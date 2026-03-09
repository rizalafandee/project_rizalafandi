# 📡 Telco Customer Churn Dashboard - DMV A 📊

## 📌 Project Overview
Proyek ini dikembangkan untuk memenuhi *Final Project* mata kuliah **Data Mining dan Visualisasi A** di **Statistika ITS**. Fokus utamanya adalah menganalisis perilaku pelanggan perusahaan telekomunikasi untuk memprediksi probabilitas *churn* (berhenti berlangganan).

Selain pemodelan prediktif, kami membangun sebuah **Dashboard R-Shiny** interaktif untuk memvisualisasikan tren data dan memberikan rekomendasi strategi retensi bagi manajemen perusahaan.

## ❓ Problem Statement
Tingkat retensi pelanggan adalah metrik kritis dalam industri telekomunikasi:
* **Customer Retention:** Mempertahankan pelanggan lama jauh lebih murah dibandingkan mendapatkan pelanggan baru.
* **Churn Drivers:** Faktor apa saja yang menyebabkan pelanggan berhenti (misal: jenis kontrak, biaya bulanan, atau layanan teknis)?
* **Actionable Insight:** Bagaimana manajemen bisa melihat profil pelanggan yang berisiko tinggi secara *real-time*?

## 📂 Dataset
Dataset yang digunakan adalah **Telco Customer Churn** yang mencakup profil pelanggan dan layanan yang mereka gunakan.
* **Jumlah Data:** 7.043 entri.
* **Variabel Kunci:** `Contract`, `MonthlyCharges`, `TotalCharges`, `Tenure`, dan `InternetService`.
* **Target:** `Churn` (Yes/No).

## ⚙️ Methodology

### 1. Data Analysis & Modeling (Python)
Langkah-langkah yang dilakukan dalam *notebook* meliputi:
* **Preprocessing:** Penanganan *missing values* pada `TotalCharges` dan *encoding* variabel kategorikal.
* **Feature Selection:** Mengidentifikasi variabel yang memiliki korelasi kuat terhadap keputusan pelanggan untuk *churn*.
* **Modeling:** Membangun model klasifikasi untuk memprediksi status *churn* pelanggan.

### 2. Dashboard Development (R-Shiny)
Dashboard dirancang untuk memudahkan eksplorasi data secara visual:
* **Input Interaktif:** Filter berdasarkan masa tenor (*tenure*), jenis kontrak, dan metode pembayaran.
* **Visualisasi Utama:** Penggunaan *bar chart* dan *pie chart* untuk menunjukkan distribusi demografis dan pola pengeluaran pelanggan.
* **Summary Statistics:** Menampilkan ringkasan data yang berubah secara dinamis sesuai filter yang dipilih.

Dashboard yang dikembangkan berhasil memetakan kelompok rentan ini untuk target promosi khusus.

## 💻 Dashboard Features
* **Exploratory Data Analysis (EDA):** Grafik sebaran biaya bulanan dan masa berlangganan.
* **Customer Segmentation:** Melihat proporsi churn berdasarkan kategori layanan.
* **Interactive Table:** Data pelanggan yang dapat difilter secara langsung.

## 👥 Authors - Kelompok 17 (Statistika ITS)
* **M. Aflah Ghozi S** (NRP: 5003221074)
* **Rizal Afandi** (NRP: 5003221116)
* **Ryanaldi Robby K** (NRP: 5003221182)
* **M. Ilham Ramadhan** (NRP: 5003221185)
