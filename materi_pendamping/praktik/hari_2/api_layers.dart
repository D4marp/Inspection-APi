// Teaching skeleton. Copy into lib/api_layers.dart, keep lib/inspection.dart.
// UI login/list/form wiring is an exercise. Requires http, secure storage,
// shared_preferences. No refresh token or production offline auth policy.
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'inspection.dart';

class ApiException implements Exception {
  final int status;
  final String message;
  ApiException(this.status, this.message);
}
class ApiService {
  final http.Client client;
  final FlutterSecureStorage secure;
  final String baseUrl;
  ApiService(this.client, this.secure, this.baseUrl) {
    final uri = Uri.tryParse(baseUrl);
    if (uri == null || !['http', 'https'].contains(uri.scheme) || uri.host.isEmpty) {
      throw ArgumentError('Set API_BASE_URL to a valid http/https URL');
    }
  }
  Future<String?> readToken() => secure.read(key: 'session_token');
  Future<void> clearToken() => secure.delete(key: 'session_token');
  Map<String, dynamic> decode(http.Response response, int expected) {
    if (response.statusCode != expected) {
      String message = 'Request gagal (${response.statusCode})';
      try {
        final error = jsonDecode(response.body);
        if (error is Map && error['message'] is String) message = error['message'] as String;
      } on FormatException { /* Preserve HTTP failure even with invalid error JSON. */ }
      throw ApiException(response.statusCode, message);
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
  Future<void> login(String username, String password) async {
    final response = await client.post(Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}))
      .timeout(const Duration(seconds: 10));
    final body = decode(response, 200);
    await secure.write(key: 'session_token', value: body['token'] as String);
  }
  Future<Map<String, String>> authHeaders() async {
    final token = await readToken();
    if (token == null || token.isEmpty) throw ApiException(401, 'Silakan login');
    return {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
  }
  Future<List<Inspection>> list() async {
    final response = await client.get(Uri.parse('$baseUrl/inspections?per_page=50'),
      headers: await authHeaders()).timeout(const Duration(seconds: 10));
    final body = decode(response, 200);
    return (body['items'] as List).map((e) =>
      Inspection.fromJson(e as Map<String, dynamic>)).toList();
  }
  Future<Inspection> create(Map<String, dynamic> fields) async {
    final response = await client.post(Uri.parse('$baseUrl/inspections'),
      headers: await authHeaders(), body: jsonEncode(fields))
      .timeout(const Duration(seconds: 10));
    return Inspection.fromJson(decode(response, 201));
  }
  void close() => client.close();
}

class ListResult {
  final List<Inspection> items;
  final bool isCached;
  final DateTime fetchedAt;
  ListResult(this.items, this.isCached, this.fetchedAt);
}
class InspectionRepository {
  final ApiService api;
  final SharedPreferencesAsync prefs;
  InspectionRepository(this.api, this.prefs);
  Future<void> clearSession() async {
    await api.clearToken();
    await prefs.remove('inspection_cache');
  }
  Future<ListResult?> readCache() async {
    final raw = await prefs.getString('inspection_cache');
    if (raw == null) return null;
    try {
      final body = jsonDecode(raw) as Map<String, dynamic>;
      return ListResult((body['items'] as List).map((e) =>
        Inspection.fromJson(e as Map<String, dynamic>)).toList(), true,
        DateTime.parse(body['fetchedAt'] as String).toUtc());
    } catch (_) {
      await prefs.remove('inspection_cache');
      return null;
    }
  }
  Future<ListResult> list() async {
    List<Inspection> items;
    try { items = await api.list(); }
    on ApiException catch (e) {
      if (e.status == 401) await clearSession();
      rethrow; // Never hide an HTTP failure with cache.
    } on TimeoutException {
      final cached = await readCache();
      if (cached != null) return cached;
      rethrow;
    } on SocketException {
      final cached = await readCache();
      if (cached != null) return cached;
      rethrow;
    } on http.ClientException {
      final cached = await readCache();
      if (cached != null) return cached;
      rethrow;
    }
    final now = DateTime.now().toUtc();
    // A cache write failure must not discard a successful API result.
    try {
      await prefs.setString('inspection_cache', jsonEncode({
        'fetchedAt': now.toIso8601String(),
        'items': items.map((e) => e.toJson()).toList()}));
    } catch (_) { /* UI can show a separate persistence warning in extension. */ }
    return ListResult(items, false, now);
  }
  Future<Inspection> create(Map<String, dynamic> fields) async {
    try { return await api.create(fields); }
    on ApiException catch (e) {
      if (e.status == 401) await clearSession();
      rethrow;
    }
  }
}

class InspectionController extends ChangeNotifier {
  final InspectionRepository repository;
  final VoidCallback onSessionExpired;
  InspectionController(this.repository, this.onSessionExpired);
  List<Inspection> items = [];
  bool isLoading = false, isSubmitting = false, isCached = false;
  DateTime? fetchedAt;
  String? errorMessage;
  bool _disposed = false;
  void emit() { if (!_disposed) notifyListeners(); }
  void handle(Object error) {
    if (error is ApiException && error.status == 401) {
      items = []; isCached = false; fetchedAt = null;
      onSessionExpired();
    }
    errorMessage = error is ApiException ? error.message :
      'Koneksi atau format data bermasalah. Coba lagi.';
  }
  Future<void> load() async {
    if (isLoading || _disposed) return;
    isLoading = true; errorMessage = null; emit();
    try {
      final result = await repository.list();
      if (_disposed) return;
      items = result.items; isCached = result.isCached; fetchedAt = result.fetchedAt;
    } catch (e) { if (!_disposed) handle(e); }
    finally { isLoading = false; emit(); }
  }
  Future<Inspection?> create(Map<String, dynamic> fields) async {
    if (isSubmitting || isLoading || isCached || _disposed) return null;
    isSubmitting = true; errorMessage = null; emit();
    try {
      final item = await repository.create(fields);
      if (_disposed) return null;
      items = [item, ...items.where((e) => e.id != item.id)];
      // Refresh separately after form closes. Creation succeeded even if GET fails.
      return item;
    } catch (e) { if (!_disposed) handle(e); return null; }
    finally { isSubmitting = false; emit(); }
  }
  @override
  void dispose() { _disposed = true; super.dispose(); }
}
