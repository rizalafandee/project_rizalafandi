DROP DATABASE IF EXISTS GreckStore;
CREATE DATABASE IF NOT EXISTS GreckStore;
USE GreckStore;

CREATE TABLE Member (
    Kode_Member INT PRIMARY KEY,
    Tipe_Member VARCHAR(255),
    Diskon INT
);
-- desc Staff;

CREATE TABLE Staff (
    ID_Staff VARCHAR(7) PRIMARY KEY,
    Nama VARCHAR(255),
    Email VARCHAR(255),
    No_Telpon VARCHAR(15),
    Jabatan VARCHAR(50)
);

CREATE TABLE Ongkos_Kirim (
    Kode VARCHAR(3) PRIMARY KEY,
    Tujuan VARCHAR(255),
    Biaya INT
);

CREATE TABLE Customer (
    ID_Customer INT PRIMARY KEY,
    Nama VARCHAR(255),
    Email VARCHAR(255),
    No_Telepon VARCHAR(15),
    Alamat VARCHAR(255),
    Kode_Member INT,
    FOREIGN KEY (Kode_Member) REFERENCES Member(Kode_Member)
);

CREATE TABLE Produk (
    ID_Produk VARCHAR(10) PRIMARY KEY,
    Nama VARCHAR(255),
    Stock INT,
    Harga_Produk INT
);

CREATE TABLE Pemesanan (
    ID_Pemesanan VARCHAR(10),
    ID_Customer INT,
    ID_Produk VARCHAR(10),
    Jumlah INT,
    Tanggal_Pembelian DATE,
    ID_Staff VARCHAR(7),
    Tipe_Pembelian VARCHAR(10),
    Kode_Provinsi_Tujuan VARCHAR(3),
    Pembayaran VARCHAR(10),
    PRIMARY KEY(ID_Pemesanan, ID_Produk),
    FOREIGN KEY (ID_Customer) REFERENCES Customer(ID_Customer),
    FOREIGN KEY (ID_Produk) REFERENCES Produk(ID_Produk),
    FOREIGN KEY (ID_Staff) REFERENCES Staff(ID_Staff),
    FOREIGN KEY (Kode_Provinsi_Tujuan) REFERENCES Ongkos_Kirim(Kode)
);

CREATE TABLE Pengiriman (
    ID_Pemesanan VARCHAR(10) UNIQUE,
    Resi VARCHAR(10) PRIMARY KEY,
    Tanggal_Pengiriman DATE,
    Tanggal_Sampai DATE,
    FOREIGN KEY (ID_Pemesanan) REFERENCES Pemesanan(ID_Pemesanan)
);

CREATE TABLE Supplier (
    ID_Supplier VARCHAR(6) PRIMARY KEY,
    Alamat VARCHAR(100),
    Nama VARCHAR(50),
    Email VARCHAR(50)
);

CREATE TABLE Order_Stock (
    ID_Supplier VARCHAR(6),
    ID_Produk VARCHAR(10),
    Jumlah INT,
    Tanggal_Supply DATE,
    ID_Penanggung_Jawab VARCHAR(7),
    FOREIGN KEY (ID_Supplier) REFERENCES Supplier(ID_Supplier),
    FOREIGN KEY (ID_Produk) REFERENCES Produk(ID_Produk),
    FOREIGN KEY (ID_Penanggung_Jawab) REFERENCES Staff(ID_Staff)
);

-- Update Stock
DELIMITER //
CREATE TRIGGER StockOrder
AFTER INSERT ON Order_Stock
FOR EACH ROW
	BEGIN
		UPDATE Produk
		SET Stock = Stock + NEW.Jumlah
		WHERE ID_Produk = NEW.ID_Produk;
	END //

CREATE TRIGGER Pesanan
AFTER INSERT ON Pemesanan
FOR EACH ROW
	BEGIN
		UPDATE Produk
		SET Stock = Stock - NEW.Jumlah
		WHERE ID_Produk = NEW.ID_Produk;
	END //
DELIMITER ;

INSERT INTO Member (Kode_Member, Tipe_Member, Diskon) 
VALUES
(0, 'Non-Member', 0),
(1, 'Bronze', 5),
(2, 'Silver', 10),
(3, 'Gold', 15);

