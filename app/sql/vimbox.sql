-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Sep 15, 2016 at 04:00 AM
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
-- Table structure for table `access_control`
--

CREATE TABLE IF NOT EXISTS `access_control` (
  `page` varchar(255) NOT NULL,
  `modules` varchar(255) NOT NULL,
  PRIMARY KEY (`page`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `access_control`
--

INSERT INTO `access_control` (`page`, `modules`) VALUES
('AdminLeads.jsp', 'Admin'),
('AddFollowUpComment.jsp', 'Admin|Sales'),
('AssignJobs.jsp', 'Admin|Operations'),
('ChangePassword.jsp', 'Admin|Operations|SiteSurvey|HR|Sales'),
('CreateCustomer.jsp', 'Admin|Sales'),
('CreateEmployee.jsp', 'Admin|HR'),
('CreateLead.jsp', 'Admin|Sales'),
('CreateLeaveMC.jsp', 'Admin|HR'),
('CreatePayslip.jsp', 'Admin|HR'),
('CreateTicket.jsp', 'Admin|Operations|SiteSurvey|HR|Sales'),
('EditAttendance.jsp', 'Admin|HR'),
('EditCustomer.jsp', 'Admin|Sales'),
('EditEmployee.jsp', 'Admin|HR'),
('EditLead.jsp', 'Admin|Sales'),
('EditPayslip.jsp', 'Admin|HR'),
('EditTicket.jsp', 'Admin|Operations|SiteSurvey|HR|Sales'),
('FullTimeEmployees.jsp', 'Admin|HR'),
('header.jsp', 'Admin|Operations|SiteSurvey|HR|Sales'),
('HomePage.jsp', 'Admin|Operations|SiteSurvey|HR|Sales'),
('LeadsHistory.jsp', 'Admin|Sales'),
('LeaveMCs.jsp', 'Admin|HR'),
('LoadAdminLeads.jsp', 'Admin'),
('LoadAssignedMovers.jsp', 'Admin|Sales|Operations'),
('LoadAssignJobModal.jsp', 'Admin|Sales|Operations'),
('LoadAssignJobs.jsp', 'Admin|Operations'),
('LoadAttendancesViewModal.jsp', 'Admin|HR'),
('LoadAttendancesYM.jsp', 'Admin|HR'),
('LoadEmployees.jsp', 'Admin|HR'),
('LoadLeaveMC.jsp', 'Admin|HR'),
('LoadLeaveMCNric.jsp', 'Admin|HR'),
('LoadMyLeads.jsp', 'Admin|Sales'),
('LoadMySurveyMonthlySchedule.jsp', 'Admin|SiteSurvey'),
('LoadMySurveySchedule.jsp', 'Admin|SiteSurvey'),
('LoadMySurveyWeeklySchedule.jsp', 'Admin|SiteSurvey'),
('LoadPayslips.jsp', 'Admin|HR'),
('LoadSales.jsp', 'Admin|Sales'),
('LoadSalesOperations.jsp', 'Admin|Sales'),
('LoadSalesSurveys.jsp', 'Admin|Sales|SiteSurvey'),
('LoadServices.jsp', 'Admin|Sales'),
('LoadSiteInfoTable.jsp', 'Admin|Sales'),
('LoadSurvey.jsp', 'Admin|SiteSurvey|Sales'),
('LoadSurveyItemsTable.jsp', 'Admin|SiteSurvey|Sales'),
('LoadSurveys.jsp', 'Admin|SiteSurvey|Sales'),
('LoadSurveyVimboxTable.jsp', 'Admin|SiteSurvey|Sales'),
('LoadViewDOM.jsp', 'Admin|Sales'),
('LoadViewEmployeeModal.jsp', 'Admin|HR'),
('LoadViewLeadDOM.jsp', 'Admin|Sales'),
('MovingCalendar.jsp', 'Admin|Sales'),
('MovingCalendarPopulate.jsp', 'Admin|Sales'),
('MyJobs.jsp', 'Admin|Operations'),
('MyLeads.jsp', 'Admin|Sales'),
('MyLeadsAction.jsp', 'Admin|Sales'),
('MyScheduleCalendar.jsp', 'Admin|SiteSurvey'),
('MySites.jsp', 'Admin|SiteSurvey'),
('MySiteSurveySchedules.jsp', 'Admin|SiteSurvey'),
('MyTickets.jsp', 'Admin|Operations|SiteSurvey|HR|Sales'),
('PartTimeEmployees.jsp', 'Admin|HR'),
('Payslips.jsp', 'Admin|HR'),
('PopulateLeadFields.jsp', 'Admin|Sales'),
('RetrieveEmployeeDesignations.jsp', 'Admin|HR'),
('RetrieveLeadDetails.jsp', 'Admin|Sales'),
('RetrieveLeadFollowup.jsp', 'Admin|Sales'),
('RetrieveMovers.jsp', 'Admin|Operations'),
('RetrieveMovingSchedule.jsp', 'Admin|Operations|Sales'),
('RetrievePayslipDetails.jsp', 'Admin|HR'),
('RetrieveSalesPortion.jsp', 'Admin|Operations|Sales'),
('RetrieveSiteSurveyorSchedule.jsp', 'Admin|SiteSurvey|Sales'),
('RetrieveSurveyDetails.jsp', 'Admin|SiteSurvey|Sales'),
('RetrieveTicket.jsp', 'Admin|Operation|SiteSurvey|HR|Sales'),
('RetrieveTicketComment.jsp', 'Admin|Operations|SiteSurvey|HR|Sales'),
('SalesOperations.jsp', 'Admin|Sales'),
('SalesSites.jsp', 'Admin|Sales'),
('SearchCustomers.jsp', 'Admin|Operations|SiteSurvey|HR|Sales'),
('SearchCustomersByName.jsp', 'Admin|Operations|SiteSurvey|HR|Sales'),
('SearchSecondaryServices.jsp', 'Admin|Sales'),
('SearchTickets.jsp', 'Admin|Operations|SiteSurvey|HR|Sales'),
('SiteSurveyCalendar.jsp', 'Admin|SiteSurvey|Sales'),
('SiteSurveyCalendarPopulate.jsp', 'Admin|SiteSurvey|Sales'),
('StartSurvey.jsp', 'Admin|SiteSurvey'),
('SupervisorDailyJobs.jsp', 'Admin|Operations'),
('SupervisorEditAttendance.jsp', 'Admin|Operations'),
('SupervisorJobs.jsp', 'Admin|Operations'),
('SupervisorJobsCalendar.jsp', 'Admin|Operations'),
('SupervisorTakeAttendance.jsp', 'Admin|Operations'),
('surveyHeader.jsp', 'Admin|SiteSurvey'),
('TakeAttendance.jsp', 'Admin|HR'),
('TicketForum.jsp', 'Admin|Operations|SiteSurvey|HR|Sales'),
('TicketsHistory.jsp', 'Admin|Operations|SiteSurvey|HR|Sales'),
('ViewAttendance.jsp', 'Admin|HR');

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`customer_id`, `salutation`, `first_name`, `last_name`, `contact`, `email`) VALUES
(1, 'Ms', 'pamelas', 'seah', 90827736, 'pamela@gmail.com'),
(2, 'Mr', 'khairul', 'anwar', 98873304, 'khairul@gmail.com'),
(3, 'Mr', 'test', '', 89765432, ''),
(4, 'Mr', 'Test', 'test', 72947462, ''),
(5, 'Ms', 'Subin', 'Gan', 62745293, '');

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
(5, 382715999);

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
-- Table structure for table `leadconfirmation`
--

CREATE TABLE IF NOT EXISTS `leadconfirmation` (
  `lead_id` int(10) NOT NULL,
  `confirmed_user` varchar(20) NOT NULL,
  `total_amount` double NOT NULL,
  `collected_amount` double NOT NULL,
  `email_path` varchar(255) NOT NULL,
  PRIMARY KEY (`lead_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `leadconfirmation`
--

INSERT INTO `leadconfirmation` (`lead_id`, `confirmed_user`, `total_amount`, `collected_amount`, `email_path`) VALUES
(382715999, '', 0, 0, '');

-- --------------------------------------------------------

--
-- Table structure for table `leadcustitem`
--

CREATE TABLE IF NOT EXISTS `leadcustitem` (
  `lead_id` int(10) NOT NULL,
  `sales_div` varchar(255) NOT NULL,
  `survey_area` varchar(50) NOT NULL,
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
(382715999, 'SELECT');

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

INSERT INTO `leadinfo` (`owner_user`, `lead_id`, `type`, `customer_id`, `tom`, `datetime_of_creation`, `status`, `reason`, `source`, `referral`) VALUES
('S9344895B', 382715999, 'Sales', 5, '', '2016-09-13 19:44:20', 'Rejected', 'Test', 'Call', 'Friend');

-- --------------------------------------------------------

--
-- Table structure for table `leadmaterial`
--

CREATE TABLE IF NOT EXISTS `leadmaterial` (
  `lead_id` int(10) NOT NULL,
  `sales_div` varchar(255) NOT NULL,
  `survey_area` varchar(50) NOT NULL,
  `materialname` varchar(100) NOT NULL,
  `materialqty` varchar(10) NOT NULL,
  `materialcharge` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `leadmove`
--

CREATE TABLE IF NOT EXISTS `leadmove` (
  `lead_id` int(10) NOT NULL,
  `sales_div` varchar(255) NOT NULL,
  `type` varchar(10) NOT NULL,
  `address` varchar(255) NOT NULL,
  `storeys` varchar(50) NOT NULL,
  `pushing` varchar(50) NOT NULL,
  PRIMARY KEY (`lead_id`,`sales_div`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `leadmove`
--

INSERT INTO `leadmove` (`lead_id`, `sales_div`, `type`, `address`, `storeys`, `pushing`) VALUES
(382715999, 'sales1|39 Cambridge Rd #1-1 S210039', 'from', '39 Cambridge Rd_1_1_210039', ' ', ' '),
(382715999, 'sales2|864 Yishun Ave 4, Block 864 #11-11 S760864', 'to', '864 Yishun Ave 4, Block 864_11_11_760864', ' ', ' ');

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
(382715999, 'sales1|39 Cambridge Rd #1-1 S210039', 'storeyCharge', '0.00'),
(382715999, 'sales1|39 Cambridge Rd #1-1 S210039', 'pushCharge', '0.00'),
(382715999, 'sales1|39 Cambridge Rd #1-1 S210039', 'detourCharge', '0.00'),
(382715999, 'sales1|39 Cambridge Rd #1-1 S210039', 'materialCharge', '0.00'),
(382715999, 'sales1|39 Cambridge Rd #1-1 S210039', 'markup', '0.00'),
(382715999, 'sales1|39 Cambridge Rd #1-1 S210039', 'discount', '0.00'),
(382715999, 'sales2|864 Yishun Ave 4, Block 864 #11-11 S760864', 'storeyCharge', '0.00'),
(382715999, 'sales2|864 Yishun Ave 4, Block 864 #11-11 S760864', 'pushCharge', '0.00'),
(382715999, 'sales2|864 Yishun Ave 4, Block 864 #11-11 S760864', 'detourCharge', '0.00'),
(382715999, 'sales2|864 Yishun Ave 4, Block 864 #11-11 S760864', 'materialCharge', '0.00'),
(382715999, 'sales2|864 Yishun Ave 4, Block 864 #11-11 S760864', 'markup', '0.00'),
(382715999, 'sales2|864 Yishun Ave 4, Block 864 #11-11 S760864', 'discount', '0.00');

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
  `survey_area` varchar(255) NOT NULL,
  `survey_area_name` varchar(255) NOT NULL,
  PRIMARY KEY (`lead_id`,`sales_div`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `leadsalesdiv`
--

INSERT INTO `leadsalesdiv` (`lead_id`, `sales_div`, `survey_area`, `survey_area_name`) VALUES
(382715999, 'sales1|39 Cambridge Rd #1-1 S210039', '', ''),
(382715999, 'sales2|864 Yishun Ave 4, Block 864 #11-11 S760864', '', '');

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

-- --------------------------------------------------------

--
-- Table structure for table `leadvimboxitem`
--

CREATE TABLE IF NOT EXISTS `leadvimboxitem` (
  `lead_id` int(10) NOT NULL,
  `sales_div` varchar(255) NOT NULL,
  `survey_area` varchar(50) NOT NULL,
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
-- Table structure for table `operations_assigned`
--

CREATE TABLE IF NOT EXISTS `operations_assigned` (
  `lead_id` int(10) NOT NULL,
  `ss_owner` varchar(10) NOT NULL,
  `supervisor` varchar(20) NOT NULL,
  `carplate_no` varchar(255) NOT NULL,
  `address_tag` varchar(50) NOT NULL,
  `address` varchar(255) NOT NULL,
  `dom` date NOT NULL,
  `start_datetime` datetime NOT NULL,
  `end_datetime` datetime NOT NULL,
  `timeslot` varchar(255) NOT NULL,
  `remarks` varchar(255) NOT NULL,
  `status` varchar(20) NOT NULL,
  PRIMARY KEY (`lead_id`,`carplate_no`,`dom`,`start_datetime`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `operations_assigned`
--

INSERT INTO `operations_assigned` (`lead_id`, `ss_owner`, `supervisor`, `carplate_no`, `address_tag`, `address`, `dom`, `start_datetime`, `end_datetime`, `timeslot`, `remarks`, `status`) VALUES
(382715999, 'S9344895B', '1234567', 'SFX6729B', 'from|to|', '39 Cambridge Rd #1-1 S210039|864 Yishun Ave 4, Block 864 #11-11 S760864|', '2016-09-15', '2016-09-15 13:00:00', '2016-09-15 13:30:00', '1300 - 1400', '', 'Confirmed'),
(382715999, 'S9344895B', '1234567', 'SFX6729B', 'from|to|', '39 Cambridge Rd #1-1 S210039|864 Yishun Ave 4, Block 864 #11-11 S760864|', '2016-09-15', '2016-09-15 13:30:00', '2016-09-15 14:00:00', '1300 - 1400', '', 'Confirmed'),
(382715999, 'S9289374H', '1234567', 'SFX6729B', 'from|to|', '39 Cambridge Rd #1-1 S210039|864 Yishun Ave 4, Block 864 #11-11 S760864|', '2016-09-16', '2016-09-16 12:30:00', '2016-09-16 13:00:00', '1230 - 1330', '', 'Confirmed'),
(382715999, 'S9289374H', '1234567', 'SFX6729B', 'from|to|', '39 Cambridge Rd #1-1 S210039|864 Yishun Ave 4, Block 864 #11-11 S760864|', '2016-09-16', '2016-09-16 13:00:00', '2016-09-16 13:30:00', '1230 - 1330', '', 'Confirmed');

-- --------------------------------------------------------

--
-- Table structure for table `operations_attendance`
--

CREATE TABLE IF NOT EXISTS `operations_attendance` (
  `supervisor` varchar(20) NOT NULL,
  `assigned_mover` varchar(20) NOT NULL,
  `dom` date NOT NULL,
  `attendance` varchar(10) NOT NULL,
  `duration` int(11) NOT NULL,
  PRIMARY KEY (`supervisor`,`assigned_mover`,`dom`)
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

--
-- Dumping data for table `payslips`
--

INSERT INTO `payslips` (`payslip_id`, `nric`, `payment_mode`, `start_date`, `end_date`, `payment_date`, `basic`, `allowance`, `deduction`, `overtime_hr`, `overtime`, `additional`, `employer_cpf`) VALUES
(21003844, 'S9887362K', 'Cheque', '2016-08-01', '2016-08-31', '2016-08-31', 3000, 0, 600, 0, 0, 0, 510),
(22530242, 'S9289374H', 'Cheque', '2016-08-01', '2016-08-31', '2016-08-31', 3000, 0, 600, 0, 0, 0, 510),
(72599972, '1234567', 'Cheque', '2016-08-01', '2016-08-31', '2016-08-31', 1234, 0, 315.36, 0, 0, 100, 209.78),
(88547686, 'S9344895B', 'Cheque', '2016-08-01', '2016-08-31', '2016-08-31', 6000, 0, 1200, 0, 0, 0, 1020);

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

--
-- Dumping data for table `payslips_apbd`
--

INSERT INTO `payslips_apbd` (`payslip_id`, `description`, `breakdown`) VALUES
(72599972, 'trfswd', 100);

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
(21003844, 'Employee''s CPF Deduction', 600),
(22530242, 'Employee''s CPF Deduction', 600),
(72599972, 'Absent - 1 day(s)', 68.56),
(72599972, 'Employee''s CPF Deduction', 246.8),
(88547686, 'Employee''s CPF Deduction', 1200);

-- --------------------------------------------------------

--
-- Table structure for table `sitesurvey_assigned`
--

CREATE TABLE IF NOT EXISTS `sitesurvey_assigned` (
  `lead_id` int(10) NOT NULL,
  `ss_owner` varchar(10) NOT NULL,
  `ss_user` varchar(10) NOT NULL,
  `address_tag` varchar(50) NOT NULL,
  `address` varchar(255) NOT NULL,
  `start_datetime` datetime NOT NULL,
  `end_datetime` datetime NOT NULL,
  `timeslot` varchar(255) NOT NULL,
  `remarks` varchar(255) NOT NULL,
  `status` varchar(20) NOT NULL,
  PRIMARY KEY (`lead_id`,`start_datetime`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `sitesurvey_assigned`
--

INSERT INTO `sitesurvey_assigned` (`lead_id`, `ss_owner`, `ss_user`, `address_tag`, `address`, `start_datetime`, `end_datetime`, `timeslot`, `remarks`, `status`) VALUES
(382715999, 'S9344895B', 'S9289374H', 'from|', '39 Cambridge Rd #1-1 S210039|', '2016-09-15 13:30:00', '2016-09-15 14:00:00', '1330 - 1430', '', 'Completed'),
(382715999, 'S9344895B', 'S9289374H', 'from|', '39 Cambridge Rd #1-1 S210039|', '2016-09-15 14:00:00', '2016-09-15 14:30:00', '1330 - 1430', '', 'Completed');

-- --------------------------------------------------------

--
-- Table structure for table `system_enquiries`
--

CREATE TABLE IF NOT EXISTS `system_enquiries` (
  `enquiry` varchar(255) NOT NULL,
  PRIMARY KEY (`enquiry`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `system_enquiries`
--

INSERT INTO `system_enquiries` (`enquiry`) VALUES
('Material Prices'),
('Site Survey availability');

-- --------------------------------------------------------

--
-- Table structure for table `system_items`
--

CREATE TABLE IF NOT EXISTS `system_items` (
  `name` varchar(50) NOT NULL,
  `description` varchar(100) NOT NULL,
  `dimensions` varchar(50) NOT NULL,
  `units` varchar(10) NOT NULL,
  `img` varchar(255) NOT NULL,
  PRIMARY KEY (`name`,`description`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `system_items`
--

INSERT INTO `system_items` (`name`, `description`, `dimensions`, `units`, `img`) VALUES
('Arm Chair', '', '', '4', ''),
('Bed (Bunk bed)', 'Double Single', '', '30', ''),
('Bed (Bunk bed)', 'Queen + Single', '', '34', ''),
('Bed (Bunk bed)', 'Queen top bed', '', '24', ''),
('Bed (Bunk bed)', 'Single top bed', '', '16', ''),
('Bed (Canopy)', 'King', '', '34', ''),
('Bed (Canopy)', 'Queen', '', '28', ''),
('Bed (Canopy)', 'Single', '', '20', ''),
('Bed with no storage', 'King', '', '20', ''),
('Bed with no storage', 'Queen', '', '16', ''),
('Bed with no storage', 'Single', '', '10', ''),
('Bed with storage & frame', 'King', '', '30', ''),
('Bed with storage & frame', 'Queen', '', '24', ''),
('Bed with storage & frame', 'Single', '', '16', ''),
('Bench L', '', 'Less than 152W x 38D x 38H', '4', ''),
('Bench M', '', 'Less than 114W x 38D x 38H', '3', ''),
('Bench S', '', 'Less than 76W x 38D x 38H', '2', ''),
('Bookshelf', '', '80W x 28D x 202H', '5', ''),
('Chairs (Office)', 'Wheeled & Movable', '', '2', ''),
('Chairs x2', '', '', '2', ''),
('Chest of Drawers L', '', 'L & H Less than 114cm', '6', ''),
('Chest of Drawers M', '', 'L & H Less than 76cm', '4', ''),
('Chest of Drawers S', '', 'L & H Less than 38cm', '2', ''),
('Chiller standard size', '', '60W x 57D x 82H', '4', ''),
('Coffee Table L', '', 'Less than 76W x 76L x 38H', '4', ''),
('Coffee Table S', '', 'Less than 38W x 76L x 38H', '2', ''),
('Computer', 'CPU + Monitor + keyboard + Mouse', '', '2', ''),
('Computer', 'CPU + Monitor + keyboard + Mouse + Printer', '', '3', ''),
('Dining Chair x2', '', '', '2', ''),
('Dining Table', '4 Person', '76L x 76W x 76H', '8', ''),
('Dining Table', '6 Person', '152L x 95W x 76H', '12', '/images/items/dining_table_6_seater.png'),
('Dining Table', '8 Person', '228L x 95W x 76H', '19', ''),
('Dining Table', 'More than 8 Person', 'Depending on L & W', '', ''),
('Display Cabinet', '2 doors', '96W x 42D x 215H', '10', ''),
('Display Cabinet', 'No doors', '78W x 41D x 95H', '4', ''),
('Display Console', '', '', '4', ''),
('Dressing Table L', 'With mirror', '120W x 42D x 77H', '9', ''),
('Dressing Table S', 'With mirror', '70W x 42D x 77H', '6', ''),
('Dryer', '', '', '4', ''),
('Freezer', '', '61W x 66D x 90H', '4', ''),
('Fridge', '1 Door', '70W x 72D x 178H', '10', ''),
('Fridge', '2 Doors', '92W x 73D x 175H', '14', ''),
('Iron + Board', '', '', '2', ''),
('Lamp', '', '', '1', ''),
('Oven L', '', 'Above 38 x 60 x 38', '2', ''),
('Oven S', '', '38 x 60 x 38 and below', '1', ''),
('Pigeon Hole', 'Units depend on holes', '', '4', ''),
('Rack', 'Clothes Rack', '', '2', ''),
('Rack', 'Hats & Coat stand', '', '1', ''),
('Side Table', 'Bed side', '', '2', ''),
('Sofa', '1 Seater', '105W x 99D x 83H', '10', ''),
('Sofa', '2 Seater', '190W x 95D x 83H', '17', ''),
('Sofa', '2 Seater L Shape', '', '25', ''),
('Sofa', '3 Seater', '228W x 95D x 83H', '21', ''),
('Sofa', '3 Seater L Shape', '', '29', ''),
('Speaker Set', '', '', '1', ''),
('Standing fan', '', '', '1', ''),
('Study Desk L', '', '160L x 80D x 65H', '10', ''),
('Study Desk S', '', '120L x 80D x 65H', '7', ''),
('Tv Console', '', '', '6', ''),
('Wall Shelves', '', '146W x 23D x 47H', '2', ''),
('Wardrobe', '2 Doors', '110W x 60D x 208H', '16', ''),
('Wardrobe', '3 Doors', '150W x 60D x 236H', '24', ''),
('Wardrobe', '3 includes sliding doors', '200W x 66D x 236H', '36', ''),
('Washing Machine', '', '', '4', '');

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
('Full', 'IT', 'Manager', 'Admin', 5),
('Full', 'Operations', 'Mover', 'Operation', 6),
('Full', 'Sales', 'Surveyor', 'SiteSurvey', 5),
('Part', 'Admin', 'Part-Time Clerk', '', 5),
('Part', 'Operations', 'Part-Time Mover', '', 6);

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
  `img` varchar(255) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `system_special_items`
--

INSERT INTO `system_special_items` (`name`, `img`) VALUES
('Bed (Compartment bed)', ''),
('Massage Chair', ''),
('Piano', '/images/items/piano.jpg'),
('Safe', ''),
('Statue', '/images/items/statue.png');

-- --------------------------------------------------------

--
-- Table structure for table `system_vimbox_materials`
--

CREATE TABLE IF NOT EXISTS `system_vimbox_materials` (
  `name` varchar(50) NOT NULL,
  `charge` varchar(10) NOT NULL,
  `img` varchar(255) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `system_vimbox_materials`
--

INSERT INTO `system_vimbox_materials` (`name`, `charge`, `img`) VALUES
('Bubblewrap', '', '/images/items/bubblewrap.png');

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
-- Table structure for table `trucks`
--

CREATE TABLE IF NOT EXISTS `trucks` (
  `carplate_no` varchar(10) NOT NULL,
  `name` varchar(200) NOT NULL,
  PRIMARY KEY (`carplate_no`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `trucks`
--

INSERT INTO `trucks` (`carplate_no`, `name`) VALUES
('SFX6729B', 'Truck 2'),
('SGX4526F', 'Truck 1');

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
  `license` varchar(255) NOT NULL,
  `department` varchar(100) NOT NULL,
  `designation` varchar(100) NOT NULL,
  `salary` int(10) NOT NULL,
  `type` varchar(5) NOT NULL,
  PRIMARY KEY (`nric`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`nric`, `first_name`, `last_name`, `date_joined`, `mailing_address`, `registered_address`, `license`, `department`, `designation`, `salary`, `type`) VALUES
('1234567', 'test', 'test', '2016-08-16', 'TestingAgainOk', '', '', 'Operations', 'Mover', 1234, 'Full'),
('S9289374H', 'SiteSurveyor', '1', '2016-08-12', 'Test', '', '', 'Sales', 'Surveyor', 3000, 'Full'),
('S9344895B', 'Yu Sheng', 'Ngo', '2016-06-18', 'Yishun Ave 4 Blk 864 #11-37 S760864', '', '', 'IT', 'Manager', 6000, 'Full'),
('S9887362K', 'SiteSurveyor', '2', '2016-08-12', 'Test', '', '', 'Sales', 'Surveyor', 3000, 'Full');

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
('S9289374H', '1@sitesurvey.com', 'password'),
('S9887362K', '2@sitesurvey.com', 'password'),
('S9344895B', 'admin', 'password'),
('1234567', 'test@test.com', 'password');

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
('1234567', '2016-08-30', 'Absent', 0),
('S9289374H', '2016-08-30', 'Present', 0),
('S9344895B', '2016-08-30', 'Present', 0),
('S9887362K', '2016-08-30', 'Present', 0);

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
('1234567', 'Cheque', 'dewfwe', 'wefewf', '1245634'),
('S9289374H', 'Cheque', 'DBS', 'site1-account', '123456789'),
('S9344895B', 'Cheque', 'DBS', 'yusheng account', '123-4567-8'),
('S9887362K', 'Cheque', 'DBS', 'sitesurvey2-account', '123456789');

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
('1234567', 12345678, 0, 0),
('S9289374H', 12345678, 0, 0),
('S9344895B', 97312965, 0, 67384625),
('S9887362K', 12345678, 0, 0);

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
('1234567', 'test', 'etst', 12344567, 0),
('S9289374H', 'Mother', 'mother', 12345678, 0),
('S9344895B', 'Phua Kuee Hoy', 'Mother', 85732675, 0),
('S9887362K', 'Mother', 'mother', 12345678, 0);

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
('1234567', '2016-08-16', 56, 14, 0, 0),
('S9289374H', '2016-08-12', 56, 14, 0, 0),
('S9344895B', '2016-06-18', 56, 14, 0, 5),
('S9887362K', '2016-08-12', 56, 14, 0, 0);

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
  `img` varchar(255) NOT NULL,
  PRIMARY KEY (`nric`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users_leave_record`
--

INSERT INTO `users_leave_record` (`leave_type`, `leave_name`, `nric`, `date`, `time_string`, `leave_duration`, `img`) VALUES
('Paid', 'MC', 'S9344895B', '2016-09-16', '0900 - 1800', 9, '/images/MC/S9344895B-MC-16092016-17092016.png');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
