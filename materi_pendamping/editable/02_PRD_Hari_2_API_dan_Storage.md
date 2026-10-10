# PRD Hari 2 API dan Penyimpanan
**Product Requirements Document | DPL Inspection Training | Versi latihan 0.2**

**Trainer dan Pembuat Buku: Damar Galih Aji Pradana, S.Tr.Kom.**

## Tujuan
Mengganti sumber data lokal checkpoint hari 1 dengan API latihan, menambahkan login demo, dan membuat state serta session dapat dikelola dengan jelas. UI tidak memanggil HTTP langsung. Peserta memisahkan model, API service, repository, controller ChangeNotifier, dan storage.

**Input:** tag day-1 yang memenuhi PRD hari 1 serta API training yang sudah disiapkan trainer/PIC. **Output:** app terintegrasi API dengan token demo dan cache daftar terakhir. **Pengguna:** satu petugas simulasi. **Reviewer:** trainer dan PIC developer. Implementasi dan deployment backend bukan materi peserta; mock Python dalam folder praktik menjadi fallback kelas dengan kontrak sama.

## Kebutuhan fungsional
| ID | Persyaratan inti | Perilaku |
|---|---|---|
| D2-01 | Login | Kredensial demo valid mendapat token; salah mendapat pesan |
| D2-02 | Session | Token disimpan di secure storage; startup memvalidasi melalui request API |
| D2-03 | GET daftar | HTTP response dikonversi menjadi List Inspection |
| D2-04 | POST inspeksi | Data valid dikirim; daftar diperbarui hanya setelah server sukses |
| D2-05 | State | Loading, success, empty, error dan retry terlihat |
| D2-06 | Cache | Simpan daftar terakhir; saat network failure tampil read-only dengan label waktu cache |
| D2-07 | 401 dan logout | Token/cache dibersihkan; kembali ke login; data lama tidak tampil |
| D2-08 | Submit guard | Tombol tidak menerima submit ganda selama request |
| D2-09 | Search/filter | Search kode/lokasi dan filter kondisi di daftar yang sudah dimuat |

**Demo tambahan:** pagination server, PUT/DELETE, interceptor konseptual dan upload multipart. Implementasi pagination penuh bukan acceptance wajib. Cache hanya daftar; tidak ada antrean POST offline.

## User stories
- Petugas ingin login dan melanjutkan sesi setelah restart tanpa menyimpan password.
- Petugas ingin melihat hasil request atau error sehingga mengetahui kapan retry perlu dilakukan.
- Petugas ingin membaca data terakhir ketika koneksi putus dan mengetahui bahwa data tersebut berasal dari cache.
- Petugas ingin logout tanpa meninggalkan session maupun catatan pengguna sebelumnya.

<!-- PAGE -->
## Kontrak API latihan
**Base URL:** parameter API_BASE_URL, tanpa slash terakhir. Jalur utama device/simulator memakai URL HTTPS yang disediakan PIC. Fallback mock lokal: iPhone Simulator memakai `http://localhost:8000`; Android Emulator memakai `http://10.0.2.2:8000`; physical device memakai alamat LAN komputer server. HTTP hanya untuk debug lab; release memakai staging HTTPS. Trainer memverifikasi kontrak sebelum sesi sehingga peserta langsung mengerjakan Flutter.

| Endpoint | Request | Response inti |
|---|---|---|
| POST /auth/login | username dan password | 200 token dan user; 401 bila salah |
| GET /inspections | Bearer token; query page/per_page/q/condition opsional | 200 items, page, per_page, total |
| POST /inspections | Bearer token; assetCode, location, condition, note | 201 object Inspection |
| GET /health | Tanpa token | 200 status ok |

Dokumentasi kontrak API dapat disediakan melalui Swagger/OpenAPI untuk referensi
trainer dan peserta, tetapi pembahasan tooling backend bukan bagian praktik.

