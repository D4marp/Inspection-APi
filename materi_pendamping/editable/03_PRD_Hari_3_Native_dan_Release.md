# PRD Hari 3 Flutter dan Release Android
**Product Requirements Document | DPL Inspection Training | Versi latihan 0.3**

**Trainer dan Pembuat Buku: Damar Galih Aji Pradana, S.Tr.Kom.**

## Tujuan dan perubahan fokus
Menyempurnakan aplikasi Flutter dengan fitur foto, pengujian, pemeriksaan performance, dan build iOS Simulator. Praktik utama memakai iPhone 16 Simulator; kamera diterima pada perangkat fisik. Source Android tetap tersedia untuk build APK/AAB lanjutan.

Foto dipasang pada detail inspeksi sebagai preview lokal. Foto tidak di-upload ke API dan tidak dijamin bertahan setelah restart. Latihan memakai data dummy dan identitas app latihan, bukan rilis aplikasi operasional DPL.

**Pengguna:** petugas inspeksi simulasi. **Reviewer:** trainer dan PIC developer. **Pemilik akun/key:** PIC yang ditunjuk. **Input:** checkpoint day-2 dengan API, session dan cache yang berfungsi.

## Kebutuhan fungsional dan kualitas
| ID | Persyaratan wajib | Hasil yang dapat diperiksa |
|---|---|---|
| D3-01 | Foto Android | Pilih galeri/kamera; preview pada detail record aktif |
| D3-02 | Lifecycle picker | Cancel/error tidak crash; jalur retrieveLostData ditangani |
| D3-03 | Flutter tests | Unit test model/validator dan widget test form/state |
| D3-04 | Performance review | Satu pengukuran profile; satu perbaikan yang dijelaskan |
| D3-05 | Polishing Flutter | UI sempit, keyboard, empty/error/retry, submit guard dan cache label |
| D3-06 | Android release | ID latihan, versi, signing latihan, APK dan AAB |
| D3-07 | Release smoke test | Login, list, create, cache, logout dan foto di device |
| D3-08 | Handover | Source, README, hasil test, log build dan release checklist |

**Bersyarat:** upload ke Google Play Internal Testing jika akun serta hak akses siap. **Overview:** Flutter memakai kode Dart bersama, tetapi iOS membutuhkan Mac/Xcode dan konfigurasi native/signing tersendiri. Tidak ada target archive, IPA, TestFlight, atau App Store pada kelas ini.

## User stories
- Petugas ingin preview foto pada inspeksi yang tepat, termasuk saat membatalkan picker.
- Developer ingin membuktikan bahwa validation dan state UI bekerja melalui test.
- Developer ingin menemukan masalah UI/rebuild melalui DevTools dan memperbaikinya.
- PIC ingin mendapatkan build Android dengan versi, environment dan signer yang diketahui.

<!-- PAGE -->
## Aturan foto dan Flutter
- Gunakan image_picker dengan XFile; tombol pick dinonaktifkan selama proses.
- Lampiran hanya terikat pada record aktif. Simpan id record ketika memulai picker agar pemulihan lost data tidak menempel pada record yang salah.
- Kamera dapat memerlukan physical device. Batal picker menghasilkan null; jangan menganggapnya sebagai exception.
- Setelah async selesai, periksa mounted sebelum menyentuh UI; controller mempunyai lifecycle jelas.
- File sementara tidak digunakan sebagai bukti inspeksi permanen. Penyimpanan permanen, compression policy dan multipart upload menjadi pengayaan.

## Identitas dan artefak Android
| Komponen | Contoh latihan | Bukti |
|---|---|---|
| Application ID | com.example.dplinspection.training | Ganti menjadi ID milik akun bila upload |
| Version | 0.3.0+3 | Version name dan version code |
| API environment | Staging HTTPS | Host dan label environment; data dummy |
| APK release | app-release.apk | Terpasang di device; fingerprint signer |
| AAB release | app.aab | Build sukses; verifikasi signature |
| Source | Tag day-3 | Commit hash, pubspec.lock dan README |

## Pengujian minimum
Unit test membuktikan parsing JSON serta aturan catatan untuk needs_action. Widget test membuktikan field wajib ditolak dan pesan error/retry dapat muncul. Smoke test dijalankan pada release Android terhadap API staging HTTPS yang disiapkan PIC. Mock HTTP hanya untuk debug lab; jangan membuka cleartext secara global pada release agar smoke test tampak berhasil.

**Performance:** ukur dalam mode profile pada device yang sama. Catat skenario scroll/rebuild, gejala awal, perbaikan, dan hasil setelahnya. Target kelas adalah menemukan serta menjelaskan satu perbaikan; tidak menetapkan angka FPS universal tanpa kondisi pengukuran.

## Prasyarat
Flutter 3.44.8, Xcode 26.5, iPhone 16 Simulator iOS 18.0, serta API training/staging HTTPS tersedia dan sudah diverifikasi trainer/PIC. Peserta menerima base URL dan kontrak response; implementasi/deployment backend bukan bagian sesi. Mock Python tetap menjadi fallback debug dengan kontrak sama. Signing store bersifat opsional. Jika staging belum tersedia, catat smoke test API release sebagai blocker; build simulator dan fungsi non-network tetap dapat diperiksa.

<!-- PAGE -->
## Acceptance criteria hari 3
| ID | Skenario | Kriteria lulus |
|---|---|---|
| AC1 | Foto dan detail record lain | Preview hanya milik record yang dipilih |
| AC2 | Cancel, denied/error dan lost data | App tetap berjalan; hasil dipulihkan atau pesan jelas |
| AC3 | Unit/widget tests | Test aturan data dan interaksi UI lulus |
| AC4 | Profile satu skenario | Bukti sebelum/sesudah; perbaikan dijelaskan |
| AC5 | Layar sempit dan keyboard | Field/tombol terjangkau tanpa overflow |
| AC6 | APK/AAB release | File tersedia dan signature latihan terverifikasi |
| AC7 | Smoke test release | Alur utama bekerja; jika API staging tidak siap, blocker dicatat |
| AC8 | Handover | Source, versi, host, hasil test dan catatan release lengkap |

## Definition of done
Semua persyaratan inti dipenuhi dan acceptance diuji. APK dapat dipasang di device Android. AAB ditandatangani dengan key latihan. Trainer mencatat hasil network release sesuai kesiapan staging; blocker tidak dianggap sebagai test yang lulus. Upload Play dicatat terpisah dari kelulusan implementasi Flutter.

## Paket handover peserta
- Tag day-3 dan commit hash dengan README langkah menjalankan aplikasi.
- Hasil flutter analyze, flutter test, dan log build Android.
- Checklist smoke test, screenshot foto, dan catatan satu perbaikan performance.
- Release notes berisi fitur, versi, host API, batas cache/foto, serta masalah yang diketahui.
- Daftar blocker dengan PIC dan langkah berikutnya; key/password/token tidak disertakan.

## Batas scope 3 hari
Tidak mencakup offline write queue, backend production, upload foto ke server, GPS/notification, state management kedua, CI/CD, archive IPA, TestFlight, atau App Store. Penguasaan Flutter dibangun lewat alur yang selesai dan teruji, bukan menambahkan sebanyak mungkin package.
