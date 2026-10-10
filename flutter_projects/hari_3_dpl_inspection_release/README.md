# DPL Inspection — Hari 3

Proyek Flutter mandiri hasil `flutter create` untuk praktik plugin foto,
lifecycle, lost-data recovery, testing, profiling, dan build release. Foto hanya
preview lokal sementara; belum di-upload atau dipersist sebagai data bisnis.

## Toolchain

- Flutter 3.44.8 stable; Dart 3.12.2
- Xcode 26.5
- Simulator uji: iPhone 16, iOS 18.0
- `image_picker` dan dependency lain dikunci di `pubspec.lock`

## Menjalankan dan menguji

```sh
fvm flutter pub get
fvm flutter analyze
fvm flutter test
fvm flutter run -d "iPhone 16"
```

Simulator tidak selalu menyediakan kamera; tombol Galeri tetap dapat diuji.
Gunakan perangkat fisik untuk acceptance kamera. Mode khusus dokumentasi membuka
detail/foto langsung:

```sh
fvm flutter run -d "iPhone 16" --dart-define=SCREENSHOT_MODE=true
```

Build verifikasi:

```sh
flutter build ios --simulator
flutter build apk --debug
```

Untuk release Android production, siapkan keystore di luar repository dan
gunakan HTTPS. Jangan pernah commit password/keystore.

## Repository GitHub mandiri

```sh
git init
git add .
git commit -m "Complete Flutter day 3 photo testing and release"
git branch -M main
git remote add origin https://github.com/USERNAME/dpl-inspection-day-3.git
git push -u origin main
```
