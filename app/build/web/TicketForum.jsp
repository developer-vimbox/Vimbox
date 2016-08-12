<%@page import="com.vimbox.user.User"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.customer.Customer"%>
<%@page import="com.vimbox.database.TicketDAO"%>
<%@page import="com.vimbox.ticket.Ticket"%>
<%@page import="java.util.ArrayList"%>
<!DOCTYPE html> 
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title> VIMBOX </title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <script src="JS/ModalFunctions.js"></script>
        <script src="JS/TicketFunctions.js"></script>
        <script src="JS/CustomerFunctions.js"></script>
        <script src="JS/LeadFunctions.js"></script>
    </head>
    <body>
        <%@include file="header.jsp"%>
        <!-- The Modal for Pending Tickets-->
        <div id="pkwModal" class="modal">
            <!-- Modal content -->
            <div class="search-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('pkwModal')">×</span>
                    <div id="pkwContent"></div>
                </div>
            </div>
        </div>
        <!-- The Modal for resolved tickets -->
        <div id="rkwModal" class="modal">
            <!-- Modal content -->
            <div class="search-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('rkwModal')">×</span>
                    <div id="rkwContent"></div>
                </div>
            </div>
        </div>
        <div id="page-content-wrapper">
            <div id="page-content">
                <div class="container">
                    <!-- Tocify -->
                    <!--<link rel="stylesheet" type="text/css" href="assets/widgets/tocify/tocify.css">-->
                    <script type="text/javascript" src="assets/widgets/sticky/sticky.js"></script>
                    <script type="text/javascript" src="assets/widgets/tocify/tocify.js"></script>

                    <script type="text/javascript">
                        $(function () {
                            var toc = $("#tocify-menu").tocify({context: ".toc-tocify", showEffect: "fadeIn", extendPage: false, selectors: "h2, h3, h4"});
                        });
                        jQuery(document).ready(function ($) {

                            /* Sticky bars */

                            $(function () {
                                "use strict";

                                $('.sticky-nav').hcSticky({
                                    top: 50,
                                    innerTop: 50,
                                    stickTo: 'document'
                                });

                            });

                        });
                    </script>
                    <%                ArrayList<Ticket> pendingTickets = TicketDAO.getPendingTickets();
                        ArrayList<Ticket> resolvedTickets = TicketDAO.getResolvedTickets();
                    %>
                    <div id="page-title">
                        <h2>Ticket Forum</h2> <br/>
                        <div class="panel">
                            <div class="panel-body">
                                <div class="example-box-wrapper">
                                    <ul class="nav-responsive nav nav-tabs">
                                        <li class="active"><a href="#pendingTickets" data-toggle="tab">Pending Tickets</a></li>
                                        <li><a href="#resolvedTickets" data-toggle="tab">Resolved Tickets</a></li>
                                    </ul>
                                    <div class="tab-content">
                                        <div id="pendingTickets" class="tab-pane active">
                                            <div class="form-group">
                                                <div class="col-sm-4">
                                                    <div class="input-group bootstrap-touchspin">
                                                        <input type = "text" id="pKw" placeholder="Enter keyword or date (YYYY-MM-DD)" class = "form-control"  style="width: 400px;color:black;">
                                                        <span class="input-group-btn">
                                                            <button class="btn btn-default bootstrap-touchspin-up" type="button" onclick="searchPending()">Search Pending</button>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                            <br/><br/>
                                            <br/>
                                            <table class="table table-hover">
                                                <tr>
                                                    <th>Ticket ID</th>
                                                    <th>Cust Name</th>
                                                    <th>Cust Contact</th>
                                                    <th>Cust Email</th>
                                                    <th>Subject</th>
                                                    <th>Date & Time</th>
                                                    <th>Status</th>
                                                    <th>Action</th>
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
                                                        <button class="btn btn-default" onclick="viewEachTicket('<%=ticketId%>')" data-toggle="modal" data-target="#viewEachTicketModal">VT</button>
                                                        <div class="modal" id="viewEachTicketModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel2" aria-hidden="true">
                                                            <div class="modal-dialog" style="width: 500px;">
                                                                <div class="modal-content" style="width: 500px;">
                                                                    <div class="modal-header">
                                                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                                                        <h3>Ticket Details</h3>
                                                                    </div>
                                                                    <div class="modal-body">
                                                                        <div id="viewEachTicketModalContent"></div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <button class="btn btn-default"  onclick="viewEachComment('<%=ticketId%>')" data-toggle="modal" data-target="#viewEachCommentModal">VC</button>
                                                        <div class="modal" id="viewEachCommentModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel2" aria-hidden="true">
                                                            <div class="modal-dialog" style="width: 500px;">
                                                                <div class="modal-content" style="width: 500px;">
                                                                    <div class="modal-header">
                                                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                                                        <h3>Comment Details</h3>
                                                                    </div>
                                                                    <div class="modal-body">
                                                                        <div id="viewEachCommentModalContent"></div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <%
                                                    }
                                                %>
                                            </table>
                                        </div>
                                        <div id="resolvedTickets" class="tab-pane">
                                            <div class="form-group">
                                                <div class="col-sm-4">
                                                    <div class="input-group bootstrap-touchspin"><span class="input-group-addon bootstrap-touchspin-prefix" style="display: none;"></span>
                                                        <input type = "text"  id="rKw" placeholder="Enter keyword or date (YYYY-MM-DD)" class = "form-control"  style="width: 400px;color:black;">
                                                        <span class="input-group-btn">
                                                            <button class="btn btn-default bootstrap-touchspin-up" type="button" onclick="searchResolved()">Search Resolved</button>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                            <br/><br/>
                                            <br/>
                                            <table class="table table-hover">
                                                <tr>
                                                    <th>Ticket ID</th>
                                                    <th>Cust Name</th>
                                                    <th>Cust Contact</th>
                                                    <th>Cust Email</th>
                                                    <th>Subject</th>
                                                    <th>Date & Time</th>
                                                    <th>Status</th>
                                                    <th>Action</th>
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
                                                        <button class="btn btn-default " value="<%=ticketId%>" onclick="viewEachTicket('<%=ticketId%>')" data-toggle="modal" data-target="#viewTicketModall">VT</button>
                                                        <div class="modal" id="viewTicketModall" tabindex="-1" role="dialog" aria-labelledby="myModalLabel2" aria-hidden="true">
                                                            <div class="modal-dialog" style="width: 500px;">
                                                                <div class="modal-content" style="width: 500px;">
                                                                    <div class="modal-header">
                                                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                                                        <h3>Ticket Details</h3>
                                                                    </div>
                                                                    <div class="modal-body">
                                                                        <div id="viewEachTicketModalContent"></div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <button class="btn btn-default " value="<%=ticketId%>" onclick="viewComments('<%=ticketId%>')">VC</button>
                                                    </td>
                                                </tr>
                                                <%
                                                    }
                                                %>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</div>
</body>
</html>