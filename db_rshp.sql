-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: laravel
-- ------------------------------------------------------
-- Server version	8.4.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;

--
-- Table structure for table `detail_rekam_medis`
--

DROP TABLE IF EXISTS `detail_rekam_medis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detail_rekam_medis` (
  `iddetail_rekam_medis` int NOT NULL AUTO_INCREMENT,
  `idrekam_medis` int NOT NULL,
  `idkode_tindakan_terapi` int NOT NULL,
  `detail` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `deleted_by` bigint DEFAULT NULL,
  PRIMARY KEY (`iddetail_rekam_medis`),
  KEY `fk_detail_rekam_medis_rekam_medis1_idx` (`idrekam_medis`),
  KEY `idkode_tindakan_terapi` (`idkode_tindakan_terapi`),
  KEY `fk_detail_rekam_medis_user` (`deleted_by`),
  CONSTRAINT `detail_rekam_medis_ibfk_1` FOREIGN KEY (`idkode_tindakan_terapi`) REFERENCES `kode_tindakan_terapi` (`idkode_tindakan_terapi`),
  CONSTRAINT `fk_detail_rekam_medis_rekam_medis1` FOREIGN KEY (`idrekam_medis`) REFERENCES `rekam_medis` (`idrekam_medis`),
  CONSTRAINT `fk_detail_rekam_medis_user` FOREIGN KEY (`deleted_by`) REFERENCES `user` (`iduser`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detail_rekam_medis`
--

/*!40000 ALTER TABLE `detail_rekam_medis` DISABLE KEYS */;
INSERT INTO `detail_rekam_medis` VALUES (9,3,13,'test_detail','2025-12-15 18:21:47',NULL),(10,3,13,'test_detail',NULL,NULL),(11,3,19,'test_detail_2',NULL,NULL);
/*!40000 ALTER TABLE `detail_rekam_medis` ENABLE KEYS */;

--
-- Table structure for table `dokter`
--

DROP TABLE IF EXISTS `dokter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dokter` (
  `iddokter` bigint unsigned NOT NULL AUTO_INCREMENT,
  `alamat` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `no_hp` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `bidang_dokter` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `jenis_kelamin` char(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `iduser` bigint NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`iddokter`),
  UNIQUE KEY `dokter_iduser_unique` (`iduser`),
  CONSTRAINT `dokter_iduser_foreign` FOREIGN KEY (`iduser`) REFERENCES `user` (`iduser`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dokter`
--

/*!40000 ALTER TABLE `dokter` DISABLE KEYS */;
INSERT INTO `dokter` VALUES (1,'test_alamat','012345678','test_keahlian','M',8,'2025-11-25 19:24:38','2025-11-25 19:24:38');
/*!40000 ALTER TABLE `dokter` ENABLE KEYS */;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;

--
-- Table structure for table `jenis_hewan`
--

DROP TABLE IF EXISTS `jenis_hewan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jenis_hewan` (
  `idjenis_hewan` int NOT NULL AUTO_INCREMENT,
  `nama_jenis_hewan` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`idjenis_hewan`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jenis_hewan`
--

/*!40000 ALTER TABLE `jenis_hewan` DISABLE KEYS */;
INSERT INTO `jenis_hewan` VALUES (1,'Anjing (Canis lupus familiaris)'),(2,'Kucing (Felis catus)'),(3,'Kelinci (Oryctolagus cuniculus)'),(4,'Burung'),(5,'Reptil'),(6,'Rodent / Hewan Kecil');
/*!40000 ALTER TABLE `jenis_hewan` ENABLE KEYS */;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;

--
-- Table structure for table `kategori`
--

DROP TABLE IF EXISTS `kategori`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kategori` (
  `idkategori` int NOT NULL,
  `nama_kategori` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`idkategori`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kategori`
--

/*!40000 ALTER TABLE `kategori` DISABLE KEYS */;
INSERT INTO `kategori` VALUES (1,'Vaksinasi'),(2,'Bedah / Operasi'),(3,'Cairan infus'),(4,'Terapi Injeksi'),(5,'Terapi Oral'),(6,'Diagnostik'),(7,'Rawat Inap'),(8,'Lain-lain'),(9,'test');
/*!40000 ALTER TABLE `kategori` ENABLE KEYS */;

--
-- Table structure for table `kategori_klinis`
--

DROP TABLE IF EXISTS `kategori_klinis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kategori_klinis` (
  `idkategori_klinis` int NOT NULL,
  `nama_kategori_klinis` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`idkategori_klinis`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kategori_klinis`
--

/*!40000 ALTER TABLE `kategori_klinis` DISABLE KEYS */;
INSERT INTO `kategori_klinis` VALUES (1,'Terapi'),(2,'Tindakan'),(3,'test');
/*!40000 ALTER TABLE `kategori_klinis` ENABLE KEYS */;

--
-- Table structure for table `kode_tindakan_terapi`
--

DROP TABLE IF EXISTS `kode_tindakan_terapi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kode_tindakan_terapi` (
  `idkode_tindakan_terapi` int NOT NULL AUTO_INCREMENT,
  `kode` varchar(5) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `deskripsi_tindakan_terapi` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `idkategori` int NOT NULL,
  `idkategori_klinis` int NOT NULL,
  PRIMARY KEY (`idkode_tindakan_terapi`),
  KEY `fk_kode_tindakan_terapi_kategori1_idx` (`idkategori`),
  KEY `fk_kode_tindakan_terapi_kategori_klinis1_idx` (`idkategori_klinis`),
  CONSTRAINT `fk_kode_tindakan_terapi_kategori1` FOREIGN KEY (`idkategori`) REFERENCES `kategori` (`idkategori`),
  CONSTRAINT `fk_kode_tindakan_terapi_kategori_klinis1` FOREIGN KEY (`idkategori_klinis`) REFERENCES `kategori_klinis` (`idkategori_klinis`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kode_tindakan_terapi`
--

/*!40000 ALTER TABLE `kode_tindakan_terapi` DISABLE KEYS */;
INSERT INTO `kode_tindakan_terapi` VALUES (1,'T01','Vaksinasi Rabies',1,1),(2,'T02','Vaksinasi Polivalen (DHPPi/L untuk anjing)',1,1),(3,'T03','Vaksinasi Panleukopenia / Tricat kucing',1,1),(4,'T04','Vaksinasi lainnya (bordetella, influenza, dsb.)',1,1),(5,'T05','Sterilisasi jantan',2,2),(6,'T06','Sterilisasi betina',2,2),(9,'T07','Minor surgery (luka, abses)',2,2),(10,'T08','Major surgery (laparotomi, tumor)',2,2),(11,'T09','Infus intravena cairan kristaloid',3,1),(12,'T10','Infus intravena cairan koloid',3,1),(13,'T11','Antibiotik injeksi',4,1),(14,'T12','Antiparasit injeksi',4,1),(15,'T13','Antiemetik / gastroprotektor',4,1),(16,'T14','Analgesik / antiinflamasi',4,1),(17,'T15','Kortikosteroid',4,1),(18,'T16','Antibiotik oral',5,1),(19,'T17','Antiparasit oral',5,1),(20,'T18','Vitamin / suplemen',5,1),(21,'T19','Diet khusus',5,1),(22,'T20','Pemeriksaan darah rutin',6,2),(23,'T21','Pemeriksaan kimia darah',6,2),(24,'T22','Pemeriksaan feses / parasitologi',6,2),(25,'T23','Pemeriksaan urin',6,2),(26,'T24','Radiografi (rontgen)',6,2),(27,'T25','USG Abdomen',6,2),(28,'T26','Sitologi / biopsi',6,2),(29,'T27','Rapid test penyakit infeksi',6,2),(30,'T28','Observasi sehari',7,2),(31,'T29','Observasi lebih dari 1 hari',7,2),(32,'T30','Grooming medis',8,2),(33,'T31','Deworming',8,1),(34,'T32','Ektoparasit control',8,1),(38,'test','test',9,3);
/*!40000 ALTER TABLE `kode_tindakan_terapi` ENABLE KEYS */;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'0001_01_01_000000_create_users_table',1),(2,'0001_01_01_000001_create_cache_table',1),(3,'0001_01_01_000002_create_jobs_table',1),(4,'2025_11_02_012214_add_email_verified_at_to_user_table',2),(5,'2025_11_02_012303_add_email_verified_at_to_user_table',2),(6,'2025_11_24_150014_create_temu_dokter_table',3),(7,'2025_11_24_150717_add_temu_dokter_relation_to_rekam_medis',4),(8,'2025_11_25_160112_create_dokter_table',5),(9,'2025_11_25_160131_create_perawat_table',5);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;

--
-- Table structure for table `pemilik`
--

DROP TABLE IF EXISTS `pemilik`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pemilik` (
  `idpemilik` int NOT NULL,
  `no_wa` varchar(45) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `alamat` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `iduser` bigint NOT NULL,
  PRIMARY KEY (`idpemilik`),
  KEY `fk_pemilik_user1_idx` (`iduser`),
  CONSTRAINT `fk_pemilik_user1` FOREIGN KEY (`iduser`) REFERENCES `user` (`iduser`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pemilik`
--

/*!40000 ALTER TABLE `pemilik` DISABLE KEYS */;
INSERT INTO `pemilik` VALUES (3,'0812345678','test_addrs',22),(4,'0812345678','test_addrs',23);
/*!40000 ALTER TABLE `pemilik` ENABLE KEYS */;

--
-- Table structure for table `perawat`
--

DROP TABLE IF EXISTS `perawat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `perawat` (
  `idperawat` bigint unsigned NOT NULL AUTO_INCREMENT,
  `alamat` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `no_hp` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `jenis_kelamin` char(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pendidikan` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `iduser` bigint NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`idperawat`),
  UNIQUE KEY `perawat_iduser_unique` (`iduser`),
  CONSTRAINT `perawat_iduser_foreign` FOREIGN KEY (`iduser`) REFERENCES `user` (`iduser`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `perawat`
--

/*!40000 ALTER TABLE `perawat` DISABLE KEYS */;
INSERT INTO `perawat` VALUES (1,'test_addrs','0812345678','M','test_edu',10,'2025-11-25 19:39:54','2025-11-25 19:39:54');
/*!40000 ALTER TABLE `perawat` ENABLE KEYS */;

--
-- Table structure for table `pet`
--

DROP TABLE IF EXISTS `pet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pet` (
  `idpet` int NOT NULL AUTO_INCREMENT,
  `nama` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tanggal_lahir` date DEFAULT NULL,
  `warna_tanda` varchar(45) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `jenis_kelamin` char(1) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `idpemilik` int NOT NULL,
  `idras_hewan` int NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `deleted_by` bigint DEFAULT NULL,
  PRIMARY KEY (`idpet`),
  KEY `fk_pet_pemilik1_idx` (`idpemilik`),
  KEY `fk_pet_ras_hewan1_idx` (`idras_hewan`),
  KEY `fk_pet_user` (`deleted_by`),
  CONSTRAINT `fk_pet_pemilik1` FOREIGN KEY (`idpemilik`) REFERENCES `pemilik` (`idpemilik`),
  CONSTRAINT `fk_pet_ras_hewan1` FOREIGN KEY (`idras_hewan`) REFERENCES `ras_hewan` (`idras_hewan`),
  CONSTRAINT `fk_pet_user` FOREIGN KEY (`deleted_by`) REFERENCES `user` (`iduser`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pet`
--

/*!40000 ALTER TABLE `pet` DISABLE KEYS */;
INSERT INTO `pet` VALUES (3,'test_pet_2','2000-04-24','test345','M',4,2,NULL,NULL),(5,'test_pet_2','2012-04-24','test_desc','M',4,1,'2025-12-15 17:47:25',6);
/*!40000 ALTER TABLE `pet` ENABLE KEYS */;

--
-- Table structure for table `ras_hewan`
--

DROP TABLE IF EXISTS `ras_hewan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ras_hewan` (
  `idras_hewan` int NOT NULL AUTO_INCREMENT,
  `nama_ras` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `idjenis_hewan` int NOT NULL,
  PRIMARY KEY (`idras_hewan`),
  KEY `fk_ras_hewan_jenis_hewan1_idx` (`idjenis_hewan`),
  CONSTRAINT `fk_ras_hewan_jenis_hewan1` FOREIGN KEY (`idjenis_hewan`) REFERENCES `jenis_hewan` (`idjenis_hewan`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ras_hewan`
--

/*!40000 ALTER TABLE `ras_hewan` DISABLE KEYS */;
INSERT INTO `ras_hewan` VALUES (1,'Golden Retriever 123',1),(2,'Labrador Retriever',1),(3,'German Shepherd',1),(4,'Bulldog (English, French)',1),(5,'Poodle (Toy, Miniature, Standard)',1),(6,'Beagle',1),(7,'Siberian Husky',1),(8,'Shih Tzu',1),(9,'Dachshund',1),(10,'Chihuahua',1),(11,'Persia',2),(12,'Maine Coon',2),(13,'Siamese',2),(14,'Bengal',2),(15,'Sphynx',2),(16,'Scottish Fold',2),(17,'British Shorthair',2),(18,'Anggora',2),(19,'Domestic Shorthair (kampung)',2),(20,'Ragdoll',2),(21,'Holland Lop',3),(22,'Netherland Dwarf',3),(23,'Flemish Giant',3),(24,'Lionhead',3),(25,'Rex',3),(26,'Angora Rabbit',3),(27,'Mini Lop',3),(28,'Lovebird (Agapornis sp.)',4),(29,'Kakatua (Cockatoo)',4),(30,'Parrot / Nuri (Macaw, African Grey, Amazon Parrot)',4),(31,'Kenari (Serinus canaria)',4),(32,'Merpati (Columba livia)',4),(33,'Parkit (Budgerigar / Melopsittacus undulatus)',4),(34,'Jalak (Sturnus sp.)',4),(35,'Kura-kura Sulcata (African spurred tortoise)',5),(36,'Red-Eared Slider (Trachemys scripta elegans)',5),(37,'Leopard Gecko',5),(38,'Iguana hijau',5),(39,'Ball Python',5),(40,'Corn Snake',5),(41,'Hamster (Syrian, Roborovski, Campbell, Winter White)',6),(42,'Guinea Pig (Abyssinian, Peruvian, American Shorthair)',6),(43,'Gerbil',6),(44,'Chinchilla',6);
/*!40000 ALTER TABLE `ras_hewan` ENABLE KEYS */;

--
-- Table structure for table `rekam_medis`
--

DROP TABLE IF EXISTS `rekam_medis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rekam_medis` (
  `idrekam_medis` int NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT NULL,
  `anamnesa` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `temuan_klinis` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `diagnosa` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `idpet` int NOT NULL,
  `dokter_pemeriksa` int NOT NULL,
  `idreservasi_dokter` int DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `deleted_by` bigint DEFAULT NULL,
  PRIMARY KEY (`idrekam_medis`),
  KEY `fk_rekam_medis_pet1_idx` (`idpet`),
  KEY `fk_rekam_medis_role_user1_idx` (`dokter_pemeriksa`),
  KEY `rekam_medis_idreservasi_dokter_index` (`idreservasi_dokter`),
  KEY `rekam_medis_user_foreign_key` (`deleted_by`),
  CONSTRAINT `fk_rekam_medis_pet1` FOREIGN KEY (`idpet`) REFERENCES `pet` (`idpet`),
  CONSTRAINT `rekam_medis_ibfk_1` FOREIGN KEY (`dokter_pemeriksa`) REFERENCES `role_user` (`idrole_user`),
  CONSTRAINT `rekam_medis_idreservasi_dokter_foreign` FOREIGN KEY (`idreservasi_dokter`) REFERENCES `temu_dokter` (`idreservasi_dokter`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `rekam_medis_user_foreign_key` FOREIGN KEY (`deleted_by`) REFERENCES `user` (`iduser`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rekam_medis`
--

/*!40000 ALTER TABLE `rekam_medis` DISABLE KEYS */;
INSERT INTO `rekam_medis` VALUES (3,'2025-12-03 20:44:33','test123','test123','test123',3,14,4,NULL,NULL);
/*!40000 ALTER TABLE `rekam_medis` ENABLE KEYS */;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `idrole` int NOT NULL AUTO_INCREMENT,
  `nama_role` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`idrole`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,'Administrator'),(2,'Dokter'),(3,'Perawat'),(4,'Resepsionis'),(5,'Pemilik');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;

--
-- Table structure for table `role_user`
--

DROP TABLE IF EXISTS `role_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_user` (
  `idrole_user` int NOT NULL AUTO_INCREMENT,
  `iduser` bigint NOT NULL,
  `idrole` int NOT NULL,
  `status` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`idrole_user`),
  KEY `fk_role_user_user_idx` (`iduser`),
  KEY `fk_role_user_role1_idx` (`idrole`),
  CONSTRAINT `fk_role_user_role1` FOREIGN KEY (`idrole`) REFERENCES `role` (`idrole`),
  CONSTRAINT `fk_role_user_user` FOREIGN KEY (`iduser`) REFERENCES `user` (`iduser`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_user`
--

/*!40000 ALTER TABLE `role_user` DISABLE KEYS */;
INSERT INTO `role_user` VALUES (1,6,1,1),(14,8,2,1),(15,10,3,1),(19,9,4,1),(20,23,5,1),(25,7,1,1);
/*!40000 ALTER TABLE `role_user` ENABLE KEYS */;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES ('kuObnB6PAYnrw4R6IpkTmrVN8CxHSuaZDOj72c7y',6,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','YTo0OntzOjY6Il90b2tlbiI7czo0MDoiWHg0SnFrM1VCNmZJSmgzTDdvdENIV2QxS3NqVmtLMGJrWWVtS3pXQyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mzg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9kYXRhL3Jla2FtLW1lZGlzIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6Njt9',1765849844);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;

--
-- Table structure for table `temu_dokter`
--

DROP TABLE IF EXISTS `temu_dokter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temu_dokter` (
  `idreservasi_dokter` int NOT NULL AUTO_INCREMENT,
  `no_urut` int DEFAULT NULL,
  `waktu_daftar` timestamp NULL DEFAULT NULL,
  `status` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `idrole_user` int NOT NULL,
  PRIMARY KEY (`idreservasi_dokter`),
  KEY `fk_temu_dokter_role_user1_idx` (`idrole_user`),
  CONSTRAINT `temu_dokter_idrole_user_foreign` FOREIGN KEY (`idrole_user`) REFERENCES `role_user` (`idrole_user`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temu_dokter`
--

/*!40000 ALTER TABLE `temu_dokter` DISABLE KEYS */;
INSERT INTO `temu_dokter` VALUES (2,1,'2025-11-27 23:47:00','0',14),(3,1,'2025-12-02 23:39:00','1',14),(4,2,'2025-12-02 22:40:00','2',14);
/*!40000 ALTER TABLE `temu_dokter` ENABLE KEYS */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `iduser` bigint NOT NULL AUTO_INCREMENT,
  `nama` varchar(500) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(300) COLLATE utf8mb4_general_ci NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `deleted_by` bigint DEFAULT NULL,
  PRIMARY KEY (`iduser`),
  UNIQUE KEY `email` (`email`),
  KEY `fk_user_user` (`deleted_by`),
  CONSTRAINT `fk_user_user` FOREIGN KEY (`deleted_by`) REFERENCES `user` (`iduser`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (6,'admin','admin@mail.com','2025-11-03 02:46:44','$2y$12$NzqjxRhHjvRBzVO9/Ux7Je.Vy5v3AaUyH9eF9nfjfi3W4KNdf6.1i',NULL,NULL),(7,'Admin Test','admin@test.com',NULL,'$2y$12$NzqjxRhHjvRBzVO9/Ux7Je.Vy5v3AaUyH9eF9nfjfi3W4KNdf6.1i',NULL,NULL),(8,'Dokter Test','dokter@test.com','2025-11-02 19:20:25','$2y$12$NzqjxRhHjvRBzVO9/Ux7Je.Vy5v3AaUyH9eF9nfjfi3W4KNdf6.1i',NULL,NULL),(9,'Resepsionis Test','resepsionis@test.com','2025-11-02 19:20:25','$2y$12$NzqjxRhHjvRBzVO9/Ux7Je.Vy5v3AaUyH9eF9nfjfi3W4KNdf6.1i',NULL,NULL),(10,'Perawat Test','perawat@test.com','2025-11-02 19:20:25','$2y$12$NzqjxRhHjvRBzVO9/Ux7Je.Vy5v3AaUyH9eF9nfjfi3W4KNdf6.1i',NULL,NULL),(15,'test','test@test.com',NULL,'$2y$12$NzqjxRhHjvRBzVO9/Ux7Je.Vy5v3AaUyH9eF9nfjfi3W4KNdf6.1i',NULL,NULL),(22,'test123','test123@mail.com',NULL,'$2y$12$/zanTgo5tkvy.AcDvgq5cO8YJSCzXUj0LHsbojzCwusQl12MWWV2a',NULL,NULL),(23,'test1234','test1234@mail.com',NULL,'$2y$12$4bFFGFb.cRE17A9a0QFOo.OQZ4lPULE1FJFtPE92hwtaH1dEK/Wri',NULL,NULL),(24,'testtesttest','test@test.test',NULL,'$2y$12$Lwd3pYKmzWusTYZEwsFroOQT1giSoBwQvorKSt8EUG3K81GhvcBm6','2025-12-01 19:21:59',6);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

--
-- Dumping routines for database 'laravel'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-24 22:16:32
