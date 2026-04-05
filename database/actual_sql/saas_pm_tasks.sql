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
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tasks` (
  `task_id` int NOT NULL AUTO_INCREMENT,
  `project_id` int NOT NULL,
  `assigned_by` int NOT NULL,
  `assigned_to` int DEFAULT NULL,
  `name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `status` enum('pending','in_progress','completed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `priority` enum('low','medium','high','critical') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'medium',
  `deadline` date DEFAULT NULL,
  `completion_pct` tinyint NOT NULL DEFAULT '0',
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`task_id`),
  KEY `assigned_by` (`assigned_by`),
  KEY `idx_tasks_project` (`project_id`),
  KEY `idx_tasks_assigned_to` (`assigned_to`),
  KEY `idx_tasks_status` (`status`),
  CONSTRAINT `tasks_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`project_id`) ON DELETE CASCADE,
  CONSTRAINT `tasks_ibfk_2` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`user_id`) ON DELETE RESTRICT,
  CONSTRAINT `tasks_ibfk_3` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tasks`
--

LOCK TABLES `tasks` WRITE;
/*!40000 ALTER TABLE `tasks` DISABLE KEYS */;
INSERT INTO `tasks` VALUES (1,1,2,4,'Design Login Page UI','Figma mockup → Alpine.js implementation with validation.','completed','high','2026-02-10',100,NULL,'2026-03-30 13:44:10','2026-03-30 13:44:10'),(2,1,2,5,'Build Dashboard Layout','Responsive dashboard skeleton with sidebar and content area.','completed','high','2026-03-20',100,NULL,'2026-03-30 13:44:10','2026-04-01 11:03:28'),(4,1,2,4,'Write Unit Tests for Login','Jest tests for login form validation and API calls.','completed','medium','2026-04-05',100,NULL,'2026-03-30 13:44:10','2026-03-31 16:59:24'),(11,4,3,7,'Audit Legacy API Endpoints','Document all 48 legacy endpoints with request/response schemas.','completed','high','2025-11-01',100,NULL,'2026-03-30 13:44:10','2026-03-30 13:44:10'),(12,4,3,8,'Deploy Auth Microservice','JWT-based auth microservice on Docker.','completed','critical','2025-12-15',100,NULL,'2026-03-30 13:44:10','2026-03-30 13:44:10'),(13,5,10,12,'Data Pipeline Setup','Apache Airflow DAG for ingesting user behaviour data daily.','completed','critical','2026-02-01',100,NULL,'2026-03-30 13:44:10','2026-03-30 13:44:10'),(14,5,10,13,'Train Collaborative Filter Model','Matrix factorisation model on 1M user interaction records.','in_progress','critical','2026-04-15',55,NULL,'2026-03-30 13:44:10','2026-03-30 13:44:10'),(15,5,10,14,'A/B Test Framework','Design A/B test to compare recommendation algorithms.','pending','high','2026-05-01',0,NULL,'2026-03-30 13:44:10','2026-03-30 13:44:10'),(16,5,11,15,'Recommendation UI Components','Product carousel with personalised recommendation badges.','in_progress','medium','2026-04-30',30,NULL,'2026-03-30 13:44:10','2026-03-30 13:44:10'),(17,6,10,12,'Write Dockerfiles','Multi-stage Dockerfiles for all 6 microservices.','completed','high','2026-02-10',100,NULL,'2026-03-30 13:44:10','2026-03-30 13:44:10'),(18,6,10,13,'Configure GitHub Actions','CI pipeline with lint, test, build, and push to ECR.','completed','critical','2026-02-25',100,NULL,'2026-03-30 13:44:10','2026-03-30 13:44:10'),(19,6,10,14,'Setup Staging Environment','Kubernetes staging namespace with auto-deploy on merge to main.','in_progress','high','2026-03-31',85,NULL,'2026-03-30 13:44:10','2026-03-30 13:44:10'),(20,7,11,15,'Multilingual Form Builder','Dynamic form with 5 language support (EN, HI, TA, TE, ML).','in_progress','medium','2026-04-20',40,NULL,'2026-03-30 13:44:10','2026-03-30 13:44:10'),(21,7,11,12,'Sentiment Analysis Integration','Integrate Hugging Face sentiment API for feedback classification.','pending','high','2026-05-15',0,NULL,'2026-03-30 13:44:10','2026-03-30 13:44:10'),(22,8,17,18,'Setup Project Repository','GitHub monorepo with backend and frontend scaffolding.','completed','medium','2026-03-05',100,NULL,'2026-03-30 13:44:10','2026-03-30 13:44:10'),(23,8,17,18,'Build Landing Page','Responsive landing page with hero, features, and pricing sections.','in_progress','high','2026-03-25',65,NULL,'2026-03-30 13:44:10','2026-03-30 13:44:10'),(24,8,17,18,'Implement User Registration','Register endpoint, email verification, and JWT login.','pending','critical','2026-04-01',0,NULL,'2026-03-30 13:44:10','2026-03-30 13:44:10'),(27,9,23,NULL,'Requirements Planning','Plan an SRS for the project','pending','medium','2026-04-06',0,NULL,'2026-04-03 21:00:36','2026-04-03 21:00:36'),(28,9,23,NULL,'Build business logic','Build backend with nodejs asnd some brain','pending','critical','2026-04-21',0,NULL,'2026-04-03 21:01:41','2026-04-03 21:01:41');
/*!40000 ALTER TABLE `tasks` ENABLE KEYS */;
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
