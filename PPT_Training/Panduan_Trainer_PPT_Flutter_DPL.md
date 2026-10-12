# Panduan Trainer — Flutter Android DPL, 3 Hari

Paket presentasi untuk PT. Dok Pantai Lamongan. Fokus pada pengembangan aplikasi Android dengan Flutter. Pembahasan Mac/iOS hanya 20 menit pada hari ketiga; peserta tidak membutuhkan Mac untuk mengikuti praktik utama.

## Isi paket

| Presentasi | Slide | Hasil utama |
|---|---:|---|
| Hari_1_Dart_Flutter_UI_Form.pptx | 44 | Model Dart, daftar/detail, form valid, navigation dan state UI |
| Hari_2_Architecture_API_State_Storage.pptx | 39 | Scaffold/Form, JSONPlaceholder CRUD, mapper, picker, OpenCode |
| Hari_3_Testing_Performance_Release_Android.pptx | 39 | PRD migrasi Kotlin, WebView security, Agent Skill, test/build evidence |

Total 122 slide. Format 16:9; teks, kode, tabel dan diagram teknis dapat diedit. Deck Hari 2–3 memakai tema navy–cyan–gold yang konsisten dengan cover buku. Setiap slide memiliki catatan presenter berisi tujuan, alokasi waktu, arahan penjelasan/demonstrasi, pertanyaan diskusi dan rujukan. Kunci evaluasi berada pada catatan slide evaluasi.

Folder materi_pendamping dalam ZIP memuat silabus, tiga PRD, tiga modul harian, versi Markdown yang dapat diedit, contoh kode Dart dan mock API Python dari paket materi 3 hari.

## Cara mengajar

Buka Notes/Catatan pada PowerPoint untuk membaca arahan trainer. Slide merupakan bahan penjelasan dan demonstrasi; gunakan modul untuk instruksi praktik yang lebih rinci serta PRD untuk menilai hasil. Tampilkan contoh kode sambil mengubah proyek peserta, lalu minta bukti hasil pada setiap checkpoint.

Satu proyek inspeksi peralatan dikembangkan bertahap selama tiga hari. Data dan aturan validasi tetap konsisten: kondisi good atau needs_action, kode aset/lokasi wajib, catatan temuan minimal 10 karakter setelah trim dan maksimal 500 karakter.

Peserta diasumsikan memahami dasar pemrograman dan pengalaman pengembangan Android/Kotlin. Flutter SDK, Android toolchain dan device/emulator perlu disiapkan sebelum kelas. Alokasi efektif adalah 390 menit per hari (6,5 jam): 08.30–16.30 dengan total istirahat 90 menit.

| Hari | Urutan sesi |
|---|---|
| 1 | Dart → widget/layout → state/form/navigation → debugging → review |
| 2 | UI composition → 4 file CRUD + mapper → picker → OpenCode/API key → challenge |
| 3 | Legacy inventory → PRD slice → Agent Skill → WebView modular → migration lab → handover |

Jika peserta tertinggal, dahulukan kriteria wajib PRD. Asset dekoratif, pagination lengkap, custom MethodChannel, upload foto permanen dan sinkronisasi offline merupakan pengembangan lanjutan. Foto dalam latihan adalah preview lokal; cache bersifat read-only dengan timestamp.

## Persiapan demonstrasi

1. Catat versi Flutter/Dart/JDK/Android SDK dan dependency yang benar-benar dipakai; simpan pubspec.lock untuk konsistensi.
2. Sebelum Hari 2, verifikasi koneksi HTTPS dan empat method JSONPlaceholder; jelaskan bahwa write tidak persisten.
3. Siapkan OpenCode 1 stable dan provider masing-masing peserta. Jangan tampilkan atau membagikan API key.
4. Sebelum Hari 3, sanitasi source Kotlin/XML dan contract yang menjadi context pack.
5. Smoke-test WebView asset lokal, external-navigation block, serta Agent Skill discovery.
6. Lakukan dry-run challenge dan quality gate pada toolchain peserta.

Saat membahas CRUD, buka hanya satu operation file dan satu test pada setiap
checkpoint: Read, Create, Update, lalu Delete. `ApiClient` baru dibuka setelah
empat operasi selesai untuk menunjukkan facade. Pada WebView, mulai dari pure
navigation policy, lanjut controller, lalu screen.

Perintah panjang pada beberapa slide ditampilkan dalam dua baris agar mudah dibaca. Gabungkan menjadi satu command saat menjalankannya, seperti dijelaskan pada catatan presenter.

## Praktik engineering yang dilatih

Pemisahan UI/controller/repository/service, full CRUD semantics, picker lifecycle,
secret boundary, PRD traceability, migration per vertical slice, WebView allowlist,
Agent Skill, test perilaku, checkpoint Git, build, dan handover.

## Pemeriksaan paket dan batas verifikasi

Struktur PPTX, ukuran slide, font, tabel native dan catatan presenter diperiksa.
Seluruh slide Hari 2–3 dirender ke PDF dan ditinjau melalui contact sheet. Source
generator berada di `tools/build_day2_crud_ai_picker_deck.py` dan
`tools/build_day3_ai_webview_deck.py`; keduanya memakai komponen visual dari
`tools/build_professional_decks.py` agar perubahan berikutnya konsisten.

Build, test dan smoke test yang disebut dalam materi tetap merupakan aktivitas kelas pada toolchain trainer/peserta. Paket presentasi belum diuji melalui Google Slides secara langsung. Periksa tampilan di komputer trainer sebelum kelas; font yang dipakai adalah Aptos/Aptos Display serta Cascadia Mono dengan fallback dari aplikasi presentasi.
