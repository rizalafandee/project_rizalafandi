# 🛡️ User Behavior Analysis & Fraud Detection

![Program](https://img.shields.io/badge/Program-Asah_by_Dicoding_x_Accenture-red)
![Role](https://img.shields.io/badge/Role-Machine_Learning_Learning_Path-blue)
![Tools](https://img.shields.io/badge/Tools-Python_%7C_Scikit--Learn_%7C_Pandas-green)

## 📌 Project Overview
Proyek ini merupakan *Final Submission* untuk program **Studi Independen: Asah by Dicoding x Accenture**. [cite_start]Fokus utama proyek ini adalah mengimplementasikan teknik *Supervised Learning* untuk deteksi penipuan dan *Unsupervised Learning* untuk segmentasi profil akun[cite: 905, 1014].

## ❓ Problem Statement
Dalam ekosistem digital, keamanan transaksi dan pemahaman terhadap segmen pengguna adalah kunci utama:
* [cite_start]**Klasifikasi**: Menentukan apakah aktivitas akun bersifat "Safe", "Suspect", atau "Fraud" berdasarkan pola login dan transaksi[cite: 1015].
* [cite_start]**Clustering**: Mengelompokkan pengguna berdasarkan profil keuangan (*Account Balance*) untuk strategi intervensi yang lebih personal[cite: 351, 827].

## 📂 Dataset
Dataset yang digunakan mencakup data simulasi aktivitas akun:
* [cite_start]**Jumlah Data**: 2.513 baris[cite: 310].
* [cite_start]**Fitur Utama**: `TransactionAmount`, `LoginAttempts`, `AccountBalance`, dan `LastLoginRegion`[cite: 313, 316].
* **Variabel Target**: `Target` (0: Safe, 1: Suspect, 2: Fraud).

## ⚙️ Methodology

### 1. Classification (Supervised Learning)
* [cite_start]**Preprocessing**: Penanganan data kosong dan *Label Encoding* pada variabel kategorikal[cite: 323, 324].
* [cite_start]**Model**: Menggunakan **Random Forest Classifier** yang dioptimasi untuk akurasi maksimal[cite: 349, 1003].
* **Evaluasi**: Menggunakan *Confusion Matrix* dan *Classification Report* untuk memastikan deteksi fraud yang presisi.

### 2. Clustering (Unsupervised Learning)
* [cite_start]**Metode**: **K-Means Clustering**[cite: 351, 360].
* [cite_start]**Penentuan K**: Menggunakan **Elbow Method** untuk menentukan jumlah kelompok paling optimal[cite: 358, 826].
* **Visualisasi**: Pemetaan sebaran pengguna berdasarkan saldo dan jumlah transaksi.

## 📊 Results & Evaluation
Model klasifikasi berhasil memberikan performa yang sangat stabil dalam mendeteksi pola penipuan. [cite_start]Sementara itu, model *clustering* berhasil membagi pengguna ke dalam beberapa segmen risiko yang membantu tim operasional dalam mengambil tindakan proaktif[cite: 362, 854].

## 👤 Author
[cite_start]**Rizal Afandi** [cite: 5, 20]
[cite_start]Sarjana Statistika - **Institut Teknologi Sepuluh Nopember (ITS)** [cite: 14, 29]
*Project ini dikembangkan sebagai portofolio kompetensi Machine Learning di program Dicoding x Accenture.*
