<%@include file="ValidateLogin.jsp"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Home Page</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="assets/globals/plugins/modernizr/modernizr.min.js"></script>
        <script src="JS/CustomerFunctions.js"></script>
        <script src="JS/TicketFunctions.js"></script>
        <script src="JS/LeadFunctions.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
        <link rel="stylesheet" href="assets/admin1/css/admin1.css">
        <link rel="stylesheet" href="assets/globals/css/elements.css">
        <link rel="stylesheet" href="assets/globals/css/plugins.css">
    </head>
    <body onload="reload()">
        <div class="nav-bar-container">
            <!-- BEGIN ICONS -->
            <div class="nav-menu">
                <div class="hamburger">
                    <span class="patty"></span>
                    <span class="patty"></span>
                    <span class="patty"></span>
                    <span class="patty"></span>
                    <span class="patty"></span>
                    <span class="patty"></span>
                </div><!--.hamburger-->
            </div><!--.nav-menu-->

            <div class="nav-search">
                <span class="search"></span>
            </div><!--.nav-search-->

            <div class="nav-bar-border"></div><!--.nav-bar-border-->

            <!-- BEGIN OVERLAY HELPERS -->
            <div class="overlay">
                <div class="starting-point">
                    <span></span>
                </div><!--.starting-point-->
                <div class="logo">VIMBOX</div><!--.logo-->
            </div><!--.overlay-->

            <div class="overlay-secondary"></div><!--.overlay-secondary-->
            <!-- END OF OVERLAY HELPERS -->

        </div><!--.nav-bar-container-->

        <div class="layer-container">

            <!-- BEGIN MENU LAYER -->
            <div class="menu-layer">
                <ul>
                    <li>
                        <a href="HomePage.jsp">HomePage</a>
                    </li>
                    <li>
                        <a href="javascript:;">Human Resource</a>
                        <ul class="child-menu">
                            <li><a href="FullTimeEmployees.jsp">Full Time Employees</a></li>
                            <li><a href="PartTimeEmployees.jsp">Part Time Employees</a></li>
                            <li><a href="Payslips.jsp">Payslips</a></li>
                            <li><a href="TakeAttendance.jsp">Take Attendance</a></li>
                            <li><a href="ViewAttendance.jsp">View Attendance</a></li>
                            <li><a href="LeaveMCs.jsp">Leave/MC</a></li>
                        </ul>
                    </li>
                    <li>
                        <a href="javascript:;">Sales</a>
                        <ul class="child-menu">
                            <li><a href="CreateLead.jsp">Create Lead</a></li>
                            <li><a href="MyLeads.jsp">My Leads</a></li>
                        </ul>
                    </li>
                    <li>
                        <a href="javascript:;">Ticket</a>
                        <ul class="child-menu">
                            <li><a href="CreateTicket.jsp">Create Ticket</a></li>
                            <li><a href="MyTickets.jsp">My Tickets</a></li>
                            <li><a href="TicketForum.jsp">Ticket Forum</a></li>
                        </ul>
                    </li>
                    <li>
                        <a href="javascript:;">Site Surveyor</a>
                        <ul class="child-menu">
                            <li><a href="MySites.jsp">My Sites </a></li>
                        </ul>
                    </li>
                </ul>
            </div><!--.menu-layer-->
            <!-- END OF MENU LAYER -->

            <!-- BEGIN SEARCH LAYER -->
            <div class="search-layer">
                <div class="search">
                    <div class="form-group">
                        <input type="text" id="customer_search" class="form-control" placeholder="Search Customer">
                        <button onclick='customerSearch("crm")' class="btn btn-default"><i class="ion-search"></i></button>
                    </div>
                </div><!--.search-->

                <div class="results">
                    <div class="row">
                        <div id="customer_modal">
                            <div id="customer_content"></div>
                        </div>

                        <div id="edit_customer_modal" class="modal">
                            <div class="modal-content">
                                <div class="modal-body">
                                    <span class="close" onclick="closeModal('edit_customer_modal')">×</span>
                                    <div id="edit_customer_content"></div>
                                </div>
                            </div>
                        </div>

                        <div id="customer_error_modal" class="modal">
                            <div class="error-modal-content">
                                <div class="modal-body">
                                    <span class="close" onclick="closeModal('customer_error_modal')">×</span>
                                    <div id="customer_error_status"></div>
                                    <hr>
                                    <div id="customer_error_message"></div>
                                </div>
                            </div>
                        </div>

                        <div id="ticketsHistoryModel" class="modal">
                            <!-- Modal content -->
                            <div class="search-modal-content">
                                <div class="modal-body">
                                    <span class="close" onclick="closeModal('ticketsHistoryModel')">×</span>
                                    <div id="ticketsHistoryContent"></div>
                                </div>
                            </div>
                        </div>

                        <div id="leadsHistoryModel" class="modal">
                            <!-- Modal content -->
                            <div class="search-modal-content">
                                <div class="modal-body">
                                    <span class="close" onclick="closeModal('leadsHistoryModel')">×</span>
                                    <div id="leadsHistoryContent"></div>
                                </div>
                            </div>
                        </div>


                    </div><!--.row-->
                </div><!--.results-->
            </div><!--.search-layer-->
            <!-- END OF SEARCH LAYER -->
        </div>

        <div class="content">
            <div class="page-header full-content">
                <div class="row">
                    <div class="col-sm-6">
                        <h1>Home Page <small>anything to display?</small></h1>
                    </div><!--.col-->
                    <div class="col-sm-6">
                        <ol class="breadcrumb">
                            <a href="Logout.jsp">Logout</a>
                        </ol>
                    </div><!--.col-->
                </div><!--.row-->
            </div><!--.page-header-->

            <!-- Start content -->
            Anything to put at home page?

            <!-- End content -->
        </div><!--.content-->

        <!-- PLEASURE -->
        <script src="assets/globals/js/pleasure.js"></script>
        <!-- ADMIN 1 -->
        <script src="assets/admin1/js/layout.js"></script>
        <script src="assets/globals/js/global-vendors.js"></script>

        <!-- BEGIN INITIALIZATION-->
        <script>
                                        $(document).ready(function () {
                                            Pleasure.init();
                                            Layout.init();
                                        });
        </script>
        <!-- END INITIALIZATION-->
    </body>
</html>
