-- MySQL dump 10.13  Distrib 5.7.44, for Linux (x86_64)
--
-- Host: localhost    Database: joolun_ry
-- ------------------------------------------------------
-- Server version	5.7.44-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `door_lock`
--

DROP TABLE IF EXISTS `door_lock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `door_lock` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '门锁id',
  `yard_sn` varchar(36) NOT NULL COMMENT '园区sn（第三方）',
  `door_guid` varchar(36) NOT NULL COMMENT '门禁id（第三方）',
  `door_name` varchar(255) NOT NULL COMMENT '门禁名称（第三方）',
  `del_flag` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `province_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '省名',
  `city_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '市名',
  `county_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '区名',
  `detail_info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '详情地址',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='门锁表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `door_lock`
--

LOCK TABLES `door_lock` WRITE;
/*!40000 ALTER TABLE `door_lock` DISABLE KEYS */;
INSERT INTO `door_lock` VALUES (1,'786537017627385856','5068416139942690838','测试','0','2025-05-29 10:47:46','2025-05-29 06:03:18',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `door_lock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `door_lock_history`
--

DROP TABLE IF EXISTS `door_lock_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `door_lock_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '门锁id',
  `yard_sn` varchar(36) NOT NULL COMMENT '园区sn（第三方）',
  `door_guid` varchar(36) NOT NULL COMMENT '门禁id（第三方）',
  `operation` varchar(255) NOT NULL COMMENT '操作记录(open：远程开门 reboot：重启)',
  `response` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '第三方接口响应',
  `detail_info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '详情地址',
  `open_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '用户标识',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='门锁操作历史表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `door_lock_history`
--

LOCK TABLES `door_lock_history` WRITE;
/*!40000 ALTER TABLE `door_lock_history` DISABLE KEYS */;
INSERT INTO `door_lock_history` VALUES (1,'786537017627385856','5068416139942690838','open','400',NULL,'o_2jP6zd9W79TNucHkuemFrpFaPg','2025-06-24 16:00:22','2025-06-24 08:00:22'),(2,'786537017627385856','5068416139942690838','open','400',NULL,'o3h6g7c4ISkNNpmE6dHRvWHucSa0','2026-03-20 13:24:21','2026-03-20 05:24:21'),(3,'786537017627385856','5068416139942690838','open','400',NULL,'o3h6g7c4ISkNNpmE6dHRvWHucSa0','2026-03-20 14:14:31','2026-03-20 06:14:31'),(4,'786537017627385856','5068416139942690838','open','400',NULL,'o3h6g7aR3G6tkD7yjm4UsMDM1kWs','2026-03-20 17:11:14','2026-03-20 09:11:14'),(5,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7aR3G6tkD7yjm4UsMDM1kWs','2026-03-20 17:12:18','2026-03-20 09:12:18'),(6,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7ZqNuq4MYyBqMj3LbWJEGoY','2026-03-24 14:16:47','2026-03-24 06:16:47'),(7,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7ZqNuq4MYyBqMj3LbWJEGoY','2026-03-24 14:17:33','2026-03-24 06:17:33'),(8,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7ZqNuq4MYyBqMj3LbWJEGoY','2026-03-24 14:20:14','2026-03-24 06:20:14'),(9,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7feoFdOMohbTNxHCr2-yF1s','2026-03-24 14:21:03','2026-03-24 06:21:03'),(10,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7ZqNuq4MYyBqMj3LbWJEGoY','2026-03-24 14:28:19','2026-03-24 06:28:19'),(11,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7RrnYZH-W_45YpuZi1mGLZw','2026-03-24 14:38:23','2026-03-24 06:38:23'),(12,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7c5-wcVouRMCS2fuuTZjBuA','2026-03-24 14:44:43','2026-03-24 06:44:43'),(13,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7feoFdOMohbTNxHCr2-yF1s','2026-03-24 15:12:50','2026-03-24 07:12:50'),(14,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7YPqSzTpnsrMonJNMVopRDQ','2026-03-24 15:57:55','2026-03-24 07:57:55'),(15,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7S3PgHX-X_siTmvvpI4Qz64','2026-03-24 16:17:03','2026-03-24 08:17:03'),(16,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7feoFdOMohbTNxHCr2-yF1s','2026-03-24 16:32:34','2026-03-24 08:32:34'),(17,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7ZqNuq4MYyBqMj3LbWJEGoY','2026-03-25 09:31:49','2026-03-25 01:31:49'),(18,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-25 13:34:45','2026-03-25 05:34:45'),(19,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-25 13:40:51','2026-03-25 05:40:51'),(20,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-25 14:29:26','2026-03-25 06:29:26'),(21,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-25 14:31:34','2026-03-25 06:31:34'),(22,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7ZqNuq4MYyBqMj3LbWJEGoY','2026-03-25 15:21:30','2026-03-25 07:21:30'),(23,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7c5-wcVouRMCS2fuuTZjBuA','2026-03-25 15:29:34','2026-03-25 07:29:34'),(24,'786537017627385856','5068416139942690838','open','400',NULL,'o3h6g7S3PgHX-X_siTmvvpI4Qz64','2026-03-25 17:53:21','2026-03-25 09:53:21'),(25,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7feoFdOMohbTNxHCr2-yF1s','2026-03-26 09:57:01','2026-03-26 01:57:01'),(26,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7feoFdOMohbTNxHCr2-yF1s','2026-03-26 10:00:28','2026-03-26 02:00:28'),(27,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-26 11:50:06','2026-03-26 03:50:06'),(28,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-26 16:41:15','2026-03-26 08:41:15'),(29,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-26 16:42:11','2026-03-26 08:42:11'),(30,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-26 16:56:57','2026-03-26 08:56:57'),(31,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-26 17:00:47','2026-03-26 09:00:47'),(32,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-26 17:01:03','2026-03-26 09:01:03'),(33,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-26 17:02:49','2026-03-26 09:02:49'),(34,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-26 17:03:45','2026-03-26 09:03:45'),(35,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-26 17:06:40','2026-03-26 09:06:40'),(36,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-26 17:07:32','2026-03-26 09:07:32'),(37,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-26 17:15:00','2026-03-26 09:15:00'),(38,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-26 17:15:31','2026-03-26 09:15:31'),(39,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-26 17:30:39','2026-03-26 09:30:39'),(40,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-26 17:31:21','2026-03-26 09:31:21'),(41,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7UIrKP9B-LP83vmEEqYuUpY','2026-03-27 09:20:47','2026-03-27 01:20:47'),(42,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7RrnYZH-W_45YpuZi1mGLZw','2026-03-27 10:26:33','2026-03-27 02:26:33'),(43,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-27 10:45:23','2026-03-27 02:45:23'),(44,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-27 10:45:56','2026-03-27 02:45:56'),(45,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-27 10:57:45','2026-03-27 02:57:45'),(46,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7c4ISkNNpmE6dHRvWHucSa0','2026-03-27 11:00:12','2026-03-27 03:00:12'),(47,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7c4ISkNNpmE6dHRvWHucSa0','2026-03-27 11:09:16','2026-03-27 03:09:16'),(48,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7eFnPidPOkKIyf5nazFYN7s','2026-03-27 11:21:21','2026-03-27 03:21:21'),(49,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-27 11:23:29','2026-03-27 03:23:29'),(50,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-27 11:24:17','2026-03-27 03:24:17'),(51,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7c4ISkNNpmE6dHRvWHucSa0','2026-03-27 11:25:14','2026-03-27 03:25:14'),(52,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7c4ISkNNpmE6dHRvWHucSa0','2026-03-27 11:32:56','2026-03-27 03:32:56'),(53,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-27 11:46:01','2026-03-27 03:46:01'),(54,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-27 11:46:49','2026-03-27 03:46:49'),(55,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-27 11:47:45','2026-03-27 03:47:45'),(56,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-27 11:51:26','2026-03-27 03:51:26'),(57,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-27 12:54:08','2026-03-27 04:54:08'),(58,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-27 13:06:10','2026-03-27 05:06:10'),(59,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-27 13:06:46','2026-03-27 05:06:46'),(60,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-27 13:19:05','2026-03-27 05:19:05'),(61,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-27 14:43:35','2026-03-27 06:43:35'),(62,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-27 14:48:45','2026-03-27 06:48:45'),(63,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-27 14:49:36','2026-03-27 06:49:36'),(64,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-27 14:50:02','2026-03-27 06:50:02'),(65,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-27 14:50:28','2026-03-27 06:50:28'),(66,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-03-27 15:41:07','2026-03-27 07:41:07'),(67,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7feoFdOMohbTNxHCr2-yF1s','2026-03-28 09:31:34','2026-03-28 01:31:34'),(68,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7UIrKP9B-LP83vmEEqYuUpY','2026-03-28 12:04:40','2026-03-28 04:04:40'),(69,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7feoFdOMohbTNxHCr2-yF1s','2026-03-28 14:44:32','2026-03-28 06:44:32'),(70,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7YPqSzTpnsrMonJNMVopRDQ','2026-03-28 16:37:52','2026-03-28 08:37:52'),(71,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7UIrKP9B-LP83vmEEqYuUpY','2026-03-30 11:27:39','2026-03-30 03:27:39'),(72,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7YPqSzTpnsrMonJNMVopRDQ','2026-03-30 14:25:33','2026-03-30 06:25:33'),(73,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7UIrKP9B-LP83vmEEqYuUpY','2026-03-30 16:20:29','2026-03-30 08:20:29'),(74,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7UIrKP9B-LP83vmEEqYuUpY','2026-03-31 08:56:04','2026-03-31 00:56:04'),(75,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7UIrKP9B-LP83vmEEqYuUpY','2026-04-01 09:04:36','2026-04-01 01:04:36'),(76,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7ZqNuq4MYyBqMj3LbWJEGoY','2026-04-01 09:52:38','2026-04-01 01:52:38'),(77,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7UIrKP9B-LP83vmEEqYuUpY','2026-04-01 12:52:47','2026-04-01 04:52:47'),(78,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7feoFdOMohbTNxHCr2-yF1s','2026-04-01 13:00:13','2026-04-01 05:00:13'),(79,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7ZqNuq4MYyBqMj3LbWJEGoY','2026-04-01 14:14:55','2026-04-01 06:14:55'),(80,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7UIrKP9B-LP83vmEEqYuUpY','2026-04-01 18:02:46','2026-04-01 10:02:46'),(81,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7ZqNuq4MYyBqMj3LbWJEGoY','2026-04-02 09:53:27','2026-04-02 01:53:27'),(82,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7UIrKP9B-LP83vmEEqYuUpY','2026-04-02 10:14:32','2026-04-02 02:14:32'),(83,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7feoFdOMohbTNxHCr2-yF1s','2026-04-02 10:55:26','2026-04-02 02:55:26'),(84,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7ZqNuq4MYyBqMj3LbWJEGoY','2026-04-02 14:38:04','2026-04-02 06:38:04'),(85,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7feoFdOMohbTNxHCr2-yF1s','2026-04-02 15:16:49','2026-04-02 07:16:49'),(86,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7UIrKP9B-LP83vmEEqYuUpY','2026-04-02 15:56:23','2026-04-02 07:56:23'),(87,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7ZqNuq4MYyBqMj3LbWJEGoY','2026-04-03 10:59:37','2026-04-03 02:59:37'),(88,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7ZqNuq4MYyBqMj3LbWJEGoY','2026-04-07 11:02:38','2026-04-07 03:02:38'),(89,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7feoFdOMohbTNxHCr2-yF1s','2026-04-07 15:02:59','2026-04-07 07:02:59'),(90,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7feoFdOMohbTNxHCr2-yF1s','2026-04-08 13:05:37','2026-04-08 05:05:37'),(91,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7feoFdOMohbTNxHCr2-yF1s','2026-04-09 12:58:36','2026-04-09 04:58:36'),(92,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-04-11 11:42:37','2026-04-11 03:42:37'),(93,'786537017627385856','5068416139942690838','open','400',NULL,'o3h6g7bfzTz7NMdPMVcPiIgRQpyQ','2026-04-12 10:46:34','2026-04-12 02:46:34'),(94,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7aR3G6tkD7yjm4UsMDM1kWs','2026-04-12 10:50:31','2026-04-12 02:50:31'),(95,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7feoFdOMohbTNxHCr2-yF1s','2026-04-12 11:10:26','2026-04-12 03:10:26'),(96,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7feoFdOMohbTNxHCr2-yF1s','2026-04-12 11:22:32','2026-04-12 03:22:32'),(97,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7UJjB9vOnUeQ38bwvNqbrbk','2026-04-13 10:11:38','2026-04-13 02:11:38'),(98,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7feoFdOMohbTNxHCr2-yF1s','2026-04-13 10:28:23','2026-04-13 02:28:23'),(99,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7feoFdOMohbTNxHCr2-yF1s','2026-04-13 14:54:22','2026-04-13 06:54:22'),(100,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7feoFdOMohbTNxHCr2-yF1s','2026-04-13 14:59:53','2026-04-13 06:59:53'),(101,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7UIrKP9B-LP83vmEEqYuUpY','2026-04-13 16:26:30','2026-04-13 08:26:30'),(102,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-04-14 15:15:31','2026-04-14 07:15:31'),(103,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-04-14 15:24:27','2026-04-14 07:24:27'),(104,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-04-14 15:24:56','2026-04-14 07:24:56'),(105,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-04-14 15:27:10','2026-04-14 07:27:10'),(106,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-04-14 15:39:18','2026-04-14 07:39:18'),(107,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7c4ISkNNpmE6dHRvWHucSa0','2026-04-14 15:47:22','2026-04-14 07:47:22'),(108,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-04-14 15:56:01','2026-04-14 07:56:01'),(109,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-04-14 15:58:50','2026-04-14 07:58:50'),(110,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-04-14 15:59:55','2026-04-14 07:59:55'),(111,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-04-14 16:01:39','2026-04-14 08:01:39'),(112,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-04-14 16:30:29','2026-04-14 08:30:29'),(113,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-04-14 16:32:58','2026-04-14 08:32:58'),(114,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-04-14 16:33:31','2026-04-14 08:33:31'),(115,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-04-14 16:37:19','2026-04-14 08:37:19'),(116,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-04-14 16:59:27','2026-04-14 08:59:27'),(117,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-04-14 17:03:17','2026-04-14 09:03:17'),(118,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-04-14 17:05:19','2026-04-14 09:05:19'),(119,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-04-14 17:05:50','2026-04-14 09:05:50'),(120,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-04-14 17:09:18','2026-04-14 09:09:18'),(121,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM','2026-04-14 17:14:12','2026-04-14 09:14:12'),(122,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7feoFdOMohbTNxHCr2-yF1s','2026-04-14 17:22:10','2026-04-14 09:22:10'),(123,'786537017627385856','5068416139942690838','open','200',NULL,'o3h6g7feoFdOMohbTNxHCr2-yF1s','2026-04-15 14:16:14','2026-04-15 06:16:14');
/*!40000 ALTER TABLE `door_lock_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table`
--

DROP TABLE IF EXISTS `gen_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gen_table` (
  `table_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) COLLATE utf8mb4_croatian_ci DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) COLLATE utf8mb4_croatian_ci DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) COLLATE utf8mb4_croatian_ci DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='代码生成业务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table`
--

LOCK TABLES `gen_table` WRITE;
/*!40000 ALTER TABLE `gen_table` DISABLE KEYS */;
INSERT INTO `gen_table` VALUES (1,'goods_spu','商品表',NULL,NULL,'GoodsSpu','crud','','com.joolun.system','system','spu','商品','joolun','0','/',NULL,'admin','2025-03-19 14:31:10','',NULL,NULL),(2,'spu_try_on_img_url','商品试戴图片表',NULL,NULL,'SpuTryOnImgUrl','crud','','com.joolun.system','system','url','商品试戴图片','joolun','0','/',NULL,'admin','2025-04-10 13:33:18','',NULL,NULL),(3,'try_on_glass_img_url','试戴眼镜图片地址表',NULL,NULL,'TryOnGlassImgUrl','crud','','com.joolun.system','system','url','试戴眼镜图片地址','joolun','0','/',NULL,'admin','2025-04-10 13:33:30','',NULL,NULL),(4,'goods_spu_banners','轮播图表',NULL,NULL,'GoodsSpuBanners','crud','element-plus','com.joolun.mall','system','banners','轮播图','guihuyu','0','/','{}','admin','2025-04-10 15:17:35','','2025-04-10 15:18:17',NULL),(5,'order_logistics_info','物流信息查询表',NULL,NULL,'OrderLogisticsInfo','crud','','com.joolun.system','system','info','物流信息查询','joolun','0','/',NULL,'admin','2025-04-11 14:04:49','',NULL,NULL),(6,'door_lock','门锁表',NULL,NULL,'DoorLock','crud','','com.joolun.system','system','lock','门锁','joolun','0','/',NULL,'admin','2025-05-24 09:18:10','',NULL,NULL),(7,'door_lock_history','门锁操作历史表',NULL,NULL,'DoorLockHistory','crud','element-plus','com.joolun.mall','mall','history','门锁操作历史','joolun','0','/','{}','admin','2025-05-24 09:18:10','','2025-05-24 09:27:22',NULL);
/*!40000 ALTER TABLE `gen_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table_column`
--

DROP TABLE IF EXISTS `gen_table_column`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gen_table_column` (
  `column_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint(20) DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) COLLATE utf8mb4_croatian_ci DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '字典类型',
  `sort` int(11) DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='代码生成业务表字段';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table_column`
--

LOCK TABLES `gen_table_column` WRITE;
/*!40000 ALTER TABLE `gen_table_column` DISABLE KEYS */;
INSERT INTO `gen_table_column` VALUES (1,1,'id','PK','varchar(32)','String','id','1','0','0','1',NULL,NULL,NULL,'EQ','input','',1,'admin','2025-03-19 14:31:10','',NULL),(2,1,'spu_code','spu编码','varchar(32)','String','spuCode','0','0','0','1','1','1','1','EQ','input','',2,'admin','2025-03-19 14:31:10','',NULL),(3,1,'name','spu名字','varchar(200)','String','name','0','0','1','1','1','1','1','LIKE','input','',3,'admin','2025-03-19 14:31:10','',NULL),(4,1,'sell_point','卖点','varchar(500)','String','sellPoint','0','0','1','1','1','1','1','EQ','textarea','',4,'admin','2025-03-19 14:31:10','',NULL),(5,1,'description','描述','text','String','description','0','0','1','1','1','1','1','EQ','textarea','',5,'admin','2025-03-19 14:31:10','',NULL),(6,1,'category_first','一级分类ID','varchar(32)','String','categoryFirst','0','0','1','1','1','1','1','EQ','input','',6,'admin','2025-03-19 14:31:10','',NULL),(7,1,'category_second','二级分类ID','varchar(32)','String','categorySecond','0','0','0','1','1','1','1','EQ','input','',7,'admin','2025-03-19 14:31:10','',NULL),(8,1,'tag','标签','varchar(255)','String','tag','0','0','0','1','1','1','1','EQ','input','',8,'admin','2025-03-19 14:31:10','',NULL),(9,1,'pic_urls','商品图片','varchar(1024)','String','picUrls','0','0','1','1','1','1','1','EQ','textarea','',9,'admin','2025-03-19 14:31:10','',NULL),(10,1,'shelf','是否上架（1是 0否）','char(2)','String','shelf','0','0','1','1','1','1','1','EQ','input','',10,'admin','2025-03-19 14:31:10','',NULL),(11,1,'sort','排序字段','int(11)','Long','sort','0','0','1','1','1','1','1','EQ','input','',11,'admin','2025-03-19 14:31:10','',NULL),(12,1,'sales_price','销售价格','decimal(10,2)','BigDecimal','salesPrice','0','0','0','1','1','1','1','EQ','input','',12,'admin','2025-03-19 14:31:10','',NULL),(13,1,'market_price','市场价','decimal(10,2)','BigDecimal','marketPrice','0','0','0','1','1','1','1','EQ','input','',13,'admin','2025-03-19 14:31:10','',NULL),(14,1,'cost_price','成本价','decimal(10,2)','BigDecimal','costPrice','0','0','0','1','1','1','1','EQ','input','',14,'admin','2025-03-19 14:31:10','',NULL),(15,1,'stock','库存','int(11)','Long','stock','0','0','1','1','1','1','1','EQ','input','',15,'admin','2025-03-19 14:31:10','',NULL),(16,1,'sale_num','销量','int(11)','Long','saleNum','0','0','0','1','1','1','1','EQ','input','',16,'admin','2025-03-19 14:31:10','',NULL),(17,1,'create_time','创建时间','datetime','Date','createTime','0','0','1','1',NULL,NULL,NULL,'EQ','datetime','',17,'admin','2025-03-19 14:31:10','',NULL),(18,1,'update_time','最后更新时间','timestamp','Date','updateTime','0','0','1','1','1',NULL,NULL,'EQ','datetime','',18,'admin','2025-03-19 14:31:10','',NULL),(19,1,'del_flag','逻辑删除标记（0：显示；1：隐藏）','char(2)','String','delFlag','0','0','1','1',NULL,NULL,NULL,'EQ','input','',19,'admin','2025-03-19 14:31:10','',NULL),(20,1,'version','版本号','int(11)','Long','version','0','0','0','1','1','1','1','EQ','input','',20,'admin','2025-03-19 14:31:10','',NULL),(21,2,'id','主键ID','varchar(32)','String','id','1','0','0','1',NULL,NULL,NULL,'EQ','input','',1,'admin','2025-04-10 13:33:18','',NULL),(22,2,'img_url','图片地址','varchar(255)','String','imgUrl','0','0','1','1','1','1','1','EQ','input','',2,'admin','2025-04-10 13:33:18','',NULL),(23,2,'goods_spu_id','商品SPU ID','varchar(32)','String','goodsSpuId','0','0','1','1','1','1','1','EQ','input','',3,'admin','2025-04-10 13:33:18','',NULL),(24,2,'create_time','创建时间','datetime','Date','createTime','0','0','1','1',NULL,NULL,NULL,'EQ','datetime','',4,'admin','2025-04-10 13:33:18','',NULL),(25,2,'update_time','最后更新时间','timestamp','Date','updateTime','0','0','1','1','1',NULL,NULL,'EQ','datetime','',5,'admin','2025-04-10 13:33:18','',NULL),(26,2,'del_flag','逻辑删除标记（0：显示；1：隐藏）','char(1)','String','delFlag','0','0','1','1',NULL,NULL,NULL,'EQ','input','',6,'admin','2025-04-10 13:33:18','',NULL),(27,3,'id','主键ID','varchar(32)','String','id','1','0','0','1',NULL,NULL,NULL,'EQ','input','',1,'admin','2025-04-10 13:33:30','',NULL),(28,3,'wx_user_id','微信用户ID','varchar(32)','String','wxUserId','0','0','1','1','1','1','1','EQ','input','',2,'admin','2025-04-10 13:33:30','',NULL),(29,3,'img_url','图片地址','varchar(255)','String','imgUrl','0','0','1','1','1','1','1','EQ','input','',3,'admin','2025-04-10 13:33:30','',NULL),(30,3,'goods_spu_id','商品SPU ID','varchar(32)','String','goodsSpuId','0','0','1','1','1','1','1','EQ','input','',4,'admin','2025-04-10 13:33:30','',NULL),(31,3,'create_time','创建时间','datetime','Date','createTime','0','0','1','1',NULL,NULL,NULL,'EQ','datetime','',5,'admin','2025-04-10 13:33:30','',NULL),(32,3,'update_time','最后更新时间','timestamp','Date','updateTime','0','0','1','1','1',NULL,NULL,'EQ','datetime','',6,'admin','2025-04-10 13:33:30','',NULL),(33,3,'del_flag','逻辑删除标记（0：显示；1：隐藏）','char(1)','String','delFlag','0','0','1','1',NULL,NULL,NULL,'EQ','input','',7,'admin','2025-04-10 13:33:30','',NULL),(34,4,'id','ID','int(20)','Long','id','1','1','0','1',NULL,NULL,NULL,'EQ','input','',1,'admin','2025-04-10 15:17:35','','2025-04-10 15:18:17'),(35,4,'goods_spu_id','商品SPU ID','varchar(32)','String','goodsSpuId','0','0','1','1','1','1','1','EQ','input','',2,'admin','2025-04-10 15:17:35','','2025-04-10 15:18:17'),(36,4,'banner_img_url','图片','varchar(255)','String','bannerImgUrl','0','0','0','1','1','1','1','EQ','input','',3,'admin','2025-04-10 15:17:35','','2025-04-10 15:18:17'),(37,4,'create_time','创建时间','datetime','Date','createTime','0','0','0','1',NULL,NULL,NULL,'EQ','datetime','',4,'admin','2025-04-10 15:17:35','','2025-04-10 15:18:17'),(38,4,'update_time','更新时间','datetime','Date','updateTime','0','0','0','1','1',NULL,NULL,'EQ','datetime','',5,'admin','2025-04-10 15:17:35','','2025-04-10 15:18:17'),(39,5,'id','PK','varchar(32)','String','id','1','0','0','1',NULL,NULL,NULL,'EQ','input','',1,'admin','2025-04-11 14:04:49','',NULL),(40,5,'logistics_id','物流id','varchar(32)','String','logisticsId','0','0','0','1','1','1','1','EQ','input','',2,'admin','2025-04-11 14:04:49','',NULL),(41,5,'status','物流状态 1在途中，2派件中，3已签收，4派送失败，5揽收，6退回，7转单，8疑难，9退签，10待清关，11清关中，12已清关，13清关异常','char(2)','String','status','0','0','0','1','1','1','1','EQ','radio','',3,'admin','2025-04-11 14:04:49','',NULL),(42,5,'name','物流名称','varchar(255)','String','name','0','0','0','1','1','1','1','LIKE','input','',4,'admin','2025-04-11 14:04:49','',NULL),(43,5,'com','快递公司代码','varchar(255)','String','com','0','0','0','1','1','1','1','EQ','input','',5,'admin','2025-04-11 14:04:49','',NULL),(44,5,'number','快递单号','varchar(255)','String','number','0','0','0','1','1','1','1','EQ','input','',6,'admin','2025-04-11 14:04:49','',NULL),(45,5,'logo','快递公司logo','varchar(255)','String','logo','0','0','0','1','1','1','1','EQ','input','',7,'admin','2025-04-11 14:04:49','',NULL),(46,5,'list','快递信息','varchar(2000)','String','list','0','0','0','1','1','1','1','EQ','textarea','',8,'admin','2025-04-11 14:04:49','',NULL),(47,6,'id','门锁id','bigint(32)','Long','id','1','0','0','1',NULL,NULL,NULL,'EQ','input','',1,'admin','2025-05-24 09:18:10','',NULL),(48,6,'yard_sn','园区sn（第三方）','varchar(36)','String','yardSn','0','0','1','1','1','1','1','EQ','input','',2,'admin','2025-05-24 09:18:10','',NULL),(49,6,'door_guid','门禁id（第三方）','varchar(36)','String','doorGuid','0','0','1','1','1','1','1','EQ','input','',3,'admin','2025-05-24 09:18:10','',NULL),(50,6,'door_name','门禁名称（第三方）','varchar(255)','String','doorName','0','0','1','1','1','1','1','LIKE','input','',4,'admin','2025-05-24 09:18:10','',NULL),(51,6,'del_flag','逻辑删除标记（0：显示；1：隐藏）','char(2)','String','delFlag','0','0','1','1',NULL,NULL,NULL,'EQ','input','',5,'admin','2025-05-24 09:18:10','',NULL),(52,6,'create_time','创建时间','datetime','Date','createTime','0','0','1','1',NULL,NULL,NULL,'EQ','datetime','',6,'admin','2025-05-24 09:18:10','',NULL),(53,6,'update_time','最后更新时间','timestamp','Date','updateTime','0','0','1','1','1',NULL,NULL,'EQ','datetime','',7,'admin','2025-05-24 09:18:10','',NULL),(54,6,'province_name','省名','varchar(50)','String','provinceName','0','0','0','1','1','1','1','LIKE','input','',8,'admin','2025-05-24 09:18:10','',NULL),(55,6,'city_name','市名','varchar(50)','String','cityName','0','0','0','1','1','1','1','LIKE','input','',9,'admin','2025-05-24 09:18:10','',NULL),(56,6,'county_name','区名','varchar(50)','String','countyName','0','0','0','1','1','1','1','LIKE','input','',10,'admin','2025-05-24 09:18:10','',NULL),(57,6,'detail_info','详情地址','varchar(255)','String','detailInfo','0','0','0','1','1','1','1','EQ','input','',11,'admin','2025-05-24 09:18:10','',NULL),(58,7,'id','门锁id','bigint(32)','Long','id','1','0','0','1',NULL,NULL,NULL,'EQ','input','',1,'admin','2025-05-24 09:18:10','','2025-05-24 09:27:22'),(59,7,'yard_sn','园区sn（第三方）','varchar(36)','String','yardSn','0','0','1','1','1','1','1','EQ','input','',2,'admin','2025-05-24 09:18:10','','2025-05-24 09:27:22'),(60,7,'door_guid','门禁id（第三方）','varchar(36)','String','doorGuid','0','0','1','1','1','1','1','EQ','input','',3,'admin','2025-05-24 09:18:10','','2025-05-24 09:27:22'),(61,7,'operation','操作记录(open：远程开门 reboot：重启)','varchar(255)','String','operation','0','0','1','1','1','1','1','EQ','input','',4,'admin','2025-05-24 09:18:10','','2025-05-24 09:27:22'),(62,7,'response','第三方接口响应','varchar(255)','String','response','0','0','0','1','1','1','1','EQ','input','',5,'admin','2025-05-24 09:18:10','','2025-05-24 09:27:22'),(63,7,'detail_info','详情地址','varchar(255)','String','detailInfo','0','0','0','1','1','1','1','EQ','input','',6,'admin','2025-05-24 09:18:10','','2025-05-24 09:27:22'),(64,7,'open_id','用户标识','varchar(64)','String','openId','0','0','1','1','1','1','1','EQ','input','',7,'admin','2025-05-24 09:18:10','','2025-05-24 09:27:22'),(65,7,'create_time','创建时间','datetime','Date','createTime','0','0','1','1',NULL,NULL,NULL,'EQ','datetime','',8,'admin','2025-05-24 09:18:10','','2025-05-24 09:27:22'),(66,7,'update_time','最后更新时间','timestamp','Date','updateTime','0','0','1','1','1',NULL,NULL,'EQ','datetime','',9,'admin','2025-05-24 09:18:10','','2025-05-24 09:27:22');
/*!40000 ALTER TABLE `gen_table_column` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goods_category`
--

DROP TABLE IF EXISTS `goods_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_category` (
  `id` varchar(32) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'PK',
  `enable` char(2) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '（1：开启；0：关闭）',
  `parent_id` varchar(32) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '父分类编号',
  `name` varchar(16) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '名称',
  `description` varchar(255) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '描述',
  `pic_url` varchar(255) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '图片',
  `sort` smallint(6) DEFAULT NULL COMMENT '排序',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `del_flag` char(2) COLLATE utf8mb4_croatian_ci DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='分类表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goods_category`
--

LOCK TABLES `goods_category` WRITE;
/*!40000 ALTER TABLE `goods_category` DISABLE KEYS */;
INSERT INTO `goods_category` VALUES ('1900362375073705986','1','0','镜框','','/profile/upload/2025/04/02/O1CN01kFoUtK27ezMftJV2n_!!2213854717823-0-cib_20250402160607A001.jpg',1,'2025-03-14 09:44:31','2025-03-14 09:44:31','0'),('1900364456392208385','1','1900362375073705986','军达','军达，显白，放大你的眼','/profile/upload/2025/04/02/O1CN01a248j423ffZy7Wy5R_!!2212057487283-0-cib_20250402160623A002.jpg',1,'2025-03-14 09:52:48','2025-03-19 09:00:55','0'),('1900364702459441153','1','1900362375073705986','科迪讯','款式多，库存多，发货迅速','/profile/upload/2025/04/02/O1CN01aDLmEj250Z4n2wWGK_!!2209559537464-0-cib_20250402160638A003.jpg',2,'2025-03-14 09:53:46','2025-03-14 09:53:46','0'),('1900364881426198529','1','1900362375073705986','仟伊','高级感十足','/profile/upload/2025/04/02/O1CN01YzjaWa1xPk5BrPYfI_!!2212781886436-0-cib_20250402160649A004.jpg',3,'2025-03-14 09:54:29','2025-03-14 09:54:29','0'),('1910138691179040769','1','0','镜片','','/profile/upload/2025/04/10/9208511322_708216336_20250410091206A001.jpg',2,'2025-04-10 09:12:07','2025-04-10 09:12:07','0'),('1910138691179041236','1','1910138691179040769','视特耐','','/profile/upload/2025/04/10/O1CN01Eq9Q1T1Yar7kkYjcp_!!3044073076-0-cib_20250410091520A002.jpg',1,'2025-04-10 09:14:30','2025-04-10 09:15:06','0'),('1910139821145509890','1','1910138691179040769','蔡司','','/profile/upload/2025/04/10/蔡司_20250410103353A004.jpg',2,'2025-04-10 09:16:36','2025-04-10 09:16:36','0'),('1910139977504968706','1','1910138691179040769','凯米','','/profile/upload/2025/04/10/O1CN01hAKK232LM7YodZFG1_!!1856649677-0-cib_20250410091712A004.jpg',3,'2025-04-10 09:17:13','2025-04-10 09:17:13','0'),('1910147834342289410','1','1910138691179040769','明月','','/profile/upload/2025/04/10/明月_20250410094825A001.jpg',4,'2025-04-10 09:48:27','2025-04-10 09:48:27','0');
/*!40000 ALTER TABLE `goods_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goods_spu`
--

DROP TABLE IF EXISTS `goods_spu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_spu` (
  `id` varchar(32) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'PK',
  `spu_code` varchar(32) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT 'spu编码',
  `name` varchar(200) COLLATE utf8mb4_croatian_ci NOT NULL DEFAULT '' COMMENT 'spu名字',
  `sell_point` varchar(500) COLLATE utf8mb4_croatian_ci NOT NULL DEFAULT '' COMMENT '卖点',
  `description` text COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '描述',
  `category_first` varchar(32) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '一级分类ID',
  `category_second` varchar(32) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '二级分类ID',
  `tag` varchar(255) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '标签',
  `pic_urls` varchar(1024) COLLATE utf8mb4_croatian_ci NOT NULL DEFAULT '' COMMENT '商品图片',
  `shelf` char(2) COLLATE utf8mb4_croatian_ci NOT NULL DEFAULT '0' COMMENT '是否上架（1是 0否）',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序字段',
  `sales_price` decimal(10,2) DEFAULT NULL COMMENT '销售价格',
  `market_price` decimal(10,2) DEFAULT NULL COMMENT '市场价',
  `cost_price` decimal(10,2) DEFAULT NULL COMMENT '成本价',
  `stock` int(11) NOT NULL DEFAULT '0' COMMENT '库存',
  `sale_num` int(11) DEFAULT '0' COMMENT '销量',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `del_flag` char(2) COLLATE utf8mb4_croatian_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `version` int(11) DEFAULT '0' COMMENT '版本号',
  PRIMARY KEY (`id`) USING BTREE,
  FULLTEXT KEY `idx_fulltext_search` (`name`,`sell_point`,`description`,`tag`) /*!50100 WITH PARSER `ngram` */ 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='商品表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goods_spu`
--

