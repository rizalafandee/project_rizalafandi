# 🏨 Hotel Booking Insight Dashboard - DMV A 📊

## 📌 Project Overview
Proyek ini dikembangkan untuk memenuhi Final Project mata kuliah Data Mining dan Visualisasi (A) di Program Studi Statistika ITS. Fokus utamanya adalah menganalisis pola pemesanan hotel, perilaku pelanggan, dan tren reservasi untuk memahami faktor-faktor yang memengaruhi pembatalan.  Selain analisis mendalam dan pemodelan prediktif, kami membangun sebuah Interactive Dashboard menggunakan R-Shiny untuk memvisualisasikan tren data serta mendeteksi risiko pembatalan guna mendukung pengambilan keputusan operasional manajemen perhotelan.

## ❓ Problem Statement
Kemudahan fitur pembatalan gratis pada platform pemesanan online memunculkan tantangan kritis bagi manajemen hotel:
Impact on Revenue: Pembatalan mendadak memang menguntungkan tamu, namun berpotensi menurunkan pendapatan dan mengganggu operasional hotel.
Cancellation Drivers: Faktor dominan apa saja yang memengaruhi tamu untuk membatalkan pesanan (misal: jarak waktu pemesanan/lead time, harga kamar, atau tipe segmentasi pasar)?
Actionable Insight: Bagaimana pihak manajemen dapat memprediksi probabilitas pembatalan secara dini untuk menyiapkan langkah antisipatif?

## 📂 Dataset
Dataset yang digunakan adalah Hotel Reservations Dataset yang memuat rekam jejak historis pemesanan tamu.
Jumlah Data: 36.275 entri.
Variabel Kunci: lead_time, avg_price_per_room, room_type_reserved, no_of_special_requests, dan komposisi tamu.
Target: booking_status (Canceled / Not_Canceled).

## ⚙️ Methodology
1. Data Analysis & Modeling (Python)  
Langkah-langkah yang dilakukan dalam tahapan analitik meliputi:  
Preprocessing & Resampling: Melakukan perbaikan tipe data tanggal, rekayasa fitur (menghitung total malam & mengelompokkan lead time), serta menangani ketidakseimbangan kelas (imbalanced data) menggunakan teknik SMOTE khusus pada data latih.  
Feature Selection: Melakukan uji ANOVA F-Test (untuk fitur numerik) dan Chi-Square Test (untuk fitur kategorik) guna memvalidasi signifikansi prediktor terhadap variabel target.  
Modeling: Menguji kinerja tiga algoritma (Random Forest, Logistic Regression, dan Gaussian Naive Bayes). Random Forest ditetapkan sebagai model terbaik karena menghasilkan Akurasi dan AUC tertinggi serta konsisten diuji melalui K-Fold Cross Validation.  
2. Dashboard Development (R-Shiny)  
Dashboard dirancang agar insight mudah diakses dan digunakan secara praktis:  
Interactive Prediction: Form input khusus bagi manajemen untuk memasukkan karakteristik reservasi baru dan mendapatkan prediksi risiko pembatalannya saat itu juga.  Visualisasi Utama: Menggunakan variasi bar chart, line chart, dan pie chart untuk memantau puncak pemesanan (booking trends) dan perbandingan demografi tamu antar tahun maupun bulan.  
Summary Statistics: Panel metrik yang menampilkan angka agregat seperti total pendapatan estimasi, total reservasi yang batal, dan rata-rata durasi menginap.  
💻 Dashboard Features  
About Dataset: Menampilkan tabel data mentah yang dapat difilter dan diunduh, lengkap dengan Metadata (Variable Description).  
Data Analysis (Summary & Visualizations): Eksplorasi visual dan ringkasan statistik yang dapat disesuaikan rentang waktu dan status pembatalannya (mencakup metrik Reservation dan Guest).  
Cancellation Prediction: Fitur kalkulator machine learning untuk memprediksi apakah sebuah reservasi berisiko tinggi dibatalkan (High Risk/Low Risk).  

## 👥 Authors - Kelompok 17 (Data Mining dan Visualisasi A)
M. Aflah Ghozi S (NRP: 5003221074)  
Rizal Afandi (NRP: 5003221116)  
Ryanaldy Robby Kusuma (NRP: 5003221182)  
M. Ilham Ramadhan (NRP: 5003221185)  