INSERT INTO Staff (ID_Staff, Nama, Email, No_Telpon, Jabatan) 
VALUES
('PK-5003', 'Budi Santoso', 'budi.santoso_123@gmail.com', '081399264871', 'Direktur'),
('PK-5004', 'Giffani Febrian', 'giffani.feb_567@gmail.com', '083514607289', 'Manager'),
('PK-5005', 'Alexander Afandi', 'alexander.afandi_1234@gmail.com', '086473910285', 'Manager'),
('PK-5006', 'Erlangga Yudha', 'erlangga.yudha_5678@gmail.com', '088697324105', 'Manager'),
('PK-5007', 'Ari Wibowo', 'ari.wibowo_9012@gmail.com', '081728506934', 'Sales Online'),
('PK-5008', 'Dilan Setiawan', 'dilan.setiawan_7890@gmail.com', '087602843159', 'Sales Online'),
('PK-5009', 'Yuli Astuti', 'yuli.astuti_5678901@gmail.com', '086195724803', 'Sales Online'),
('PK-5010', 'Devi Lestari', 'devi.lestari_123456@gmail.com', '082506139874', 'Sales Online'),
('PK-5011', 'Ahmad Rizki', 'ahmad.rizki_567890@gmail.com', '081405698372', 'Sales Offline'),
('PK-5012', 'Putri Lestari', 'putri.lestari_456@gmail.com', '087255786943', 'Sales Offline'),
('PK-5013', 'Adi Prasetyo', 'adi.prasetyo_789@gmail.com', '085628497013', 'Sales Offline'),
('PK-5014', 'Ratna Dewi', 'ratna.dewi_234@gmail.com', '082761935842', 'Sales Offline'),
('PK-5015', 'Siti Nurhaliza', 'siti.nurhaliza_890@gmail.com', '089938156472', 'Sales Offline'),
('PK-5016', 'Maya Sari', 'maya.sari_3456@gmail.com', '084305719682', 'Sales Offline'),
('PK-5017', 'Yuniarti Wijaya', 'yuniarti.wijaya_12345@gmail.com', '089263047815', 'Sales Offline'),
('PK-5018', 'Lina Fitriani', 'lina.fitriani_1234567@gmail.com', '084620385719', 'Sales Offline');

INSERT INTO Ongkos_Kirim (Kode, Tujuan, Biaya) 
VALUES
('OFF', 'On Place', 0),
('ACB', 'Aceh', 25000),
('BAL', 'Bali', 25000),
('BAN', 'Banten', 15000),
('BEN', 'Bengkulu', 25000),
('DIY', 'DI Yogyakarta', 18000),
('DKJ', 'DKI Jakarta', 10000),
('GOR', 'Gorontalo', 32000),
('JAM', 'Jambi', 22000),
('JTG', 'Jawa Tengah', 18000),
('JTM', 'Jawa Timur', 20000),
('JWB', 'Jawa Barat', 15000),
('KBB', 'Kepulauan Bangka Belitung', 25000),
('KRI', 'Kepulauan Riau', 20000),
('KTB', 'Kalimantan Barat', 30000),
('KTH', 'Kalimantan Tengah', 35000),
('KTM', 'Kalimantan Timur', 40000),
('KTS', 'Kalimantan Selatan', 32000),
('KTU', 'Kalimantan Utara', 40000),
('LAM', 'Lampung', 20000),
('MLK', 'Maluku', 40000),
('MLU', 'Maluku Utara', 40000),
('NTB', 'Nusa Tenggara Barat', 30000),
('NTT', 'Nusa Tenggara Timur', 35000),
('PAP', 'Papua', 45000),
('PBD', 'Papua Barat Daya', 45000),
('PBR', 'Papua Barat', 45000),
('PPG', 'Papua Pegunungan', 45000),
('PPS', 'Papua Selatan', 45000),
('PPT', 'Papua Tengah', 45000),
('RIA', 'Riau', 18000),
('SBT', 'Sulawesi Barat', 35000),
('SCT', 'Sulawesi Tengah', 35000),
('SSS', 'Sulawesi Selatan', 35000),
('STG', 'Sulawesi Tenggara', 35000),
('SUB', 'Sumatera Barat', 22000),
('SUN', 'Sumatera Utara', 20000),
('SUS', 'Sumatera Selatan', 20000),
('SUT', 'Sulawesi Utara', 30000);

