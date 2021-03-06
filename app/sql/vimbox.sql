-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Oct 20, 2016 at 07:02 AM
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
('AddFollowUpComment.jsp', 'Admin|Sales'),
('AllLeads.jsp', 'Admin|Sales'),
('AssignJobs.jsp', 'Admin|Operation'),
('ChangePassword.jsp', 'Admin|Operation|SiteSurvey|HR|Sales|Supervisor'),
('CreateCustomer.jsp', 'Admin|Sales'),
('CreateEmployee.jsp', 'Admin|HR'),
('CreateLead.jsp', 'Admin|Sales'),
('CreateLeaveMC.jsp', 'Admin|HR'),
('CreatePayslip.jsp', 'Admin|HR'),
('CreateTicket.jsp', 'Admin|Operation|SiteSurvey|HR|Sales|Supervisor'),
('Drafts.jsp', 'Admin|Operation|SiteSurvey|HR|Sales|Supervisor'),
('EditAttendance.jsp', 'Admin|HR'),
('EditCustomer.jsp', 'Admin|Sales'),
('EditEmployee.jsp', 'Admin|HR'),
('EditLead.jsp', 'Admin|Sales'),
('EditPayslip.jsp', 'Admin|HR'),
('EditTicket.jsp', 'Admin|Operation|SiteSurvey|HR|Sales|Supervisor'),
('FullTimeEmployees.jsp', 'Admin|HR'),
('header.jsp', 'Admin|Operation|SiteSurvey|HR|Sales|Supervisor'),
('HomePage.jsp', 'Admin|Operation|SiteSurvey|HR|Sales|Supervisor'),
('Inbox.jsp', 'Admin|Operation|SiteSurvey|HR|Sales|Supervisor'),
('LeadsHistory.jsp', 'Admin|Sales'),
('LeaveMCs.jsp', 'Admin|HR'),
('LoadAdminLeads.jsp', 'Admin'),
('LoadAllLeads.jsp', 'Admin|Sales'),
('LoadAssignedMovers.jsp', 'Admin|Sales|Operation'),
('LoadAssignJobModal.jsp', 'Admin|Sales|Operation'),
('LoadAssignJobs.jsp', 'Admin|Operation'),
('LoadAttendancesViewModal.jsp', 'Admin|HR'),
('LoadAttendancesYM.jsp', 'Admin|HR'),
('LoadEmployees.jsp', 'Admin|HR'),
('LoadLeaveMC.jsp', 'Admin|HR'),
('LoadLeaveMCNric.jsp', 'Admin|HR'),
('LoadMonthSalesReport.jsp', 'Admin|Sales'),
('LoadMySurveyMonthlySchedule.jsp', 'Admin|SiteSurvey'),
('LoadMySurveySchedule.jsp', 'Admin|SiteSurvey'),
('LoadMySurveyWeeklySchedule.jsp', 'Admin|SiteSurvey'),
('LoadPayslips.jsp', 'Admin|HR'),
('LoadSales.jsp', 'Admin|Sales'),
('LoadSalesOperations.jsp', 'Admin|Sales'),
('LoadSalesReport.jsp', 'Admin|Sales'),
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
('LoadYearSalesReport.jsp', 'Admin|Sales'),
('MovingCalendar.jsp', 'Admin|Sales'),
('MovingCalendarPopulate.jsp', 'Admin|Sales'),
('MyJobs.jsp', 'Admin|Operation'),
('MyLeadsAction.jsp', 'Admin|Sales'),
('MyScheduleCalendar.jsp', 'Admin|SiteSurvey'),
('MySites.jsp', 'Admin|SiteSurvey'),
('MySiteSurveySchedules.jsp', 'Admin|SiteSurvey'),
('MyTickets.jsp', 'Admin|Operation|SiteSurvey|HR|Sales|Supervisor'),
('NewMessage.jsp', 'Admin|Operation|SiteSurvey|HR|Sales|Supervisor'),
('PartTimeEmployees.jsp', 'Admin|HR'),
('Payslips.jsp', 'Admin|HR'),
('PopulateLeadFields.jsp', 'Admin|Sales'),
('RetrieveEmployeeDesignations.jsp', 'Admin|HR'),
('RetrieveLeadDetails.jsp', 'Admin|Sales'),
('RetrieveLeadFollowup.jsp', 'Admin|Sales'),
('RetrieveMovers.jsp', 'Admin|Operation'),
('RetrieveMovingSchedule.jsp', 'Admin|Operation|Sales'),
('RetrievePayslipDetails.jsp', 'Admin|HR'),
('RetrieveSalesPortion.jsp', 'Admin|Operation|Sales'),
('RetrieveSiteSurveyorSchedule.jsp', 'Admin|SiteSurvey|Sales'),
('RetrieveSurveyDetails.jsp', 'Admin|SiteSurvey|Sales'),
('RetrieveTicket.jsp', 'Admin|Operation|SiteSurvey|HR|Sales|Supervisor'),
('RetrieveTicketComment.jsp', 'Admin|Operation|SiteSurvey|HR|Sales|Supervisor'),
('SalesOperations.jsp', 'Admin|Sales'),
('SalesSites.jsp', 'Admin|Sales'),
('SearchCustomers.jsp', 'Admin|Operation|SiteSurvey|HR|Sales|Supervisor'),
('SearchCustomersByName.jsp', 'Admin|Operation|SiteSurvey|HR|Sales|Supervisor'),
('SearchSecondaryServices.jsp', 'Admin|Sales'),
('SearchTickets.jsp', 'Admin|Operation|SiteSurvey|HR|Sales|Supervisor'),
('Sentmail.jsp', 'Admin|Operation|SiteSurvey|HR|Sales|Supervisor'),
('SiteSurveyCalendar.jsp', 'Admin|SiteSurvey|Sales'),
('SiteSurveyCalendarPopulate.jsp', 'Admin|SiteSurvey|Sales'),
('Spam.jsp', 'Admin|Operation|SiteSurvey|HR|Sales|Supervisor'),
('StartSurvey.jsp', 'Admin|SiteSurvey'),
('SupervisorDailyJobs.jsp', 'Admin|Supervisor'),
('SupervisorEditAttendance.jsp', 'Admin|Supervisor'),
('SupervisorJobs.jsp', 'Admin|Supervisor'),
('SupervisorJobsCalendar.jsp', 'Admin|Supervisor'),
('SupervisorTakeAttendance.jsp', 'Admin|Supervisor'),
('surveyHeader.jsp', 'Admin|SiteSurvey'),
('TakeAttendance.jsp', 'Admin|HR'),
('TicketForum.jsp', 'Admin|Operation|SiteSurvey|HR|Sales|Supervisor'),
('TicketsHistory.jsp', 'Admin|Operation|SiteSurvey|HR|Sales|Supervisor'),
('Trash.jsp', 'Admin|Operation|SiteSurvey|HR|Sales|Supervisor'),
('ValueSetup.jsp', 'Admin'),
('ViewAttendance.jsp', 'Admin|HR'),
('ViewSalesReport.jsp', 'Admin|Sales');

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`customer_id`, `salutation`, `first_name`, `last_name`, `contact`, `email`) VALUES
(1, 'Mr', 'Test', 'Test', 99999999, '');

