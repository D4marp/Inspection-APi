# Panduan Trainer — Flutter Android DPL, 3 Hari

Paket presentasi untuk PT. Dok Pantai Lamongan. Fokus pada pengembangan aplikasi Android dengan Flutter. Pembahasan Mac/iOS hanya 20 menit pada hari ketiga; peserta tidak membutuhkan Mac untuk mengikuti praktik utama.

## Isi paket

| Presentasi | Slide | Hasil utama |
|---|---:|---|
| Hari_1_Dart_Flutter_UI_Form.pptx | 44 | Model Dart, daftar/detail, form valid, navigation dan state UI |
| Hari_2_Architecture_API_State_Storage.pptx | 39 | Clean boundaries, OpenAPI, hosted API, state, cache dan failure engineering |
| Hari_3_Testing_Performance_Release_Android.pptx | 39 | Native boundary, test strategy, DevTools, signing, release dan handover |

Total 122 slide. Format 16:9; teks, kode, tabel dan diagram teknis dapat diedit. Deck Hari 2–3 memakai tema navy–cyan–gold yang konsisten dengan cover buku. Setiap slide memiliki catatan presenter berisi tujuan, alokasi waktu, arahan penjelasan/demonstrasi, pertanyaan diskusi dan rujukan. Kunci evaluasi berada pada catatan slide evaluasi.

Folder materi_pendamping dalam ZIP memuat silabus, tiga PRD, tiga modul harian, versi Markdown yang dapat diedit, contoh kode Dart dan mock API Python dari paket materi 3 hari.

## Cara mengajar

Buka Notes/Catatan pada PowerPoint untuk membaca arahan trainer. Slide merupakan bahan penjelasan dan demonstrasi; gunakan modul untuk instruksi praktik yang lebih rinci serta PRD untuk menilai hasil. Tampilkan contoh kode sambil mengubah proyek peserta, lalu minta bukti hasil pada setiap checkpoint.

Satu proyek inspeksi peralatan dikembangkan bertahap selama tiga hari. Data dan aturan validasi tetap konsisten: kondisi good atau needs_action, kode aset/lokasi wajib, catatan temuan minimal 10 karakter setelah trim dan maksimal 500 karakter.

Peserta diasumsikan memahami dasar pemrograman dan pengalaman pengembangan Android/Kotlin. Flutter SDK, Android toolchain dan device/emulator perlu disiapkan sebelum kelas. Alokasi efektif adalah 390 menit per hari (6,5 jam): 08.30–16.30 dengan total istirahat 90 menit.

| Hari | Urutan sesi |
|---|---|
| 1 | Dart → widget/layout → state/form/navigation → debugging → review |
| 2 | Clean boundaries → OpenAPI/login/GET/POST → state/cache → failure engineering → review |
| 3 | Native boundary → test portfolio → profiling → overview iOS 20 menit → release/review |

Jika peserta tertinggal, dahulukan kriteria wajib PRD. Asset dekoratif, pagination lengkap, custom MethodChannel, upload foto permanen dan sinkronisasi offline merupakan pengembangan lanjutan. Foto dalam latihan adalah preview lokal; cache bersifat read-only dengan timestamp.

## Persiapan demonstrasi

1. Catat versi Flutter/Dart/JDK/Android SDK dan dependency yang benar-benar dipakai; simpan pubspec.lock untuk konsistensi.
2. Verifikasi hosted Express API, Swagger UI/OpenAPI, image tag Docker, dan endpoint health dari device kelas. Jalankan mock Python sebagai fallback dengan kontrak yang sama.
3. Siapkan skenario login salah, 401, 409, 422, 500, timeout, cache rusak dan logout; gunakan request ID tanpa merekam token.
4. Gunakan physical Android untuk profiling dan pemeriksaan kamera. Siapkan fallback demonstrasi jika hardware peserta berbeda.
5. Siapkan keystore latihan dan staging HTTPS sebelum sesi rilis. Isi placeholder host/path/password di mesin latihan; gunakan identifier yang bebas dari aplikasi operasional.
6. Lakukan dry-run contoh kode dan alur kelas pada toolchain peserta. Contoh pada slide adalah potongan terarah; imports, helper, field State, wiring UI dan konfigurasi lengkap mengikuti modul/source latihan.

Perintah panjang pada beberapa slide ditampilkan dalam dua baris agar mudah dibaca. Gabungkan menjadi satu command saat menjalankannya, seperti dijelaskan pada catatan presenter.

## Praktik engineering yang dilatih

Pemisahan tanggung jawab UI/controller/repository/service, model bertipe, dependency melalui constructor, penanganan error yang dapat diuji, lifecycle resource, token melalui secure storage, test perilaku, pengukuran performance, checkpoint Git serta verifikasi signer dan smoke test release. Materi ini menggunakan praktik engineering umum; tidak mengklaim sertifikasi atau kesesuaian terhadap satu standar formal tertentu.

## Pemeriksaan paket dan batas verifikasi

Struktur PPTX, ukuran slide, font, tabel native dan catatan presenter diperiksa. Seluruh slide Hari 2–3 dirender ke PDF dan ditinjau melalui contact sheet. Source generator berada di `tools/build_professional_decks.py` agar perubahan berikutnya konsisten.

Build, test dan smoke test yang disebut dalam materi tetap merupakan aktivitas kelas pada toolchain trainer/peserta. Paket presentasi belum diuji melalui Google Slides secara langsung. Periksa tampilan di komputer trainer sebelum kelas; font yang dipakai adalah Aptos/Aptos Display serta Cascadia Mono dengan fallback dari aplikasi presentasi.
