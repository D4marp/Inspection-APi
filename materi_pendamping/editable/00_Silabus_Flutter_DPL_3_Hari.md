# Silabus Flutter Android 3 Hari
**PT. Dok Pantai Lamongan | Fokus Flutter untuk Android | Onsite**

**Trainer dan Pembuat Buku: Damar Galih Aji Pradana, S.Tr.Kom.**

Program ini memadatkan silabus awal menjadi 3 hari efektif untuk tim developer yang sudah mengenal Kotlin. Fokus praktik adalah menyelesaikan aplikasi latihan pada iPhone 16 Simulator, mengintegrasikan REST API, kemudian menyiapkan build. Semua proyek tetap menghasilkan platform Android+iOS. Rancangan ini mengasumsikan instalasi lingkungan pengembangan selesai sebelum hari pertama.

## Hasil akhir yang dituju
- Peserta dapat membuat UI, navigasi, form, dan state sederhana dengan Flutter.
- Peserta dapat memisahkan UI, controller, repository, dan service serta menangani API dan session.
- Peserta dapat menambahkan satu native feature, menguji aplikasi, dan melakukan build release Android.
- Peserta dapat menjalankan dan membuktikan aplikasi pada iPhone 16 Simulator serta memahami signing/distribusi sebagai tahap lanjutan. Archive, IPA, TestFlight, dan upload Google Play bukan target wajib kelas.

## Struktur 3 hari
| Hari | Fokus dan praktik | Hasil yang diperiksa |
|---|---|---|
| 1 | Adaptasi Kotlin ke Dart, widget, layout, form, navigasi, local state | Prototipe daftar inspeksi, detail, dan form dengan data lokal |
| 2 | Architecture, REST API, token, ChangeNotifier, cache sederhana | Login demo, GET/POST, loading/error/retry, session dan cache |
| 3 | Foto Android, testing, DevTools, perbaikan Flutter, Android release | Lampiran foto lokal, smoke test, APK/AAB, dan catatan release |

**Durasi:** 08.30-16.30 WIB per hari; 6,5 jam belajar efektif dan 1,5 jam istirahat. Total 19,5 jam efektif. Jadwal dapat dipisah sesuai operasional DPL, dengan urutan hari tetap 1-2-3.

**Metode:** penjelasan ringkas, demonstrasi trainer, praktik berpasangan, dan pemeriksaan hasil. Sekitar dua pertiga waktu diarahkan pada praktik dan review. Peserta memakai checkpoint Git agar setiap hari dapat dilanjutkan tanpa mengulang pekerjaan.

## Proyek latihan
**DPL Inspection Training** adalah contoh aplikasi pencatatan inspeksi peralatan, bukan spesifikasi proses bisnis resmi DPL. Seluruh nama aset, pengguna, dan temuan menggunakan data dummy. Satu pengguna dapat melihat daftar inspeksi, membuat catatan, lalu melampirkan foto lokal. Proyek dapat diganti dengan kasus DPL yang mempunyai API siap pakai tanpa menambah scope.

<!-- PAGE -->
## Jadwal hari 1
| Waktu | Materi | Aktivitas dan checkpoint |
|---|---|---|
| 08.30-10.00 | Flutter workflow, Dart untuk Kotlin, null safety, Future | Doctor, run awal, model Inspection dan data dummy |
| 10.00-10.15 | Istirahat | 15 menit |
| 10.15-12.00 | Widget, layout, theme, list dan responsive UI | Daftar dan detail; layar sempit tanpa overflow |
| 12.00-13.00 | Istirahat | 60 menit |
| 13.00-14.30 | Form, validation, navigation dan setState | Form tambah inspeksi dan hasil kembali ke daftar |
| 14.30-14.45 | Istirahat | 15 menit |
| 14.45-16.00 | Reusable widget, inspector dan debugging UI | Perbaiki layout, lifecycle controller dan state |
| 16.00-16.30 | Review PRD hari 1 dan Git checkpoint | Demo alur daftar-detail-form; tag day-1 |

## Jadwal hari 2
| Waktu | Materi | Aktivitas dan checkpoint |
|---|---|---|
| 08.30-10.00 | Architecture, clean boundaries, model, repository, async | Refactor prototipe dan verifikasi health API |
| 10.00-10.15 | Istirahat | 15 menit |
| 10.15-12.00 | Swagger/OpenAPI, login, token, GET/POST, error mapping | Validasi kontrak, ambil dan tambah inspeksi |
| 12.00-13.00 | Istirahat | 60 menit |
| 13.00-14.30 | ChangeNotifier, storage, session, cache | Loading/success/empty/error, restart dan logout |
| 14.30-14.45 | Istirahat | 15 menit |
| 14.45-16.00 | Search/filter, timeout, 401, API debugging | Uji kegagalan dan cache; pagination sebagai demo |
| 16.00-16.30 | Review PRD hari 2 dan Git checkpoint | Demo API, bukti pengujian; tag day-2 |

