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
-- Table structure for table `activity_logs`
--

DROP TABLE IF EXISTS `activity_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `action` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `entity_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `entity_id` int NOT NULL,
  `actor_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_logs_tenant` (`tenant_id`),
  KEY `idx_logs_entity` (`entity_type`,`entity_id`),
  CONSTRAINT `activity_logs_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`tenant_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_logs`
--

LOCK TABLES `activity_logs` WRITE;
/*!40000 ALTER TABLE `activity_logs` DISABLE KEYS */;
INSERT INTO `activity_logs` VALUES (1,1,'CREATE','project',1,1,'2026-03-30 13:44:10'),(2,1,'CREATE','project',2,1,'2026-03-30 13:44:10'),(3,1,'CREATE','project',3,1,'2026-03-30 13:44:10'),(4,1,'CREATE','project',4,1,'2026-03-30 13:44:10'),(5,1,'CREATE','task',1,2,'2026-03-30 13:44:10'),(6,1,'ASSIGN','task',1,2,'2026-03-30 13:44:10'),(7,1,'COMPLETE','task',1,4,'2026-03-30 13:44:10'),(8,1,'CREATE','task',2,2,'2026-03-30 13:44:10'),(9,1,'ASSIGN','task',2,2,'2026-03-30 13:44:10'),(10,1,'COMPLETE','task',5,5,'2026-03-30 13:44:10'),(11,1,'COMPLETE','task',6,6,'2026-03-30 13:44:10'),(12,1,'COMPLETE','task',9,4,'2026-03-30 13:44:10'),(13,1,'COMPLETE','task',11,7,'2026-03-30 13:44:10'),(14,1,'COMPLETE','task',12,8,'2026-03-30 13:44:10'),(15,1,'UPDATE','project',1,2,'2026-03-30 13:44:10'),(16,2,'CREATE','project',5,9,'2026-03-30 13:44:10'),(17,2,'CREATE','project',6,9,'2026-03-30 13:44:10'),(18,2,'CREATE','project',7,9,'2026-03-30 13:44:10'),(19,2,'COMPLETE','task',13,12,'2026-03-30 13:44:10'),(20,2,'COMPLETE','task',17,12,'2026-03-30 13:44:10'),(21,2,'COMPLETE','task',18,13,'2026-03-30 13:44:10'),(22,3,'CREATE','project',8,16,'2026-03-30 13:44:10'),(23,3,'ASSIGN','task',22,17,'2026-03-30 13:44:10'),(24,3,'COMPLETE','task',22,18,'2026-03-30 13:44:10');
/*!40000 ALTER TABLE `activity_logs` ENABLE KEYS */;
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