-- --------------------------------------------------------

--
-- Table structure for table `customers_history`
--

CREATE TABLE IF NOT EXISTS `customers_history` (
  `customer_id` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  PRIMARY KEY (`customer_id`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `leadcomment`
--

CREATE TABLE IF NOT EXISTS `leadcomment` (
  `lead_id` int(10) NOT NULL,
  `sales_div` varchar(255) NOT NULL,
  `comment` varchar(1000) NOT NULL
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
  `reason` varchar(1000) NOT NULL,
  `source` varchar(20) NOT NULL,
  `referral` varchar(200) NOT NULL,
  PRIMARY KEY (`owner_user`,`lead_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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

-- --------------------------------------------------------

--
-- Table structure for table `leadquotation`
--

CREATE TABLE IF NOT EXISTS `leadquotation` (
  `ref_num` varchar(50) NOT NULL,
  `service_include` varchar(300) NOT NULL,
  PRIMARY KEY (`ref_num`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `leadremark`
--

CREATE TABLE IF NOT EXISTS `leadremark` (
  `lead_id` int(10) NOT NULL,
  `sales_div` varchar(255) NOT NULL,
  `remark` varchar(1000) NOT NULL
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
-- Table structure for table `notifications`
--

CREATE TABLE IF NOT EXISTS `notifications` (
  `notification_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(20) NOT NULL,
  `message` varchar(255) NOT NULL,
  `status` varchar(10) NOT NULL,
  PRIMARY KEY (`notification_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

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
('Operation Availability'),
('Site Survey availability');

-- --------------------------------------------------------

--
-- Table structure for table `system_items`
--

CREATE TABLE IF NOT EXISTS `system_items` (
  `item_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `dimensions` varchar(50) NOT NULL,
  `units` varchar(10) NOT NULL,
  `img` varchar(255) NOT NULL,
  `item_type` varchar(10) NOT NULL,
  PRIMARY KEY (`item_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=71 ;

--
-- Dumping data for table `system_items`
--

INSERT INTO `system_items` (`item_id`, `name`, `description`, `dimensions`, `units`, `img`, `item_type`) VALUES
(1, 'Arm Chair', '', '', '4', '', 'Normal'),
(2, 'Bed (Bunk bed)', 'Double Single', '', '30', '', 'Normal'),
(3, 'Bed (Bunk bed)', 'Queen + Single', '', '34', '', 'Normal'),
(4, 'Bed (Bunk bed)', 'Queen top bed', '', '24', '', 'Normal'),
(5, 'Bed (Bunk bed)', 'Single top bed', '', '16', '', 'Normal'),
(6, 'Bed (Canopy)', 'King', '', '34', '', 'Normal'),
(7, 'Bed (Canopy)', 'Queen', '', '28', '', 'Normal'),
(8, 'Bed (Canopy)', 'Single', '', '20', '', 'Normal'),
(9, 'Bed with no storage', 'King', '', '20', '', 'Normal'),
(10, 'Bed with no storage', 'Queen', '', '24', '', 'Normal'),
(11, 'Bed with no storage', 'Single', '', '10', '', 'Normal'),
(12, 'Bed with storage & frame', 'King', '', '30', '', 'Normal'),
(13, 'Bed with storage & frame', 'Queen', '', '24', '', 'Normal'),
(14, 'Bed with storage & frame', 'Single', '', '16', '', 'Normal'),
(15, 'Bench L', '', 'Less than 152W x 38D x 38H', '4', '', 'Normal'),
(16, 'Bench M', '', 'Less than 114W x 38D x 38H', '3', '', 'Normal'),
(17, 'Bench S', '', 'Less than 76W x 38D x 38H', '2', '', 'Normal'),
(18, 'Bookshelf', '', '80W x 28D x 202H', '5', '', 'Normal'),
(19, 'Chairs (Office)', 'Wheeled & Movable', '', '2', '', 'Normal'),
(20, 'Chairs x2', '', '', '2', '', 'Normal'),
(21, 'Chest of Drawers L', '', 'L & H Less than 114cm', '6', '', 'Normal'),
(22, 'Chest of Drawers M', '', 'L & H Less than 76cm', '4', '', 'Normal'),
(23, 'Chest of Drawers S', '', 'L & H Less than 38cm', '2', '', 'Normal'),
(24, 'Chiller standard size', '', '60W x 57D x 82H', '4', '', 'Normal'),
(25, 'Coffee Table L', '', 'Less than 76W x 76L x 38H', '4', '', 'Normal'),
(26, 'Coffee Table S', '', 'Less than 38W x 76L x 38H', '2', '', 'Normal'),
(27, 'Computer', 'CPU + Monitor + keyboard + Mouse', '', '2', '', 'Normal'),
(28, 'Computer', 'CPU + Monitor + keyboard + Mouse + Printer', '', '3', '', 'Normal'),
(29, 'Dining Chair x2', '', '', '2', '', 'Normal'),
(30, 'Dining Table', '4 Person', '76L x 76W x 76H', '8', '', 'Normal'),
(31, 'Dining Table', '6 Person', '152L x 95W x 76H', '12', '/images/items/dining_table_6_seater.png', 'Normal'),
(32, 'Dining Table', '8 Person', '228L x 95W x 76H', '19', '', 'Normal'),
(33, 'Dining Table', 'More than 8 Person', 'Depending on L & W', '', '', 'Normal'),
(34, 'Display Cabinet', '2 doors', '96W x 42D x 215H', '10', '', 'Normal'),
(35, 'Display Cabinet', 'No doors', '78W x 41D x 95H', '4', '', 'Normal'),
(36, 'Display Console', '', '', '4', '', 'Normal'),
(37, 'Dressing Table L', 'With mirror', '120W x 42D x 77H', '9', '', 'Normal'),
(38, 'Dressing Table S', 'With mirror', '70W x 42D x 77H', '6', '', 'Normal'),
(39, 'Dryer', '', '', '4', '', 'Normal'),
(40, 'Freezer', '', '61W x 66D x 90H', '4', '', 'Normal'),
(41, 'Fridge', '1 Door', '70W x 72D x 178H', '10', '', 'Normal'),
(42, 'Fridge', '2 Doors', '92W x 73D x 175H', '14', '', 'Normal'),
(43, 'Iron + Board', '', '', '2', '', 'Normal'),
(44, 'Lamp', '', '', '1', '', 'Normal'),
(45, 'Oven L', '', 'Above 38 x 60 x 38', '2', '', 'Normal'),
(46, 'Oven S', '', '38 x 60 x 38 and below', '1', '', 'Normal'),
(47, 'Pigeon Hole', 'Units depend on holes', '', '4', '', 'Normal'),
(48, 'Rack', 'Clothes Rack', '', '2', '', 'Normal'),
(49, 'Rack', 'Hats & Coat stand', '', '1', '', 'Normal'),
(50, 'Side Table', 'Bed side', '', '2', '', 'Normal'),
(51, 'Sofa', '1 Seater', '105W x 99D x 83H', '10', '', 'Normal'),
(52, 'Sofa', '2 Seater', '190W x 95D x 83H', '17', '', 'Normal'),
(53, 'Sofa', '2 Seater L Shape', '', '25', '', 'Normal'),
(54, 'Sofa', '3 Seater', '228W x 95D x 83H', '21', '', 'Normal'),
(55, 'Sofa', '3 Seater L Shape', '', '29', '', 'Normal'),
(56, 'Speaker Set', '', '', '1', '', 'Normal'),
(57, 'Standing fan', '', '', '1', '', 'Normal'),
(58, 'Study Desk L', '', '160L x 80D x 65H', '10', '', 'Normal'),
(59, 'Study Desk S', '', '120L x 80D x 65H', '7', '', 'Normal'),
(60, 'Tv Console', '', '', '6', '', 'Normal'),
(61, 'Wall Shelves', '', '146W x 23D x 47H', '2', '', 'Normal'),
(62, 'Wardrobe', '2 Doors', '110W x 60D x 208H', '16', '', 'Normal'),
(63, 'Wardrobe', '3 Doors', '150W x 60D x 236H', '24', '', 'Normal'),
(64, 'Wardrobe', '3 includes sliding doors', '200W x 66D x 236H', '36', '', 'Normal'),
(65, 'Washing Machine', '', '', '4', '', 'Normal'),
(66, 'Bed (Compartment bed)', '', '', '', '', 'Special'),
(67, 'Massage Chair', '', '', '', '', 'Special'),
(68, 'Piano', '', '', '', '/images/items/piano.jpg', 'Special'),
(69, 'Safe', '', '', '', '', 'Special'),
(70, 'Statue', '', '', '', '/images/items/statue.png', 'Special');

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
('Full', 'HR', 'Manager', 'HR', 5),
('Full', 'Operations', 'Mover', 'Operation', 6),
('Full', 'Operations', 'Supervisor', 'Supervisor', 6),
('Full', 'Sales', 'Sales', 'Sales', 5),
('Full', 'Sales', 'Surveyor', 'SiteSurvey', 5),
('Full', 'Super', 'Admin', 'Admin', 5),
('Part', 'Admin', 'Part-Time Clerk', '', 5),
('Part', 'Operations', 'Part-Time Mover', '', 6);

-- --------------------------------------------------------

--
-- Table structure for table `system_move_types`
--

CREATE TABLE IF NOT EXISTS `system_move_types` (
  `type` varchar(20) NOT NULL,
  `abbreviation` varchar(10) NOT NULL,
  PRIMARY KEY (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `system_move_types`
--

INSERT INTO `system_move_types` (`type`, `abbreviation`) VALUES
('Disposal', 'DIS'),
('International', 'IM'),
('Office', 'OFF'),
('Residential', 'HH'),
('Storage', 'STORE');

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
-- Table structure for table `system_percentage`
--

CREATE TABLE IF NOT EXISTS `system_percentage` (
  `name` varchar(100) NOT NULL,
  `percentage` double NOT NULL,
  PRIMARY KEY (`name`,`percentage`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `system_percentage`
--

INSERT INTO `system_percentage` (`name`, `percentage`) VALUES
('Deposit', 40);

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
('Facebook'),
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
('Email'),
('Live Chat');

-- --------------------------------------------------------

--
-- Table structure for table `system_vimbox_materials`
--

CREATE TABLE IF NOT EXISTS `system_vimbox_materials` (
  `material_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `img` varchar(255) NOT NULL,
  PRIMARY KEY (`material_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `system_vimbox_materials`
--

INSERT INTO `system_vimbox_materials` (`material_id`, `name`, `img`) VALUES
(1, 'Bubblewrap', '/images/items/bubblewrap.png');

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
  `modules` varchar(200) NOT NULL,
  `salary` int(10) NOT NULL,
  `type` varchar(5) NOT NULL,
  PRIMARY KEY (`nric`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`nric`, `first_name`, `last_name`, `date_joined`, `mailing_address`, `registered_address`, `license`, `department`, `designation`, `modules`, `salary`, `type`) VALUES
('S7821060E ', 'Bin Yunos', 'Riduwan ', '2016-07-01', '422 Clementi Ave 1 #20-343', '455 Segar Road #04-107', '', 'Operations', 'Mover', 'Operation', 2000, 'Full'),
('S7913240C', 'Lau Mun Hoe ', '(Liu WenHao)', '2016-08-01', '626 Ang Mo Kio Ave 4 #04-1048 (S)560626     ', '', '', 'Operations', 'Supervisor', 'Supervisor', 2800, 'Full'),
('S8541685E', 'Tan ', 'Beng Hock', '2016-06-06', '197B Boon Lay Drive #12-103 (S) 642197', '', '', 'Operations', 'Supervisor', 'Supervisor', 2500, 'Full'),
('S8843967H', 'Gerald', 'Fong Soon Loong', '2016-06-06', '682D Woodlands Drive 73 #02-233 (S)734682', '', '', 'Operations', 'Supervisor', 'Supervisor', 2200, 'Full'),
('s9101930b', 'Ahmad Hakim', 'Ahmad Zaini', '2016-09-27', 'HakimAddress', '', '', 'Super', 'Admin', 'Admin|SiteSurvey', 3000, 'Full'),
('s9130728f', 'Poh Teck', 'Lua', '2015-10-19', '150 Jalan Teck Whye #16-43 (S)680150', '', '', 'Sales', 'Sales', 'Sales', 1800, 'Full'),
('s9215652d', 'Jonathan', 'Goh Thiam Soon', '2015-10-01', '292 Choa Chu Kang Ave 3 #01-224 (S)680292', '', '', 'Sales', 'Surveyor', 'SiteSurvey', 2100, 'Full'),
('s9231662i', 'Rena', 'Lim', '2015-08-13', 'Choa Chu Kang Central Blk 218 #02-238', '', '', 'HR', 'Manager', 'HR|Sales', 3000, 'Full'),
('S9344895B', 'Admin', 'Super', '2016-06-18', 'AdminAddress', '', '', 'Super', 'Admin', 'Admin', 6000, 'Full');

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
('S9344895B', 'admin', 'vimgen2016'),
('S8541685E', 'benghock@ops', 'password'),
('S8843967H', 'Gerald@ops', 'password'),
('s9101930b', 'hakim@super', 'password'),
('s9215652d', 'jonathan@ss', 'password'),
('s9130728f', 'pt@sales', 'password'),
('s9231662i', 'rena@hr', 'password'),
('S7821060E ', 'Riduwan@hr', 'password'),
('S7913240C', 'wenhao@ops', 'password');

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
('S7821060E ', '2016-10-06', 'Present', 0),
('S7913240C', '2016-10-06', 'Present', 0),
('S8541685E', '2016-10-06', 'Present', 0),
('S8843967H', '2016-10-06', 'Present', 0),
('s9101930b', '2016-10-06', 'Present', 0),
('s9130728f', '2016-10-06', 'Present', 0),
('s9215652d', '2016-10-06', 'Absent', 0),
('s9231662i', '2016-10-06', 'Present', 0),
('S9344895B', '2016-10-06', 'Present', 0);

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
('S7821060E ', 'Cash', 'POSB Savings', 'Sunalti Binte Yusoff', '063701327'),
('S7913240C', 'Cash', 'POSB Savings', 'Lau Mun Hoe (Liu WenHao)', '195596948'),
('S8541685E', 'Cash', 'POSB Savings', 'Tan Beng Hock', '187087430'),
('S8843967H', 'Cash', 'DBS Savings ', 'Fong Soon Loong Gerald', '0185116498'),
('s9101930b', 'Cheque', 'DBS', 'HAKIM-ACCOUNT', '1234567'),
('s9130728f', 'Cheque', 'OCBC', 'Lua Poh Teck', '647651314001'),
('s9215652d', 'Cheque', 'DBS', 'Goh Thiam Soon, Jonathan', '1234567'),
('s9231662i', 'Cheque', 'POSB Savings', 'Rena Lim', '057683554'),
('S9344895B', 'Cheque', 'DBS', 'yusheng account', '123-4567-8');

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
('S7821060E ', 85317418, 0, 0),
('S7913240C', 91574406, 0, 0),
('S8541685E', 91682901, 0, 0),
('S8843967H', 90210266, 0, 0),
('s9101930b', 99999999, 0, 0),
('s9130728f', 97451518, 0, 0),
('s9215652d', 93833066, 0, 0),
('s9231662i', 83835397, 0, 0),
('S9344895B', 99999999, 0, 0);

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
('S7821060E ', 'Sunalti', 'Wife', 83307504, 0),
('S7913240C', 'My Lien', 'Wife', 91575472, 0),
('S8541685E', 'Angeline', 'Wife', 91066176, 0),
('S8843967H', 'Linda Ong', 'Mother', 96450118, 0),
('s9101930b', 'Person1', 'Mother', 99999999, 0),
('s9130728f', 'Edward', 'Brother', 96743618, 0),
('s9215652d', 'Irene', 'Mother', 98782112, 0),
('s9231662i', 'Rena', 'Mother', 99999999, 0),
('S9344895B', 'Person1', 'Mother', 99999999, 0);

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
('S7821060E ', '2016-07-01', 112, 14, 36, 0),
('S7913240C', '2016-08-01', 112, 14, 9, 0),
('S8541685E', '2016-06-06', 112, 14, 0, 0),
('S8843967H', '2016-06-06', 112, 14, 18, 0),
('s9101930b', '2016-09-27', 112, 14, 0, 0),
('s9130728f', '2016-09-27', 112, 14, 36, 0),
('s9215652d', '2016-09-27', 112, 14, 0, 0),
('s9231662i', '2016-09-27', 112, 14, 0, 0),
('S9344895B', '2016-06-18', 112, 14, 0, 0);

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
('Paid', 'Leave', 'S7821060E ', '2016-07-25', '0830 - 1730', 9, ''),
('Paid', 'Leave', 'S7821060E ', '2016-10-14', '0830 - 1730', 9, ''),
('Paid', 'Leave', 'S7821060E ', '2016-10-15', '0830 - 1730', 9, ''),
('Paid', 'Leave', 'S7821060E ', '2016-10-17', '0830 - 1730', 9, ''),
('Paid', 'Leave', 'S7913240C', '2016-08-11', '0830 - 1730', 9, ''),
('Paid', 'Leave', 'S8843967H', '2016-07-25', '0830 - 1730', 9, ''),
('Paid', 'Leave', 'S8843967H', '2016-07-30', '0830 - 1730', 9, ''),
('Paid', 'Leave', 's9130728f', '2016-02-11', '0900 - 1800', 9, ''),
('Paid', 'Leave', 's9130728f', '2016-02-12', '0900 - 1800', 9, ''),
('Paid', 'Leave', 's9130728f', '2016-02-15', '0900 - 1800', 9, ''),
('Paid', 'Leave', 's9130728f', '2016-03-14', '0900 - 1800', 9, '');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
