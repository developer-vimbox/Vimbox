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
        <script>src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.2/jquery.min.js"></script>
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
                String ticketId = pendingTicket.getTicketid();
                String customerName = pendingTicket.getCustomerName();
                if(customerName.isEmpty()){
                    customerName = "N/A";
                }
                String contact  = pendingTicket.getContactNumber();
                if(contact.isEmpty()){
                    contact = "N/A";
                }
                String email = pendingTicket.getEmail();
                if(email.isEmpty()){
                    email = "N/A";
                }
                String subject = pendingTicket.getSubject();
                String dateTime = Converter.convertDate(pendingTicket.getDatetime());
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
                                        <td><%=pendingTicket.getOwner().getFullname()%></td>
                                    </tr>
                                    <tr>
                                        <td align="right">Assigned To :</td>
                                        <td>
                                            <%
                                                ArrayList<User> assigned = pendingTicket.getAssigned();
                                                if(assigned.size() > 1){
                                                    for(User assignee:assigned){
                                                        out.println("<li>" + assignee.getFullname() + "</li>");
                                                    }
                                                }else if(assigned.size() == 1){
                                                    out.println(assigned.get(0).getFullname());
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
            for(Ticket ticket:resolvedTickets){
                String ticketId = ticket.getTicketid();
                String customerName = ticket.getCustomerName();
                if(customerName.isEmpty()){
                    customerName = "N/A";
                }
                String contact  = ticket.getContactNumber();
                if(contact.isEmpty()){
                    contact = "N/A";
                }
                String email = ticket.getEmail();
                if(email.isEmpty()){
                    email = "N/A";
                }
                String subject = ticket.getSubject();
                String dateTime = Converter.convertDate(ticket.getDatetime());
                String status = ticket.getStatus();
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
                                    <td><%=ticket.getOwner().getFullname()%></td>
                                </tr>
                                <tr>
                                    <td align="right">Assigned To :</td>
                                    <td>
                                        <%
                                            ArrayList<User> assigned = ticket.getAssigned();
                                            if(assigned.size() > 1){
                                                for(User assignee:assigned){
                                                    out.println("<li>" + assignee.getFullname() + "</li>");
                                                }
                                            }else if(assigned.size() == 1){
                                                out.println(assigned.get(0).getFullname());
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
                                    <td><%=ticket.getDescription()%></td>
                                </tr>
                                <tr>
                                    <td align="right">Solution :</td>
                                    <td><%=ticket.getSolution()%></td>
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
        <script>
            function closeModal(modalName){
                var modal = document.getElementById(modalName);
                modal.style.display = "none";
            }
            function viewTicket(ticketId){
                var modal = document.getElementById("viewTicketModal" + ticketId);
                modal.style.display = "block";
            }
            function viewComments(ticketId){
                var modal = document.getElementById("viewCommentsModal" + ticketId);
                var div1 = document.getElementById("commentsContent" + ticketId);
                $.get("RetrieveTicketComment.jsp",{getTid:ticketId}, function(data) {
                    div1.innerHTML = data;
                });
                modal.style.display = "block";
            }
            function searchPending(){
                var kw = document.getElementById("pKw").value;
                var modal = document.getElementById("pkwModal");
                var pkwDiv = document.getElementById("pkwContent");
                $.get("SearchTickets.jsp",{getKeyword:kw , getAction:"pending"}, function(data) {
                    pkwDiv.innerHTML = data;
                });
                modal.style.display = "block";
            }
            
            function searchResolved(){
                var kw = document.getElementById("rKw").value;
                var modal = document.getElementById("rkwModal");
                var rkwDiv = document.getElementById("rkwContent");
                $.get("SearchTickets.jsp",{getKeyword:kw , getAction:"resolved"}, function(data) {
                    rkwDiv.innerHTML = data;
                });
                modal.style.display = "block";
            }
        </script>
    </body>
</html>
