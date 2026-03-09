# 📱 Greckstore Relational Database System

## 📌 Project Overview
Proyek ini merupakan perancangan sistem manajemen basis data relasional untuk **Greckstore**, sebuah *Samsung Authorized Official Store*. Fokus utamanya adalah menciptakan arsitektur data yang mampu menangani seluruh alur operasional toko, mulai dari manajemen inventaris stok hingga otomatisasi pelaporan transaksi harian secara terstruktur.

## ❓ Business Challenges
Sebagai toko retail resmi, pengelolaan data manual sering kali menimbulkan kendala yang menghambat skalabilitas bisnis:
* **Integritas Data:** Risiko terjadinya anomali data saat proses *update* atau *delete* informasi produk dan pelanggan.
* **Redundansi:** Penyimpanan data yang tidak efisien yang dapat memperlambat performa sistem saat data mulai membesar.
* **Otomatisasi Laporan:** Kesulitan dalam menghasilkan rekapitulasi pendapatan dan inventaris secara *real-time*.

## ⚙️ Architecture & Design

### 1. Data Normalization
Sistem ini dirancang dengan mematuhi kaidah **Third Normal Form (3NF)** untuk memastikan tidak ada ketergantungan transitif. Arsitektur akhir terdiri dari **9 entitas utama** yang mencakup:
* **CRM:** Customer & Member Management.
* **Operations:** Staff, Supplier, & Order_Stock.
* **Transactions:** Produk, Pemesanan, Pengiriman, & Ongkos_Kirim.

### 2. Relationship Schema (ERD)
* **One-to-Many:** Pemetaan wilayah pengiriman ke transaksi serta kategori member ke data pelanggan.
* **One-to-One:** Integrasi langsung antara data pesanan dan rincian pengiriman logistik.
* **Many-to-Many:** Penanganan transaksi kompleks antara ribuan SKU produk dengan ribuan data pelanggan melalui tabel transaksi perantara.

## 🚀 Advanced SQL Automation
Sistem ini tidak hanya menyimpan data, tetapi juga dilengkapi dengan logika bisnis otomatis menggunakan fitur **MySQL**:

### ⚡ Automated Triggers
* **Inventory Synchronization:** Stok barang akan berkurang secara otomatis ketika terjadi transaksi penjualan (`INSERT` pada tabel Pemesanan) dan bertambah secara otomatis saat ada pasokan baru dari supplier (`INSERT` pada tabel Order_Stock).

### 📦 Stored Procedures & Business Intelligence
* **`Income()`**: Fungsi otomasi untuk menghasilkan laporan laba rugi bulanan dalam hitungan detik.
* **`Produk_Terjual()`**: Analisis *Best Seller* untuk mengidentifikasi produk dengan perputaran tercepat.
* **`Nota_Transaksi(ID_Pesan)`**: Generator invoice otomatis yang mengkalkulasi diskon khusus member dan biaya logistik secara presisi.

## 👥 Project Team - Kelompok 2 Basis Data B
Penyusunan sistem ini dilakukan melalui kolaborasi mahasiswa Departemen Statistika, Fakultas Sains dan Analitika Data:

* **Giffani Rizky Febrian** (NRP: 5003221014)
* **Brahmayudha Erlangga Putra** (NRP: 5003221084)
* **Rizal Afandi** (NRP: 5003221116)

---
*Proyek ini merupakan bukti kompetensi dalam perancangan struktur data relasional untuk kebutuhan industri retail.*