**Demo login:** username `trainer`, password `training123`. Seluruh kredensial dan token ini dummy, bukan contoh autentikasi production. Mock server menyimpan data dalam memori; restart server mengembalikan seed data.

```json
{"token":"training-demo-token","user":{"id":"u1","name":"Trainer"}}
```

```json
{"items":[{"id":"1","assetCode":"PMP-001",
"location":"Workshop A","condition":"good","note":"",
"createdAt":"2026-10-03T01:00:00Z"}],
"page":1,"per_page":50,"total":1}
```

**Error kontrak:** 400 malformed JSON/query; 401 session tidak valid; 409 konflik/idempotency bila digunakan; 422 field invalid; 429 rate limit bila digunakan; 500 fault simulasi. Error berbentuk `{"message":"..."}` dan boleh membawa detail field yang terdokumentasi. Timeout dan network error berasal dari client dan tidak mempunyai HTTP status.

## Storage dan state
Token memakai secure storage. Cache daftar nonrahasia memakai SharedPreferencesAsync sebagai latihan; simpan satu JSON berisi items dan fetchedAt UTC. Data inspeksi production dapat bersifat sensitif sehingga backend dan kebijakan storage nyata harus ditinjau sebelum operasional.

Controller memiliki items, isLoading, isSubmitting, errorMessage, isCached dan fetchedAt. Loading tidak dimulai dari build(). Controller dimiliki dan di-dispose oleh layar. Repository menerima service melalui constructor agar sumber data bisa diganti.

<!-- PAGE -->
## Acceptance criteria hari 2
| ID | Skenario | Kriteria lulus |
|---|---|---|
| AC1 | Login benar dan salah | Benar membuka daftar; salah tetap di login tanpa token |
| AC2 | Restart app setelah login | Token dibaca; API diminta ulang; 401 tetap mengakhiri session |
| AC3 | GET dan POST valid | Response diparse; item baru tampil sekali dengan id server |
| AC4 | Klik simpan berulang saat request lambat | Hanya satu POST berjalan |
| AC5 | Network dimatikan sesudah GET sukses | Cache read-only tampil, label dan fetchedAt terlihat |
| AC6 | Network dimatikan tanpa cache | Error informatif dan retry, bukan daftar kosong palsu |
| AC7 | Header token tidak valid | 401 menghapus token/cache lalu membuka login |
| AC8 | Server 422 atau 500 | Pesan tampil; form tetap berisi data; submit dapat dicoba lagi |
| AC9 | JSON cache rusak | Cache diabaikan/dihapus; aplikasi tidak crash |
| AC10 | Logout dan login ulang | Session lama dibersihkan; tidak ada data cache lama |
| AC11 | Search/filter lokal | Hasil sesuai kode/lokasi/kondisi; clear memulihkan daftar |

## Kebutuhan nonfungsional
- Request timeout 10 detik; exception dibedakan antara timeout, network, parsing dan HTTP failure.
- Base URL bukan string hardcode di beberapa layar; gunakan dart-define.
- Password, token dan authorization header tidak dicetak ke log.
- pubspec.lock, README run server/app, dan file contoh environment masuk version control; credential asli tidak masuk.
- UI tidak melakukan retry POST otomatis karena request pertama mungkin telah diterima server.
- Cache tidak dipakai setelah 401 dan tidak memungkinkan membuat data offline.

## Definition of done
Semua persyaratan inti dan acceptance criteria lulus. Serahkan checkpoint day-2, bukti GET/POST, screenshot error/cache, dan catatan skema JSON. Trainer memeriksa pemisahan layer serta logout. Build release dan foto belum menjadi syarat hari 2.

## Dependensi dan pengendalian risiko
API training menjadi jalur utama setelah trainer/PIC menyelesaikan dry run endpoint, credential dummy, dan fault scenario. Peserta cukup menerima base URL serta kontrak response. Mock Python tetap tersedia sebagai fallback. Implementasi/deployment backend, refresh token, role permissions, database offline, serta multi-user cache tidak menjadi scope kelas.
