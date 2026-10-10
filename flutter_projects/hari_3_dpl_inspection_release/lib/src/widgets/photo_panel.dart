import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotoPanel extends StatefulWidget {
  const PhotoPanel({super.key, required this.inspectionId});
  final String inspectionId;

  @override
  State<PhotoPanel> createState() => _PhotoPanelState();
}

class _PhotoPanelState extends State<PhotoPanel> {
  final _picker = ImagePicker();
  final _preferences = SharedPreferencesAsync();
  XFile? _photo;
  bool _busy = false;
  String? _message;

  static const _pendingKey = 'pending_photo_inspection';

  @override
  void initState() {
    super.initState();
    _recoverLostData();
  }

  Future<void> _recoverLostData() async {
    try {
      if (await _preferences.getString(_pendingKey) != widget.inspectionId) {
        return;
      }
      final result = await _picker.retrieveLostData();
      if (!mounted) return;
      setState(() {
        if (result.files?.isNotEmpty == true) {
          _photo = result.files!.first;
        } else if (result.exception != null) {
          _message = 'Foto gagal dipulihkan. Pilih ulang.';
        }
      });
      await _preferences.remove(_pendingKey);
    } on Object {
      if (mounted) {
        setState(() => _message = 'Pemulihan foto gagal. Pilih ulang.');
      }
    }
  }

  Future<void> _pick(ImageSource source) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      await _preferences.setString(_pendingKey, widget.inspectionId);
      final selected = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 80,
      );
      if (!mounted) return;
      setState(() {
        _photo = selected;
        if (selected == null) _message = 'Pemilihan foto dibatalkan.';
      });
    } on PlatformException {
      if (mounted) {
        setState(
          () => _message = 'Foto tidak dapat diakses. Periksa izin perangkat.',
        );
      }
    } on Object {
      if (mounted) setState(() => _message = 'Foto gagal dipilih. Coba lagi.');
    } finally {
      await _preferences.remove(_pendingKey);
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.add_a_photo_outlined, color: colors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Lampiran foto',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Preview tersimpan sementara pada sesi aplikasi dan belum di-upload.',
            ),
            const SizedBox(height: 16),
            if (_photo != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(_photo!.path),
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox(
                    height: 120,
                    child: Center(child: Text('File foto tidak tersedia.')),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: _busy ? null : () => _pick(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Galeri'),
                ),
                OutlinedButton.icon(
                  onPressed: _busy ? null : () => _pick(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('Kamera'),
                ),
                if (_photo != null)
                  TextButton.icon(
                    onPressed: _busy
                        ? null
                        : () => setState(() => _photo = null),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Hapus'),
                  ),
              ],
            ),
            if (_busy) ...[
              const SizedBox(height: 10),
              const LinearProgressIndicator(),
            ],
            if (_message != null) ...[
              const SizedBox(height: 10),
              Text(_message!, style: TextStyle(color: colors.onSurfaceVariant)),
            ],
          ],
        ),
      ),
    );
  }
}
