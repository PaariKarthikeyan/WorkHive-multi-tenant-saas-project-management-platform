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
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `role_id` int NOT NULL,
  `first_name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `secondary_email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `two_factor_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `reset_token` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reset_token_expiry` datetime DEFAULT NULL,
  `avatar_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bio` text COLLATE utf8mb4_unicode_ci,
  `department` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `job_title` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `timezone` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT 'Asia/Kolkata',
  `date_of_birth` date DEFAULT NULL,
  `gender` enum('male','female','non_binary','prefer_not_to_say') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `linkedin_url` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notification_email` tinyint(1) NOT NULL DEFAULT '1',
  `notification_sms` tinyint(1) NOT NULL DEFAULT '0',
  `theme_preference` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_users_tenant` (`tenant_id`),
  KEY `idx_users_role` (`role_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`tenant_id`) ON DELETE CASCADE,
  CONSTRAINT `users_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,1,1,'Arun','Kumar','arun@techcorp.com','$2a$12$8v63RZJtiB53nqSQFyr6COzwIK/iHYU3VRh1tK5UJWu93105.wZ6.',1,'2026-03-30 13:44:10','2026-04-01 14:49:36',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,'Coimbatore, India','Asia/Kolkata',NULL,'male',NULL,1,0,'dark'),(2,1,2,'Meena','Sharma','meena@techcorp.com','$2a$12$8v63RZJtiB53nqSQFyr6COzwIK/iHYU3VRh1tK5UJWu93105.wZ6.',1,'2026-03-30 13:44:10','2026-03-30 14:19:54',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Asia/Kolkata',NULL,NULL,NULL,1,0,'system'),(3,1,2,'Ravi','Krishnan','ravi@techcorp.com','$2a$12$8v63RZJtiB53nqSQFyr6COzwIK/iHYU3VRh1tK5UJWu93105.wZ6.',1,'2026-03-30 13:44:10','2026-03-30 14:19:54',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Asia/Kolkata',NULL,NULL,NULL,1,0,'system'),(4,1,3,'Raj','Patel','raj@techcorp.com','$2a$12$8v63RZJtiB53nqSQFyr6COzwIK/iHYU3VRh1tK5UJWu93105.wZ6.',1,'2026-03-30 13:44:10','2026-03-30 14:19:54',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Asia/Kolkata',NULL,NULL,NULL,1,0,'system'),(5,1,3,'Priya','Nair','priya@techcorp.com','$2a$12$8v63RZJtiB53nqSQFyr6COzwIK/iHYU3VRh1tK5UJWu93105.wZ6.',1,'2026-03-30 13:44:10','2026-03-30 14:19:54',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Asia/Kolkata',NULL,NULL,NULL,1,0,'system'),(6,1,3,'Suresh','Babu','suresh@techcorp.com','$2a$12$8v63RZJtiB53nqSQFyr6COzwIK/iHYU3VRh1tK5UJWu93105.wZ6.',1,'2026-03-30 13:44:10','2026-03-30 14:19:54',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Asia/Kolkata',NULL,NULL,NULL,1,0,'system'),(7,1,3,'Anitha','Reddy','anitha@techcorp.com','$2a$12$8v63RZJtiB53nqSQFyr6COzwIK/iHYU3VRh1tK5UJWu93105.wZ6.',1,'2026-03-30 13:44:10','2026-03-30 14:19:54',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Asia/Kolkata',NULL,NULL,NULL,1,0,'system'),(8,1,3,'Deepak','Menon','deepak@techcorp.com','$2a$12$8v63RZJtiB53nqSQFyr6COzwIK/iHYU3VRh1tK5UJWu93105.wZ6.',1,'2026-03-30 13:44:10','2026-03-30 14:19:54',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Asia/Kolkata',NULL,NULL,NULL,1,0,'system'),(9,2,1,'Kavya','Iyer','kavya@innovatech.com','$2a$12$8v63RZJtiB53nqSQFyr6COzwIK/iHYU3VRh1tK5UJWu93105.wZ6.',1,'2026-03-30 13:44:10','2026-03-30 14:19:54',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Asia/Kolkata',NULL,NULL,NULL,1,0,'system'),(10,2,2,'Sanjay','Verma','sanjay@innovatech.com','$2a$12$8v63RZJtiB53nqSQFyr6COzwIK/iHYU3VRh1tK5UJWu93105.wZ6.',1,'2026-03-30 13:44:10','2026-03-30 14:19:54',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Asia/Kolkata',NULL,NULL,NULL,1,0,'system'),(11,2,2,'Lakshmi','Pillai','lakshmi@innovatech.com','$2a$12$8v63RZJtiB53nqSQFyr6COzwIK/iHYU3VRh1tK5UJWu93105.wZ6.',1,'2026-03-30 13:44:10','2026-03-30 14:19:54',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Asia/Kolkata',NULL,NULL,NULL,1,0,'system'),(12,2,3,'Arjun','Singh','arjun@innovatech.com','$2a$12$8v63RZJtiB53nqSQFyr6COzwIK/iHYU3VRh1tK5UJWu93105.wZ6.',1,'2026-03-30 13:44:10','2026-03-30 14:19:54',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Asia/Kolkata',NULL,NULL,NULL,1,0,'system'),(13,2,3,'Divya','Nambiar','divya@innovatech.com','$2a$12$8v63RZJtiB53nqSQFyr6COzwIK/iHYU3VRh1tK5UJWu93105.wZ6.',1,'2026-03-30 13:44:10','2026-03-30 14:19:54',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Asia/Kolkata',NULL,NULL,NULL,1,0,'system'),(14,2,3,'Nikhil','Gupta','nikhil@innovatech.com','$2a$12$8v63RZJtiB53nqSQFyr6COzwIK/iHYU3VRh1tK5UJWu93105.wZ6.',1,'2026-03-30 13:44:10','2026-03-30 14:19:54',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Asia/Kolkata',NULL,NULL,NULL,1,0,'system'),(15,2,3,'Pooja','Mishra','pooja@innovatech.com','$2a$12$8v63RZJtiB53nqSQFyr6COzwIK/iHYU3VRh1tK5UJWu93105.wZ6.',1,'2026-03-30 13:44:10','2026-03-30 14:19:54',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Asia/Kolkata',NULL,NULL,NULL,1,0,'system'),(16,3,1,'Vikram','Desai','vikram@startupnest.com','$2a$12$8v63RZJtiB53nqSQFyr6COzwIK/iHYU3VRh1tK5UJWu93105.wZ6.',1,'2026-03-30 13:44:10','2026-03-30 14:19:54',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Asia/Kolkata',NULL,NULL,NULL,1,0,'system'),(17,3,2,'Shreya','Joshi','shreya@startupnest.com','$2a$12$8v63RZJtiB53nqSQFyr6COzwIK/iHYU3VRh1tK5UJWu93105.wZ6.',1,'2026-03-30 13:44:10','2026-03-30 14:19:54',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Asia/Kolkata',NULL,NULL,NULL,1,0,'system'),(18,3,3,'Kiran','Bhat','kiran@startupnest.com','$2a$12$8v63RZJtiB53nqSQFyr6COzwIK/iHYU3VRh1tK5UJWu93105.wZ6.',1,'2026-03-30 13:44:10','2026-03-30 14:19:54',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Asia/Kolkata',NULL,NULL,NULL,1,0,'system'),(19,1,3,'Mithun','Surya','mithun@techcorp.com','$2b$12$36F7Qykm/vxMwtbCde9PBO1PYdHSivY7ZuyOr./IMG21oXhtNN8Q.',1,'2026-03-30 15:01:28','2026-04-02 12:24:11','kymithunsuryakkumarasamy@gmail.com','1234567890',1,NULL,NULL,NULL,NULL,'MSC ',NULL,'Coimbatore','Asia/Kolkata','2006-11-13','male','https://linkedin.com/Mithunsurya-Kumarasamy',1,0,'system'),(20,4,1,'Skibidi','Vel','paari@paari.com','$2b$12$zT0SQfExRVlOcN3aE.mgRe/mxfqRnBHMt3/LSrb.dCuUf..q4DYIG',1,'2026-03-31 13:25:23','2026-04-03 21:05:11','paari22062007@gmail.com','7530047357',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Asia/Kolkata',NULL,NULL,NULL,1,0,'system'),(22,5,1,'Varun','San','pari@varun.com','$2b$12$T4TMawnxCTzxDHf9x3HUF.Hc1ypMCw.qNmcBA2FHG6xyCKA72XdKC',1,'2026-04-03 20:49:30','2026-04-03 20:49:30',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Asia/Kolkata',NULL,NULL,NULL,1,0,'system'),(23,5,2,'Jithendra','','jith@varun.com','$2b$12$kTYuzufPCZ7MphO1pR6mL.qjLl132GNkQCg1P9Uq3/bPe3dWPjrVq',1,'2026-04-03 20:52:17','2026-04-03 20:52:17',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Asia/Kolkata',NULL,NULL,NULL,1,0,'system'),(25,5,3,'Harshith','','harsh@varun.com','$2b$12$QNA9zdYMQsTxVZo07qCYo.U.ekJKnpqyk/mejU82xDtomewsPaGnC',1,'2026-04-03 22:30:02','2026-04-03 22:30:02',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Asia/Kolkata',NULL,NULL,NULL,1,0,'system');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
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
