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
        <title>My Tickets</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
    </head>
    <body>
        <%@include file="MyTicketsAction.jsp"%>
        <%
            ArrayList<Ticket> myTickets = TicketDAO.getTicketsByOwnerUser(user);
            ArrayList<Ticket> assignedTickets = TicketDAO.getTicketsByAssignedUser(user);
            
        %>
        <h1>My Tickets</h1>
        <table border="1">
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
            for(Ticket myTicket:myTickets){
                String ticketId = myTicket.getTicketid();
                String customerName = myTicket.getCustomerName();
                if(customerName.isEmpty()){
                    customerName = "Not provided";
                }
                String contact  = myTicket.getContactNumber();
                if(contact.isEmpty()){
                    contact = "Not provided";
                }
                String email = myTicket.getEmail();
                if(email.isEmpty()){
                    email = "N/A";
                }
                String subject = myTicket.getSubject();
                String dateTime = Converter.convertDate(myTicket.getDatetime());
                String status = myTicket.getStatus();
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
            <%
                if(status.equals("Pending")){
            %>
                <a href="EditTicket.jsp?tId=<%=ticketId%>">Edit</a>
            <%
                }
            %>
                </td>
            </tr>
        <%
            }
        %>
        </table>
        
        
        <h1>Assigned Tickets</h1>
        <table border="1">
            <tr>
                <th>Ticket ID</th>
                <th>Cust Name</th>
                <th>Cust Contact</th>
                <th>Cust Email</th>
                <th>Subject</th>
                <th>Date & Time</th>
                <th>Status</th>
                <th>Action</th>
                <th>View</th>
            </tr>
        <%
            for(Ticket ticket:assignedTickets){
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
                <button onclick="addComment('<%=ticketId%>')">C</button>
                <!-- The Modal -->
                <div id="commentModal<%=ticketId%>" class="modal">
                    <!-- Modal content -->
                    <div class="modal-content">
                        <div class="modal-body">
                            <span class="close" onclick="closeModal('commentModal<%=ticketId%>')">×</span>
                            <h3>Add Comment</h3>
                            <form method="post" action="TicketCommentController">
                                <table>
                                    <tr>
                                        <td>Ticket ID :</td>
                                        <td><%=ticketId%><input type="hidden" name="id" value="<%=ticketId%>" /></td>
                                    </tr>
                                    <tr>
                                        <td>Comment :</td>
                                        <td><textarea required name="comment" cols="75" rows="6" autofocus autocomplete="off" oninvalid="this.setCustomValidity('Please enter a comment')" oninput="setCustomValidity('')"></textarea></td>
                                    </tr>  
                                </table>
                                <input type="submit" value="Add Comment">
                            </form>
                        </div>
                    </div>
                </div>

                <button onclick="resolve('<%=ticketId%>')">R</button>
                <div id="resolveModal<%=ticketId%>" class="modal">
                    <!-- Modal content -->
                    <div class="modal-content">
                        <div class="modal-body">
                            <span class="close" onclick="closeModal('resolveModal<%=ticketId%>')">×</span>
                            <h3>Resolve Ticket</h3>
                            <form method="post" action="ResolveTicketController">
                                <table>
                                    <tr>
                                        <td>Ticket ID :</td>
                                        <td><%=ticketId%><input type="hidden" name="id" value="<%=ticketId%>" /></td>
                                    </tr>
                                    <tr>
                                        <td>Solution :</td>
                                        <td><textarea required name="solution" cols="75" rows="6" autofocus autocomplete="off" oninvalid="this.setCustomValidity('Please enter a comment')" oninput="setCustomValidity('')"></textarea></td>
                                    </tr>  
                                </table>
                                <input type="submit" value="Resolve">
                            </form>
                        </div>
                    </div>
                </div>
            </td>
           
            <td>
                <button onclick="viewTicket('<%=ticketId%>')">VT</button>
                <!-- The Modal -->
                <div id="viewTicketModal<%=ticketId%>" class="modal">
                    <!-- Modal content -->
                    <div class="modal-content">
                        <div class="modal-body">
                            <span class="close" onclick="closeModal('viewTicketModal<%=ticketId%>')">×</span>
                            <h3>Ticket Details</h3>
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
            function addComment(ticketId){
                var modal = document.getElementById("commentModal" + ticketId);
                modal.style.display = "block";
            }
            function resolve(ticketId){
                var modal = document.getElementById("resolveModal" + ticketId);
                modal.style.display = "block";
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
        </script>
    </body>
</html>
