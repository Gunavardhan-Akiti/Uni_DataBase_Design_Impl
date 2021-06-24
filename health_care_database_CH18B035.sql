-- MySQL dump 10.13  Distrib 5.7.19, for Win64 (x86_64)
--
-- Host: localhost    Database: health_care
-- ------------------------------------------------------
-- Server version	5.7.19-log

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

create database if not exists health_care;
use health_care;

--
-- Table structure for table employee
--

DROP TABLE IF EXISTS employee;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE employee (
  empId varchar(8) NOT NULL,
  name varchar(50) DEFAULT NULL,
  age decimal(3,0) DEFAULT NULL,
  join_year decimal(4, 0) DEFAULT NULL,
  phone_no decimal(10,0) DEFAULT NULL,
  carecenterId decimal(3,0) DEFAULT NULL,
  PRIMARY KEY (empId),
  FOREIGN KEY (carecenterId) REFERENCES carecenter (Id)
) ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table employee
--

-- -- LOCK TABLES course WRITE;
/*!40000 ALTER TABLE employee DISABLE KEYS */;
INSERT INTO employee VALUES 
('C18P101', 'Gunavardhan', 21, 2018, 7416173741, 1),
('U16P501', 'Vishnu', 25, 2016, 8478102931, 5),
('R10P141', 'Anand', 30, 2010, 9947128383, 4),
('C11P102', 'Vishal', 34, 2011, 7338122313, 1),
('G12P201', 'Mrnalika', 36, 2012, 9494283131, 2),
('O13P130', 'Veda', 26, 2013, 9918001313, 3),
('R14P041', 'Shashank', 24, 2014, 9911223344, 4),
('N15P501', 'Shruthi', 21, 2015, 882234123, 6),
('N17P511', 'Sunny', 39, 2017, 8474741212, 6),
('O19P181', 'Jugal', 35, 2019, 9966331122, 3);
/*!40000 ALTER TABLE employee ENABLE KEYS */;
-- -- UNLOCK TABLES;

--
-- Table structure for table assigns
--

DROP TABLE IF EXISTS assigns;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE assigns (
  empId varchar(8) NOT NULL,
  carecenterId decimal(3, 0) NOT NULL,
  assigned_time decimal(2, 0) DEFAULT NULL,
  PRIMARY KEY (empId, carecenterId),
  FOREIGN KEY (empId) REFERENCES employee (empId),
  FOREIGN KEY (carecenterId) REFERENCES carecenter (Id)
) ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table assigns
--

-- LOCK TABLES assigns WRITE;
/*!40000 ALTER TABLE assigns DISABLE KEYS */;
INSERT INTO assigns VALUES ('C18P101', 1, 9),('U16P501', 5, 6),('R10P141', 4, 8),('C11P102', 1, 10),('G12P201', 2, 9),('O13P130', 3, 9),('R14P041', 4, 7),('N15P501', 6, 9),('N17P511', 6, 10),('O19P181', 3, 12);
/*!40000 ALTER TABLE assigns ENABLE KEYS */;
-- UNLOCK TABLES;

--
-- Table structure for table carecenter
--

DROP TABLE IF EXISTS carecenter;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE carecenter (
  Id decimal(3, 0) NOT NULL,
  name varchar(50) DEFAULT NULL,
  incharge_Id varchar(8) DEFAULT NULL,
  PRIMARY KEY (Id),
  FOREIGN KEY (incharge_Id) REFERENCES employee (empId) ON DELETE SET NULL
) ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table carecenter
--

-- LOCK TABLES carecenter WRITE;
/*!40000 ALTER TABLE carecenter DISABLE KEYS */;
INSERT INTO carecenter VALUES
(1, 'Cardiology', 'C18P101'),
(2, 'Gastroenterology', 'G12P201'),
(3, 'Orthopaedics', 'O13P130'),
(4, 'Rheumatology', 'R14P041'),
(5, 'Urology', 'U16P501'),
(6, 'Nephrology', 'N15P501');
/*!40000 ALTER TABLE carecenter ENABLE KEYS */;
-- UNLOCK TABLES;