INSERT INTO Customer (ID_Customer, Nama, Email, No_Telepon, Alamat, Kode_Member) 
VALUES
(5698, 'Farhan Akbar', 'farhan.akbar87@gmail.com', '087601234567', 'Jl. Gatot Subroto No. 345, Jambi', 0),
(2546, 'Rina Pratiwi', 'rina.pratiwi_43@gmail.com', '085678945612', 'Jl. Kartini No. 234, Palembang', 2),
(1278, 'Dika Wijaya', 'dika_wijaya09@gmail.com', '082156789012', 'Jl. Asia Afrika No. 123, Bandung', 1),
(4532, 'Rizky Setiawan', 'rizky.setiawan_18@gmail.com', '088901234567', 'Jl. Pahlawan No. 234, Madiun', 3),
(8967, 'Bella Permata', 'bella_permata03@gmail.com', '081901234567', 'Jl. Thamrin No. 456, Jakarta', 0),
(7823, 'Ira Susanti', 'ira_susanti27@gmail.com', '087890123456', 'Jl. Gatot Subroto No. 123,, Jakarta', 2),
(3189, 'Rima Indah', 'rima.indah40@gmail.com', '085345678901', 'Jl. A. Yani No. 890, Padang', 1),
(6742, 'Ani Fitriani', 'ani_fitriani39@gmail.com', '083234567890', 'Jl. Embong Malang No. 789, Surabaya', 3),
(4502, 'Siska Utami', 'siska_utami06@gmail.com', '088234567890', 'Jl. Ahmad Yani No. 789, Balikpapan', 0),
(7634, 'Indra Wibowo', 'indra_wibowo88@gmail.com', '081234567890', 'Jl. A. Mappanyuki No. 234, Makassar', 1),
(5632, 'Adira Budiman', 'adira_budiman50@gmail.com', '085632109523', 'Jl. Sam Ratulangi No. 567, Manado', 2),
(2856, 'Lintang Guin', 'lintang.guin143@gmail.com', '085217631992', 'Jl. Jend. Sudirman No. 123, Yogyakarta', 1),
(1470, 'Yuarki Isnaini', 'yuarki.nain33@gmail.com', '081178365199', 'Jl. Ahmad Dahlan No. 123, Surabaya', 1),
(1241, 'Kimberly Wati', 'kimberly_wati29@gmail.com', '085421873018', 'Jl. S. Parman No. 456, Semarang', 2),
(8901, 'Michael Erwin', 'mimic.erwin21@gmail.com', '083544589211', 'Jl. Gajah Mada No. 789, Yogyakarta', 2),
(1670, 'Andrew Galatama', 'andrew_galau20@gmail.com', '086198365291', 'Jl. Sudirman No. 234, Jakarta', 0),
(3476, 'Suroso Kimono', 'surosoo.kimono24@gmail.com', '082653018291', 'Jl. Jenderal Sudirman No. 567, Bandung', 3),
(4289, 'Supri Priyadi', 'supri_priyadi98@gmail.com', '084528164827', 'Jl. Dr. Sutomo No. 890, Malang', 1);

