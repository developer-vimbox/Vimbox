-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Jul 22, 2016 at 06:10 AM
-- Server version: 5.6.17
-- PHP Version: 5.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `vimbox`
--

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE IF NOT EXISTS `customers` (
  `customer_id` int(11) NOT NULL AUTO_INCREMENT,
  `salutation` varchar(10) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `contact` int(20) NOT NULL,
  `email` varchar(100) NOT NULL,
  PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`customer_id`, `salutation`, `first_name`, `last_name`, `contact`, `email`) VALUES
(1, 'Ms', 'pamela', 'seah', 90827736, 'pamela@gmail.com'),
(2, 'Mr', 'khairul', 'anwar', 98873304, 'khairul@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `customers_history`
--

CREATE TABLE IF NOT EXISTS `customers_history` (
  `customer_id` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  PRIMARY KEY (`customer_id`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `customers_history`
--

INSERT INTO `customers_history` (`customer_id`, `id`) VALUES
(1, 75683040);

-- --------------------------------------------------------

--
-- Table structure for table `leadcomment`
--

CREATE TABLE IF NOT EXISTS `leadcomment` (
  `lead_id` int(10) NOT NULL,
  `sales_div` varchar(255) NOT NULL,
  `comment` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `leadcustitem`
--

CREATE TABLE IF NOT EXISTS `leadcustitem` (
  `lead_id` int(10) NOT NULL,
  `sales_div` varchar(255) NOT NULL,
  `itemname` varchar(100) NOT NULL,
  `itemremark` varchar(255) NOT NULL,
  `itemcharge` varchar(10) NOT NULL,
  `itemqty` varchar(10) NOT NULL,
  `itemunit` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `leadcustitem`
--

INSERT INTO `leadcustitem` (`lead_id`, `sales_div`, `itemname`, `itemremark`, `itemcharge`, `itemqty`, `itemunit`) VALUES
(182819413, 'sales1|864 Yishun Ave 4, Block 864 #11-11 S760864', 'Boxes', '', '', '30', '30'),
(182819413, 'sales2|39 Cambridge Rd #11-11 S210039', 'Boxes', '', '', '50', '50'),
(108879773, 'sales1|864 Yishun Ave 4, Block 864 #11-11 S760864', 'Boxes', '', '', '70', '70');

-- --------------------------------------------------------

--
-- Table structure for table `leadenquiry`
--

CREATE TABLE IF NOT EXISTS `leadenquiry` (
  `lead_id` int(10) NOT NULL,
  `enquiry` varchar(255) NOT NULL,
  PRIMARY KEY (`lead_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `leadinfo`
--

CREATE TABLE IF NOT EXISTS `leadinfo` (
  `owner_user` varchar(100) NOT NULL,
  `lead_id` int(10) NOT NULL,
  `type` varchar(20) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `tom` varchar(200) NOT NULL,
  `dom` varchar(200) NOT NULL,
  `datetime_of_creation` datetime NOT NULL,
  `status` varchar(10) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `source` varchar(20) NOT NULL,
  `referral` varchar(200) NOT NULL,
  PRIMARY KEY (`owner_user`,`lead_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `leadinfo`
--

INSERT INTO `leadinfo` (`owner_user`, `lead_id`, `type`, `customer_id`, `tom`, `dom`, `datetime_of_creation`, `status`, `reason`, `source`, `referral`) VALUES
('S9344895B', 108879773, 'Sales', -1, '', '', '2016-07-22 11:05:12', 'Pending', '', 'Call', 'Friend'),
('S9344895B', 182819413, 'Sales', -1, '', '', '2016-07-22 09:41:59', 'Pending', '', 'Call', 'Friend'),
('S9344895B', 464255293, 'Site Survey', -1, '', '', '2016-07-18 09:37:43', 'Pending', '', 'Call', 'Friend'),
('S9344895B', 521002514, 'Site Survey', -1, '', '', '2016-07-18 09:38:11', 'Pending', '', 'Call', 'Friend'),
('S9344895B', 537746269, 'Site Survey', -1, '', '', '2016-07-18 10:40:54', 'Pending', '', 'Call', 'Friend'),
('S9344895B', 684582215, 'Site Survey', -1, '', '', '2016-07-18 10:41:13', 'Pending', '', 'Call', 'Friend');

-- --------------------------------------------------------

--
-- Table structure for table `leadmaterial`
--

CREATE TABLE IF NOT EXISTS `leadmaterial` (
  `lead_id` int(10) NOT NULL,
  `sales_div` varchar(255) NOT NULL,
  `materialname` varchar(100) NOT NULL,
  `materialqty` varchar(10) NOT NULL,
  `materialcharge` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `leadmovefrom`
--

CREATE TABLE IF NOT EXISTS `leadmovefrom` (
  `lead_id` int(10) NOT NULL,
  `addressfrom` varchar(255) NOT NULL,
  `storeysfrom` varchar(50) NOT NULL,
  `pushingfrom` varchar(50) NOT NULL,
  PRIMARY KEY (`lead_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `leadmovefrom`
--

INSERT INTO `leadmovefrom` (`lead_id`, `addressfrom`, `storeysfrom`, `pushingfrom`) VALUES
(108879773, '864 Yishun Ave 4, Block 864_11_11_760864', ' ', ' '),
(182819413, '864 Yishun Ave 4, Block 864_11_11_760864|39 Cambridge Rd_11_11_210039', ' | ', ' | '),
(464255293, '39 Cambridge Rd_11_11_210039', ' ', ' '),
(521002514, '894 Tampines Street 81, Block 894_11_11_520894', ' ', ' '),
(537746269, '864 Yishun Ave 4, Block 864_11_11_760864', ' ', ' '),
(684582215, '8 Boon Lay Way_8_115_609964', ' ', ' ');

-- --------------------------------------------------------

--
-- Table structure for table `leadmoveto`
--

CREATE TABLE IF NOT EXISTS `leadmoveto` (
  `lead_id` int(10) NOT NULL,
  `addressto` varchar(255) NOT NULL,
  `storeysto` varchar(50) NOT NULL,
  `pushingto` varchar(50) NOT NULL,
  PRIMARY KEY (`lead_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `leadmoveto`
--

INSERT INTO `leadmoveto` (`lead_id`, `addressto`, `storeysto`, `pushingto`) VALUES
(108879773, '', '', ''),
(182819413, '', '', ''),
(464255293, '', '', ''),
(521002514, '', '', ''),
(537746269, '', '', ''),
(684582215, '', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `leadother`
--

CREATE TABLE IF NOT EXISTS `leadother` (
  `lead_id` int(10) NOT NULL,
  `sales_div` varchar(255) NOT NULL,
  `other` varchar(100) NOT NULL,
  `charge` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `leadother`
--

INSERT INTO `leadother` (`lead_id`, `sales_div`, `other`, `charge`) VALUES
(182819413, 'sales1|864 Yishun Ave 4, Block 864 #11-11 S760864', 'storeyCharge', '0.00'),
(182819413, 'sales1|864 Yishun Ave 4, Block 864 #11-11 S760864', 'pushCharge', '0.00'),
(182819413, 'sales1|864 Yishun Ave 4, Block 864 #11-11 S760864', 'detourCharge', '0.00'),
(182819413, 'sales1|864 Yishun Ave 4, Block 864 #11-11 S760864', 'materialCharge', '0.00'),
(182819413, 'sales1|864 Yishun Ave 4, Block 864 #11-11 S760864', 'markup', '0.00'),
(182819413, 'sales1|864 Yishun Ave 4, Block 864 #11-11 S760864', 'discount', '0.00'),
(182819413, 'sales2|39 Cambridge Rd #11-11 S210039', 'storeyCharge', '0.00'),
(182819413, 'sales2|39 Cambridge Rd #11-11 S210039', 'pushCharge', '0.00'),
(182819413, 'sales2|39 Cambridge Rd #11-11 S210039', 'detourCharge', '0.00'),
(182819413, 'sales2|39 Cambridge Rd #11-11 S210039', 'materialCharge', '0.00'),
(182819413, 'sales2|39 Cambridge Rd #11-11 S210039', 'markup', '0.00'),
(182819413, 'sales2|39 Cambridge Rd #11-11 S210039', 'discount', '0.00'),
(108879773, 'sales1|864 Yishun Ave 4, Block 864 #11-11 S760864', 'storeyCharge', '0.00'),
(108879773, 'sales1|864 Yishun Ave 4, Block 864 #11-11 S760864', 'pushCharge', '0.00'),
(108879773, 'sales1|864 Yishun Ave 4, Block 864 #11-11 S760864', 'detourCharge', '0.00'),
(108879773, 'sales1|864 Yishun Ave 4, Block 864 #11-11 S760864', 'materialCharge', '0.00'),
(108879773, 'sales1|864 Yishun Ave 4, Block 864 #11-11 S760864', 'markup', '0.00'),
(108879773, 'sales1|864 Yishun Ave 4, Block 864 #11-11 S760864', 'discount', '0.00');

-- --------------------------------------------------------

--
-- Table structure for table `leadremark`
--

CREATE TABLE IF NOT EXISTS `leadremark` (
  `lead_id` int(10) NOT NULL,
  `sales_div` varchar(255) NOT NULL,
  `remark` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `leadsalesdiv`
--

CREATE TABLE IF NOT EXISTS `leadsalesdiv` (
  `lead_id` int(10) NOT NULL,
  `sales_div` varchar(255) NOT NULL,
  PRIMARY KEY (`lead_id`,`sales_div`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `leadsalesdiv`
--

INSERT INTO `leadsalesdiv` (`lead_id`, `sales_div`) VALUES
(108879773, 'sales1|864 Yishun Ave 4, Block 864 #11-11 S760864'),
(182819413, 'sales1|864 Yishun Ave 4, Block 864 #11-11 S760864'),
(182819413, 'sales2|39 Cambridge Rd #11-11 S210039');

-- --------------------------------------------------------

--
-- Table structure for table `leadservice`
--

CREATE TABLE IF NOT EXISTS `leadservice` (
  `lead_id` int(10) NOT NULL,
  `sales_div` varchar(255) NOT NULL,
  `service` varchar(100) NOT NULL,
  `charge` varchar(10) NOT NULL,
  `manpower` varchar(10) NOT NULL,
  `remarks` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `leadservice`
--

INSERT INTO `leadservice` (`lead_id`, `sales_div`, `service`, `charge`, `manpower`, `remarks`) VALUES
(108879773, 'sales1|864 Yishun Ave 4, Block 864 #11-11 S760864', 'Packing_Local', '320.00', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `leadvimboxitem`
--

CREATE TABLE IF NOT EXISTS `leadvimboxitem` (
  `lead_id` int(10) NOT NULL,
  `sales_div` varchar(255) NOT NULL,
  `itemname` varchar(100) NOT NULL,
  `itemremark` varchar(255) NOT NULL,
  `itemcharge` varchar(10) NOT NULL,
  `itemqty` varchar(10) NOT NULL,
  `itemunit` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `lead_followups`
--

CREATE TABLE IF NOT EXISTS `lead_followups` (
  `lead_id` int(10) NOT NULL,
  `followup` varchar(255) NOT NULL,
  `datetime_of_creation` datetime NOT NULL,
  PRIMARY KEY (`lead_id`,`datetime_of_creation`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `payslips`
--

CREATE TABLE IF NOT EXISTS `payslips` (
  `payslip_id` int(8) NOT NULL,
  `nric` varchar(10) NOT NULL,
  `payment_mode` varchar(20) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `payment_date` date NOT NULL,
  `basic` double NOT NULL,
  `allowance` double NOT NULL,
  `deduction` double NOT NULL,
  `overtime_hr` double NOT NULL,
  `overtime` double NOT NULL,
  `additional` double NOT NULL,
  `employer_cpf` double NOT NULL,
  PRIMARY KEY (`payslip_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `payslips_abd`
--

CREATE TABLE IF NOT EXISTS `payslips_abd` (
  `payslip_id` int(8) NOT NULL,
  `description` varchar(255) NOT NULL,
  `breakdown` double NOT NULL,
  PRIMARY KEY (`payslip_id`,`description`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `payslips_apbd`
--

CREATE TABLE IF NOT EXISTS `payslips_apbd` (
  `payslip_id` int(8) NOT NULL,
  `description` varchar(255) NOT NULL,
  `breakdown` double NOT NULL,
  PRIMARY KEY (`payslip_id`,`description`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `payslips_dbd`
--

CREATE TABLE IF NOT EXISTS `payslips_dbd` (
  `payslip_id` int(8) NOT NULL,
  `description` varchar(255) NOT NULL,
  `breakdown` double NOT NULL,
  PRIMARY KEY (`payslip_id`,`description`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `sitesurvey_assigned`
--

CREATE TABLE IF NOT EXISTS `sitesurvey_assigned` (
  `lead_id` int(10) NOT NULL,
  `ss_user` varchar(10) NOT NULL,
  `address` varchar(255) NOT NULL,
  `start_datetime` datetime NOT NULL,
  `end_datetime` datetime NOT NULL,
  `timeslot` varchar(255) NOT NULL,
  `remarks` varchar(255) NOT NULL,
  PRIMARY KEY (`lead_id`,`start_datetime`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `sitesurvey_assigned`
--

INSERT INTO `sitesurvey_assigned` (`lead_id`, `ss_user`, `address`, `start_datetime`, `end_datetime`, `timeslot`, `remarks`) VALUES
(464255293, 'S9433742A', '39 Cambridge Rd #11-11 S210039|', '2016-07-11 12:00:00', '2016-07-11 12:30:00', '1200 - 1300', ''),
(464255293, 'S9433742A', '39 Cambridge Rd #11-11 S210039|', '2016-07-11 12:30:00', '2016-07-11 13:00:00', '1200 - 1300', ''),
(521002514, 'S9433742A', '894 Tampines Street 81, Block 894 #11-11 S520894|', '2016-07-11 13:00:00', '2016-07-11 13:30:00', '1300 - 1400', ''),
(521002514, 'S9433742A', '894 Tampines Street 81, Block 894 #11-11 S520894|', '2016-07-11 13:30:00', '2016-07-11 14:00:00', '1300 - 1400', ''),
(537746269, 'S9244165A', '864 Yishun Ave 4, Block 864 #11-11 S760864|', '2016-07-11 12:00:00', '2016-07-11 12:30:00', '1200 - 1300', ''),
(537746269, 'S9244165A', '864 Yishun Ave 4, Block 864 #11-11 S760864|', '2016-07-11 12:30:00', '2016-07-11 13:00:00', '1200 - 1300', ''),
(684582215, 'S9244165A', '8 Boon Lay Way #8-115 S609964|', '2016-07-11 13:00:00', '2016-07-11 13:30:00', '1300 - 1400', ''),
(684582215, 'S9244165A', '8 Boon Lay Way #8-115 S609964|', '2016-07-11 13:30:00', '2016-07-11 14:00:00', '1300 - 1400', '');

-- --------------------------------------------------------

--
-- Table structure for table `system_items`
--

CREATE TABLE IF NOT EXISTS `system_items` (
  `name` varchar(50) NOT NULL,
  `description` varchar(100) NOT NULL,
  `dimensions` varchar(50) NOT NULL,
  `units` varchar(10) NOT NULL,
  PRIMARY KEY (`name`,`description`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `system_items`
--

INSERT INTO `system_items` (`name`, `description`, `dimensions`, `units`) VALUES
('Arm Chair', '', '', '4'),
('Bed (Bunk bed)', 'Double Single', '', '30'),
('Bed (Bunk bed)', 'Queen + Single', '', '34'),
('Bed (Bunk bed)', 'Queen top bed', '', '24'),
('Bed (Bunk bed)', 'Single top bed', '', '16'),
('Bed (Canopy)', 'King', '', '34'),
('Bed (Canopy)', 'Queen', '', '28'),
('Bed (Canopy)', 'Single', '', '20'),
('Bed with no storage', 'King', '', '20'),
('Bed with no storage', 'Queen', '', '16'),
('Bed with no storage', 'Single', '', '10'),
('Bed with storage & frame', 'King', '', '30'),
('Bed with storage & frame', 'Queen', '', '24'),
('Bed with storage & frame', 'Single', '', '16'),
('Bench L', '', 'Less than 152W x 38D x 38H', '4'),
('Bench M', '', 'Less than 114W x 38D x 38H', '3'),
('Bench S', '', 'Less than 76W x 38D x 38H', '2'),
('Bookshelf', '', '80W x 28D x 202H', '5'),
('Chairs (Office)', 'Wheeled & Movable', '', '2'),
('Chairs x2', '', '', '2'),
('Chest of Drawers L', '', 'L & H Less than 114cm', '6'),
('Chest of Drawers M', '', 'L & H Less than 76cm', '4'),
('Chest of Drawers S', '', 'L & H Less than 38cm', '2'),
('Chiller standard size', '', '60W x 57D x 82H', '4'),
('Coffee Table L', '', 'Less than 76W x 76L x 38H', '4'),
('Coffee Table S', '', 'Less than 38W x 76L x 38H', '2'),
('Computer', 'CPU + Monitor + keyboard + Mouse', '', '2'),
('Computer', 'CPU + Monitor + keyboard + Mouse + Printer', '', '3'),
('Dining Chair x2', '', '', '2'),
('Dining Table', '4 Person', '76L x 76W x 76H', '8'),
('Dining Table', '6 Person', '152L x 95W x 76H', '12'),
('Dining Table', '8 Person', '228L x 95W x 76H', '19'),
('Dining Table', 'More than 8 Person', 'Depending on L & W', ''),
('Display Cabinet', '2 doors', '96W x 42D x 215H', '10'),
('Display Cabinet', 'No doors', '78W x 41D x 95H', '4'),
('Display Console', '', '', '4'),
('Dressing Table L', 'With mirror', '120W x 42D x 77H', '9'),
('Dressing Table S', 'With mirror', '70W x 42D x 77H', '6'),
('Dryer', '', '', '4'),
('Freezer', '', '61W x 66D x 90H', '4'),
('Fridge', '1 Door', '70W x 72D x 178H', '10'),
('Fridge', '2 Doors', '92W x 73D x 175H', '14'),
('Iron + Board', '', '', '2'),
('Lamp', '', '', '1'),
('Oven L', '', 'Above 38 x 60 x 38', '2'),
('Oven S', '', '38 x 60 x 38 and below', '1'),
('Pigeon Hole', 'Units depend on holes', '', '4'),
('Rack', 'Clothes Rack', '', '2'),
('Rack', 'Hats & Coat stand', '', '1'),
('Side Table', 'Bed side', '', '2'),
('Sofa', '1 Seater', '105W x 99D x 83H', '10'),
('Sofa', '2 Seater', '190W x 95D x 83H', '17'),
('Sofa', '2 Seater L Shape', '', '25'),
('Sofa', '3 Seater', '228W x 95D x 83H', '21'),
('Sofa', '3 Seater L Shape', '', '29'),
('Speaker Set', '', '', '1'),
('Standing fan', '', '', '1'),
('Study Desk L', '', '160L x 80D x 65H', '10'),
('Study Desk S', '', '120L x 80D x 65H', '7'),
('Tv Console', '', '', '6'),
('Wall Shelves', '', '146W x 23D x 47H', '2'),
('Wardrobe', '2 Doors', '110W x 60D x 208H', '16'),
('Wardrobe', '3 Doors', '150W x 60D x 236H', '24'),
('Wardrobe', '3 includes sliding doors', '200W x 66D x 236H', '36'),
('Washing Machine', '', '', '4');

-- --------------------------------------------------------

--
-- Table structure for table `system_lead_types`
--

CREATE TABLE IF NOT EXISTS `system_lead_types` (
  `type` varchar(20) NOT NULL,
  PRIMARY KEY (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `system_lead_types`
--

INSERT INTO `system_lead_types` (`type`) VALUES
('Enquiry'),
('Sales'),
('Site Survey');

-- --------------------------------------------------------

--
-- Table structure for table `system_modules`
--

CREATE TABLE IF NOT EXISTS `system_modules` (
  `type` varchar(5) NOT NULL,
  `department` varchar(100) NOT NULL,
  `designation` varchar(100) NOT NULL,
  `modules` varchar(200) NOT NULL,
  `working_days` int(11) NOT NULL,
  PRIMARY KEY (`type`,`department`,`designation`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `system_modules`
--

INSERT INTO `system_modules` (`type`, `department`, `designation`, `modules`, `working_days`) VALUES
('Full', 'IT', 'Manager', 'Ticket|Sales', 5),
('Full', 'Operations', 'Mover', '', 6),
('Full', 'Sales', 'Surveyor', '', 5);

-- --------------------------------------------------------

--
-- Table structure for table `system_move_types`
--

CREATE TABLE IF NOT EXISTS `system_move_types` (
  `type` varchar(20) NOT NULL,
  PRIMARY KEY (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `system_move_types`
--

INSERT INTO `system_move_types` (`type`) VALUES
('Disposal'),
('Office'),
('Residential'),
('Storage');

-- --------------------------------------------------------

--
-- Table structure for table `system_payment_modes`
--

CREATE TABLE IF NOT EXISTS `system_payment_modes` (
  `mode` varchar(50) NOT NULL,
  PRIMARY KEY (`mode`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `system_payment_modes`
--

INSERT INTO `system_payment_modes` (`mode`) VALUES
('Cash'),
('Cheque');

-- --------------------------------------------------------

--
-- Table structure for table `system_referrals`
--

CREATE TABLE IF NOT EXISTS `system_referrals` (
  `source` varchar(30) NOT NULL,
  PRIMARY KEY (`source`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `system_referrals`
--

INSERT INTO `system_referrals` (`source`) VALUES
('Friend'),
('Magazine'),
('Website');

-- --------------------------------------------------------

--
-- Table structure for table `system_services`
--

CREATE TABLE IF NOT EXISTS `system_services` (
  `primary_service` varchar(50) NOT NULL,
  `secondary_service` varchar(50) NOT NULL,
  `formula` varchar(50) DEFAULT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY (`primary_service`,`secondary_service`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `system_services`
--

INSERT INTO `system_services` (`primary_service`, `secondary_service`, `formula`, `description`) VALUES
('Manpower', 'Internal Moving', '160 x MP', ''),
('Manpower', 'Manpower Request', '60 x MP', ''),
('Moving', 'Local', '4.8 x U + AC', 'Provision of Local Moving Service'),
('Packing', 'Local', 'B / 50 x 160', 'Provision of Local Packing Service'),
('Unpacking', 'Local', 'B / 50 x 120', 'Provision of Local Unpacking Service');

-- --------------------------------------------------------

--
-- Table structure for table `system_sources`
--

CREATE TABLE IF NOT EXISTS `system_sources` (
  `source` varchar(100) NOT NULL,
  PRIMARY KEY (`source`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `system_sources`
--

INSERT INTO `system_sources` (`source`) VALUES
('Call'),
('Email');

-- --------------------------------------------------------

--
-- Table structure for table `system_special_items`
--

CREATE TABLE IF NOT EXISTS `system_special_items` (
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `system_special_items`
--

INSERT INTO `system_special_items` (`name`) VALUES
('Bed (Compartment bed)'),
('Massage Chair'),
('Piano'),
('Safe'),
('Statue');

-- --------------------------------------------------------

--
-- Table structure for table `tickets`
--

CREATE TABLE IF NOT EXISTS `tickets` (
  `ticket_id` int(8) NOT NULL,
  `owner_user` varchar(100) NOT NULL,
  `assigned_users` varchar(200) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `subject` varchar(100) NOT NULL,
  `datetime_of_creation` datetime NOT NULL,
  `datetime_of_edit` datetime NOT NULL,
  `description` varchar(255) NOT NULL,
  `solution` varchar(255) NOT NULL,
  `status` varchar(10) NOT NULL,
  PRIMARY KEY (`ticket_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tickets`
--

INSERT INTO `tickets` (`ticket_id`, `owner_user`, `assigned_users`, `customer_id`, `subject`, `datetime_of_creation`, `datetime_of_edit`, `description`, `solution`, `status`) VALUES
(75683040, 'S9344895B', 'S9344895B|S9244165A', 1, 'Moving Feedback', '2016-07-22 12:09:48', '2016-07-22 12:09:48', 'Moving was too slow', '', 'Pending');

-- --------------------------------------------------------

--
-- Table structure for table `ticket_comments`
--

CREATE TABLE IF NOT EXISTS `ticket_comments` (
  `ticket_id` int(8) NOT NULL,
  `comment` varchar(255) NOT NULL,
  `datetime_of_creation` datetime NOT NULL,
  PRIMARY KEY (`ticket_id`,`datetime_of_creation`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `nric` varchar(10) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `date_joined` date NOT NULL,
  `mailing_address` varchar(200) NOT NULL,
  `registered_address` varchar(200) NOT NULL,
  `department` varchar(100) NOT NULL,
  `designation` varchar(100) NOT NULL,
  `salary` int(10) NOT NULL,
  `type` varchar(5) NOT NULL,
  PRIMARY KEY (`nric`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`nric`, `first_name`, `last_name`, `date_joined`, `mailing_address`, `registered_address`, `department`, `designation`, `salary`, `type`) VALUES
('S9244165A', 'Subash', 'T', '2016-07-18', 'Testing', '', 'Sales', 'Surveyor', 500, 'Full'),
('S9344895B', 'Yu Sheng', 'Ngo', '2016-06-18', 'Yishun Ave 4 Blk 864 #11-37 S760864', '', 'IT', 'Manager', 6000, 'Full'),
('S9433742A', 'Wai Kit', 'Chan', '2016-07-18', 'Testing', '', 'Sales', 'Surveyor', 500, 'Full'),
('S9876543C', 'Chun Kit', 'Chow', '2016-06-20', 'Blk 39 Cambridge Road #13-129 S210039', '', 'IT', 'Manager', 6000, 'Full');

-- --------------------------------------------------------

--
-- Table structure for table `users_account`
--

CREATE TABLE IF NOT EXISTS `users_account` (
  `nric` varchar(10) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users_account`
--

INSERT INTO `users_account` (`nric`, `username`, `password`) VALUES
('S9344895B', 'admin', 'password'),
('S9876543C', 'chunkit@gmail.com', 'password'),
('S9244165A', 'subash@subash.com', 'password'),
('S9433742A', 'waitkit@waitkit.com', 'password');

-- --------------------------------------------------------

--
-- Table structure for table `users_attendance_record`
--

CREATE TABLE IF NOT EXISTS `users_attendance_record` (
  `nric` varchar(10) NOT NULL,
  `date` date NOT NULL,
  `status` varchar(10) NOT NULL,
  `duration` int(11) NOT NULL,
  PRIMARY KEY (`nric`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users_bank`
--

CREATE TABLE IF NOT EXISTS `users_bank` (
  `nric` varchar(10) NOT NULL,
  `payment_mode` varchar(50) NOT NULL,
  `bank_name` varchar(100) NOT NULL,
  `account_name` varchar(100) NOT NULL,
  `account_no` varchar(50) NOT NULL,
  PRIMARY KEY (`nric`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users_bank`
--

INSERT INTO `users_bank` (`nric`, `payment_mode`, `bank_name`, `account_name`, `account_no`) VALUES
('S9244165A', 'Cheque', 'DBS', 'subash-account', '123456789'),
('S9344895B', 'Cheque', 'DBS', 'yusheng account', '123-4567-8'),
('S9433742A', 'Cheque', 'DBS', 'waikit-account', '12345678'),
('S9876543C', 'Cheque', 'DBS', 'chunkit-account', '123-45678-9');

-- --------------------------------------------------------

--
-- Table structure for table `users_contact`
--

CREATE TABLE IF NOT EXISTS `users_contact` (
  `nric` varchar(10) NOT NULL,
  `phone_no` int(11) NOT NULL,
  `fax_no` int(11) NOT NULL,
  `home_no` int(11) NOT NULL,
  PRIMARY KEY (`nric`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users_contact`
--

INSERT INTO `users_contact` (`nric`, `phone_no`, `fax_no`, `home_no`) VALUES
('S9244165A', 12345678, 0, 0),
('S9344895B', 97312965, 0, 67580571),
('S9433742A', 12345678, 0, 0),
('S9876543C', 98311269, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `users_emergency`
--

CREATE TABLE IF NOT EXISTS `users_emergency` (
  `nric` varchar(10) NOT NULL,
  `name` varchar(100) NOT NULL,
  `relationship` varchar(100) NOT NULL,
  `contact_no` int(11) NOT NULL,
  `office_no` int(11) NOT NULL,
  PRIMARY KEY (`nric`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users_emergency`
--

INSERT INTO `users_emergency` (`nric`, `name`, `relationship`, `contact_no`, `office_no`) VALUES
('S9244165A', 'Mum', 'Mother', 12345678, 0),
('S9344895B', 'Phua Kuee Hoy', 'Mother', 85732675, 0),
('S9433742A', 'Mum', 'Mother', 12345678, 0),
('S9876543C', 'Chow Yun Fat', 'Father', 90087654, 0);

-- --------------------------------------------------------

--
-- Table structure for table `users_leave`
--

CREATE TABLE IF NOT EXISTS `users_leave` (
  `nric` varchar(10) NOT NULL,
  `date_joined` date NOT NULL,
  `leave` double NOT NULL,
  `mc` int(11) NOT NULL,
  `used_leave` double NOT NULL,
  `used_mc` int(11) NOT NULL,
  PRIMARY KEY (`nric`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users_leave`
--

INSERT INTO `users_leave` (`nric`, `date_joined`, `leave`, `mc`, `used_leave`, `used_mc`) VALUES
('S9244165A', '2016-07-18', 63, 14, 0, 0),
('S9344895B', '2016-06-18', 63, 14, 0, 0),
('S9433742A', '2016-07-18', 63, 14, 0, 0),
('S9876543C', '2016-06-20', 63, 14, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `users_leave_record`
--

CREATE TABLE IF NOT EXISTS `users_leave_record` (
  `leave_type` varchar(10) NOT NULL,
  `leave_name` varchar(20) NOT NULL,
  `nric` varchar(10) NOT NULL,
  `date` date NOT NULL,
  `time_string` varchar(20) NOT NULL,
  `leave_duration` double NOT NULL,
  `img` varchar(100) NOT NULL,
  PRIMARY KEY (`nric`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