--
-- Table structure for table carecenter
--

DROP TABLE IF EXISTS bed;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE bed (
  carecenterId decimal(3, 0) NOT NULL,
  bed_no decimal(4, 0) NOT NULL,
  room_no decimal(4, 0) NOT NULL,
  PRIMARY KEY (carecenterId, bed_no, room_no),
  FOREIGN KEY (carecenterId) REFERENCES carecenter (Id)
) ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table bed
--

-- LOCK TABLES bed WRITE;
/*!40000 ALTER TABLE bed DISABLE KEYS */;
INSERT INTO bed VALUES (1, 1001, 101),(1, 1002, 101),(1, 1003, 101),(1, 2001, 102),(1, 2002, 102),(1, 3001, 103),(1, 4001, 104),(2, 1001, 101),(2, 1002, 101),(2, 1003, 101),(2, 2001, 102),(2, 2002, 102),(2, 3001, 103),(2, 4001, 104),(3, 1001, 101),(3, 1002, 101),(3, 1003, 101),(3, 2001, 102),(3, 2002, 102),(3, 3001, 103),(3, 4001, 104),(4, 1001, 101),(4, 1002, 101),(4, 1003, 101),(4, 2001, 102),(4, 2002, 102),(4, 3001, 103),(4, 4001, 104),(5, 1001, 101),(5, 1002, 101),(5, 1003, 101),(5, 2001, 102),(5, 2002, 102),(5, 3001, 103),(5, 4001, 104),(6, 1001, 101),(6, 1002, 101),(6, 1003, 101),(6, 2001, 102),(6, 2002, 102),(6, 3001, 103),(6, 4001, 104);
/*!40000 ALTER TABLE bed ENABLE KEYS */;
-- UNLOCK TABLES;


--
-- Table structure for table patient
--

DROP TABLE IF EXISTS patient;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE patient (
  patientId decimal(8, 0) NOT NULL,
  name varchar(20) DEFAULT NULL,
  sex varchar(6) DEFAULT NULL,
  admit_date decimal(9,0) DEFAULT NULL,
  dis_date decimal(9, 0) DEFAULT NULL,
  physicianId decimal(8, 0) DEFAULT NULL,
  ccId decimal(3,0) DEFAULT NULL,
  bed_no decimal(4, 0) DEFAULT NULL,
  room_no decimal(4, 0) DEFAULT NULL,
  PRIMARY KEY (patientId),
  FOREIGN KEY (ccId) REFERENCES carecenter (Id) ON DELETE CASCADE,
  FOREIGN KEY (physicianId) REFERENCES physician (physicianId) ON DELETE CASCADE
) ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table patient
--

-- LOCK TABLES enrollment WRITE;
/*!40000 ALTER TABLE patient DISABLE KEYS */;
INSERT INTO patient VALUES
(199401, 'Krishna chaitanya', 'male', 20200609, 20200901, 19641, 1, 1001, 101),
(199402, 'Shabari', 'female', 20180201, 20181223, 19644, 6, 4001, 104),
(199403, 'Narayana', 'male', 20190609, 20190630, 19642, 2, 3001, 103),
(199404, 'Saketh', 'male', 20200609, 20200901, 19641, 1, 1003, 103),
(199410, 'Srinivas raju', 'male', 20200530, 20200615, 19641, 3, 4001, 104),
(199411, 'Siddharth', 'male', 20200501, 20200631, 19644, 4, 1003, 101),
(199412, 'Chinmay', 'female', 20200722, 20200821, 19641, 6, 3001, 103),
(199413, 'Sri Krishna', 'male', 20200615, 20200711, 19642, 5, 2001, 102),
(199405, 'Niharika', 'female', 20200909, 00000000, 19649, 4, 4001, 104),
(199406, 'Ashrith', 'male', 20200609, 00000000, 19647, 3, 3001, 103),
(199407, 'Sai Teja', 'male', 20200609, 00000000, 19643, 5, 4001, 104),
(199408, 'Akhil', 'male', 20200609, 00000000, 19646, 2, 1001, 101),
(199409, 'Sriharsha', 'male', 20200909, 00000000, 19648, 4, 3001, 103),
(199414, 'Bhargav', 'male', 20200906, 00000000, 19643, 5, 1001, 101),
(199415, 'Kalyan', 'male', 20200915, 00000000, 19646, 2, 2001, 102),
(199416, 'Santosh', 'male', 20200920, 00000000, 19648, 4, 2001, 102);
/*!40000 ALTER TABLE patient ENABLE KEYS */;
-- UNLOCK TABLES;

