<%@page import="com.vimbox.customer.Customer"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.database.TicketDAO"%>
<%@page import="com.vimbox.ticket.Ticket"%>
<%@page import="java.util.ArrayList"%>
<%@include file="ValidateLogin.jsp"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ticket Forum</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <script src="JS/TicketFunctions.js"></script>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
        <link rel="stylesheet" href="assets/admin1/css/admin1.css">
        <link rel="stylesheet" href="assets/globals/css/elements.css">
        <link rel="stylesheet" href="assets/globals/css/plugins.css">
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="assets/globals/plugins/modernizr/modernizr.min.js"></script>
    </head>
    <body onload='reload()'>
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
                            <li><a href="CreateEmployee.jsp">Create Employee</a></li>
                            <li><a href="FullTimeEmployees.jsp">Full Time Employees</a></li>
                            <li><a href="PartTimeEmployees.jsp">Part Time Employees</a></li>
                            <li><a href="Payslips.jsp">Payslips</a></li>
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
                        <h1>Ticket Forum <small></small></h1>
                    </div><!--.col-->
                    <div class="col-sm-6">
                        <ol class="breadcrumb">
                            <a href="Logout.jsp">Logout</a>
                        </ol>
                    </div><!--.col-->
                </div><!--.row-->
            </div><!--.page-header-->

            <!-- Start content -->
            <%                ArrayList<Ticket> pendingTickets = TicketDAO.getPendingTickets();
                ArrayList<Ticket> resolvedTickets = TicketDAO.getResolvedTickets();
            %>
            <h1>Pending Tickets</h1>
            <input type="text" id="pKw" placeholder="Enter keyword or date (YYYY-MM-DD)" style="width: 228px;" autofocus autocomplete="on">
            <button onclick="searchPending()">Search Pending</button><br><br>
            <!-- The Modal -->
            <div id="pkwModal" class="modal">
                <!-- Modal content -->
                <div class="search-modal-content">
                    <div class="modal-body">
                        <span class="close" onclick="closeModal('pkwModal')">×</span>
                        <div id="pkwContent"></div>
                    </div>
                </div>
            </div>
            <table border="1">
                <tr>
                    <th>Ticket ID</th>
                    <th>Cust Name</th>
                    <th>Cust Contact</th>
                    <th>Cust Email</th>
                    <th>Subject</th>
                    <th>Date & Time</th>
                    <th>Status</th>
                    <th>View</th>
                </tr>
                <%
                    for (Ticket pendingTicket : pendingTickets) {
                        int ticketId = pendingTicket.getTicket_id();
                        Customer customer = pendingTicket.getCustomer();
                        String customerName = customer.toString();
                        String contact = customer.getContact() + "";
                        if (contact.equals("0")) {
                            contact = "N/A";
                        }
                        String email = customer.getEmail();
                        if (email.isEmpty()) {
                            email = "N/A";
                        }
                        String subject = pendingTicket.getSubject();
                        String dateTime = Converter.convertDate(pendingTicket.getDatetime_of_creation());
                        String status = pendingTicket.getStatus();
                %>
                <tr>
                    <td><%=ticketId%></td>
                    <td><%=customerName%></td>
                    <td><%=contact%></td>
                    <td><%=email%></td>
                    <td><%=subject%></td>
                    <td><%=dateTime%></td>
                    <td><%=status%></td>
                    <td>
                        <button onclick="viewTicket('<%=ticketId%>')">VT</button>
                        <!-- The Modal -->
                        <div id="viewTicketModal<%=ticketId%>" class="modal">
                            <!-- Modal content -->
                            <div class="modal-content">
                                <div class="modal-body">
                                    <span class="close" onclick="closeModal('viewTicketModal<%=ticketId%>')">×</span>
                                    <h3>Ticket Details</h3><hr>
                                    <table>
                                        <tr>
                                            <td align="right">Ticket ID :</td>
                                            <td><%=ticketId%></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Date & Time :</td>
                                            <td><%=dateTime%></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Ticket Owner :</td>
                                            <td><%=pendingTicket.getOwner_user().toString()%></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Assigned To :</td>
                                            <td>
                                                <%
                                                    ArrayList<User> assigned = pendingTicket.getAssigned_users();
                                                    if (assigned.size() > 1) {
                                                        for (User assignee : assigned) {
                                                            out.println("<li>" + assignee.toString() + "</li>");
                                                        }
                                                    } else if (assigned.size() == 1) {
                                                        out.println(assigned.get(0).toString());
                                                    }
                                                %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">Subject :</td>
                                            <td><%=subject%></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Customer Details :</td>
                                            <td>
                                                <%=customerName%><br>
                                                <%=contact%><br>
                                                <%=email%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">Status :</td>
                                            <td><%=status%></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Description :</td>
                                            <td><%=pendingTicket.getDescription()%></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Solution :</td>
                                            <td><%=pendingTicket.getSolution()%></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <button onclick="viewComments('<%=ticketId%>')">VC</button>
                        <!-- The Modal -->
                        <div id="viewCommentsModal<%=ticketId%>" class="modal">
                            <!-- Modal content -->
                            <div class="modal-content">
                                <div class="modal-body">
                                    <span class="close" onclick="closeModal('viewCommentsModal<%=ticketId%>')">×</span>
                                    <div id="commentsContent<%=ticketId%>"></div> 
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>
                <%
                    }
                %>
            </table>


            <h1>Resolved Tickets</h1>
            <input type="text" id="rKw" placeholder="Enter keyword or date (YYYY-MM-DD)" style="width: 228px;" autocomplete="on">
            <button onclick="searchResolved()">Search Resolved</button><br><br>
            <!-- The Modal -->
            <div id="rkwModal" class="modal">
                <!-- Modal content -->
                <div class="search-modal-content">
                    <div class="modal-body">
                        <span class="close" onclick="closeModal('rkwModal')">×</span>
                        <div id="rkwContent"></div>
                    </div>
                </div>
            </div>

            <table border="1">
                <tr>
                    <th>Ticket ID</th>
                    <th>Cust Name</th>
                    <th>Cust Contact</th>
                    <th>Cust Email</th>
                    <th>Subject</th>
                    <th>Date & Time</th>
                    <th>Status</th>
                    <th>View</th>
                </tr>
                <%
                    for (Ticket resolvedTicket : resolvedTickets) {
                        int ticketId = resolvedTicket.getTicket_id();
                        Customer customer = resolvedTicket.getCustomer();
                        String customerName = customer.toString();
                        String contact = customer.getContact() + "";
                        if (contact.equals("0")) {
                            contact = "N/A";
                        }
                        String email = customer.getEmail();
                        if (email.isEmpty()) {
                            email = "N/A";
                        }
                        String subject = resolvedTicket.getSubject();
                        String dateTime = Converter.convertDate(resolvedTicket.getDatetime_of_creation());
                        String status = resolvedTicket.getStatus();
                %>
                <tr>
                    <td><%=ticketId%></td>
                    <td><%=customerName%></td>
                    <td><%=contact%></td>
                    <td><%=email%></td>
                    <td><%=subject%></td>
                    <td><%=dateTime%></td>
                    <td><%=status%></td>
                    <td>
                        <button onclick="viewTicket('<%=ticketId%>')">VT</button>
                        <!-- The Modal -->
                        <div id="viewTicketModal<%=ticketId%>" class="modal">
                            <!-- Modal content -->
                            <div class="modal-content">
                                <div class="modal-body">
                                    <span class="close" onclick="closeModal('viewTicketModal<%=ticketId%>')">×</span>
                                    <h3>Ticket Details</h3><hr>
                                    <table>
                                        <tr>
                                            <td align="right">Ticket ID :</td>
                                            <td><%=ticketId%></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Date & Time :</td>
                                            <td><%=dateTime%></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Ticket Owner :</td>
                                            <td><%=resolvedTicket.getOwner_user().toString()%></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Assigned To :</td>
                                            <td>
                                                <%
                                                    ArrayList<User> assigned = resolvedTicket.getAssigned_users();
                                                    if (assigned.size() > 1) {
                                                        for (User assignee : assigned) {
                                                            out.println("<li>" + assignee.toString() + "</li>");
                                                        }
                                                    } else if (assigned.size() == 1) {
                                                        out.println(assigned.get(0).toString());
                                                    }
                                                %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">Subject :</td>
                                            <td><%=subject%></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Customer Details :</td>
                                            <td>
                                                <%=customerName%><br>
                                                <%=contact%><br>
                                                <%=email%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">Status :</td>
                                            <td><%=status%></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Description :</td>
                                            <td><%=resolvedTicket.getDescription()%></td>
                                        </tr>
                                        <tr>
                                            <td align="right">Solution :</td>
                                            <td><%=resolvedTicket.getSolution()%></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <button onclick="viewComments('<%=ticketId%>')">VC</button>
                        <!-- The Modal -->
                        <div id="viewCommentsModal<%=ticketId%>" class="modal">
                            <!-- Modal content -->
                            <div class="modal-content">
                                <div class="modal-body">
                                    <span class="close" onclick="closeModal('viewCommentsModal<%=ticketId%>')">×</span>
                                    <div id="commentsContent<%=ticketId%>"></div> 
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>
                <%
                    }
                %>
            </table>

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
