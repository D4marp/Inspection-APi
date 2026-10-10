# Handoff API Training — Express, Swagger/OpenAPI, dan Docker

Dokumen ini adalah checklist persiapan trainer/PIC sebelum kelas, bukan materi
peserta. Kelas tetap dominan Flutter; Express, Swagger/OpenAPI, dan Docker hanya
menjamin API training siap dipakai dan kontraknya mengikuti PRD Hari 2.

Implementasi referensi yang siap dijalankan tersedia di
`../backend/inspection-api`. Dari root paket:

```sh
cd backend/inspection-api
docker compose up --build -d
curl http://localhost:3100/health
```

Swagger UI lokal tersedia di <http://localhost:3100/docs> dan spesifikasi
OpenAPI di <http://localhost:3100/openapi.json>. Port host `3100` dipilih agar
tidak bentrok dengan development server pada port `3000`.

## Artefak yang disediakan backend

- Base URL training melalui HTTPS.
- Swagger UI, misalnya `https://HOST/docs`.
- Dokumen OpenAPI, misalnya `https://HOST/openapi.json`.
- Endpoint `/health` yang memuat status dan versi/image tag.
- Credential dummy, seed data, serta cara menjalankan fault scenario.
- Docker image/tag dan rentang waktu backend tersedia untuk kelas.

## Kontrak minimum

| Operation | Success | Failure utama |
|---|---:|---|
| `POST /auth/login` | 200 token + user | 401 credential salah |
| `GET /inspections` | 200 items + pagination | 401, 500 |
| `POST /inspections` | 201 Inspection | 401, 409, 422 |
| `GET /health` | 200 status + version | 503 dependency down |

Nama field inti tetap mengikuti PRD: `id`, `assetCode`, `location`, `condition`,
`note`, dan `createdAt`. `condition` menerima `good` atau `needs_action`.
Timestamp dikirim sebagai ISO-8601 dan dinormalisasi UTC di Flutter.

## Checklist sebelum kelas

1. Jalankan seluruh operation dari Swagger UI.
2. Cocokkan status, schema, enum, required field, dan contoh response dengan PRD.
3. Verifikasi 401 tidak mengembalikan data session lama.
4. Verifikasi 422 mempunyai pesan yang dapat dipetakan ke field form.
5. Catat image tag, commit backend, base URL, dan credential dummy.
6. Pastikan log backend memakai request ID serta meredaksi token/password.
7. Uji dari jaringan/device yang dipakai peserta.
8. Siapkan mock Python sebagai fallback dengan kontrak yang sama.

## Konfigurasi Flutter

```sh
flutter run \
  --dart-define=API_BASE_URL=https://HOST_API_TRAINING
```

Release candidate menggunakan staging HTTPS. Jangan menjadikan localhost,
cleartext global, token, password, atau host rahasia sebagai nilai hard-coded di
widget/source control.

## Bukti handoff

Simpan versi OpenAPI, daftar endpoint/status, screenshot Swagger tanpa secret,
request ID contoh, image tag Docker, serta hasil smoke test. Jika kontrak hosted
berbeda dari mock, perbaiki kontraknya sebelum wiring UI; aplikasi tidak boleh
menebak bentuk payload.