--
-- Table structure for table physician
--

DROP TABLE IF EXISTS physician;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE physician (
  physicianId decimal(8, 0) NOT NULL,
  name varchar(20) DEFAULT NULL,
  sex varchar(6) DEFAULT NULL,
  exp decimal(2, 0) DEFAULT NULL,
  PRIMARY KEY (physicianId)
) ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table physician
--

-- LOCK TABLES physician WRITE;
/*!40000 ALTER TABLE physician DISABLE KEYS */;
INSERT INTO physician VALUES (19641, 'Shlok', 'male', 9),(19642, 'Pavan Kumar', 'male', 1),(19643, 'Puneeth', 'male', 3),(19644, 'Siri', 'female', 12),(19645, 'Rashi', 'female', 20),(19646, 'Aditi', 'female', 15),(19647, 'Navyanth', 'male', 30),(19648, 'Praveen', 'male', 36),(19649, 'Sampath', 'male', 3);
/*!40000 ALTER TABLE physician ENABLE KEYS */;
-- UNLOCK TABLES;

--
-- Table structure for table performs
--

DROP TABLE IF EXISTS performs;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE performs (
  physicianId decimal(8, 0) NOT NULL,
  treatmentId decimal(8, 0) NOT NULL,
  patientId decimal(8, 0) NOT NULL,
  date decimal(9,0) DEFAULT NULL,
  time decimal(5,0) DEFAULT NULL,
  result varchar(15) DEFAULT NULL,
  PRIMARY KEY (physicianId,treatmentId,patientId),
   FOREIGN KEY (physicianId) REFERENCES physician (physicianId),
   FOREIGN KEY (patientId) REFERENCES patient (patientId),
   FOREIGN KEY (treatmentId) REFERENCES treatment (treatmentId)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table performs
--

-- LOCK TABLES performs WRITE;
/*!40000 ALTER TABLE performs DISABLE KEYS */;
INSERT INTO performs VALUES 
(19641, 4791, 199401, 20200615, 1800, 'successful'),
(19642, 4792, 199402, 20180220, 1200, 'successful'),
(19643, 4793, 199403, 20190616, 0800, 'successful'),
(19644, 4794, 199404, 20200612, 1900, 'successful'),
(19645, 4795, 199405, 20200920, 1300, 'successful'),
(19646, 4796, 199406, 20200930, 1500, 'unsuccessful'),
(19647, 4797, 199407, 20200701, 1600, 'successful'),
(19648, 4798, 199408, 20200705, 1700, 'unsuccessful'),
(19649, 4799, 199409, 20200921, 2100, 'successful'),
(19645, 4795, 199401, 20200923, 1300, 'successful'),
(19646, 4795, 199404, 20200913, 1400, 'successful'),
(19646, 4795, 199401, 20200620, 1500, 'successful'),
(19643, 4795, 199404, 20200625, 1100, 'successful'),
(19642, 4795, 199403, 20190621, 2100, 'successful'),
(19641, 4795, 199401, 20200623, 1800, 'successful'),
(19645, 4795, 199402, 20180229, 1900, 'successful'),
(19645, 4795, 199409, 20200926, 2000, 'unsuccessful'),
(19646, 4795, 199406, 20201031, 1900, 'successful'),
(19643, 4791, 199414, 20200910, 1900, 'successful'),
(19646, 4792, 199415, 20200921, 2000, 'unsuccessful'),
(19648, 4793, 199416, 20200923, 1900, 'successful');
/*!40000 ALTER TABLE performs ENABLE KEYS */;
-- UNLOCK TABLES;

--
-- Table structure for table treatment
--

DROP TABLE IF EXISTS treatment;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE treatment (
  treatmentId decimal(8, 0) NOT NULL,
  name varchar(20) DEFAULT NULL,
  cost decimal(8,0) DEFAULT NULL,
  PRIMARY KEY (treatmentId)
) ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table treatment
--

-- LOCK TABLES student WRITE;
/*!40000 ALTER TABLE treatment DISABLE KEYS */;
INSERT INTO treatment VALUES (4791, 'Neurosurgery', 1500),(4792, 'Oncology', 12999),(4793, 'Gastroenterology', 1329),(4794, 'Orthopedics', 6999),(4795, 'Cardiology', 1949),(4796, 'Ophthalmology', 1049),(4797, 'Endocrinology', 1000),(4798, 'Bariatric Surgery', 699),(4799, 'Dermatology', 399);

/*!40000 ALTER TABLE treatment ENABLE KEYS */;
-- UNLOCK TABLES;

--
-- Table structure for table used
--

DROP TABLE IF EXISTS used;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE used (
  date decimal(9,0) NOT NULL,
  patientId decimal(8, 0) NOT NULL,
  itemId decimal(8, 0) NOT NULL,
  quant decimal(8, 0) DEFAULT NULL,
  total_cost decimal(8, 0) DEFAULT NULL,
  PRIMARY KEY (date,patientId,itemId),
  FOREIGN KEY (patientId) REFERENCES patient (patientId) ON DELETE CASCADE,
  FOREIGN KEY (itemId) REFERENCES item (itemId) ON DELETE CASCADE
) ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table used
--

-- LOCK TABLES used WRITE;
/*!40000 ALTER TABLE used DISABLE KEYS */;
INSERT INTO used VALUES (20200930, 199406, 782, 3, 6),(20200615, 199401, 234, 4, 56),(20180220, 199402, 901, 1, 11),(20190616, 199403, 371, 2, 26),(20200612, 199404, 231, 3, 33),(20200920, 199405, 543, 1, 5),(20200930, 199406, 881, 2, 24),(20200701, 199407, 299, 3, 39),(20200705, 199408, 999, 6, 72),(20200721, 199409, 142, 1, 14),
(20200610, 199404, 234, 1, 14),
(20200531, 199410, 142, 4, 56),
(20200502, 199411, 894, 5, 70),
(20200723, 199412, 142, 3, 42),
(20200616, 199413, 234, 7, 98);
/*!40000 ALTER TABLE used ENABLE KEYS */;
-- UNLOCK TABLES;

--
-- Table structure for table used
--

DROP TABLE IF EXISTS item;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE item (
  itemId decimal(8, 0) NOT NULL,
  description varchar(100) DEFAULT NULL,
  cost decimal(8, 0) DEFAULT NULL,
  PRIMARY KEY (itemId)
) ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for item used
--

-- LOCK TABLES item WRITE;
/*!40000 ALTER TABLE item DISABLE KEYS */;
INSERT INTO item VALUES (782, 'Syringes : insert fluids', 2),(234, 'vicodin : Pain management', 14),(142, 'norco : Pain management', 14),(894, 'xodol : Pain management', 14),(231, 'synthroid : Thyroid deficiency', 11),(674, 'levoxyl : Thyroid deficiency', 11),(901, 'unithroid : Thyroid deficiency', 11),(471, 'Delasone : Arthritis, some cancer symptoms', 5),(543, 'Sterapred : Arthritis, some cancer symptoms', 5),(915, 'Amoxil : Bacterial infections', 9),(371, 'Neurontin : Seizures, nerve pain', 13),(301, 'Prinivil : Blood pressure, heart failure', 7),(801, 'Zestril : Blood pressure, heart failure', 7),(881, 'Lipitor : High cholesterol', 12),(222, 'Glucophage : Type 2 diabetes', 8),(299, 'Zofran : Nausea', 13),(999, 'Motrin : Fever and inflammation', 12);
/*!40000 ALTER TABLE item ENABLE KEYS */;
-- UNLOCK TABLES;


/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-09-28 12:22:49
