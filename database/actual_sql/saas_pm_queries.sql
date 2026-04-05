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
-- Table structure for table `queries`
--

DROP TABLE IF EXISTS `queries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `queries` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `employee_id` int NOT NULL,
  `manager_id` int NOT NULL,
  `subject` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `reply` text COLLATE utf8mb4_unicode_ci,
  `is_answered` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `tenant_id` (`tenant_id`),
  KEY `idx_queries_employee` (`employee_id`),
  KEY `idx_queries_manager` (`manager_id`),
  CONSTRAINT `queries_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`tenant_id`) ON DELETE CASCADE,
  CONSTRAINT `queries_ibfk_2` FOREIGN KEY (`employee_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `queries_ibfk_3` FOREIGN KEY (`manager_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `queries`
--

LOCK TABLES `queries` WRITE;
/*!40000 ALTER TABLE `queries` DISABLE KEYS */;
INSERT INTO `queries` VALUES (1,1,4,2,'Deadline extension for Login Unit Tests','Hi Meena, the jest setup took longer than expected due to module conflicts. Can the deadline be extended by 5 days?','Okay',1,'2026-03-30 13:44:10'),(2,1,5,2,'Missing design specs for Dashboard Layout','The Figma file shared does not include mobile breakpoint specs. Where can I find them?','Sorry Priya! I have added the mobile specs in the v3 Figma link shared in the project channel.',1,'2026-03-30 13:44:10'),(3,1,7,3,'Chart.js version compatibility issue','Chart.js v4 is breaking with our current Alpine.js setup. Should I downgrade to v3?',NULL,0,'2026-03-30 13:44:10'),(4,1,8,3,'No access to staging database','I cannot connect to the staging DB for QA testing. Can you check my permissions?','Fixed! Your user was missing the SELECT grant. Should work now.',1,'2026-03-30 13:44:10'),(5,2,12,10,'Docker build failing on M1 Mac','The Dockerfile for the auth service fails on ARM architecture. Getting platform mismatch error.','Add --platform=linux/amd64 to the FROM line. Updated Dockerfile pushed to the repo.',1,'2026-03-30 13:44:10'),(6,2,15,11,'Unclear requirements for Tamil language form','The feedback form spec does not define whether right-to-left support is needed for Tamil text input. Please clarify.',NULL,0,'2026-03-30 13:44:10'),(7,3,18,17,'Which hosting platform for MVP launch?','Should we deploy on Vercel + PlanetScale or a traditional VPS? What is the budget?','Going with Railway for backend and Vercel for frontend. Monthly budget is around ₹3000.',1,'2026-03-30 13:44:10'),(8,1,4,2,'Clarification of the project','Answer quickly',NULL,0,'2026-04-02 19:13:09');
/*!40000 ALTER TABLE `queries` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-05 12:56:53
