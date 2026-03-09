# 🛡️ Fraud Detection: Semi-Supervised Learning Approach

## 📌 Project Overview
Proyek ini mengimplementasikan alur kerja data science yang terintegrasi untuk mendeteksi penipuan (*fraud*). Karena data awal tidak memiliki label target, proyek ini menggunakan pendekatan **Clustering** untuk menghasilkan label buatan, yang kemudian divalidasi dan digunakan sebagai target dalam model **Classification**.

## 🔄 Integrated Workflow
Proyek ini tidak berdiri sendiri, melainkan sebuah rangkaian proses yang saling berhubungan:

1. **Unsupervised Step (Clustering)**:
   * Data profil akun dianalisis tanpa label menggunakan **K-Means**.
   * Dihasilkan 3 cluster (0, 1, 2) yang merepresentasikan tingkatan perilaku pengguna.
   
2. **Supervised Step (Classification)**:
   * Hasil label dari *clustering* dijadikan sebagai **Variabel Target**.
   * Model **Random Forest** dilatih menggunakan label tersebut untuk memprediksi kategori risiko pada data baru di masa depan.



## 📂 Dataset Details
* **Jumlah Data**: 2.513 entri.
* **Fitur Utama**: `TransactionAmount`, `LoginAttempts`, `AccountBalance`, dan `LastLoginRegion`.
* **Kategori Hasil**: 0, 1, 2

## ⚙️ Methodology

### 1. Clustering with K-Means
* **Feature Selection**: Fokus pada atribut finansial dan perilaku login.
* **Elbow Method**: Digunakan untuk memastikan bahwa 3 cluster adalah jumlah yang paling optimal untuk segmentasi ini.

### 2. Classification with Random Forest
* **Labeling**: Menggunakan output cluster sebagai ground truth.
* **Optimization**: Menerapkan Hyperparameter Tuning untuk mendapatkan model yang paling presisi dalam membedakan antar kategori risiko.

## 📊 Results & Evaluation
Dengan menggunakan label hasil *clustering*, model **Random Forest** mampu mempelajari pola karakteristik tiap kelompok dengan sangat baik. Hal ini membuktikan bahwa segmentasi perilaku otomatis dapat menjadi dasar yang kuat untuk membangun sistem deteksi *fraud* yang proaktif.

## 👤 Author
* **Rizal Afandi**

*Project ini adalah bagian dari Proyek Machine Learning saya di program Asah led by Dicoding x Accenture.*
