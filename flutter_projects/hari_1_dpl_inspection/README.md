# DPL Inspection — Hari 1

Proyek Flutter lengkap untuk praktik UI, form, validasi, navigation, local state,
loading, empty state, error/retry, dan responsive layout.

## Toolchain yang dikunci

- Flutter 3.44.8 stable
- Dart 3.12.2
- Xcode 26.5
- Simulator uji: iPhone 16, iOS 18.0

Jika memakai FVM:

```sh
fvm install 3.44.8
fvm flutter pub get
fvm flutter run -d "iPhone 16"
```

Tanpa FVM, pastikan `flutter --version` menunjukkan 3.44.8 lalu jalankan:

```sh
flutter pub get
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter run -d "iPhone 16"
```

## Asset gambar dengan FlutterGen

Gambar lokal disimpan di `assets/images/` dan diakses melalui class yang
dibuat FlutterGen, bukan dengan string path:

```dart
Assets.images.pumpInspection.image(fit: BoxFit.cover)
```

Setelah menambah atau mengganti asset, jalankan generator:

```sh
fvm flutter pub get
fvm dart run build_runner build
```

Tanpa FVM, ganti `fvm flutter` dan `fvm dart` dengan `flutter` dan `dart`.

## Repository GitHub mandiri

Folder ini tidak menyimpan credential. File generated, lockfile, Android, dan
iOS sengaja disertakan agar clone baru dapat langsung dijalankan.

```sh
git init
git add .
git commit -m "Complete Flutter day 1 UI and form"
git branch -M main
git remote add origin https://github.com/USERNAME/dpl-inspection-day-1.git
git push -u origin main
```

Jangan commit signing key, file `.env`, token, atau data operasional.
