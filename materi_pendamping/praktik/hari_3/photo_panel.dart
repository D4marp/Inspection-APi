// Android teaching widget. Copy to lib/photo_panel.dart.
// Attach to detail using PhotoPanel(key: ValueKey(item.id), inspectionId: item.id).
// Requires image_picker and shared_preferences. File is temporary, no API upload.
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotoPanel extends StatefulWidget {
  final String inspectionId;
  const PhotoPanel({super.key, required this.inspectionId});
  @override
  State<PhotoPanel> createState() => _PhotoPanelState();
}
class _PhotoPanelState extends State<PhotoPanel> {
  final picker = ImagePicker();
  final prefs = SharedPreferencesAsync();
  XFile? photo;
  bool busy = false;
  String? message;
  @override
  void initState() { super.initState(); recover(); }
  Future<void> recover() async {
    try {
      final pending = await prefs.getString('pending_photo_inspection');
      if (pending != widget.inspectionId) return;
      final result = await picker.retrieveLostData();
      if (!mounted) return;
      if (result.files?.isNotEmpty == true) {
        setState(() => photo = result.files!.first);
      } else if (result.exception != null) {
        setState(() => message = 'Foto gagal dipulihkan. Pilih ulang.');
      }
      await prefs.remove('pending_photo_inspection');
    } catch (_) {
      if (mounted) setState(() => message = 'Pemulihan foto gagal. Pilih ulang.');
    }
  }
  Future<void> pick(ImageSource source) async {
    if (busy) return;
    setState(() { busy = true; message = null; });
    try {
      await prefs.setString('pending_photo_inspection', widget.inspectionId);
      final result = await picker.pickImage(source: source, maxWidth: 1600, imageQuality: 80);
      if (!mounted) return;
      if (result != null) setState(() => photo = result);
      await prefs.remove('pending_photo_inspection');
    } on PlatformException {
      if (mounted) setState(() => message = 'Foto tidak dapat diakses. Periksa izin/perangkat.');
      await prefs.remove('pending_photo_inspection');
    } catch (_) {
      if (mounted) setState(() => message = 'Foto gagal dipilih. Coba lagi.');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Lampiran foto lokal sementara'),
      Wrap(spacing: 8, children: [
        FilledButton(onPressed: busy ? null : () => pick(ImageSource.gallery),
          child: const Text('Galeri')),
        OutlinedButton(onPressed: busy ? null : () => pick(ImageSource.camera),
          child: const Text('Kamera'))]),
      if (busy) const LinearProgressIndicator(),
      if (message != null) Text(message!),
      if (photo != null) Image.file(File(photo!.path), height: 200, fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Text('File foto tidak tersedia. Pilih ulang.')),
      if (photo != null) TextButton(onPressed: busy ? null : () => setState(() => photo = null),
        child: const Text('Hapus foto')),
    ]);
}
