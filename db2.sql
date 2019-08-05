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
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Answer_Upvotes`
--

DROP TABLE IF EXISTS `Answer_Upvotes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `Answer_Upvotes` (
  `question_id` int(11) NOT NULL,
  `answer_id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  PRIMARY KEY (`question_id`,`answer_id`,`userid`),
  KEY `userid` (`userid`),
  CONSTRAINT `Answer_Upvotes_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `Question` (`question_id`),
  CONSTRAINT `Answer_Upvotes_ibfk_2` FOREIGN KEY (`userid`) REFERENCES `User` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `insertAvote` BEFORE INSERT ON `Answer_votes` FOR EACH ROW BEGIN
    IF (NEW.type = 0) THEN
        Update User set User.reputation = User.reputation + 2 where User.userid=(select userid from Answer where Answer.question_id = NEW.question_id and Answer.answer_id = NEW.answer_id); 
        Update Answer set Answer.upvotes = Answer.upvotes + 1 where Answer.question_id = NEW.question_id and Answer.answer_id = NEW.answer_id;
    ELSE
        Update User set User.reputation = User.reputation - 1 where User.userid=(select userid from Answer where Answer.question_id = NEW.question_id and Answer.answer_id = NEW.answer_id); 
        Update Answer set Answer.downvotes = Answer.downvotes + 1 where Answer.question_id = NEW.question_id and Answer.answer_id = NEW.answer_id;
    END IF;    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `deleteAvote` BEFORE DELETE ON `Answer_votes` FOR EACH ROW BEGIN
    IF (OLD.type = 0) THEN
        Update User set User.reputation = User.reputation - 2 where User.userid=(select userid from Answer where Answer.question_id = OLD.question_id and Answer.answer_id = OLD.answer_id); 
        Update Answer set Answer.upvotes = Answer.upvotes - 1 where Answer.question_id = OLD.question_id and Answer.answer_id = OLD.answer_id;
    ELSE
        Update User set User.reputation = User.reputation + 1 where User.userid=(select userid from Answer where Answer.question_id = OLD.question_id and Answer.answer_id = OLD.answer_id); 
        Update Answer set Answer.downvotes = Answer.downvotes - 1 where Answer.question_id = OLD.question_id and Answer.answer_id = OLD.answer_id;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Moderator`
--

DROP TABLE IF EXISTS `Moderator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `Moderator` (
  `userid` int(11) NOT NULL,
  `moderator_since` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`userid`),
  CONSTRAINT `Moderator_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `User` (`userid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Question_Upvotes`
--

DROP TABLE IF EXISTS `Question_Upvotes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `Question_Upvotes` (
  `question_id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  PRIMARY KEY (`question_id`,`userid`),
  KEY `userid` (`userid`),
  CONSTRAINT `Question_Upvotes_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `Question` (`question_id`) ON DELETE CASCADE,
  CONSTRAINT `Question_Upvotes_ibfk_2` FOREIGN KEY (`userid`) REFERENCES `User` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `insertQvote` BEFORE INSERT ON `Question_votes` FOR EACH ROW BEGIN     IF (NEW.type = 0) THEN         Update User set User.reputation = User.reputation + 2 where User.userid=(select userid from Question where Question.question_id = NEW.question_id);          Update Question set Question.upvotes = Question.upvotes + 1 where Question.question_id = NEW.question_id;     ELSE         Update User set User.reputation = User.reputation - 1 where User.userid=(select userid from Question where Question.question_id = NEW.question_id);         Update Question set Question.downvotes = Question.downvotes + 1 where Question.question_id = NEW.question_id;     END IF;     END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `deleteQvote` BEFORE DELETE ON `Question_votes` FOR EACH ROW BEGIN
    IF (OLD.type = 0) THEN
        Update User set User.reputation = User.reputation - 2 where User.userid=(select userid from Question where Question.question_id = OLD.question_id); 
        Update Question set Question.upvotes = Question.upvotes - 1 where Question.question_id = OLD.question_id;
    ELSE
        Update User set User.reputation = User.reputation + 1 where User.userid=(select userid from Question where Question.question_id = OLD.question_id);
        Update Question set Question.downvotes = Question.downvotes - 1 where Question.question_id = OLD.question_id;
    END IF;    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'cs309_project'
--
/*!50003 DROP PROCEDURE IF EXISTS `AnswerVote` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `AnswerVote`(IN uid INT, IN qid INT, IN aid INT, IN type INT)
BEGIN 
    IF EXISTS(select * from Answer_votes A where A.userid=uid and A.question_id=qid and A.answer_id=aid)
    THEN delete from Answer_votes A where A.userid=uid and A.question_id=qid and A.answer_id=aid;
    ELSE insert into Answer_votes values (qid, aid, uid, type); 
    END IF; 
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `QuestionVote` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `QuestionVote`(IN uid INT, IN qid INT, IN type INT)
BEGIN IF EXISTS(select * from Question_votes Q where Q.userid=uid and Q.question_id=qid) THEN delete from Question_votes Q where Q.userid=uid and Q.question_id=qid; ELSE insert into Question_votes values (qid, uid, type); END IF; END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-05-30  0:37:06