INSERT INTO Produk (ID_Produk, Nama, Stock, Harga_Produk) 
VALUES
('SM-S21PB', 'Samsung Galaxy S21 Phantom Blue', 100, 13986000),
('SM-S21MG', 'Samsung Galaxy S21 Mystic Grey', 150, 13986000),
('SM-S21MR', 'Samsung Galaxy S21 Mystic Red', 200, 13986000),
('SM-S21ML', 'Samsung Galaxy S21 Moonlight', 50, 13986000),
('SM-A52PB', 'Samsung Galaxy A52 Phantom Blue', 30, 5586000),
('SM-A52MG', 'Samsung Galaxy A52 Mystic Grey', 40, 5586000),
('SM-A52MR', 'Samsung Galaxy A52 Mystic Red', 100, 5586000),
('SM-M32PB', 'Samsung Galaxy M32 Phantom Blue', 20, 3486000),
('SM-M32MG', 'Samsung Galaxy M32 Mystic Grey', 80, 3486000),
('SM-N20AS', 'Samsung Galaxy Note 20 Ultra Ash Silver', 25, 16786000),
('SM-N20OB', 'Samsung Galaxy Note 20 Ultra Ocean Blue', 30, 16786000),
('SM-ZF3AS', 'Samsung Galaxy Z Fold 3 Ash Silver', 50, 25186000),
('SM-ZF3OB', 'Samsung Galaxy Z Fold 3 Ocean Blue', 15, 25186000),
('SM-ZF3BM', 'Samsung Galaxy Z Fold 3 Black Matte', 20, 25186000),
('ST-S7PAS', 'Samsung Galaxy Tab S7+ Ash Silver', 20, 11886000),
('ST-S7POB', 'Samsung Galaxy Tab S7+ Ocean Blue', 25, 11886000),
('ST-S7PBM', 'Samsung Galaxy Tab S7+ Black Matte', 50, 11886000),
('ST-A7LSB', 'Samsung Galaxy Tab A7 Lite Silver Blue', 35, 2086000),
('ST-A7LPS', 'Samsung Galaxy Tab A7 Lite Platinum Silver', 15, 2086000),
('ST-TAPSB', 'Samsung Galaxy Tab Active Pro Silver Blue', 40, 7686000),
('ST-S7PPS', 'Samsung Galaxy Tab Active Pro Platinum Silver', 25, 7686000),
('SB-CB4SB', 'Samsung Galaxy Chromebook 4 Silver Blue', 15, 11186000),
('SB-CB4PS', 'Samsung Galaxy Chromebook 4 Platinum Silver', 10, 11186000),
('SB-CB4RG', 'Samsung Galaxy Chromebook 4 Rose Gold', 30, 11186000),
('SB-BP5SB', 'Samsung Galaxy Book Pro 360 5G Silver Blue', 20, 20986000),
('SB-BP5PS', 'Samsung Galaxy Book Pro 360 5G Platinum Silver', 50, 20986000),
('SB-BS2PB', 'Samsung Galaxy Book S2 Phantom Blue', 30, 13986000),
('SB-BS2MG', 'Samsung Galaxy Book S2 Mystic Grey', 25, 13986000),
('SB-BS2MR', 'Samsung Galaxy Book S2 Mystic Red', 15, 13986000),
('SB-BF3PB', 'Samsung Galaxy Book Flex 3 Phantom Blue', 40, 18186000),
('SB-BF3MG', 'Samsung Galaxy Book Flex 3 Mystic Grey', 20, 18186000),
('SB-BF3MR', 'Samsung Galaxy Book Flex 3 Mystic Red', 35, 18186000),
('SB-CBGML', 'Samsung Galaxy Chromebook Go Moonlight', 10, 6986000),
('SB-CBGBM', 'Samsung Galaxy Chromebook Go Black Matte', 30, 6986000),
('SB-CBGPS', 'Samsung Galaxy Chromebook Go Platinum Silver', 15, 6986000);

