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

Sertifikat berlaku sampai 23 Agustus 2030. Periksa rantai sertifikat TMDB dan
perbarui file PEM serta DER sebelum masa berlaku berakhir atau saat TMDB
mengganti certificate authority.

## Firebase Analytics dan Crashlytics

Aplikasi Android dan iOS terhubung ke Firebase project `solve-ur-shape` dengan
package/bundle ID `com.dicoding.ditonton`. Firebase diinisialisasi saat aplikasi
dimulai, navigasi halaman dicatat oleh `FirebaseAnalyticsObserver`, dan error
fatal Flutter maupun error asinkron yang tidak tertangani dikirim ke
Crashlytics.

Untuk memeriksa event secara langsung melalui Analytics DebugView di Android:

```bash
adb shell setprop debug.firebase.analytics.app com.dicoding.ditonton
flutter run --dart-define=TMDB_API_KEY=YOUR_API_KEY
```

Untuk mengirim laporan uji Crashlytics, jalankan aplikasi dengan tombol uji
khusus berikut:

```bash
flutter run \
  --dart-define=TMDB_API_KEY=YOUR_API_KEY \
  --dart-define=ENABLE_CRASHLYTICS_TEST=true
```

Buka halaman **About**, tekan **Test Crashlytics**, lalu jalankan kembali
aplikasi agar laporan crash dikirim. Tombol tersebut tidak muncul pada
penggunaan normal.

---

## Tips Submission Awal

Pastikan untuk memeriksa kembali seluruh hasil testing pada submissionmu sebelum dikirimkan. Karena kriteria pada submission ini akan diperiksa setelah seluruh berkas testing berhasil dijalankan.


## Tips Submission Akhir

Jika kamu menerapkan modular pada project, Anda dapat memanfaatkan berkas `test.sh` pada repository ini. Berkas tersebut dapat mempermudah proses testing melalui *terminal* atau *command prompt*. Sebelumnya menjalankan berkas tersebut, ikuti beberapa langkah berikut:
1. Install terlebih dahulu aplikasi sesuai dengan Operating System (OS) yang Anda gunakan.
    - Bagi pengguna **Linux**, jalankan perintah berikut pada terminal.
        ```
        sudo apt-get update -qq -y
        sudo apt-get install lcov -y
        ```
    
    - Bagi pengguna **Mac**, jalankan perintah berikut pada terminal.
        ```
        brew install lcov
        ```
    - Bagi pengguna **Windows**, ikuti langkah berikut.
        - Install [Chocolatey](https://chocolatey.org/install) pada komputermu.
        - Setelah berhasil, install [lcov](https://community.chocolatey.org/packages/lcov) dengan menjalankan perintah berikut.
            ```
            choco install lcov
            ```
        - Kemudian cek **Environtment Variabel** pada kolom **System variabels** terdapat variabel GENTHTML dan LCOV_HOME. Jika tidak tersedia, Anda bisa menambahkan variabel baru dengan nilai seperti berikut.
            | Variable | Value|
            | ----------- | ----------- |
            | GENTHTML | C:\ProgramData\chocolatey\lib\lcov\tools\bin\genhtml |
            | LCOV_HOME | C:\ProgramData\chocolatey\lib\lcov\tools |
        
2. Untuk mempermudah proses verifikasi testing, jalankan perintah berikut.
    ```
    git init
    ```
3. Kemudian jalankan berkas `test.sh` dengan perintah berikut pada *terminal* atau *powershell*.
    ```
    test.sh
    ```
    atau
    ```
    ./test.sh
    ```
    Proses ini akan men-*generate* berkas `lcov.info` dan folder `coverage` terkait dengan laporan coverage.
4. Tunggu proses testing selesai hingga muncul web terkait laporan coverage.
