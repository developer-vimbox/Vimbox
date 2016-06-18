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
        <title>My Tickets</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <script src="JS/TicketFunctions.js"></script>
        <script src="JS/CustomerFunctions.js"></script>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
    </head>
    <body>
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
                int ticketId = myTicket.getTicket_id();
                Customer customer = myTicket.getCustomer();
                String customerName = customer.toString();
                String contact  = customer.getContact() + "";
                if(contact.equals("0")){
                    contact = "N/A";
                }
                String email = customer.getEmail();
                if(email.isEmpty()){
                    email = "N/A";
                }
                String subject = myTicket.getSubject();
                String dateTime = Converter.convertDate(myTicket.getDatetime_of_creation());
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
                <button onclick="editTicket(<%=ticketId%>)">Edit</button>
                <div id="edit_ticket_modal" class="modal">
                    <div class="modal-content">
                        <div class="modal-body">
                            <span class="close" onclick="closeModal('edit_ticket_modal')">×</span>
                            <div id="edit_ticket_content"></div>
                        </div>
                    </div>
                </div>
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
                int ticketId = ticket.getTicket_id();
                Customer customer = ticket.getCustomer();
                String customerName = customer.toString();
                String contact  = customer.getContact() + "";
                if(contact.equals("0")){
                    contact = "N/A";
                }
                String email = customer.getEmail();
                if(email.isEmpty()){
                    email = "N/A";
                }
                String subject = ticket.getSubject();
                String dateTime = Converter.convertDate(ticket.getDatetime_of_creation());
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
                <button onclick="commentTicket('<%=ticketId%>')">C</button>
                <!-- The Modal -->
                <div id="commentModal<%=ticketId%>" class="modal">
                    <!-- Modal content -->
                    <div class="modal-content">
                        <div class="modal-body">
                            <span class="close" onclick="closeModal('commentModal<%=ticketId%>')">×</span>
                            <h3>Add Comment</h3>
                            <table>
                                <tr>
                                    <td>Ticket ID :</td>
                                    <td><%=ticketId%><input type="hidden" id="comment_ticket_id<%=ticketId%>" value="<%=ticketId%>" /></td>
                                </tr>
                                <tr>
                                    <td>Comment :</td>
                                    <td><textarea id="ticket_comment<%=ticketId%>" cols="75" rows="6" autofocus></textarea></td>
                                </tr>  
                                <tr>
                                    <td></td>
                                    <td><button onclick="followupTicket(<%=ticketId%>)">Add Comment</button></td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>

                <button onclick="closeTicket('<%=ticketId%>')">R</button>
                <div id="resolveModal<%=ticketId%>" class="modal">
                    <!-- Modal content -->
                    <div class="modal-content">
                        <div class="modal-body">
                            <span class="close" onclick="closeModal('resolveModal<%=ticketId%>')">×</span>
                            <h3>Resolve Ticket</h3>
                            <table>
                                <tr>
                                    <td>Ticket ID :</td>
                                    <td><%=ticketId%><input type="hidden" id="resolve_ticket_id<%=ticketId%>" value="<%=ticketId%>" /></td>
                                </tr>
                                <tr>
                                    <td>Solution :</td>
                                    <td><textarea id="resolve_ticket_solution<%=ticketId%>" cols="75" rows="6" autofocus></textarea></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td><button onclick="resolveTicket(<%=ticketId%>)">Resolve Ticket</button></td>
                                </tr>
                            </table>
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
                                    <td><%=ticket.getOwner_user().toString()%></td>
                                </tr>
                                <tr>
                                    <td align="right">Assigned To :</td>
                                    <td>
                                        <%
                                            ArrayList<User> assigned = ticket.getAssigned_users();
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
        
        <div id="ticket_error_modal" class="modal">
            <div class="error-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('ticket_error_modal')">×</span>
                    <div id="ticket_error_status"></div>
                    <hr>
                    <div id="ticket_error_message"></div>
                </div>
            </div>
        </div>
    </body>
</html>