## Jadwal hari 3
| Waktu | Materi | Aktivitas dan checkpoint |
|---|---|---|
| 08.30-10.00 | Plugin foto Android, lifecycle dan native configuration | Pilih/ambil foto, cancel, error, lost data; plugin vs MethodChannel |
| 10.00-10.15 | Istirahat | 15 menit |
| 10.15-12.00 | Flutter testing, inspector, DevTools dan performance | Unit/widget test, profiling singkat, perbaiki rebuild/list |
| 12.00-13.00 | Istirahat | 60 menit |
| 13.00-14.10 | Penyempurnaan proyek Flutter | Responsive UI, validasi, retry, cache dan alur end-to-end |
| 14.10-14.30 | Toolchain dan konfigurasi iOS | Izin plugin, simulator, perbedaan signing perangkat |
| 14.30-14.45 | Istirahat | 15 menit |
| 14.45-16.00 | Android configuration, signing dan release | Build APK/AAB, verifikasi signer dan smoke test |
| 16.00-16.30 | Demo akhir dan handover | Review acceptance, release notes dan tag day-3 |

## Cara mengajar program intensif
Trainer menjelaskan satu konsep, mendemonstrasikan satu perubahan kecil, kemudian peserta menerapkannya sendiri. Pada setiap sesi, gunakan checkpoint yang terlihat: layar bekerja, data server diterima, atau satu skenario uji lulus. Hindari kuliah panjang yang menghabiskan waktu implementasi.

Praktik berpasangan memakai peran penulis kode dan reviewer yang ditukar tiap sesi. Reviewer mengecek alur data, error state, serta acceptance. Trainer memeriksa hasil sebelum menambah scope agar peserta tidak membawa bug hari pertama sampai sesi release.

## Jika peserta tertinggal
Gunakan starter untuk memulihkan checkpoint, kemudian minta peserta menjelaskan perubahan yang dilakukan. Pertahankan alur inti daftar-detail-form-API. Kurangi pengayaan animasi, pagination, MethodChannel dan upload store sebelum mengurangi waktu form, state, error handling atau testing.

## Review akhir 3 hari
Demo mengikuti alur pengguna: login, list, detail, create invalid/valid, retry/cache, foto, dan logout pada iPhone 16 Simulator. Peserta menunjukkan test serta build simulator dan menjelaskan satu perbaikan. Hasil akhir mencakup source Android+iOS, bukti acceptance, screenshot, dan langkah menjalankan proyek.

<!-- PAGE -->
## Penyesuaian seluruh topik silabus awal
| Topik awal | Penempatan dalam 3 hari | Kedalaman |
|---|---|---|
| Flutter dan Dart | Hari 1 pagi | Praktik inti; dasar programming diringkas |
| UI development | Hari 1 | List, form, layout dan theme praktik; animasi pengayaan |
| Navigation dan state | Hari 1-2 | Navigator, setState dan satu ChangeNotifier |
| Architecture dan clean code | Hari 2 | Model-service-repository-controller sederhana |
| REST API dan backend | Hari 2 | Login, GET, POST, JSON dan error praktik |
| Local storage | Hari 2 | Token dan cache read-only; database demo konsep |
| Xcode dan iOS development | Hari 3 overview | Pengenalan 20 menit; tidak menjadi target praktik |
| Android build | Hari 3 | APK, AAB dan release signing |
| iOS deployment | Hari 3 overview | Alur distribusi dikenalkan; praktik ditunda |
| Native integration | Hari 3 | Satu fitur foto; MethodChannel demonstrasi |
| Debugging | Terintegrasi tiap hari | UI, API, dependency, build dan signing |
| Performance | Hari 3 | Satu profiling singkat; optimasi list/rebuild |
| Git dan team development | Penutupan tiap hari | Commit, checkpoint, review singkat |
| Project case client | Berlanjut hari 1-3 | Satu proyek, scope terbatas dan data dummy |

