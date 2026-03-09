# 🏦 Bank Term Deposit Prediction - Data Quest 2025

## 📌 Project Overview
Proyek ini dikerjakan sebagai bagian dari kompetisi **Data Quest 2025** yang diselenggarakan oleh **Data Science Indonesia**. Fokus utamanya adalah membangun model prediktif untuk mengidentifikasi nasabah bank yang berpotensi berlangganan **Deposito Berjangka** (*Term Deposit*).

Melalui pendekatan berbasis data, solusi ini bertujuan untuk mengoptimalkan strategi *telemarketing* perbankan agar lebih tepat sasaran dan efisien dalam melakukan konversi nasabah.

## ❓ Problem Statement
Industri perbankan menghadapi tantangan besar dalam efisiensi kampanye pemasaran:
* **Efisiensi Sumber Daya:** Pemasaran kepada seluruh nasabah tanpa filter mengakibatkan pemborosan biaya dan waktu.
* **Imbalanced Data:** Jumlah nasabah yang setuju berlangganan jauh lebih sedikit dibandingkan yang menolak, sehingga model rentan terhadap bias kelas mayoritas.
* **Identifikasi Pola:** Diperlukan identifikasi fitur demografis dan finansial yang paling berpengaruh terhadap keputusan nasabah.

## 📂 Dataset
Dataset mencakup data historis interaksi kampanye pemasaran bank:
* **Training Set:** `train.csv` (Data dengan label target).
* **Testing Set:** `test.csv` (Data tanpa label untuk kebutuhan kompetisi).

### Key Variables
* **Demografis:** `age`, `job`, `marital`, `education`.
* **Finansial:** `default` (gagal bayar), `housing`, `loan`.
* **Interaksi Kampanye:** `contact`, `month`, `day_of_week`, `duration`, `campaign`.
* **Sosial Ekonomi:** `emp.var.rate`, `cons.price.idx`, `cons.conf.idx`.
* **Target:** `y` (no/yes).

## ⚙️ Methodology

### 1. Data Preprocessing & Feature Engineering
Berdasarkan pengerjaan dalam *notebook*, langkah-langkah yang dilakukan meliputi:
* **Handling Missing Values:** Mengidentifikasi dan menangani nilai 'unknown' pada fitur kategorikal.
* **Feature Selection:** Menggunakan Feature Selection untuk memilih fitur yang paling relevan guna meningkatkan efisiensi komputasi model.
* **Encoding:** Menerapkan *Label Encoding* pada variabel kategorikal agar dapat diproses oleh algoritma *machine learning*.

### 2. Modeling Strategy
Strategi pemodelan difokuskan pada penanganan ketidakseimbangan kelas dan optimasi parameter:
* **Oversampling:** Menggunakan **SMOTE (Synthetic Minority Over-sampling Technique)** untuk menyeimbangkan proporsi kelas target pada data latih.
* **Algoritma Utama:** Membandingkan **Random Forest Classifier** dan **XGBoost Classifier**.
* **Hyperparameter Tuning:** Menggunakan **Optuna** untuk mencari kombinasi parameter terbaik (seperti `n_estimators`, `max_depth`, dan `learning_rate`) guna memaksimalkan performa model.
* 
## 📊 Results & Evaluation
Berikut adalah ruang untuk hasil performa model berdasarkan evaluasi validasi dan testing:

| Metric | Test Score | Best Validation Score |
| :--- | :--- | :--- |
| **Accuracy** | [83.86%] | [78.19%] |
| **ROC-AUC** | [78.90 %] | [-] |

Penggunaan **SMOTE** terbukti sangat krusial dalam menangani ketidakseimbangan kelas pada dataset ini. Integrasi algoritma **XGBoost** dengan optimasi **Optuna** memberikan landasan yang kuat dalam memprediksi keputusan nasabah secara lebih akurat dibandingkan model *baseline*.

## 👥 Authors - Team KTT2
* **Akbar Maulana** (NRP: 5003221104)
* **Rizal Afandi** (NRP: 5003221116)
* **Ida Bagus Panya Ananda Yogi** (NRP: 5003221154)
