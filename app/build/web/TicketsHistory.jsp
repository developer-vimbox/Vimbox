<%@page import="com.vimbox.user.User"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.database.TicketDAO"%>
<%@page import="com.vimbox.ticket.Ticket"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.CustomerHistoryDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Tickets History</title>
    </head>
    <body>
        <h2>Tickets History</h2><hr>
        <%
            String custId = request.getParameter("getId");
            ArrayList<String> ids = CustomerHistoryDAO.getCustomerTicketIds(Integer.parseInt(custId));
            if(ids.isEmpty()){
        %>
            No results found
        <%
            }else{
                if(ids.size()==1){
                    out.println(ids.size() + " record found");
                }else{
                    out.println(ids.size() + " records found");
                }
                ArrayList<Ticket> tickets = new ArrayList<Ticket>();
                for(String id:ids){
                    tickets.add(TicketDAO.getTicketById(id));
                }
        %>
        <br><br>
        <table border="1" width="100%">
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
                for(Ticket ticket:tickets){
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
        </table>
        <%          
                }
            }
        %>
    </body>
</html>
