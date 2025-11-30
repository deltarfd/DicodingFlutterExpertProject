# Ditonton - Flutter Expert Project

[![CI](https://github.com/deltarfd/DicodingFlutterExpertProject/actions/workflows/main.yml/badge.svg)](https://github.com/deltarfd/DicodingFlutterExpertProject/actions/workflows/main.yml)
[![Codemagic build status](https://api.codemagic.io/apps/692a93c3ad97215c39c7a9ef/flutter-workflow/status_badge.svg)](https://codemagic.io/app/692a93c3ad97215c39c7a9ef/flutter-workflow/latest_build)

> **Flutter Version Required**: 3.38.3 or higher

📊 **[View Coverage Report](https://deltarfd.github.io/DicodingFlutterExpertProject/)**

## 🎯 Dicoding Submission - Flutter Expert

## 📦 Project Structure

This app is modularized into separate local packages for each feature.

**Packages**:
- `ditonton_core`: Shared db, errors, utils and domain entities
- `ditonton_movies`: Movies feature (data, domain, presentation with BLoC)
- `ditonton_tv`: TV feature (data, domain, presentation with BLoC)

The root app depends on these via path dependencies in pubspec.yaml.

## 🔄 CI/CD Pipeline

Automated testing and building powered by GitHub Actions:

- **Flutter 3.38.3** - Latest stable version
- **Dependency Caching** - Faster build times
- **Comprehensive Testing** - Unit, widget, and integration tests across all packages
- **Coverage Reporting** - Automatic HTML coverage reports with lcov/genhtml
- **GitHub Pages** - Coverage reports published at [deltarfd.github.io/DicodingFlutterExpertProject](https://deltarfd.github.io/DicodingFlutterExpertProject/)
- **APK Artifacts** - Debug builds saved for 7 days
- **Integration Tests** - Full app flow testing on every commit

## 🔥 Firebase Integration

- **Analytics** - User behavior tracking with `FirebaseAnalyticsObserver`
- **Crashlytics** - Automatic crash reporting for production stability
- **SSL Pinning** - Enhanced security for TMDB API requests

---

Repository ini merupakan starter project submission kelas Flutter Expert Dicoding Indonesia.

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

