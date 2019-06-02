-- MySQL dump 10.13  Distrib 8.0.16, for Linux (x86_64)
--
-- Host: localhost    Database: cs309_project
-- ------------------------------------------------------
-- Server version	8.0.16

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8mb4 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Answer`
--

DROP TABLE IF EXISTS `Answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `Answer` (
  `answer_id` int(11) NOT NULL AUTO_INCREMENT,
  `upvotes` int(11) DEFAULT '0',
  `downvotes` int(11) DEFAULT '0',
  `answered_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `content` text,
  `is_solution` int(11) DEFAULT '0',
  `question_id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  PRIMARY KEY (`question_id`,`answer_id`),
  KEY `userid` (`userid`),
  KEY `answer_id` (`answer_id`),
  CONSTRAINT `Answer_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `Question` (`question_id`) ON DELETE CASCADE,
  CONSTRAINT `Answer_ibfk_2` FOREIGN KEY (`userid`) REFERENCES `User` (`userid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Answer`
--

LOCK TABLES `Answer` WRITE;
/*!40000 ALTER TABLE `Answer` DISABLE KEYS */;
/*!40000 ALTER TABLE `Answer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Answer_votes`
--

DROP TABLE IF EXISTS `Answer_votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `Answer_votes` (
  `question_id` int(11) NOT NULL,
  `answer_id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  PRIMARY KEY (`question_id`,`answer_id`,`userid`),
  KEY `userid` (`userid`),
  CONSTRAINT `Answer_votes_ibfk_1` FOREIGN KEY (`question_id`, `answer_id`) REFERENCES `Answer` (`question_id`, `answer_id`),
  CONSTRAINT `Answer_votes_ibfk_2` FOREIGN KEY (`userid`) REFERENCES `User` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Answer_votes`
--

LOCK TABLES `Answer_votes` WRITE;
/*!40000 ALTER TABLE `Answer_votes` DISABLE KEYS */;
/*!40000 ALTER TABLE `Answer_votes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Question`
--

DROP TABLE IF EXISTS `Question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `Question` (
  `question_id` int(11) NOT NULL AUTO_INCREMENT,
  `status` int(11) DEFAULT NULL,
  `upvotes` int(11) DEFAULT '0',
  `downvotes` int(11) DEFAULT '0',
  `asked_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `content` text,
  `userid` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  PRIMARY KEY (`question_id`),
  KEY `userid` (`userid`),
  CONSTRAINT `Question_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `User` (`userid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Question`
--

LOCK TABLES `Question` WRITE;
/*!40000 ALTER TABLE `Question` DISABLE KEYS */;
/*!40000 ALTER TABLE `Question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Question_votes`
--

DROP TABLE IF EXISTS `Question_votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `Question_votes` (
  `question_id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  PRIMARY KEY (`question_id`,`userid`),
  KEY `userid` (`userid`),
  CONSTRAINT `Question_votes_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `Question` (`question_id`) ON DELETE CASCADE,
  CONSTRAINT `Question_votes_ibfk_2` FOREIGN KEY (`userid`) REFERENCES `User` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Question_votes`
--

LOCK TABLES `Question_votes` WRITE;
/*!40000 ALTER TABLE `Question_votes` DISABLE KEYS */;
/*!40000 ALTER TABLE `Question_votes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Tag`
--

DROP TABLE IF EXISTS `Tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `Tag` (
  `Tagname` char(30) NOT NULL,
  `question_count` int(11) DEFAULT '0',
  `Description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Tagname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tag`
--

LOCK TABLES `Tag` WRITE;
/*!40000 ALTER TABLE `Tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `Tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Tag_relation`
--

DROP TABLE IF EXISTS `Tag_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `Tag_relation` (
  `Tagname1` char(10) NOT NULL,
  `Tagname2` char(10) NOT NULL,
  PRIMARY KEY (`Tagname1`,`Tagname2`),
  KEY `Tagname2` (`Tagname2`),
  CONSTRAINT `Tag_relation_ibfk_1` FOREIGN KEY (`Tagname1`) REFERENCES `Tag` (`Tagname`) ON DELETE CASCADE,
  CONSTRAINT `Tag_relation_ibfk_2` FOREIGN KEY (`Tagname2`) REFERENCES `Tag` (`Tagname`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tag_relation`
--

LOCK TABLES `Tag_relation` WRITE;
/*!40000 ALTER TABLE `Tag_relation` DISABLE KEYS */;
/*!40000 ALTER TABLE `Tag_relation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Tagged`
--

DROP TABLE IF EXISTS `Tagged`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `Tagged` (
  `Tagname` char(10) NOT NULL,
  `question_id` int(11) NOT NULL,
  PRIMARY KEY (`Tagname`,`question_id`),
  KEY `question_id` (`question_id`),
  CONSTRAINT `Tagged_ibfk_1` FOREIGN KEY (`Tagname`) REFERENCES `Tag` (`Tagname`) ON DELETE CASCADE,
  CONSTRAINT `Tagged_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `Question` (`question_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tagged`
--

LOCK TABLES `Tagged` WRITE;
/*!40000 ALTER TABLE `Tagged` DISABLE KEYS */;
/*!40000 ALTER TABLE `Tagged` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_tagged_insert` BEFORE INSERT ON `Tagged` FOR EACH ROW BEGIN
    IF EXISTS(select tagname from Tag where tagname = NEW.tagname) THEN
        Update Tag set question_count = question_count + 1 where tagname = NEW.tagname; 
    ELSE
        insert into Tag(tagname, question_count, description) values (NEW.tagname, 1, "");
    END IF;    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `User` (
  `email` varchar(40) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `username` varchar(20) NOT NULL,
  `userid` int(11) NOT NULL AUTO_INCREMENT,
  `reputation` int(11) DEFAULT '0',
  `user_since` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`userid`),
  UNIQUE KEY `userid` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-05-16 23:31:49
