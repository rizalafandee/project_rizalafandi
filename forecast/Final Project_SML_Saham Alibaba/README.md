# 📈 Alibaba Stock Price Forecasting (BABA) - SML Final Project

## 📌 Project Overview
Proyek ini merupakan *Final Project* mata kuliah **Statistical Machine Learning (SML)** yang berfokus pada peramalan deret waktu (*time series forecasting*) harga saham **Alibaba Group Holding Limited (BABA)**. Penelitian ini membandingkan algoritma *deep learning* **Long Short-Term Memory (LSTM)** dengan algoritma *ensemble learning* **XGBoost** untuk memprediksi pergerakan harga saham di pasar yang dinamis.

## ❓ Problem Statement
Pasar saham memiliki volatilitas yang sangat tinggi, sehingga prediksi harga yang akurat menjadi tantangan besar bagi investor:
* **Kompleksitas Data:** Harga saham dipengaruhi oleh faktor historis yang memiliki ketergantungan jangka panjang.
* **Model Comparison:** Apakah arsitektur *Recurrent Neural Network* (LSTM) lebih unggul dibandingkan model *Gradient Boosting* (XGBoost) dalam menangani data deret waktu?
* **Akurasi Prediksi:** Bagaimana meminimalkan nilai error (RMSE/MAPE) untuk memberikan estimasi harga yang paling mendekati realita.

## 📂 Dataset Details
* **Source:** Data historis harga saham Alibaba (BABA) yang mencakup periode waktu tertentu.
* **Fitur Utama:** `Open`, `High`, `Low`, `Close`, `Adj Close`, dan `Volume`.
* **Target:** Harga penutupan (*Closing Price*) di masa mendatang.

## ⚙️ Methodology

### 1. Data Preprocessing
* **Normalization:** Menggunakan *Min-Max Scaling* untuk mempercepat proses konvergensi pada model LSTM.
* **Windowing:** Mengubah data deret waktu menjadi format *supervised learning* dengan jendela waktu tertentu (*time steps*).
* **Train-Test Split:** Membagi data secara kronologis untuk menjaga urutan waktu.

### 2. Modeling Approach
* **LSTM (Long Short-Term Memory):** Digunakan untuk menangkap pola dependensi jangka panjang dan memori dalam data sekuensial.
* **XGBoost:** Digunakan sebagai pembanding berbasis pohon keputusan yang efisien dan kuat terhadap *outlier*.

## 📊 Results & Evaluation
Performa model dievaluasi menggunakan metrik akurasi statistik. Berdasarkan penelitian:
* **Model Terbaik:** XGBoost menunjukkan nilai error yang lebih rendah dalam menangkap tren fluktuasi harga.
* **Metrik Evaluasi:** Fokus pada nilai **RMSE (Root Mean Square Error)** dan **MAPE**.

## 👥 Authors (Kelompok 4 - SML C)
Penyusunan penelitian ini dilakukan oleh tim mahasiswa **Statistika - Institut Teknologi Sepuluh Nopember (ITS)**:

1. **Amadea Inchrisa** (NRP: 5003221146)
2. **Anita Diah Anggraini** (NRP: 5003211107)
3. **M. Aldevaran Jaylani Antares** (NRP: 5003221077)
4. **Meidiantha Nataniel Bangun** (NRP: 5003221117)
5. **Nabila Alyani Hanifah** (NRP: 5003221166)
6. **Revana Moza Hendriani** (NRP: 5003221009)
7. **Rifqi Adi Mahmada** (NRP: 5003221028)
8. **Rizal Afandi** (NRP: 5003221116)

---
*Proyek ini merupakan implementasi tingkat lanjut dari algoritma Statistical Machine Learning untuk analisis pasar keuangan.*