INSERT INTO Pemesanan (ID_Pemesanan, ID_Customer, ID_Produk, Jumlah, Tanggal_Pembelian, ID_Staff, Tipe_Pembelian, Kode_Provinsi_Tujuan, Pembayaran)
VALUES
('STB-00001', 5698, 'SM-A52MG', 1, '2023-01-26', 'PK-5007', 'Online', 'JAM', 'Cash'),
('STB-00001', 5698, 'SM-N20OB', 2, '2023-01-26', 'PK-5007', 'Online', 'JAM', 'Cash'),
('STB-00002', 2546, 'SM-N20OB', 1, '2023-02-26', 'PK-5008', 'Online', 'SUS', 'Cash'),
('STB-00003', 1278, 'SB-BS2PB', 2, '2023-03-01', 'PK-5018', 'Offline', 'OFF', 'Debit'),
('STB-00004', 4532, 'ST-A7LPS', 1, '2023-03-01', 'PK-5007', 'Online', 'JTM', 'Cash'),
('STB-00005', 8967, 'ST-S7PAS', 1, '2023-03-01', 'PK-5008', 'Online', 'DKJ', 'Debit'),
('STB-00005', 8967, 'SB-CBGML', 1, '2023-03-01', 'PK-5008', 'Online', 'DKJ', 'Debit'),
('STB-00006', 7823, 'SB-BF3PB', 1, '2023-04-13', 'PK-5015', 'Offline', 'OFF', 'Debit'),
('STB-00007', 3189, 'SB-BP5PS', 2, '2023-05-03', 'PK-5010', 'Online', 'SUB', 'Cash'),
('STB-00008', 6742, 'ST-A7LSB', 1, '2023-05-08', 'PK-5012', 'Offline', 'OFF', 'Cash'),
('STB-00009', 4502, 'SM-A52MR', 2, '2023-06-10', 'PK-5011', 'Offline', 'OFF', 'Debit'),
('STB-00009', 4502, 'ST-S7POB', 1, '2023-06-10', 'PK-5011', 'Offline', 'OFF', 'Debit'),
('STB-00009', 4502, 'SB-CB4PS', 1, '2023-06-10', 'PK-5011', 'Offline', 'OFF', 'Debit'),
('STB-00010', 7634, 'SM-A52MG', 1, '2023-08-06', 'PK-5015', 'Offline', 'OFF', 'Debit'),
('STB-00010', 7634, 'SM-ZF3AS', 1, '2023-08-06', 'PK-5015', 'Offline', 'OFF', 'Debit'),
('STB-00011', 5632, 'SB-CB4RG', 1, '2023-08-08', 'PK-5013', 'Offline', 'OFF', 'Debit'),
('STB-00012', 2856, 'SB-CB4SB', 1, '2023-10-05', 'PK-5015', 'Offline', 'OFF', 'Debit'),
('STB-00013', 1470, 'SB-BS2MR', 1, '2023-10-08', 'PK-5007', 'Online', 'JTM', 'Debit'),
('STB-00014', 1241, 'SM-A52MR', 1, '2023-10-12', 'PK-5010', 'Online', 'JTG', 'Debit'),
('STB-00015', 8901, 'SB-CB4PS', 1, '2023-10-14', 'PK-5011', 'Offline', 'OFF', 'Cash'),
('STB-00016', 1670, 'SM-ZF3AS', 1, '2023-10-25', 'PK-5009', 'Online', 'DKJ', 'Debit'),
('STB-00017', 3476, 'SM-N20AS', 2, '2023-10-29', 'PK-5008', 'Online', 'JWB', 'Cash'),
('STB-00018', 4289, 'SB-CBGML', 1, '2023-11-10', 'PK-5018', 'Offline', 'OFF', 'Cash'),
('STB-00019', 2546, 'SM-A52MG', 1, '2023-11-27', 'PK-5017', 'Offline', 'OFF', 'Debit'),
('STB-00020', 4532, 'SM-S21PB', 1, '2023-12-12', 'PK-5009', 'Online', 'JTM', 'Debit'),
('STB-00021', 8901, 'SM-ZF3OB', 1, '2023-12-19', 'PK-5009', 'Online', 'DIY', 'Cash'),
('STB-00022', 1241, 'SB-BF3PB', 1, '2023-12-26', 'PK-5010', 'Online', 'JTG', 'Debit'),
('STB-00023', 7634, 'ST-A7LSB', 2, '2023-12-26', 'PK-5008', 'Online', 'SSS', 'Cash'),
('STB-00024', 6742, 'ST-TAPSB', 1, '2023-12-29', 'PK-5010', 'Online', 'JTM', 'Cash'),
('STB-00024', 6742, 'SM-A52MR', 1, '2023-12-29', 'PK-5010', 'Online', 'JTM', 'Cash');

