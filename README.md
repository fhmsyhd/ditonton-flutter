# a199-flutter-expert-project

[![Flutter CI](https://github.com/fhmsyhd/ditonton-flutter/actions/workflows/flutter-ci.yml/badge.svg)](https://github.com/fhmsyhd/ditonton-flutter/actions/workflows/flutter-ci.yml)

Repository ini merupakan starter project submission kelas Flutter Expert Dicoding Indonesia.

## Menjalankan Aplikasi

Aplikasi membutuhkan API key TMDB melalui `--dart-define`. Nilai key tidak
disimpan di dalam repository.

```bash
flutter run --dart-define=TMDB_API_KEY=YOUR_API_KEY
```

Untuk membuat APK:

```bash
flutter build apk --dart-define=TMDB_API_KEY=YOUR_API_KEY
```

## SSL Pinning

Semua request API menggunakan `TmdbPinnedClient` dan hanya menerima koneksi
HTTPS ke `api.themoviedb.org`. Trust store aplikasi hanya memuat sertifikat
intermediate Amazon RSA 2048 M04 dari folder `assets/certificates/`.
