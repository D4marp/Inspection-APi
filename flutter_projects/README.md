# Flutter Projects — Paket Training DPL 3 Hari

Direktori ini berisi tiga proyek Flutter mandiri. Setiap folder dapat dibuka,
diuji, dan dipush sebagai repository GitHub terpisah.

## Versi standar

```text
Flutter 3.44.8 stable (revision 058e0af2c2)
Dart 3.12.2
DevTools 2.57.0
Xcode 26.5
Simulator iPhone 16 / iOS 18.0
```

Setiap proyek mempunyai `.fvmrc` berisi Flutter 3.44.8 dan `pubspec.lock`.

## Proyek

| Folder | Android / iOS application ID | Fokus |
|---|---|---|
| `hari_1_dpl_inspection` | `id.co.dokpantailamongan.dpl_inspection_day_1` / `id.co.dokpantailamongan.dplInspectionDay1` | UI, form, navigation, local state |
| `hari_2_dpl_inspection_api` | `id.co.dokpantailamongan.dpl_inspection_day_2` / `id.co.dokpantailamongan.dplInspectionDay2` | JSONPlaceholder CRUD, mapper, picker, OpenCode |
| `hari_3_dpl_inspection_release` | `id.co.dokpantailamongan.dpl_inspection_day_3` / `id.co.dokpantailamongan.dplInspectionDay3` | PRD migrasi Kotlin, WebView, Agent Skill |

Proyek dibuat dengan pola berikut:

```sh
flutter create --platforms=android,ios \
  --org id.co.dokpantailamongan \
  --project-name NAMA_PACKAGE \
  NAMA_FOLDER
```

## Quality gate terverifikasi

Quality gate setiap proyek:

- lulus `dart format --output=none --set-exit-if-changed lib test`;
- lulus `flutter analyze` tanpa issue;
- lulus seluruh `flutter test`;
- mempunyai instruksi build/smoke test pada README masing-masing;
- menyimpan credential dan signing key di luar repository.

Ikuti README di dalam setiap proyek untuk setup API, OpenCode, WebView/Agent
Skill, dan langkah verifikasi. Jangan commit credential, token, signing key,
atau data operasional.