LOCK TABLES `goods_spu` WRITE;
/*!40000 ALTER TABLE `goods_spu` DISABLE KEYS */;
INSERT INTO `goods_spu` VALUES ('1900363838747389953','','军达-冰蓝色镜框','好看','噶安徽就卡死爱迪生\n','1900362375073705986','1900364456392208385','国产,进口','[\"/profile/upload/2025/04/16/bls_20250416185945A029.jpg\"]','1',0,0.01,0.01,9.00,946,28,'2025-03-14 09:50:20','2025-03-19 01:41:26','0',131),('1900378351710318593','2312','金色','高端大气','<p>噶安徽就卡死爱迪生的两个角色公司开了个看</p><p>安徽卡号</p><p>司法考试计划阿萨分类\n</p>','1900362375073705986','1900364456392208385','国产','[\"/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg\"]','1',0,0.01,12.00,10.00,489,27,'2025-03-14 10:48:01','2025-03-19 01:41:27','0',37),('1900378673224691713','2122','简约椭圆','时尚高颜值','asdzx','1900362375073705986','1900364456392208385','进口','[\"/profile/upload/2025/04/14/O1CN01rwlGpu23ffZwigOaQ_!!2212057487283-0-cib_20250414084955A009.jpg\"]','1',0,0.01,12.00,10.00,699,22,'2025-03-14 10:49:17','2025-03-19 03:05:33','0',18),('1900379604263710721','2124','优雅精致纯钛架','纯钛，斯文典雅，万搭','zxczx','1900362375073705986','1900364456392208385','进口','[\"/profile/upload/2025/04/16/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250416194940A002.jpg\"]','1',0,0.01,18.00,13.00,2499,123,'2025-03-14 10:52:59','2025-03-19 03:05:33','0',15),('1900382455924862977','','星耀黑银','高级感','<p> asda</p>','1900362375073705986','1900364881426198529','进口','[\"/profile/upload/2025/04/02/2_20250402162503A010.jpg\"]','1',0,0.01,14.00,10.00,6,26,'2025-03-14 11:04:19','2025-03-19 03:05:33','0',10),('1900382773244932098','','巴黎灰岛','神秘','<p>mnhsd</p>','1900362375073705986','1900364881426198529','国产','[\"/profile/upload/2025/04/02/O1CN01fiWHYn250Yylo5yp4_!!2209559537464-0-cib_20250402162518A011.jpg\"]','1',0,0.01,15.00,11.00,9,29,'2025-03-14 11:05:35','2025-03-19 01:41:31','0',8),('1900383214020145154','','方框男生镜框','细腻质感，立体轮廓','123132','1900362375073705986','1900364702459441153','国产','[\"/dev-api/profile/upload/2025/04/02/O1CN01aDLmEj250Z4n2wWGK_!!2209559537464-0-cib_20250402162529A012.jpg\"]','1',0,50.00,22.00,15.00,99,129,'2025-03-14 11:07:20','2025-03-19 01:41:32','0',4),('1900383473018417154','111','全框','轻便，耐摔','<p>hyh</p>','1900362375073705986','1900364702459441153','全框','[\"/profile/upload/2025/04/02/O1CN01AVDr61250ZBTE7nQD_!!2209559537464-0-cib_20250402162542A013.jpg\"]','1',0,0.01,18.00,13.00,148,66,'2025-03-14 11:08:22','2025-03-19 03:05:22','0',6),('1900384263716024321','112','商务男士半框','高品质，轻奢高尚','<p>jih</p>','1900362375073705986','1900364702459441153','半框,进口','[\"/profile/upload/2025/04/02/O1CN01YzjaWa1xPk5BrPYfI_!!2212781886436-0-cib_20250402162556A014.jpg\"]','1',0,0.01,34.00,17.00,199,204,'2025-03-14 11:11:30','2025-03-24 05:18:39','0',2),('1900384575709327362','113','潮色金属半框','真空IP电镀','&lt;!DOCTYPE html&gt;&lt;html lang=\"en\"&gt;&lt;head&gt;    &lt;meta charset=\"UTF-8\"&gt;    &lt;meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"&gt;    &lt;title&gt;商品介绍&lt;/title&gt;    &lt;style&gt;        body {            font-family: Arial, sans-serif;            line-height: 1.6;            margin: 0;            padding: 0;            background-color: #f4f4f4;        }        .container {            width: 80%;            margin: auto;            overflow: hidden;        }        .product-intro {            background: #fff;            padding: 20px;            margin-top: 20px;            border-radius: 5px;            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);        }        .product-intro h1 {            color: #333;        }        .product-intro img {            max-width: 100%;            height: auto;            margin-bottom: 20px;        }        .product-intro p {            margin-bottom: 10px;        }        .product-intro ul {            margin: 0;            padding: 0;            list-style: none;        }        .product-intro ul li {            margin-bottom: 10px;            padding-left: 20px;            position: relative;        }        .product-intro ul li::before {            content: \"•\";            position: absolute;            left: 0;            color: #ff6347;            font-size: 20px;        }        .product-intro .price {            font-size: 24px;            color: #ff6347;            margin-top: 20px;        }        .product-intro .btn {            display: inline-block;            background: #ff6347;            color: #fff;            padding: 10px 20px;            text-decoration: none;            border-radius: 5px;            margin-top: 20px;        }        .product-intro .btn:hover {            background: #e0533e;        }    &lt;/style&gt;&lt;/head&gt;&lt;body&gt;    &lt;div class=\"container\"&gt;        &lt;div class=\"product-intro\"&gt;            &lt;h1&gt;智能手表&lt;/h1&gt;            &lt;img src=\"https://via.placeholder.com/500x300\" alt=\"智能手表\"&gt;            &lt;p&gt;这是一款功能强大的智能手表，适合追求时尚与科技的您。&lt;/p&gt;            &lt;ul&gt;                &lt;li&gt;高清触摸屏，操作流畅便捷&lt;/li&gt;                &lt;li&gt;多种运动模式，满足您的运动需求&lt;/li&gt;                &lt;li&gt;健康监测功能，实时关注您的身体状况&lt;/li&gt;                &lt;li&gt;长续航电池，让您无需频繁充电&lt;/li&gt;            &lt;/ul&gt;            &lt;div class=\"price\"&gt;￥999.00&lt;/div&gt;                  &lt;/div&gt;    &lt;/div&gt;&lt;/body&gt;&lt;/html&gt;','1900362375073705986','1900364702459441153','进口,全框','[\"/dev-api/profile/upload/2025/04/02/O1CN01zd7cxa250ZGppw10H_!!2209559537464-0-cib_20250402162609A015.jpg\"]','1',0,10.00,28.00,16.00,189,142,'2025-03-14 11:12:44','2025-03-24 05:18:58','0',7),('1910142888230309889','1231321','蔡司','进口','<p>国际大品牌</p>','1910138691179040769','1910139821145509890','进口,树脂','[\"/profile/upload/2025/04/10/cs1_20250410103456A005.jpg\"]','1',0,0.01,12.00,7.00,99994,4,'2025-04-10 09:28:47','2025-04-10 01:28:47','0',9),('1910148048591532034','','明月','超亮高清超薄非球面防蓝光定制近视高度配眼镜片','耐磨，易清洁','1910138691179040769','1910147834342289410','树脂','[\"/profile/upload/2025/04/10/明月_20250410102247A003.jpg\"]','1',0,0.01,9.00,6.00,9998,0,'2025-04-10 09:49:18','2025-04-16 10:10:11','0',5);
/*!40000 ALTER TABLE `goods_spu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goods_spu_banners`
--

DROP TABLE IF EXISTS `goods_spu_banners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods_spu_banners` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `goods_spu_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci DEFAULT NULL,
  `banner_img_url` varchar(255) DEFAULT NULL COMMENT '图片',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='轮播图表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goods_spu_banners`
--

LOCK TABLES `goods_spu_banners` WRITE;
/*!40000 ALTER TABLE `goods_spu_banners` DISABLE KEYS */;
INSERT INTO `goods_spu_banners` VALUES (2,'1900384263716024321','/profile/upload/2025/04/14/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250414102400A019.jpg','2025-04-13 16:46:40','2025-04-14 10:24:01'),(4,'1900378351710318593','/profile/upload/2025/04/14/bls_20250414103725A022.jpg','2025-04-13 17:02:57','2025-04-14 10:37:27'),(5,'1910142888230309889','/profile/upload/2025/04/14/bls_20250414103824A023.jpg','2025-04-13 17:03:49','2025-04-14 10:38:25');
/*!40000 ALTER TABLE `goods_spu_banners` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `optometry_data`
--

DROP TABLE IF EXISTS `optometry_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `optometry_data` (
  `optometry_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '眼镜验光ID',
  `optometry_records_id` bigint(20) DEFAULT NULL COMMENT '验光记录ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `spherical_mirror` varchar(50) DEFAULT NULL COMMENT '球镜数据',
  `cylindrical_mirror` varchar(50) DEFAULT NULL COMMENT '柱镜数据',
  `position_of_axis` varchar(50) DEFAULT NULL COMMENT '轴位数据',
  `addend` varchar(50) DEFAULT NULL COMMENT 'ADD数据',
  `distance_of_pupil` varchar(50) DEFAULT NULL COMMENT '瞳距数据',
  `horizontal_prism` varchar(50) DEFAULT '0.0' COMMENT '水平棱镜数据',
  `vertical_prism` varchar(50) DEFAULT '0.0' COMMENT '垂直棱镜数据',
  `type` int(1) NOT NULL COMMENT '分类数据（1=电脑验光仪，2=查片仪，3=验光头，4=最终配镜）',
  `near_far` int(1) DEFAULT NULL COMMENT '远近数据（0=远，1=近）',
  `left_right_eyes` int(1) NOT NULL COMMENT '左右眼数据（0=左眼，1=右眼）',
  PRIMARY KEY (`optometry_id`) USING BTREE,
  KEY `optometry_records_id` (`optometry_records_id`) USING BTREE,
  CONSTRAINT `optometry_data_ibfk_1` FOREIGN KEY (`optometry_records_id`) REFERENCES `optometry_records` (`optometry_records_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=439 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='眼镜验光数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `optometry_data`
--

LOCK TABLES `optometry_data` WRITE;
/*!40000 ALTER TABLE `optometry_data` DISABLE KEYS */;
INSERT INTO `optometry_data` VALUES (1,1,'2024-11-27 15:49:29','2024-11-27 15:49:29','-5.25','-4.75','338.0','0.0','32.0','-2.2','-2.3',3,0,0),(2,1,'2024-11-27 15:49:29','2024-11-27 15:49:29','-5.25','-4.75','338.0','0.0','32.0','-2.2','-2.3',3,0,1),(3,1,'2024-11-27 15:49:29','2024-11-27 15:49:29','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,0),(4,1,'2024-11-27 15:49:29','2024-11-27 15:49:29','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,1),(5,1,'2024-11-27 15:49:29','2024-11-27 15:49:29','-5.25','-4.75','338.0','0.0','32.0','-2.2','-2.3',4,0,0),(6,1,'2024-11-27 15:49:29','2024-11-27 15:49:29','-5.25','-4.75','338.0','0.0','32.0','-2.2','-2.3',4,0,1),(7,1,'2024-11-27 15:49:29','2024-11-27 15:49:29','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,0),(8,1,'2024-11-27 15:49:29','2024-11-27 15:49:29','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,1),(9,2,'2024-12-12 16:02:13','2024-12-12 16:02:13','-5.25','-4.75','338.0','0.0','32.0','-2.2','-2.3',3,0,0),(10,2,'2024-12-12 16:02:13','2024-12-12 16:02:13','-5.25','-4.75','338.0','0.0','32.0','-2.2','-2.3',3,0,1),(11,2,'2024-12-12 16:02:13','2024-12-12 16:02:13','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,0),(12,2,'2024-12-12 16:02:13','2024-12-12 16:02:13','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,1),(13,2,'2024-12-12 16:02:13','2024-12-12 16:02:13','-5.25','-4.75','338.0','0.0','32.0','-2.2','-2.3',4,0,0),(14,2,'2024-12-12 16:02:13','2024-12-12 16:02:13','-5.25','-4.75','338.0','0.0','32.0','-2.2','-2.3',4,0,1),(15,2,'2024-12-12 16:02:13','2024-12-12 16:02:13','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,0),(16,2,'2024-12-12 16:02:13','2024-12-12 16:02:13','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,1),(17,3,'2025-02-18 15:27:30','2025-02-18 15:27:30','0.0','0.0','0.0','0.0','32.0','0.0','0.0',3,0,0),(18,3,'2025-02-18 15:27:30','2025-02-18 15:27:30','0.0','0.0','0.0','0.0','32.0','0.0','0.0',3,0,1),(19,3,'2025-02-18 15:27:30','2025-02-18 15:27:30','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,0),(20,3,'2025-02-18 15:27:30','2025-02-18 15:27:30','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,1),(21,3,'2025-02-18 15:27:30','2025-02-18 15:27:30','0.0','0.0','0.0','0.0','32.0','0.0','0.0',4,0,0),(22,3,'2025-02-18 15:27:30','2025-02-18 15:27:30','0.0','0.0','0.0','0.0','32.0','0.0','0.0',4,0,1),(23,3,'2025-02-18 15:27:30','2025-02-18 15:27:30','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,0),(24,3,'2025-02-18 15:27:30','2025-02-18 15:27:30','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,1),(25,4,'2025-02-18 17:10:10','2025-02-18 17:10:10','0.0','0.0','0.0','0.0','32.0','0.0','0.0',3,0,0),(26,4,'2025-02-18 17:10:10','2025-02-18 17:10:10','0.0','0.0','0.0','0.0','32.0','0.0','0.0',3,0,1),(27,4,'2025-02-18 17:10:10','2025-02-18 17:10:10','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,0),(28,4,'2025-02-18 17:10:10','2025-02-18 17:10:10','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,1),(29,4,'2025-02-18 17:10:10','2025-02-18 17:10:10','0.0','0.0','0.0','0.0','32.0','0.0','0.0',4,0,0),(30,4,'2025-02-18 17:10:10','2025-02-18 17:10:10','0.0','0.0','0.0','0.0','32.0','0.0','0.0',4,0,1),(31,4,'2025-02-18 17:10:10','2025-02-18 17:10:10','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,0),(32,4,'2025-02-18 17:10:10','2025-02-18 17:10:10','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,1),(33,5,'2025-02-18 17:10:28','2025-02-18 17:10:28','0.0','0.0','0.0','0.0','32.0','0.0','0.0',3,0,0),(34,5,'2025-02-18 17:10:28','2025-02-18 17:10:28','0.0','0.0','0.0','0.0','32.0','0.0','0.0',3,0,1),(35,5,'2025-02-18 17:10:28','2025-02-18 17:10:28','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,0),(36,5,'2025-02-18 17:10:28','2025-02-18 17:10:28','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,1),(37,5,'2025-02-18 17:10:28','2025-02-18 17:10:28','0.0','0.0','0.0','0.0','32.0','0.0','0.0',4,0,0),(38,5,'2025-02-18 17:10:28','2025-02-18 17:10:28','0.0','0.0','0.0','0.0','32.0','0.0','0.0',4,0,1),(39,5,'2025-02-18 17:10:28','2025-02-18 17:10:28','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,0),(40,5,'2025-02-18 17:10:28','2025-02-18 17:10:28','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,1),(41,6,'2025-02-20 09:27:53','2025-02-20 09:27:53','0.0','0.0','0.0','0.0','32.0','0.0','0.0',3,0,0),(42,6,'2025-02-20 09:27:53','2025-02-20 09:27:53','0.0','0.0','0.0','0.0','32.0','0.0','0.0',3,0,1),(43,6,'2025-02-20 09:27:53','2025-02-20 09:27:53','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,0),(44,6,'2025-02-20 09:27:53','2025-02-20 09:27:53','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,1),(45,6,'2025-02-20 09:27:53','2025-02-20 09:27:53','0.0','0.0','0.0','0.0','32.0','0.0','0.0',4,0,0),(46,6,'2025-02-20 09:27:53','2025-02-20 09:27:53','0.0','0.0','0.0','0.0','32.0','0.0','0.0',4,0,1),(47,6,'2025-02-20 09:27:53','2025-02-20 09:27:53','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,0),(48,6,'2025-02-20 09:27:53','2025-02-20 09:27:53','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,1),(49,7,'2025-02-20 09:28:08','2025-02-20 09:28:08','0.0','0.0','0.0','0.0','32.0','0.0','0.0',3,0,0),(50,7,'2025-02-20 09:28:08','2025-02-20 09:28:08','0.0','0.0','0.0','0.0','32.0','0.0','0.0',3,0,1),(51,7,'2025-02-20 09:28:08','2025-02-20 09:28:08','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,0),(52,7,'2025-02-20 09:28:08','2025-02-20 09:28:08','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,1),(53,7,'2025-02-20 09:28:08','2025-02-20 09:28:08','0.0','0.0','0.0','0.0','32.0','0.0','0.0',4,0,0),(54,7,'2025-02-20 09:28:08','2025-02-20 09:28:08','0.0','0.0','0.0','0.0','32.0','0.0','0.0',4,0,1),(55,7,'2025-02-20 09:28:08','2025-02-20 09:28:08','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,0),(56,7,'2025-02-20 09:28:08','2025-02-20 09:28:08','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,1),(57,8,'2025-02-20 09:28:19','2025-02-20 09:28:19','0.0','0.0','0.0','0.0','32.0','0.0','0.0',3,0,0),(58,8,'2025-02-20 09:28:19','2025-02-20 09:28:19','0.0','0.0','0.0','0.0','32.0','0.0','0.0',3,0,1),(59,8,'2025-02-20 09:28:19','2025-02-20 09:28:19','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,0),(60,8,'2025-02-20 09:28:19','2025-02-20 09:28:19','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,1),(61,8,'2025-02-20 09:28:19','2025-02-20 09:28:19','0.0','0.0','0.0','0.0','32.0','0.0','0.0',4,0,0),(62,8,'2025-02-20 09:28:19','2025-02-20 09:28:19','0.0','0.0','0.0','0.0','32.0','0.0','0.0',4,0,1),(63,8,'2025-02-20 09:28:19','2025-02-20 09:28:19','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,0),(64,8,'2025-02-20 09:28:19','2025-02-20 09:28:19','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,1),(65,9,'2025-02-20 11:04:26','2025-02-20 11:04:26','0.0','0.0','0.0','0.0','32.0','0.0','0.0',3,0,0),(66,9,'2025-02-20 11:04:26','2025-02-20 11:04:26','0.0','0.0','0.0','0.0','32.0','0.0','0.0',3,0,1),(67,9,'2025-02-20 11:04:26','2025-02-20 11:04:26','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,0),(68,9,'2025-02-20 11:04:26','2025-02-20 11:04:26','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,1),(69,9,'2025-02-20 11:04:26','2025-02-20 11:04:26','0.0','0.0','0.0','0.0','32.0','0.0','0.0',4,0,0),(70,9,'2025-02-20 11:04:26','2025-02-20 11:04:26','0.0','0.0','0.0','0.0','32.0','0.0','0.0',4,0,1),(71,9,'2025-02-20 11:04:26','2025-02-20 11:04:26','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,0),(72,9,'2025-02-20 11:04:26','2025-02-20 11:04:26','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,1),(73,10,'2025-02-20 11:16:43','2025-02-20 11:16:43','0.0','0.0','0.0','0.0','32.0','0.0','0.0',3,0,0),(74,10,'2025-02-20 11:16:43','2025-02-20 11:16:43','0.0','0.0','0.0','0.0','32.0','0.0','0.0',3,0,1),(75,10,'2025-02-20 11:16:43','2025-02-20 11:16:43','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,0),(76,10,'2025-02-20 11:16:43','2025-02-20 11:16:43','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,1),(77,10,'2025-02-20 11:16:43','2025-02-20 11:16:43','0.0','0.0','0.0','0.0','32.0','0.0','0.0',4,0,0),(78,10,'2025-02-20 11:16:43','2025-02-20 11:16:43','0.0','0.0','0.0','0.0','32.0','0.0','0.0',4,0,1),(79,10,'2025-02-20 11:16:43','2025-02-20 11:16:43','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,0),(80,10,'2025-02-20 11:16:43','2025-02-20 11:16:43','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,1),(81,11,'2025-02-20 11:44:39','2025-02-20 11:44:39','0.0','0.0','0.0','0.0','32.0','0.0','0.0',3,0,0),(82,11,'2025-02-20 11:44:39','2025-02-20 11:44:39','0.0','0.0','0.0','0.0','32.0','0.0','0.0',3,0,1),(83,11,'2025-02-20 11:44:39','2025-02-20 11:44:39','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,0),(84,11,'2025-02-20 11:44:39','2025-02-20 11:44:39','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,1),(85,11,'2025-02-20 11:44:39','2025-02-20 11:44:39','0.0','0.0','0.0','0.0','32.0','0.0','0.0',4,0,0),(86,11,'2025-02-20 11:44:39','2025-02-20 11:44:39','0.0','0.0','0.0','0.0','32.0','0.0','0.0',4,0,1),(87,11,'2025-02-20 11:44:39','2025-02-20 11:44:39','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,0),(88,11,'2025-02-20 11:44:39','2025-02-20 11:44:39','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,1),(89,12,'2025-02-20 12:32:28','2025-02-20 12:32:28','0.0','0.0','0.0','0.0','32.0','0.0','0.0',3,0,0),(90,12,'2025-02-20 12:32:28','2025-02-20 12:32:28','0.0','0.0','0.0','0.0','32.0','0.0','0.0',3,0,1),(91,12,'2025-02-20 12:32:28','2025-02-20 12:32:28','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,0),(92,12,'2025-02-20 12:32:28','2025-02-20 12:32:28','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,1),(93,12,'2025-02-20 12:32:28','2025-02-20 12:32:28','0.0','0.0','0.0','0.0','32.0','0.0','0.0',4,0,0),(94,12,'2025-02-20 12:32:28','2025-02-20 12:32:28','0.0','0.0','0.0','0.0','32.0','0.0','0.0',4,0,1),(95,12,'2025-02-20 12:32:28','2025-02-20 12:32:28','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,0),(96,12,'2025-02-20 12:32:28','2025-02-20 12:32:28','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,1),(97,13,'2025-02-20 13:02:07','2025-02-20 13:02:07','0.0','0.0','0.0','0.0','32.0','0.0','0.0',3,0,0),(98,13,'2025-02-20 13:02:07','2025-02-20 13:02:07','0.0','0.0','0.0','0.0','32.0','0.0','0.0',3,0,1),(99,13,'2025-02-20 13:02:07','2025-02-20 13:02:07','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,0),(100,13,'2025-02-20 13:02:07','2025-02-20 13:02:07','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,1),(101,13,'2025-02-20 13:02:07','2025-02-20 13:02:07','0.0','0.0','0.0','0.0','32.0','0.0','0.0',4,0,0),(102,13,'2025-02-20 13:02:07','2025-02-20 13:02:07','0.0','0.0','0.0','0.0','32.0','0.0','0.0',4,0,1),(103,13,'2025-02-20 13:02:07','2025-02-20 13:02:07','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,0),(104,13,'2025-02-20 13:02:07','2025-02-20 13:02:07','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,1),(105,14,'2025-02-21 10:30:49','2025-02-21 10:30:49','0.0','0.0','0.0','0.0','32.0','0.0','0.0',3,0,0),(106,14,'2025-02-21 10:30:49','2025-02-21 10:30:49','0.0','0.0','0.0','0.0','32.0','0.0','0.0',3,0,1),(107,14,'2025-02-21 10:30:49','2025-02-21 10:30:49','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,0),(108,14,'2025-02-21 10:30:49','2025-02-21 10:30:49','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,1),(109,14,'2025-02-21 10:30:49','2025-02-21 10:30:49','0.0','0.0','0.0','0.0','32.0','0.0','0.0',4,0,0),(110,14,'2025-02-21 10:30:49','2025-02-21 10:30:49','0.0','0.0','0.0','0.0','32.0','0.0','0.0',4,0,1),(111,14,'2025-02-21 10:30:49','2025-02-21 10:30:49','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,0),(112,14,'2025-02-21 10:30:49','2025-02-21 10:30:49','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',4,1,1),(113,15,'2025-02-21 10:43:19','2025-02-21 10:43:19','0.0','0.0','0.0','0.0','32.0','0.0','0.0',3,0,0),(114,15,'2025-02-21 10:43:19','2025-02-21 10:43:19','0.0','0.0','0.0','0.0','32.0','0.0','0.0',3,0,1),(115,15,'2025-02-21 10:43:19','2025-02-21 10:43:19','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,0),(116,15,'2025-02-21 10:43:19','2025-02-21 10:43:19','0.0','0.0','0.0',NULL,'30.0','0.0','0.0',3,1,1),(117,15,'2025-02-21 10:43:19','2025-02-21 10:43:19','0.0','0.0','0.0','0.0','32.0','0.0','0.0',4,0,0),(118,15,'2025-02-21 10:43:19','2025-02-21 10:43:19','0.0','0.0','0.0','0.0','32.0','0.0','0.0',4,0,1),(119,15,'2025-02-21 10:43:19','2025-02-25 10:29:48','0.0','0.0','0.0','0.0','30.0','0.0','0.0',4,1,0),(120,15,'2025-02-21 10:43:19','2025-02-25 10:29:43','0.0','0.0','0.0','0.0','30.0','0.0','0.0',4,1,1),(123,15,'2025-02-21 10:43:19','2025-02-21 10:43:19','0.0','0.0','0.0','0.0','32.0','0.0','0.0',2,0,1),(124,15,'2025-02-21 10:43:19','2025-02-21 10:43:19','0.0','0.0','0.0','0.0','32.0','0.0','0.0',2,0,0),(127,15,'2025-02-21 10:43:19','2025-02-21 10:43:19','0.0','0.0','0.0','0.0','32.0','0.0','0.0',1,0,1),(128,15,'2025-02-21 10:43:19','2025-02-21 10:43:19','0.0','0.0','0.0','0.0','32.0','0.0','0.0',1,0,0),(129,16,'2026-03-26 16:56:36','2026-03-26 16:56:36','-2.25','-0.25','58','0.0','64.16','0.0','0.0',1,0,0),(130,16,'2026-03-26 16:56:36','2026-03-26 16:56:36','-2.25','-0.50','94','0.0','64.16','0.0','0.0',1,0,1),(131,16,'2026-03-26 16:56:36','2026-03-26 16:56:36','-2.25','-0.25','58.0','0.0','64.16','0.0','0.0',3,0,0),(132,16,'2026-03-26 16:56:36','2026-03-26 16:56:36','-2.0','-0.5','99.0','0.0','64.16','0.0','0.0',3,0,1),(133,16,'2026-03-26 16:56:36','2026-03-26 16:56:36','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(134,16,'2026-03-26 16:56:36','2026-03-26 16:56:36','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(135,16,'2026-03-26 16:56:36','2026-03-26 16:56:36','-2.25','-0.25','58.0','0.0','64.16','0.0','0.0',4,0,0),(136,16,'2026-03-26 16:56:36','2026-03-26 16:56:36','-2.0','-0.5','99.0','0.0','64.16','0.0','0.0',4,0,1),(137,16,'2026-03-26 16:56:36','2026-03-26 16:56:36','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(138,16,'2026-03-26 16:56:36','2026-03-26 16:56:36','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(139,17,'2026-03-27 10:44:51','2026-03-27 10:44:51','-2.75','-0.25','79','0.0','64.24','0.0','0.0',1,0,0),(140,17,'2026-03-27 10:44:51','2026-03-27 10:44:51','-2.75','-0.25','85','0.0','64.24','0.0','0.0',1,0,1),(141,17,'2026-03-27 10:44:51','2026-03-27 10:44:51','-2.75','-0.25','79.0','0.0','64.24','0.0','0.0',3,0,0),(142,17,'2026-03-27 10:44:51','2026-03-27 10:44:51','-2.75','-0.25','85.0','0.0','64.24','0.0','0.0',3,0,1),(143,17,'2026-03-27 10:44:51','2026-03-27 10:44:51','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(144,17,'2026-03-27 10:44:51','2026-03-27 10:44:51','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(145,17,'2026-03-27 10:44:51','2026-03-27 10:44:51','-2.75','-0.25','79.0','0.0','64.24','0.0','0.0',4,0,0),(146,17,'2026-03-27 10:44:51','2026-03-27 10:44:51','-2.75','-0.25','85.0','0.0','64.24','0.0','0.0',4,0,1),(147,17,'2026-03-27 10:44:51','2026-03-27 10:44:51','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(148,17,'2026-03-27 10:44:51','2026-03-27 10:44:51','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(149,18,'2026-03-27 15:42:53','2026-03-27 15:42:53','-9.00','-1.00','3','0.0','61.92','0.0','0.0',1,0,0),(150,18,'2026-03-27 15:42:53','2026-03-27 15:42:53','-8.00','-0.25','61','0.0','61.92','0.0','0.0',1,0,1),(151,18,'2026-03-27 15:42:53','2026-03-27 15:42:53','-9.0','-1.0','3.0','0.0','61.92','0.0','0.0',3,0,0),(152,18,'2026-03-27 15:42:53','2026-03-27 15:42:53','-8.0','-0.25','61.0','0.0','61.92','0.0','0.0',3,0,1),(153,18,'2026-03-27 15:42:53','2026-03-27 15:42:53','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(154,18,'2026-03-27 15:42:53','2026-03-27 15:42:53','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(155,18,'2026-03-27 15:42:53','2026-03-27 15:42:53','-9.0','-1.0','3.0','0.0','61.92','0.0','0.0',4,0,0),(156,18,'2026-03-27 15:42:53','2026-03-27 15:42:53','-8.0','-0.25','61.0','0.0','61.92','0.0','0.0',4,0,1),(157,18,'2026-03-27 15:42:53','2026-03-27 15:42:53','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(158,18,'2026-03-27 15:42:53','2026-03-27 15:42:53','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(159,19,'2026-03-28 09:19:07','2026-03-28 09:19:07','-5.25','-0.50','120','0.0','64.53','0.0','0.0',1,0,0),(160,19,'2026-03-28 09:19:07','2026-03-28 09:19:07','-6.25','-0.50','72','0.0','64.53','0.0','0.0',1,0,1),(161,19,'2026-03-28 09:19:07','2026-03-28 09:19:07','-5.5','-1.0','125.0','0.0','64.53','0.0','0.0',3,0,0),(162,19,'2026-03-28 09:19:07','2026-03-28 09:19:07','-6.25','-0.5','67.0','0.0','64.53','0.0','0.0',3,0,1),(163,19,'2026-03-28 09:19:07','2026-03-28 09:19:07','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(164,19,'2026-03-28 09:19:07','2026-03-28 09:19:07','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(165,19,'2026-03-28 09:19:07','2026-03-28 09:19:07','-5.5','-1.0','125.0','0.0','64.53','0.0','0.0',4,0,0),(166,19,'2026-03-28 09:19:07','2026-03-28 09:19:07','-6.25','-0.5','67.0','0.0','64.53','0.0','0.0',4,0,1),(167,19,'2026-03-28 09:19:07','2026-03-28 09:19:07','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(168,19,'2026-03-28 09:19:07','2026-03-28 09:19:07','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(169,20,'2026-03-28 09:35:41','2026-03-28 09:35:41','-5.75','-0.50','103','0.0','64.78','0.0','0.0',1,0,0),(170,20,'2026-03-28 09:35:41','2026-03-28 09:35:41','-6.75','-0.50','70','0.0','64.78','0.0','0.0',1,0,1),(171,20,'2026-03-28 09:35:41','2026-03-28 09:35:41','-6.25','0.0','138.0','0.0','64.78','0.0','0.0',3,0,0),(172,20,'2026-03-28 09:35:41','2026-03-28 09:35:41','-6.5','-0.75','65.0','0.0','64.78','0.0','0.0',3,0,1),(173,20,'2026-03-28 09:35:41','2026-03-28 09:35:41','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(174,20,'2026-03-28 09:35:41','2026-03-28 09:35:41','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(175,20,'2026-03-28 09:35:41','2026-03-28 09:35:41','-6.25','0.0','138.0','0.0','64.78','0.0','0.0',4,0,0),(176,20,'2026-03-28 09:35:41','2026-03-28 09:35:41','-6.5','-0.75','65.0','0.0','64.78','0.0','0.0',4,0,1),(177,20,'2026-03-28 09:35:41','2026-03-28 09:35:41','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(178,20,'2026-03-28 09:35:41','2026-03-28 09:35:41','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(179,21,'2026-03-28 09:46:18','2026-03-28 09:46:18','-7.25','-1.00','2','0.0','62.39','0.0','0.0',1,0,0),(180,21,'2026-03-28 09:46:18','2026-03-28 09:46:18','-7.25','-1.00','5','0.0','62.39','0.0','0.0',1,0,1),(181,21,'2026-03-28 09:46:18','2026-03-28 09:46:18','-7.0','-1.0','2.0','0.0','62.39','0.0','0.0',3,0,0),(182,21,'2026-03-28 09:46:18','2026-03-28 09:46:18','-7.0','-1.0','5.0','0.0','62.39','0.0','0.0',3,0,1),(183,21,'2026-03-28 09:46:18','2026-03-28 09:46:18','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(184,21,'2026-03-28 09:46:18','2026-03-28 09:46:18','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(185,21,'2026-03-28 09:46:18','2026-03-28 09:46:18','-7.0','-1.0','2.0','0.0','62.39','0.0','0.0',4,0,0),(186,21,'2026-03-28 09:46:18','2026-03-28 09:46:18','-7.0','-1.0','5.0','0.0','62.39','0.0','0.0',4,0,1),(187,21,'2026-03-28 09:46:18','2026-03-28 09:46:18','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(188,21,'2026-03-28 09:46:18','2026-03-28 09:46:18','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(189,22,'2026-03-28 12:08:32','2026-03-28 12:08:32','3.25','-6.00','11','0.0','57.66','0.0','0.0',1,0,0),(190,22,'2026-03-28 12:08:32','2026-03-28 12:08:32','-3.25','-0.25','8','0.0','57.66','0.0','0.0',1,0,1),(191,22,'2026-03-28 12:08:32','2026-03-28 12:08:32','3.25','-5.75','14.0','0.0','57.66','0.0','0.0',3,0,0),(192,22,'2026-03-28 12:08:32','2026-03-28 12:08:32','-3.25','-0.25','8.0','0.0','57.66','0.0','0.0',3,0,1),(193,22,'2026-03-28 12:08:32','2026-03-28 12:08:32','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(194,22,'2026-03-28 12:08:32','2026-03-28 12:08:32','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(195,22,'2026-03-28 12:08:32','2026-03-28 12:08:32','3.25','-5.75','14.0','0.0','57.66','0.0','0.0',4,0,0),(196,22,'2026-03-28 12:08:32','2026-03-28 12:08:32','-3.25','-0.25','8.0','0.0','57.66','0.0','0.0',4,0,1),(197,22,'2026-03-28 12:08:32','2026-03-28 12:08:32','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(198,22,'2026-03-28 12:08:32','2026-03-28 12:08:32','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(199,23,'2026-03-28 16:47:33','2026-03-28 16:47:33','-4.75','-2.25','1','0.0','58.86','0.0','0.0',1,0,0),(200,23,'2026-03-28 16:47:33','2026-03-28 16:47:33','-4.75','-3.00','10','0.0','58.86','0.0','0.0',1,0,1),(201,23,'2026-03-28 16:47:33','2026-03-28 16:47:33','-4.75','-2.25','1.0','0.0','58.86','0.0','0.0',3,0,0),(202,23,'2026-03-28 16:47:33','2026-03-28 16:47:33','-4.25','-2.75','9.0','0.0','58.86','0.0','0.0',3,0,1),(203,23,'2026-03-28 16:47:33','2026-03-28 16:47:33','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(204,23,'2026-03-28 16:47:33','2026-03-28 16:47:33','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(205,23,'2026-03-28 16:47:33','2026-03-28 16:47:33','-4.75','-2.25','1.0','0.0','58.86','0.0','0.0',4,0,0),(206,23,'2026-03-28 16:47:33','2026-03-28 16:47:33','-4.25','-2.75','9.0','0.0','58.86','0.0','0.0',4,0,1),(207,23,'2026-03-28 16:47:33','2026-03-28 16:47:33','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(208,23,'2026-03-28 16:47:33','2026-03-28 16:47:33','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(209,24,'2026-03-30 09:32:26','2026-03-30 09:32:26','-2.25','-0.50','89','0.0','64.40','0.0','0.0',1,0,0),(210,24,'2026-03-30 09:32:26','2026-03-30 09:32:26','-2.00','-0.50','60','0.0','64.40','0.0','0.0',1,0,1),(211,24,'2026-03-30 09:32:26','2026-03-30 09:32:26','-2.25','-0.5','84.0','0.0','64.4','0.0','0.0',3,0,0),(212,24,'2026-03-30 09:32:26','2026-03-30 09:32:26','-2.25','-0.25','85.0','0.0','64.4','0.0','0.0',3,0,1),(213,24,'2026-03-30 09:32:26','2026-03-30 09:32:26','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(214,24,'2026-03-30 09:32:26','2026-03-30 09:32:26','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(215,24,'2026-03-30 09:32:26','2026-03-30 09:32:26','-2.25','-0.5','84.0','0.0','64.4','0.0','0.0',4,0,0),(216,24,'2026-03-30 09:32:26','2026-03-30 09:32:26','-2.25','-0.25','85.0','0.0','64.4','0.0','0.0',4,0,1),(217,24,'2026-03-30 09:32:26','2026-03-30 09:32:26','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(218,24,'2026-03-30 09:32:26','2026-03-30 09:32:26','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(219,25,'2026-03-30 10:48:24','2026-03-30 10:48:24','-6.75','-1.25','3','0.0','63.02','0.0','0.0',1,0,0),(220,25,'2026-03-30 10:48:24','2026-03-30 10:48:24','-7.25','-1.25','5','0.0','63.02','0.0','0.0',1,0,1),(221,25,'2026-03-30 10:48:24','2026-03-30 10:48:24','-6.75','-1.25','8.0','0.0','63.02','0.0','0.0',3,0,0),(222,25,'2026-03-30 10:48:24','2026-03-30 10:48:24','-6.75','-1.25','5.0','0.0','63.02','0.0','0.0',3,0,1),(223,25,'2026-03-30 10:48:24','2026-03-30 10:48:24','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(224,25,'2026-03-30 10:48:24','2026-03-30 10:48:24','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(225,25,'2026-03-30 10:48:24','2026-03-30 10:48:24','-6.75','-1.25','8.0','0.0','63.02','0.0','0.0',4,0,0),(226,25,'2026-03-30 10:48:24','2026-03-30 10:48:24','-6.75','-1.25','5.0','0.0','63.02','0.0','0.0',4,0,1),(227,25,'2026-03-30 10:48:24','2026-03-30 10:48:24','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(228,25,'2026-03-30 10:48:24','2026-03-30 10:48:24','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(229,26,'2026-03-30 11:38:06','2026-03-30 11:38:06','4.50','-6.50','8','0.0','57.66','0.0','0.0',1,0,0),(230,26,'2026-03-30 11:38:06','2026-03-30 11:38:06','-2.75','-0.50','9','0.0','57.66','0.0','0.0',1,0,1),(231,26,'2026-03-30 11:38:06','2026-03-30 11:38:06','4.25','-6.0','13.0','0.0','57.66','0.0','0.0',3,0,0),(232,26,'2026-03-30 11:38:06','2026-03-30 11:38:06','-3.25','0.0','9.0','0.0','57.66','0.0','0.0',3,0,1),(233,26,'2026-03-30 11:38:06','2026-03-30 11:38:06','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(234,26,'2026-03-30 11:38:06','2026-03-30 11:38:06','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(235,26,'2026-03-30 11:38:06','2026-03-30 11:38:06','4.25','-6.0','13.0','0.0','57.66','0.0','0.0',4,0,0),(236,26,'2026-03-30 11:38:06','2026-03-30 11:38:06','-3.25','0.0','9.0','0.0','57.66','0.0','0.0',4,0,1),(237,26,'2026-03-30 11:38:06','2026-03-30 11:38:06','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(238,26,'2026-03-30 11:38:06','2026-03-30 11:38:06','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(239,27,'2026-03-30 12:58:51','2026-03-30 12:58:51','-3.75','-1.00','79','0.0','65.46','0.0','0.0',1,0,0),(240,27,'2026-03-30 12:58:51','2026-03-30 12:58:51','-3.25','-1.50','87','0.0','65.46','0.0','0.0',1,0,1),(241,27,'2026-03-30 12:58:51','2026-03-30 12:58:51','-3.75','-0.75','94.0','0.0','65.46','0.0','0.0',3,0,0),(242,27,'2026-03-30 12:58:51','2026-03-30 12:58:51','-3.25','-1.5','86.0','0.0','65.46','0.0','0.0',3,0,1),(243,27,'2026-03-30 12:58:51','2026-03-30 12:58:51','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(244,27,'2026-03-30 12:58:51','2026-03-30 12:58:51','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(245,27,'2026-03-30 12:58:51','2026-03-30 12:58:51','-3.75','-0.75','94.0','0.0','65.46','0.0','0.0',4,0,0),(246,27,'2026-03-30 12:58:51','2026-03-30 12:58:51','-3.25','-1.5','86.0','0.0','65.46','0.0','0.0',4,0,1),(247,27,'2026-03-30 12:58:51','2026-03-30 12:58:51','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(248,27,'2026-03-30 12:58:51','2026-03-30 12:58:51','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(249,28,'2026-03-30 13:03:59','2026-03-30 13:03:59','-3.75','-1.25','79','0.0','65.74','0.0','0.0',1,0,0),(250,28,'2026-03-30 13:03:59','2026-03-30 13:03:59','-3.50','-1.00','85','0.0','65.74','0.0','0.0',1,0,1),(251,28,'2026-03-30 13:03:59','2026-03-30 13:03:59','-3.75','-1.0','99.0','0.0','65.74','0.0','0.0',3,0,0),(252,28,'2026-03-30 13:03:59','2026-03-30 13:03:59','-3.5','-1.5','85.0','0.0','65.74','0.0','0.0',3,0,1),(253,28,'2026-03-30 13:03:59','2026-03-30 13:03:59','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(254,28,'2026-03-30 13:03:59','2026-03-30 13:03:59','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(255,28,'2026-03-30 13:03:59','2026-03-30 13:03:59','-3.75','-1.0','99.0','0.0','65.74','0.0','0.0',4,0,0),(256,28,'2026-03-30 13:03:59','2026-03-30 13:03:59','-3.5','-1.5','85.0','0.0','65.74','0.0','0.0',4,0,1),(257,28,'2026-03-30 13:03:59','2026-03-30 13:03:59','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(258,28,'2026-03-30 13:03:59','2026-03-30 13:03:59','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(259,29,'2026-03-30 13:15:32','2026-03-30 13:15:32','-7.50','-0.75','11','0.0','62.93','0.0','0.0',1,0,0),(260,29,'2026-03-30 13:15:32','2026-03-30 13:15:32','-7.00','-0.25','55','0.0','62.93','0.0','0.0',1,0,1),(261,29,'2026-03-30 13:15:32','2026-03-30 13:15:32','-7.5','-0.75','11.0','0.0','62.93','0.0','0.0',3,0,0),(262,29,'2026-03-30 13:15:32','2026-03-30 13:15:32','-7.0','-0.25','55.0','0.0','62.93','0.0','0.0',3,0,1),(263,29,'2026-03-30 13:15:32','2026-03-30 13:15:32','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(264,29,'2026-03-30 13:15:32','2026-03-30 13:15:32','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(265,29,'2026-03-30 13:15:32','2026-03-30 13:15:32','-7.5','-0.75','11.0','0.0','62.93','0.0','0.0',4,0,0),(266,29,'2026-03-30 13:15:32','2026-03-30 13:15:32','-7.0','-0.25','55.0','0.0','62.93','0.0','0.0',4,0,1),(267,29,'2026-03-30 13:15:32','2026-03-30 13:15:32','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(268,29,'2026-03-30 13:15:32','2026-03-30 13:15:32','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(269,30,'2026-03-30 14:41:48','2026-03-30 14:41:48','-6.00','-4.00','2','0.0','60.14','0.0','0.0',1,0,0),(270,30,'2026-03-30 14:41:48','2026-03-30 14:41:48','-5.00','-3.75','1','0.0','60.14','0.0','0.0',1,0,1),(271,30,'2026-03-30 14:41:48','2026-03-30 14:41:48','-6.0','-3.5','2.0','0.0','60.14','0.0','0.0',3,0,0),(272,30,'2026-03-30 14:41:48','2026-03-30 14:41:48','-5.0','-2.75','359.0','0.0','60.14','0.0','0.0',3,0,1),(273,30,'2026-03-30 14:41:48','2026-03-30 14:41:48','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(274,30,'2026-03-30 14:41:48','2026-03-30 14:41:48','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(275,30,'2026-03-30 14:41:49','2026-03-30 14:41:49','-6.0','-3.5','2.0','0.0','60.14','0.0','0.0',4,0,0),(276,30,'2026-03-30 14:41:49','2026-03-30 14:41:49','-5.0','-2.75','359.0','0.0','60.14','0.0','0.0',4,0,1),(277,30,'2026-03-30 14:41:49','2026-03-30 14:41:49','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(278,30,'2026-03-30 14:41:49','2026-03-30 14:41:49','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(279,31,'2026-03-30 14:46:13','2026-03-30 14:46:13','-4.00','-2.50','2','0.0','60.58','0.0','0.0',1,0,0),(280,31,'2026-03-30 14:46:13','2026-03-30 14:46:13','-4.00','-3.00','5','0.0','60.58','0.0','0.0',1,0,1),(281,31,'2026-03-30 14:46:13','2026-03-30 14:46:13','-4.0','-2.5','2.0','0.0','60.58','0.0','0.0',3,0,0),(282,31,'2026-03-30 14:46:13','2026-03-30 14:46:13','-4.0','-2.0','1.0','0.0','60.58','0.0','0.0',3,0,1),(283,31,'2026-03-30 14:46:13','2026-03-30 14:46:13','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(284,31,'2026-03-30 14:46:13','2026-03-30 14:46:13','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(285,31,'2026-03-30 14:46:13','2026-03-30 14:46:13','-4.0','-2.5','2.0','0.0','60.58','0.0','0.0',4,0,0),(286,31,'2026-03-30 14:46:13','2026-03-30 14:46:13','-4.0','-2.0','1.0','0.0','60.58','0.0','0.0',4,0,1),(287,31,'2026-03-30 14:46:13','2026-03-30 14:46:13','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(288,31,'2026-03-30 14:46:13','2026-03-30 14:46:13','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(289,32,'2026-03-30 14:50:08','2026-03-30 14:50:08','-4.00','-2.25','2','0.0','61.31','0.0','0.0',1,0,0),(290,32,'2026-03-30 14:50:08','2026-03-30 14:50:08','-4.25','-3.00','7','0.0','61.31','0.0','0.0',1,0,1),(291,32,'2026-03-30 14:50:08','2026-03-30 14:50:08','-4.0','-2.0','360.0','0.0','61.31','0.0','0.0',3,0,0),(292,32,'2026-03-30 14:50:08','2026-03-30 14:50:08','-4.25','-2.5','358.0','0.0','61.31','0.0','0.0',3,0,1),(293,32,'2026-03-30 14:50:08','2026-03-30 14:50:08','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(294,32,'2026-03-30 14:50:08','2026-03-30 14:50:08','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(295,32,'2026-03-30 14:50:08','2026-03-30 14:50:08','-4.0','-2.0','360.0','0.0','61.31','0.0','0.0',4,0,0),(296,32,'2026-03-30 14:50:08','2026-03-30 14:50:08','-4.25','-2.5','358.0','0.0','61.31','0.0','0.0',4,0,1),(297,32,'2026-03-30 14:50:08','2026-03-30 14:50:08','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(298,32,'2026-03-30 14:50:08','2026-03-30 14:50:08','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(299,33,'2026-03-30 16:25:03','2026-03-30 16:25:03','4.50','-6.75','8','0.0','56.99','0.0','0.0',1,0,0),(300,33,'2026-03-30 16:25:03','2026-03-30 16:25:03','-2.25','-0.75','2','0.0','56.99','0.0','0.0',1,0,1),(301,33,'2026-03-30 16:25:03','2026-03-30 16:25:03','3.0','-6.0','12.0','0.0','56.99','0.0','0.0',3,0,0),(302,33,'2026-03-30 16:25:03','2026-03-30 16:25:03','-3.25','0.0','357.0','0.0','56.99','0.0','0.0',3,0,1),(303,33,'2026-03-30 16:25:03','2026-03-30 16:25:03','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(304,33,'2026-03-30 16:25:03','2026-03-30 16:25:03','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(305,33,'2026-03-30 16:25:03','2026-03-30 16:25:03','3.0','-6.0','12.0','0.0','56.99','0.0','0.0',4,0,0),(306,33,'2026-03-30 16:25:03','2026-03-30 16:25:03','-3.25','0.0','357.0','0.0','56.99','0.0','0.0',4,0,1),(307,33,'2026-03-30 16:25:03','2026-03-30 16:25:03','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(308,33,'2026-03-30 16:25:03','2026-03-30 16:25:03','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(309,34,'2026-03-30 16:39:06','2026-03-30 16:39:06','-4.25','-1.00','86','0.0','65.87','0.0','0.0',1,0,0),(310,34,'2026-03-30 16:39:06','2026-03-30 16:39:06','-3.50','-1.00','91','0.0','65.87','0.0','0.0',1,0,1),(311,34,'2026-03-30 16:39:06','2026-03-30 16:39:06','-4.25','-1.0','86.0','0.0','65.87','0.0','0.0',3,0,0),(312,34,'2026-03-30 16:39:06','2026-03-30 16:39:06','-3.25','-1.0','86.0','0.0','65.87','0.0','0.0',3,0,1),(313,34,'2026-03-30 16:39:06','2026-03-30 16:39:06','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(314,34,'2026-03-30 16:39:06','2026-03-30 16:39:06','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(315,34,'2026-03-30 16:39:06','2026-03-30 16:39:06','-4.25','-1.0','86.0','0.0','65.87','0.0','0.0',4,0,0),(316,34,'2026-03-30 16:39:06','2026-03-30 16:39:06','-3.25','-1.0','86.0','0.0','65.87','0.0','0.0',4,0,1),(317,34,'2026-03-30 16:39:06','2026-03-30 16:39:06','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(318,34,'2026-03-30 16:39:06','2026-03-30 16:39:06','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(319,35,'2026-04-11 11:44:42','2026-04-11 11:44:42','-2.25','-0.50','90','0.0','64.43','0.0','0.0',1,0,0),(320,35,'2026-04-11 11:44:42','2026-04-11 11:44:42','-2.25','-0.50','87','0.0','64.43','0.0','0.0',1,0,1),(321,35,'2026-04-11 11:44:42','2026-04-11 11:44:42','-2.0','-0.5','90.0','0.0','64.43','0.0','0.0',3,0,0),(322,35,'2026-04-11 11:44:42','2026-04-11 11:44:42','-2.0','-0.5','87.0','0.0','64.43','0.0','0.0',3,0,1),(323,35,'2026-04-11 11:44:42','2026-04-11 11:44:42','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(324,35,'2026-04-11 11:44:42','2026-04-11 11:44:42','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(325,35,'2026-04-11 11:44:42','2026-04-11 11:44:42','-2.0','-0.5','90.0','0.0','64.43','0.0','0.0',4,0,0),(326,35,'2026-04-11 11:44:42','2026-04-11 11:44:42','-2.0','-0.5','87.0','0.0','64.43','0.0','0.0',4,0,1),(327,35,'2026-04-11 11:44:42','2026-04-11 11:44:42','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(328,35,'2026-04-11 11:44:42','2026-04-11 11:44:42','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(329,36,'2026-04-13 09:53:35','2026-04-13 09:53:35','-5.25','-1.00','33','0.0','64.56','0.0','0.0',1,0,0),(330,36,'2026-04-13 09:53:35','2026-04-13 09:53:35','-6.25','-0.75','55','0.0','64.56','0.0','0.0',1,0,1),(331,36,'2026-04-13 09:53:35','2026-04-13 09:53:35','-5.25','-1.0','323.0','0.0','64.56','0.0','0.0',3,0,0),(332,36,'2026-04-13 09:53:35','2026-04-13 09:53:35','-6.25','-0.75','65.0','0.0','64.56','0.0','0.0',3,0,1),(333,36,'2026-04-13 09:53:35','2026-04-13 09:53:35','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(334,36,'2026-04-13 09:53:35','2026-04-13 09:53:35','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(335,36,'2026-04-13 09:53:35','2026-04-13 09:53:35','-5.25','-1.0','323.0','0.0','64.56','0.0','0.0',4,0,0),(336,36,'2026-04-13 09:53:35','2026-04-13 09:53:35','-6.25','-0.75','65.0','0.0','64.56','0.0','0.0',4,0,1),(337,36,'2026-04-13 09:53:35','2026-04-13 09:53:35','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(338,36,'2026-04-13 09:53:35','2026-04-13 09:53:35','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(339,37,'2026-04-13 10:16:31','2026-04-13 10:16:31','3.50','-6.25','12','0.0','57.33','0.0','0.0',1,0,0),(340,37,'2026-04-13 10:16:31','2026-04-13 10:16:31','-2.75','-0.75','2','0.0','57.33','0.0','0.0',1,0,1),(341,37,'2026-04-13 10:16:31','2026-04-13 10:16:31','4.25','-6.0','14.0','0.0','57.33','0.0','0.0',3,0,0),(342,37,'2026-04-13 10:16:31','2026-04-13 10:16:31','-0.75','-0.25','2.0','0.0','57.33','0.0','0.0',3,0,1),(343,37,'2026-04-13 10:16:31','2026-04-13 10:16:31','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(344,37,'2026-04-13 10:16:31','2026-04-13 10:16:31','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(345,37,'2026-04-13 10:16:31','2026-04-13 10:16:31','4.25','-6.0','14.0','0.0','57.33','0.0','0.0',4,0,0),(346,37,'2026-04-13 10:16:31','2026-04-13 10:16:31','-0.75','-0.25','2.0','0.0','57.33','0.0','0.0',4,0,1),(347,37,'2026-04-13 10:16:32','2026-04-13 10:16:32','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(348,37,'2026-04-13 10:16:32','2026-04-13 10:16:32','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(349,38,'2026-04-13 10:20:37','2026-04-13 10:20:37','4.00','-6.50','11','0.0','57.81','0.0','0.0',1,0,0),(350,38,'2026-04-13 10:20:37','2026-04-13 10:20:37','-2.75','-0.75','9','0.0','57.81','0.0','0.0',1,0,1),(351,38,'2026-04-13 10:20:37','2026-04-13 10:20:37','2.25','-6.75','15.0','0.0','57.81','0.0','0.0',3,0,0),(352,38,'2026-04-13 10:20:37','2026-04-13 10:20:37','-2.0','-0.25','9.0','0.0','57.81','0.0','0.0',3,0,1),(353,38,'2026-04-13 10:20:37','2026-04-13 10:20:37','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(354,38,'2026-04-13 10:20:37','2026-04-13 10:20:37','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(355,38,'2026-04-13 10:20:37','2026-04-13 10:20:37','2.25','-6.75','15.0','0.0','57.81','0.0','0.0',4,0,0),(356,38,'2026-04-13 10:20:37','2026-04-13 10:20:37','-2.0','-0.25','9.0','0.0','57.81','0.0','0.0',4,0,1),(357,38,'2026-04-13 10:20:37','2026-04-13 10:20:37','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(358,38,'2026-04-13 10:20:37','2026-04-13 10:20:37','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(359,39,'2026-04-13 11:09:01','2026-04-13 11:09:01','-5.50','-0.75','66','0.0','64.21','0.0','0.0',1,0,0),(360,39,'2026-04-13 11:09:01','2026-04-13 11:09:01','-6.50','-0.50','37','0.0','64.21','0.0','0.0',1,0,1),(361,39,'2026-04-13 11:09:01','2026-04-13 11:09:01','-5.5','-0.75','116.0','0.0','64.21','0.0','0.0',3,0,0),(362,39,'2026-04-13 11:09:01','2026-04-13 11:09:01','-6.75','-0.5','47.0','0.0','64.21','0.0','0.0',3,0,1),(363,39,'2026-04-13 11:09:01','2026-04-13 11:09:01','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(364,39,'2026-04-13 11:09:01','2026-04-13 11:09:01','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(365,39,'2026-04-13 11:09:01','2026-04-13 11:09:01','-5.5','-0.75','116.0','0.0','64.21','0.0','0.0',4,0,0),(366,39,'2026-04-13 11:09:01','2026-04-13 11:09:01','-6.75','-0.5','47.0','0.0','64.21','0.0','0.0',4,0,1),(367,39,'2026-04-13 11:09:01','2026-04-13 11:09:01','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(368,39,'2026-04-13 11:09:01','2026-04-13 11:09:01','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(369,40,'2026-04-13 11:17:31','2026-04-13 11:17:31','-4.50','-0.50','16','0.0','59.63','0.0','0.0',1,0,0),(370,40,'2026-04-13 11:17:31','2026-04-13 11:17:31','-4.00','-0.75','34','0.0','59.63','0.0','0.0',1,0,1),(371,40,'2026-04-13 11:17:31','2026-04-13 11:17:31','-4.50','-0.50','16','0.0','59.63','0.0','0.0',3,0,0),(372,40,'2026-04-13 11:17:31','2026-04-13 11:17:31','-4.00','-0.75','34','0.0','59.63','0.0','0.0',3,0,1),(373,40,'2026-04-13 11:17:31','2026-04-13 11:17:31','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(374,40,'2026-04-13 11:17:31','2026-04-13 11:17:31','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(375,40,'2026-04-13 11:17:31','2026-04-13 11:17:31','-4.50','-0.50','16','0.0','59.63','0.0','0.0',4,0,0),(376,40,'2026-04-13 11:17:31','2026-04-13 11:17:31','-4.00','-0.75','34','0.0','59.63','0.0','0.0',4,0,1),(377,40,'2026-04-13 11:17:31','2026-04-13 11:17:31','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(378,40,'2026-04-13 11:17:31','2026-04-13 11:17:31','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(379,41,'2026-04-13 14:59:35','2026-04-13 14:59:35','-5.00','-0.75','39','0.0','63.98','0.0','0.0',1,0,0),(380,41,'2026-04-13 14:59:35','2026-04-13 14:59:35','-6.25','-0.75','33','0.0','63.98','0.0','0.0',1,0,1),(381,41,'2026-04-13 14:59:35','2026-04-13 14:59:35','-4.75','0.0','119.0','0.0','63.98','0.0','0.0',3,0,0),(382,41,'2026-04-13 14:59:35','2026-04-13 14:59:35','-6.25','-0.5','78.0','0.0','63.98','0.0','0.0',3,0,1),(383,41,'2026-04-13 14:59:35','2026-04-13 14:59:35','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(384,41,'2026-04-13 14:59:35','2026-04-13 14:59:35','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(385,41,'2026-04-13 14:59:35','2026-04-13 14:59:35','-4.75','0.0','119.0','0.0','63.98','0.0','0.0',4,0,0),(386,41,'2026-04-13 14:59:35','2026-04-13 14:59:35','-6.25','-0.5','78.0','0.0','63.98','0.0','0.0',4,0,1),(387,41,'2026-04-13 14:59:35','2026-04-13 14:59:35','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(388,41,'2026-04-13 14:59:35','2026-04-13 14:59:35','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(389,42,'2026-04-13 15:54:13','2026-04-13 15:54:13','-6.75','-1.00','1','0.0','63.91','0.0','0.0',1,0,0),(390,42,'2026-04-13 15:54:13','2026-04-13 15:54:13','-6.50','-1.50','1','0.0','63.91','0.0','0.0',1,0,1),(391,42,'2026-04-13 15:54:13','2026-04-13 15:54:13','-7.0','-1.0','1.0','0.0','63.91','0.0','0.0',3,0,0),(392,42,'2026-04-13 15:54:13','2026-04-13 15:54:13','-6.75','-1.5','1.0','0.0','63.91','0.0','0.0',3,0,1),(393,42,'2026-04-13 15:54:13','2026-04-13 15:54:13','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(394,42,'2026-04-13 15:54:13','2026-04-13 15:54:13','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(395,42,'2026-04-13 15:54:13','2026-04-13 15:54:13','-7.0','-1.0','1.0','0.0','63.91','0.0','0.0',4,0,0),(396,42,'2026-04-13 15:54:13','2026-04-13 15:54:13','-6.75','-1.5','1.0','0.0','63.91','0.0','0.0',4,0,1),(397,42,'2026-04-13 15:54:13','2026-04-13 15:54:13','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(398,42,'2026-04-13 15:54:13','2026-04-13 15:54:13','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(399,43,'2026-04-13 15:58:13','2026-04-13 15:58:13','-6.50','-1.25','1','0.0','63.08','0.0','0.0',1,0,0),(400,43,'2026-04-13 15:58:13','2026-04-13 15:58:13','-6.75','-1.50','2','0.0','63.08','0.0','0.0',1,0,1),(401,43,'2026-04-13 15:58:13','2026-04-13 15:58:13','-6.75','-1.25','1.0','0.0','63.08','0.0','0.0',3,0,0),(402,43,'2026-04-13 15:58:13','2026-04-13 15:58:13','-6.75','-1.5','2.0','0.0','63.08','0.0','0.0',3,0,1),(403,43,'2026-04-13 15:58:13','2026-04-13 15:58:13','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(404,43,'2026-04-13 15:58:13','2026-04-13 15:58:13','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(405,43,'2026-04-13 15:58:13','2026-04-13 15:58:13','-6.75','-1.25','1.0','0.0','63.08','0.0','0.0',4,0,0),(406,43,'2026-04-13 15:58:13','2026-04-13 15:58:13','-6.75','-1.5','2.0','0.0','63.08','0.0','0.0',4,0,1),(407,43,'2026-04-13 15:58:13','2026-04-13 15:58:13','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(408,43,'2026-04-13 15:58:13','2026-04-13 15:58:13','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(409,44,'2026-04-13 16:45:11','2026-04-13 16:45:11','4.00','-6.50','11','0.0','56.86','0.0','0.0',1,0,0),(410,44,'2026-04-13 16:45:11','2026-04-13 16:45:11','-2.75','-0.75','3','0.0','56.86','0.0','0.0',1,0,1),(411,44,'2026-04-13 16:45:11','2026-04-13 16:45:11','4.00','-6.50','11','0.0','56.86','0.0','0.0',3,0,0),(412,44,'2026-04-13 16:45:11','2026-04-13 16:45:11','-2.75','-0.75','3','0.0','56.86','0.0','0.0',3,0,1),(413,44,'2026-04-13 16:45:11','2026-04-13 16:45:11','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(414,44,'2026-04-13 16:45:11','2026-04-13 16:45:11','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(415,44,'2026-04-13 16:45:11','2026-04-13 16:45:11','4.00','-6.50','11','0.0','56.86','0.0','0.0',4,0,0),(416,44,'2026-04-13 16:45:11','2026-04-13 16:45:11','-2.75','-0.75','3','0.0','56.86','0.0','0.0',4,0,1),(417,44,'2026-04-13 16:45:11','2026-04-13 16:45:11','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(418,44,'2026-04-13 16:45:11','2026-04-13 16:45:11','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(419,45,'2026-04-14 15:32:33','2026-04-14 15:32:33','-4.00','-2.25','6','0.0','62.38','0.0','0.0',1,0,0),(420,45,'2026-04-14 15:32:33','2026-04-14 15:32:33','-4.25','-2.75','7','0.0','62.38','0.0','0.0',1,0,1),(421,45,'2026-04-14 15:32:33','2026-04-14 15:32:33','-4.0','-2.25','6.0','0.0','62.38','0.0','0.0',3,0,0),(422,45,'2026-04-14 15:32:33','2026-04-14 15:32:33','-4.25','-2.75','7.0','0.0','62.38','0.0','0.0',3,0,1),(423,45,'2026-04-14 15:32:33','2026-04-14 15:32:33','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(424,45,'2026-04-14 15:32:33','2026-04-14 15:32:33','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(425,45,'2026-04-14 15:32:33','2026-04-14 15:32:33','-4.0','-2.25','6.0','0.0','62.38','0.0','0.0',4,0,0),(426,45,'2026-04-14 15:32:33','2026-04-14 15:32:33','-4.25','-2.75','7.0','0.0','62.38','0.0','0.0',4,0,1),(427,45,'2026-04-14 15:32:33','2026-04-14 15:32:33','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(428,45,'2026-04-14 15:32:33','2026-04-14 15:32:33','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1),(429,46,'2026-04-14 17:27:41','2026-04-14 17:27:41','4.00','-6.50','11','0.0','56.72','0.0','0.0',1,0,0),(430,46,'2026-04-14 17:27:41','2026-04-14 17:27:41','-2.75','-0.75','3','0.0','56.72','0.0','0.0',1,0,1),(431,46,'2026-04-14 17:27:41','2026-04-14 17:27:41','4.00','-6.50','11','0.0','56.72','0.0','0.0',3,0,0),(432,46,'2026-04-14 17:27:41','2026-04-14 17:27:41','-2.75','-0.75','3','0.0','56.72','0.0','0.0',3,0,1),(433,46,'2026-04-14 17:27:41','2026-04-14 17:27:41','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,0),(434,46,'2026-04-14 17:27:41','2026-04-14 17:27:41','0.0','0.0','0.0','0.0','64.0','0.0','0.0',3,1,1),(435,46,'2026-04-14 17:27:41','2026-04-14 17:27:41','4.00','-6.50','11','0.0','56.72','0.0','0.0',4,0,0),(436,46,'2026-04-14 17:27:41','2026-04-14 17:27:41','-2.75','-0.75','3','0.0','56.72','0.0','0.0',4,0,1),(437,46,'2026-04-14 17:27:41','2026-04-14 17:27:41','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,0),(438,46,'2026-04-14 17:27:41','2026-04-14 17:27:41','0.0','0.0','0.0','0.0','64.0','0.0','0.0',4,1,1);
/*!40000 ALTER TABLE `optometry_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `optometry_records`
--

DROP TABLE IF EXISTS `optometry_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `optometry_records` (
  `optometry_records_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '验光记录ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `customer_id` bigint(20) DEFAULT NULL COMMENT '顾客ID',
  `customer_name` varchar(255) DEFAULT NULL COMMENT '顾客姓名',
  `optometrist_id` bigint(20) NOT NULL COMMENT '验光师ID',
  `optometrist_name` varchar(255) DEFAULT NULL COMMENT '验光师姓名',
  `store_id` bigint(20) NOT NULL COMMENT '门店ID',
  `store_name` varchar(255) NOT NULL COMMENT '门店名称',
  `store_phone` varchar(20) NOT NULL COMMENT '门店电话',
  `is_delete` int(1) NOT NULL DEFAULT '0' COMMENT '逻辑删0否1是',
  `ai_data` varchar(2000) DEFAULT NULL COMMENT 'ai数据',
  PRIMARY KEY (`optometry_records_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='验光记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `optometry_records`
--

LOCK TABLES `optometry_records` WRITE;
/*!40000 ALTER TABLE `optometry_records` DISABLE KEYS */;
INSERT INTO `optometry_records` VALUES (1,'2024-11-27 15:49:29','2024-11-27 15:49:29',3,'hfhygh',2,'紫菜汤',1,'测试','18775075395',0,NULL),(2,'2024-12-12 16:02:13','2024-12-12 16:02:13',3,'hfhygh',1,'桂花鱼',1,'测试','17751070969',0,NULL),(3,'2025-02-18 15:27:30','2025-02-25 15:06:48',3,'hfhygh',2,'紫菜汤',1,'测试','18812332121\r\n',0,NULL),(4,'2025-02-18 17:10:10','2025-02-25 15:06:54',3,'hfhygh',2,'紫菜汤',1,'测试','18812332121\r\n',0,NULL),(5,'2025-02-18 17:10:28','2025-02-25 15:07:01',3,'hfhygh',2,'紫菜汤',1,'测试','18812332121\r\n',0,NULL),(6,'2025-02-20 09:27:53','2025-02-25 15:07:01',3,'hfhygh',2,'紫菜汤',1,'测试','18812332121\r\n',0,NULL),(7,'2025-02-20 09:28:08','2025-02-25 15:07:01',3,'hfhygh',2,'紫菜汤',1,'测试','18812332121\r\n',0,NULL),(8,'2025-02-20 09:28:19','2025-02-25 15:07:01',3,'hfhygh',2,'紫菜汤',1,'测试','18812332121\r\n',0,NULL),(9,'2025-02-20 11:04:26','2025-02-25 15:07:01',3,'hfhygh',2,'紫菜汤',1,'测试','18812332121\r\n',0,NULL),(10,'2025-02-20 11:16:43','2025-02-25 15:07:01',3,'hfhygh',2,'紫菜汤',1,'测试','18812332121\r\n',0,NULL),(11,'2025-02-20 11:44:39','2025-02-25 15:07:01',3,'hfhygh',2,'紫菜汤',1,'测试','18812332121\r\n',0,NULL),(12,'2025-02-20 12:32:28','2025-02-25 15:07:01',3,'hfhygh',2,'紫菜汤',1,'测试','18812332121\r\n',0,NULL),(13,'2025-02-20 13:02:07','2025-02-25 15:07:01',3,'hfhygh',2,'紫菜汤',1,'测试','18812332121\r\n',0,NULL),(14,'2025-02-21 10:30:49','2025-02-25 15:07:01',3,'hfhygh',2,'紫菜汤',1,'测试','18812332121\r\n',0,NULL),(15,'2025-02-21 10:43:19','2025-02-25 15:07:02',3,'hfhygh',2,'紫菜汤',1,'测试','18812332121\r\n',0,NULL),(16,'2026-03-26 16:56:36','2026-03-26 16:56:36',1,'桂花鱼',4,'静音仓验光师（被控）',2,'静音仓','18111111111',0,'这是一份双眼近视合并散光的验光数据：左眼近视-2.25D（较右眼深0.25D），散光-0.25D，轴位58°（顺规散光，矫正难度低）；右眼近视-2.0D，散光-0.5D，轴位99°（同样顺规散光，散光度数更高）。\n\n整体为单纯近视散光，双眼散光轴位均在30°-130°顺规范围，矫正相对容易。左右眼近视度数差异小，散光度数右眼更高，可能影响视物清晰度（尤其看细节时）。建议优先选择足矫配镜，避免因散光欠矫导致视疲劳。日常需注意控制用眼时长，每30分钟远眺放松，定期复查（每半年至1年），青少年或度数增长快者需监测近视进展。若配镜后仍有视物模糊、重影或眼干等症状，需排查眼部健康（如是否合并弱视、干眼症等）。'),(17,'2026-03-27 10:44:51','2026-03-27 10:44:51',1,'桂花鱼',5,'静音仓店长（主控）',2,'静音仓','18111111111',0,'您的验光数据显示双眼均为275度近视（球镜-2.75D），合并25度近视散光（柱镜-0.25D），散光轴位分别为79°和85°（接近垂直方向）。  \n\n**分析要点**：  \n1. **近视度数**：双眼均为中度近视（275度），若裸眼视力不佳（如低于0.6），需及时矫正以避免视疲劳或度数进展。  \n2. **散光性质**：-0.25D为轻度近视散光，轴位79°、85°接近垂直方向（顺规散光），对视力影响较小，但双眼轴位相近，提示散光对称性较好。  \n3. **临床意义**：低度数散光（≤50度）通常对视力影响有限，若裸眼视力、双眼视功能正常且无疲劳症状，可暂不配镜；若存在视疲劳、阅读模糊或视力下降，建议矫正散光以稳定屈光状态。  \n\n**建议**：结合裸眼/矫正视力及日常用眼需求决定。若视力正常且无不适，可定期复查；若视力下降或伴随疲劳，需配镜矫正。'),(18,'2026-03-27 15:42:53','2026-03-27 15:42:53',13,'这个网速只能',5,'静音仓店长（主控）',2,'静音仓','18111111111',0,'这是一份验光数据，双眼均为近视，左眼度数更高且伴有散光。具体分析如下：\n\n1. **球镜度数**：左眼-9.00D（900度近视），右眼-8.00D（800度近视），属于高度近视，双眼度数差异100度，可能影响双眼视功能，需关注。\n\n2. **散光情况**：左眼-1.00D（近视散光100度），轴位3°（接近水平方向）；右眼-0.25D（近视散光25度），轴位61°。轴位3°可能为记录误差（通常轴位以10°为间隔），需复查确认；右眼25度散光轴位61°，属轻度散光，对视力影响较小。\n\n3. **配镜建议**：需根据试戴舒适度调整度数，优先选择双眼矫正平衡，避免单眼过矫。高度近视（尤其是左眼900度）易伴随视网膜病变风险，建议定期眼底检查，避免剧烈运动。\n\n4. **注意事项**：双眼度数差100度可能导致融像困难，若出现视疲劳、视物重影，需及时就医调整镜片。轴位3°若确认无误，需配镜时特殊标注，避免散光矫正偏差。\n\n建议佩戴合适度数的框架镜，或咨询医生评估是否适合角膜塑形镜/近视手术，定期复查视力及度数变化。'),(19,'2026-03-28 09:19:07','2026-03-28 09:19:07',1,'桂花鱼',5,'静音仓店长（主控）',2,'静音仓','18111111111',0,'这是一份双眼近视合并散光的验光数据：右眼近视625度（-6.25D）、近视散光50度（-0.5D），轴位67°；左眼近视550度（-5.5D）、近视散光100度（-1.0D），轴位125°。  \n\n**关键信息**：双眼均为规则近视散光，右眼近视度数更高（屈光参差约75度），左眼散光度数更高（100度）且轴位（125°）与右眼（67°）不同，属于不对称性散光。  \n\n**注意事项**：1. 屈光参差可能导致双眼成像大小差异，需佩戴准确度数及轴位的眼镜，初次适应可能需1-2周；2. 成人可耐受≤250度的屈光参差，儿童需警惕弱视风险，建议每3-6个月复查视力；3. 配镜时优先保证轴位精准（散光矫正关键），可考虑小瞳距适配镜片减少视觉干扰。  \n\n（248字）'),(20,'2026-03-28 09:35:41','2026-03-28 09:35:41',8,'用户_3709',5,'静音仓店长（主控）',2,'静音仓','18111111111',0,'该验光数据显示：双眼均为近视，右眼近视度数（-6.50D）略高于左眼（-6.25D）；右眼伴有75度近视散光（柱镜-0.75D），轴位65°；左眼无散光（柱镜0.00D）。\n\n散光轴位65°属于斜轴散光，配镜时需精确对准轴位以保证矫正效果。建议结合试戴体验，确认散光度数及轴位是否影响视力清晰度，若矫正后仍有视物模糊或视疲劳，需进一步检查调整。日常应注意用眼时长，避免近视度数加深。'),(21,'2026-03-28 09:46:18','2026-03-28 09:46:18',8,'用户_3709',5,'静音仓店长（主控）',2,'静音仓','18111111111',0,'**分析：**  \n双眼验光数据显示：  \n1. **近视度数**：左右眼均为-7.00D（700度近视），属于高度近视，需警惕视网膜病变风险。  \n2. **散光情况**：双眼均有-1.00D（100度）近视散光，散光度数较低但轴位有差异：左眼轴位2°，右眼轴位5°，均接近水平方向（0°）。  \n3. **临床意义**：双眼近视度数、散光度数对称，但轴位不同，提示对称型近视散光，配镜时需严格对准散光轴位，否则易导致视物变形、视疲劳。  \n\n**建议**：高度近视（700度）需重视散瞳验光准确性，轴位180°左右（垂直）或0°附近（水平）的散光，需确保配镜时轴位误差＜10°，优先选择试镜确认矫正效果，并定期复查眼底。'),(22,'2026-03-28 12:08:32','2026-03-28 12:08:32',14,'用户_0199',5,'静音仓店长（主控）',2,'静音仓','18111111111',0,'双眼均为325度近视（球镜-3.25D），左眼合并575度近视散光（柱镜-5.75D，轴位14°），右眼合并25度近视散光（柱镜-0.25D，轴位8°）。左眼散光度数显著高于右眼，轴位接近垂直方向（14°、8°均靠近90°垂直轴），可能提示左眼散光类型或成因特殊（如角膜散光），需警惕高度散光对视觉质量的影响（如视疲劳、视物变形）。建议结合角膜地形图等检查排除圆锥角膜风险，配镜时优先保证左眼散光矫正准确，避免视疲劳或弱视。'),(23,'2026-03-28 16:47:33','2026-03-28 16:47:33',11,'用户_6519',5,'静音仓店长（主控）',2,'静音仓','18111111111',0,'这组数据显示双眼均存在近视及近视散光（混合散光），属于双眼不对称散光情况。具体分析如下：  \n\n**左眼**：近视-4.75D（475度），近视散光-2.25D（225度），轴位1°（特殊轴位，需确认是否为10°或0°误差）。  \n**右眼**：近视-4.25D（425度），近视散光-2.75D（275度），轴位9°（接近90°，需核对是否为90°）。  \n\n**关键特点**：双眼近视度数差异较小（475度 vs 425度），但散光度数及轴位不对称（右眼散光更高、轴位特殊）。轴位1°和9°均为非典型值，可能存在检查误差（如书写时的小数点误标，或轴位10°/90°的近似记录），需进一步确认。  \n\n**配镜建议**：需优先核对轴位准确性，试戴时评估双眼平衡，避免因散光度数/轴位差异导致视疲劳或双眼视功能异常。日常注意用眼时长，定期复查视力变化。'),(24,'2026-03-30 09:32:26','2026-03-30 09:32:26',1,'桂花鱼',5,'静音仓店长（主控）',2,'静音仓','18111111111',0,'这组验光数据显示双眼均为低度近视，具体分析如下：\n\n**球镜度数**：双眼均为-2.25D（225度近视），属于轻度近视，可能导致远视力模糊，尤其看远处物体如黑板、路标时需眯眼。\n\n**散光情况**：左眼散光-0.50D（50度近视散光），轴位84°；右眼散光-0.25D（25度近视散光），轴位85°。散光度数左眼高于右眼，轴位接近（84° vs 85°），提示散光方向基本一致，可能影响双眼视平衡。\n\n**临床意义**：双眼近视度数相同，但左眼散光更明显，可能导致视物变形、重影或视疲劳，尤其在不加矫正散光时，容易因眯眼调节过度加重疲劳。若裸眼视力明显下降（如低于0.8），建议佩戴矫正眼镜；若日常无明显不适，可结合视功能检查（如裸眼/矫正视力、视疲劳症状）决定是否配镜。\n\n**注意事项**：定期复查视力，避免长时间近距离用眼，控制近视进展。配镜时需精确对应散光轴位（84°-85°），以保证矫正效果。'),(25,'2026-03-30 10:48:24','2026-03-30 10:48:24',1,'桂花鱼',5,'静音仓店长（主控）',2,'静音仓','18111111111',0,'这是一份双眼近视合并散光的验光数据：双眼球镜（近视度数）均为-6.75D（675度近视），散光度数均为-1.25D（125度近视散光），轴位左眼8°、右眼5°。  \n\n**关键分析**：  \n1. **度数特征**：双眼近视度数对称，散光度数、类型（近视散光）一致，但散光轴位不同（左眼8°、右眼5°），属于常见的双眼度数对称、散光轴位各异的情况。  \n2. **散光轴位**：散光轴位反映散光方向，8°和5°均在正常范围（0°-180°），轴位差异提示双眼散光方向略有不同，可能影响矫正时的视觉舒适度。  \n3. **潜在问题**：轴位偏差（5°-8°）虽不大，但仍需确认是否为检测误差；若轴位不准确，可能导致视物变形或疲劳。  \n\n**建议**：佩戴结合该度数和轴位的矫正镜，定期复查视力变化，注意散光轴位的长期稳定性，必要时结合角膜地形图排除圆锥角膜等病理因素。'),(26,'2026-03-30 11:38:06','2026-03-30 11:38:06',14,'用户_0199',5,'静音仓店长（主控）',2,'静音仓','18111111111',0,'左眼情况：球镜+4.25D（远视425度），柱镜-6.0D（近视散光600度），散光轴位13°（接近水平方向）；右眼：球镜-3.25D（近视325度），无散光。  \n\n需注意：左眼远视+高度近视散光的组合较特殊，可能存在数据合理性问题（通常高度散光更倾向与近视/远视同符号，如-4.25D球镜+ -6.0D柱镜更常见），建议复核验光数据。轴位13°属于低度数轴位，需结合试镜调整。右眼度数较低，无散光。  \n\n建议：凭此数据配镜前需试戴，重点关注左眼视力清晰度及舒适度，避免高度散光导致视疲劳或矫正不足。'),(27,'2026-03-30 12:58:51','2026-03-30 12:58:51',14,'用户_0199',5,'静音仓店长（主控）',2,'静音仓','18111111111',0,'这份验光数据显示双眼均存在近视散光，具体分析如下：  \n- **球镜度数（近视）**：左眼-3.75D（375度近视），右眼-3.25D（325度近视），双眼近视度数不等（左眼比右眼深50度），存在轻度屈光参差。  \n- **柱镜度数（散光）**：左眼-0.75D（75度近视散光），右眼-1.5D（150度近视散光），右眼散光度数明显高于左眼，散光类型为近视散光（柱镜与球镜均为负度数）。  \n- **轴位**：左眼散光轴位94°，右眼86°，双眼散光方向不同，需注意配镜时轴位准确性对矫正效果的影响。  \n\n**总结**：双眼均为“复合近视散光”（近视+近视散光），右眼散光度数更高，左眼近视度数更深，可能存在双眼视疲劳或融像困难风险（尤其屈光参差≥50度时）。建议结合裸眼/矫正视力、视功能检查及佩戴舒适度综合评估，必要时调整镜架参数或度数以优化视觉体验。'),(28,'2026-03-30 13:03:59','2026-03-30 13:03:59',14,'用户_0199',5,'静音仓店长（主控）',2,'静音仓','18111111111',0,'你的验光数据显示双眼均为近视并伴有散光（近视散光）：左眼球镜-3.75D（375度近视），散光-1.0D（100度近视散光），轴位99°；右眼球镜-3.5D（350度近视），散光-1.5D（150度近视散光），轴位85°。  \n\n双眼近视度数差异较小（25度），但散光度数右眼更高（150度），左眼轴位99°（接近垂直方向），右眼85°（接近水平方向），散光轴位存在差异。这种情况需注意：  \n1. **双眼矫正平衡**：散光度数及轴位不对称，配镜时可能需调整镜片度数平衡双眼视疲劳；  \n2. **试戴验证**：轴位差异可能影响矫正清晰度，建议试戴确认舒适度及视觉质量；  \n3. **日常用眼**：长期近距离用眼（如看手机、电脑）需注意眼肌调节，避免视疲劳，建议定期复查视力。  \n\n建议结合试戴效果最终确定配镜方案，确保矫正清晰且舒适。'),(29,'2026-03-30 13:15:32','2026-03-30 13:15:32',14,'用户_0199',5,'静音仓店长（主控）',2,'静音仓','18111111111',0,'该验光数据显示双眼存在近视合并散光：右眼近视-7.00D（700度），近视散光-0.25D（25度），轴位55°；左眼近视-7.50D（750度），近视散光-0.75D（75度），轴位11°。  \n\n双眼近视度数不等（左眼比右眼高50度），散光度数左眼更明显（75度）且轴位（11° vs 55°）差异较大。散光轴位反映角膜/晶状体散光方向，轴位差异提示双眼散光矫正需精准，否则可能影响视觉平衡。  \n\n建议结合裸眼/矫正视力、试戴舒适度及双眼视功能（如融合功能）综合评估，优先保证散光矫正准确，避免单眼疲劳。配镜时注意双眼平衡测试，必要时考虑角膜地形图排查散光成因（如是否角膜形态不对称），定期复查视力稳定性。'),(30,'2026-03-30 14:41:48','2026-03-30 14:41:48',11,'用户_6519',5,'静音仓店长（主控）',2,'静音仓','18111111111',0,'**分析如下**：  \n- **球镜度数**：左眼-6.00D（近视600度），右眼-5.00D（近视500度），双眼均为中度至高度近视，左眼近视度数更高。  \n- **柱镜度数**：左眼-3.50D，右眼-2.75D，均为近视散光，散光类型为**单纯近视散光**（球镜与柱镜均为负向，无远视成分）。  \n- **轴位**：左眼2°，右眼179°，均接近水平方向（轴位0°/180°为水平方向），提示散光轴位偏水平。右眼179°轴位接近180°，可能存在测量误差或实际散光轴位接近水平（散光度数较低时轴位易受干扰）。  \n\n**建议**：双眼高度近视合并散光，需及时佩戴矫正眼镜（框架镜或隐形眼镜），避免视疲劳及度数快速增长。轴位若存在误差（尤其右眼179°），建议复查确认准确性。日常需注意控制用眼时长，定期（每半年）验光复查。'),(31,'2026-03-30 14:46:13','2026-03-30 14:46:13',11,'用户_6519',5,'静音仓店长（主控）',2,'静音仓','18111111111',0,'该验光数据显示双眼均为近视，具体分析如下：\n\n**球镜（近视度数）**：双眼均为-4.00D（400度近视），度数相同，属于中度近视。\n\n**柱镜（散光度数）**：左眼有-2.50D（250度近视散光），右眼有-2.00D（200度近视散光），左眼散光度数更高。\n\n**轴位**：轴位数据（2.0/1.0）可能存在记录误差（常规轴位应为10°、20°等整数度数，以10°为间隔），建议核对原始验光单确认。轴位是散光矫正的关键参数，需准确记录以确保配镜效果。\n\n\n**建议**：若轴位为20°和10°（合理推测笔误），则左眼散光轴位20°、右眼10°，双眼近视度数相同，散光度数左眼更高。配镜时需结合轴位精准矫正，避免因轴位误差导致视物变形。建议以正规验光单为准，确认轴位准确性。'),(32,'2026-03-30 14:50:08','2026-03-30 14:50:08',11,'用户_6519',5,'静音仓店长（主控）',2,'静音仓','18111111111',0,'这组验光数据显示双眼均为混合散光（复合近视散光），具体分析如下：  \n\n**球镜度数**：左眼-4.00D（400度近视），右眼-4.25D（425度近视），右眼近视度数略高（球镜差0.25D），散光度数右眼-2.50D（250度），左眼-2.00D（200度），右眼散光度数更高。  \n\n**柱镜与轴位**：双眼柱镜均为负柱镜（近视散光），轴位左眼180°、右眼178°，均接近水平方向（0°为水平，180°为水平反向），散光方向几乎一致，轴位偏差极小（178°接近180°），可能对视觉清晰度影响较大。  \n\n**临床意义**：双眼中高度近视散光（散光≥200度），散光轴位接近水平方向，可能导致视物变形或清晰度不足，尤其右眼散光度数更高，视疲劳风险增加。建议优先选择与轴位匹配的镜片，试戴时重点关注轴位舒适度，定期复查视力及度数变化，避免长期用眼过度。'),(33,'2026-03-30 16:25:03','2026-03-30 16:25:03',14,'用户_0199',5,'静音仓店长（主控）',2,'静音仓','18111111111',0,'左眼球镜3.0D（若为-3.0D则为近视300度，若为+3.0D则为远视300度），柱镜-6.0D（高度近视散光），轴位12°；右眼球镜-3.25D（近视325度），柱镜0.0（无散光），轴位177°。  \n\n分析：右眼为中度近视（-3.25D），无散光，矫正后视力较易清晰。左眼柱镜-6.0D为高度散光（若球镜为-3.0D则为近视300度合并高度近视散光；若球镜为+3.0D则为远视300度合并高度近视散光），轴位12°（接近垂直方向）。高度散光易导致视物模糊、重影、视疲劳，需警惕角膜形态异常（如圆锥角膜），建议进一步检查角膜地形图。轴位12°需精准矫正，否则影响视力恢复。建议佩戴合适矫正镜，定期复查视力及散光变化。'),(34,'2026-03-30 16:39:06','2026-03-30 16:39:06',14,'用户_0199',5,'静音仓店长（主控）',2,'静音仓','18111111111',0,'您的验光数据显示双眼均为近视合并散光，具体分析如下：\n\n**球镜（近视度数）**：左眼-4.25D（425度），右眼-3.25D（325度），左眼近视度数高于右眼，存在**轻度屈光参差**（双眼度数差100度）。\n\n**柱镜（散光度数）**：双眼均为-1.0D（100度近视散光），散光度数相同。\n\n**轴位**：双眼轴位均为86度，属于**顺规散光**（轴位在30°-130°之间），且双眼轴位一致，提示散光方向对称。\n\n\n**注意事项**：\n1. **屈光参差**：左眼度数更高，可能导致双眼融像困难，尤其长时间用眼易出现视疲劳、视物模糊。\n2. **散光一致性**：双眼轴位相同，散光类型相似，配镜时可优先考虑常规矫正方案，但需注意镜片光学中心对齐。\n3. **建议**：结合临床症状（如眼干、视物重影），优先选择框架眼镜矫正，避免因屈光参差导致单眼抑制；若用眼需求高（如驾驶、运动），可考虑角膜接触镜改善融像效果。定期复查（每半年至1年），监测度数变化，尤其左眼近视进展较快时需加强用眼防护。'),(35,'2026-04-11 11:44:42','2026-04-11 11:44:42',13,'这个网速只能',5,'静音仓店长（主控）',2,'静音仓','18111111111',0,'您的验光数据显示：双眼均为-2.00D（200度）近视，-0.50D（50度）近视散光，左眼轴位90°，右眼87°。分析如下：  \n\n1. **近视与散光性质**：球镜-2.00D明确为200度近视；柱镜-0.50D为50度近视散光，轴位90°（左眼）和87°（右眼），属于规则散光（轴位接近，无明显交叉散光）。  \n\n2. **双眼对称性**：双眼近视度数、散光度数及散光轴位（相差3°，在±5°正常误差范围内）均高度对称，属于轻度不对称散光，对双眼视功能影响较小。  \n\n3. **矫正与适配**：规则散光（轴位稳定）可通过框架眼镜或隐形眼镜矫正，试镜时轴位一致性良好，通常矫正效果稳定。若配镜后无头晕、视物变形，可优先选择框架镜；若对清晰度要求高或运动场景佩戴，隐形眼镜可能更优。  \n\n4. **注意事项**：建议定期复查视力（每半年至1年），监测度数变化；若试镜时出现眼胀、重影，需调整散光度数或轴位精度。  \n\n整体而言，度数较低且散光规则对称，矫正难度小，适配性较好。'),(36,'2026-04-13 09:53:35','2026-04-13 09:53:35',1,'桂花鱼',5,'静音仓店长（主控）',2,'静音仓','18111111111',0,'您的验光数据显示双眼均存在近视及散光，具体分析如下：\n\n**球镜度数**：右眼-6.25D（625度近视），左眼-5.25D（525度近视），右眼近视度数较左眼深100度，双眼近视差异需关注，配镜时可能需平衡双眼清晰度。\n\n**柱镜度数**：左眼-1.00D（100度近视散光），右眼-0.75D（75度近视散光），左眼散光度数高于右眼，散光类型均为近视散光。\n\n**轴位**：左眼散光轴位143°（接近垂直方向，属于逆规散光），右眼轴位65°（接近水平方向，属于顺规散光），轴位差异较大，配镜时需重点匹配散光方向以保证矫正效果。\n\n**建议**：配镜需综合考虑矫正视力、双眼平衡及舒适度，因双眼近视、散光度数及轴位存在差异，可能需试戴调整。日常注意用眼习惯，避免视疲劳，定期复查视力。'),(37,'2026-04-13 10:16:31','2026-04-13 10:16:31',21,'用户_8118',5,'静音仓店长（主控）',2,'静音仓','18111111111',0,'**分析：**  \n左眼：球镜+4.25D（425度远视），柱镜-6.00D（600度近视散光），轴位14°；  \n右眼：球镜-0.75D（75度近视），柱镜-0.25D（25度近视散光），轴位2°。  \n\n**关键信息：**  \n1. **散光度数差异大**：左眼散光600度（高度散光），右眼仅25度（轻度散光），双眼散光矫正需求差异显著。  \n2. **轴位独立**：左眼散光轴位14°，右眼2°，双眼散光方向不同，配镜时需分别处理。  \n3. **左眼性质特殊**：球镜为远视（+），但合并高度近视散光（-6.00D），需警惕是否存在角膜形态异常（如圆锥角膜）或散光叠加误差（如数据录入失误需复核）。  \n\n**建议：** 尽快进行散瞳验光确认度数，试戴镜评估舒适度，排除圆锥角膜等病变，高度散光需优先保证矫正清晰度与双眼协调。'),(38,'2026-04-13 10:20:37','2026-04-13 10:20:37',21,'用户_8118',5,'静音仓店长（主控）',2,'静音仓','18111111111',0,'您提供的验光数据显示：左眼球镜+2.25D（远视225度），柱镜-6.75D（近视散光675度），轴位15°；右眼球镜-2.0D（近视200度），柱镜-0.25D（近视散光25度），轴位9°。  \n\n**关键分析：**  \n1. **散光特征**：双眼散光轴位（9°、15°）均接近水平方向（逆规散光常见轴位范围0°-30°），左眼散光度数极高（-6.75D），属于高度散光，需警惕角膜形态异常（如圆锥角膜）或晶状体异常；右眼散光度数低（-0.25D），轴位接近水平。  \n2. **屈光参差**：双眼球镜度数差异大（左眼远视225度，右眼近视200度），度数差超400度，属于高度屈光参差，可能导致双眼视功能异常（如融像困难、视疲劳），需优先矫正。  \n3. **配镜建议**：高度散光需结合角膜地形图排除圆锥角膜，低度数散光可适当低矫。因左眼远视+高度散光，右眼近视+低度散光，建议选择特殊散光镜片（如环曲面镜片），并定期复查视功能，避免弱视或斜视风险（尤其儿童）。  \n\n**提示**：此数据仅为验光结果，具体配镜方案需结合试戴舒适度及双眼视功能评估。'),(39,'2026-04-13 11:09:01','2026-04-13 11:09:01',2,'紫菜汤',5,'静音仓店长（主控）',2,'静音仓','18111111111',0,NULL),(40,'2026-04-13 11:17:31','2026-04-13 11:17:31',2,'紫菜汤',5,'静音仓店长（主控）',2,'静音仓','18111111111',0,'左眼：球镜-4.75D（475度近视），柱镜-0.5D（50度散光，轴位20°）；右眼：球镜-4.25D（425度近视），柱镜0.0（无散光）。双眼均为近视，左眼度数高于右眼50度，存在屈光参差（双眼度数差50度，属于轻度参差）。左眼合并轻度散光（轴位20°），散光度数较低，轴位接近水平方向。  \n\n右眼为单纯近视，左眼为近视合并散光。屈光参差可能导致双眼视功能差异，需注意配镜后是否有视疲劳或双眼平衡问题。建议试戴评估舒适度，配镜时优先保证最佳矫正视力，散光轴位需精准校准（20°接近水平，配镜时需准确对准轴位）。若日常有视疲劳，可考虑渐进镜或隐形眼镜平衡双眼调节。'),(41,'2026-04-13 14:59:35','2026-04-13 14:59:35',8,'用户_3709',4,'静音仓验光师（被控）',2,'静音仓','18111111111',0,'这组验光数据显示双眼均为近视，存在屈光参差，右眼有轻度近视散光：  \n- **左眼**：球镜（近视）-4.75D（475度近视），柱镜0.0（无散光），轴位119°（因无散光，轴位无实际意义）。  \n- **右眼**：球镜-6.25D（625度近视），柱镜-0.5D（50度近视散光），轴位78°（散光方向）。  \n\n**关键信息**：双眼近视度数不等（右眼比左眼高150度），属屈光参差。右眼散光度数较低（50度），轴位78°（正常散光轴位范围），对视力影响较轻。  \n\n**建议**：佩戴全矫眼镜以平衡双眼视差，减少视疲劳；若用眼需求大或度数变化快，需定期复查。长期屈光参差可能影响立体视，成年人若出现视疲劳或视物模糊，应优先矫正散光轴位准确性。'),(42,'2026-04-13 15:54:13','2026-04-13 15:54:13',8,'用户_3709',4,'静音仓验光师（被控）',2,'静音仓','18111111111',0,'您的验光数据显示双眼均为近视伴散光，具体分析如下：  \n**左眼**：近视-7.00D（700度），散光-1.00D（100度近视散光），轴位1.0°（注：轴位1°可能性低，推测为书写误差，应为10°或相近整数，若为10°则散光方向接近水平）。  \n**右眼**：近视-6.75D（675度），散光-1.50D（150度近视散光），轴位1.0°（同理，可能为10°）。  \n\n**特点**：双眼近视度数差异小（25度），散光度数左眼轻（100度）、右眼重（150度），轴位若均为10°，属散光方向一致（顺规散光可能性）。  \n**建议**：轴位需以验光单为准（10°更合理），配镜时优先选择双眼平衡方案，定期复查防止度数进展，高度近视（-7.00D）需注意用眼习惯，避免视疲劳或度数加深。'),(43,'2026-04-13 15:58:13','2026-04-13 15:58:13',8,'用户_3709',4,'静音仓验光师（被控）',2,'静音仓','18111111111',0,'您的验光数据显示双眼均为高度近视（球镜-6.75D），右眼伴150度近视散光（柱镜-1.5D，轴位20°），左眼伴125度近视散光（柱镜-1.25D，轴位10°）。注意：轴位“1.0”“2.0”可能为记录误差（应为10°/20°），需确认是否为10°、20°（散光轴位单位为度，范围0-180°，非小数）。\n\n高度近视（≥600度）易引发视网膜病变，建议定期查眼底；散光轴位10°/20°属低位轴位，若矫正时轴位偏差，可能导致视物模糊或视疲劳。配镜时需确保散光轴位准确，日常避免剧烈运动，控制用眼时长，每半年复查视力及眼底。'),(44,'2026-04-13 16:45:11','2026-04-13 16:45:11',14,'用户_0199',4,'静音仓验光师（被控）',2,'静音仓','18111111111',0,'该验光数据显示双眼存在屈光不正，具体分析如下：  \n\n**右眼**：球镜-3.25D（近视325度），柱镜-0.25D（25度近视散光），轴位3°（接近水平方向）。散光度数低，对视力影响较小，可能为生理性散光或轻度角膜不规则。  \n\n**左眼**：球镜2.5D（需确认符号，若无负号可能为远视250度或近视250度），柱镜-6.25D（高度近视散光625度），轴位13°（接近垂直方向）。高度散光（-6.25D）轴位特殊（13°），需警惕散光轴位准确性，建议复查排除测量误差或圆锥角膜等病变。  \n\n**综合**：左眼散光度数高（625度），需优先排查病因（如角膜形态异常）；右眼散光度数低，对视力影响有限。建议结合试镜结果及角膜地形图等检查，确定矫正方案，必要时高度散光需特殊镜片设计（如环曲面镜片）。'),(45,'2026-04-14 15:32:33','2026-04-14 15:32:33',1,'桂花鱼',23,'18355555555',4,'18344444444','18344444444',0,'您的验光数据显示双眼均为近视合并近视散光，具体分析如下：\n\n**双眼基本情况**：  \n- **右眼（OD）**：球镜-4.25D（425度近视），柱镜-2.75D（275度近视散光），轴位7°；  \n- **左眼（OS）**：球镜-4.00D（400度近视），柱镜-2.25D（225度近视散光），轴位6°。  \n\n\n**关键参数解读**：  \n1. **近视度数**：右眼（-4.25D）＞左眼（-4.00D），存在轻度屈光参差（双眼度数差50度），长期不矫正可能影响双眼融像，尤其近距离用眼易疲劳。  \n2. **散光度数**：右眼（-2.75D）＞左眼（-2.25D），且轴位均为6°-7°（接近水平方向），属于**顺规散光**（轴位15°-179°为顺规，矫正效果通常较好）。  \n3. **轴位准确性**：散光轴位需精准（±5°内），偏差可能导致视物变形、头晕。建议配镜时选择轴位准确的镜片，尤其度数较高时。  \n\n\n**建议**：配镜时优先确保轴位准确，散光度数较高者可能需适应期。若长期佩戴后仍有不适，需复查轴位及度数稳定性。'),(46,'2026-04-14 17:27:41','2026-04-14 17:27:41',8,'用户_3709',5,'静音仓店长（主控）',2,'静音仓','18111111111',0,'根据验光数据分析：左眼为+2.75D（275度远视）合并-6.25D（625度近视散光），轴位12°；右眼为-3.25D（325度近视）合并-0.5D（50度近视散光），轴位8°。  \n\n**关键信息**：  \n1. **左眼散光度数高达625度**，属于高度散光，轴位12°（接近水平方向），可能影响视物清晰度，尤其高度散光易导致视疲劳、代偿头位等问题。  \n2. **双眼屈光参差明显**：右眼近视325度，左眼远视275度，度数差异较大，需注意佩戴眼镜时的适配性，避免因双眼调节差异引发不适。  \n3. **散光类型**：双眼散光轴位（8°、12°）均接近水平方向，属于顺规散光（轴位10°-170°为顺规），矫正时需重点关注散光轴位准确性。  \n\n**建议**：高度散光需优先保证矫正轴位准确，高度数散光可能需特殊镜片设计（如环曲面镜片）；屈光参差者建议佩戴专业定制镜片，定期复查视功能，避免视疲劳加重。具体矫正方案请以验光师试戴反馈为准。');
/*!40000 ALTER TABLE `optometry_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_info`
--

DROP TABLE IF EXISTS `order_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_info` (
  `id` varchar(32) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'PK',
  `del_flag` char(2) COLLATE utf8mb4_croatian_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `user_id` varchar(32) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '用户id',
  `order_no` varchar(50) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '订单单号',
  `payment_way` char(2) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '支付方式1、货到付款；2、在线支付',
  `is_pay` char(2) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '是否支付0、未支付 1、已支付',
  `name` varchar(255) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '订单名',
  `status` char(2) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '订单状态1、待发货 2、待收货 3、确认收货/已完成 5、已关闭',
  `freight_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '运费金额',
  `sales_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '销售金额',
  `payment_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '支付金额（销售金额+运费金额）',
  `payment_time` datetime DEFAULT NULL COMMENT '付款时间',
  `delivery_time` datetime DEFAULT NULL COMMENT '发货时间',
  `receiver_time` datetime DEFAULT NULL COMMENT '收货时间',
  `closing_time` datetime DEFAULT NULL COMMENT '成交时间',
  `user_message` varchar(100) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '买家留言',
  `transaction_id` varchar(32) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '支付交易ID',
  `logistics_id` varchar(32) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '物流id',
  `remark` varchar(255) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_order_no` (`order_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='订单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_info`
--

LOCK TABLES `order_info` WRITE;
/*!40000 ALTER TABLE `order_info` DISABLE KEYS */;
INSERT INTO `order_info` VALUES ('1354094503631306753','0','2021-01-26 23:51:02','2021-01-26 15:51:02','1352572935968165889','1354094503576731648','2','0',NULL,'5',0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('1354469715404148737','0','2021-01-28 00:41:59','2021-01-27 16:41:59','1352168072700571649','1354469713115086848','2','0','iPhone12白色','5',0.00,4999.00,4999.00,NULL,NULL,NULL,NULL,NULL,NULL,'1354469714800168962',NULL),('1354474070446510081','0','2021-01-28 00:59:17','2021-01-27 16:59:17','1354473059078176770','1354474068199342080','2','0','iPhone12白色','5',0.00,4999.00,4999.00,NULL,NULL,NULL,NULL,NULL,NULL,'1354474069813170178',NULL),('1354620399822884865','0','2021-01-28 10:40:45','2021-01-28 02:40:45','1354473059078176770','1354620397982580736','2','0','iPhone12白色','5',0.00,4999.00,4999.00,NULL,NULL,NULL,NULL,NULL,NULL,'1354620399231488001',NULL),('1354795347837304834','0','2021-01-28 22:15:56','2021-01-28 14:15:55','1354473059078176770','1354795346135351296','2','0','iPhone12白色','5',0.00,4999.00,4999.00,NULL,NULL,NULL,NULL,NULL,NULL,'1354795347308822530',NULL),('1354797185856794625','0','2021-01-28 22:23:14','2021-01-28 14:23:13','1354473059078176770','1354797183827705856','2','0','iPhone12白色','5',0.00,4999.00,4999.00,NULL,NULL,NULL,NULL,NULL,NULL,'1354797185185705985',NULL),('1354797794534137858','0','2021-01-28 22:25:39','2021-01-28 14:25:39','1354473059078176770','1354797792530268160','2','0','iPhone12白色','5',0.00,4999.00,4999.00,NULL,NULL,NULL,NULL,NULL,NULL,'1354797793913380865',NULL),('1354798824059609090','0','2021-01-28 22:29:45','2021-01-28 14:29:44','1354473059078176770','1354798822391283712','2','1','iPhone12白色','3',0.00,0.01,0.01,'2021-01-28 22:30:01','2021-01-28 23:16:51','2021-01-28 23:17:41',NULL,NULL,'4200000797202101287152815447','1354798823514349569',NULL),('1354798971141267457','0','2021-01-28 22:30:20','2021-01-28 14:30:19','1354473059078176770','1354798969477136384','2','1','iPhone12白色','3',0.00,0.01,0.01,'2021-01-28 22:32:33','2021-01-28 23:10:49','2021-01-28 23:16:19',NULL,NULL,'4200000808202101285235202004','1354798970596007937',NULL),('1355417350676951041','0','2021-01-30 15:27:33','2021-01-30 07:27:33','1355406809988345857','1355417348219076608','2','0','【时尚博主推荐】Daphne/达芙妮2020春季新款闪耀水晶扣时装鞋淑雅女单鞋 粉红112 38',NULL,0.00,0.20,0.20,NULL,NULL,NULL,NULL,NULL,NULL,'1355417349930364930',NULL),('1355418768053907457','0','2021-01-30 15:33:11','2021-01-30 07:33:11','1355406809988345857','1355418765948354560','2','0','Apple iPhone',NULL,0.00,6000.00,6000.00,NULL,NULL,NULL,NULL,NULL,NULL,'1355418767420567554',NULL),('1355426472587714562','0','2021-01-30 16:03:48','2021-01-30 08:03:48','1355406809988345857','1355426470679281664','2','1','【时尚博主推荐】Daphne/达芙妮2020春季新款闪耀水晶扣时装鞋淑雅女单鞋 粉红112 38','1',0.00,0.10,0.10,'2021-01-30 16:04:20',NULL,NULL,NULL,NULL,'4200000801202101302811163830','1355426471975346177',NULL),('1357673549756682241','0','2021-02-05 20:52:53','2021-02-05 12:52:52','1354473059078176770','1357673547845074944','2','0','iPhone 12 Pro','5',0.00,8499.00,8499.00,NULL,NULL,NULL,NULL,NULL,NULL,'1357673549135925250',NULL),('1632993114357575681','0','2023-03-07 14:34:33','2023-03-07 06:34:32','1354473059078176770','1632993114207551488','2','0','HUAWEI P40 Pro+','5',0.00,0.98,0.98,NULL,NULL,NULL,NULL,NULL,NULL,'1632993114324021250',NULL),('1632994752065449985','0','2023-03-07 14:41:03','2023-03-07 06:41:03','1354473059078176770','1632994751923879936','2','0','HUAWEI P40 Pro+','5',0.00,0.10,0.10,NULL,NULL,NULL,NULL,NULL,NULL,'1632994752031895553',NULL),('1632995133256437763','0','2023-03-07 14:42:34','2023-03-07 06:42:34','1354473059078176770','1632995133102227456','2','1','HUAWEI P40 Pro+','5',0.00,0.10,0.10,'2023-03-07 14:42:56','2023-03-07 14:59:46',NULL,NULL,NULL,'4200001772202303073968832224','1632995133256437762',NULL),('1645623820711706626','0','2023-04-11 11:04:28','2023-04-11 03:04:27','1354473059078176770','1645623820574261248','2','0','Apple iPhone 13 Pro','5',0.00,8999.00,8999.00,NULL,NULL,NULL,NULL,NULL,NULL,'1645623820711706625',NULL),('1645635415705706497','0','2023-04-11 11:50:32','2023-04-11 03:50:32','1354473059078176770','1645635415513759744','2','1','HUAWEI P40 Pro+','5',0.00,0.10,0.10,'2023-04-11 11:50:49',NULL,NULL,NULL,NULL,'4200001784202304119379049641','1645635415605043201',NULL),('1901559589749952513','0','2025-03-17 17:01:50','2025-03-17 09:01:50','1900425114278260738','1901559589581619200','2','0','优雅精致纯钛架',NULL,0.00,25.00,25.00,NULL,NULL,NULL,NULL,NULL,NULL,'1901559589724786690',NULL),('1909241965190647810','0','2025-04-07 21:48:51','2025-04-07 13:48:51','1907278202958839809','1909241965120061440','2','0','军达-冰蓝色镜框',NULL,20.00,10.00,30.00,NULL,NULL,NULL,NULL,'',NULL,'1909241965169676289',NULL),('1909246795489546241','0','2025-04-07 22:08:03','2025-04-07 14:08:02','1907278202958839809','1909246795452514304','2','0','军达-冰蓝色镜框',NULL,0.00,10.00,10.00,NULL,NULL,NULL,NULL,'',NULL,'1909246795485351937',NULL),('1909248649824899074','0','2025-04-07 22:15:25','2025-04-07 14:15:24','1907278202958839809','1909248649792061440','2','0','军达-冰蓝色镜框',NULL,0.00,10.00,10.00,NULL,NULL,NULL,NULL,'',NULL,'1909248649824899073',NULL),('1909403939903967234','0','2025-04-08 08:32:29','2025-04-08 00:32:28','1907278202958839809','1909403939862740992','2','0','军达-冰蓝色镜框',NULL,0.00,10.00,10.00,NULL,NULL,NULL,NULL,'',NULL,'1909403939895578626',NULL),('1909407615208984578','0','2025-04-08 08:47:05','2025-04-08 00:47:05','1907278202958839809','1909407615176146944','2','0','军达-冰蓝色镜框',NULL,0.00,10.00,10.00,NULL,NULL,NULL,NULL,'',NULL,'1909407615204790273',NULL),('1909412235268395010','0','2025-04-08 09:05:27','2025-04-08 01:05:26','1907278202958839809','1909412235231363072','2','0','军达-冰蓝色镜框',NULL,0.00,10.00,10.00,NULL,NULL,NULL,NULL,'',NULL,'1909412235260006402',NULL),('1909412914326212610','0','2025-04-08 09:08:09','2025-04-08 01:08:08','1907278202958839809','1909412914284986368','2','0','军达-冰蓝色镜框',NULL,0.00,10.00,10.00,NULL,NULL,NULL,NULL,'',NULL,'1909412914313629697',NULL),('1909415386277023745','0','2025-04-08 09:17:58','2025-04-08 01:17:57','1907278202958839809','1909415386231603200','2','0','军达-冰蓝色镜框',NULL,0.00,10.00,10.00,NULL,NULL,NULL,NULL,'',NULL,'1909415386264440833',NULL),('1909415645183021058','0','2025-04-08 09:19:00','2025-04-08 01:18:59','1907278202958839809','1909415645133406208','2','0','军达-冰蓝色镜框',NULL,0.00,10.00,10.00,NULL,NULL,NULL,NULL,'',NULL,'1909415645174632449',NULL),('1909416095475109889','0','2025-04-08 09:20:47','2025-04-08 01:20:47','1907278202958839809','1909416095438077952','2','0','金色',NULL,0.00,11.00,11.00,NULL,NULL,NULL,NULL,'',NULL,'1909416095470915585',NULL),('1909416766563749890','0','2025-04-08 09:23:27','2025-04-08 01:23:27','1907278202958839809','1909416766526717952','2','0','金色',NULL,0.00,11.00,11.00,NULL,NULL,NULL,NULL,'',NULL,'1909416766555361282',NULL),('1909416858419007490','0','2025-04-08 09:23:49','2025-04-08 01:23:48','1907278202958839809','1909416858377781248','2','0','优雅精致纯钛架',NULL,0.00,15.00,15.00,NULL,NULL,NULL,NULL,'',NULL,'1909416858410618881',NULL),('1909417103785791490','0','2025-04-08 09:24:47','2025-04-08 01:24:47','1907278202958839809','1909417103748759552','2','0','金色',NULL,0.00,11.00,11.00,NULL,NULL,NULL,NULL,'',NULL,'1909417103777402882',NULL),('1909417386402189313','0','2025-04-08 09:25:55','2025-04-08 01:25:54','1907278202958839809','1909417386365157376','2','0','金色',NULL,0.00,11.00,11.00,NULL,NULL,NULL,NULL,'',NULL,'1909417386397995010',NULL),('1909420850138124289','0','2025-04-08 09:39:41','2025-04-08 01:39:40','1907278202958839809','1909420850105286656','2','0','简约椭圆',NULL,0.00,11.00,11.00,NULL,NULL,NULL,NULL,'',NULL,'1909420850133929986',NULL),('1909421506592837633','0','2025-04-08 09:42:17','2025-04-08 01:42:17','1907278202958839809','1909421506555805696','2','0','简约椭圆',NULL,0.00,11.00,11.00,NULL,NULL,NULL,NULL,'',NULL,'1909421506588643330',NULL),('1909422767266402306','0','2025-04-08 09:47:18','2025-04-08 01:47:17','1907278202958839809','1909422767233564672','2','0','简约椭圆',NULL,0.00,11.00,11.00,NULL,NULL,NULL,NULL,'',NULL,'1909422767262208002',NULL),('1909422804138528770','0','2025-04-08 09:47:27','2025-04-08 01:47:26','1907278202958839809','1909422804097302528','2','0','优雅精致纯钛架',NULL,0.00,15.00,15.00,NULL,NULL,NULL,NULL,'',NULL,'1909422804100780034',NULL),('1909422943930486785','0','2025-04-08 09:48:00','2025-04-08 01:47:59','1907278202958839809','1909422943893454848','2','0','巴黎灰岛',NULL,0.00,13.00,13.00,NULL,NULL,NULL,NULL,'',NULL,'1909422943926292481',NULL),('1909423759051526146','0','2025-04-08 09:51:14','2025-04-08 01:51:14','1907278202958839809','1909423759014494208','2','0','星耀黑银',NULL,0.00,13.00,13.00,NULL,NULL,NULL,NULL,'',NULL,'1909423759043137537',NULL),('1909424048865349633','0','2025-04-08 09:52:23','2025-04-08 01:52:23','1907278202958839809','1909424048828317696','2','0','巴黎灰岛',NULL,0.00,13.00,13.00,NULL,NULL,NULL,NULL,'',NULL,'1909424048861155330',NULL),('1909427697490386945','0','2025-04-08 10:06:53','2025-04-08 02:06:53','1907278202958839809','1909427696736141312','2','0','优雅精致纯钛架',NULL,0.00,15.00,15.00,NULL,NULL,NULL,NULL,'',NULL,'1909427696873824257',NULL),('1909428445636780034','0','2025-04-08 10:09:52','2025-04-08 02:09:51','1907278202958839809','1909428445578788864','2','0','优雅精致纯钛架',NULL,0.00,15.00,15.00,NULL,NULL,NULL,NULL,'',NULL,'1909428445624197122',NULL),('1909430786809192449','0','2025-04-08 10:19:10','2025-04-08 02:19:09','1907278202958839809','1909430786705063936','2','0','优雅精致纯钛架',NULL,0.00,15.00,15.00,NULL,NULL,NULL,NULL,'',NULL,'1909430786779832322',NULL),('1909433413735284738','0','2025-04-08 10:29:36','2025-04-08 02:29:36','1907278202958839809','1909433412876238848','2','0','星耀黑银',NULL,0.00,13.00,13.00,NULL,NULL,NULL,NULL,'',NULL,'1909433413085167618',NULL),('1909435201062510593','0','2025-04-08 10:36:42','2025-04-08 02:36:42','1907278202958839809','1909435200211779584','2','0','巴黎灰岛',NULL,0.00,13.00,13.00,NULL,NULL,NULL,NULL,'',NULL,'1909435200454336514',NULL),('1909450699514912771','0','2025-04-08 11:38:17','2025-04-08 03:38:17','1907278202958839809','1909450699503042560','2','0','金色',NULL,0.00,11.00,11.00,NULL,NULL,NULL,NULL,'',NULL,'1909450699514912770',NULL),('1909474273558581251','0','2025-04-08 13:11:58','2025-04-08 05:11:57','1907278202958839809','1909474273555120128','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909474273558581250',NULL),('1909475366304763905','0','2025-04-08 13:16:18','2025-04-08 05:16:18','1907278202958839809','1909475365487640576','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909475365642063873',NULL),('1909486529088376834','0','2025-04-08 14:00:40','2025-04-08 06:00:39','1907278202958839809','1909486528946503680','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909486529054822402',NULL),('1909489014892994561','0','2025-04-08 14:10:32','2025-04-08 06:10:32','1907278202958839809','1909489014038069248','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909489014234488833',NULL),('1909494718420819970','0','2025-04-08 14:33:12','2025-04-08 06:33:12','1907278202958839809','1909494718350229504','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909494718404042753',NULL),('1909496224767287297','0','2025-04-08 14:39:11','2025-04-08 06:39:11','1907278202958839809','1909496223887261696','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909496224092004353',NULL),('1909496404400939010','0','2025-04-08 14:39:54','2025-04-08 06:39:54','1907278202958839809','1909496404334608384','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909496404379967489',NULL),('1909497426477326338','0','2025-04-08 14:43:58','2025-04-08 06:43:57','1907278202958839809','1909497426461327360','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909497426477326337',NULL),('1909498542254465026','0','2025-04-08 14:48:24','2025-04-08 06:48:23','1907278202958839809','1909498542200717312','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909498542241882113',NULL),('1909498944274309122','0','2025-04-08 14:50:00','2025-04-08 06:49:59','1907278202958839809','1909498944191201280','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909498944274309121',NULL),('1909499415986786306','0','2025-04-08 14:51:52','2025-04-08 06:51:52','1907278202958839809','1909499415010213888','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909499415227617281',NULL),('1909499520152326146','0','2025-04-08 14:52:17','2025-04-08 06:52:17','1907278202958839809','1909499520085917696','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909499520135548929',NULL),('1909499813401284610','0','2025-04-08 14:53:27','2025-04-08 06:53:26','1907278202958839809','1909499813326487552','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909499813392896002',NULL),('1909500103953305602','0','2025-04-08 14:54:36','2025-04-08 06:54:36','1907278202958839809','1909500103878508544','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909500103936528385',NULL),('1909500164317728770','0','2025-04-08 14:54:51','2025-04-08 06:54:50','1907278202958839809','1909500164259708928','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909500164305145858',NULL),('1909500257099927555','0','2025-04-08 14:55:13','2025-04-08 06:55:12','1907278202958839809','1909500257046102016','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909500257099927554',NULL),('1909500297096810498','0','2025-04-08 14:55:22','2025-04-08 06:55:22','1907278202958839809','1909500297034596352','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909500297084227585',NULL),('1909500317724397571','0','2025-04-08 14:55:27','2025-04-08 06:55:27','1907278202958839809','1909500317729292288','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909500317724397570',NULL),('1909504734561390594','0','2025-04-08 15:13:00','2025-04-08 07:13:00','1907278202958839809','1909504734499176448','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909504734536224769',NULL),('1909513503307542530','0','2025-04-08 15:47:51','2025-04-08 07:47:50','1907278202958839809','1909513502523916288','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909513502690979842',NULL),('1909514804070236161','0','2025-04-08 15:53:01','2025-04-08 07:53:01','1907278202958839809','1909514803227918336','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909514803415924737',NULL),('1909519340210044929','0','2025-04-08 16:11:02','2025-04-08 08:11:02','1907278202958839809','1909519339397054464','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909519339568316417',NULL),('1909520686996852738','0','2025-04-08 16:16:23','2025-04-08 08:16:23','1907278202958839809','1909520686154514432','2','0','军达-冰蓝色镜框','5',0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909520686392872961',NULL),('1909525358532894721','0','2025-04-08 16:34:57','2025-04-08 08:34:57','1907278202958839809','1909525357266993152','2','1','金色','3',0.00,0.01,0.01,'2025-04-08 16:35:06','2025-04-08 16:49:32','2025-04-09 13:40:07',NULL,'','4200002712202504081271157962','1909525357522067457',NULL),('1909529369805856769','0','2025-04-08 16:50:54','2025-04-08 08:50:53','1907278202958839809','1909529369743720448','2','1','全框','1',0.00,0.01,0.01,'2025-04-08 16:51:03',NULL,NULL,NULL,'','4200002674202504081387000100','1909529369793273857',NULL),('1909537018857480193','0','2025-04-08 17:21:17','2025-04-08 09:21:17','1907278202958839809','1909537017880903680','2','0','军达-冰蓝色镜框',NULL,0.00,0.06,0.06,NULL,NULL,NULL,NULL,'',NULL,'1909537018232528897',NULL),('1909537232091701250','0','2025-04-08 17:22:08','2025-04-08 09:22:08','1907278202958839809','1909537232000122880','2','1','军达-冰蓝色镜框','1',0.00,0.02,0.02,'2025-04-08 17:22:20',NULL,NULL,NULL,'','4200002674202504089165881729','1909537232079118338',NULL),('1909539063148666881','0','2025-04-08 17:29:25','2025-04-08 09:29:24','1907278202958839809','1909539063090642944','2','1','军达-冰蓝色镜框','2',0.00,0.01,0.01,'2025-04-08 17:29:49','2025-04-10 11:35:23',NULL,NULL,'','4200002692202504086168330809','1909539063131889666',NULL),('1909540322941427713','0','2025-04-08 17:34:25','2025-04-08 09:34:25','1907278202958839809','1909540322904375296','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909540322933039105',NULL),('1909540512003874818','0','2025-04-08 17:35:10','2025-04-08 09:35:10','1907278202958839809','1909540511966822400','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909540511999680513',NULL),('1909540681504088065','0','2025-04-08 17:35:51','2025-04-08 09:35:50','1907278202958839809','1909540681458647040','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909540681491505154',NULL),('1909779974680043523','0','2025-04-09 09:26:43','2025-04-09 01:26:42','1907278202958839809','1909779974655574016','2','1','军达-冰蓝色镜框','1',0.00,0.01,0.01,'2025-04-09 09:26:55',NULL,NULL,NULL,'','4200002628202504096084114289','1909779974680043522',NULL),('1909780068674396162','0','2025-04-09 09:27:05','2025-04-09 01:27:05','1907278202958839809','1909780068645732352','2','1','军达-冰蓝色镜框','3',0.00,0.01,0.01,'2025-04-09 09:27:27','2025-04-09 14:29:54','2025-04-09 14:30:07',NULL,'','4200002630202504093227258183','1909780068674396161',NULL),('1909782134645940226','0','2025-04-09 09:35:18','2025-04-09 01:35:17','1907278202958839809','1909782134617276416','2','1','军达-冰蓝色镜框','3',0.00,0.01,0.01,'2025-04-09 09:35:33','2025-04-09 14:00:42','2025-04-09 14:01:06',NULL,'','4200002682202504091759271656','1909782134637551618',NULL),('1909783564563865601','0','2025-04-09 09:40:59','2025-04-09 01:40:58','1907278202958839809','1909783564531007488','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,NULL,NULL,'1909783564555476993',NULL),('1909783615403024386','0','2025-04-09 09:41:11','2025-04-09 01:41:10','1907278202958839809','1909783615365971968','2','1','军达-冰蓝色镜框','3',0.00,0.01,0.01,'2025-04-09 09:41:43','2025-04-09 13:59:40','2025-04-09 13:59:53',NULL,NULL,'4200002620202504099483941877','1909783615394635778',NULL),('1909785338817372162','0','2025-04-09 09:48:02','2025-04-09 01:48:01','1907278202958839809','1909785338784514048','2','1','军达-冰蓝色镜框','3',0.00,0.01,0.01,'2025-04-09 09:48:20','2025-04-09 13:54:58','2025-04-09 13:55:15',NULL,NULL,'4200002686202504094056795850','1909785338808983554',NULL),('1909786875585191938','0','2025-04-09 09:54:08','2025-04-09 01:54:07','1907278202958839809','1909786875548139520','2','1','军达-冰蓝色镜框','3',0.00,0.01,0.01,'2025-04-09 09:54:53','2025-04-09 13:54:06','2025-04-09 13:54:22',NULL,NULL,'4200002698202504097268188162','1909786875576803329',NULL),('1909787108289372163','0','2025-04-09 09:55:03','2025-04-09 01:55:03','1907278202958839809','1909787108281679872','2','1','军达-冰蓝色镜框','3',0.00,0.01,0.01,'2025-04-09 09:55:21','2025-04-09 13:49:38','2025-04-09 13:52:19',NULL,NULL,'4200002711202504096686523641','1909787108289372162',NULL),('1909787615628189697','0','2025-04-09 09:57:04','2025-04-09 01:57:04','1907278202958839809','1909787615595331584','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,NULL,NULL,'1909787615619801090',NULL),('1909787659500609538','0','2025-04-09 09:57:15','2025-04-09 01:57:14','1907278202958839809','1909787659467751424','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,NULL,NULL,'1909787659496415233',NULL),('1909787723182727169','0','2025-04-09 09:57:30','2025-04-09 01:57:30','1907278202958839809','1909787723149869056','2','0','军达-冰蓝色镜框','5',0.00,0.01,0.01,NULL,NULL,NULL,NULL,NULL,NULL,'1909787723174338561',NULL),('1909787789817634818','0','2025-04-09 09:57:46','2025-04-09 01:57:45','1907278202958839809','1909787789788971008','2','0','军达-冰蓝色镜框','5',0.00,0.01,0.01,NULL,NULL,NULL,NULL,NULL,NULL,'1909787789813440514',NULL),('1909788402357985281','0','2025-04-09 10:00:12','2025-04-09 02:00:11','1907278202958839809','1909788402320932864','2','0','军达-冰蓝色镜框','5',0.00,0.01,0.01,NULL,NULL,NULL,NULL,NULL,NULL,'1909788402349596673',NULL),('1909788462323949570','0','2025-04-09 10:00:26','2025-04-09 02:00:26','1907278202958839809','1909788462295285760','2','0','军达-冰蓝色镜框','5',0.00,0.01,0.01,NULL,NULL,NULL,NULL,NULL,NULL,'1909788462315560962',NULL),('1909788600450768898','0','2025-04-09 10:00:59','2025-04-09 02:00:59','1907278202958839809','1909788600417910784','2','1','军达-冰蓝色镜框','3',0.00,0.01,0.01,'2025-04-09 10:01:14','2025-04-09 13:22:19','2025-04-09 13:39:19',NULL,NULL,'4200002676202504091569583798','1909788600446574594',NULL),('1909795012060995585','0','2025-04-09 10:26:28','2025-04-09 02:26:27','1907300228113170433','1909795012032331776','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,NULL,NULL,'1909795012056801282',NULL),('1909795453993836546','0','2025-04-09 10:28:13','2025-04-09 02:28:13','1907300228113170433','1909795453965172736','2','0','方框男生镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,NULL,NULL,'1909795453989642242',NULL),('1909808979487547394','0','2025-04-09 11:21:58','2025-04-09 03:21:57','1907300228113170433','1909808979429556224','2','0','星耀黑银',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,NULL,NULL,'1909808979487547393',NULL),('1909833404836515841','0','2025-04-09 12:59:01','2025-04-09 04:59:01','1907278202958839809','1909833403990016000','2','0','金色','5',0.00,0.01,0.01,NULL,NULL,NULL,NULL,NULL,NULL,'1909833404203175937',NULL),('1909855580075626497','0','2025-04-09 14:27:08','2025-04-09 06:27:08','1907278202958839809','1909855580021850112','2','1','军达-冰蓝色镜框','5',0.00,0.02,0.02,'2025-04-09 14:27:18','2025-04-09 14:28:10','2025-04-09 14:28:22',NULL,NULL,'4200002631202504098714567216','1909855580046266370',NULL),('1909895314843947010','0','2025-04-09 17:05:02','2025-04-09 09:05:01','1907278202958839809','1909895314014208000','2','0','军达-冰蓝色镜框','5',0.00,0.01,0.01,NULL,NULL,NULL,NULL,'',NULL,'1909895314218995713',NULL),('1909900840394870786','0','2025-04-09 17:26:59','2025-04-09 09:26:59','1907278202958839809','1909900840357855232','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,NULL,NULL,'1909900840390676482',NULL),('1909900926017392642','0','2025-04-09 17:27:20','2025-04-09 09:27:19','1907278202958839809','1909900925959405568','2','0','军达-冰蓝色镜框',NULL,0.00,0.02,0.02,NULL,NULL,NULL,NULL,NULL,NULL,'1909900926009004033',NULL),('1909903067750649859','0','2025-04-09 17:35:50','2025-04-09 09:35:50','1907278202958839809','1909903067713634304','2','1','军达-冰蓝色镜框','3',0.00,0.01,0.01,'2025-04-09 17:35:58','2025-04-09 17:36:28','2025-04-09 17:36:39',NULL,NULL,'4200002672202504094073277424','1909903067750649858',NULL),('1910136255261495298','0','2025-04-10 09:02:27','2025-04-10 01:02:26','1910132627566022658','1910136255199313920','2','0','军达-冰蓝色镜框','5',0.00,0.02,0.02,NULL,NULL,NULL,NULL,NULL,NULL,'1910136255253106689',NULL),('1910137141643759618','0','2025-04-10 09:05:58','2025-04-10 01:05:57','1910132627566022658','1910137141564801024','2','0','军达-冰蓝色镜框','5',0.00,0.02,0.02,NULL,NULL,NULL,NULL,NULL,NULL,'1910137141639565313',NULL),('1910137346141245442','0','2025-04-10 09:06:47','2025-04-10 01:06:46','1910132627566022658','1910137346041315328','2','0','军达-冰蓝色镜框','5',0.00,0.05,0.05,NULL,NULL,NULL,NULL,NULL,NULL,'1910137346137051137',NULL),('1910159377826066434','0','2025-04-10 10:34:19','2025-04-10 02:34:19','1907278202958839809','1910159377747148800','2','1','军达-冰蓝色镜框','2',0.00,0.01,0.01,'2025-04-10 10:41:29','2025-04-13 09:05:32',NULL,NULL,NULL,'4200002679202504103431093068','1910159377826066433',NULL),('1910195232242528257','0','2025-04-10 12:56:48','2025-04-10 04:56:47','1910132627566022658','1910195231299469312','2','0','军达-冰蓝色镜框','5',0.00,0.03,0.03,NULL,NULL,NULL,NULL,NULL,NULL,'1910195231621771266',NULL),('1910198873116450817','0','2025-04-10 13:11:16','2025-04-10 05:11:15','1910132627566022658','1910198872181833728','2','0','军达-冰蓝色镜框','5',0.00,0.01,0.01,NULL,NULL,NULL,NULL,NULL,NULL,'1910198872252424193',NULL),('1910199595979579393','0','2025-04-10 13:14:08','2025-04-10 05:14:08','1907278202958839809','1910199595925766144','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,NULL,NULL,'1910199595966996482',NULL),('1910211045791948801','0','2025-04-10 13:59:38','2025-04-10 05:59:37','1907278202958839809','1910211045012537344','2','0','军达-冰蓝色镜框',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,NULL,NULL,'1910211045158608897',NULL),('1910215993258729474','0','2025-04-10 14:19:18','2025-04-10 06:19:17','1907278202958839809','1910215993217515520','2','0','金色',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,NULL,NULL,'1910215993250340866',NULL),('1910227636529205250','0','2025-04-10 15:05:33','2025-04-10 07:05:33','1910132627566022658','1910227635686866944','2','0','军达-冰蓝色镜框','5',0.00,0.01,0.01,NULL,NULL,NULL,NULL,NULL,NULL,'1910227635774230530',NULL),('1910241347767750658','0','2025-04-10 16:00:03','2025-04-10 08:00:02','1910240925996929026','1910241347701309440','2','1','蔡司','3',0.00,0.02,0.02,'2025-04-10 16:00:17','2025-04-10 16:01:10','2025-04-10 16:01:35',NULL,NULL,'4200002688202504108161903377','1910241347767750657',NULL),('1910244440274227201','0','2025-04-10 16:12:20','2025-04-10 08:12:19','1910132627566022658','1910244440211980288','2','1','军达-冰蓝色镜框','3',0.00,0.02,0.02,'2025-04-10 16:12:32','2025-04-10 16:12:55','2025-04-10 16:13:10',NULL,NULL,'4200002670202504104578377547','1910244440261644289',NULL),('1910264316111998977','0','2025-04-10 17:31:19','2025-04-10 09:31:18','1907278202958839809','1910264316058140672','2','0','优雅精致纯钛架',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,NULL,NULL,'1910264316099416066',NULL),('1910296232953499651','0','2025-04-10 19:38:08','2025-04-10 11:38:08','1910132627566022658','1910296232941584384','2','0','军达-冰蓝色镜框',NULL,0.00,0.02,0.02,NULL,NULL,NULL,NULL,NULL,NULL,'1910296232953499650',NULL),('1910492258448560130','0','2025-04-11 08:37:04','2025-04-11 00:37:04','1907278202958839809','1910492258440839168','2','0','金色',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,NULL,NULL,'1910492258448560129',NULL),('1910495149527781379','0','2025-04-11 08:48:34','2025-04-11 00:48:33','1907278202958839809','1910495149515866112','2','0','金色',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,NULL,NULL,'1910495149527781378',NULL),('1911253766967152642','0','2025-04-13 11:03:02','2025-04-13 03:03:02','1907278202958839809','1911253766905004032','2','0','简约椭圆',NULL,0.00,0.01,0.01,NULL,NULL,NULL,NULL,NULL,NULL,'1911253766941986818',NULL),('1911289364826312705','0','2025-04-13 13:24:29','2025-04-13 05:24:29','1910132627566022658','1911289364789329920','2','1','金色','5',0.00,0.01,0.01,'2025-04-13 13:24:36','2025-04-13 13:25:21','2025-04-13 13:25:48',NULL,NULL,'4200002620202504131278005317','1911289364813729793',NULL),('1911289865781399554','0','2025-04-13 13:26:29','2025-04-13 05:26:28','1910132627566022658','1911289865736028160','2','1','军达-冰蓝色镜框','5',0.00,0.02,0.02,'2025-04-13 13:26:39','2025-04-13 13:27:27','2025-04-13 13:27:42',NULL,NULL,'4200002676202504132418863205','1911289865773010945',NULL),('1911290482100817922','0','2025-04-13 13:28:56','2025-04-13 05:28:55','1910132627566022658','1911290482068029440','2','1','金色','5',0.00,0.01,0.01,'2025-04-13 13:29:02','2025-04-13 13:29:42','2025-04-13 13:29:48',NULL,NULL,'4200002627202504139401870405','1911290482096623617',NULL),('1911290970108088321','0','2025-04-13 13:30:52','2025-04-13 05:30:52','1907278202958839809','1911290970075299840','2','1','军达-冰蓝色镜框','5',0.00,0.01,0.01,'2025-04-13 13:31:03','2025-04-13 13:31:30','2025-04-13 13:31:41',NULL,NULL,'4200002671202504132864283598','1911290970099699714',NULL),('1911291366809554946','0','2025-04-13 13:32:27','2025-04-13 05:32:26','1907278202958839809','1911291366759989248','2','1','金色','1',0.00,0.01,0.01,'2025-04-13 13:32:37',NULL,NULL,NULL,NULL,'4200002705202504135824942294','1911291366801166338',NULL),('1911294114305167362','0','2025-04-13 13:43:22','2025-04-13 05:43:21','1907278202958839809','1911294114276573184','2','1','金色','1',0.00,0.01,0.01,'2025-04-13 13:43:36',NULL,NULL,NULL,NULL,'4200002671202504138611603719','1911294114296778753',NULL),('1912392808375021570','0','2025-04-16 14:29:11','2025-04-16 06:29:10','1912392421513392129','1912392808300281856','2','0','军达-冰蓝色镜框',NULL,0.00,0.02,0.02,NULL,NULL,NULL,NULL,NULL,NULL,'1912392808366632962',NULL),('1914997890295898114','0','2025-04-23 19:00:51','2025-04-23 11:00:50','1910132627566022658','1914997890195914752','2','1','军达-冰蓝色镜框','5',0.00,0.01,0.01,'2025-04-23 19:01:06','2025-04-23 19:02:40','2025-04-23 19:03:18',NULL,NULL,'4200002625202504230411747807','1914997890253955074',NULL);
/*!40000 ALTER TABLE `order_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_item`
--

DROP TABLE IF EXISTS `order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_item` (
  `id` varchar(32) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'PK',
  `del_flag` char(2) COLLATE utf8mb4_croatian_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `order_id` varchar(32) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '订单编号',
  `spu_id` varchar(32) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '商品Id',
  `spu_name` varchar(200) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '商品名',
  `pic_url` varchar(500) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '图片',
  `quantity` int(11) NOT NULL COMMENT '商品数量',
  `sales_price` decimal(10,2) NOT NULL COMMENT '购买单价',
  `freight_price` decimal(10,2) DEFAULT '0.00' COMMENT '运费金额',
  `payment_price` decimal(10,2) DEFAULT '0.00' COMMENT '支付金额（购买单价*商品数量+运费金额）',
  `remark` varchar(250) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '备注',
  `status` char(2) COLLATE utf8mb4_croatian_ci DEFAULT '0' COMMENT '状态0：正常；1：退款中；2:拒绝退款；3：同意退款',
  `is_refund` char(2) COLLATE utf8mb4_croatian_ci DEFAULT '0' COMMENT '是否退款0:否 1：是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='订单详情';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_item`
--

LOCK TABLES `order_item` WRITE;
/*!40000 ALTER TABLE `order_item` DISABLE KEYS */;
INSERT INTO `order_item` VALUES ('1354469716075237378','0','2021-01-28 00:41:59','2021-01-27 16:41:59','1354469715404148737','1353738731164561410','iPhone12白色','http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/category-9.png',1,4999.00,0.00,4999.00,NULL,'0','0'),('1354474071088238594','0','2021-01-28 00:59:18','2021-01-27 16:59:18','1354474070446510081','1353738731164561410','iPhone12白色','http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/category-9.png',1,4999.00,0.00,4999.00,NULL,'0','0'),('1354620400435253249','0','2021-01-28 10:40:45','2021-01-28 02:40:45','1354620399822884865','1353738731164561410','iPhone12白色','http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/category-9.png',1,4999.00,0.00,4999.00,NULL,'0','0'),('1354795348378370049','0','2021-01-28 22:15:55','2021-01-28 14:15:55','1354795347837304834','1353738731164561410','iPhone12白色','http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/category-9.png',1,4999.00,0.00,4999.00,NULL,'0','0'),('1354797186527883265','0','2021-01-28 22:23:14','2021-01-28 14:23:14','1354797185856794625','1353738731164561410','iPhone12白色','http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/category-9.png',1,4999.00,0.00,4999.00,NULL,'0','0'),('1354797795180060673','0','2021-01-28 22:25:39','2021-01-28 14:25:39','1354797794534137858','1353738731164561410','iPhone12白色','http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/category-9.png',1,4999.00,0.00,4999.00,NULL,'0','0'),('1354798824613257217','0','2021-01-28 22:29:44','2021-01-28 14:29:44','1354798824059609090','1353738731164561410','iPhone12白色','http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/category-9.png',1,0.01,0.00,0.01,NULL,'0','0'),('1354798971694915585','0','2021-01-28 22:30:19','2021-01-28 14:30:19','1354798971141267457','1353738731164561410','iPhone12白色','http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/category-9.png',1,0.01,0.00,0.01,NULL,'0','0'),('1355417351444508674','0','2021-01-30 15:27:33','2021-01-30 07:27:33','1355417350676951041','1355412081553190914','【时尚博主推荐】Daphne/达芙妮2020春季新款闪耀水晶扣时装鞋淑雅女单鞋 粉红112 38','http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/aed00a45-1598-490d-9ea9-b35c386ae6b3.png',2,0.10,0.00,0.20,NULL,'0','0'),('1355418768758550529','0','2021-01-30 15:33:11','2021-01-30 07:33:11','1355418768053907457','1353738731164561410','Apple iPhone','http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/10952adc-cad0-4c53-8762-9906d1dde220.jpg',1,6000.00,0.00,6000.00,NULL,'0','0'),('1355418868545236994','0','2021-01-30 15:33:35','2021-01-30 07:33:35','1355418867987394561','1355412081553190914','【时尚博主推荐】Daphne/达芙妮2020春季新款闪耀水晶扣时装鞋淑雅女单鞋 粉红112 38','http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/aed00a45-1598-490d-9ea9-b35c386ae6b3.png',1,0.10,0.00,0.10,NULL,'0','0'),('1355426473221054466','0','2021-01-30 16:03:48','2021-01-30 08:03:48','1355426472587714562','1355412081553190914','【时尚博主推荐】Daphne/达芙妮2020春季新款闪耀水晶扣时装鞋淑雅女单鞋 粉红112 38','http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/aed00a45-1598-490d-9ea9-b35c386ae6b3.png',1,0.10,0.00,0.10,NULL,'0','0'),('1357673550390022145','0','2021-02-05 20:52:52','2021-02-05 12:52:52','1357673549756682241','1353738731164561410','iPhone 12 Pro','http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/goods-4.png',1,8499.00,0.00,8499.00,NULL,'0','0'),('1632993114403713025','0','2023-03-07 14:34:32','2023-03-07 06:34:32','1632993114357575681','1355412081553190914','HUAWEI P40 Pro+','https://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/goods-11.png',1,0.98,0.00,0.98,NULL,'0','0'),('1632994752065449986','0','2023-03-07 14:41:03','2023-03-07 06:41:03','1632994752065449985','1355412081553190914','HUAWEI P40 Pro+','https://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/goods-11.png',1,0.10,0.00,0.10,NULL,'0','0'),('1632995133310963713','0','2023-03-07 14:42:34','2023-03-07 06:42:34','1632995133256437763','1355412081553190914','HUAWEI P40 Pro+','https://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/goods-11.png',1,0.10,0.00,0.10,NULL,'3','1'),('1645623820762038274','0','2023-04-11 11:04:27','2023-04-11 03:04:27','1645623820711706626','1442505794278191105','Apple iPhone 13 Pro','https://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/132.png',1,8999.00,0.00,8999.00,NULL,'0','0'),('1645635415768621058','0','2023-04-11 11:50:32','2023-04-11 03:50:32','1645635415705706497','1355412081553190914','HUAWEI P40 Pro+','https://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/goods-11.png',1,0.10,0.00,0.10,NULL,'3','1'),('1901559589796089858','0','2025-03-17 17:01:50','2025-03-17 09:01:50','1901559589749952513','1900379604263710721','优雅精致纯钛架','/profile/upload/2025/03/14/O1CN01ZBFYzw23ffZvicJET_!!2212057487283-0-cib_20250314105135A008.jpg',1,15.00,0.00,15.00,NULL,'0','0'),('1901559589804478466','0','2025-03-17 17:01:50','2025-03-17 09:01:50','1901559589749952513','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/03/14/O1CN01a248j423ffZy7Wy5R_!!2212057487283-0-cib_20250314094937A002.jpg',1,10.00,0.00,10.00,NULL,'0','0'),('1909241965253562370','0','2025-04-07 21:48:51','2025-04-07 13:48:51','1909241965190647810','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,10.00,20.00,30.00,NULL,'0','0'),('1909246795497934849','0','2025-04-07 22:08:02','2025-04-07 14:08:02','1909246795489546241','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,10.00,0.00,10.00,NULL,'0','0'),('1909248649837481985','0','2025-04-07 22:15:24','2025-04-07 14:15:24','1909248649824899074','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,10.00,0.00,10.00,NULL,'0','0'),('1909403939916550146','0','2025-04-08 08:32:28','2025-04-08 00:32:28','1909403939903967234','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,10.00,0.00,10.00,NULL,'0','0'),('1909407615217373185','0','2025-04-08 08:47:05','2025-04-08 00:47:05','1909407615208984578','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,10.00,0.00,10.00,NULL,'0','0'),('1909412235348086786','0','2025-04-08 09:05:26','2025-04-08 01:05:26','1909412235268395010','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,10.00,0.00,10.00,NULL,'0','0'),('1909412914334601217','0','2025-04-08 09:08:08','2025-04-08 01:08:08','1909412914326212610','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,10.00,0.00,10.00,NULL,'0','0'),('1909415386285412353','0','2025-04-08 09:17:57','2025-04-08 01:17:57','1909415386277023745','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,10.00,0.00,10.00,NULL,'0','0'),('1909415645191409666','0','2025-04-08 09:18:59','2025-04-08 01:18:59','1909415645183021058','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,10.00,0.00,10.00,NULL,'0','0'),('1909416095483498498','0','2025-04-08 09:20:47','2025-04-08 01:20:47','1909416095475109889','1900378351710318593','金色','/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg',1,11.00,0.00,11.00,NULL,'0','0'),('1909416766572138497','0','2025-04-08 09:23:27','2025-04-08 01:23:27','1909416766563749890','1900378351710318593','金色','/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg',1,11.00,0.00,11.00,NULL,'0','0'),('1909416858427396098','0','2025-04-08 09:23:48','2025-04-08 01:23:48','1909416858419007490','1900379604263710721','优雅精致纯钛架','/profile/upload/2025/04/02/O1CN01rwlGpu23ffZwigOaQ_!!2212057487283-0-cib_20250402162441A009.jpg',1,15.00,0.00,15.00,NULL,'0','0'),('1909417103794180097','0','2025-04-08 09:24:47','2025-04-08 01:24:47','1909417103785791490','1900378351710318593','金色','/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg',1,11.00,0.00,11.00,NULL,'0','0'),('1909417386410577921','0','2025-04-08 09:25:54','2025-04-08 01:25:54','1909417386402189313','1900378351710318593','金色','/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg',1,11.00,0.00,11.00,NULL,'0','0'),('1909420850146512897','0','2025-04-08 09:39:40','2025-04-08 01:39:40','1909420850138124289','1900378673224691713','简约椭圆','/profile/upload/2025/04/02/O1CN01lyQRHs23ffIcjlXXp_!!2212057487283-0-cib_20250402162429A008.jpg',1,11.00,0.00,11.00,NULL,'0','0'),('1909421506601226242','0','2025-04-08 09:42:17','2025-04-08 01:42:17','1909421506592837633','1900378673224691713','简约椭圆','/profile/upload/2025/04/02/O1CN01lyQRHs23ffIcjlXXp_!!2212057487283-0-cib_20250402162429A008.jpg',1,11.00,0.00,11.00,NULL,'0','0'),('1909422767274790913','0','2025-04-08 09:47:17','2025-04-08 01:47:17','1909422767266402306','1900378673224691713','简约椭圆','/profile/upload/2025/04/02/O1CN01lyQRHs23ffIcjlXXp_!!2212057487283-0-cib_20250402162429A008.jpg',1,11.00,0.00,11.00,NULL,'0','0'),('1909422804146917377','0','2025-04-08 09:47:26','2025-04-08 01:47:26','1909422804138528770','1900379604263710721','优雅精致纯钛架','/profile/upload/2025/04/02/O1CN01rwlGpu23ffZwigOaQ_!!2212057487283-0-cib_20250402162441A009.jpg',1,15.00,0.00,15.00,NULL,'0','0'),('1909422943938875394','0','2025-04-08 09:47:59','2025-04-08 01:47:59','1909422943930486785','1900382773244932098','巴黎灰岛','/profile/upload/2025/04/02/O1CN01fiWHYn250Yylo5yp4_!!2209559537464-0-cib_20250402162518A011.jpg',1,13.00,0.00,13.00,NULL,'0','0'),('1909423759059914753','0','2025-04-08 09:51:14','2025-04-08 01:51:14','1909423759051526146','1900382455924862977','星耀黑银','/profile/upload/2025/04/02/2_20250402162503A010.jpg',1,13.00,0.00,13.00,NULL,'0','0'),('1909424048873738241','0','2025-04-08 09:52:23','2025-04-08 01:52:23','1909424048865349633','1900382773244932098','巴黎灰岛','/profile/upload/2025/04/02/O1CN01fiWHYn250Yylo5yp4_!!2209559537464-0-cib_20250402162518A011.jpg',1,13.00,0.00,13.00,NULL,'0','0'),('1909427697578467329','0','2025-04-08 10:06:53','2025-04-08 02:06:53','1909427697490386945','1900379604263710721','优雅精致纯钛架','/profile/upload/2025/04/02/O1CN01rwlGpu23ffZwigOaQ_!!2212057487283-0-cib_20250402162441A009.jpg',1,15.00,0.00,15.00,NULL,'0','0'),('1909428445636780035','0','2025-04-08 10:09:51','2025-04-08 02:09:51','1909428445636780034','1900379604263710721','优雅精致纯钛架','/profile/upload/2025/04/02/O1CN01rwlGpu23ffZwigOaQ_!!2212057487283-0-cib_20250402162441A009.jpg',1,15.00,0.00,15.00,NULL,'0','0'),('1909430786838552577','0','2025-04-08 10:19:09','2025-04-08 02:19:09','1909430786809192449','1900379604263710721','优雅精致纯钛架','/profile/upload/2025/04/02/O1CN01rwlGpu23ffZwigOaQ_!!2212057487283-0-cib_20250402162441A009.jpg',1,15.00,0.00,15.00,NULL,'0','0'),('1909433413789810690','0','2025-04-08 10:29:36','2025-04-08 02:29:36','1909433413735284738','1900382455924862977','星耀黑银','/profile/upload/2025/04/02/2_20250402162503A010.jpg',1,13.00,0.00,13.00,NULL,'0','0'),('1909435201129619458','0','2025-04-08 10:36:42','2025-04-08 02:36:42','1909435201062510593','1900382773244932098','巴黎灰岛','/profile/upload/2025/04/02/O1CN01fiWHYn250Yylo5yp4_!!2209559537464-0-cib_20250402162518A011.jpg',1,13.00,0.00,13.00,NULL,'0','0'),('1909450699514912772','0','2025-04-08 11:38:17','2025-04-08 03:38:17','1909450699514912771','1900378351710318593','金色','/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg',1,11.00,0.00,11.00,NULL,'0','0'),('1909474273625690113','0','2025-04-08 13:11:57','2025-04-08 05:11:57','1909474273558581251','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909475366413815809','0','2025-04-08 13:16:18','2025-04-08 05:16:18','1909475366304763905','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909486529109348354','0','2025-04-08 14:00:39','2025-04-08 06:00:39','1909486529088376834','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909489014951714817','0','2025-04-08 14:10:32','2025-04-08 06:10:32','1909489014892994561','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909494718433402882','0','2025-04-08 14:33:12','2025-04-08 06:33:12','1909494718420819970','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909496224838590465','0','2025-04-08 14:39:11','2025-04-08 06:39:11','1909496224767287297','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909496404417716225','0','2025-04-08 14:39:54','2025-04-08 06:39:54','1909496404400939010','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909497426477326339','0','2025-04-08 14:43:57','2025-04-08 06:43:57','1909497426477326338','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909498542267047938','0','2025-04-08 14:48:23','2025-04-08 06:48:23','1909498542254465026','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909498944274309123','0','2025-04-08 14:49:59','2025-04-08 06:49:59','1909498944274309122','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909499416121004034','0','2025-04-08 14:51:52','2025-04-08 06:51:52','1909499415986786306','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909499520164909057','0','2025-04-08 14:52:17','2025-04-08 06:52:17','1909499520152326146','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909499813413867522','0','2025-04-08 14:53:26','2025-04-08 06:53:26','1909499813401284610','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909500103953305603','0','2025-04-08 14:54:36','2025-04-08 06:54:36','1909500103953305602','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909500164334505985','0','2025-04-08 14:54:50','2025-04-08 06:54:50','1909500164317728770','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909500257099927556','0','2025-04-08 14:55:12','2025-04-08 06:55:12','1909500257099927555','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909500297105199106','0','2025-04-08 14:55:22','2025-04-08 06:55:22','1909500297096810498','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909500317808283650','0','2025-04-08 14:55:27','2025-04-08 06:55:27','1909500317724397571','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909504734573973506','0','2025-04-08 15:13:00','2025-04-08 07:13:00','1909504734561390594','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909513503374651394','0','2025-04-08 15:47:50','2025-04-08 07:47:50','1909513503307542530','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909514804175093761','0','2025-04-08 15:53:01','2025-04-08 07:53:01','1909514804070236161','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909519340256182273','0','2025-04-08 16:11:02','2025-04-08 08:11:02','1909519340210044929','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909520687072350209','0','2025-04-08 16:16:23','2025-04-08 08:16:23','1909520686996852738','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909525358717444098','0','2025-04-08 16:34:57','2025-04-08 08:34:57','1909525358532894721','1900378351710318593','金色','/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909529369818439681','0','2025-04-08 16:50:53','2025-04-08 08:50:53','1909529369805856769','1900383473018417154','全框','/profile/upload/2025/04/02/O1CN01AVDr61250ZBTE7nQD_!!2209559537464-0-cib_20250402162542A013.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909537018916200449','0','2025-04-08 17:21:17','2025-04-08 09:21:17','1909537018857480193','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',2,0.01,0.00,0.02,NULL,'0','0'),('1909537018916200450','0','2025-04-08 17:21:17','2025-04-08 09:21:17','1909537018857480193','1900382455924862977','星耀黑银','/profile/upload/2025/04/02/2_20250402162503A010.jpg',2,0.01,0.00,0.02,NULL,'0','0'),('1909537018916200451','0','2025-04-08 17:21:17','2025-04-08 09:21:17','1909537018857480193','1900382773244932098','巴黎灰岛','/profile/upload/2025/04/02/O1CN01fiWHYn250Yylo5yp4_!!2209559537464-0-cib_20250402162518A011.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909537018916200452','0','2025-04-08 17:21:17','2025-04-08 09:21:17','1909537018857480193','1900378351710318593','金色','/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909537232104284162','0','2025-04-08 17:22:08','2025-04-08 09:22:08','1909537232091701250','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909537232104284163','0','2025-04-08 17:22:08','2025-04-08 09:22:08','1909537232091701250','1900382455924862977','星耀黑银','/profile/upload/2025/04/02/2_20250402162503A010.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909539063157055490','0','2025-04-08 17:29:24','2025-04-08 09:29:24','1909539063148666881','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909540322949816321','0','2025-04-08 17:34:25','2025-04-08 09:34:25','1909540322941427713','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909540512003874819','0','2025-04-08 17:35:10','2025-04-08 09:35:10','1909540512003874818','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909540681512476674','0','2025-04-08 17:35:50','2025-04-08 09:35:50','1909540681504088065','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909779974680043524','0','2025-04-09 09:26:42','2025-04-09 01:26:42','1909779974680043523','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909780068686979074','0','2025-04-09 09:27:05','2025-04-09 01:27:05','1909780068674396162','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909782134645940227','0','2025-04-09 09:35:17','2025-04-09 01:35:17','1909782134645940226','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909783564568059906','0','2025-04-09 09:40:58','2025-04-09 01:40:58','1909783564563865601','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909783615403024387','0','2025-04-09 09:41:10','2025-04-09 01:41:10','1909783615403024386','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909785338821566465','0','2025-04-09 09:48:01','2025-04-09 01:48:01','1909785338817372162','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909786875585191939','0','2025-04-09 09:54:07','2025-04-09 01:54:07','1909786875585191938','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909787108289372164','0','2025-04-09 09:55:03','2025-04-09 01:55:03','1909787108289372163','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909787615632384002','0','2025-04-09 09:57:04','2025-04-09 01:57:04','1909787615628189697','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909787659508998146','0','2025-04-09 09:57:14','2025-04-09 01:57:14','1909787659500609538','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909787723191115777','0','2025-04-09 09:57:30','2025-04-09 01:57:30','1909787723182727169','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909787789830217730','0','2025-04-09 09:57:45','2025-04-09 01:57:45','1909787789817634818','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909788402366373889','0','2025-04-09 10:00:11','2025-04-09 02:00:11','1909788402357985281','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909788462323949571','0','2025-04-09 10:00:26','2025-04-09 02:00:26','1909788462323949570','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909788600454963201','0','2025-04-09 10:00:59','2025-04-09 02:00:59','1909788600450768898','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'3','0'),('1909795012069384194','0','2025-04-09 10:26:27','2025-04-09 02:26:27','1909795012060995585','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909795454002225154','0','2025-04-09 10:28:13','2025-04-09 02:28:13','1909795453993836546','1900383214020145154','方框男生镜框','/profile/upload/2025/04/02/O1CN01aDLmEj250Z4n2wWGK_!!2209559537464-0-cib_20250402162529A012.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909808979546267649','0','2025-04-09 11:21:57','2025-04-09 03:21:57','1909808979487547394','1900382455924862977','星耀黑银','/profile/upload/2025/04/02/2_20250402162503A010.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909833404882653186','0','2025-04-09 12:59:01','2025-04-09 04:59:01','1909833404836515841','1900378351710318593','金色','/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909855580084015106','0','2025-04-09 14:27:08','2025-04-09 08:34:15','1909855580075626497','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'3','1'),('1909855580088209410','0','2025-04-09 14:27:08','2025-04-09 08:33:58','1909855580075626497','1900378351710318593','金色','/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg',1,0.01,0.00,0.01,NULL,'3','1'),('1909895314902667265','0','2025-04-09 17:05:01','2025-04-09 09:05:01','1909895314843947010','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909900840403259394','0','2025-04-09 17:26:59','2025-04-09 09:26:59','1909900840394870786','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909900926025781249','0','2025-04-09 17:27:19','2025-04-09 09:27:19','1909900926017392642','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909900926025781250','0','2025-04-09 17:27:19','2025-04-09 09:27:19','1909900926017392642','1900378351710318593','金色','/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1909903067750649860','0','2025-04-09 17:35:50','2025-04-09 09:35:50','1909903067750649859','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'2','0'),('1910136255269883906','0','2025-04-10 09:02:26','2025-04-10 01:02:26','1910136255261495298','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1910136255269883907','0','2025-04-10 09:02:26','2025-04-10 01:02:26','1910136255261495298','1900378673224691713','简约椭圆','/profile/upload/2025/04/02/O1CN01lyQRHs23ffIcjlXXp_!!2212057487283-0-cib_20250402162429A008.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1910137141652148225','0','2025-04-10 09:05:57','2025-04-10 01:05:57','1910137141643759618','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1910137141652148226','0','2025-04-10 09:05:57','2025-04-10 01:05:57','1910137141643759618','1900378351710318593','金色','/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1910137346149634050','0','2025-04-10 09:06:46','2025-04-10 01:06:46','1910137346141245442','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1910137346149634051','0','2025-04-10 09:06:46','2025-04-10 01:06:46','1910137346141245442','1900378351710318593','金色','/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1910137346149634052','0','2025-04-10 09:06:46','2025-04-10 01:06:46','1910137346141245442','1900378673224691713','简约椭圆','/profile/upload/2025/04/02/O1CN01lyQRHs23ffIcjlXXp_!!2212057487283-0-cib_20250402162429A008.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1910137346149634053','0','2025-04-10 09:06:46','2025-04-10 01:06:46','1910137346141245442','1900382455924862977','星耀黑银','/profile/upload/2025/04/02/2_20250402162503A010.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1910137346149634054','0','2025-04-10 09:06:46','2025-04-10 01:06:46','1910137346141245442','1900382773244932098','巴黎灰岛','/profile/upload/2025/04/02/O1CN01fiWHYn250Yylo5yp4_!!2209559537464-0-cib_20250402162518A011.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1910159377901563906','0','2025-04-10 10:34:19','2025-04-10 02:34:19','1910159377826066434','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1910195232280276993','0','2025-04-10 12:56:47','2025-04-10 04:56:47','1910195232242528257','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1910195232280276994','0','2025-04-10 12:56:47','2025-04-10 04:56:47','1910195232242528257','1900378351710318593','金色','/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1910195232280276995','0','2025-04-10 12:56:47','2025-04-10 04:56:47','1910195232242528257','1900378673224691713','简约椭圆','/profile/upload/2025/04/02/O1CN01lyQRHs23ffIcjlXXp_!!2212057487283-0-cib_20250402162429A008.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1910198873175171074','0','2025-04-10 13:11:15','2025-04-10 05:11:15','1910198873116450817','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1910199595992162306','0','2025-04-10 13:14:08','2025-04-10 05:14:08','1910199595979579393','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1910211045838086145','0','2025-04-10 13:59:37','2025-04-10 05:59:37','1910211045791948801','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1910215993267118082','0','2025-04-10 14:19:17','2025-04-10 06:19:17','1910215993258729474','1900378351710318593','金色','/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1910227636562759681','0','2025-04-10 15:05:33','2025-04-10 07:05:33','1910227636529205250','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1910241347813888001','0','2025-04-10 16:00:02','2025-04-10 08:00:02','1910241347767750658','1910142888230309889','蔡司','/profile/upload/2025/04/10/cs1_20250410103456A005.jpg',2,0.01,0.00,0.02,NULL,'3','0'),('1910244440278421505','0','2025-04-10 16:12:19','2025-04-10 08:12:19','1910244440274227201','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'1','0'),('1910244440278421506','0','2025-04-10 16:12:19','2025-04-10 08:12:19','1910244440274227201','1910142888230309889','蔡司','/profile/upload/2025/04/10/cs1_20250410103456A005.jpg',1,0.01,0.00,0.01,NULL,'1','0'),('1910264316111998978','0','2025-04-10 17:31:18','2025-04-10 09:31:18','1910264316111998977','1900379604263710721','优雅精致纯钛架','/profile/upload/2025/04/02/O1CN01rwlGpu23ffZwigOaQ_!!2212057487283-0-cib_20250402162441A009.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1910296232953499652','0','2025-04-10 19:38:08','2025-04-10 11:38:08','1910296232953499651','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1910296232953499653','0','2025-04-10 19:38:08','2025-04-10 11:38:08','1910296232953499651','1910148048591532034','明月','/profile/upload/2025/04/10/明月_20250410102247A003.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1910492258448560131','0','2025-04-11 08:37:04','2025-04-11 00:37:04','1910492258448560130','1900378351710318593','金色','/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1910495149527781380','0','2025-04-11 08:48:33','2025-04-11 00:48:33','1910495149527781379','1900378351710318593','金色','/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1911253767046844418','0','2025-04-13 11:03:02','2025-04-13 03:03:02','1911253766967152642','1900378673224691713','简约椭圆','/profile/upload/2025/04/02/O1CN01lyQRHs23ffIcjlXXp_!!2212057487283-0-cib_20250402162429A008.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1911289364834701313','0','2025-04-13 13:24:29','2025-04-13 05:24:29','1911289364826312705','1900378351710318593','金色','/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg',1,0.01,0.00,0.01,NULL,'3','1'),('1911289865785593857','0','2025-04-13 13:26:28','2025-04-13 05:26:28','1911289865781399554','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'3','1'),('1911289865789788162','0','2025-04-13 13:26:28','2025-04-13 05:26:28','1911289865781399554','1910142888230309889','蔡司','/profile/upload/2025/04/10/cs1_20250410103456A005.jpg',1,0.01,0.00,0.01,NULL,'3','1'),('1911290482109206529','0','2025-04-13 13:28:55','2025-04-13 05:28:55','1911290482100817922','1900378351710318593','金色','/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg',1,0.01,0.00,0.01,NULL,'3','1'),('1911290970112282625','0','2025-04-13 13:30:52','2025-04-13 05:30:52','1911290970108088321','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'3','1'),('1911291366817943554','0','2025-04-13 13:32:26','2025-04-13 05:32:26','1911291366809554946','1900378351710318593','金色','/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1911294114313555970','0','2025-04-13 13:43:21','2025-04-13 05:43:21','1911294114305167362','1900378351710318593','金色','/profile/upload/2025/04/07/O1CN01a4p6a523ffIYFl6XA_!!2212057487283-0-cib_20250402162410A007_20250407111457A001.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1912392808601513985','0','2025-04-16 14:29:10','2025-04-16 06:29:10','1912392808375021570','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/07/bls_20250407111523A002.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1912392808601513986','0','2025-04-16 14:29:10','2025-04-16 06:29:10','1912392808375021570','1910142888230309889','蔡司','/profile/upload/2025/04/10/cs1_20250410103456A005.jpg',1,0.01,0.00,0.01,NULL,'0','0'),('1914997890400755713','0','2025-04-23 19:00:50','2025-04-23 11:00:50','1914997890295898114','1900363838747389953','军达-冰蓝色镜框','/profile/upload/2025/04/16/bls_20250416185945A029.jpg',1,0.01,0.00,0.01,NULL,'3','1');
/*!40000 ALTER TABLE `order_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_logistics`
--

DROP TABLE IF EXISTS `order_logistics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_logistics` (
  `id` varchar(32) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'PK',
  `del_flag` char(2) COLLATE utf8mb4_croatian_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `postal_code` varchar(10) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '邮编',
  `user_name` varchar(50) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '收货人名字',
  `tel_num` varchar(20) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '电话号码',
  `address` varchar(255) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '详细地址',
  `logistics` char(20) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '物流商家',
  `logistics_no` varchar(30) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '物流单号',
  `status` char(2) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '快递单当前状态，包括-1错误，0在途，1揽收，2疑难，3签收，4退签，5派件，6退回，7转投?等7个状态',
  `is_check` char(2) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '签收标记（0：未签收；1：已签收）',
  `message` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '相关信息',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='订单物流表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_logistics`
--

LOCK TABLES `order_logistics` WRITE;
/*!40000 ALTER TABLE `order_logistics` DISABLE KEYS */;
INSERT INTO `order_logistics` VALUES ('1354469714800168962','0','2021-01-28 00:41:59','2021-01-27 16:41:59',NULL,'张三','18602513214','广东省广州市海珠区新港中路397号',NULL,NULL,NULL,NULL,NULL),('1354474069813170178','0','2021-01-28 00:59:17','2021-01-27 16:59:17',NULL,'张三','18563265321','广东省广州市海珠区新港中路397号',NULL,NULL,NULL,NULL,NULL),('1354620399231488001','0','2021-01-28 10:40:45','2021-01-28 02:40:45',NULL,'张三','18563265321','广东省广州市海珠区新港中路397号',NULL,NULL,NULL,NULL,NULL),('1354795347308822530','0','2021-01-28 22:15:55','2021-01-28 14:15:55',NULL,'张三','18563265321','广东省广州市海珠区新港中路397号',NULL,NULL,NULL,NULL,NULL),('1354797185185705985','0','2021-01-28 22:23:13','2021-01-28 14:23:13',NULL,'张三','18563265321','广东省广州市海珠区新港中路397号',NULL,NULL,NULL,NULL,NULL),('1354797793913380865','0','2021-01-28 22:25:38','2021-01-28 14:25:38',NULL,'张三','18563265321','广东省广州市海珠区新港中路397号',NULL,NULL,NULL,NULL,NULL),('1354798823514349569','0','2021-01-28 22:29:44','2021-01-28 14:29:44',NULL,'张三','18563265321','广东省广州市海珠区新港中路397号','yunda','48466513213213165','1',NULL,NULL),('1354798970596007937','0','2021-01-28 22:30:19','2021-01-28 14:30:19',NULL,'张三','18563265321','广东省广州市海珠区新港中路397号',NULL,NULL,NULL,NULL,NULL),('1355417349930364930','0','2021-01-30 15:27:33','2021-01-30 07:27:33',NULL,'张三','15580802543','北京市北京市东城区大冲地铁口',NULL,NULL,NULL,NULL,NULL),('1355418767420567554','0','2021-01-30 15:33:11','2021-01-30 07:33:11',NULL,'张三','15580802543','北京市北京市东城区大冲地铁口',NULL,NULL,NULL,NULL,NULL),('1355418867316305921','0','2021-01-30 15:33:35','2021-01-30 07:33:35',NULL,'张三','15580802543','北京市北京市东城区大冲地铁口',NULL,NULL,NULL,NULL,NULL),('1355426471975346177','0','2021-01-30 16:03:48','2021-01-30 08:03:48',NULL,'张三','15580802543','北京市北京市东城区大冲地铁口',NULL,NULL,NULL,NULL,NULL),('1357673549135925250','0','2021-02-05 20:52:52','2021-02-05 12:52:52',NULL,'张三','18563265321','广东省广州市海珠区新港中路397号',NULL,NULL,NULL,NULL,NULL),('1632993114324021250','0','2023-03-07 14:34:32','2023-03-07 06:34:32',NULL,'张三','18563265321','广东省广州市海珠区新港中路397号',NULL,NULL,NULL,NULL,NULL),('1632994752031895553','0','2023-03-07 14:41:03','2023-03-07 06:41:03',NULL,'张三','18563265321','广东省广州市海珠区新港中路397号',NULL,NULL,NULL,NULL,NULL),('1632995133256437762','0','2023-03-07 14:42:34','2023-03-07 06:42:34',NULL,'张三','18563265321','广东省广州市海珠区新港中路397号','huitongkuaidi','566985565255','1',NULL,NULL),('1645623820711706625','0','2023-04-11 11:04:27','2023-04-11 03:04:27',NULL,'张三','18563265321','广东省广州市海珠区新港中路397号',NULL,NULL,NULL,NULL,NULL),('1645635415605043201','0','2023-04-11 11:50:32','2023-04-11 03:50:32',NULL,'张三','18563265321','广东省广州市海珠区新港中路397号',NULL,NULL,NULL,NULL,NULL),('1901559589724786690','0','2025-03-17 17:01:50','2025-03-17 09:01:50',NULL,'桂花鱼','13313124523','江苏省苏州市昆山市前进中路345号',NULL,NULL,NULL,NULL,NULL),('1909241965169676289','0','2025-04-07 21:48:51','2025-04-07 13:48:51',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909246795485351937','0','2025-04-07 22:08:02','2025-04-07 14:08:02',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909248649824899073','0','2025-04-07 22:15:24','2025-04-07 14:15:24',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909403939895578626','0','2025-04-08 08:32:28','2025-04-08 00:32:28',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909407615204790273','0','2025-04-08 08:47:05','2025-04-08 00:47:05',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909412235260006402','0','2025-04-08 09:05:26','2025-04-08 01:05:26',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909412914313629697','0','2025-04-08 09:08:08','2025-04-08 01:08:08',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909415386264440833','0','2025-04-08 09:17:57','2025-04-08 01:17:57',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909415645174632449','0','2025-04-08 09:18:59','2025-04-08 01:18:59',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909416095470915585','0','2025-04-08 09:20:47','2025-04-08 01:20:47',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909416766555361282','0','2025-04-08 09:23:27','2025-04-08 01:23:27',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909416858410618881','0','2025-04-08 09:23:48','2025-04-08 01:23:48',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909417103777402882','0','2025-04-08 09:24:47','2025-04-08 01:24:47',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909417386397995010','0','2025-04-08 09:25:54','2025-04-08 01:25:54',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909420850133929986','0','2025-04-08 09:39:40','2025-04-08 01:39:40',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909421506588643330','0','2025-04-08 09:42:17','2025-04-08 01:42:17',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909422767262208002','0','2025-04-08 09:47:17','2025-04-08 01:47:17',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909422804100780034','0','2025-04-08 09:47:26','2025-04-08 01:47:26',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909422943926292481','0','2025-04-08 09:47:59','2025-04-08 01:47:59',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909423759043137537','0','2025-04-08 09:51:14','2025-04-08 01:51:14',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909424048861155330','0','2025-04-08 09:52:23','2025-04-08 01:52:23',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909427696873824257','0','2025-04-08 10:06:53','2025-04-08 02:06:53',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909428445624197122','0','2025-04-08 10:09:51','2025-04-08 02:09:51',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909430786779832322','0','2025-04-08 10:19:09','2025-04-08 02:19:09',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909433413085167618','0','2025-04-08 10:29:36','2025-04-08 02:29:36',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909435200454336514','0','2025-04-08 10:36:42','2025-04-08 02:36:42',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909450699514912770','0','2025-04-08 11:38:17','2025-04-08 03:38:17',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909474273558581250','0','2025-04-08 13:11:57','2025-04-08 05:11:57',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909475365642063873','0','2025-04-08 13:16:18','2025-04-08 05:16:18',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909486529054822402','0','2025-04-08 14:00:39','2025-04-08 06:00:39',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909489014234488833','0','2025-04-08 14:10:32','2025-04-08 06:10:32',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909494718404042753','0','2025-04-08 14:33:12','2025-04-08 06:33:12',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909496224092004353','0','2025-04-08 14:39:11','2025-04-08 06:39:11',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909496404379967489','0','2025-04-08 14:39:54','2025-04-08 06:39:54',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909497426477326337','0','2025-04-08 14:43:57','2025-04-08 06:43:57',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909498542241882113','0','2025-04-08 14:48:23','2025-04-08 06:48:23',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909498944274309121','0','2025-04-08 14:49:59','2025-04-08 06:49:59',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909499415227617281','0','2025-04-08 14:51:52','2025-04-08 06:51:52',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909499520135548929','0','2025-04-08 14:52:17','2025-04-08 06:52:17',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909499813392896002','0','2025-04-08 14:53:26','2025-04-08 06:53:26',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909500103936528385','0','2025-04-08 14:54:36','2025-04-08 06:54:36',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909500164305145858','0','2025-04-08 14:54:50','2025-04-08 06:54:50',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909500257099927554','0','2025-04-08 14:55:12','2025-04-08 06:55:12',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909500297084227585','0','2025-04-08 14:55:22','2025-04-08 06:55:22',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909500317724397570','0','2025-04-08 14:55:27','2025-04-08 06:55:27',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909504734536224769','0','2025-04-08 15:13:00','2025-04-08 07:13:00',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909513502690979842','0','2025-04-08 15:47:50','2025-04-08 07:47:50',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909514803415924737','0','2025-04-08 15:53:01','2025-04-08 07:53:01',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909519339568316417','0','2025-04-08 16:11:02','2025-04-08 08:11:02',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909520686392872961','0','2025-04-08 16:16:23','2025-04-08 08:16:23',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909525357522067457','0','2025-04-08 16:34:57','2025-04-08 08:34:57',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的','tiantian','dasda','1',NULL,NULL),('1909529369793273857','0','2025-04-08 16:50:53','2025-04-08 08:50:53',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909537018232528897','0','2025-04-08 17:21:17','2025-04-08 09:21:17',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909537232079118338','0','2025-04-08 17:22:08','2025-04-08 09:22:08',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909539063131889666','0','2025-04-08 17:29:24','2025-04-11 05:00:02',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的','huitongkuaidi','YT8736186768458','1',NULL,NULL),('1909540322933039105','0','2025-04-08 17:34:25','2025-04-08 09:34:25',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909540511999680513','0','2025-04-08 17:35:10','2025-04-08 09:35:10',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909540681491505154','0','2025-04-08 17:35:50','2025-04-08 09:35:50',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909779974680043522','0','2025-04-09 09:26:42','2025-04-09 01:26:42',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909780068674396161','0','2025-04-09 09:27:05','2025-04-09 01:27:05',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的','tiantian','6666666666','1',NULL,NULL),('1909782134637551618','0','2025-04-09 09:35:17','2025-04-09 01:35:17',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的','tiantian','6666666666','1',NULL,NULL),('1909783564555476993','0','2025-04-09 09:40:58','2025-04-09 01:40:58',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909783615394635778','0','2025-04-09 09:41:10','2025-04-09 01:41:10',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的','tiantian','555555','1',NULL,NULL),('1909785338808983554','0','2025-04-09 09:48:01','2025-04-09 01:48:01',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的','tiantian','44444444','1',NULL,NULL),('1909786875576803329','0','2025-04-09 09:54:07','2025-04-09 01:54:07',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的','tiantian','333333333','1',NULL,NULL),('1909787108289372162','0','2025-04-09 09:55:03','2025-04-09 01:55:03',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的','tiantian','2222222222222','1',NULL,NULL),('1909787615619801090','0','2025-04-09 09:57:04','2025-04-09 01:57:04',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909787659496415233','0','2025-04-09 09:57:14','2025-04-09 01:57:14',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909787723174338561','0','2025-04-09 09:57:30','2025-04-09 01:57:30',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909787789813440514','0','2025-04-09 09:57:45','2025-04-09 01:57:45',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909788402349596673','0','2025-04-09 10:00:11','2025-04-09 02:00:11',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909788462315560962','0','2025-04-09 10:00:26','2025-04-09 02:00:26',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909788600446574594','0','2025-04-09 10:00:59','2025-04-09 02:00:59',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的','tiantian','11111111111111111111111111111','1',NULL,NULL),('1909795012056801282','0','2025-04-09 10:26:27','2025-04-09 02:26:27',NULL,'规划风格化','18333333333','北京市北京市东城区234325',NULL,NULL,NULL,NULL,NULL),('1909795453989642242','0','2025-04-09 10:28:13','2025-04-09 02:28:13',NULL,'规划风格化','18333333333','北京市北京市东城区234325',NULL,NULL,NULL,NULL,NULL),('1909808979487547393','0','2025-04-09 11:21:57','2025-04-09 03:21:57',NULL,'规划风格化','18333333333','北京市北京市东城区234325',NULL,NULL,NULL,NULL,NULL),('1909833404203175937','0','2025-04-09 12:59:01','2025-04-09 04:59:01',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909855580046266370','0','2025-04-09 14:27:08','2025-04-09 06:27:08',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的','tiantian','6666666666','1',NULL,NULL),('1909895314218995713','0','2025-04-09 17:05:01','2025-04-09 09:05:01',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909900840390676482','0','2025-04-09 17:26:59','2025-04-09 09:26:59',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909900926009004033','0','2025-04-09 17:27:19','2025-04-09 09:27:19',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1909903067750649858','0','2025-04-09 17:35:50','2025-04-09 09:35:50',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的','tiantian','123','1',NULL,NULL),('1910136255253106689','0','2025-04-10 09:02:26','2025-04-10 01:02:26',NULL,'桂花鱼','132325232745','江苏省苏州市昆山市杨树路555号',NULL,NULL,NULL,NULL,NULL),('1910137141639565313','0','2025-04-10 09:05:57','2025-04-10 01:05:57',NULL,'桂花鱼','132325232745','江苏省苏州市昆山市杨树路555号',NULL,NULL,NULL,NULL,NULL),('1910137346137051137','0','2025-04-10 09:06:46','2025-04-10 01:06:46',NULL,'桂花鱼','132325232745','江苏省苏州市昆山市杨树路555号',NULL,NULL,NULL,NULL,NULL),('1910159377826066433','0','2025-04-10 10:34:19','2025-04-10 02:34:19',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的','tiantian','1111223543535346','1',NULL,NULL),('1910195231621771266','0','2025-04-10 12:56:47','2025-04-10 04:56:47',NULL,'桂花鱼','132325232745','江苏省苏州市昆山市杨树路555号',NULL,NULL,NULL,NULL,NULL),('1910198872252424193','0','2025-04-10 13:11:15','2025-04-10 05:11:15',NULL,'桂花鱼','132325232745','江苏省苏州市昆山市杨树路555号',NULL,NULL,NULL,NULL,NULL),('1910199595966996482','0','2025-04-10 13:14:08','2025-04-10 05:14:08',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1910211045158608897','0','2025-04-10 13:59:37','2025-04-10 05:59:37',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1910215993250340866','0','2025-04-10 14:19:17','2025-04-10 06:19:17',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1910227635774230530','0','2025-04-10 15:05:33','2025-04-10 07:05:33',NULL,'桂花鱼','132325232745','江苏省苏州市昆山市杨树路555号',NULL,NULL,NULL,NULL,NULL),('1910241347767750657','0','2025-04-10 16:00:02','2025-04-10 08:00:02',NULL,'zhang','1','天津市市辖区河东区dd','tiantian','123','1',NULL,NULL),('1910244440261644289','0','2025-04-10 16:12:19','2025-04-10 08:12:19',NULL,'桂花鱼','132325232745','江苏省苏州市昆山市杨树路555号','tiantian','123512','1',NULL,NULL),('1910264316099416066','0','2025-04-10 17:31:18','2025-04-10 09:31:18',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1910296232953499650','0','2025-04-10 19:38:08','2025-04-10 11:38:08',NULL,'桂花鱼','132325232745','江苏省苏州市昆山市杨树路555号',NULL,NULL,NULL,NULL,NULL),('1910492258448560129','0','2025-04-11 08:37:04','2025-04-11 00:37:04',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1910495149527781378','0','2025-04-11 08:48:33','2025-04-11 00:48:33',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1911253766941986818','0','2025-04-13 11:03:02','2025-04-13 03:03:02',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1911289364813729793','0','2025-04-13 13:24:29','2025-04-13 05:24:29',NULL,'桂花鱼','132325232745','江苏省苏州市昆山市杨树路555号','yunda','464300338874911','1',NULL,NULL),('1911289865773010945','0','2025-04-13 13:26:28','2025-04-13 05:26:28',NULL,'桂花鱼','132325232745','江苏省苏州市昆山市杨树路555号','yunda','464300338874911','1',NULL,NULL),('1911290482096623617','0','2025-04-13 13:28:55','2025-04-13 05:28:55',NULL,'桂花鱼','132325232745','江苏省苏州市昆山市杨树路555号','yunda','464300338874911','1',NULL,NULL),('1911290970099699714','0','2025-04-13 13:30:51','2025-04-13 05:30:51',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的','tiantian','123141151','1',NULL,NULL),('1911291366801166338','0','2025-04-13 13:32:26','2025-04-13 05:32:26',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1911294114296778753','0','2025-04-13 13:43:21','2025-04-13 05:43:21',NULL,'张1','18336336761','天津市市辖区和平区啊实打实大苏打实打实的',NULL,NULL,NULL,NULL,NULL),('1912392808366632962','0','2025-04-16 14:29:10','2025-04-16 06:29:10',NULL,'桂花园','1325683560','北京市市辖区东城区荷花池',NULL,NULL,NULL,NULL,NULL),('1914997890253955074','0','2025-04-23 19:00:50','2025-04-23 11:00:50',NULL,'桂花鱼','132325232745','江苏省苏州市昆山市杨树路555号','huitongkuaidi','23456','1',NULL,NULL);
/*!40000 ALTER TABLE `order_logistics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_logistics_info`
--

DROP TABLE IF EXISTS `order_logistics_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_logistics_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'PK',
  `logistics_id` varchar(32) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '物流id',
  `status` char(2) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '物流状态 1在途中，2派件中，3已签收，4派送失败，5揽收，6退回，7转单，8疑难，9退签，10待清关，11清关中，12已清关，13清关异常',
  `name` varchar(255) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '物流名称',
  `com` varchar(255) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '快递公司代码',
  `number` varchar(255) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '快递单号',
  `logo` varchar(255) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '快递公司logo',
  `list` varchar(2000) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '快递信息',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='物流信息查询表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_logistics_info`
--

LOCK TABLES `order_logistics_info` WRITE;
/*!40000 ALTER TABLE `order_logistics_info` DISABLE KEYS */;
INSERT INTO `order_logistics_info` VALUES (1,'YT8736186768458','3','圆通速递','yuantong','YT8736186768458','http://img.lundear.com/yuantong.png','[{\"time\":\"2025-02-11 17:55:18\",\"status\":\"已签收，签收人凭取货码签收。如有疑问请联系快递员: 18521102536，网点电话：18521803516,0512-81633526，投诉电话: 18521100313。感谢使用圆通速递，期待再次为您服务！\"},{\"time\":\"2025-02-11 13:40:44\",\"status\":\"您好，快件已暂存至昆山珠江御景北门475号店菜鸟驿站，如有疑问请联系18136413727，投诉电话：18521100313。感谢使用圆通速递，期待再次为您服务！\"},{\"time\":\"2025-02-11 07:54:12\",\"status\":\"【江苏省昆山蓬朗】的张兴盛（18521102536）正在派件，（有事先呼我，勿找平台，少一次投诉，多一份感恩）！如有疑问请联系网点:18521803516,0512-81633526，投诉电话:18521100313。[95161和18521号段的上海号码为圆通快递员专属号码，请放心接听]\"},{\"time\":\"2025-02-11 07:54:09\",\"status\":\"您的快件已经到达【江苏省昆山蓬朗】\"},{\"time\":\"2025-02-11 04:02:39\",\"status\":\"您的快件离开【上海转运中心】，已发往【江苏省昆山蓬朗】\"},{\"time\":\"2025-02-11 03:32:36\",\"status\":\"您的快件已经到达【上海转运中心】\"},{\"time\":\"2025-02-09 22:41:05\",\"status\":\"您的快件离开【深圳转运中心】，已发往【上海转运中心】。预计【02月11日】到达【上海市】，因运输距离较远，预计将在【11日晚上】为您更新快件状态，请您放心！\"},{\"time\":\"2025-02-09 22:39:56\",\"status\":\"您的快件已经到达【深圳转运中心】\"},{\"time\":\"2025-02-09 21:43:54\",\"status\":\"您的快件离开【广东省深圳市龙岗区平湖】，已发往【深圳转运中心】\"},{\"time\":\"2025-02-08 08:07:09\",\"status\":\"您的快件在【广东省深圳市龙岗区平湖】已揽收，揽收人: 王小明（15691613295）\"}]'),(2,'1111223543535346',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `order_logistics_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_blob_triggers`
--

DROP TABLE IF EXISTS `qrtz_blob_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_blob_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='Blob类型的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_blob_triggers`
--

LOCK TABLES `qrtz_blob_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_blob_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_blob_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_calendars`
--

DROP TABLE IF EXISTS `qrtz_calendars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_calendars` (
  `sched_name` varchar(120) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`,`calendar_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='日历信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_calendars`
--

LOCK TABLES `qrtz_calendars` WRITE;
/*!40000 ALTER TABLE `qrtz_calendars` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_calendars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_cron_triggers`
--

DROP TABLE IF EXISTS `qrtz_cron_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_cron_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='Cron类型的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_cron_triggers`
--

LOCK TABLES `qrtz_cron_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_cron_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_cron_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_fired_triggers`
--

DROP TABLE IF EXISTS `qrtz_fired_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_fired_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint(20) NOT NULL COMMENT '触发的时间',
  `sched_time` bigint(20) NOT NULL COMMENT '定时器制定的时间',
  `priority` int(11) NOT NULL COMMENT '优先级',
  `state` varchar(16) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`,`entry_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='已触发的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_fired_triggers`
--

LOCK TABLES `qrtz_fired_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_fired_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_fired_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_job_details`
--

DROP TABLE IF EXISTS `qrtz_job_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_job_details` (
  `sched_name` varchar(120) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`job_name`,`job_group`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='任务详细信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_job_details`
--

LOCK TABLES `qrtz_job_details` WRITE;
/*!40000 ALTER TABLE `qrtz_job_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_job_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_locks`
--

DROP TABLE IF EXISTS `qrtz_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_locks` (
  `sched_name` varchar(120) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`,`lock_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='存储的悲观锁信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_locks`
--

LOCK TABLES `qrtz_locks` WRITE;
/*!40000 ALTER TABLE `qrtz_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_paused_trigger_grps`
--

DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_paused_trigger_grps` (
  `sched_name` varchar(120) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`,`trigger_group`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='暂停的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_paused_trigger_grps`
--

LOCK TABLES `qrtz_paused_trigger_grps` WRITE;
/*!40000 ALTER TABLE `qrtz_paused_trigger_grps` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_paused_trigger_grps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_scheduler_state`
--

DROP TABLE IF EXISTS `qrtz_scheduler_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_scheduler_state` (
  `sched_name` varchar(120) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint(20) NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint(20) NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`,`instance_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='调度器状态表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_scheduler_state`
--

LOCK TABLES `qrtz_scheduler_state` WRITE;
/*!40000 ALTER TABLE `qrtz_scheduler_state` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_scheduler_state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_simple_triggers`
--

DROP TABLE IF EXISTS `qrtz_simple_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_simple_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint(20) NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint(20) NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint(20) NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='简单触发器的信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_simple_triggers`
--

LOCK TABLES `qrtz_simple_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_simple_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_simple_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_simprop_triggers`
--

DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_simprop_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int(11) DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int(11) DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint(20) DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint(20) DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='同步机制的行锁表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_simprop_triggers`
--

LOCK TABLES `qrtz_simprop_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_simprop_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_simprop_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_triggers`
--

DROP TABLE IF EXISTS `qrtz_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qrtz_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint(20) DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint(20) DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int(11) DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint(20) NOT NULL COMMENT '开始时间',
  `end_time` bigint(20) DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint(6) DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`) USING BTREE,
  KEY `sched_name` (`sched_name`,`job_name`,`job_group`) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='触发器详细信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_triggers`
--

LOCK TABLES `qrtz_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shopping_cart`
--

DROP TABLE IF EXISTS `shopping_cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shopping_cart` (
  `id` varchar(32) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'PK',
  `del_flag` char(2) COLLATE utf8mb4_croatian_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `user_id` varchar(32) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '用户编号',
  `spu_id` varchar(32) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '商品SPU',
  `quantity` int(11) NOT NULL COMMENT '数量',
  `spu_name` varchar(200) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '加入时的spu名字',
  `add_price` decimal(10,2) DEFAULT NULL COMMENT '加入时价格',
  `pic_url` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '图片',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='购物车';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shopping_cart`
--

LOCK TABLES `shopping_cart` WRITE;
/*!40000 ALTER TABLE `shopping_cart` DISABLE KEYS */;
INSERT INTO `shopping_cart` VALUES ('1353755369452634114','0','2021-01-26 01:23:26','2021-01-25 17:29:11','1352233320682930178','1353738731164561410',1,'iPhone12白色',4999.00,NULL),('1354094384559210498','0','2021-01-26 23:50:33','2021-01-26 15:50:33','1352572935968165889','1353738731164561410',1,'iPhone12白色',4999.00,'http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/category-9.png'),('1355427342960320514','0','2021-01-30 16:07:16','2021-01-30 08:07:16','1355406809988345857','1353738731164561410',1,'Apple iPhone',6000.00,'http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/10952adc-cad0-4c53-8762-9906d1dde220.jpg'),('1357249438573252609','0','2021-02-04 16:47:37','2021-02-04 08:47:37','1356171782972882945','1355440649314263041',1,'HUAWEI Mate 40 Pro+',8999.00,'http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/goods-5.png'),('1357249497834573826','0','2021-02-04 16:47:51','2021-02-04 08:47:51','1356171782972882945','1355412081553190914',1,'HUAWEI P40 Pro+',0.10,'http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/goods-7.png'),('1357673715054202882','0','2021-02-05 20:53:31','2021-02-05 12:53:31','1354473059078176770','1353738731164561410',1,'iPhone 12 Pro',8499.00,'http://joolun-open.oss-cn-zhangjiakou.aliyuncs.com/goods-4.png');
/*!40000 ALTER TABLE `shopping_cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `spu_try_on_img_url`
--

DROP TABLE IF EXISTS `spu_try_on_img_url`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spu_try_on_img_url` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `img_url` varchar(255) NOT NULL COMMENT '图片地址',
  `goods_spu_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '商品SPU ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_goods_spu_id` (`goods_spu_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='商品试戴图片表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spu_try_on_img_url`
--

LOCK TABLES `spu_try_on_img_url` WRITE;
/*!40000 ALTER TABLE `spu_try_on_img_url` DISABLE KEYS */;
INSERT INTO `spu_try_on_img_url` VALUES (1,'/profile/upload/2025/04/07/bls_20250407111523A002.jpg','1900363838747389953','2025-04-10 14:17:25','2025-04-10 06:17:25','0');
/*!40000 ALTER TABLE `spu_try_on_img_url` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_config` (
  `config_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) COLLATE utf8mb4_croatian_ci DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='参数配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
INSERT INTO `sys_config` VALUES (1,'主框架页-默认皮肤样式名称','sys.index.skinName','skin-blue','Y','admin','2024-09-11 09:31:32','',NULL,'蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow'),(2,'用户管理-账号初始密码','sys.user.initPassword','123456','Y','admin','2024-09-11 09:31:32','',NULL,'初始化密码 123456'),(3,'主框架页-侧边栏主题','sys.index.sideTheme','theme-dark','Y','admin','2024-09-11 09:31:32','',NULL,'深色主题theme-dark，浅色主题theme-light'),(4,'账号自助-验证码开关','sys.account.captchaEnabled','true','Y','admin','2024-09-11 09:31:32','',NULL,'是否开启验证码功能（true开启，false关闭）'),(5,'账号自助-是否开启用户注册功能','sys.account.registerUser','false','Y','admin','2024-09-11 09:31:32','',NULL,'是否开启注册用户功能（true开启，false关闭）'),(6,'用户登录-黑名单列表','sys.login.blackIPList','','Y','admin','2024-09-11 09:31:32','',NULL,'设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dept`
--

DROP TABLE IF EXISTS `sys_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_dept` (
  `dept_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint(20) DEFAULT '0' COMMENT '父部门id',
  `ancestors` varchar(50) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '部门名称',
  `order_num` int(11) DEFAULT '0' COMMENT '显示顺序',
  `leader` varchar(20) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '邮箱',
  `status` char(1) COLLATE utf8mb4_croatian_ci DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) COLLATE utf8mb4_croatian_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='部门表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dept`
--

LOCK TABLES `sys_dept` WRITE;
/*!40000 ALTER TABLE `sys_dept` DISABLE KEYS */;
INSERT INTO `sys_dept` VALUES (100,0,'0','若依科技',0,'若依','15888888888','ry@qq.com','0','0','admin','2024-09-11 09:31:30','',NULL),(101,100,'0,100','深圳总公司',1,'若依','15888888888','ry@qq.com','0','0','admin','2024-09-11 09:31:30','',NULL),(102,100,'0,100','长沙分公司',2,'若依','15888888888','ry@qq.com','0','0','admin','2024-09-11 09:31:30','',NULL),(103,101,'0,100,101','研发部门',1,'若依','15888888888','ry@qq.com','0','0','admin','2024-09-11 09:31:30','',NULL),(104,101,'0,100,101','市场部门',2,'若依','15888888888','ry@qq.com','0','0','admin','2024-09-11 09:31:30','',NULL),(105,101,'0,100,101','测试部门',3,'若依','15888888888','ry@qq.com','0','0','admin','2024-09-11 09:31:30','',NULL),(106,101,'0,100,101','财务部门',4,'若依','15888888888','ry@qq.com','0','0','admin','2024-09-11 09:31:30','',NULL),(107,101,'0,100,101','运维部门',5,'若依','15888888888','ry@qq.com','0','0','admin','2024-09-11 09:31:30','',NULL),(108,102,'0,100,102','市场部门',1,'若依','15888888888','ry@qq.com','0','0','admin','2024-09-11 09:31:30','',NULL),(109,102,'0,100,102','财务部门',2,'若依','15888888888','ry@qq.com','0','0','admin','2024-09-11 09:31:30','',NULL);
/*!40000 ALTER TABLE `sys_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_data`
--

DROP TABLE IF EXISTS `sys_dict_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_dict_data` (
  `dict_code` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int(11) DEFAULT '0' COMMENT '字典排序',
  `dict_label` varchar(100) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) COLLATE utf8mb4_croatian_ci DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) COLLATE utf8mb4_croatian_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='字典数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_data`
--

LOCK TABLES `sys_dict_data` WRITE;
/*!40000 ALTER TABLE `sys_dict_data` DISABLE KEYS */;
INSERT INTO `sys_dict_data` VALUES (1,1,'男','0','sys_user_sex','','','Y','0','admin','2024-09-11 09:31:32','',NULL,'性别男'),(2,2,'女','1','sys_user_sex','','','N','0','admin','2024-09-11 09:31:32','',NULL,'性别女'),(3,3,'未知','2','sys_user_sex','','','N','0','admin','2024-09-11 09:31:32','',NULL,'性别未知'),(4,1,'显示','0','sys_show_hide','','primary','Y','0','admin','2024-09-11 09:31:32','',NULL,'显示菜单'),(5,2,'隐藏','1','sys_show_hide','','danger','N','0','admin','2024-09-11 09:31:32','',NULL,'隐藏菜单'),(6,1,'正常','0','sys_normal_disable','','primary','Y','0','admin','2024-09-11 09:31:32','',NULL,'正常状态'),(7,2,'停用','1','sys_normal_disable','','danger','N','0','admin','2024-09-11 09:31:32','',NULL,'停用状态'),(8,1,'正常','0','sys_job_status','','primary','Y','0','admin','2024-09-11 09:31:32','',NULL,'正常状态'),(9,2,'暂停','1','sys_job_status','','danger','N','0','admin','2024-09-11 09:31:32','',NULL,'停用状态'),(10,1,'默认','DEFAULT','sys_job_group','','','Y','0','admin','2024-09-11 09:31:32','',NULL,'默认分组'),(11,2,'系统','SYSTEM','sys_job_group','','','N','0','admin','2024-09-11 09:31:32','',NULL,'系统分组'),(12,1,'是','Y','sys_yes_no','','primary','Y','0','admin','2024-09-11 09:31:32','',NULL,'系统默认是'),(13,2,'否','N','sys_yes_no','','danger','N','0','admin','2024-09-11 09:31:32','',NULL,'系统默认否'),(14,1,'通知','1','sys_notice_type','','warning','Y','0','admin','2024-09-11 09:31:32','',NULL,'通知'),(15,2,'公告','2','sys_notice_type','','success','N','0','admin','2024-09-11 09:31:32','',NULL,'公告'),(16,1,'正常','0','sys_notice_status','','primary','Y','0','admin','2024-09-11 09:31:32','',NULL,'正常状态'),(17,2,'关闭','1','sys_notice_status','','danger','N','0','admin','2024-09-11 09:31:32','',NULL,'关闭状态'),(18,99,'其他','0','sys_oper_type','','info','N','0','admin','2024-09-11 09:31:32','',NULL,'其他操作'),(19,1,'新增','1','sys_oper_type','','info','N','0','admin','2024-09-11 09:31:32','',NULL,'新增操作'),(20,2,'修改','2','sys_oper_type','','info','N','0','admin','2024-09-11 09:31:32','',NULL,'修改操作'),(21,3,'删除','3','sys_oper_type','','danger','N','0','admin','2024-09-11 09:31:32','',NULL,'删除操作'),(22,4,'授权','4','sys_oper_type','','primary','N','0','admin','2024-09-11 09:31:32','',NULL,'授权操作'),(23,5,'导出','5','sys_oper_type','','warning','N','0','admin','2024-09-11 09:31:32','',NULL,'导出操作'),(24,6,'导入','6','sys_oper_type','','warning','N','0','admin','2024-09-11 09:31:32','',NULL,'导入操作'),(25,7,'强退','7','sys_oper_type','','danger','N','0','admin','2024-09-11 09:31:32','',NULL,'强退操作'),(26,8,'生成代码','8','sys_oper_type','','warning','N','0','admin','2024-09-11 09:31:32','',NULL,'生成操作'),(27,9,'清空数据','9','sys_oper_type','','danger','N','0','admin','2024-09-11 09:31:32','',NULL,'清空操作'),(28,1,'成功','0','sys_common_status','','primary','N','0','admin','2024-09-11 09:31:32','',NULL,'正常状态'),(29,2,'失败','1','sys_common_status','','danger','N','0','admin','2024-09-11 09:31:32','',NULL,'停用状态'),(100,1,'进口','1','spu_tag_type',NULL,'default','N','0','admin','2025-03-19 09:29:58','',NULL,NULL),(101,2,'国产','2','spu_tag_type',NULL,'default','N','0','admin','2025-03-19 09:30:11','',NULL,NULL),(102,13,'半框','13','spu_tag_type',NULL,'default','N','0','admin','2025-03-19 09:30:32','',NULL,NULL),(103,12,'全框','12','spu_tag_type',NULL,'default','N','0','admin','2025-03-19 09:30:52','',NULL,NULL);
/*!40000 ALTER TABLE `sys_dict_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_type`
--

DROP TABLE IF EXISTS `sys_dict_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_dict_type` (
  `dict_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '字典类型',
  `status` char(1) COLLATE utf8mb4_croatian_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE KEY `dict_type` (`dict_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='字典类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_type`
--

LOCK TABLES `sys_dict_type` WRITE;
/*!40000 ALTER TABLE `sys_dict_type` DISABLE KEYS */;
INSERT INTO `sys_dict_type` VALUES (1,'用户性别','sys_user_sex','0','admin','2024-09-11 09:31:32','',NULL,'用户性别列表'),(2,'菜单状态','sys_show_hide','0','admin','2024-09-11 09:31:32','',NULL,'菜单状态列表'),(3,'系统开关','sys_normal_disable','0','admin','2024-09-11 09:31:32','',NULL,'系统开关列表'),(4,'任务状态','sys_job_status','0','admin','2024-09-11 09:31:32','',NULL,'任务状态列表'),(5,'任务分组','sys_job_group','0','admin','2024-09-11 09:31:32','',NULL,'任务分组列表'),(6,'系统是否','sys_yes_no','0','admin','2024-09-11 09:31:32','',NULL,'系统是否列表'),(7,'通知类型','sys_notice_type','0','admin','2024-09-11 09:31:32','',NULL,'通知类型列表'),(8,'通知状态','sys_notice_status','0','admin','2024-09-11 09:31:32','',NULL,'通知状态列表'),(9,'操作类型','sys_oper_type','0','admin','2024-09-11 09:31:32','',NULL,'操作类型列表'),(10,'系统状态','sys_common_status','0','admin','2024-09-11 09:31:32','',NULL,'登录状态列表'),(100,'商品标签','spu_tag_type','0','admin','2025-03-19 09:29:34','',NULL,NULL);
/*!40000 ALTER TABLE `sys_dict_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job`
--

DROP TABLE IF EXISTS `sys_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_job` (
  `job_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) COLLATE utf8mb4_croatian_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) COLLATE utf8mb4_croatian_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) COLLATE utf8mb4_croatian_ci DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) COLLATE utf8mb4_croatian_ci DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) COLLATE utf8mb4_croatian_ci DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`,`job_name`,`job_group`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='定时任务调度表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job`
--

LOCK TABLES `sys_job` WRITE;
/*!40000 ALTER TABLE `sys_job` DISABLE KEYS */;
INSERT INTO `sys_job` VALUES (1,'系统默认（无参）','DEFAULT','ryTask.ryNoParams','0/10 * * * * ?','3','1','1','admin','2024-09-11 09:31:32','',NULL,''),(2,'系统默认（有参）','DEFAULT','ryTask.ryParams(\'ry\')','0/15 * * * * ?','3','1','1','admin','2024-09-11 09:31:32','',NULL,''),(3,'系统默认（多参）','DEFAULT','ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)','0/20 * * * * ?','3','1','1','admin','2024-09-11 09:31:32','',NULL,'');
/*!40000 ALTER TABLE `sys_job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job_log`
--

DROP TABLE IF EXISTS `sys_job_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_job_log` (
  `job_log_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '日志信息',
  `status` char(1) COLLATE utf8mb4_croatian_ci DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '异常信息',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='定时任务调度日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job_log`
--

LOCK TABLES `sys_job_log` WRITE;
/*!40000 ALTER TABLE `sys_job_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_job_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_logininfor`
--

DROP TABLE IF EXISTS `sys_logininfor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_logininfor` (
  `info_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '操作系统',
  `status` char(1) COLLATE utf8mb4_croatian_ci DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '提示消息',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  KEY `idx_sys_logininfor_s` (`status`) USING BTREE,
  KEY `idx_sys_logininfor_lt` (`login_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=147 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='系统访问记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_logininfor`
--

LOCK TABLES `sys_logininfor` WRITE;
/*!40000 ALTER TABLE `sys_logininfor` DISABLE KEYS */;
INSERT INTO `sys_logininfor` VALUES (100,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2024-09-11 09:36:42'),(101,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2024-09-11 10:06:16'),(102,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2024-09-11 10:19:10'),(103,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2024-09-11 15:58:28'),(104,'test','127.0.0.1','内网IP','Chrome 13','Windows 10','1','用户不存在/密码错误','2024-09-11 16:13:48'),(105,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2024-09-11 16:14:04'),(106,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2024-09-11 16:23:14'),(107,'test','127.0.0.1','内网IP','Chrome 13','Windows 10','1','用户不存在/密码错误','2025-03-12 13:12:57'),(108,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','用户不存在/密码错误','2025-03-12 13:13:11'),(109,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','用户不存在/密码错误','2025-03-12 13:13:22'),(110,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-03-12 13:14:23'),(111,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-03-14 09:41:46'),(112,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-03-14 11:48:26'),(113,'test','127.0.0.1','内网IP','Chrome 13','Windows 10','1','验证码已失效','2025-03-14 13:24:16'),(114,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-03-14 13:24:35'),(115,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-03-14 14:11:26'),(116,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-03-14 15:44:20'),(117,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-03-17 13:56:09'),(118,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','用户不存在/密码错误','2025-03-17 14:01:56'),(119,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','用户不存在/密码错误','2025-03-17 14:02:06'),(120,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-03-17 14:02:25'),(121,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-03-18 16:22:47'),(122,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-03-19 09:06:03'),(123,'admin','127.0.0.1','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-03-19 10:05:05'),(124,'admin','192.168.0.69','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-03-19 10:33:47'),(125,'test','127.0.0.1','内网IP','Chrome 13','Windows 10','1','用户不存在/密码错误','2025-03-19 10:53:25'),(126,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-03-19 10:53:42'),(127,'admin','192.168.0.69','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-03-19 12:53:14'),(128,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','用户不存在/密码错误','2025-03-19 13:18:51'),(129,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','1','用户不存在/密码错误','2025-03-19 13:19:00'),(130,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-03-19 13:19:12'),(131,'admin','192.168.0.69','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-03-19 15:29:11'),(132,'test','192.168.0.69','内网IP','Chrome 13','Mac OS X','1','用户不存在/密码错误','2025-03-19 15:59:10'),(133,'admin','192.168.0.69','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-03-19 15:59:19'),(134,'admin','192.168.0.69','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-03-19 17:03:12'),(135,'admin','127.0.0.1','内网IP','Chrome 13','Windows 10','0','登录成功','2025-03-21 11:03:28'),(136,'admin','192.168.0.69','内网IP','Chrome 13','Mac OS X','0','登录成功','2025-03-21 11:12:18'),(137,'admin','192.168.0.35','内网IP','Chrome 13','Windows 10','0','登录成功','2025-03-24 14:18:24'),(138,'test','192.168.0.35','内网IP','Chrome 13','Windows 10','1','用户不存在/密码错误','2025-03-24 15:13:38'),(139,'admin','192.168.0.35','内网IP','Chrome 13','Windows 10','0','登录成功','2025-03-24 15:13:47'),(140,'admin','192.168.0.35','内网IP','Chrome 13','Windows 10','0','登录成功','2025-03-24 15:24:15'),(141,'admin','192.168.0.35','内网IP','Chrome 13','Windows 10','0','登录成功','2025-03-24 16:00:32'),(142,'admin','192.168.0.35','内网IP','Chrome 13','Windows 10','1','验证码错误','2025-03-27 10:57:21'),(143,'admin','192.168.0.35','内网IP','Chrome 13','Windows 10','1','验证码错误','2025-03-27 10:57:25'),(144,'admin','192.168.0.35','内网IP','Chrome 13','Windows 10','1','验证码错误','2025-03-27 10:57:29'),(145,'admin','192.168.0.35','内网IP','Chrome 13','Windows 10','0','登录成功','2025-03-27 10:57:38'),(146,'admin','127.0.0.1','内网IP','Chrome 10','Windows 10','0','登录成功','2025-04-13 14:07:13');
/*!40000 ALTER TABLE `sys_logininfor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_menu`
--

DROP TABLE IF EXISTS `sys_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_menu` (
  `menu_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint(20) DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int(11) DEFAULT '0' COMMENT '显示顺序',
  `path` varchar(200) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '路由名称',
  `is_frame` int(11) DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `is_cache` int(11) DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) COLLATE utf8mb4_croatian_ci DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) COLLATE utf8mb4_croatian_ci DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) COLLATE utf8mb4_croatian_ci DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2060 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='菜单权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu`
--

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` VALUES (1,'系统管理',0,1,'system',NULL,'','',1,0,'M','0','0','','system','admin','2024-09-11 09:31:31','',NULL,'系统管理目录'),(2,'系统监控',0,2,'monitor',NULL,'','',1,0,'M','0','0','','monitor','admin','2024-09-11 09:31:31','',NULL,'系统监控目录'),(3,'系统工具',0,3,'tool',NULL,'','',1,0,'M','0','0','','tool','admin','2024-09-11 09:31:31','',NULL,'系统工具目录'),(4,'公众号管理',0,4,'wxmp',NULL,'','',1,0,'M','0','0','','wechat','admin','2024-09-11 09:31:31','admin','2025-03-14 13:36:08','公众号管理'),(100,'用户管理',1,1,'user','system/user/index','','',1,0,'C','0','0','system:user:list','user','admin','2024-09-11 09:31:31','',NULL,'用户管理菜单'),(101,'角色管理',1,2,'role','system/role/index','','',1,0,'C','0','0','system:role:list','peoples','admin','2024-09-11 09:31:31','',NULL,'角色管理菜单'),(102,'菜单管理',1,3,'menu','system/menu/index','','',1,0,'C','0','0','system:menu:list','tree-table','admin','2024-09-11 09:31:31','',NULL,'菜单管理菜单'),(103,'部门管理',1,4,'dept','system/dept/index','','',1,0,'C','0','0','system:dept:list','tree','admin','2024-09-11 09:31:31','',NULL,'部门管理菜单'),(104,'岗位管理',1,5,'post','system/post/index','','',1,0,'C','0','0','system:post:list','post','admin','2024-09-11 09:31:31','',NULL,'岗位管理菜单'),(105,'字典管理',1,6,'dict','system/dict/index','','',1,0,'C','0','0','system:dict:list','dict','admin','2024-09-11 09:31:31','',NULL,'字典管理菜单'),(106,'参数设置',1,7,'config','system/config/index','','',1,0,'C','0','0','system:config:list','edit','admin','2024-09-11 09:31:31','',NULL,'参数设置菜单'),(107,'通知公告',1,8,'notice','system/notice/index','','',1,0,'C','0','0','system:notice:list','message','admin','2024-09-11 09:31:31','',NULL,'通知公告菜单'),(108,'日志管理',1,9,'log','','','',1,0,'M','0','0','','log','admin','2024-09-11 09:31:31','',NULL,'日志管理菜单'),(109,'在线用户',2,1,'online','monitor/online/index','','',1,0,'C','0','0','monitor:online:list','online','admin','2024-09-11 09:31:31','',NULL,'在线用户菜单'),(110,'定时任务',2,2,'job','monitor/job/index','','',1,0,'C','0','0','monitor:job:list','job','admin','2024-09-11 09:31:31','',NULL,'定时任务菜单'),(111,'数据监控',2,3,'druid','monitor/druid/index','','',1,0,'C','0','0','monitor:druid:list','druid','admin','2024-09-11 09:31:31','',NULL,'数据监控菜单'),(112,'服务监控',2,4,'server','monitor/server/index','','',1,0,'C','0','0','monitor:server:list','server','admin','2024-09-11 09:31:31','',NULL,'服务监控菜单'),(113,'缓存监控',2,5,'cache','monitor/cache/index','','',1,0,'C','0','0','monitor:cache:list','redis','admin','2024-09-11 09:31:31','',NULL,'缓存监控菜单'),(114,'缓存列表',2,6,'cacheList','monitor/cache/list','','',1,0,'C','0','0','monitor:cache:list','redis-list','admin','2024-09-11 09:31:31','',NULL,'缓存列表菜单'),(115,'表单构建',3,1,'build','tool/build/index','','',1,0,'C','0','0','tool:build:list','build','admin','2024-09-11 09:31:31','',NULL,'表单构建菜单'),(116,'代码生成',3,2,'gen','tool/gen/index','','',1,0,'C','0','0','tool:gen:list','code','admin','2024-09-11 09:31:31','',NULL,'代码生成菜单'),(117,'系统接口',3,3,'swagger','tool/swagger/index','','',1,0,'C','0','0','tool:swagger:list','swagger','admin','2024-09-11 09:31:31','',NULL,'系统接口菜单'),(500,'操作日志',108,1,'operlog','monitor/operlog/index','','',1,0,'C','0','0','monitor:operlog:list','form','admin','2024-09-11 09:31:31','',NULL,'操作日志菜单'),(501,'登录日志',108,2,'logininfor','monitor/logininfor/index','','',1,0,'C','0','0','monitor:logininfor:list','logininfor','admin','2024-09-11 09:31:31','',NULL,'登录日志菜单'),(1000,'用户查询',100,1,'','','','',1,0,'F','0','0','system:user:query','#','admin','2024-09-11 09:31:31','',NULL,''),(1001,'用户新增',100,2,'','','','',1,0,'F','0','0','system:user:add','#','admin','2024-09-11 09:31:31','',NULL,''),(1002,'用户修改',100,3,'','','','',1,0,'F','0','0','system:user:edit','#','admin','2024-09-11 09:31:31','',NULL,''),(1003,'用户删除',100,4,'','','','',1,0,'F','0','0','system:user:remove','#','admin','2024-09-11 09:31:31','',NULL,''),(1004,'用户导出',100,5,'','','','',1,0,'F','0','0','system:user:export','#','admin','2024-09-11 09:31:31','',NULL,''),(1005,'用户导入',100,6,'','','','',1,0,'F','0','0','system:user:import','#','admin','2024-09-11 09:31:31','',NULL,''),(1006,'重置密码',100,7,'','','','',1,0,'F','0','0','system:user:resetPwd','#','admin','2024-09-11 09:31:31','',NULL,''),(1007,'角色查询',101,1,'','','','',1,0,'F','0','0','system:role:query','#','admin','2024-09-11 09:31:31','',NULL,''),(1008,'角色新增',101,2,'','','','',1,0,'F','0','0','system:role:add','#','admin','2024-09-11 09:31:31','',NULL,''),(1009,'角色修改',101,3,'','','','',1,0,'F','0','0','system:role:edit','#','admin','2024-09-11 09:31:31','',NULL,''),(1010,'角色删除',101,4,'','','','',1,0,'F','0','0','system:role:remove','#','admin','2024-09-11 09:31:31','',NULL,''),(1011,'角色导出',101,5,'','','','',1,0,'F','0','0','system:role:export','#','admin','2024-09-11 09:31:31','',NULL,''),(1012,'菜单查询',102,1,'','','','',1,0,'F','0','0','system:menu:query','#','admin','2024-09-11 09:31:31','',NULL,''),(1013,'菜单新增',102,2,'','','','',1,0,'F','0','0','system:menu:add','#','admin','2024-09-11 09:31:31','',NULL,''),(1014,'菜单修改',102,3,'','','','',1,0,'F','0','0','system:menu:edit','#','admin','2024-09-11 09:31:31','',NULL,''),(1015,'菜单删除',102,4,'','','','',1,0,'F','0','0','system:menu:remove','#','admin','2024-09-11 09:31:31','',NULL,''),(1016,'部门查询',103,1,'','','','',1,0,'F','0','0','system:dept:query','#','admin','2024-09-11 09:31:31','',NULL,''),(1017,'部门新增',103,2,'','','','',1,0,'F','0','0','system:dept:add','#','admin','2024-09-11 09:31:31','',NULL,''),(1018,'部门修改',103,3,'','','','',1,0,'F','0','0','system:dept:edit','#','admin','2024-09-11 09:31:31','',NULL,''),(1019,'部门删除',103,4,'','','','',1,0,'F','0','0','system:dept:remove','#','admin','2024-09-11 09:31:31','',NULL,''),(1020,'岗位查询',104,1,'','','','',1,0,'F','0','0','system:post:query','#','admin','2024-09-11 09:31:31','',NULL,''),(1021,'岗位新增',104,2,'','','','',1,0,'F','0','0','system:post:add','#','admin','2024-09-11 09:31:31','',NULL,''),(1022,'岗位修改',104,3,'','','','',1,0,'F','0','0','system:post:edit','#','admin','2024-09-11 09:31:31','',NULL,''),(1023,'岗位删除',104,4,'','','','',1,0,'F','0','0','system:post:remove','#','admin','2024-09-11 09:31:31','',NULL,''),(1024,'岗位导出',104,5,'','','','',1,0,'F','0','0','system:post:export','#','admin','2024-09-11 09:31:31','',NULL,''),(1025,'字典查询',105,1,'#','','','',1,0,'F','0','0','system:dict:query','#','admin','2024-09-11 09:31:31','',NULL,''),(1026,'字典新增',105,2,'#','','','',1,0,'F','0','0','system:dict:add','#','admin','2024-09-11 09:31:31','',NULL,''),(1027,'字典修改',105,3,'#','','','',1,0,'F','0','0','system:dict:edit','#','admin','2024-09-11 09:31:31','',NULL,''),(1028,'字典删除',105,4,'#','','','',1,0,'F','0','0','system:dict:remove','#','admin','2024-09-11 09:31:31','',NULL,''),(1029,'字典导出',105,5,'#','','','',1,0,'F','0','0','system:dict:export','#','admin','2024-09-11 09:31:31','',NULL,''),(1030,'参数查询',106,1,'#','','','',1,0,'F','0','0','system:config:query','#','admin','2024-09-11 09:31:31','',NULL,''),(1031,'参数新增',106,2,'#','','','',1,0,'F','0','0','system:config:add','#','admin','2024-09-11 09:31:31','',NULL,''),(1032,'参数修改',106,3,'#','','','',1,0,'F','0','0','system:config:edit','#','admin','2024-09-11 09:31:31','',NULL,''),(1033,'参数删除',106,4,'#','','','',1,0,'F','0','0','system:config:remove','#','admin','2024-09-11 09:31:31','',NULL,''),(1034,'参数导出',106,5,'#','','','',1,0,'F','0','0','system:config:export','#','admin','2024-09-11 09:31:31','',NULL,''),(1035,'公告查询',107,1,'#','','','',1,0,'F','0','0','system:notice:query','#','admin','2024-09-11 09:31:31','',NULL,''),(1036,'公告新增',107,2,'#','','','',1,0,'F','0','0','system:notice:add','#','admin','2024-09-11 09:31:31','',NULL,''),(1037,'公告修改',107,3,'#','','','',1,0,'F','0','0','system:notice:edit','#','admin','2024-09-11 09:31:31','',NULL,''),(1038,'公告删除',107,4,'#','','','',1,0,'F','0','0','system:notice:remove','#','admin','2024-09-11 09:31:31','',NULL,''),(1039,'操作查询',500,1,'#','','','',1,0,'F','0','0','monitor:operlog:query','#','admin','2024-09-11 09:31:31','',NULL,''),(1040,'操作删除',500,2,'#','','','',1,0,'F','0','0','monitor:operlog:remove','#','admin','2024-09-11 09:31:31','',NULL,''),(1041,'日志导出',500,3,'#','','','',1,0,'F','0','0','monitor:operlog:export','#','admin','2024-09-11 09:31:31','',NULL,''),(1042,'登录查询',501,1,'#','','','',1,0,'F','0','0','monitor:logininfor:query','#','admin','2024-09-11 09:31:31','',NULL,''),(1043,'登录删除',501,2,'#','','','',1,0,'F','0','0','monitor:logininfor:remove','#','admin','2024-09-11 09:31:31','',NULL,''),(1044,'日志导出',501,3,'#','','','',1,0,'F','0','0','monitor:logininfor:export','#','admin','2024-09-11 09:31:31','',NULL,''),(1045,'账户解锁',501,4,'#','','','',1,0,'F','0','0','monitor:logininfor:unlock','#','admin','2024-09-11 09:31:31','',NULL,''),(1046,'在线查询',109,1,'#','','','',1,0,'F','0','0','monitor:online:query','#','admin','2024-09-11 09:31:31','',NULL,''),(1047,'批量强退',109,2,'#','','','',1,0,'F','0','0','monitor:online:batchLogout','#','admin','2024-09-11 09:31:31','',NULL,''),(1048,'单条强退',109,3,'#','','','',1,0,'F','0','0','monitor:online:forceLogout','#','admin','2024-09-11 09:31:31','',NULL,''),(1049,'任务查询',110,1,'#','','','',1,0,'F','0','0','monitor:job:query','#','admin','2024-09-11 09:31:31','',NULL,''),(1050,'任务新增',110,2,'#','','','',1,0,'F','0','0','monitor:job:add','#','admin','2024-09-11 09:31:31','',NULL,''),(1051,'任务修改',110,3,'#','','','',1,0,'F','0','0','monitor:job:edit','#','admin','2024-09-11 09:31:31','',NULL,''),(1052,'任务删除',110,4,'#','','','',1,0,'F','0','0','monitor:job:remove','#','admin','2024-09-11 09:31:31','',NULL,''),(1053,'状态修改',110,5,'#','','','',1,0,'F','0','0','monitor:job:changeStatus','#','admin','2024-09-11 09:31:31','',NULL,''),(1054,'任务导出',110,6,'#','','','',1,0,'F','0','0','monitor:job:export','#','admin','2024-09-11 09:31:31','',NULL,''),(1055,'生成查询',116,1,'#','','','',1,0,'F','0','0','tool:gen:query','#','admin','2024-09-11 09:31:31','',NULL,''),(1056,'生成修改',116,2,'#','','','',1,0,'F','0','0','tool:gen:edit','#','admin','2024-09-11 09:31:31','',NULL,''),(1057,'生成删除',116,3,'#','','','',1,0,'F','0','0','tool:gen:remove','#','admin','2024-09-11 09:31:31','',NULL,''),(1058,'导入代码',116,4,'#','','','',1,0,'F','0','0','tool:gen:import','#','admin','2024-09-11 09:31:31','',NULL,''),(1059,'预览代码',116,5,'#','','','',1,0,'F','0','0','tool:gen:preview','#','admin','2024-09-11 09:31:31','',NULL,''),(1060,'生成代码',116,6,'#','','','',1,0,'F','0','0','tool:gen:code','#','admin','2024-09-11 09:31:31','',NULL,''),(2000,'用户标签',4,10,'wxusertags','wxmp/wxusertags/index',NULL,'',1,0,'C','0','0','wxmp:wxusertags:list','tab','admin','2020-03-03 10:47:36','admin','2020-03-03 20:17:50',''),(2001,'修改标签',2000,10,'',NULL,NULL,'',1,0,'F','1','0','wxmp:wxusertags:edit','#','admin','2020-03-03 11:16:13','',NULL,''),(2002,'公众号用户',4,20,'wxuser','wxmp/wxuser/index',NULL,'',1,0,'C','0','0','wxmp:wxuser:index','peoples','admin','2020-03-04 10:13:30','',NULL,''),(2003,'用户消息',4,30,'wxmsg','wxmp/wxmsg/index',NULL,'',1,0,'C','0','0','wxmp:wxmsg:index','clipboard','admin','2020-03-04 10:15:47','',NULL,''),(2004,'素材管理',4,40,'wxmaterial','wxmp/wxmaterial/index',NULL,'',1,0,'C','0','0','wxmp:wxmaterial:index','example','admin','2020-03-04 10:17:21','admin','2020-03-05 21:31:33',''),(2005,'自定义菜单',4,50,'wxmenu','wxmp/wxmenu/detail',NULL,'',1,0,'C','0','0','wxmp:wxmenu:get','cascader','admin','2020-03-04 10:18:02','admin','2020-03-04 10:29:20',''),(2006,'消息自动回复',4,60,'wxautoreply','wxmp/wxautoreply/index',NULL,'',1,0,'C','0','0','wxmp:wxautoreply:index','dashboard','admin','2020-03-04 10:18:53','',NULL,''),(2007,'数据统计',4,70,'wxsummary','wxmp/wxsummary/index',NULL,'',1,0,'C','0','0',NULL,'druid','admin','2020-03-04 10:19:53','',NULL,''),(2008,'用户标签删除',2000,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxusertags:del','#','admin','2020-03-04 17:08:10','',NULL,''),(2009,'用户标签新增',2000,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxusertags:add','#','admin','2020-03-04 17:08:42','',NULL,''),(2010,'公众号用户新增',2002,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxuser:add','#','admin','2020-03-04 17:15:01','admin','2020-03-04 17:16:59',''),(2011,'公众号用户修改',2002,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxuser:edit','#','admin','2020-03-04 17:16:17','admin','2020-03-04 17:17:09',''),(2012,'公众号用户打标签',2002,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxuser:tagging','#','admin','2020-03-04 17:16:41','',NULL,''),(2013,'公众号用户备注修改',2002,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxuser:edit:remark','#','admin','2020-03-04 17:17:43','',NULL,''),(2014,'公众号用户同步',2002,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxuser:synchro','#','admin','2020-03-04 17:18:09','',NULL,''),(2015,'公众号用户删除',2002,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxuser:del','#','admin','2020-03-04 17:18:31','',NULL,''),(2016,'公众号用户详情',2002,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxuser:get','#','admin','2020-03-04 17:18:55','',NULL,''),(2017,'用户消息新增',2003,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxmsg:add','#','admin','2020-03-04 17:19:24','',NULL,''),(2018,'用户消息修改',2003,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxmsg:edit','#','admin','2020-03-04 17:19:45','',NULL,''),(2019,'用户消息删除',2003,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxmsg:del','#','admin','2020-03-04 17:20:03','',NULL,''),(2020,'用户消息详情',2003,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxmsg:get','#','admin','2020-03-04 17:20:21','',NULL,''),(2021,'素材新增',2004,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxmaterial:add','#','admin','2020-03-04 17:20:43','',NULL,''),(2022,'素材修改',2004,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxmaterial:edit','#','admin','2020-03-04 17:21:03','',NULL,''),(2023,'素材删除',2004,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxmaterial:del','#','admin','2020-03-04 17:21:24','',NULL,''),(2024,'素材详情',2004,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxmaterial:get','#','admin','2020-03-04 17:21:43','',NULL,''),(2025,'自定义菜单发布',2005,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxmenu:add','#','admin','2020-03-04 17:22:12','',NULL,''),(2026,'消息自动回复新增',2006,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxautoreply:add','#','admin','2020-03-04 17:22:43','',NULL,''),(2027,'消息自动回复修改',2006,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxautoreply:edit','#','admin','2020-03-04 17:23:05','',NULL,''),(2028,'消息自动回复删除',2006,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxautoreply:del','#','admin','2020-03-04 17:23:36','',NULL,''),(2029,'消息自动回复详情',2006,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxautoreply:get','#','admin','2020-03-04 17:23:59','',NULL,''),(2033,'商城管理',0,5,'mall',NULL,NULL,'',1,0,'M','0','0',NULL,'shopping','admin','2021-01-21 17:44:55','',NULL,''),(2034,'商品分类',2033,10,'goodscategory','mall/goodscategory/index',NULL,'',1,0,'C','0','0','mall:goodscategory:index','build','admin','2021-01-21 17:47:43','admin','2021-01-21 17:48:30',''),(2035,'商品类目查询',2034,0,'',NULL,NULL,'',1,0,'F','0','0','mall:goodscategory:get','#','admin','2021-01-21 17:48:23','',NULL,''),(2036,'新增商品类目',2034,0,'',NULL,NULL,'',1,0,'F','0','0','mall:goodscategory:add','#','admin','2021-01-21 17:48:51','',NULL,''),(2037,'修改商品类目',2034,0,'',NULL,NULL,'',1,0,'F','0','0','mall:goodscategory:edit','#','admin','2021-01-21 17:49:11','',NULL,''),(2038,'删除商品类目',2034,0,'',NULL,NULL,'',1,0,'F','0','0','mall:goodscategory:del','#','admin','2021-01-21 17:49:31','',NULL,''),(2039,'商品管理',2033,10,'goodsspu','mall/goodsspu/index',NULL,'',1,0,'C','0','0','mall:goodsspu:index','shopping','admin','2021-01-25 22:10:44','admin','2021-01-25 22:12:13',''),(2040,'商品查询',2039,0,'',NULL,NULL,'',1,0,'F','0','0','mall:goodsspu:get','#','admin','2021-01-25 22:13:08','',NULL,''),(2041,'新增商品',2039,0,'',NULL,NULL,'',1,0,'F','0','0','mall:goodsspu:add','#','admin','2021-01-25 22:14:55','',NULL,''),(2042,'修改商品',2039,0,'',NULL,NULL,'',1,0,'F','0','0','mall:goodsspu:edit','#','admin','2021-01-25 22:15:14','',NULL,''),(2043,'删除商品',2039,0,'',NULL,NULL,'',1,0,'F','0','0','mall:goodsspu:del','#','admin','2021-01-25 22:15:35','',NULL,''),(2044,'订单管理',2033,10,'orderinfo','mall/orderinfo/index',NULL,'',1,0,'C','0','0','mall:orderinfo:index','list','admin','2021-01-27 00:07:14','admin','2021-01-27 00:07:45',''),(2045,'订单查询',2044,0,'',NULL,NULL,'',1,0,'F','0','0','mall:orderinfo:get','#','admin','2021-01-27 00:08:28','',NULL,''),(2046,'商城订单修改',2044,0,'',NULL,NULL,'',1,0,'F','0','0','mall:orderinfo:edit','#','admin','2021-01-28 22:38:58','',NULL,''),(2047,'商城订单新增',2044,0,'',NULL,NULL,'',1,0,'F','0','0','mall:orderinfo:add','#','admin','2021-01-28 22:39:21','',NULL,''),(2048,'商城订单删除',2044,0,'',NULL,NULL,'',1,0,'F','0','0','mall:orderinfo:del','#','admin','2021-01-28 22:39:41','',NULL,''),(2049,'小程序管理',0,6,'wxma',NULL,NULL,'',1,0,'M','0','0','','phone','admin','2021-01-28 23:45:03','admin','2025-03-14 10:55:47',''),(2050,'小程序用户',2049,10,'wxuser-ma','wxma/wxuser/index',NULL,'',1,0,'C','0','0','wxmp:wxuser:index','peoples','admin','2021-01-28 23:54:34','',NULL,''),(2051,'小程序用户查询',2050,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxuser:get','#','admin','2021-01-28 23:57:07','',NULL,''),(2052,'草稿箱',4,44,'wxdraft','wxmp/wxdraft/index',NULL,'',1,0,'C','0','0','	 wxmp:wxdraft:index','guide','admin','2022-03-29 14:48:47','admin','2022-03-29 14:51:31',''),(2053,'新增草稿箱',2052,0,'',NULL,NULL,'',1,0,'F','1','0','wxmp:wxdraft:add','#','admin','2022-03-29 14:50:13','',NULL,''),(2054,'修改草稿箱',2052,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxdraft:edit','#','admin','2022-03-29 14:50:28','',NULL,''),(2055,'删除草稿箱',2052,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxdraft:del','#','admin','2022-03-29 14:50:41','',NULL,''),(2057,'发布草稿',2052,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxdraft:publish','#','admin','2022-03-29 14:51:14','',NULL,''),(2058,'已发布',4,46,'wxfreepublish','wxmp/wxfreepublish/index',NULL,'',1,0,'C','0','0','wxmp:wxfreepublish:index','clipboard','admin','2022-03-29 14:52:44','',NULL,''),(2059,'删除已发布',2058,0,'',NULL,NULL,'',1,0,'F','0','0','wxmp:wxfreepublish:del','#','admin','2022-03-29 14:52:57','',NULL,'');
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice`
--

DROP TABLE IF EXISTS `sys_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_notice` (
  `notice_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob COMMENT '公告内容',
  `status` char(1) COLLATE utf8mb4_croatian_ci DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='通知公告表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice`
--

LOCK TABLES `sys_notice` WRITE;
/*!40000 ALTER TABLE `sys_notice` DISABLE KEYS */;
INSERT INTO `sys_notice` VALUES (1,'温馨提醒：2018-07-01 若依新版本发布啦','2',_binary '新版本内容','0','admin','2024-09-11 09:31:32','',NULL,'管理员'),(2,'维护通知：2018-07-01 若依系统凌晨维护','1',_binary '维护内容','0','admin','2024-09-11 09:31:32','',NULL,'管理员');
/*!40000 ALTER TABLE `sys_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_oper_log`
--

DROP TABLE IF EXISTS `sys_oper_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_oper_log` (
  `oper_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '模块标题',
  `business_type` int(11) DEFAULT '0' COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '请求方式',
  `operator_type` int(11) DEFAULT '0' COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '返回参数',
  `status` int(11) DEFAULT '0' COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint(20) DEFAULT '0' COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  KEY `idx_sys_oper_log_bt` (`business_type`) USING BTREE,
  KEY `idx_sys_oper_log_s` (`status`) USING BTREE,
  KEY `idx_sys_oper_log_ot` (`oper_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='操作日志记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oper_log`
--

LOCK TABLES `sys_oper_log` WRITE;
/*!40000 ALTER TABLE `sys_oper_log` DISABLE KEYS */;
INSERT INTO `sys_oper_log` VALUES (100,'菜单管理',2,'com.joolun.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2024-09-11 09:31:31\",\"icon\":\"wechat\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":4,\"menuName\":\"公众号管理\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"wxmp\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-03-14 10:55:18',43),(101,'菜单管理',2,'com.joolun.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2021-01-28 23:45:03\",\"icon\":\"phone\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2049,\"menuName\":\"小程序管理\",\"menuType\":\"M\",\"orderNum\":6,\"params\":{},\"parentId\":0,\"path\":\"wxma\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-03-14 10:55:47',21),(102,'菜单管理',2,'com.joolun.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2024-09-11 09:31:31\",\"icon\":\"wechat\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":4,\"menuName\":\"公众号管理\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"wxmp\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-03-14 13:36:08',33),(103,'用户头像',2,'com.joolun.web.controller.system.SysProfileController.avatar()','POST',1,'admin','研发部门','/system/user/profile/avatar','127.0.0.1','内网IP','','{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2025/03/17/avatar_20250317150205A001.png\",\"code\":200}',0,NULL,'2025-03-17 15:02:05',239),(104,'字典类型',1,'com.joolun.web.controller.system.SysDictTypeController.add()','POST',1,'admin','研发部门','/system/dict/type','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"dictName\":\"商品标签\",\"dictType\":\"spu_tag_type\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-03-19 09:29:34',18),(105,'字典数据',1,'com.joolun.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"进口\",\"dictSort\":1,\"dictType\":\"spu_tag_type\",\"dictValue\":\"1\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-03-19 09:29:58',14),(106,'字典数据',1,'com.joolun.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"国产\",\"dictSort\":2,\"dictType\":\"spu_tag_type\",\"dictValue\":\"2\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-03-19 09:30:11',13),(107,'字典数据',1,'com.joolun.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"半框\",\"dictSort\":13,\"dictType\":\"spu_tag_type\",\"dictValue\":\"13\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-03-19 09:30:32',21),(108,'字典数据',1,'com.joolun.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"全框\",\"dictSort\":12,\"dictType\":\"spu_tag_type\",\"dictValue\":\"12\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-03-19 09:30:52',12),(109,'字典类型',9,'com.joolun.web.controller.system.SysDictTypeController.refreshCache()','DELETE',1,'admin','研发部门','/system/dict/type/refreshCache','192.168.0.69','内网IP','{}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-03-19 10:50:11',36),(110,'代码生成',6,'com.joolun.generator.controller.GenController.importTableSave()','POST',1,'admin','研发部门','/tool/gen/importTable','127.0.0.1','内网IP','{\"tables\":\"goods_spu\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-03-19 14:31:10',150);
/*!40000 ALTER TABLE `sys_oper_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_post`
--

DROP TABLE IF EXISTS `sys_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_post` (
  `post_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int(11) NOT NULL COMMENT '显示顺序',
  `status` char(1) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='岗位信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_post`
--

LOCK TABLES `sys_post` WRITE;
/*!40000 ALTER TABLE `sys_post` DISABLE KEYS */;
INSERT INTO `sys_post` VALUES (1,'ceo','董事长',1,'0','admin','2024-09-11 09:31:31','',NULL,''),(2,'se','项目经理',2,'0','admin','2024-09-11 09:31:31','',NULL,''),(3,'hr','人力资源',3,'0','admin','2024-09-11 09:31:31','',NULL,''),(4,'user','普通员工',4,'0','admin','2024-09-11 09:31:31','',NULL,'');
/*!40000 ALTER TABLE `sys_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_role` (
  `role_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int(11) NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) COLLATE utf8mb4_croatian_ci DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) DEFAULT '1' COMMENT '部门树选择项是否关联显示',
  `status` char(1) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) COLLATE utf8mb4_croatian_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='角色信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'超级管理员','admin',1,'1',1,1,'0','0','admin','2024-09-11 09:31:31','',NULL,'超级管理员'),(2,'普通角色','common',2,'2',1,1,'0','0','admin','2024-09-11 09:31:31','',NULL,'普通角色');
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_dept`
--

DROP TABLE IF EXISTS `sys_role_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_role_dept` (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `dept_id` bigint(20) NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`,`dept_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='角色和部门关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_dept`
--

LOCK TABLES `sys_role_dept` WRITE;
/*!40000 ALTER TABLE `sys_role_dept` DISABLE KEYS */;
INSERT INTO `sys_role_dept` VALUES (2,100),(2,101),(2,105);
/*!40000 ALTER TABLE `sys_role_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_menu`
--

DROP TABLE IF EXISTS `sys_role_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_role_menu` (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `menu_id` bigint(20) NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`,`menu_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='角色和菜单关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_menu`
--

LOCK TABLES `sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sys_role_menu` DISABLE KEYS */;
INSERT INTO `sys_role_menu` VALUES (2,1),(2,2),(2,3),(2,4),(2,100),(2,101),(2,102),(2,103),(2,104),(2,105),(2,106),(2,107),(2,108),(2,109),(2,110),(2,111),(2,112),(2,113),(2,114),(2,115),(2,116),(2,117),(2,500),(2,501),(2,1000),(2,1001),(2,1002),(2,1003),(2,1004),(2,1005),(2,1006),(2,1007),(2,1008),(2,1009),(2,1010),(2,1011),(2,1012),(2,1013),(2,1014),(2,1015),(2,1016),(2,1017),(2,1018),(2,1019),(2,1020),(2,1021),(2,1022),(2,1023),(2,1024),(2,1025),(2,1026),(2,1027),(2,1028),(2,1029),(2,1030),(2,1031),(2,1032),(2,1033),(2,1034),(2,1035),(2,1036),(2,1037),(2,1038),(2,1039),(2,1040),(2,1041),(2,1042),(2,1043),(2,1044),(2,1045),(2,1046),(2,1047),(2,1048),(2,1049),(2,1050),(2,1051),(2,1052),(2,1053),(2,1054),(2,1055),(2,1056),(2,1057),(2,1058),(2,1059),(2,1060);
/*!40000 ALTER TABLE `sys_role_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_user` (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint(20) DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) COLLATE utf8mb4_croatian_ci DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '手机号码',
  `sex` char(1) COLLATE utf8mb4_croatian_ci DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '密码',
  `status` char(1) COLLATE utf8mb4_croatian_ci DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `del_flag` char(1) COLLATE utf8mb4_croatian_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `create_by` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,103,'admin','若依','00','ry@163.com','15888888888','1','/profile/avatar/2025/03/17/avatar_20250317150205A001.png','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2025-04-13 14:07:13','admin','2024-09-11 09:31:31','','2025-04-13 14:07:12','管理员'),(2,105,'ry','若依','00','ry@qq.com','15666666666','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2024-09-11 09:31:31','admin','2024-09-11 09:31:31','',NULL,'测试员');
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_post`
--

DROP TABLE IF EXISTS `sys_user_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_user_post` (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `post_id` bigint(20) NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`,`post_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='用户与岗位关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_post`
--

LOCK TABLES `sys_user_post` WRITE;
/*!40000 ALTER TABLE `sys_user_post` DISABLE KEYS */;
INSERT INTO `sys_user_post` VALUES (1,1),(2,2);
/*!40000 ALTER TABLE `sys_user_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_user_role` (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='用户和角色关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role`
--

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` VALUES (1,1),(2,2);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `try_on_glass_img_url`
--

DROP TABLE IF EXISTS `try_on_glass_img_url`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `try_on_glass_img_url` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `wx_user_id` varchar(32) NOT NULL COMMENT '微信用户ID',
  `img_url` varchar(255) NOT NULL COMMENT '图片地址',
  `goods_spu_id` varchar(32) NOT NULL COMMENT '商品SPU ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='试戴眼镜图片地址表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `try_on_glass_img_url`
--

LOCK TABLES `try_on_glass_img_url` WRITE;
/*!40000 ALTER TABLE `try_on_glass_img_url` DISABLE KEYS */;
/*!40000 ALTER TABLE `try_on_glass_img_url` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `try_optometry`
--

DROP TABLE IF EXISTS `try_optometry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `try_optometry` (
  `try_optometry_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `results_id` bigint(20) DEFAULT NULL COMMENT '视图验光id',
  `left_right_eyes` int(11) DEFAULT NULL COMMENT '左右眼睛（0左，1右）',
  `spherical_mirror` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '球镜',
  `cylindrical_mirror` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '柱镜',
  `position_of_axis` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '轴位',
  `addend` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ADD',
  PRIMARY KEY (`try_optometry_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='试戴验光表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `try_optometry`
--

LOCK TABLES `try_optometry` WRITE;
/*!40000 ALTER TABLE `try_optometry` DISABLE KEYS */;
INSERT INTO `try_optometry` VALUES (1,1,0,'','','',''),(2,1,1,'','','',''),(3,2,0,'','','',''),(4,2,1,'','','',''),(5,3,0,'','','',''),(6,3,1,'','','',''),(7,4,0,'','','',''),(8,4,1,'','','',''),(9,5,0,'','','',''),(10,5,1,'','','',''),(11,6,0,'','','',''),(12,6,1,'','','',''),(13,7,0,'','','',''),(14,7,1,'','','',''),(15,8,0,'','','',''),(16,8,1,'','','',''),(17,9,0,'','','',''),(18,9,1,'','','',''),(19,10,0,'','','',''),(20,10,1,'','','',''),(21,11,0,'','','',''),(22,11,1,'','','',''),(23,12,0,'','','',''),(24,12,1,'','','',''),(25,13,0,'','','',''),(26,13,1,'','','',''),(27,14,0,'','','',''),(28,14,1,'','','',''),(29,15,0,'','','',''),(30,15,1,'','','',''),(31,16,0,'','','',''),(32,16,1,'','','',''),(33,17,0,'','','',''),(34,17,1,'','','',''),(35,18,0,'','','',''),(36,18,1,'','','',''),(37,19,0,'','','',''),(38,19,1,'','','',''),(39,20,0,'','','',''),(40,20,1,'','','',''),(41,21,0,'','','',''),(42,21,1,'','','',''),(43,22,0,'','','',''),(44,22,1,'','','',''),(45,23,0,'','','',''),(46,23,1,'','','',''),(47,24,0,'','','',''),(48,24,1,'','','',''),(49,25,0,'','','',''),(50,25,1,'','','',''),(51,26,0,'','','',''),(52,26,1,'','','',''),(53,27,0,'','','',''),(54,27,1,'','','',''),(55,28,0,'','','',''),(56,28,1,'','','',''),(57,29,0,'','','',''),(58,29,1,'','','',''),(59,30,0,'','','',''),(60,30,1,'','','',''),(61,31,0,'','','',''),(62,31,1,'','','',''),(63,32,0,'','','',''),(64,32,1,'','','',''),(65,33,0,'','','',''),(66,33,1,'','','',''),(67,34,0,'','','',''),(68,34,1,'','','',''),(69,35,0,'','','',''),(70,35,1,'','','',''),(71,36,0,'','','',''),(72,36,1,'','','',''),(73,37,0,'','','',''),(74,37,1,'','','',''),(75,38,0,'','','',''),(76,38,1,'','','',''),(77,39,0,'','','',''),(78,39,1,'','','',''),(79,40,0,'','','',''),(80,40,1,'','','',''),(81,41,0,'','','',''),(82,41,1,'','','',''),(83,42,0,'','','',''),(84,42,1,'','','',''),(85,43,0,'','','',''),(86,43,1,'','','',''),(87,44,0,'','','',''),(88,44,1,'','','',''),(89,45,0,'','','',''),(90,45,1,'','','',''),(91,46,0,'','','',''),(92,46,1,'','','','');
/*!40000 ALTER TABLE `try_optometry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_address`
--

DROP TABLE IF EXISTS `user_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_address` (
  `id` varchar(32) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT 'PK',
  `del_flag` char(2) COLLATE utf8mb4_croatian_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `user_id` varchar(32) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '用户编号',
  `user_name` varchar(50) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '收货人名字',
  `postal_code` varchar(50) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '邮编',
  `province_name` varchar(50) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '省名',
  `city_name` varchar(50) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '市名',
  `county_name` varchar(50) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '区名',
  `detail_info` varchar(50) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '详情地址',
  `tel_num` varchar(50) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '电话号码',
  `is_default` char(2) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '是否默认 1是0否',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='用户地址';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_address`
--

LOCK TABLES `user_address` WRITE;
/*!40000 ALTER TABLE `user_address` DISABLE KEYS */;
INSERT INTO `user_address` VALUES ('1354441894547988481','0','2021-01-27 22:51:26','2021-01-27 14:51:26','1352168072700571649','张三',NULL,'广东省','广州市','海珠区','新港中路397号','18602513214','1'),('1354474056307511297','0','2021-01-28 00:59:14','2021-01-27 16:59:14','1354473059078176770','张三',NULL,'广东省','广州市','海珠区','新港中路397号','18563265321','1'),('1355417330850476033','0','2021-01-30 15:27:29','2021-01-30 07:27:29','1355406809988345857','张三',NULL,'北京市','北京市','东城区','大冲地铁口','15580802543','1'),('1901559553876070402','0','2025-03-17 17:01:41','2025-03-17 09:01:41','1900425114278260738','桂花鱼',NULL,'江苏省','苏州市','昆山市','前进中路345号','13313124523',NULL),('1909168328773275650','0','2025-04-07 16:56:14','2025-04-08 03:39:08','1907278202958839809','张1',NULL,'天津市','市辖区','和平区','啊实打实大苏打实打实的','18336336761','1'),('1909233132762370049','0','2025-04-07 21:13:45','2025-04-08 03:39:08','1907278202958839809','哪吒',NULL,'河北省','石家庄市','长安区','工人路429号','15711281598','0'),('1909794902082150401','0','2025-04-09 10:26:01','2025-04-09 02:26:01','1907300228113170433','规划风格化',NULL,'北京市','北京市','东城区','234325','18333333333','1'),('1910136218544558082','0','2025-04-10 09:02:17','2025-04-10 01:02:17','1910132627566022658','桂花鱼',NULL,'江苏省','苏州市','昆山市','杨树路555号','132325232745','1'),('1910241229412880386','0','2025-04-10 15:59:34','2025-04-10 07:59:36','1910240925996929026','zhang',NULL,'天津市','市辖区','河东区','dd','1','1');
/*!40000 ALTER TABLE `user_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vision_test_results`
--

DROP TABLE IF EXISTS `vision_test_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vision_test_results` (
  `results_id` int(11) NOT NULL AUTO_INCREMENT,
  `optometry_records_id` bigint(20) DEFAULT NULL COMMENT '验光记录ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `ww4points` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '沃氏4点',
  `stereo_view` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '立体观',
  `vgf_bi` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '隐斜（远）BI',
  `vgf_bu` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '隐斜（远）BU',
  `pnif_bi_1` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '正负融像（远）BI1',
  `pnif_bi_2` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '正负融像（远）BI2',
  `pnif_bi_3` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '正负融像（远）BI3',
  `pnif_bu_1` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '正负融像（远）BU1',
  `pnif_bu_2` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '正负融像（远）BU2',
  `pnif_bu_3` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '正负融像（远）BU3',
  `vgn_bi` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '隐斜（近）BI',
  `vgn_bu` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '隐斜（近）BU',
  `aca` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '梯度法',
  `pnin_bi_1` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '正负融像（近）BI1',
  `pnin_bi_2` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '正负融像（近）BI2',
  `pnin_bi_3` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '正负融像（近）BI3',
  `pnin_bu_1` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '正负融像（近）BU1',
  `pnin_bu_2` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '正负融像（近）BU2',
  `pnin_bu_3` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '正负融像（近）BU3',
  `nra` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '负相对调节NRA',
  `bcc` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '调节反应BCC',
  `pra` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '正相对调节PRA',
  `reverse_beat` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '反转拍',
  `visual_chart` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '视力表',
  `binoculus` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '双眼',
  `left_eye` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '左眼',
  `right_eye` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '右眼',
  `diagnosis_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '诊断名称',
  `diagnosis_abnormal` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '诊断异常名称',
  `rests` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '其他',
  `sugggestions` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '建议方案',
  PRIMARY KEY (`results_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='视图验光数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vision_test_results`
--

LOCK TABLES `vision_test_results` WRITE;
/*!40000 ALTER TABLE `vision_test_results` DISABLE KEYS */;
INSERT INTO `vision_test_results` VALUES (1,1,'2024-11-27 15:49:29','2024-11-27 15:49:29','2','',NULL,'0.0','0.0','0.0','0.0','0.0','0.0','0.0',NULL,'0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','上单下单','','','','','','',''),(2,2,'2024-12-12 16:02:13','2024-12-12 16:02:13','2','',NULL,'0.0','0.0','0.0','0.0','0.0','0.0','0.0',NULL,'0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','上单下单','','','','','','',''),(3,3,'2025-02-18 15:27:30','2025-02-18 15:27:30','3','',NULL,'0.0','1.0','2.0','1.0','0.0','0.0','0.0',NULL,'0.0','6.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','上单下单','','','','','','',''),(4,4,'2025-02-18 17:10:10','2025-02-18 17:10:10','3','',NULL,'0.0','1.0','2.0','1.0','0.0','0.0','0.0',NULL,'0.0','6.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','上单下单','','','','','','',''),(5,5,'2025-02-18 17:10:28','2025-02-18 17:10:28','3','',NULL,'0.0','1.0','2.0','1.0','0.0','0.0','0.0',NULL,'0.0','6.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','上单下单','','','','','','',''),(6,6,'2025-02-20 09:27:53','2025-02-20 09:27:53','2','',NULL,'0.0','1.0','2.0','1.0','0.0','0.0','0.0',NULL,'0.0','6.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','上单下单','','','','','','',''),(7,7,'2025-02-20 09:28:08','2025-02-20 09:28:08','2','',NULL,'0.0','1.0','2.0','1.0','0.0','0.0','0.0',NULL,'0.0','6.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','上单下单','','','','','','',''),(8,8,'2025-02-20 09:28:19','2025-02-20 09:28:19','2','',NULL,'0.0','1.0','2.0','1.0','0.0','0.0','0.0',NULL,'0.0','6.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','上单下单','','','','','','',''),(9,9,'2025-02-20 11:04:26','2025-02-20 11:04:26','5','',NULL,'0.0','1.0','2.0','1.0','0.0','0.0','0.0',NULL,'0.0','6.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','上单下单','','','','','','',''),(10,10,'2025-02-20 11:16:43','2025-02-20 11:16:43','5','',NULL,'0.0','1.0','2.0','1.0','0.0','0.0','0.0',NULL,'0.0','6.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','上单下单','','','','','','',''),(11,11,'2025-02-20 11:44:39','2025-02-20 11:44:39','5','',NULL,'0.0','1.0','2.0','1.0','0.0','0.0','0.0',NULL,'0.0','6.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','上单下单','','','','','','',''),(12,12,'2025-02-20 12:32:28','2025-02-20 12:32:28','5','',NULL,'0.0','1.0','2.0','1.0','0.0','0.0','0.0',NULL,'0.0','6.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','上单下单','','','','','','',''),(13,13,'2025-02-20 13:02:07','2025-02-20 13:02:07','5','',NULL,'0.0','1.0','2.0','1.0','0.0','0.0','0.0',NULL,'0.0','6.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','上单下单','','','','','','',''),(14,14,'2025-02-21 10:30:49','2025-02-21 10:30:49','2','',NULL,'0.0','0.0','0.0','0.0','0.0','0.0','0.0',NULL,'0.0','6.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','上单下双','','','','','','',''),(15,15,'2025-02-21 10:43:19','2025-02-25 10:34:05','2','',NULL,'0.0','0.0','0.0','0.0','0.0','0.0','0.0',NULL,'0.0','6.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','上单下双','','','','','','','多吃含胡萝卜素的食物'),(16,16,'2026-03-26 16:56:36','2026-03-26 16:56:36','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(17,17,'2026-03-27 10:44:51','2026-03-27 10:44:51','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(18,18,'2026-03-27 15:42:53','2026-03-27 15:42:53','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(19,19,'2026-03-28 09:19:07','2026-03-28 09:19:07','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(20,20,'2026-03-28 09:35:41','2026-03-28 09:35:41','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(21,21,'2026-03-28 09:46:18','2026-03-28 09:46:18','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(22,22,'2026-03-28 12:08:32','2026-03-28 12:08:32','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(23,23,'2026-03-28 16:47:33','2026-03-28 16:47:33','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(24,24,'2026-03-30 09:32:26','2026-03-30 09:32:26','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(25,25,'2026-03-30 10:48:24','2026-03-30 10:48:24','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(26,26,'2026-03-30 11:38:06','2026-03-30 11:38:06','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(27,27,'2026-03-30 12:58:51','2026-03-30 12:58:51','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(28,28,'2026-03-30 13:03:59','2026-03-30 13:03:59','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(29,29,'2026-03-30 13:15:32','2026-03-30 13:15:32','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(30,30,'2026-03-30 14:41:49','2026-03-30 14:41:49','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(31,31,'2026-03-30 14:46:13','2026-03-30 14:46:13','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(32,32,'2026-03-30 14:50:08','2026-03-30 14:50:08','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(33,33,'2026-03-30 16:25:03','2026-03-30 16:25:03','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(34,34,'2026-03-30 16:39:06','2026-03-30 16:39:06','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(35,35,'2026-04-11 11:44:42','2026-04-11 11:44:42','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(36,36,'2026-04-13 09:53:35','2026-04-13 09:53:35','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(37,37,'2026-04-13 10:16:32','2026-04-13 10:16:32','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(38,38,'2026-04-13 10:20:37','2026-04-13 10:20:37','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(39,39,'2026-04-13 11:09:01','2026-04-13 11:09:01','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(40,40,'2026-04-13 11:17:31','2026-04-13 11:17:31','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(41,41,'2026-04-13 14:59:35','2026-04-13 14:59:35','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(42,42,'2026-04-13 15:54:14','2026-04-13 15:54:14','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(43,43,'2026-04-13 15:58:13','2026-04-13 15:58:13','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(44,44,'2026-04-13 16:45:11','2026-04-13 16:45:11','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(45,45,'2026-04-14 15:32:33','2026-04-14 15:32:33','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','',''),(46,46,'2026-04-14 17:27:41','2026-04-14 17:27:41','','',NULL,'0','0','0','0','0','0','0',NULL,'0','0','0','0','0','0','0','0','0','0','0','','','','','','','','','');
/*!40000 ALTER TABLE `vision_test_results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wx_auto_reply`
--

DROP TABLE IF EXISTS `wx_auto_reply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wx_auto_reply` (
  `id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '主键',
  `create_id` varchar(32) CHARACTER SET utf8 DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_id` varchar(32) CHARACTER SET utf8 DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(100) CHARACTER SET utf8 DEFAULT NULL COMMENT '备注',
  `del_flag` char(2) CHARACTER SET utf8 DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `type` char(2) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '类型（1、关注时回复；2、消息回复；3、关键词回复）',
  `req_key` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '关键词',
  `req_type` char(10) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '请求消息类型（text：文本；image：图片；voice：语音；video：视频；shortvideo：小视频；location：地理位置）',
  `rep_type` char(10) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '回复消息类型（text：文本；image：图片；voice：语音；video：视频；music：音乐；news：图文）',
  `rep_mate` char(10) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '回复类型文本匹配类型（1、全匹配，2、半匹配）',
  `rep_content` text COLLATE utf8mb4_croatian_ci COMMENT '回复类型文本保存文字',
  `rep_media_id` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '回复类型imge、voice、news、video的mediaID或音乐缩略图的媒体id',
  `rep_name` varchar(100) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '回复的素材名、视频和音乐的标题',
  `rep_desc` varchar(200) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '视频和音乐的描述',
  `rep_url` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '链接',
  `rep_hq_url` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '高质量链接',
  `rep_thumb_media_id` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '缩略图的媒体id',
  `rep_thumb_url` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '缩略图url',
  `content` mediumtext COLLATE utf8mb4_croatian_ci COMMENT '图文消息的内容',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='微信自动回复';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wx_auto_reply`
--

LOCK TABLES `wx_auto_reply` WRITE;
/*!40000 ALTER TABLE `wx_auto_reply` DISABLE KEYS */;
/*!40000 ALTER TABLE `wx_auto_reply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wx_menu`
--

DROP TABLE IF EXISTS `wx_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wx_menu` (
  `id` varchar(32) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '菜单ID（click、scancode_push、scancode_waitmsg、pic_sysphoto、pic_photo_or_album、pic_weixin、location_select：保存key）',
  `del_flag` char(2) COLLATE utf8mb4_croatian_ci DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `sort` int(11) DEFAULT '1' COMMENT '排序值',
  `parent_id` varchar(32) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '父菜单ID',
  `type` char(20) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '菜单类型click、view、miniprogram、scancode_push、scancode_waitmsg、pic_sysphoto、pic_photo_or_album、pic_weixin、location_select、media_id、view_limited等',
  `name` varchar(20) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '菜单名',
  `url` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT 'view、miniprogram保存链接',
  `ma_app_id` varchar(32) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '小程序的appid',
  `ma_page_path` varchar(100) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '小程序的页面路径',
  `rep_type` char(10) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '回复消息类型（text：文本；image：图片；voice：语音；video：视频；music：音乐；news：图文）',
  `rep_content` text COLLATE utf8mb4_croatian_ci COMMENT 'Text:保存文字',
  `rep_media_id` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT 'imge、voice、news、video：mediaID',
  `rep_name` varchar(100) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '素材名、视频和音乐的标题',
  `rep_desc` varchar(200) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '视频和音乐的描述',
  `rep_url` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '链接',
  `rep_hq_url` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '高质量链接',
  `rep_thumb_media_id` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '缩略图的媒体id',
  `rep_thumb_url` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '缩略图url',
  `content` mediumtext COLLATE utf8mb4_croatian_ci COMMENT '图文消息的内容',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='自定义菜单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wx_menu`
--

LOCK TABLES `wx_menu` WRITE;
/*!40000 ALTER TABLE `wx_menu` DISABLE KEYS */;
/*!40000 ALTER TABLE `wx_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wx_msg`
--

DROP TABLE IF EXISTS `wx_msg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wx_msg` (
  `id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '主键',
  `create_id` varchar(32) CHARACTER SET utf8 DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_id` varchar(32) CHARACTER SET utf8 DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(100) CHARACTER SET utf8 DEFAULT NULL COMMENT '备注',
  `del_flag` char(2) CHARACTER SET utf8 DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `app_name` varchar(50) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '公众号名称',
  `app_logo` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '公众号logo',
  `wx_user_id` varchar(32) CHARACTER SET utf8 NOT NULL COMMENT '微信用户ID',
  `nick_name` varchar(200) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '微信用户昵称',
  `headimg_url` varchar(1000) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '微信用户头像',
  `type` char(2) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '消息分类（1、用户发给公众号；2、公众号发给用户；）',
  `rep_type` char(20) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '消息类型（text：文本；image：图片；voice：语音；video：视频；shortvideo：小视频；location：地理位置；music：音乐；news：图文；event：推送事件）',
  `rep_event` char(20) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '事件类型（subscribe：关注；unsubscribe：取关；CLICK、VIEW：菜单事件）',
  `rep_content` text COLLATE utf8mb4_croatian_ci COMMENT '回复类型文本保存文字、地理位置信息',
  `rep_media_id` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '回复类型imge、voice、news、video的mediaID或音乐缩略图的媒体id',
  `rep_name` varchar(100) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '回复的素材名、视频和音乐的标题',
  `rep_desc` varchar(200) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '视频和音乐的描述',
  `rep_url` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '链接',
  `rep_hq_url` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '高质量链接',
  `content` mediumtext COLLATE utf8mb4_croatian_ci COMMENT '图文消息的内容',
  `rep_thumb_media_id` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '缩略图的媒体id',
  `rep_thumb_url` varchar(500) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '缩略图url',
  `rep_location_x` double DEFAULT NULL COMMENT '地理位置维度',
  `rep_location_y` double DEFAULT NULL COMMENT '地理位置经度',
  `rep_scale` double DEFAULT NULL COMMENT '地图缩放大小',
  `read_flag` char(2) CHARACTER SET utf8 DEFAULT '1' COMMENT '已读标记（1：是；0：否）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='微信消息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wx_msg`
--

LOCK TABLES `wx_msg` WRITE;
/*!40000 ALTER TABLE `wx_msg` DISABLE KEYS */;
INSERT INTO `wx_msg` VALUES ('1632267995913953281',NULL,'2023-03-05 14:33:11',NULL,NULL,NULL,'0',NULL,NULL,'1632267995788124162',NULL,NULL,'1','event','subscribe',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0'),('1632272703470731266',NULL,'2023-03-05 14:51:53',NULL,NULL,NULL,'0',NULL,NULL,'1632267995788124162',NULL,NULL,'1','event','unsubscribe',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0'),('1632272808005369857',NULL,'2023-03-05 14:52:18',NULL,NULL,NULL,'0',NULL,NULL,'1632267995788124162',NULL,NULL,'1','event','subscribe',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0'),('1632272917996797954',NULL,'2023-03-05 14:52:44',NULL,NULL,NULL,'0',NULL,NULL,'1632267995788124162',NULL,NULL,'1','event','unsubscribe',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0'),('1632272989350297601',NULL,'2023-03-05 14:53:01',NULL,NULL,NULL,'0',NULL,NULL,'1632267995788124162',NULL,NULL,'1','event','subscribe',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0'),('1632273483217068033',NULL,'2023-03-05 14:54:59',NULL,NULL,NULL,'0',NULL,NULL,'1632267995788124162',NULL,NULL,'1','event','unsubscribe',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0'),('1632273535528427521',NULL,'2023-03-05 14:55:12',NULL,NULL,NULL,'0',NULL,NULL,'1632267995788124162',NULL,NULL,'1','event','subscribe',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0'),('1632273641581404162',NULL,'2023-03-05 14:55:37',NULL,NULL,NULL,'0',NULL,NULL,'1632267995788124162',NULL,NULL,'1','text',NULL,'小鲜肉',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0'),('1632273658178265090',NULL,'2023-03-05 14:55:41',NULL,NULL,NULL,'0',NULL,NULL,'1632267995788124162',NULL,NULL,'1','text',NULL,'的',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0'),('1632273702734356482',NULL,'2023-03-05 14:55:52',NULL,NULL,NULL,'0',NULL,NULL,'1632267995788124162',NULL,NULL,'1','image',NULL,NULL,'eRUJFkjKKJcKu_vvI-uXy6eMNbSS-ftq1a_JB6M0BAAcvHK6VA0UpVc1IG-_csAI',NULL,NULL,'http://mmbiz.qpic.cn/mmbiz_jpg/5X3iagjL72nicRx8gcY0hZT2wepsfvTDxYicF0xY2KkEfNKje4mGbvDXXbOWVs1cukF6GDLcS3aXSwAZTIGuOTyVg/0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0'),('1632878647481229313',NULL,'2023-03-07 06:59:42',NULL,NULL,NULL,'0',NULL,NULL,'1632267995788124162',NULL,NULL,'1','text',NULL,'提交',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0');
/*!40000 ALTER TABLE `wx_msg` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wx_user`
--

DROP TABLE IF EXISTS `wx_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wx_user` (
  `id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '主键',
  `create_id` varchar(32) CHARACTER SET utf8 DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_id` varchar(32) CHARACTER SET utf8 DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(100) CHARACTER SET utf8 DEFAULT NULL COMMENT '用户备注',
  `del_flag` char(2) CHARACTER SET utf8 DEFAULT '0' COMMENT '逻辑删除标记（0：显示；1：隐藏）',
  `app_type` char(2) CHARACTER SET utf8 DEFAULT NULL COMMENT '应用类型(1:小程序，2:公众号)',
  `subscribe` char(2) CHARACTER SET utf8 DEFAULT NULL COMMENT '是否订阅（1：是；0：否；2：网页授权用户）',
  `subscribe_scene` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT '返回用户关注的渠道来源，ADD_SCENE_SEARCH 公众号搜索，ADD_SCENE_ACCOUNT_MIGRATION 公众号迁移，ADD_SCENE_PROFILE_CARD 名片分享，ADD_SCENE_QR_CODE 扫描二维码，ADD_SCENEPROFILE LINK 图文页内名称点击，ADD_SCENE_PROFILE_ITEM 图文页右上角菜单，ADD_SCENE_PAID 支付后关注，ADD_SCENE_OTHERS 其他',
  `subscribe_time` datetime DEFAULT NULL COMMENT '关注时间',
  `subscribe_num` int(11) DEFAULT NULL COMMENT '关注次数',
  `cancel_subscribe_time` datetime DEFAULT NULL COMMENT '取消关注时间',
  `open_id` varchar(64) COLLATE utf8mb4_croatian_ci NOT NULL COMMENT '用户标识',
  `open_id_pc` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '网页端用户标识',
  `nick_name` varchar(200) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '昵称',
  `sex` char(2) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '性别（1：男，2：女，0：未知）',
  `city` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '所在城市',
  `country` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '所在国家',
  `province` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '所在省份',
  `phone` varchar(15) CHARACTER SET utf8 DEFAULT NULL COMMENT '手机号码',
  `language` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '用户语言',
  `headimg_url` varchar(1000) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '头像',
  `union_id` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT 'union_id',
  `group_id` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '用户组',
  `tagid_list` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '标签列表',
  `qr_scene_str` varchar(64) COLLATE utf8mb4_croatian_ci DEFAULT NULL COMMENT '二维码扫码场景',
  `latitude` double DEFAULT NULL COMMENT '地理位置纬度',
  `longitude` double DEFAULT NULL COMMENT '地理位置经度',
  `precision` double DEFAULT NULL COMMENT '地理位置精度',
  `session_key` varchar(200) CHARACTER SET utf8 DEFAULT NULL COMMENT '会话密钥',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_openid` (`open_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci ROW_FORMAT=DYNAMIC COMMENT='微信用户';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wx_user`
--

LOCK TABLES `wx_user` WRITE;
/*!40000 ALTER TABLE `wx_user` DISABLE KEYS */;
INSERT INTO `wx_user` VALUES ('1900425114278260738',NULL,'2025-03-14 13:53:50',NULL,'2025-03-17 16:59:43',NULL,'0','1',NULL,NULL,NULL,NULL,NULL,'oPXd06wSf5K8mW_h5uJsUsxU55sk',NULL,'   ','0','','','',NULL,'zh_CN','https://thirdwx.qlogo.cn/mmopen/vi_32/z770JtevmV1aHqKmiaYwcicqaXR0e32ywqMKuFBfWg6rauFNeiaYLGEdBAosZx119SZcOSibbmImQQzOoCEMoax24LV88Iict1reHibibyXS6jh0zM/132',NULL,NULL,'[]',NULL,NULL,NULL,NULL,'3ydRrXSYaEnG8PVt9/yp7w=='),('1907278202958839809','13','2025-04-02 11:45:33',NULL,'2026-03-27 15:42:53',NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,'o_2jP6zd9W79TNucHkuemFrpFaPg',NULL,'这个网速只能','0',NULL,NULL,NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/hh0DgEGDicETFV15NcqXB0fHa4PSyfDMAb3tgkpsqpc8JhDRVo50sia87DhL2NRUaictGSBcNibY9ncbAic9icayEBZxQUu5OeqWhgr9lZ1otoGs4/132','oKmXP6xeGKe2c9mYyYWwIPImtuAc',NULL,NULL,NULL,NULL,NULL,NULL,NULL),('1907300228113170433','13','2025-04-02 13:13:04',NULL,'2026-03-27 15:42:53',NULL,'0','1',NULL,NULL,NULL,NULL,NULL,'o3h6g7TOi2Pd0NnroMdXwvXK4oqM',NULL,'这个网速只能','0','','','','18336336761','zh_CN','https://thirdwx.qlogo.cn/mmopen/vi_32/dr34H3hOMVuictiacGsIISbUc91bHdNvCelIvqqhDAddE64zNSMRI90XfMaXlmchTcHNx3KZPChwby2p5xs3sBeEtRjBIy2hJu3h8iaqvkY5d0/132','oKmXP6xeGKe2c9mYyYWwIPImtuAc',NULL,'[]',NULL,NULL,NULL,NULL,'YfCKrsMs8jEsQQcVbgCEww=='),('1910127473236168705',NULL,'2025-04-10 08:27:32',NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,'o_2jP6-KR1YgkNg_Kw2cJgDcQq3M',NULL,'锅巴肉片','0',NULL,NULL,NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/JzIRs07U8G0t0o2USQvoSQkK9gtxDaV3TRMU0HU3nVLbTmZOG0oibKFAIfFNzgzKcZ2wC8Jn8c3tg2rXDZSB8wOnWooEQdxicb2YIubfYsaEE/132','oKmXP66EmWw6zXdcfoarzefWDvg8',NULL,NULL,NULL,NULL,NULL,NULL,NULL),('1910171594734710786','21','2025-04-10 11:22:52',NULL,'2026-04-13 10:16:31',NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,'o_2jP6xp26adYNzgfOBD4S0QQVw8',NULL,'XM小希-13382518118','0',NULL,NULL,NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/9mjKN9eFKKGu8vibticCZJzrjz65aMxj4n98z5xGy2QCGicpHXBXGt7CpC8N8OLWr2Vg5Jj1cLGibHrClA9xEVQAk168Mw1c7QwVNsYIdk6KUuA/132','oKmXP66VFdLU5eAMTX3VH-Zziv88',NULL,NULL,NULL,NULL,NULL,NULL,NULL),('1910240925996929026','8','2025-04-10 15:58:21',NULL,'2026-03-28 09:35:41',NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,'o_2jP6wA5zbhkCRTjq7g6x7kBiSA',NULL,'张翔','0',NULL,NULL,NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/lPOXDTOLtvzWHXsCKSY0CBj2RNAnBiajLNNZ2gsUyvj42v2ibkYNibHwybB37BjqibjIsbImRJnib1f4Dz5ibE1gS1xc1swdmpMELxHgW8WYy6v5M/132','oKmXP631Avt6f4EiAb7xki5D9Chk',NULL,NULL,NULL,NULL,NULL,NULL,NULL),('2034876203109011458','1','2026-03-20 14:14:27',NULL,'2026-03-20 14:15:31',NULL,'0','1',NULL,NULL,NULL,NULL,NULL,'o3h6g7c4ISkNNpmE6dHRvWHucSa0','o_2jP6wtOEF1kqhIWV8miVeiq0N0','   ','0',NULL,NULL,NULL,'17751070969',NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/ooZCPFY1xgBfkiacUA4D3DXe4PXZI8OVGnh4NM9Sl7H4FK80vTznnEib4WhxVVzQ3f3guicWszfW8k8RtvDRjpdPO7VlSbiasYODDwicTuTuYY5M/132','oKmXP65p7Sg98Kz_PcLNy9I-oBIE',NULL,'[]',NULL,NULL,NULL,NULL,'5Q3aHvQjZOooKiUSbillzQ=='),('2034920666695028738',NULL,'2026-03-20 17:11:08',NULL,'2026-03-20 17:11:13',NULL,'0','1',NULL,NULL,NULL,NULL,NULL,'o3h6g7aR3G6tkD7yjm4UsMDM1kWs',NULL,NULL,NULL,NULL,NULL,NULL,'13382518228',NULL,NULL,'oKmXP6-LRueGNw2zSLI6RmNuqPwU',NULL,'[]',NULL,NULL,NULL,NULL,'29G1quz9CXj9eby5POLruQ=='),('2036326305136701442',NULL,'2026-03-24 14:16:39',NULL,'2026-03-24 14:16:46',NULL,'0','1',NULL,NULL,NULL,NULL,NULL,'o3h6g7ZqNuq4MYyBqMj3LbWJEGoY',NULL,NULL,NULL,NULL,NULL,NULL,'15935981583',NULL,NULL,'oKmXP6ycBDEiw_4rHnwW_P1O_x8E',NULL,'[]',NULL,NULL,NULL,NULL,'WsdYHcgzGLFJy5OB/wsnpA=='),('2036327390127648770','8','2026-03-24 14:20:57',NULL,'2026-03-28 09:35:41',NULL,'0','1',NULL,NULL,NULL,NULL,NULL,'o3h6g7feoFdOMohbTNxHCr2-yF1s',NULL,NULL,NULL,NULL,NULL,NULL,'13127783709',NULL,NULL,'oKmXP631Avt6f4EiAb7xki5D9Chk',NULL,'[]',NULL,NULL,NULL,NULL,'6neHFcYQBgEq/iM2sgQw0w=='),('2036331760344952833',NULL,'2026-03-24 14:38:19',NULL,'2026-03-24 14:38:23',NULL,'0','1',NULL,NULL,NULL,NULL,NULL,'o3h6g7RrnYZH-W_45YpuZi1mGLZw',NULL,NULL,NULL,NULL,NULL,NULL,'15251356123',NULL,NULL,'oKmXP63yByBoZfLhTeiJipab8IPo',NULL,'[]',NULL,NULL,NULL,NULL,'4Mp4jZErFF4d6U9BbL1veQ=='),('2036333338179203074',NULL,'2026-03-24 14:44:35',NULL,'2026-03-24 14:44:43',NULL,'0','1',NULL,NULL,NULL,NULL,NULL,'o3h6g7c5-wcVouRMCS2fuuTZjBuA',NULL,NULL,NULL,NULL,NULL,NULL,'15062693265',NULL,NULL,'oKmXP628KxRa9d7HVPpFg8vuBJmc',NULL,'[]',NULL,NULL,NULL,NULL,'/QbyiIAWIUWgh5NDH76/+g=='),('2036351639437504513','11','2026-03-24 15:57:19',NULL,'2026-03-28 16:47:33',NULL,'0','1',NULL,NULL,NULL,NULL,NULL,'o3h6g7YPqSzTpnsrMonJNMVopRDQ',NULL,NULL,NULL,NULL,NULL,NULL,'18260206519',NULL,NULL,'oKmXP68X-uyAB_WOYvU7LbtB8osY',NULL,'[]',NULL,NULL,NULL,NULL,'q9GJhQbePHw7epTeA6m5xA=='),('2036356582185693185',NULL,'2026-03-24 16:16:57',NULL,'2026-03-24 16:17:02',NULL,'0','1',NULL,NULL,NULL,NULL,NULL,'o3h6g7S3PgHX-X_siTmvvpI4Qz64',NULL,NULL,NULL,NULL,NULL,NULL,'13382117741',NULL,NULL,'oKmXP6wehwQo0ILecM7V64PV4Pf4',NULL,'[]',NULL,NULL,NULL,NULL,'kzBAwRJnDxNvnr8O1jCEgw=='),('2037338984064282626','14','2026-03-27 09:20:40',NULL,'2026-03-28 12:08:32',NULL,'0','1',NULL,NULL,NULL,NULL,NULL,'o3h6g7UIrKP9B-LP83vmEEqYuUpY',NULL,NULL,NULL,NULL,NULL,NULL,'18364170199',NULL,NULL,'oKmXP6w2pNqSCZkNbDSCq7XIprtE',NULL,'[]',NULL,NULL,NULL,NULL,'ZvX+UFErS22quITWEr6SVQ=='),('2037369333553098753',NULL,'2026-03-27 11:21:16',NULL,'2026-03-27 11:21:20',NULL,'0','1',NULL,NULL,NULL,NULL,NULL,'o3h6g7eFnPidPOkKIyf5nazFYN7s',NULL,NULL,NULL,NULL,NULL,NULL,'19851280731',NULL,NULL,'oKmXP67-EmELfAa0Jj4rNsNFybHI',NULL,'[]',NULL,NULL,NULL,NULL,'hMqbP1xVh+M4kHBdgyOQ0A=='),('2038925421737996289',NULL,'2026-03-31 18:24:36',NULL,NULL,NULL,'0','1',NULL,NULL,NULL,NULL,NULL,'o3h6g7ZLPrHBl_qe5WJFDb4zhTm8',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'oKmXP6xhHdXmYYrT99zvcPNzr2QA',NULL,NULL,NULL,NULL,NULL,NULL,'qh1qGDBGsZObz1BTShnVSA=='),('2039227550637813762',NULL,'2026-04-01 14:25:09',NULL,NULL,NULL,'0','1',NULL,NULL,NULL,NULL,NULL,'o3h6g7T0l73ryZpio2HbLfhH-4AI',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'oKmXP64eSMukQR6S9b0yynYUruIw',NULL,NULL,NULL,NULL,NULL,NULL,'w1JJEcI2FNWb1GpVD00Ujw=='),('2043158791217016833',NULL,'2026-04-12 10:46:30',NULL,'2026-04-12 10:46:34',NULL,'0','1',NULL,NULL,NULL,NULL,NULL,'o3h6g7bfzTz7NMdPMVcPiIgRQpyQ',NULL,NULL,NULL,NULL,NULL,NULL,'15950187303',NULL,NULL,'oKmXP69MgTCvvFAqeJDMBdN_PvaY',NULL,'[]',NULL,NULL,NULL,NULL,'bmB9TttzuRUOUCx6SgVPiw=='),('2043512379852255234','21','2026-04-13 10:11:32',NULL,'2026-04-13 10:16:31',NULL,'0','1',NULL,NULL,NULL,NULL,NULL,'o3h6g7UJjB9vOnUeQ38bwvNqbrbk',NULL,NULL,NULL,NULL,NULL,NULL,'13382518118',NULL,NULL,'oKmXP66VFdLU5eAMTX3VH-Zziv88',NULL,NULL,NULL,NULL,NULL,NULL,'A58KKfNFgcAw/nB0jypYfA==');
/*!40000 ALTER TABLE `wx_user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-16  9:35:47
