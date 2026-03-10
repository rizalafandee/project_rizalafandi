# 🏙️ City Comfort Index (IKK) Analysis - Multiple Linear Regression

## 📌 Project Overview
Proyek ini merupakan laporan **Evaluasi Akhir Semester (EAS)** untuk mata kuliah **Analisis Regresi** di **Statistika ITS**. Fokus utama penelitian ini adalah mengidentifikasi faktor-faktor demografi dan sosial-ekonomi yang secara signifikan memengaruhi **Indeks Kenyamanan Kota (IKK)** di berbagai wilayah.

## ❓ Problem Statement
Menciptakan kota yang nyaman bagi penduduknya memerlukan pemahaman mendalam tentang variabel pendukung kualitas hidup:
* **Identifikasi Faktor:** Variabel apa saja (seperti kepadatan penduduk, rasio dependensi, atau jumlah remaja) yang paling berkontribusi terhadap kenyamanan kota?
* **Model Terbaik:** Bagaimana membangun model regresi yang ramping namun memiliki daya prediksi yang tinggi melalui seleksi fitur?
* **Validitas Statistik:** Apakah model yang dihasilkan telah memenuhi asumsi klasik regresi linear agar hasil estimasi tidak bias?

## 📂 Dataset Details
Penelitian ini melibatkan variabel-variabel berikut:
* **Variabel Respon ($Y$):** Indeks Kenyamanan Kota (IKK).
* **Variabel Prediktor ($X$):**
  * Proporsi Penduduk Remaja : proporsi penduduk yang termasuk dalam kategori remaja.
  * Sex Rasio : perbandingan jumlah penduduk laki-laki dibandingkan perempuan.
  * Dependensi Rasio : perbandingan antara populasi yang bukan angkatan kerja dengan yang bekerja.
  * Angka Partisipasi Kasar Perguruan Tinggi (APK-PT) : perbandingan antara jumlah penduduk yang masih bersekolah di jenjang pendidikan Perguruan Tinggi dengan jumlah penduduk yang memenuhi syarat resmi penduduk usia sekolah di jenjang tersebut.
  * Status Wilayah: data kategorik yang mencakup dua kategori, yaitu "Kota" dan "Kabupaten".
  * Jenis Wilayah : data kategorik yang terdiri dari tiga kategori, yaitu "Pesisir", "Antara Pesisir Non Pesisir", dan "Non-Pesisir".
  * 
## ⚙️ Methodology

### 1. Exploratory Data Analysis (EDA)
* Melakukan pemeriksaan korelasi antar variabel menggunakan *Scatter Plot* untuk melihat hubungan linier awal.

### 2. Multiple Linear Regression
* Membangun model awal dengan melibatkan seluruh variabel prediktor.
* **Backward Elimination:** Melakukan pemilihan model terbaik dengan menghapus variabel yang tidak signifikan secara bertahap berdasarkan nilai *p-value* tertinggi hingga diperoleh model optimal.

### 3. Diagnostic Checking (Asumsi Klasik)
Uji validitas model dilakukan melalui plot residual untuk memastikan:
* **Identik:** Residual memiliki varians konstan (*Homoskedastisitas*).
* **Independen:** Tidak ada autokorelasi antar residual.
* **Normalitas:** Residual berdistribusi normal (dicek melalui Q-Q Plot).

## 📊 Results & Evaluation
Berdasarkan proses eliminasi *backward*, diperoleh model final yang hanya menyertakan variabel-variabel paling signifikan. 
* **Full Model Performance:** [87,4%] menunjukkan bahwa variabel dalam model mampu menjelaskan 87,4% variabilitas Indeks Kenyamanan Kota.
* **Interpretasi:** Model terbaik berdasarkan metode ini adalah model yang memuat variabel rasio sex, rasio dependensi, dan variabel dummy dari jenis wilayah .

## 👥 Authors (Kelompok 26)
Mahasiswa **Statistika - Institut Teknologi Sepuluh Nopember (ITS)**:

1. **Tisso Arenggo Seto** (NRP: 5003221076)
2. **Rizal Afandi** (NRP: 5003221116)

**Dosen Pengampu:**
* Dr. Ir. Setiawan, MS
* Dr. Ismaini Zain, M.Si.

---
*Proyek ini merupakan bukti kemampuan dalam pemodelan statistika parametrik dan pengambilan keputusan berbasis data wilayah.*