## Materi pengayaan setelah training
- PUT/DELETE, upload multipart dan pagination penuh dapat diterapkan setelah GET/POST stabil.
- Animasi kompleks, database lokal dengan migrasi, antrean sinkronisasi offline, dan conflict resolution memerlukan sesi lanjutan.
- Camera/location/file/notification tidak semuanya dikerjakan; fitur foto menjadi praktik native wajib.
- Clean architecture lengkap, state management kedua, CI/CD, flavor kompleks, dan performance mendalam tidak menjadi syarat lulus program ini.
- Google Play dibahas melalui checklist distribusi internal. Xcode, certificate/provisioning, archive/IPA, TestFlight dan App Store menjadi materi lanjutan terpisah. Persetujuan store dan review eksternal bukan target selesai selama kelas.

## Ketentuan penilaian
Setiap PRD mempunyai acceptance criteria yang dapat diuji. Trainer mencatat **Lulus**, **Perlu perbaikan**, atau **Terhalang prasyarat**, disertai bukti dan penanggung jawab. Hari 1 dan 2 harus memenuhi semua kriteria inti sebelum lanjut. Untuk hari 3, hasil Flutter dan build iOS Simulator wajib diperiksa; build store dicatat terpisah sesuai kesiapan akun/signing.

<!-- PAGE -->
## Persiapan sebelum pelaksanaan
**H-3 sampai H-1:** trainer dan PIC developer melakukan pemeriksaan bersama. Instalasi toolchain bukan alokasi utama dari 19,5 jam belajar efektif.

| Kebutuhan | Pemeriksaan | Penanggung jawab yang disarankan |
|---|---|---|
| Flutter, Dart dan IDE | flutter doctor -v; catat versi; jalankan app template | Peserta dibantu trainer |
| iOS toolchain | Mac, Xcode, iPhone 16 Simulator iOS 18.0 | Trainer/Peserta |
| Android toolchain | Opsional untuk build lanjutan APK/AAB; tidak menjalankan emulator bersamaan | Trainer |
| Google Play opsional | Akses akun, app record dan peran upload jika praktik distribusi | Pemilik akun DPL |
| Signing Android | Keystore demo, alias dan password; bukan key produksi | Trainer dan PIC |
| Backend | Hosted Express API + Swagger/OpenAPI + image Docker; mock paket sebagai fallback; firewall dan route diuji | Trainer dan PIC backend |
| Data | Akun dan data dummy; tidak memakai data operasional sensitif | Trainer |
| Paket | Versi stabil kompatibel dipilih; pubspec.lock disimpan | Trainer |
| Jaringan | Package download, API, dan store dapat diakses | PIC IT |

**Mac/Xcode menjadi prasyarat untuk alur simulator paket ini.** Seluruh acceptance UI memakai iPhone 16 Simulator agar hanya satu emulator yang aktif. Jika signing/store belum siap, build distribusi ditandai tertunda dengan PIC serta langkah lanjut; source Android+iOS tetap tersedia di setiap proyek.

## Daftar dokumen dan file praktik
- Silabus ini mengatur waktu, kedalaman materi, dan prasyarat program.
- PRD Hari 1: persyaratan prototipe UI dan form.
- PRD Hari 2: persyaratan integrasi API, session, state dan cache.
- PRD Hari 3: persyaratan foto Android, Flutter testing/performance, build dan distribusi Android.
- Materi Hari 1, 2 dan 3: penjelasan, langkah praktik, contoh, troubleshooting, dan evaluasi.
- Folder praktik: starter UI hari 1, contoh layer API, widget foto, mock API Python dan README penggunaan. Contoh layer API/foto perlu dirangkai oleh peserta; bukan aplikasi production lengkap.

## Dasar penyusunan
Scope mengacu pada dua dokumen yang diberikan pengguna: silabus Flutter Multiplatform PT. Dok Pantai Lamongan dan penawaran training 5 hari. Jadwal 3 hari, aplikasi inspeksi, durasi harian dan pembagian kedalaman merupakan rancangan baru untuk memenuhi perubahan durasi.

Dokumen ini tidak menetapkan ulang harga atau syarat pembayaran penawaran. Perubahan komersial dapat dibuat terpisah setelah nilai jasa 3 hari ditentukan.

Referensi teknis resmi yang digunakan dalam modul: docs.flutter.dev, dart.dev, developer.android.com dan halaman publisher paket di pub.dev. Diperiksa 03 Oktober 2026; versi SDK dan paket aktual tetap dicatat sebelum kelas. Build Android belum dijalankan dalam lingkungan penyusunan dokumen ini.
