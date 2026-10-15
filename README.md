# Sunity API — Dockerized Backend

Backend REST API untuk aplikasi Sunity, menggunakan TypeScript, Express, Bun, Drizzle ORM, dan PostgreSQL. Proyek ini dilengkapi Dockerfile dan Docker Compose agar backend dan database dapat dijalankan dalam lingkungan terkontainerisasi.

## Teknologi

- TypeScript
- Express.js
- Bun
- Drizzle ORM
- PostgreSQL
- Docker dan Docker Compose
- Better Auth

## Prasyarat

Pastikan perangkat sudah memiliki:

- Docker Desktop
- Docker Compose
- Git

## Konfigurasi Environment

Salin file contoh environment menjadi `.env`.

**Windows PowerShell:**

```powershell
Copy-Item .env.example .env
```

Sesuaikan nilai berikut di `.env` dengan kredensial yang valid:

- `BETTER_AUTH_SECRET`
- `GOOGLE_CLIENT_ID`
- `GOOGLE_CLIENT_SECRET`

Jangan mengunggah `.env` atau kredensial asli ke repository publik. Gunakan `.env.example` sebagai template tanpa secret pribadi.

Konfigurasi `DATABASE_URL` untuk Docker Compose menggunakan hostname `db`, yaitu nama service PostgreSQL di jaringan Compose:

```dotenv
DATABASE_URL=postgresql://sunity:sunity@db:5432/sunity
```

## Menjalankan dengan Docker Compose

Jalankan semua perintah dari direktori proyek.

### 1. Build image backend

```powershell
docker compose build backend
```

Dockerfile menggunakan multi-stage build: Bun digunakan untuk memasang dependensi dan mengompilasi TypeScript, kemudian aplikasi dijalankan menggunakan Node.js.

### 2. Jalankan database

```powershell
docker compose up -d db
```

Periksa status database:

```powershell
docker compose ps
```

Pastikan service database berstatus `healthy`.

### 3. Jalankan migrasi database

```powershell
docker compose run --rm --no-deps backend ./node_modules/.bin/drizzle-kit migrate
```

Perintah ini menerapkan migrasi Drizzle ke database PostgreSQL. Jalankan setelah database siap.

### 4. Jalankan backend dan database

```powershell
docker compose up -d
```

Periksa status kedua service:

```powershell
docker compose ps
```

Lihat log backend jika diperlukan:

```powershell
docker compose logs backend
```

## Port dan Jaringan

| Service | Port host | Keterangan |
|---|---:|---|
| Backend | `3000` | REST API dan dokumentasi |
| PostgreSQL | `5432` | Database |

Docker Compose membuat jaringan internal agar backend dapat terhubung ke database melalui hostname `db`.

Aplikasi dapat diakses melalui:

- API: `http://localhost:3000`
- Dokumentasi API: `http://localhost:3000/docs`
- Spesifikasi OpenAPI: `http://localhost:3000/openapi.json`

## Pengujian API

Periksa dokumentasi API:

```powershell
Invoke-WebRequest http://localhost:3000/docs -UseBasicParsing
```

Periksa endpoint daftar campaign:

```powershell
Invoke-RestMethod http://localhost:3000/api/campaigns
```

Endpoint tertentu membutuhkan autentikasi atau izin admin. Gunakan akun dan alur autentikasi yang sah untuk menguji endpoint tersebut.

## Persistensi Database

Data PostgreSQL disimpan pada named volume `pgdata`, yang oleh Docker Compose dibuat dengan nama proyek, misalnya `sunity-api_pgdata`.

Periksa volume:

```powershell
docker volume ls
```

Container dapat dihentikan dan dibuat ulang tanpa menghapus volume:

```powershell
docker compose down
docker compose up -d
```

Data database tetap tersimpan selama named volume tidak dihapus.

**Peringatan:** Jangan gunakan `docker compose down -v` jika ingin mempertahankan data database, karena opsi tersebut menghapus volume yang dikelola Compose.

## Perintah Docker yang Berguna

Melihat status service:

```powershell
docker compose ps
```

Melihat log:

```powershell
docker compose logs -f
```

Menghentikan container:

```powershell
docker compose down
```

Build ulang dan jalankan:

```powershell
docker compose up -d --build
```

## Menjalankan Tanpa Docker

Untuk pengembangan lokal, diperlukan Bun dan PostgreSQL yang dapat diakses oleh aplikasi.

```powershell
bun install
Copy-Item .env.example .env
bun run db:migrate
bun run dev
```

Pastikan `DATABASE_URL` pada `.env` menunjuk ke database yang dapat diakses dari mesin lokal, bukan hostname `db` yang khusus digunakan di jaringan Docker Compose.

## Kredit dan Penggunaan AI

AI Tool: ChatGPT (OpenAI),
Purpose: AI digunakan sebagai alat bantu untuk memahami konfigurasi, menyusun langkah implementasi, dan membantu proses debugging. Konfigurasi akhir diuji secara lokal menggunakan Docker Compose.