INSERT INTO Pengiriman (ID_Pemesanan, Resi, Tanggal_Pengiriman, Tanggal_Sampai) 
VALUES
('STB-00001', 'ST05176', '2023-01-27', '2023-02-01'),
('STB-00002', 'ST05177', '2023-02-27', '2023-03-04'),
('STB-00004', 'ST05178', '2023-03-02', '2023-03-04'),
('STB-00005', 'ST05179', '2023-03-02', '2023-03-06'),
('STB-00007', 'ST05180', '2023-05-04', '2023-05-10'),
('STB-00013', 'ST05181', '2023-10-09', '2023-10-10'),
('STB-00014', 'ST05182', '2023-10-13', '2023-10-16'),
('STB-00016', 'ST05183', '2023-10-26', '2023-10-30'),
('STB-00017', 'ST05184', '2023-10-30', '2023-11-03'),
('STB-00020', 'ST05185', '2023-12-13', '2023-12-15'),
('STB-00021', 'ST05186', '2023-12-20', '2023-12-23'),
('STB-00022', 'ST05187', '2023-12-27', '2023-12-30'),
('STB-00023', 'ST05188', '2023-12-27', '2024-01-02'),
('STB-00024', 'ST05189', '2023-12-30', '2023-12-31');

INSERT INTO Supplier (ID_Supplier, Alamat, Nama, Email) 
VALUES
('HUB01', 'Jl. Melati Indah No. 7A, Bandung', 'Samsung-Tech Electronics Hub', 'samsungtech.electronicshub@gmail.com'),
('HUB02', 'Jl. Diponegoro No. 123, Semarang', 'Galaxy Electronics Hub', 'galaxy.electronicshub@gmail.com');

INSERT INTO Order_Stock (ID_Supplier, ID_Produk, Jumlah, Tanggal_Supply, ID_Penanggung_Jawab) 
VALUES
('HUB02', 'SB-CB4PS', 15, '2023-09-21', 'PK-5005'),
('HUB02', 'SB-CBGML', 30, '2023-02-02', 'PK-5005'),
('HUB01', 'SM-ZF3OB', 25, '2023-02-20', 'PK-5006'),
('HUB02', 'SB-BP5SB', 20, '2023-04-18', 'PK-5005'),
('HUB01', 'ST-A7LPS', 40, '2023-12-03', 'PK-5004'),
('HUB02', 'SB-CBGML', 15, '2023-08-01', 'PK-5005'),
('HUB02', 'SB-BS2MR', 20, '2023-08-19', 'PK-5005'),
('HUB02', 'SB-CB4PS', 20, '2023-03-11', 'PK-5005'),
('HUB01', 'SM-A52PB', 25, '2023-09-29', 'PK-5006'),
('HUB01', 'ST-TAPSB', 15, '2023-03-07', 'PK-5004'),
('HUB02', 'SB-BF3MR', 10, '2023-03-20', 'PK-5005');

-- Cek Triger Update Penambahan dan Pengurangan Stock Produk
SELECT ID_Produk, Stock FROM Produk;

INSERT INTO Pemesanan (ID_Pemesanan, ID_Customer, ID_Produk, Jumlah, Tanggal_Pembelian, ID_Staff, Tipe_Pembelian, Kode_Provinsi_Tujuan, Pembayaran) 
VALUES
('STB-00025', 4502, 'SB-BF3MG', 1, '2023-12-30', 'PK-5016', 'Offline', 'OFF', 'Cash'),
('STB-00026', 2546, 'SB-BF3MG', 2, '2023-12-30', 'PK-5013', 'Offline', 'OFF', 'Cash'),
('STB-00026', 2546, 'SB-BP5SB', 1, '2023-12-30', 'PK-5013', 'Offline', 'OFF', 'Cash'),
('STB-00026', 2546, 'SB-CB4RG', 1, '2023-12-30', 'PK-5013', 'Offline', 'OFF', 'Cash');

SELECT ID_Produk, Stock FROM Produk;

INSERT INTO Order_Stock (ID_Supplier, ID_Produk, Jumlah, Tanggal_Supply, ID_Penanggung_Jawab) 
VALUES
('HUB02', 'SB-CB4SB', 10, '2023-12-30', 'PK-5004'),
('HUB02', 'SB-CBGPS', 5, '2023-12-30', 'PK-5004');
SELECT ID_Produk, Stock FROM Produk;

