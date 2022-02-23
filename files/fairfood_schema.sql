-- MariaDB dump 10.19  Distrib 10.5.12-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: fairfood_production
-- ------------------------------------------------------
-- Server version	10.5.12-MariaDB-0+deb11u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `address_validation_results`
--

DROP TABLE IF EXISTS `address_validation_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `address_validation_results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `full_address` varchar(255) DEFAULT NULL,
  `valid_address` tinyint(1) DEFAULT NULL,
  `harmony_data` text DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_address_validation_results_on_full_address` (`full_address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `address_validation_results`
--

LOCK TABLES `address_validation_results` WRITE;
/*!40000 ALTER TABLE `address_validation_results` DISABLE KEYS */;
/*!40000 ALTER TABLE `address_validation_results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adjustments`
--

DROP TABLE IF EXISTS `adjustments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adjustments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `target_id` int(11) DEFAULT NULL,
  `target_type` varchar(255) DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL,
  `source_type` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `is_relative` tinyint(1) DEFAULT NULL,
  `amount` decimal(10,4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_adjustments_on_source_id` (`source_id`),
  KEY `index_adjustments_on_source_type` (`source_type`),
  KEY `index_adjustments_on_target_id` (`target_id`),
  KEY `index_adjustments_on_target_type` (`target_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adjustments`
--

LOCK TABLES `adjustments` WRITE;
/*!40000 ALTER TABLE `adjustments` DISABLE KEYS */;
/*!40000 ALTER TABLE `adjustments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adjustments_products`
--

DROP TABLE IF EXISTS `adjustments_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adjustments_products` (
  `adjustment_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adjustments_products`
--

LOCK TABLES `adjustments_products` WRITE;
/*!40000 ALTER TABLE `adjustments_products` DISABLE KEYS */;
/*!40000 ALTER TABLE `adjustments_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ar_internal_metadata`
--

DROP TABLE IF EXISTS `ar_internal_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ar_internal_metadata` (
  `key` varchar(255) CHARACTER SET utf8 NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ar_internal_metadata`
--

LOCK TABLES `ar_internal_metadata` WRITE;
/*!40000 ALTER TABLE `ar_internal_metadata` DISABLE KEYS */;
INSERT INTO `ar_internal_metadata` VALUES ('environment','staging','2022-02-22 22:49:43','2022-02-22 22:49:43');
/*!40000 ALTER TABLE `ar_internal_metadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `banners`
--

DROP TABLE IF EXISTS `banners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `banners` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` text NOT NULL,
  `link` varchar(255) DEFAULT NULL,
  `show_from` date DEFAULT NULL,
  `show_until` date DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `style` varchar(255) DEFAULT NULL,
  `position` varchar(255) DEFAULT 'page_top',
  `image_file_name` varchar(255) DEFAULT NULL,
  `image_content_type` varchar(255) DEFAULT NULL,
  `image_file_size` bigint(20) DEFAULT NULL,
  `image_updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_banners_on_show_from` (`show_from`),
  KEY `index_banners_on_show_until` (`show_until`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banners`
--

LOCK TABLES `banners` WRITE;
/*!40000 ALTER TABLE `banners` DISABLE KEYS */;
/*!40000 ALTER TABLE `banners` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cached_snippets`
--

DROP TABLE IF EXISTS `cached_snippets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cached_snippets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `slug` varchar(255) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `wordpress_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cached_snippets`
--

LOCK TABLES `cached_snippets` WRITE;
/*!40000 ALTER TABLE `cached_snippets` DISABLE KEYS */;
/*!40000 ALTER TABLE `cached_snippets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carts`
--

DROP TABLE IF EXISTS `carts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `carts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `payment_id` int(11) DEFAULT NULL,
  `delivery_destination_id` int(11) DEFAULT NULL,
  `subscriptions_start_date` date DEFAULT NULL,
  `converted_to_orders` tinyint(1) DEFAULT 0,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_carts_on_delivery_destination_id` (`delivery_destination_id`),
  KEY `index_carts_on_payment_id` (`payment_id`),
  KEY `index_carts_on_user_id` (`user_id`),
  CONSTRAINT `fk_rails_ea59a35211` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carts`
--

LOCK TABLES `carts` WRITE;
/*!40000 ALTER TABLE `carts` DISABLE KEYS */;
/*!40000 ALTER TABLE `carts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `closure_dates`
--

DROP TABLE IF EXISTS `closure_dates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `closure_dates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `closed_on` date NOT NULL,
  `food_host_id` int(11) DEFAULT NULL,
  `comment` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_closure_dates_on_closed_on` (`closed_on`),
  KEY `index_closure_dates_on_food_host_id` (`food_host_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `closure_dates`
--

LOCK TABLES `closure_dates` WRITE;
/*!40000 ALTER TABLE `closure_dates` DISABLE KEYS */;
/*!40000 ALTER TABLE `closure_dates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coupons`
--

DROP TABLE IF EXISTS `coupons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `coupons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(16) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `valid_from` date DEFAULT NULL,
  `valid_to` date DEFAULT NULL,
  `discount_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `discount_amount` decimal(8,2) DEFAULT NULL,
  `min_order` decimal(8,2) DEFAULT NULL,
  `available_to_discount_holders` tinyint(1) DEFAULT NULL,
  `product_filter_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `product_filter_targets` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `valid_for_orders_from` date DEFAULT NULL,
  `valid_for_orders_to` date DEFAULT NULL,
  `new_users_only` tinyint(1) DEFAULT NULL,
  `one_use_per_user` tinyint(1) DEFAULT NULL,
  `promotion_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_coupons_on_code` (`code`),
  KEY `index_coupons_on_promotion_id` (`promotion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coupons`
--

LOCK TABLES `coupons` WRITE;
/*!40000 ALTER TABLE `coupons` DISABLE KEYS */;
/*!40000 ALTER TABLE `coupons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `custom_deliverable_addresses`
--

DROP TABLE IF EXISTS `custom_deliverable_addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `custom_deliverable_addresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `address_line_1` varchar(255) DEFAULT NULL,
  `address_line_2` varchar(255) DEFAULT NULL,
  `suburb` varchar(255) DEFAULT NULL,
  `postcode` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_custom_deliverable_addresses_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `custom_deliverable_addresses`
--

LOCK TABLES `custom_deliverable_addresses` WRITE;
/*!40000 ALTER TABLE `custom_deliverable_addresses` DISABLE KEYS */;
/*!40000 ALTER TABLE `custom_deliverable_addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `daily_stats`
--

DROP TABLE IF EXISTS `daily_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `daily_stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `key` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `value` decimal(8,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_daily_stats_on_date` (`date`),
  KEY `index_daily_stats_on_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `daily_stats`
--

LOCK TABLES `daily_stats` WRITE;
/*!40000 ALTER TABLE `daily_stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `daily_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data_events`
--

DROP TABLE IF EXISTS `data_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) NOT NULL,
  `data` text NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_data_events_on_created_at` (`created_at`),
  KEY `index_data_events_on_session_id` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data_events`
--

LOCK TABLES `data_events` WRITE;
/*!40000 ALTER TABLE `data_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `day_stock_profiles`
--

DROP TABLE IF EXISTS `day_stock_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `day_stock_profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `order_quantity` int(11) DEFAULT NULL,
  `lock_version` int(11) DEFAULT 0,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_day_stock_profiles_on_date` (`date`),
  KEY `index_day_stock_profiles_on_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `day_stock_profiles`
--

LOCK TABLES `day_stock_profiles` WRITE;
/*!40000 ALTER TABLE `day_stock_profiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `day_stock_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delayed_jobs`
--

DROP TABLE IF EXISTS `delayed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `delayed_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `priority` int(11) NOT NULL DEFAULT 0,
  `attempts` int(11) NOT NULL DEFAULT 0,
  `handler` text COLLATE utf8_unicode_ci NOT NULL,
  `last_error` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `run_at` datetime DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  `failed_at` datetime DEFAULT NULL,
  `locked_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `queue` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `delayed_jobs_priority` (`priority`,`run_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delayed_jobs`
--

LOCK TABLES `delayed_jobs` WRITE;
/*!40000 ALTER TABLE `delayed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `delayed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deliveries`
--

DROP TABLE IF EXISTS `deliveries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `deliveries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `delivery_destination_id` int(11) NOT NULL,
  `fee` decimal(8,2) NOT NULL DEFAULT 0.00,
  `date` date NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_deliveries_on_date` (`date`),
  KEY `index_deliveries_on_delivery_destination_id` (`delivery_destination_id`),
  KEY `index_deliveries_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deliveries`
--

LOCK TABLES `deliveries` WRITE;
/*!40000 ALTER TABLE `deliveries` DISABLE KEYS */;
/*!40000 ALTER TABLE `deliveries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delivery_destinations`
--

DROP TABLE IF EXISTS `delivery_destinations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `delivery_destinations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `delivery_run_id` int(11) DEFAULT NULL,
  `address_line_1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address_line_2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `suburb` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `postcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `map_reference` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `member_directions` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL,
  `driver_directions` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `lock_version` int(11) DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `open_at` time DEFAULT NULL,
  `lat` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lng` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `closes_at` time DEFAULT NULL,
  `token` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `percentage_discount` decimal(8,2) DEFAULT NULL,
  `max_active_users` int(11) DEFAULT NULL,
  `host_id` int(11) DEFAULT NULL,
  `driver_notes` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `position` int(11) DEFAULT 0,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fuzzy_lat` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fuzzy_lng` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `short_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `harmony_full_address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_delivery_destinations_on_address` (`address_line_1`,`address_line_2`,`suburb`,`postcode`),
  KEY `index_delivery_destinations_on_delivery_run_id` (`delivery_run_id`),
  KEY `index_delivery_locations_on_host_id` (`host_id`),
  KEY `index_delivery_locations_on_lat_and_lng` (`lat`,`lng`),
  KEY `index_delivery_locations_on_name` (`name`),
  KEY `index_food_hosts_on_position` (`position`),
  KEY `index_delivery_destinations_on_short_name` (`short_name`),
  KEY `index_delivery_locations_on_token` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery_destinations`
--

LOCK TABLES `delivery_destinations` WRITE;
/*!40000 ALTER TABLE `delivery_destinations` DISABLE KEYS */;
/*!40000 ALTER TABLE `delivery_destinations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delivery_fees`
--

DROP TABLE IF EXISTS `delivery_fees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `delivery_fees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `amount` decimal(8,2) NOT NULL,
  `delivery_day` tinyint(4) NOT NULL,
  `delivery_max` decimal(8,2) DEFAULT NULL,
  `available_from` date DEFAULT NULL,
  `available_until` date DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_delivery_fees_on_available_from` (`available_from`),
  KEY `index_delivery_fees_on_available_until` (`available_until`),
  KEY `index_delivery_fees_on_delivery_day` (`delivery_day`),
  KEY `index_delivery_fees_on_delivery_max` (`delivery_max`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery_fees`
--

LOCK TABLES `delivery_fees` WRITE;
/*!40000 ALTER TABLE `delivery_fees` DISABLE KEYS */;
/*!40000 ALTER TABLE `delivery_fees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delivery_limits`
--

DROP TABLE IF EXISTS `delivery_limits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `delivery_limits` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `day_of_week` int(11) NOT NULL,
  `max_deliveries` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_delivery_limits_on_day_of_week` (`day_of_week`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery_limits`
--

LOCK TABLES `delivery_limits` WRITE;
/*!40000 ALTER TABLE `delivery_limits` DISABLE KEYS */;
/*!40000 ALTER TABLE `delivery_limits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delivery_runs`
--

DROP TABLE IF EXISTS `delivery_runs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `delivery_runs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `vehicle_id` int(11) DEFAULT NULL,
  `packing_shift_id` int(11) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `description` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `lock_version` int(11) DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `delivery_day` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `index_delivery_runs_on_delivery_day` (`delivery_day`),
  KEY `index_delivery_runs_on_packing_shift_id` (`packing_shift_id`),
  KEY `index_delivery_runs_on_vehicle_id` (`vehicle_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery_runs`
--

LOCK TABLES `delivery_runs` WRITE;
/*!40000 ALTER TABLE `delivery_runs` DISABLE KEYS */;
/*!40000 ALTER TABLE `delivery_runs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_templates`
--

DROP TABLE IF EXISTS `email_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `body` text DEFAULT NULL,
  `body_html` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_email_templates_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_templates`
--

LOCK TABLES `email_templates` WRITE;
/*!40000 ALTER TABLE `email_templates` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favourites`
--

DROP TABLE IF EXISTS `favourites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `favourites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_favourites_on_product_id` (`product_id`),
  KEY `index_favourites_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favourites`
--

LOCK TABLES `favourites` WRITE;
/*!40000 ALTER TABLE `favourites` DISABLE KEYS */;
/*!40000 ALTER TABLE `favourites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gift_vouchers`
--

DROP TABLE IF EXISTS `gift_vouchers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gift_vouchers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `recipient_name` varchar(255) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `value` decimal(8,2) DEFAULT NULL,
  `invoice_id` int(11) DEFAULT NULL,
  `code` varchar(16) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `cancelled_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_gift_vouchers_on_invoice_id` (`invoice_id`),
  KEY `index_gift_vouchers_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gift_vouchers`
--

LOCK TABLES `gift_vouchers` WRITE;
/*!40000 ALTER TABLE `gift_vouchers` DISABLE KEYS */;
/*!40000 ALTER TABLE `gift_vouchers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `home_delivery_area_delivery_runs`
--

DROP TABLE IF EXISTS `home_delivery_area_delivery_runs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `home_delivery_area_delivery_runs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `home_delivery_area_id` int(11) DEFAULT NULL,
  `delivery_run_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_home_delivery_area_delivery_runs_on_delivery_run_id` (`delivery_run_id`),
  KEY `index_home_delivery_area_delivery_runs_on_home_delivery_area_id` (`home_delivery_area_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `home_delivery_area_delivery_runs`
--

LOCK TABLES `home_delivery_area_delivery_runs` WRITE;
/*!40000 ALTER TABLE `home_delivery_area_delivery_runs` DISABLE KEYS */;
/*!40000 ALTER TABLE `home_delivery_area_delivery_runs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `home_delivery_area_postcodes`
--

DROP TABLE IF EXISTS `home_delivery_area_postcodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `home_delivery_area_postcodes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `home_delivery_area_id` int(11) DEFAULT NULL,
  `postcode` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_home_delivery_area_postcodes_on_home_delivery_area_id` (`home_delivery_area_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `home_delivery_area_postcodes`
--

LOCK TABLES `home_delivery_area_postcodes` WRITE;
/*!40000 ALTER TABLE `home_delivery_area_postcodes` DISABLE KEYS */;
/*!40000 ALTER TABLE `home_delivery_area_postcodes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `home_delivery_areas`
--

DROP TABLE IF EXISTS `home_delivery_areas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `home_delivery_areas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `colour` varchar(255) DEFAULT NULL,
  `admin_colour` varchar(255) DEFAULT NULL,
  `zone_name` varchar(255) DEFAULT NULL,
  `delivery_days` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `home_delivery_areas`
--

LOCK TABLES `home_delivery_areas` WRITE;
/*!40000 ALTER TABLE `home_delivery_areas` DISABLE KEYS */;
/*!40000 ALTER TABLE `home_delivery_areas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice_items`
--

DROP TABLE IF EXISTS `invoice_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invoice_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invoice_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `comment` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `price` decimal(8,2) NOT NULL DEFAULT 0.00,
  `price_ex_gst` decimal(8,2) NOT NULL DEFAULT 0.00,
  `gst` decimal(8,2) NOT NULL DEFAULT 0.00,
  `lock_version` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_invoice_items_on_deleted_at` (`deleted_at`),
  KEY `index_invoice_items_on_invoice_id` (`invoice_id`),
  KEY `index_invoice_items_on_order_id` (`order_id`),
  KEY `index_invoice_items_on_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice_items`
--

LOCK TABLES `invoice_items` WRITE;
/*!40000 ALTER TABLE `invoice_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoice_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoices`
--

DROP TABLE IF EXISTS `invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invoices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `delivery_destination_id` int(11) DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `total_inc_tax` decimal(8,2) DEFAULT NULL,
  `total_ex_tax` decimal(8,2) DEFAULT NULL,
  `tax` decimal(8,2) DEFAULT NULL,
  `comments` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `paid_by_account` decimal(8,2) NOT NULL DEFAULT 0.00,
  `paid_by_charge` decimal(8,2) NOT NULL DEFAULT 0.00,
  `created_by_user_id` int(11) NOT NULL,
  `finalised_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_invoices_on_created_at` (`created_at`),
  KEY `index_invoices_on_created_by_user_id` (`created_by_user_id`),
  KEY `index_invoices_on_deleted_at` (`deleted_at`),
  KEY `index_invoices_on_delivery_date` (`delivery_date`),
  KEY `index_invoices_on_delivery_location_id` (`delivery_destination_id`),
  KEY `index_invoices_on_finalised_at` (`finalised_at`),
  KEY `index_invoices_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices`
--

LOCK TABLES `invoices` WRITE;
/*!40000 ALTER TABLE `invoices` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `late_order_authorisations`
--

DROP TABLE IF EXISTS `late_order_authorisations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `late_order_authorisations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `authorised_for` date DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_late_order_authorisations_on_user_id_and_authorised_for` (`user_id`,`authorised_for`),
  KEY `index_late_order_authorisations_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `late_order_authorisations`
--

LOCK TABLES `late_order_authorisations` WRITE;
/*!40000 ALTER TABLE `late_order_authorisations` DISABLE KEYS */;
/*!40000 ALTER TABLE `late_order_authorisations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `complementary` tinyint(1) DEFAULT 0,
  `correction` tinyint(1) DEFAULT 0,
  `created_by_user_id` int(11) DEFAULT NULL,
  `comment` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `price` decimal(8,2) DEFAULT 0.00,
  `lock_version` int(11) DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `delivery_destination_id` int(11) NOT NULL,
  `price_ex_gst` decimal(8,2) NOT NULL,
  `gst` decimal(8,2) NOT NULL,
  `cancelled` tinyint(1) NOT NULL DEFAULT 0,
  `order_type` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `delivery_fee` decimal(8,2) NOT NULL DEFAULT 0.00,
  `delivery_date` date DEFAULT NULL,
  `base_unit_price` decimal(8,2) DEFAULT NULL,
  `delivery_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_orders_on_cancelled` (`cancelled`),
  KEY `index_orders_on_created_at` (`created_at`),
  KEY `index_orders_on_created_by_user_id` (`created_by_user_id`),
  KEY `index_orders_on_delivery_date` (`delivery_date`),
  KEY `index_orders_on_food_host_id` (`delivery_destination_id`),
  KEY `fk_rails_caba0da8d5` (`delivery_id`),
  KEY `index_orders_on_product_id_and_cancelled` (`product_id`,`cancelled`),
  KEY `index_orders_on_product_id` (`product_id`),
  KEY `index_orders_on_user_id` (`user_id`),
  CONSTRAINT `fk_rails_caba0da8d5` FOREIGN KEY (`delivery_id`) REFERENCES `deliveries` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pack_events`
--

DROP TABLE IF EXISTS `pack_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pack_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `produce_id` int(11) NOT NULL,
  `packed_on` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pack_events_on_packed_on` (`packed_on`),
  KEY `index_pack_events_on_produce_id` (`produce_id`),
  KEY `index_pack_events_on_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pack_events`
--

LOCK TABLES `pack_events` WRITE;
/*!40000 ALTER TABLE `pack_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `pack_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `packing_categories`
--

DROP TABLE IF EXISTS `packing_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `packing_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `packing_categories`
--

LOCK TABLES `packing_categories` WRITE;
/*!40000 ALTER TABLE `packing_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `packing_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `packing_shifts`
--

DROP TABLE IF EXISTS `packing_shifts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `packing_shifts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `start_at` time DEFAULT NULL,
  `end_at` time DEFAULT NULL,
  `lock_version` int(11) DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `packing_shifts`
--

LOCK TABLES `packing_shifts` WRITE;
/*!40000 ALTER TABLE `packing_shifts` DISABLE KEYS */;
/*!40000 ALTER TABLE `packing_shifts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `participations`
--

DROP TABLE IF EXISTS `participations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `participations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `promotion_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `joined_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `completed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_participations_on_user_id_and_promotion_id` (`user_id`,`promotion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `participations`
--

LOCK TABLES `participations` WRITE;
/*!40000 ALTER TABLE `participations` DISABLE KEYS */;
/*!40000 ALTER TABLE `participations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_types`
--

DROP TABLE IF EXISTS `payment_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payment_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `lock_version` int(11) DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_types`
--

LOCK TABLES `payment_types` WRITE;
/*!40000 ALTER TABLE `payment_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amount` decimal(8,2) DEFAULT 0.00,
  `payment_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_by_user_id` int(11) DEFAULT NULL,
  `comment` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lock_version` int(11) DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `order_number` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(12) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'processing',
  `payment_response` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `token` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_payments_on_token` (`token`),
  KEY `index_payments_on_created_at` (`created_at`),
  KEY `index_payments_on_created_by_user_id` (`created_by_user_id`),
  KEY `index_payments_on_payment_type_id` (`payment_type_id`),
  KEY `index_payments_on_state` (`state`),
  KEY `index_payments_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `lock_version` int(11) DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_permissions_on_role_id_and_user_id` (`role_id`,`user_id`),
  KEY `index_permissions_on_role_id` (`role_id`),
  KEY `index_permissions_on_updated_by` (`updated_by`),
  KEY `index_permissions_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produce_deliveries`
--

DROP TABLE IF EXISTS `produce_deliveries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `produce_deliveries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `supplier_id` int(11) NOT NULL,
  `produce_id` int(11) NOT NULL,
  `delivered_on` date NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_bulk_deliveries_on_produce_id` (`produce_id`),
  KEY `index_bulk_deliveries_on_supplier_id` (`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produce_deliveries`
--

LOCK TABLES `produce_deliveries` WRITE;
/*!40000 ALTER TABLE `produce_deliveries` DISABLE KEYS */;
/*!40000 ALTER TABLE `produce_deliveries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produces`
--

DROP TABLE IF EXISTS `produces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `produces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `image_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_content_type` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_file_size` int(11) DEFAULT NULL,
  `image_updated_at` datetime DEFAULT NULL,
  `wikipedia` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_produces_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produces`
--

LOCK TABLES `produces` WRITE;
/*!40000 ALTER TABLE `produces` DISABLE KEYS */;
/*!40000 ALTER TABLE `produces` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_deliveries`
--

DROP TABLE IF EXISTS `product_deliveries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_deliveries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `supplier_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `delivered_on` date NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `index_product_deliveries_on_delivered_on` (`delivered_on`),
  KEY `index_product_deliveries_on_product_id` (`product_id`),
  KEY `index_product_deliveries_on_supplier_id` (`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_deliveries`
--

LOCK TABLES `product_deliveries` WRITE;
/*!40000 ALTER TABLE `product_deliveries` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_deliveries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_types`
--

DROP TABLE IF EXISTS `product_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `lock_version` int(11) DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_content_type` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_file_size` int(11) DEFAULT NULL,
  `image_updated_at` datetime DEFAULT NULL,
  `position` int(11) NOT NULL DEFAULT 0,
  `ancestry` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_product_types_on_ancestry` (`ancestry`),
  KEY `index_product_types_on_name` (`name`),
  KEY `index_product_types_on_position` (`position`),
  KEY `index_product_types_on_slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_types`
--

LOCK TABLES `product_types` WRITE;
/*!40000 ALTER TABLE `product_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `product_type_id` int(11) DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_discountable` tinyint(1) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `unit_of_measure_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `lock_version` int(11) DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `abbreviation` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attracts_gst` tinyint(1) NOT NULL DEFAULT 0,
  `price` decimal(8,2) NOT NULL DEFAULT 0.00,
  `image_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_content_type` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_file_size` int(11) DEFAULT NULL,
  `image_updated_at` datetime DEFAULT NULL,
  `short_description` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `jit_supplier_id` int(11) DEFAULT NULL,
  `unlimited` tinyint(1) NOT NULL DEFAULT 1,
  `instock` int(11) NOT NULL DEFAULT 0,
  `warning_level` int(11) NOT NULL DEFAULT 10,
  `is_large` tinyint(1) DEFAULT NULL,
  `packing_station` int(11) DEFAULT NULL,
  `packing_category_id` int(11) DEFAULT NULL,
  `prepacked` tinyint(1) DEFAULT NULL,
  `out_of_stock_message` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `assume_stock_available_in_future` tinyint(1) NOT NULL DEFAULT 0,
  `stock_control_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'regular',
  `parts_quantity` decimal(10,3) NOT NULL DEFAULT 1.000,
  `packing_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `wholesale_price` decimal(8,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_products_on_name` (`name`),
  UNIQUE KEY `index_products_on_packing_name` (`packing_name`),
  KEY `index_products_on_instock` (`instock`),
  KEY `index_products_on_is_active` (`is_active`),
  KEY `index_products_on_supplier_id` (`jit_supplier_id`),
  KEY `index_products_on_packing_category_id` (`packing_category_id`),
  KEY `index_products_on_product_type_id` (`product_type_id`),
  KEY `index_products_on_unlimited` (`unlimited`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products_promotions`
--

DROP TABLE IF EXISTS `products_promotions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products_promotions` (
  `product_id` int(11) DEFAULT NULL,
  `promotion_id` int(11) DEFAULT NULL,
  KEY `index_products_promotions_on_product_id_and_promotion_id` (`product_id`,`promotion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products_promotions`
--

LOCK TABLES `products_promotions` WRITE;
/*!40000 ALTER TABLE `products_promotions` DISABLE KEYS */;
/*!40000 ALTER TABLE `products_promotions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products_secondary_product_types`
--

DROP TABLE IF EXISTS `products_secondary_product_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products_secondary_product_types` (
  `product_id` int(11) DEFAULT NULL,
  `product_type_id` int(11) DEFAULT NULL,
  KEY `index_products_secondary_product_types_on_product_id` (`product_id`),
  KEY `index_products_secondary_product_types_on_product_type_id` (`product_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products_secondary_product_types`
--

LOCK TABLES `products_secondary_product_types` WRITE;
/*!40000 ALTER TABLE `products_secondary_product_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `products_secondary_product_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promotions`
--

DROP TABLE IF EXISTS `promotions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `promotions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `valid_from` datetime DEFAULT NULL,
  `valid_to` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `complete_by` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotions`
--

LOCK TABLES `promotions` WRITE;
/*!40000 ALTER TABLE `promotions` DISABLE KEYS */;
/*!40000 ALTER TABLE `promotions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchase_limits`
--

DROP TABLE IF EXISTS `purchase_limits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `purchase_limits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `limit_type` varchar(12) DEFAULT NULL,
  `maximum` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_purchase_limits_on_product_id_and_limit_type` (`product_id`,`limit_type`),
  KEY `index_purchase_limits_on_product_id` (`product_id`),
  CONSTRAINT `fk_rails_f0939a9f78` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_limits`
--

LOCK TABLES `purchase_limits` WRITE;
/*!40000 ALTER TABLE `purchase_limits` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_limits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `lock_version` int(11) DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20101025120000'),('20101028060204'),('20101028061435'),('20101028065045'),('20101028132438'),('20101029005613'),('20101029013434'),('20101029014424'),('20101029032535'),('20101029032938'),('20101103122940'),('20101103132932'),('20101104042743'),('20101117022540'),('20101206135743'),('20101208040525'),('20101215033821'),('20101215041754'),('20110302141234'),('20110302141616'),('20110309043139'),('20110315150336'),('20110320100113'),('20110320123304'),('20110321125536'),('20110322103753'),('20110322104348'),('20110324033741'),('20110329224338'),('20110331004018'),('20110331051902'),('20110411161651'),('20110413014924'),('20110421004535'),('20110421014133'),('20110427043236'),('20110427052941'),('20110504021942'),('20110504023902'),('20110504043609'),('20110504055509'),('20110504055721'),('20110511020630'),('20110511020933'),('20110511024028'),('20110512081639'),('20110518040610'),('20110518125401'),('20110518131626'),('20110518132538'),('20110518132927'),('20110519001452'),('20110519004335'),('20110519005152'),('20110519051546'),('20110519074938'),('20110522145740'),('20110601013241'),('20110601031706'),('20110601044515'),('20110601052931'),('20110601060918'),('20110601064113'),('20110616131958'),('20110622042649'),('20110623042705'),('20110623045537'),('20110623073912'),('20110623074112'),('20110630002949'),('20110630041041'),('20110630073312'),('20110706013444'),('20110713000336'),('20110715110704'),('20110715112720'),('20110810051916'),('20110811062301'),('20110811071216'),('20110817152612'),('20110818031310'),('20110822031833'),('20110822054731'),('20110822062652'),('20110822073047'),('20111121045131'),('20111122044032'),('20120611021141'),('20120614043016'),('20120711042757'),('20120712024002'),('20120712050913'),('20120713011656'),('20120719003256'),('20120723051315'),('20120803021637'),('20120806064513'),('20120807024603'),('20120815033921'),('20120918023504'),('20120918043747'),('20120918050158'),('20121006234631'),('20121016003515'),('20121120001328'),('20121206040053'),('20121210234215'),('20121219033527'),('20130205002544'),('20130226022445'),('20130507014316'),('20130530015424'),('20130611043252'),('20130618001513'),('20130626011615'),('20130626025208'),('20130724033427'),('20130725002927'),('20130725211916'),('20130726060555'),('20130815030601'),('20130903045357'),('20130904000225'),('20130904041853'),('20130924000931'),('20131029040139'),('20131111014451'),('20131111020730'),('20131111035703'),('20131113020821'),('20131114030336'),('20131125005706'),('20131126021115'),('20131201225831'),('20131209024932'),('20131210035818'),('20131210042549'),('20131211004819'),('20140113001940'),('20140217051354'),('20140304022339'),('20140422020332'),('20140422054842'),('20140422055509'),('20140422062435'),('20140506021614'),('20160503060037'),('20160510050625'),('20160519060158'),('20161201011344'),('20170126002723'),('20170126003627'),('20170126022534'),('20170215051531'),('20170222062331'),('20170302051640'),('20170303051346'),('20170311051717'),('20170316010432'),('20170515163418'),('20170601205207'),('20170606063853'),('20170607041719'),('20170704010406'),('20170906173912'),('20170922070711'),('20171001230443'),('20171109025348'),('20171128185717'),('20171206051619'),('20171214044658'),('20180328210213'),('20180409053621'),('20180410011722'),('20180411045308'),('20180423231654'),('20180503062627'),('20180503072209'),('20180524035937'),('20180524231816'),('20180525070416'),('20181211032356'),('20190104030004'),('20190104031139'),('20190104032120'),('20190528055455'),('20190710061937'),('20190904053757'),('20190904065225'),('20190904071702'),('20190905225540'),('20190910062559'),('20190911042535'),('20190925045610'),('20190925050057'),('20191025003115'),('20191113063051'),('20191113063052'),('20191113063053'),('20191113063054'),('20191128064319'),('20191202034035'),('20191203065357'),('20200128062947'),('20200430055628'),('20200501010115'),('20200623052000'),('20200623053959'),('20200708231807'),('20200724041935'),('20200729062402'),('20200729063652'),('20200806060450'),('20201007034400'),('20201028035153'),('20201118004700'),('20210202001907'),('20210203000318'),('20210310031647'),('20210428062936'),('20210512062904'),('20210514012932'),('20210519014948'),('20210608054117'),('20210608071955'),('20210629004432'),('20210728052707'),('20210914052518'),('20210915232717'),('20211021061832'),('20211021062059'),('20211021232800'),('20211022022253'),('20211025235953'),('20211109004038'),('20211209224409'),('20211214044542'),('20220110003528'),('20220110021108'),('20220112011947'),('20220112030427'),('20220208012517');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stored_credit_cards`
--

DROP TABLE IF EXISTS `stored_credit_cards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stored_credit_cards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `billing_id` varchar(255) NOT NULL,
  `last_digits` varchar(4) DEFAULT NULL,
  `month` tinyint(4) DEFAULT NULL,
  `year` smallint(6) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_stored_credit_cards_on_billing_id` (`billing_id`),
  KEY `fk_rails_3aecbdec81` (`user_id`),
  CONSTRAINT `fk_rails_3aecbdec81` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stored_credit_cards`
--

LOCK TABLES `stored_credit_cards` WRITE;
/*!40000 ALTER TABLE `stored_credit_cards` DISABLE KEYS */;
/*!40000 ALTER TABLE `stored_credit_cards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscriptions`
--

DROP TABLE IF EXISTS `subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subscriptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `deliveries` int(11) NOT NULL DEFAULT 1,
  `frequency` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'weekly',
  `complementary` tinyint(1) NOT NULL DEFAULT 0,
  `correction` tinyint(1) NOT NULL DEFAULT 0,
  `comment` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `cart_id` int(11) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_subscriptions_on_cart_id` (`cart_id`),
  KEY `index_subscriptions_on_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscriptions`
--

LOCK TABLES `subscriptions` WRITE;
/*!40000 ALTER TABLE `subscriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `suppliers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `owners` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `suburb` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `produce` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `kms` int(11) DEFAULT NULL,
  `lat` decimal(8,5) DEFAULT NULL,
  `lng` decimal(8,5) DEFAULT NULL,
  `image_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_content_type` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_file_size` int(11) DEFAULT NULL,
  `image_updated_at` datetime DEFAULT NULL,
  `vimeo_id` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL,
  `interview` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `interview_image_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `interview_image_content_type` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `interview_image_file_size` int(11) DEFAULT NULL,
  `interview_image_updated_at` datetime DEFAULT NULL,
  `hub_id` int(11) DEFAULT NULL,
  `postcode` varchar(4) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cutoff_at` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_suppliers_on_hub_id` (`hub_id`),
  KEY `index_suppliers_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
/*!40000 ALTER TABLE `suppliers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taggings`
--

DROP TABLE IF EXISTS `taggings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taggings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_id` int(11) DEFAULT NULL,
  `taggable_id` int(11) DEFAULT NULL,
  `taggable_type` varchar(255) DEFAULT NULL,
  `tagger_id` int(11) DEFAULT NULL,
  `tagger_type` varchar(255) DEFAULT NULL,
  `context` varchar(128) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `taggings_idx` (`tag_id`,`taggable_id`,`taggable_type`,`context`,`tagger_id`,`tagger_type`),
  KEY `index_taggings_on_context` (`context`),
  KEY `index_taggings_on_tag_id` (`tag_id`),
  KEY `index_taggings_on_taggable_id_and_taggable_type_and_context` (`taggable_id`,`taggable_type`,`context`),
  KEY `taggings_idy` (`taggable_id`,`taggable_type`,`tagger_id`,`context`),
  KEY `index_taggings_on_taggable_id` (`taggable_id`),
  KEY `index_taggings_on_taggable_type` (`taggable_type`),
  KEY `index_taggings_on_tagger_id_and_tagger_type` (`tagger_id`,`tagger_type`),
  KEY `index_taggings_on_tagger_id` (`tagger_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taggings`
--

LOCK TABLES `taggings` WRITE;
/*!40000 ALTER TABLE `taggings` DISABLE KEYS */;
/*!40000 ALTER TABLE `taggings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `taggings_count` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_tags_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unit_of_measures`
--

DROP TABLE IF EXISTS `unit_of_measures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `unit_of_measures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `short_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lock_version` int(11) DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unit_of_measures`
--

LOCK TABLES `unit_of_measures` WRITE;
/*!40000 ALTER TABLE `unit_of_measures` DISABLE KEYS */;
/*!40000 ALTER TABLE `unit_of_measures` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_comments`
--

DROP TABLE IF EXISTS `user_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_by_user_id` int(11) DEFAULT NULL,
  `lock_version` int(11) DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_user_comments_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_comments`
--

LOCK TABLES `user_comments` WRITE;
/*!40000 ALTER TABLE `user_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_flags`
--

DROP TABLE IF EXISTS `user_flags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_flags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_user_flags_on_user_id_and_name` (`user_id`,`name`),
  KEY `index_user_flags_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_flags`
--

LOCK TABLES `user_flags` WRITE;
/*!40000 ALTER TABLE `user_flags` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_flags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `crypted_password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `salt` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `state` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'pending',
  `updated_by` int(11) DEFAULT NULL,
  `address_line_1` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `address_line_2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `suburb` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `postcode` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `delivery_destination_id` int(11) DEFAULT NULL,
  `account_balance_cached` decimal(8,2) DEFAULT 0.00,
  `percentage_discount` mediumint(9) DEFAULT 0,
  `lock_version` int(11) DEFAULT 0,
  `lat` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lng` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email_reminders` tinyint(1) NOT NULL DEFAULT 1,
  `sms_reminders` tinyint(1) NOT NULL DEFAULT 1,
  `persistence_token` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `single_access_token` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `perishable_token` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `login_count` int(11) NOT NULL DEFAULT 0,
  `failed_login_count` int(11) NOT NULL DEFAULT 0,
  `last_request_at` datetime DEFAULT NULL,
  `current_login_at` datetime DEFAULT NULL,
  `last_login_at` datetime DEFAULT NULL,
  `current_login_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_login_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `full_name` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `useragent` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_reminder_at` datetime DEFAULT NULL,
  `driver_directions` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `receives_newsletter` tinyint(1) DEFAULT 1,
  `harmony_full_address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `over_18` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  KEY `index_users_on_delivery_destination_id` (`delivery_destination_id`),
  KEY `index_users_on_full_name` (`full_name`),
  KEY `index_users_on_login` (`login`),
  KEY `index_users_on_state` (`state`),
  KEY `index_users_on_suburb` (`suburb`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicles`
--

DROP TABLE IF EXISTS `vehicles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `make` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `model` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rego` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `height` decimal(10,0) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `maximum_box_number` int(11) DEFAULT NULL,
  `maximum_weight` int(11) DEFAULT NULL,
  `lock_version` int(11) DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicles`
--

LOCK TABLES `vehicles` WRITE;
/*!40000 ALTER TABLE `vehicles` DISABLE KEYS */;
/*!40000 ALTER TABLE `vehicles` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-02-23 10:28:22
