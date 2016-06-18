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
    </head>
    <body>
        <%
            ArrayList<Ticket> pendingTickets = TicketDAO.getPendingTickets();
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
            for(Ticket pendingTicket:pendingTickets){
                int ticketId = pendingTicket.getTicket_id();
                Customer customer = pendingTicket.getCustomer();
                String customerName = customer.toString();
                String contact  = customer.getContact() + "";
                if(contact.equals("0")){
                    contact = "N/A";
                }
                String email = customer.getEmail();
                if(email.isEmpty()){
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
                                                if(assigned.size() > 1){
                                                    for(User assignee:assigned){
                                                        out.println("<li>" + assignee.toString() + "</li>");
                                                    }
                                                }else if(assigned.size() == 1){
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
            for(Ticket resolvedTicket:resolvedTickets){
                int ticketId = resolvedTicket.getTicket_id();
                Customer customer = resolvedTicket.getCustomer();
                String customerName = customer.toString();
                String contact  = customer.getContact() + "";
                if(contact.equals("0")){
                    contact = "N/A";
                }
                String email = customer.getEmail();
                if(email.isEmpty()){
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
                                                if(assigned.size() > 1){
                                                    for(User assignee:assigned){
                                                        out.println("<li>" + assignee.toString() + "</li>");
                                                    }
                                                }else if(assigned.size() == 1){
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
    </body>
</html>