DELIMITER //
CREATE PROCEDURE Income()
	BEGIN
		DECLARE current_month INT;
		DECLARE current_year INT;
		DECLARE total_income INT;

		SET current_month = 1;
		SET current_year = YEAR(NOW());

		CREATE TEMPORARY TABLE IF NOT EXISTS IncomeTable (
			Bulan VARCHAR(10),
			Pendapatan INT DEFAULT 0
		);

		WHILE current_month <= 12 DO
			SELECT IFNULL(SUM(Pemesanan.Jumlah * Produk.Harga_Produk * (100 - Member.Diskon) / 100),0) INTO total_income
			FROM Pemesanan
			JOIN Produk ON Produk.ID_Produk = Pemesanan.ID_Produk
			JOIN Customer ON Customer.ID_Customer = Pemesanan.ID_Customer
			JOIN Member ON Member.Kode_Member = Customer.Kode_Member
			JOIN Ongkos_Kirim ON Ongkos_Kirim.Kode = Pemesanan.Kode_Provinsi_Tujuan
			WHERE MONTH(Pemesanan.Tanggal_Pembelian) = current_month AND YEAR(Pemesanan.Tanggal_Pembelian) = current_year;

			INSERT INTO IncomeTable (Bulan, Pendapatan) VALUES (CONCAT(current_month, '/', current_year), total_income);

			SET current_month = current_month + 1;
		END WHILE;

		SELECT * FROM IncomeTable;
		DROP TEMPORARY TABLE IF EXISTS IncomeTable;
	END //
DELIMITER ;
CALL Income();

-- Penjualan Per Produk
DELIMITER //
CREATE PROCEDURE Produk_Terjual()
	BEGIN
		SELECT Produk.Nama, SUM(Pemesanan.Jumlah) AS Total_Penjualan
		FROM Pemesanan
		JOIN Produk ON Pemesanan.ID_Produk = Produk.ID_Produk
		GROUP BY Pemesanan.ID_Produk
		ORDER BY Total_Penjualan DESC;
	END//
DELIMITER ;
CALL Produk_Terjual();

-- Nota Pembelian (Satuan)
DELIMITER //
CREATE PROCEDURE Total_Harga(IN ID_Pesan VARCHAR(10))
	BEGIN
		DECLARE Harga INT;
		DECLARE n INT;
		DECLARE i INT DEFAULT 1;
        DECLARE Nama_Prod VARCHAR(255);
        
		SET SQL_SAFE_UPDATES = 0;
        
		SELECT COUNT(Pemesanan.ID_Pemesanan) FROM Pemesanan WHERE Pemesanan.ID_Pemesanan = ID_Pesan INTO n;
    
		SELECT SUM((Pemesanan.Jumlah * Produk.Harga_Produk *(100 - Member.Diskon)/100) + Ongkos_Kirim.Biaya/n) INTO Harga
		FROM Pemesanan
		JOIN Produk ON Pemesanan.ID_Produk = Produk.ID_Produk
		JOIN Customer ON Pemesanan.ID_Customer = Customer.ID_Customer
		JOIN Member ON Customer.Kode_Member = Member.Kode_Member
		JOIN Ongkos_Kirim ON Pemesanan.Kode_Provinsi_Tujuan = Ongkos_Kirim.Kode
		WHERE Pemesanan.ID_Pemesanan = ID_Pesan;
        
        SELECT GROUP_CONCAT(CONCAT(' ',Produk.Nama, ' (', Pemesanan.Jumlah, ')')) INTO Nama_Prod
		FROM Pemesanan
		JOIN Produk ON Pemesanan.ID_Produk = Produk.ID_Produk
		WHERE Pemesanan.ID_Pemesanan = id_pesan;
		
        SELECT Pemesanan.ID_Pemesanan, Customer.Nama AS Nama_Customer, Nama_Prod AS Nama_Produk, Pemesanan.Tanggal_Pembelian, Staff.Nama AS Nama_Staff, Pemesanan.Tipe_Pembelian, Ongkos_Kirim.Tujuan AS Provinsi_Tujuan, Pemesanan.Pembayaran, Harga AS Harga_Total
        FROM Pemesanan
        JOIN Customer ON Pemesanan.ID_Customer = Customer.ID_Customer
        JOIN Staff ON Pemesanan.ID_Staff = Staff.ID_Staff
        JOIN Ongkos_Kirim ON Pemesanan.Kode_Provinsi_Tujuan = Ongkos_Kirim.Kode
        WHERE Pemesanan.ID_Pemesanan = ID_Pesan
        LIMIT 1;
	END //
