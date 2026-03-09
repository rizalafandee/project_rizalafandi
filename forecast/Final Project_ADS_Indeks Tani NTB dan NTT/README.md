# 🌾 Agricultural Price Index Forecasting (NTB & NTT) - VAR Model

## 📌 Project Overview
Proyek ini merupakan laporan analisis statistik yang berfokus pada peramalan **Indeks Harga yang Diterima Petani (IT)** di Provinsi **Nusa Tenggara Barat (NTB)** dan **Nusa Tenggara Timur (NTT)**. Mengingat sektor pertanian adalah tulang punggung ekonomi di kedua provinsi tersebut, peramalan ini krusial untuk memantau fluktuasi kesejahteraan petani.

## ❓ Problem Statement
Indikator ekonomi di sektor pertanian seringkali saling berkaitan antar wilayah yang berdekatan:
* **Interdependensi Wilayah:** Bagaimana pengaruh pergerakan harga di NTB terhadap NTT, dan sebaliknya?
* **Akurasi Peramalan:** Bagaimana menghasilkan estimasi nilai indeks di masa depan untuk membantu perencanaan kebijakan pangan?
* **Multivariat Time Series:** Mengapa metode univariat biasa tidak cukup untuk menangkap dinamika hubungan antar dua provinsi ini?

## 📂 Dataset Details
* **Variabel Utama:** Indeks Harga yang Diterima Petani (It) Provinsi NTB ($Z_{1,t}$) dan Provinsi NTT ($Z_{2,t}$).
* **Sumber Data:** Data sekunder resmi (BPS).
* **Karakteristik:** Data deret waktu (*time series*) bulanan.

## ⚙️ Methodology
Analisis dilakukan dengan menggunakan pendekatan **Vector Autoregressive (VAR)** melalui tahapan berikut:
1. **Uji Stasioneritas:** Memastikan data stasioner dalam varians dan rata-rata (menggunakan transformasi Box-Cox dan *Differencing*).
2. **Identifikasi Model:** Penentuan *Lag* optimal berdasarkan nilai *Akaike Information Criterion* (AIC).
3. **Estimasi Parameter:** Pembentukan persamaan model VAR untuk kedua wilayah.
4. **Uji Diagnostik:** Melakukan uji asumsi *white noise* dan distribusi normal pada residual.
5. **Forecasting:** Melakukan peramalan untuk periode mendatang dan menghitung nilai akurasi.

## 📊 Results & Evaluation
Model terbaik yang terpilih adalah **VAR (1)** setelah melalui proses *differencing* pertama.
* **Akurasi NTB:** Nilai MAPE sebesar **3,967%** dan RMSE sebesar **7,251**.
* **Akurasi NTT:** Nilai MAPE sebesar **3,657%** dan RMSE sebesar **4,546**.
* **Kesimpulan:** Model VAR mampu menangkap hubungan timbal balik antar wilayah dengan tingkat kesalahan yang sangat rendah (di bawah 10%), sehingga sangat layak digunakan untuk peramalan jangka pendek.

## 👥 Authors
Proyek ini disusun oleh mahasiswa **Statistika - Institut Teknologi Sepuluh Nopember (ITS)**:

1. **Rizal Afandi** (NRP: 5003221116)
2. **Ida Bagus Panya Ananda Yogi** (NRP: 5003221154)

**Dosen Pembimbing:** Dr. Irhamah, S.Si., M.Si.

---
*Proyek ini merupakan implementasi metode statistika multivariat untuk analisis ekonomi makro di sektor pertanian.*
