-- MySQL dump 10.13  Distrib 26.7.0, for Win64 (x86_64)
--
-- Host: localhost    Database: ecommerce_db
-- ------------------------------------------------------
-- Server version	26.7.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `ecommerce_db`
--

/*!40000 DROP DATABASE IF EXISTS `ecommerce_db`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `ecommerce_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `ecommerce_db`;

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente` (
  `idCliente` int NOT NULL AUTO_INCREMENT,
  `tipoCliente` enum('PF','PJ') COLLATE utf8mb4_unicode_ci NOT NULL,
  `dataCadastro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idCliente`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (1,'PF','2026-10-28 16:40:14'),(2,'PF','2026-10-28 16:40:14'),(3,'PF','2026-10-28 16:40:14'),(4,'PJ','2026-10-28 16:40:14'),(5,'PJ','2026-10-28 16:40:14');
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cliente_pf`
--

DROP TABLE IF EXISTS `cliente_pf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente_pf` (
  `idCliente` int NOT NULL,
  `Pnome` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Mnome` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Unome` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CPF` char(11) COLLATE utf8mb4_unicode_ci NOT NULL,
  `endereco` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`idCliente`),
  UNIQUE KEY `UNIQUE_CPF_CLIENTE` (`CPF`),
  CONSTRAINT `fk_cliente_pf` FOREIGN KEY (`idCliente`) REFERENCES `cliente` (`idCliente`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente_pf`
--

LOCK TABLES `cliente_pf` WRITE;
/*!40000 ALTER TABLE `cliente_pf` DISABLE KEYS */;
INSERT INTO `cliente_pf` VALUES (1,'Ana','M','Silva','12345678901','Rua das Flores, 10'),(2,'Bruno','A','Costa','23456789012','Avenida Central, 25'),(3,'Carla',NULL,'Santos','34567890123','Rua do Comercio, 8');
/*!40000 ALTER TABLE `cliente_pf` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cliente_pj`
--

DROP TABLE IF EXISTS `cliente_pj`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente_pj` (
  `idCliente` int NOT NULL,
  `razaoSocial` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CNPJ` char(14) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idCliente`),
  UNIQUE KEY `CNPJ` (`CNPJ`),
  CONSTRAINT `fk_cliente_pj` FOREIGN KEY (`idCliente`) REFERENCES `cliente` (`idCliente`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente_pj`
--

LOCK TABLES `cliente_pj` WRITE;
/*!40000 ALTER TABLE `cliente_pj` DISABLE KEYS */;
INSERT INTO `cliente_pj` VALUES (4,'Braga Tech Comercio Digital Lda','45678901234567'),(5,'Norte Distribuicao Online Lda','56789012345678');
/*!40000 ALTER TABLE `cliente_pj` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entrega`
--

DROP TABLE IF EXISTS `entrega`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entrega` (
  `idEntrega` int NOT NULL AUTO_INCREMENT,
  `idPedido` int NOT NULL,
  `statusEntrega` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Em preparação',
  `codigoRastreio` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dataEnvio` datetime DEFAULT NULL,
  `dataEntrega` datetime DEFAULT NULL,
  PRIMARY KEY (`idEntrega`),
  UNIQUE KEY `uq_entrega_pedido` (`idPedido`),
  UNIQUE KEY `uq_entrega_rastreio` (`codigoRastreio`),
  CONSTRAINT `fk_entrega_pedido` FOREIGN KEY (`idPedido`) REFERENCES `pedido` (`idPedido`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entrega`
--

LOCK TABLES `entrega` WRITE;
/*!40000 ALTER TABLE `entrega` DISABLE KEYS */;
INSERT INTO `entrega` VALUES (1,1,'Entregue','PT202610280001','2026-10-25 10:00:00','2026-10-27 15:30:00'),(2,2,'Em preparação',NULL,NULL,NULL),(3,3,'Em transporte','PT202610280003','2026-10-28 09:00:00',NULL),(4,4,'Entregue','PT202610280004','2026-10-24 11:00:00','2026-10-26 16:00:00'),(5,5,'Em preparação',NULL,NULL,NULL);
/*!40000 ALTER TABLE `entrega` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estoque`
--

DROP TABLE IF EXISTS `estoque`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estoque` (
  `idEstoque` int NOT NULL AUTO_INCREMENT,
  `localEstoque` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idEstoque`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estoque`
--

LOCK TABLES `estoque` WRITE;
/*!40000 ALTER TABLE `estoque` DISABLE KEYS */;
INSERT INTO `estoque` VALUES (1,'Armazem Braga'),(2,'Armazem Porto'),(3,'Armazem Guimaraes');
/*!40000 ALTER TABLE `estoque` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fornecedor`
--

DROP TABLE IF EXISTS `fornecedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fornecedor` (
  `idFornecedor` int NOT NULL AUTO_INCREMENT,
  `razaoSocial` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CNPJ` char(14) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idFornecedor`),
  UNIQUE KEY `CNPJ` (`CNPJ`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fornecedor`
--

LOCK TABLES `fornecedor` WRITE;
/*!40000 ALTER TABLE `fornecedor` DISABLE KEYS */;
INSERT INTO `fornecedor` VALUES (1,'Tech Distribuicao Lda','12345678000195'),(2,'Informatica Norte Lda','23456789000196'),(3,'Comercial Digital Lda','34567890000197');
/*!40000 ALTER TABLE `fornecedor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_pedido`
--

DROP TABLE IF EXISTS `item_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_pedido` (
  `idPedido` int NOT NULL,
  `idProduto` int NOT NULL,
  `quantidade` int NOT NULL DEFAULT '1',
  `precoUnitario` decimal(10,2) NOT NULL,
  PRIMARY KEY (`idPedido`,`idProduto`),
  KEY `fk_item_pedido_produto` (`idProduto`),
  CONSTRAINT `fk_item_pedido_pedido` FOREIGN KEY (`idPedido`) REFERENCES `pedido` (`idPedido`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_item_pedido_produto` FOREIGN KEY (`idProduto`) REFERENCES `produto` (`idProduto`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_item_pedido_preco` CHECK ((`precoUnitario` >= 0)),
  CONSTRAINT `chk_item_pedido_quantidade` CHECK ((`quantidade` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_pedido`
--

LOCK TABLES `item_pedido` WRITE;
/*!40000 ALTER TABLE `item_pedido` DISABLE KEYS */;
INSERT INTO `item_pedido` VALUES (1,1,1,649.99),(1,2,1,19.99),(2,3,2,59.90),(3,4,1,149.90),(4,5,1,189.00),(5,6,2,79.99);
/*!40000 ALTER TABLE `item_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_rotina`
--

DROP TABLE IF EXISTS `log_rotina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_rotina` (
  `idLog` int NOT NULL AUTO_INCREMENT,
  `descricao` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dataLog` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idLog`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_rotina`
--

LOCK TABLES `log_rotina` WRITE;
/*!40000 ALTER TABLE `log_rotina` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_rotina` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pagamento`
--

DROP TABLE IF EXISTS `pagamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pagamento` (
  `idPagamento` int NOT NULL AUTO_INCREMENT,
  `idPedido` int NOT NULL,
  `formaPagamento` enum('Cartao de credito','Cartao de debito','Pix','Transferencia bancaria','Dinheiro','MB Way','Multibanco') COLLATE utf8mb4_unicode_ci NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `dataPagamento` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idPagamento`),
  KEY `fk_pagamento_pedido` (`idPedido`),
  CONSTRAINT `fk_pagamento_pedido` FOREIGN KEY (`idPedido`) REFERENCES `pedido` (`idPedido`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_pagamento_valor` CHECK ((`valor` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagamento`
--

LOCK TABLES `pagamento` WRITE;
/*!40000 ALTER TABLE `pagamento` DISABLE KEYS */;
INSERT INTO `pagamento` VALUES (1,1,'MB Way',674.98,'2026-10-28 17:23:35'),(2,2,'Pix',123.30,'2026-10-28 17:23:35'),(3,3,'Cartao de credito',156.90,'2026-10-28 17:23:35'),(4,4,'Transferencia bancaria',195.00,'2026-10-28 17:23:35'),(5,5,'Multibanco',163.98,'2026-10-28 17:23:35');
/*!40000 ALTER TABLE `pagamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido`
--

DROP TABLE IF EXISTS `pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido` (
  `idPedido` int NOT NULL AUTO_INCREMENT,
  `idCliente` int NOT NULL,
  `statusPedido` enum('Em processamento','Em transporte','Entregue','Cancelado') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Em processamento',
  `descricao` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `frete` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`idPedido`),
  KEY `fk_pedido_cliente` (`idCliente`),
  CONSTRAINT `fk_pedido_cliente` FOREIGN KEY (`idCliente`) REFERENCES `cliente` (`idCliente`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido`
--

LOCK TABLES `pedido` WRITE;
/*!40000 ALTER TABLE `pedido` DISABLE KEYS */;
INSERT INTO `pedido` VALUES (1,1,'Entregue','Compra de portatil e rato',5.00),(2,2,'Em processamento','Compra de teclado mecanico',3.50),(3,3,'Em transporte','Compra de monitor',7.00),(4,4,'Entregue','Compra de cadeira ergonomica',6.00),(5,5,'Em processamento','Compra de auscultadores',4.00);
/*!40000 ALTER TABLE `pedido` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
/*!50032 DROP TRIGGER IF EXISTS trg_pedido_status_auditoria */;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_pedido_status_auditoria` BEFORE UPDATE ON `pedido` FOR EACH ROW BEGIN
  IF NEW.statusPedido <> OLD.statusPedido THEN
    INSERT INTO pedido_auditoria (idPedido, statusAnterior, statusNovo)
    VALUES (OLD.idPedido, OLD.statusPedido, NEW.statusPedido);
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `pedido_auditoria`
--

DROP TABLE IF EXISTS `pedido_auditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido_auditoria` (
  `idAuditoria` int NOT NULL AUTO_INCREMENT,
  `idPedido` int NOT NULL,
  `statusAnterior` enum('Em processamento','Em transporte','Entregue','Cancelado') COLLATE utf8mb4_unicode_ci NOT NULL,
  `statusNovo` enum('Em processamento','Em transporte','Entregue','Cancelado') COLLATE utf8mb4_unicode_ci NOT NULL,
  `dataAlteracao` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idAuditoria`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido_auditoria`
--

LOCK TABLES `pedido_auditoria` WRITE;
/*!40000 ALTER TABLE `pedido_auditoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedido_auditoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produto`
--

DROP TABLE IF EXISTS `produto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produto` (
  `idProduto` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `categoria` enum('Eletronico','Acessorios','Moveis','Audio','Vestimenta','Brinquedos','Alimentos') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descricao` text COLLATE utf8mb4_unicode_ci,
  `valor` decimal(10,2) NOT NULL,
  PRIMARY KEY (`idProduto`),
  CONSTRAINT `chk_produto_valor` CHECK ((`valor` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produto`
--

LOCK TABLES `produto` WRITE;
/*!40000 ALTER TABLE `produto` DISABLE KEYS */;
INSERT INTO `produto` VALUES (1,'Portatil Lenovo IdeaPad','Eletronico','Portatil para trabalho e estudo',649.99),(2,'Rato Logitech M185','Eletronico','Rato sem fios',19.99),(3,'Teclado mecanico Redragon','Eletronico','Teclado mecanico para computador',59.90),(4,'Monitor Samsung 24 polegadas','Eletronico','Monitor Full HD',149.90),(5,'Cadeira ergonomica Office','Moveis','Cadeira para escritorio',189.00),(6,'Auscultadores JBL','Eletronico','Auscultadores com ligacao Bluetooth',79.99);
/*!40000 ALTER TABLE `produto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produto_has_estoque`
--

DROP TABLE IF EXISTS `produto_has_estoque`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produto_has_estoque` (
  `idProduto` int NOT NULL,
  `idEstoque` int NOT NULL,
  `quantidade` int NOT NULL DEFAULT '0',
  `statusEstoque` enum('Disponivel','Reservado','Indisponivel') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Disponivel',
  PRIMARY KEY (`idProduto`,`idEstoque`),
  KEY `fk_phe_estoque` (`idEstoque`),
  CONSTRAINT `fk_phe_estoque` FOREIGN KEY (`idEstoque`) REFERENCES `estoque` (`idEstoque`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_phe_produto` FOREIGN KEY (`idProduto`) REFERENCES `produto` (`idProduto`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_phe_quantidade` CHECK ((`quantidade` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produto_has_estoque`
--

LOCK TABLES `produto_has_estoque` WRITE;
/*!40000 ALTER TABLE `produto_has_estoque` DISABLE KEYS */;
INSERT INTO `produto_has_estoque` VALUES (1,1,12,'Disponivel'),(1,2,5,'Disponivel'),(2,1,20,'Disponivel'),(2,3,0,'Indisponivel'),(3,2,15,'Disponivel'),(4,1,8,'Disponivel'),(5,3,6,'Disponivel'),(6,2,10,'Disponivel');
/*!40000 ALTER TABLE `produto_has_estoque` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produto_has_fornecedor`
--

DROP TABLE IF EXISTS `produto_has_fornecedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produto_has_fornecedor` (
  `idProduto` int NOT NULL,
  `idFornecedor` int NOT NULL,
  PRIMARY KEY (`idProduto`,`idFornecedor`),
  KEY `fk_phf_fornecedor` (`idFornecedor`),
  CONSTRAINT `fk_phf_fornecedor` FOREIGN KEY (`idFornecedor`) REFERENCES `fornecedor` (`idFornecedor`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_phf_produto` FOREIGN KEY (`idProduto`) REFERENCES `produto` (`idProduto`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produto_has_fornecedor`
--

LOCK TABLES `produto_has_fornecedor` WRITE;
/*!40000 ALTER TABLE `produto_has_fornecedor` DISABLE KEYS */;
INSERT INTO `produto_has_fornecedor` VALUES (1,1),(4,1),(1,2),(2,2),(3,2),(5,3),(6,3);
/*!40000 ALTER TABLE `produto_has_fornecedor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtos_por_vendedor`
--

DROP TABLE IF EXISTS `produtos_por_vendedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produtos_por_vendedor` (
  `idProduto` int NOT NULL,
  `idTerceiroVendedor` int NOT NULL,
  `quantidade` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`idProduto`,`idTerceiroVendedor`),
  KEY `fk_pv_vendedor` (`idTerceiroVendedor`),
  CONSTRAINT `fk_pv_produto` FOREIGN KEY (`idProduto`) REFERENCES `produto` (`idProduto`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pv_vendedor` FOREIGN KEY (`idTerceiroVendedor`) REFERENCES `terceiro_vendedor` (`idTerceiroVendedor`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_pv_quantidade` CHECK ((`quantidade` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos_por_vendedor`
--

LOCK TABLES `produtos_por_vendedor` WRITE;
/*!40000 ALTER TABLE `produtos_por_vendedor` DISABLE KEYS */;
INSERT INTO `produtos_por_vendedor` VALUES (1,1,10),(1,2,5),(2,1,25),(2,3,0),(3,2,12),(4,1,8),(5,3,4),(6,2,15);
/*!40000 ALTER TABLE `produtos_por_vendedor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `terceiro_vendedor`
--

DROP TABLE IF EXISTS `terceiro_vendedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `terceiro_vendedor` (
  `idTerceiroVendedor` int NOT NULL AUTO_INCREMENT,
  `RazaoSocial` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Local` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NomeFantasia` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Endereco` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`idTerceiroVendedor`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `terceiro_vendedor`
--

LOCK TABLES `terceiro_vendedor` WRITE;
/*!40000 ALTER TABLE `terceiro_vendedor` DISABLE KEYS */;
INSERT INTO `terceiro_vendedor` VALUES (1,'Marketplace Norte Lda','Braga','Norte Tech','Rua Central, 15'),(2,'Comercio Digital Porto Lda','Porto','Digital Porto','Avenida da Boavista, 100'),(3,'Distribuicao Minho Lda','Guimaraes','Minho Store','Rua de Santo Antonio, 20');
/*!40000 ALTER TABLE `terceiro_vendedor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_today`
--

DROP TABLE IF EXISTS `v_today`;
/*!50001 DROP VIEW IF EXISTS `v_today`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_today` AS SELECT 
 1 AS `Today`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'ecommerce_db'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `evt_rotina_diaria` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `evt_rotina_diaria` ON SCHEDULE EVERY 1 DAY STARTS '2026-11-24 00:00:00' ON COMPLETION NOT PRESERVE ENABLE DO INSERT INTO log_rotina (idLog, descricao, dataLog)
  VALUES (1, 'Rotina diaria executada com sucesso', NOW())
  ON DUPLICATE KEY UPDATE descricao = VALUES(descricao), dataLog = VALUES(dataLog) */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'ecommerce_db'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_criar_pedido` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_criar_pedido`(
  IN p_idCliente   INT,
  IN p_idProduto   INT,
  IN p_qtd         INT,
  IN p_freteGratis TINYINT   -- 1 = cliente solicita frete grátis
)
BEGIN
  DECLARE v_cliente INT;
  DECLARE v_preco   DECIMAL(10,2);
  DECLARE v_pedido  INT;
  DECLARE v_total   DECIMAL(10,2);
  DECLARE v_frete   DECIMAL(10,2) DEFAULT 15.90;  -- frete padrão

  -- --------------------------------------------------------
  -- VERIFICAÇÃO DE ERRO 1 — qualquer exceção SQL
  -- (coluna NOT NULL, FK violada, tipo inválido...)
  -- → ROLLBACK TOTAL: nada é persistido
  -- --------------------------------------------------------
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SELECT 'ERRO SQL: transacao revertida (ROLLBACK total)' AS resultado;
  END;

  START TRANSACTION;

    -- validações por consulta ANTES de gravar qualquer coisa
    -- (SELECT sem linhas gera aviso 1329 e a variável fica NULL)
    SELECT idCliente INTO v_cliente
    FROM cliente WHERE idCliente = p_idCliente;

    SELECT valor INTO v_preco
    FROM produto WHERE idProduto = p_idProduto;

    IF v_cliente IS NULL OR v_preco IS NULL THEN
      -- VERIFICAÇÃO DE ERRO 2 — regra de negócio
      ROLLBACK;
      SELECT 'ERRO: cliente ou produto inexistente (ROLLBACK total)' AS resultado;

    ELSE
      -- ---------- grupo A: operações essenciais ----------
      INSERT INTO pedido (idCliente, statusPedido, descricao, frete)
      VALUES (p_idCliente, 'Em processamento',
              'Pedido criado pela procedure sp_criar_pedido', v_frete);

      SET v_pedido = LAST_INSERT_ID();

      INSERT INTO item_pedido (idPedido, idProduto, quantidade, precoUnitario)
      VALUES (v_pedido, p_idProduto, p_qtd, v_preco);

      SET v_total = p_qtd * v_preco;

      -- ---------- grupo B: trecho arriscado (frete grátis) ----------
      IF p_freteGratis = 1 THEN

        -- PONTO DE SEGURANÇA: a partir daqui, dá para
        -- desfazer SÓ este trecho e manter o pedido
        SAVEPOINT sp_antes_frete;

          UPDATE pedido SET frete = 0.00 WHERE idPedido = v_pedido;

          IF v_total < 100.00 THEN
            -- VERIFICAÇÃO DE ERRO 3 — regra "frete grátis
            -- só para pedidos >= R$ 100"
            -- → ROLLBACK PARCIAL: desfaz apenas a tentativa
            --   de frete; o pedido criado acima do savepoint
            --   é MANTIDO
            ROLLBACK TO SAVEPOINT sp_antes_frete;

            SELECT CONCAT('REGRA: frete gratis negado (total R$ ',
                          FORMAT(v_total, 2), ' < R$ 100,00) — ',
                          'ROLLBACK parcial; pedido ', v_pedido,
                          ' mantido com frete padrao') AS resultado;
          ELSE
            SELECT CONCAT('REGRA: frete gratis concedido ao pedido ',
                          v_pedido, ' (total R$ ', FORMAT(v_total, 2),
                          ' >= R$ 100,00)') AS resultado;
          END IF;

      END IF;

      COMMIT;   -- persiste o pedido (frete padrão ou grátis)

      SELECT CONCAT('OK: pedido ', v_pedido, ' confirmado — total R$ ',
                    FORMAT(v_total, 2), ', frete R$ ',
                    (SELECT frete FROM pedido WHERE idPedido = v_pedido))
      AS resultado;
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Current Database: `first_example`
--

/*!40000 DROP DATABASE IF EXISTS `first_example`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `first_example` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `first_example`;

--
-- Table structure for table `favorite_food`
--

DROP TABLE IF EXISTS `favorite_food`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorite_food` (
  `person_id` smallint unsigned NOT NULL,
  `food` varchar(20) NOT NULL,
  PRIMARY KEY (`person_id`,`food`),
  CONSTRAINT `fk_favorite_food_person_id` FOREIGN KEY (`person_id`) REFERENCES `person` (`person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorite_food`
--

LOCK TABLES `favorite_food` WRITE;
/*!40000 ALTER TABLE `favorite_food` DISABLE KEYS */;
/*!40000 ALTER TABLE `favorite_food` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `person`
--

DROP TABLE IF EXISTS `person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person` (
  `person_id` smallint unsigned NOT NULL,
  `fname` varchar(20) DEFAULT NULL,
  `lname` varchar(20) DEFAULT NULL,
  `gender` enum('M','F','O') DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `street` varchar(40) DEFAULT NULL,
  `city` varchar(25) DEFAULT NULL,
  `state` varchar(20) DEFAULT NULL,
  `country` varchar(20) DEFAULT NULL,
  `postal_code` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `person`
--

LOCK TABLES `person` WRITE;
/*!40000 ALTER TABLE `person` DISABLE KEYS */;
INSERT INTO `person` VALUES (0,'Gustavo','Sousa','M','1984-08-21','Sá de Miranda','Braga','Braga','POrtugal','4700-352'),(1,'Lucilene','Sousa','F','1988-06-29','Sá de Miranda','Braga','Braga','Portugal','4700-352');
/*!40000 ALTER TABLE `person` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'first_example'
--

--
-- Dumping routines for database 'first_example'
--

--
-- Current Database: `oficina_mecanica`
--

/*!40000 DROP DATABASE IF EXISTS `oficina_mecanica`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `oficina_mecanica` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `oficina_mecanica`;

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente` (
  `id_cliente` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(120) NOT NULL,
  `nif` char(9) NOT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `endereco` varchar(200) DEFAULT NULL,
  `data_cadastro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cliente`),
  UNIQUE KEY `nif` (`nif`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (1,'Ana Martins','245681903','+351912345601','ana.martins@example.com','Braga','2026-10-28 19:48:45'),(2,'Bruno Costa','198765432','+351912345602','bruno.costa@example.com','Guimaraes','2026-10-28 19:48:45'),(3,'Carla Ferreira','276543819','+351912345603','carla.ferreira@example.com','Vila Verde','2026-10-28 19:48:45'),(4,'Daniel Sousa','231456789','+351912345604','daniel.sousa@example.com','Braga','2026-10-28 19:48:45'),(5,'Eva Ribeiro','289123456','+351912345605','eva.ribeiro@example.com','Barcelos','2026-10-28 19:48:45');
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `equipe_mecanico`
--

DROP TABLE IF EXISTS `equipe_mecanico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `equipe_mecanico` (
  `id_equipe` int NOT NULL,
  `id_mecanico` int NOT NULL,
  `data_entrada` date NOT NULL DEFAULT (curdate()),
  PRIMARY KEY (`id_equipe`,`id_mecanico`),
  KEY `fk_em_mecanico` (`id_mecanico`),
  CONSTRAINT `fk_em_equipe` FOREIGN KEY (`id_equipe`) REFERENCES `equipe_mecanicos` (`id_equipe`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_em_mecanico` FOREIGN KEY (`id_mecanico`) REFERENCES `mecanico` (`id_mecanico`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `equipe_mecanico`
--

LOCK TABLES `equipe_mecanico` WRITE;
/*!40000 ALTER TABLE `equipe_mecanico` DISABLE KEYS */;
INSERT INTO `equipe_mecanico` VALUES (1,1,'2021-04-12'),(1,2,'2022-06-01'),(2,2,'2022-06-01'),(2,3,'2020-09-15'),(3,1,'2021-04-12'),(3,4,'2023-02-20');
/*!40000 ALTER TABLE `equipe_mecanico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `equipe_mecanicos`
--

DROP TABLE IF EXISTS `equipe_mecanicos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `equipe_mecanicos` (
  `id_equipe` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(80) NOT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_equipe`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `equipe_mecanicos`
--

LOCK TABLES `equipe_mecanicos` WRITE;
/*!40000 ALTER TABLE `equipe_mecanicos` DISABLE KEYS */;
INSERT INTO `equipe_mecanicos` VALUES (1,'Equipa Alfa','Diagnostico e manutencao geral'),(2,'Equipa Beta','Travagem e mecanica'),(3,'Equipa Gama','Eletricidade e diagnostico');
/*!40000 ALTER TABLE `equipe_mecanicos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mao_obra_os`
--

DROP TABLE IF EXISTS `mao_obra_os`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mao_obra_os` (
  `id_ordem` int NOT NULL,
  `id_servico` int NOT NULL,
  `quantidade` int NOT NULL DEFAULT '1',
  `preco_unitario` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_ordem`,`id_servico`),
  KEY `fk_mo_servico` (`id_servico`),
  CONSTRAINT `fk_mo_ordem` FOREIGN KEY (`id_ordem`) REFERENCES `ordem_servico` (`id_ordem`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_mo_servico` FOREIGN KEY (`id_servico`) REFERENCES `servico` (`id_servico`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_mao_obra_preco` CHECK ((`preco_unitario` >= 0)),
  CONSTRAINT `chk_mao_obra_quantidade` CHECK ((`quantidade` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mao_obra_os`
--

LOCK TABLES `mao_obra_os` WRITE;
/*!40000 ALTER TABLE `mao_obra_os` DISABLE KEYS */;
INSERT INTO `mao_obra_os` VALUES (1,1,1,65.00),(1,2,1,120.00),(2,2,1,120.00),(2,3,1,85.00),(3,4,1,45.00),(4,4,1,45.00),(4,5,1,35.00),(5,3,1,85.00),(6,2,1,120.00),(6,6,1,40.00);
/*!40000 ALTER TABLE `mao_obra_os` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mecanico`
--

DROP TABLE IF EXISTS `mecanico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mecanico` (
  `id_mecanico` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(120) NOT NULL,
  `nif` char(9) DEFAULT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `especialidade` varchar(100) DEFAULT NULL,
  `data_admissao` date DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_mecanico`),
  UNIQUE KEY `nif` (`nif`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mecanico`
--

LOCK TABLES `mecanico` WRITE;
/*!40000 ALTER TABLE `mecanico` DISABLE KEYS */;
INSERT INTO `mecanico` VALUES (1,'Rui Almeida','201234567','+351913000001','rui.almeida@oficina.example','Diagnostico','2021-04-12',1),(2,'Sofia Mendes','202345678','+351913000002','sofia.mendes@oficina.example','Mecanica geral','2022-06-01',1),(3,'Tiago Lopes','203456789','+351913000003','tiago.lopes@oficina.example','Travagem','2020-09-15',1),(4,'Ines Carvalho','204567891','+351913000004','ines.carvalho@oficina.example','Eletricidade auto','2023-02-20',1);
/*!40000 ALTER TABLE `mecanico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ordem_servico`
--

DROP TABLE IF EXISTS `ordem_servico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordem_servico` (
  `id_ordem` int NOT NULL AUTO_INCREMENT,
  `id_veiculo` int NOT NULL,
  `id_equipe` int NOT NULL,
  `id_mecanico_responsavel` int NOT NULL,
  `data_abertura` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `data_previsao` date DEFAULT NULL,
  `data_conclusao` datetime DEFAULT NULL,
  `estado` enum('Aberta','Em diagnostico','Aguardando aprovacao','Em execucao','Concluida','Entregue','Cancelada') NOT NULL DEFAULT 'Aberta',
  `descricao_problema` text NOT NULL,
  `observacoes` text,
  PRIMARY KEY (`id_ordem`),
  KEY `fk_os_veiculo` (`id_veiculo`),
  KEY `fk_os_equipe` (`id_equipe`),
  KEY `fk_os_mecanico` (`id_mecanico_responsavel`),
  CONSTRAINT `fk_os_equipe` FOREIGN KEY (`id_equipe`) REFERENCES `equipe_mecanicos` (`id_equipe`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_os_mecanico` FOREIGN KEY (`id_mecanico_responsavel`) REFERENCES `mecanico` (`id_mecanico`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_os_veiculo` FOREIGN KEY (`id_veiculo`) REFERENCES `veiculo` (`id_veiculo`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_os_datas` CHECK (((`data_conclusao` is null) or (`data_conclusao` >= `data_abertura`)))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordem_servico`
--

LOCK TABLES `ordem_servico` WRITE;
/*!40000 ALTER TABLE `ordem_servico` DISABLE KEYS */;
INSERT INTO `ordem_servico` VALUES (1,1,1,1,'2026-10-01 09:00:00','2026-10-02','2026-10-02 15:30:00','Entregue','Revisao periodica e mudanca de oleo','Veiculo entregue ao cliente.'),(2,3,2,3,'2026-10-04 10:15:00','2026-10-06',NULL,'Em execucao','Ruido ao travar','Aguardar verificacao final.'),(3,2,1,2,'2026-10-10 08:30:00','2026-10-11',NULL,'Aguardando aprovacao','Luz de avaria acesa no painel','Orcamento enviado ao cliente.'),(4,4,3,4,'2026-10-12 11:00:00','2026-10-12','2026-10-12 16:00:00','Entregue','Problema de bateria e arranque','Bateria substituida.'),(5,5,2,3,'2026-10-15 14:00:00','2026-10-17',NULL,'Aberta','Revisao dos travoes','Aguardando diagnostico inicial.'),(6,6,1,1,'2026-10-20 09:20:00','2026-10-21',NULL,'Em diagnostico','Consumo de combustivel elevado','Realizar diagnostico e revisao.');
/*!40000 ALTER TABLE `ordem_servico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pagamento`
--

DROP TABLE IF EXISTS `pagamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pagamento` (
  `id_pagamento` int NOT NULL AUTO_INCREMENT,
  `id_ordem` int NOT NULL,
  `data_pagamento` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `forma_pagamento` enum('Cartao','MB Way','Dinheiro','Transferencia','Multibanco') NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `estado` enum('Pendente','Pago','Reembolsado','Falhado') NOT NULL DEFAULT 'Pendente',
  `referencia` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_pagamento`),
  KEY `fk_pagamento_ordem` (`id_ordem`),
  CONSTRAINT `fk_pagamento_ordem` FOREIGN KEY (`id_ordem`) REFERENCES `ordem_servico` (`id_ordem`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_pagamento_valor` CHECK ((`valor` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagamento`
--

LOCK TABLES `pagamento` WRITE;
/*!40000 ALTER TABLE `pagamento` DISABLE KEYS */;
INSERT INTO `pagamento` VALUES (1,1,'2026-10-02 15:00:00','Cartao',244.90,'Pago','PAG-OS-001'),(2,1,'2026-10-02 15:05:00','MB Way',35.00,'Pago','PAG-OS-001-B'),(3,2,'2026-10-05 12:00:00','Transferencia',100.00,'Pago','PAG-OS-002-A'),(4,3,'2026-10-10 10:00:00','Multibanco',54.90,'Pendente','PAG-OS-003'),(5,4,'2026-10-12 15:45:00','Cartao',172.00,'Pago','PAG-OS-004');
/*!40000 ALTER TABLE `pagamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `peca`
--

DROP TABLE IF EXISTS `peca`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `peca` (
  `id_peca` int NOT NULL AUTO_INCREMENT,
  `referencia` varchar(40) NOT NULL,
  `nome` varchar(120) NOT NULL,
  `fabricante` varchar(100) DEFAULT NULL,
  `preco_unitario` decimal(10,2) NOT NULL,
  `quantidade_stock` int NOT NULL DEFAULT '0',
  `stock_minimo` int NOT NULL DEFAULT '0',
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_peca`),
  UNIQUE KEY `referencia` (`referencia`),
  CONSTRAINT `chk_peca_preco` CHECK ((`preco_unitario` >= 0)),
  CONSTRAINT `chk_peca_stock` CHECK ((`quantidade_stock` >= 0)),
  CONSTRAINT `chk_peca_stock_minimo` CHECK ((`stock_minimo` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `peca`
--

LOCK TABLES `peca` WRITE;
/*!40000 ALTER TABLE `peca` DISABLE KEYS */;
INSERT INTO `peca` VALUES (1,'OLEO-5W30','Oleo motor 5W30 (litro)','TotalEnergies',12.50,40,10,1),(2,'FILTRO-OLEO-01','Filtro de oleo','Bosch',9.90,18,5,1),(3,'PASTILHA-FRT-01','Jogo de pastilhas dianteiras','ATE',48.00,8,3,1),(4,'BATERIA-60AH','Bateria 60Ah','Varta',92.00,4,2,1),(5,'FILTRO-AR-01','Filtro de ar','Mann',16.50,2,4,1),(6,'LAMPADA-H7','Lampada H7','Philips',8.00,15,5,1);
/*!40000 ALTER TABLE `peca` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `peca_os`
--

DROP TABLE IF EXISTS `peca_os`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `peca_os` (
  `id_ordem` int NOT NULL,
  `id_peca` int NOT NULL,
  `quantidade` int NOT NULL,
  `preco_unitario` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_ordem`,`id_peca`),
  KEY `fk_po_peca` (`id_peca`),
  CONSTRAINT `fk_po_ordem` FOREIGN KEY (`id_ordem`) REFERENCES `ordem_servico` (`id_ordem`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_po_peca` FOREIGN KEY (`id_peca`) REFERENCES `peca` (`id_peca`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_peca_os_preco` CHECK ((`preco_unitario` >= 0)),
  CONSTRAINT `chk_peca_os_quantidade` CHECK ((`quantidade` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `peca_os`
--

LOCK TABLES `peca_os` WRITE;
/*!40000 ALTER TABLE `peca_os` DISABLE KEYS */;
INSERT INTO `peca_os` VALUES (1,1,4,12.50),(1,2,1,9.90),(2,3,1,48.00),(3,2,1,9.90),(4,4,1,92.00),(5,3,1,48.00),(6,5,1,16.50),(6,6,2,8.00);
/*!40000 ALTER TABLE `peca_os` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `servico`
--

DROP TABLE IF EXISTS `servico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `servico` (
  `id_servico` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(120) NOT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `preco_base` decimal(10,2) NOT NULL,
  `tempo_estimado_min` int NOT NULL DEFAULT '60',
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_servico`),
  UNIQUE KEY `nome` (`nome`),
  CONSTRAINT `chk_servico_preco` CHECK ((`preco_base` >= 0)),
  CONSTRAINT `chk_servico_tempo` CHECK ((`tempo_estimado_min` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servico`
--

LOCK TABLES `servico` WRITE;
/*!40000 ALTER TABLE `servico` DISABLE KEYS */;
INSERT INTO `servico` VALUES (1,'Mudanca de oleo','Substituicao de oleo e verificacao basica',65.00,45,1),(2,'Revisao geral','Inspecao preventiva do veiculo',120.00,120,1),(3,'Substituicao de pastilhas','Substituicao de pastilhas de travoes',85.00,90,1),(4,'Diagnostico eletronico','Leitura e analise de codigos de avaria',45.00,40,1),(5,'Substituicao de bateria','Remocao e instalacao de bateria',35.00,30,1),(6,'Alinhamento de direcao','Alinhamento das rodas dianteiras',40.00,45,1);
/*!40000 ALTER TABLE `servico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `veiculo`
--

DROP TABLE IF EXISTS `veiculo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `veiculo` (
  `id_veiculo` int NOT NULL AUTO_INCREMENT,
  `id_cliente` int NOT NULL,
  `matricula` varchar(12) NOT NULL,
  `marca` varchar(60) NOT NULL,
  `modelo` varchar(80) NOT NULL,
  `ano_fabrico` year DEFAULT NULL,
  `vin` varchar(17) DEFAULT NULL,
  `quilometragem` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_veiculo`),
  UNIQUE KEY `matricula` (`matricula`),
  UNIQUE KEY `vin` (`vin`),
  KEY `fk_veiculo_cliente` (`id_cliente`),
  CONSTRAINT `fk_veiculo_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_veiculo_quilometragem` CHECK ((`quilometragem` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `veiculo`
--

LOCK TABLES `veiculo` WRITE;
/*!40000 ALTER TABLE `veiculo` DISABLE KEYS */;
INSERT INTO `veiculo` VALUES (1,1,'12-AB-34','Renault','Clio',2018,'VF1RJA00012345678',78500),(2,1,'45-CD-67','Peugeot','308',2020,'VF3LBB00023456789',52300),(3,2,'23-EF-45','Volkswagen','Golf',2017,'WVWZZZ1KZHW123456',112000),(4,3,'67-GH-89','Toyota','Yaris',2021,'VNKKD3D300A123456',34800),(5,4,'89-IJ-01','BMW','320d',2016,'WBA8E11070K123456',145000),(6,5,'10-KL-23','Ford','Focus',2019,'WF0NXXGCHNKA12345',69000);
/*!40000 ALTER TABLE `veiculo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'oficina_mecanica'
--

--
-- Dumping routines for database 'oficina_mecanica'
--

--
-- Current Database: `ecommerce_db`
--

USE `ecommerce_db`;

--
-- Final view structure for view `v_today`
--

/*!50001 DROP VIEW IF EXISTS `v_today`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_today` (`Today`) AS select curdate() AS `current_date()` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Current Database: `first_example`
--

USE `first_example`;

--
-- Current Database: `oficina_mecanica`
--

USE `oficina_mecanica`;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-23 21:19:26
