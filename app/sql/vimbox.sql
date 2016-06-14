-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Jun 10, 2016 at 03:41 AM
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
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `contact` varchar(20) NOT NULL,
  `email` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `name`, `contact`, `email`) VALUES
(1, 'Mr Ngo Yu Sheng', '98765432', 'ngoyusheng@gmail.com'),
(2, 'Mr Chow Chun Kit', '90028347', 'chowchunkit@gmail.com'),
(3, 'Ms Pamela Seah', '90013457', 'pamelaseah@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `customershistory`
--

CREATE TABLE IF NOT EXISTS `customershistory` (
  `custid` int(11) NOT NULL,
  `id` varchar(10) NOT NULL,
  PRIMARY KEY (`custid`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE IF NOT EXISTS `items` (
  `name` varchar(50) NOT NULL,
  `description` varchar(100) NOT NULL,
  `dimensions` varchar(50) NOT NULL,
  `units` varchar(10) NOT NULL,
  PRIMARY KEY (`name`,`description`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`name`, `description`, `dimensions`, `units`) VALUES
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
-- Table structure for table `leadcomment`
--

CREATE TABLE IF NOT EXISTS `leadcomment` (
  `leadid` varchar(10) NOT NULL,
  `comment` varchar(255) NOT NULL,
  PRIMARY KEY (`leadid`,`comment`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `leadcustitem`
--

CREATE TABLE IF NOT EXISTS `leadcustitem` (
  `leadid` varchar(10) NOT NULL,
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
  `leadid` varchar(10) NOT NULL,
  `enquiry` varchar(255) NOT NULL,
  PRIMARY KEY (`leadid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `leadfollowups`
--

CREATE TABLE IF NOT EXISTS `leadfollowups` (
  `id` varchar(10) NOT NULL,
  `followup` varchar(255) NOT NULL,
  `datetiming` datetime NOT NULL,
  PRIMARY KEY (`id`,`datetiming`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `leadinfo`
--

CREATE TABLE IF NOT EXISTS `leadinfo` (
  `username` varchar(100) NOT NULL,
  `leadid` varchar(10) NOT NULL,
  `type` varchar(20) NOT NULL,
  `custid` int(11) NOT NULL,
  `tom` varchar(200) NOT NULL,
  `dom` varchar(200) NOT NULL,
  `datetiming` datetime NOT NULL,
  `status` varchar(10) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `source` varchar(20) NOT NULL,
  `referral` varchar(200) NOT NULL,
  PRIMARY KEY (`username`,`leadid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `leadmaterial`
--

CREATE TABLE IF NOT EXISTS `leadmaterial` (
  `leadid` varchar(10) NOT NULL,
  `materialname` varchar(100) NOT NULL,
  `materialqty` varchar(10) NOT NULL,
  `materialcharge` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `leadmovefrom`
--

CREATE TABLE IF NOT EXISTS `leadmovefrom` (
  `leadid` varchar(10) NOT NULL,
  `addressfrom` varchar(255) NOT NULL,
  `storeysfrom` varchar(50) NOT NULL,
  `pushingfrom` varchar(50) NOT NULL,
  PRIMARY KEY (`leadid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `leadmoveto`
--

CREATE TABLE IF NOT EXISTS `leadmoveto` (
  `leadid` varchar(10) NOT NULL,
  `addressto` varchar(255) NOT NULL,
  `storeysto` varchar(50) NOT NULL,
  `pushingto` varchar(50) NOT NULL,
  PRIMARY KEY (`leadid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `leadother`
--

CREATE TABLE IF NOT EXISTS `leadother` (
  `leadid` varchar(10) NOT NULL,
  `other` varchar(100) NOT NULL,
  `charge` varchar(10) NOT NULL,
  PRIMARY KEY (`leadid`,`other`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `leadremark`
--

CREATE TABLE IF NOT EXISTS `leadremark` (
  `leadid` varchar(10) NOT NULL,
  `remark` varchar(255) NOT NULL,
  PRIMARY KEY (`leadid`,`remark`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `leadservice`
--

CREATE TABLE IF NOT EXISTS `leadservice` (
  `leadid` varchar(10) NOT NULL,
  `service` varchar(100) NOT NULL,
  `charge` varchar(10) NOT NULL,
  `manpower` varchar(10) NOT NULL,
  `remarks` varchar(255) NOT NULL,
  PRIMARY KEY (`leadid`,`service`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `leadtype`
--

CREATE TABLE IF NOT EXISTS `leadtype` (
  `type` varchar(20) NOT NULL,
  PRIMARY KEY (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `leadtype`
--

INSERT INTO `leadtype` (`type`) VALUES
('Enquiry'),
('Sales');

-- --------------------------------------------------------

--
-- Table structure for table `leadvimboxitem`
--

CREATE TABLE IF NOT EXISTS `leadvimboxitem` (
  `leadid` varchar(10) NOT NULL,
  `itemname` varchar(100) NOT NULL,
  `itemremark` varchar(255) NOT NULL,
  `itemcharge` varchar(10) NOT NULL,
  `itemqty` varchar(10) NOT NULL,
  `itemunit` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `movetype`
--

CREATE TABLE IF NOT EXISTS `movetype` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(20) NOT NULL,
  PRIMARY KEY (`id`,`type`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `movetype`
--

INSERT INTO `movetype` (`id`, `type`) VALUES
(2, 'Residential'),
(3, 'Office'),
(4, 'Disposal'),
(5, 'Storage');

-- --------------------------------------------------------

--
-- Table structure for table `referrals`
--

CREATE TABLE IF NOT EXISTS `referrals` (
  `source` varchar(30) NOT NULL,
  PRIMARY KEY (`source`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `referrals`
--

INSERT INTO `referrals` (`source`) VALUES
('Friend'),
('Magazine'),
('Website');

-- --------------------------------------------------------

--
-- Table structure for table `services`
--

CREATE TABLE IF NOT EXISTS `services` (
  `primary_service` varchar(50) NOT NULL,
  `secondary_service` varchar(50) NOT NULL,
  `formula` varchar(50) DEFAULT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY (`primary_service`,`secondary_service`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `services`
--

INSERT INTO `services` (`primary_service`, `secondary_service`, `formula`, `description`) VALUES
('Manpower', 'Internal Moving', '160 x MP', ''),
('Manpower', 'Manpower Request', '60 x MP', ''),
('Moving', 'Local', '4.8 x U + AC', 'Provision of Local Moving Service'),
('Packing', 'Local', 'B / 50 x 160', 'Provision of Local Packing Service'),
('Unpacking', 'Local', 'B / 50 x 120', 'Provision of Local Unpacking Service');

-- --------------------------------------------------------

--
-- Table structure for table `sources`
--

CREATE TABLE IF NOT EXISTS `sources` (
  `source` varchar(100) NOT NULL,
  PRIMARY KEY (`source`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `sources`
--

INSERT INTO `sources` (`source`) VALUES
('Call'),
('Email');

-- --------------------------------------------------------

--
-- Table structure for table `special_items`
--

CREATE TABLE IF NOT EXISTS `special_items` (
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `special_items`
--

INSERT INTO `special_items` (`name`) VALUES
('Bed (Compartment bed)'),
('Massage Chair'),
('Piano'),
('Safe'),
('Statue');

-- --------------------------------------------------------

--
-- Table structure for table `ticketcomments`
--

CREATE TABLE IF NOT EXISTS `ticketcomments` (
  `id` varchar(8) NOT NULL,
  `comment` varchar(255) NOT NULL,
  `datetiming` datetime NOT NULL,
  PRIMARY KEY (`id`,`datetiming`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tickets`
--

CREATE TABLE IF NOT EXISTS `tickets` (
  `id` varchar(8) NOT NULL,
  `owneruser` varchar(100) NOT NULL,
  `subject` varchar(100) NOT NULL,
  `datetiming` datetime NOT NULL,
  `assigned` varchar(200) NOT NULL,
  `custname` varchar(100) NOT NULL,
  `custcontact` varchar(20) NOT NULL,
  `description` varchar(255) NOT NULL,
  `solution` varchar(255) NOT NULL,
  `status` varchar(10) NOT NULL,
  `custemail` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `fullname` varchar(100) NOT NULL,
  `modules` varchar(100) NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`username`, `password`, `fullname`, `modules`) VALUES
('admin', 'password123', 'NGO Yu Sheng', 'ticket'),
('chunkit', 'password', 'CHOW Chun Kit', 'ticket'),
('khairul', 'password', 'KHAIRUL Anwar Bin Johari', 'ticket');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