DELIMITER ;
CALL Total_Harga('STB-00001');

DELIMITER //
CREATE PROCEDURE Nota_Transaksi(IN ID_Pesan VARCHAR(10))
BEGIN
	DECLARE Harga INT DEFAULT 0;
    DECLARE n INT;
    DECLARE Ongkir INT;
    SET SQL_SAFE_UPDATES = 0;

	SELECT COUNT(Pemesanan.ID_Pemesanan) FROM Pemesanan WHERE Pemesanan.ID_Pemesanan = ID_Pesan INTO n;
    SELECT SUM(Ongkos_Kirim.Biaya/n) INTO Ongkir
    FROM Pemesanan
    JOIN Ongkos_Kirim ON Pemesanan.Kode_Provinsi_Tujuan = Ongkos_Kirim.Kode
	WHERE Pemesanan.ID_Pemesanan = ID_Pesan;
    
	SELECT SUM((Pemesanan.Jumlah * Produk.Harga_Produk *(100 - Member.Diskon)/100) + Ongkir/n) INTO Harga
	FROM Pemesanan
	JOIN Produk ON Pemesanan.ID_Produk = Produk.ID_Produk
	JOIN Customer ON Pemesanan.ID_Customer = Customer.ID_Customer
	JOIN Member ON Customer.Kode_Member = Member.Kode_Member
	JOIN Ongkos_Kirim ON Pemesanan.Kode_Provinsi_Tujuan = Ongkos_Kirim.Kode
	WHERE Pemesanan.ID_Pemesanan = ID_Pesan;
    
    SELECT
        CONCAT('+ ---------------------------- NOTA PEMBELIAN ----------------------------- +','\n',
               '| Tanggal Transaksi\t: ', MAX(DATE_FORMAT(Pemesanan.Tanggal_Pembelian, '%d %M %Y')), '\t\t\t\t|\n',
               '| Pelanggan\t: ', MAX(Customer.Nama), '\t\t\t\t|\n',
               '| Sales\t\t: ', MAX(Staff.Nama), '\t\t\t\t|\n',
               '+ -------------------------------------------------------------------------------- +', '\n',
               CONCAT('|   ID Produk\t', 'Jumlah\t', 'Harga   \t\t', 'Total\t\t|','\n',
               (SELECT GROUP_CONCAT('|   ',  Produk.ID_Produk, '\t', Pemesanan.Jumlah, '\t', Produk.Harga_Produk, '   \t', (Pemesanan.Jumlah * Produk.Harga_Produk), '    \t|' SEPARATOR '\n')
               FROM Pemesanan
               JOIN Produk ON Pemesanan.ID_Produk = Produk.ID_Produk
               WHERE Pemesanan.ID_Pemesanan = ID_Pesan)
               ), '\n',
               '+ -------------------------------------------------------------------------------- +', '\n',
               '|   Biaya Ongkir\t\t\t   \t', Ongkir, '\t\t|\n',
               '|   Total Biaya\t\t\t   \t', Harga, '\t|\n',
               '+ -------------------------------------------------------------------------------- +', '\n',
               '|   \to0o0o   Hayaa lu olangg tak lugi oo beli disini   o0o0o\t|\n',
               '+ -------------------------------------------------------------------------------- +', '\n'
        ) AS Nota
	FROM Pemesanan
	JOIN Customer ON Pemesanan.ID_Customer = Customer.ID_Customer
	JOIN Produk ON Pemesanan.ID_Produk = Produk.ID_Produk
    JOIN Staff ON Pemesanan.ID_Staff = Staff.ID_Staff
    WHERE Pemesanan.ID_Pemesanan = ID_Pesan
    GROUP BY Pemesanan.ID_Pemesanan;
END //
DELIMITER ;
CALL Nota_Transaksi('STB-00001'); -- gunakan form editor untuk melihat output yang sempurna