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
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `type` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `data` json DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_notifications_user` (`user_id`),
  KEY `idx_notifications_unread` (`user_id`,`is_read`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,4,'task_assigned','New Task Assigned','You have been assigned: Design Login Page UI','{\"task_id\": 1}',1,'2026-03-30 13:44:10'),(2,4,'task_assigned','New Task Assigned','You have been assigned: Write Unit Tests for Login','{\"task_id\": 4}',0,'2026-03-30 13:44:10'),(3,4,'query_replied','Query Answered','Meena replied to your query about deadline extension','{\"query_id\": 1}',1,'2026-03-30 13:44:10'),(4,5,'task_assigned','New Task Assigned','You have been assigned: Build Dashboard Layout','{\"task_id\": 2}',1,'2026-03-30 13:44:10'),(5,5,'task_assigned','New Task Assigned','You have been assigned: Build ETL Triggers','{\"task_id\": 5}',1,'2026-03-30 13:44:10'),(6,5,'query_replied','Query Answered','Meena replied to your Figma specs query','{\"query_id\": 2}',0,'2026-03-30 13:44:10'),(7,2,'query_raised','New Query from Raj','Raj raised a query about deadline extension','{\"query_id\": 1}',1,'2026-03-30 13:44:10'),(8,2,'query_raised','New Query from Priya','Priya raised a query about Figma specs','{\"query_id\": 2}',1,'2026-03-30 13:44:10'),(9,2,'task_completed','Task Completed','Raj completed: Design Login Page UI','{\"task_id\": 1}',1,'2026-03-30 13:44:10'),(10,6,'task_assigned','New Task Assigned','You have been assigned: Integrate Auth API','{\"task_id\": 3}',1,'2026-03-30 13:44:10'),(11,6,'project_update','Project Status Changed','Customer Portal Redesign progress updated to 45%','{\"project_id\": 1}',0,'2026-03-30 13:44:10'),(12,12,'task_assigned','New Task Assigned','You have been assigned: Data Pipeline Setup','{\"task_id\": 13}',1,'2026-03-30 13:44:10'),(13,12,'task_assigned','New Task Assigned','You have been assigned: Write Dockerfiles','{\"task_id\": 17}',1,'2026-03-30 13:44:10'),(14,12,'task_completed','Task Marked Complete','Data Pipeline Setup has been marked as completed','{\"task_id\": 13}',1,'2026-03-30 13:44:10'),(15,12,'query_replied','Query Answered','Sanjay replied to your Docker M1 query','{\"query_id\": 5}',1,'2026-03-30 13:44:10'),(16,9,'project_created','New Project Created','AI Recommendation Engine project has been created','{\"project_id\": 5}',1,'2026-03-30 13:44:10'),(17,9,'project_created','New Project Created','DevOps CI/CD Pipeline project has been created','{\"project_id\": 6}',1,'2026-03-30 13:44:10'),(18,18,'task_assigned','New Task Assigned','You have been assigned: Setup Project Repository','{\"task_id\": 22}',1,'2026-03-30 13:44:10'),(19,18,'task_assigned','New Task Assigned','You have been assigned: Build Landing Page','{\"task_id\": 23}',1,'2026-03-30 13:44:10'),(20,18,'query_replied','Query Answered','Shreya replied to your hosting platform query','{\"query_id\": 7}',1,'2026-03-30 13:44:10');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
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
