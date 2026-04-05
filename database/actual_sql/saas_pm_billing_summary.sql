-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: saas_pm
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `billing_summary`
--

DROP TABLE IF EXISTS `billing_summary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `billing_summary` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `billing_period` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `base_charge` decimal(10,2) NOT NULL DEFAULT '0.00',
  `usage_charge` decimal(10,2) NOT NULL DEFAULT '0.00',
  `storage_gb` decimal(8,2) NOT NULL DEFAULT '0.00',
  `api_calls_used` int NOT NULL DEFAULT '0',
  `total_due` decimal(10,2) NOT NULL DEFAULT '0.00',
  `status` enum('pending','paid','overdue') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `period_start` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `period_end` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_billing_tenant` (`tenant_id`),
  CONSTRAINT `billing_summary_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`tenant_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_billing_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`tenant_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billing_summary`
--

LOCK TABLES `billing_summary` WRITE;
/*!40000 ALTER TABLE `billing_summary` DISABLE KEYS */;
INSERT INTO `billing_summary` VALUES (1,1,'2026-01',299.00,45.50,12.30,18400,344.50,'paid','2026-03-30 13:44:10','2026-04-04 16:09:24',NULL),(2,1,'2026-02',299.00,52.00,14.10,21200,351.00,'paid','2026-03-30 13:44:10','2026-04-04 16:09:24',NULL),(3,1,'2026-03',299.00,61.25,15.80,24500,360.25,'pending','2026-03-30 13:44:10','2026-04-04 16:09:24',NULL),(4,2,'2026-01',999.00,120.00,45.20,68000,1119.00,'paid','2026-03-30 13:44:10','2026-04-04 16:09:24',NULL),(5,2,'2026-02',999.00,134.50,48.60,72300,1133.50,'paid','2026-03-30 13:44:10','2026-04-04 16:09:24',NULL),(6,2,'2026-03',999.00,148.75,51.00,78900,1147.75,'paid','2026-03-30 13:44:10','2026-04-04 16:09:24',NULL),(7,3,'2026-01',0.00,0.00,1.20,850,0.00,'paid','2026-03-30 13:44:10','2026-04-04 16:09:24',NULL),(8,3,'2026-02',0.00,0.00,1.50,1020,0.00,'paid','2026-03-30 13:44:10','2026-04-04 16:09:24',NULL),(9,3,'2026-03',0.00,0.00,1.80,1340,0.00,'pending','2026-03-30 13:44:10','2026-04-04 16:09:24',NULL),(17,1,'2026-04',299.00,74.00,0.00,8,373.00,'pending','2026-04-02 18:58:00','2026-04-04 16:09:24',NULL),(18,2,'2026-04',2499.00,63.00,0.00,6,2562.00,'pending','2026-04-02 18:58:00','2026-04-04 16:09:24',NULL),(19,3,'2026-04',0.00,21.50,0.00,3,21.50,'pending','2026-04-02 18:58:00','2026-04-04 16:09:24',NULL),(20,4,'2026-04',0.00,0.00,0.00,0,0.00,'pending','2026-04-02 18:58:00','2026-04-04 16:09:24',NULL),(21,5,'2026-04',2499.00,0.00,0.00,0,2499.00,'pending','2026-04-03 21:54:13','2026-04-04 16:09:24',NULL);
/*!40000 ALTER TABLE `billing_summary` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-05 12:56:54
