-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Jul 03, 2016 at 08:58 AM
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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`customer_id`, `salutation`, `first_name`, `last_name`, `contact`, `email`) VALUES
(1, 'Mr', 'chun kit', 'chow', 99873029, 'chunkit@gmail.com'),
(3, 'Mr', 'pamela', 'seah', 90827736, 'pamela@gmail.com'),
(4, 'Mr', '', 'Lim', 90083947, 'limahkau@gmail.com'),
(5, 'Mr', 'subash ', 'ninabeh', 90008723, 'subash@gmail.com'),
(6, 'Ms', 'khairul', 'anwar', 98873304, 'khairul@gmail.com'),
(7, 'Mr', 'Wai Tuck', '', 98876253, '');

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
(1, 62685761);

-- --------------------------------------------------------

--
-- Table structure for table `leadcomment`
--

CREATE TABLE IF NOT EXISTS `leadcomment` (
  `lead_id` int(10) NOT NULL,
  `comment` varchar(255) NOT NULL,
  PRIMARY KEY (`lead_id`,`comment`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `leadcustitem`
--

CREATE TABLE IF NOT EXISTS `leadcustitem` (
  `lead_id` int(10) NOT NULL,
  `itemname` varchar(100) NOT NULL,
  `itemremark` varchar(255) NOT NULL,
  `itemcharge` varchar(10) NOT NULL,
  `itemqty` varchar(10) NOT NULL,
  `itemunit` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `leadenquiry`
--

CREATE TABLE IF NOT EXISTS `leadenquiry` (
  `lead_id` int(10) NOT NULL,
  `enquiry` varchar(255) NOT NULL,
  PRIMARY KEY (`lead_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `leadenquiry`
--

INSERT INTO `leadenquiry` (`lead_id`, `enquiry`) VALUES
(255594632, 'customer dont want to go on anymore'),
(284361538, 'yeah');

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
('admin', 255594632, 'Enquiry', 4, 'Residential|Office', '', '2016-06-10 10:02:12', 'Rejected', 'Customer kpkb', 'Call', 'Website'),
('admin', 480987952, 'Sales', 1, '', '', '2016-06-10 09:46:06', 'Pending', '', 'Call', 'Friend'),
('s9344895b', 284361538, 'Enquiry', 1, '', '', '2016-06-15 17:49:04', 'Pending', '', 'Call', 'Friend');

-- --------------------------------------------------------

--
-- Table structure for table `leadmaterial`
--

CREATE TABLE IF NOT EXISTS `leadmaterial` (
  `lead_id` int(10) NOT NULL,
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
(255594632, '864 Yishun Ave 4, Block 864_11_11_760864', ' ', ' '),
(284361538, '', '', ''),
(480987952, '', '', '');

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
(255594632, '865 Yishun Street 81, Block 865_11_11_760865', ' ', ' '),
(284361538, '', '', ''),
(480987952, '', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `leadother`
--

CREATE TABLE IF NOT EXISTS `leadother` (
  `lead_id` int(10) NOT NULL,
  `other` varchar(100) NOT NULL,
  `charge` varchar(10) NOT NULL,
  PRIMARY KEY (`lead_id`,`other`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `leadother`
--

INSERT INTO `leadother` (`lead_id`, `other`, `charge`) VALUES
(480987952, 'detourCharge', '0.00'),
(480987952, 'markup', '0.00'),
(480987952, 'materialCharge', '0.00'),
(480987952, 'pushCharge', '0.00'),
(480987952, 'storeyCharge', '0.00');

-- --------------------------------------------------------

--
-- Table structure for table `leadremark`
--

CREATE TABLE IF NOT EXISTS `leadremark` (
  `lead_id` int(10) NOT NULL,
  `remark` varchar(255) NOT NULL,
  PRIMARY KEY (`lead_id`,`remark`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `leadservice`
--

CREATE TABLE IF NOT EXISTS `leadservice` (
  `lead_id` int(10) NOT NULL,
  `service` varchar(100) NOT NULL,
  `charge` varchar(10) NOT NULL,
  `manpower` varchar(10) NOT NULL,
  `remarks` varchar(255) NOT NULL,
  PRIMARY KEY (`lead_id`,`service`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `leadvimboxitem`
--

CREATE TABLE IF NOT EXISTS `leadvimboxitem` (
  `lead_id` int(10) NOT NULL,
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

--
-- Dumping data for table `lead_followups`
--

INSERT INTO `lead_followups` (`lead_id`, `followup`, `datetime_of_creation`) VALUES
(255594632, 'Called customer if wanna confirm but never pick up phone', '2016-06-10 10:01:49'),
(284361538, 'testing', '2016-06-15 17:35:43'),
(284361538, 'one more time', '2016-06-15 17:36:51');

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

--
-- Dumping data for table `payslips`
--

INSERT INTO `payslips` (`payslip_id`, `nric`, `payment_mode`, `start_date`, `end_date`, `payment_date`, `basic`, `allowance`, `deduction`, `overtime_hr`, `overtime`, `additional`, `employer_cpf`) VALUES
(52044433, 'S9876543C', 'Cheque', '2016-07-01', '2016-07-31', '2016-07-31', 6000, 0, 1200, 0, 0, 0, 1020),
(52322776, 'S9344895B', 'Cheque', '2016-07-01', '2016-07-31', '2016-07-31', 6000, 0, 1200, 0, 0, 0, 1020),
(79127095, 'S1234567A', 'Cash', '2016-07-01', '2016-07-31', '2016-07-31', 2000, 0, 590.48, 0, 0, 0, 340),
(79645851, 'S0987654A', 'Cash', '2016-07-01', '2016-07-31', '2016-07-31', 2000, 0, 400.14, 0, 0, 0, 340);

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

--
-- Dumping data for table `payslips_dbd`
--

INSERT INTO `payslips_dbd` (`payslip_id`, `description`, `breakdown`) VALUES
(52044433, 'Employee''s CPF Deduction', 1200),
(52322776, 'Employee''s CPF Deduction', 1200),
(79127095, 'Absent For Work - 1 day(s)', 95.24),
(79127095, 'Employee''s CPF Deduction', 400),
(79127095, 'Unpaid Leave - 1 day(s) ', 95.24),
(79645851, 'Employee''s CPF Deduction', 400),
(79645851, 'Late For Work - 4 hours(s) 10 min(s)', 35.61);

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
('Sales');

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
('Full', 'Operations', 'Mover', '', 6);

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
(62685761, 'S9344895B', 'S9876543C|S9344895B', 1, 'he sucks', '2016-06-24 11:14:51', '2016-06-24 11:15:46', 'he sucks', '', 'Pending');

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
('S0987654A', 'testing ', 'testing ', '2016-06-28', 'testing', '', 'Operations', 'Mover', 2000, 'Full'),
('S1234567A', 'test', 'test', '2016-06-28', 'testing', '', 'IT', 'Manager', 2000, 'Full'),
('S9344895B', 'Yu Sheng', 'Ngo', '2016-06-18', 'Yishun Ave 4 Blk 864 #11-37 S760864', '', 'IT', 'Manager', 6000, 'Full'),
('S9876543C', 'Chee Bai', 'Chow', '2016-06-20', 'Blk 39 Cambridge Road #13-129 S210039', '', 'IT', 'Manager', 6000, 'Full');

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
('S1234567A', 'test@test.com', 'password'),
('S0987654A', 'testing@testing.com', 'password');

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

--
-- Dumping data for table `users_attendance_record`
--

INSERT INTO `users_attendance_record` (`nric`, `date`, `status`, `duration`) VALUES
('S0987654A', '2016-07-01', 'Present', 0),
('S0987654A', '2016-07-02', 'Late', 250),
('S1234567A', '2016-07-01', 'Absent', 0),
('S1234567A', '2016-07-02', 'Present', 0),
('S9344895B', '2016-07-01', 'Leave', 0),
('S9344895B', '2016-07-02', 'Leave', 0),
('S9876543C', '2016-07-01', 'Present', 0),
('S9876543C', '2016-07-02', 'Present', 0);

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
('S0987654A', 'Cash', 'testing', 'testing', 'testing'),
('S1234567A', 'Cash', 'test', 'test', 'test'),
('S9344895B', 'Cheque', 'DBS', 'yusheng account', '123-4567-8'),
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
('S0987654A', 12345678, 0, 0),
('S1234567A', 12345678, 0, 0),
('S9344895B', 97312965, 0, 67580571),
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
('S0987654A', 'testing', 'testing', 12345678, 0),
('S1234567A', 'test', 'test', 12345678, 0),
('S9344895B', 'Phua Kuee Hoy', 'Mother', 85732675, 0),
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
('S0987654A', '2016-06-28', 63, 14, 0, 0),
('S1234567A', '2016-06-28', 63, 14, 0, 0),
('S9344895B', '2016-06-18', 63, 14, 57, 0),
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

--
-- Dumping data for table `users_leave_record`
--

INSERT INTO `users_leave_record` (`leave_type`, `leave_name`, `nric`, `date`, `time_string`, `leave_duration`, `img`) VALUES
('Unpaid', 'Leave', 'S1234567A', '2016-07-12', '0900 - 1800', 9, ''),
('Paid', 'Leave', 'S9344895B', '2016-06-27', '0900-1800', 9, ''),
('Paid', 'Leave', 'S9344895B', '2016-06-28', '0900-1800', 9, ''),
('Paid', 'Leave', 'S9344895B', '2016-06-29', '0900-1800', 9, ''),
('Paid', 'Leave', 'S9344895B', '2016-06-30', '0900-1800', 9, ''),
('Paid', 'Leave', 'S9344895B', '2016-07-01', '0900 - 1800', 9, ''),
('Paid', 'Leave', 'S9344895B', '2016-07-02', '0900 - 1800', 9, ''),
('Paid', 'Timeoff', 'S9344895B', '2016-07-04', '0900-1200', 3, '');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
