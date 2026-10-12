# DPL Inspection Training API

API Express untuk menguji aplikasi Flutter Hari 2–3. Data disimpan in-memory dan
akan kembali ke seed awal ketika proses/container restart. Seluruh credential,
token, dan record adalah data dummy training.

## Endpoint penting

- Swagger UI: <http://localhost:3100/docs>
- OpenAPI JSON: <http://localhost:3100/openapi.json>
- Health: <http://localhost:3100/health>
- Login: `POST /auth/login`
- List/create: `GET|POST /inspections`
- Detail/update/delete: `GET|PUT|DELETE /inspections/{id}`

Login default: `trainer` / `training123`.

## Menjalankan dengan Docker

```sh
cd backend/inspection-api
docker compose up --build -d
docker compose ps
curl http://localhost:3100/health
```

Buka <http://localhost:3100/docs>, jalankan login, tekan **Authorize**, lalu isi
token `training-demo-token` untuk mencoba endpoint inspection.

Container tetap mendengarkan port `3000`; Compose memublikasikannya ke port
host `3100` agar tidak bentrok dengan web development server yang umum memakai
port `3000`. Ubah `API_HOST_PORT` dan `PUBLIC_BASE_URL` bila diperlukan.

Log dan stop:

```sh
docker compose logs -f inspection-api
docker compose down
```

## Menjalankan tanpa Docker

```sh
npm ci
npm test
npm run dev
```

Node.js 20 atau lebih baru diperlukan. Salin `.env.example` bila ingin
mengganti konfigurasi; source tidak otomatis membaca file `.env`, sehingga
export environment atau gunakan `node --env-file=.env src/server.js`.
Mode tanpa Docker memakai port `3000` sesuai nilai `PORT`.

## Menghubungkan Flutter

iPhone Simulator:

```sh
fvm flutter run -d "iPhone 16" \
  --dart-define=API_BASE_URL=http://localhost:3100
```

Android Emulator:

```sh
fvm flutter run \
  --dart-define=API_BASE_URL=http://10.0.2.2:3100
```

Physical device memakai IP LAN komputer Docker, misalnya
`http://192.168.1.10:3100`. HTTP hanya untuk debug jaringan training. Release
harus memakai staging HTTPS.

## Fault simulation

Compose mengaktifkan fault simulation. Gunakan header berikut melalui
`requests.http` atau Swagger:

| Header | Nilai | Hasil |
|---|---|---|
| `X-Debug-Fault` | `list-500` | GET list menghasilkan 500 |
| `X-Debug-Fault` | `create-500` | POST menghasilkan 500 |
| `X-Debug-Delay-Ms` | `11000` | Delay 11 detik untuk timeout Flutter |

Fault header diabaikan ketika `ENABLE_FAULTS=false`.

## Quality checks

```sh
npm run check
npm test
docker compose config
docker build -t dpl-inspection-training-api:local .
```

Source API terbuka di repository training sehingga peserta dapat membaca route,
store, validation, OpenAPI, dan test. API mempunyai CRUD lengkap, request ID,
log JSON tanpa Authorization/body, validasi field, error response konsisten,
pagination/search/filter, dan `Idempotency-Key` untuk mendemonstrasikan retry
POST yang aman. Ini tetap API training, bukan backend production atau tempat
menyimpan data operasional.

Source backend dilisensikan dengan MIT License; lihat `LICENSE`.
