<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.customer.Customer"%>
<%@page import="com.vimbox.database.UserDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.ticket.Ticket"%>
<%@page import="com.vimbox.database.TicketDAO"%>
<%@include file="ValidateLogin.jsp"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Ticket</title>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
        <style>
            #additionalAssigned{
                display:none;
            }
        </style>
    </head>
    <body>
        <%
            int ticket_id = Integer.parseInt(request.getParameter("ticket_id"));
            Ticket ticket = TicketDAO.getTicketById(ticket_id);
            ArrayList<User> users = UserDAO.getFullTimeUsers();
            Customer customer = ticket.getCustomer();
        %>
        <h1>Ticket Details</h1>
        <table>
            <tr>
                <td align="right"><b>Ticket ID :</b></td>
                <td>
                    <input type='hidden' id='ticket_id' value='<%=ticket_id%>'><%=ticket_id%>
                </td>
            </tr>
        </table>
        <br>
        <fieldset>
            <legend>Customer Information</legend>
            <input type="text" id="customer_search" placeholder="Enter customer name">
            <button onclick='customerSearch("ticket");return false;'>Search</button>
            <button onclick="addNewCustomer();return false;">Add New</button>

            <div id="customer_modal" class="modal">
                <div class="modal-content">
                    <div class="modal-body">
                        <span class="close" onclick="closeModal('customer_modal')">×</span>
                        <div id="customer_content"></div>
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

            <div id="customer_information_table">
                <hr>
                <input type="hidden" id="customer_id" name="customer_id" value="<%=customer.getCustomer_id()%>">
                <table>
                    <tr>
                        <td align="right"><b>Salutation :</b></td>
                        <td>
                            <label id="customer_salutation"><%=customer.getSalutation()%></label>
                        </td>
                    </tr>
                    <tr>
                        <td align="right"><b>First Name :</b></td>
                        <td>
                            <label id="customer_first_name"><%=customer.getFirst_name()%></label>
                        </td>
                    </tr>
                    <tr>
                        <td align="right"><b>Last Name :</b></td>
                        <td>
                            <label id="customer_last_name"><%=customer.getLast_name()%></label>
                        </td>
                    </tr>
                    <tr>
                        <td align="right"><b>Contact Number :</b></td>
                        <td>
                            <label id="customer_contact">
                            <%
                                int contact = customer.getContact();
                                if(contact != 0){
                                    out.println(contact + "");
                                }
                            %>    
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <td align="right"><b>Email :</b></td>
                        <td>
                            <label id="customer_email"><%=customer.getEmail()%></label>
                        </td>
                    </tr>
                </table>
            </div>
        </fieldset>
        <br>
        <fieldset>
            <legend>Ticket Information</legend>
            <input type="hidden" id="datetime_of_creation" value="<%=Converter.convertDateDatabase(ticket.getDatetime_of_creation())%>">
            <table>
                <tr>
                    <td align="right"><b>Status :</b></td>
                    <td><%=ticket.getStatus()%></td>
                </tr>
                <tr>
                    <td align="right"><b>Assigned To :</b></td>
                    <td>
                        <div id="dynamicInput">
                        <%
                            ArrayList<User> assigned_users = ticket.getAssigned_users();
                            for(int i=0; i<assigned_users.size(); i++){
                                String nric = assigned_users.get(i).getNric();
                                if(i == 0){
                        %>
                            <div id="<%=i%>">
                                <table>
                                    <tr>
                                        <td>
                                            <select name="assigned">
                                                <%
                                                    for (User assignee : users) {
                                                        String userNric = assignee.getNric();
                                                        if(userNric.equals(nric)){
                                                            out.println("<option value='" + assignee.getNric() + "' selected>" + assignee + "</option>");
                                                        }else{
                                                            out.println("<option value='" + assignee.getNric() + "'>" + assignee + "</option>");
                                                        }
                                                    }
                                                %>
                                            </select>
                                        </td>
                                        <td><input type="button" value="+" onClick="addInput('dynamicInput');"></td>
                                    </tr>    
                                </table>
                            </div>
                        <%
                                }else{
                        %>
                            <div id="<%=i%>">
                                <table>
                                    <tr>
                                        <td>
                                            <select name="assigned">
                                                <%
                                                    for (User assignee : users) {
                                                        String userNric = assignee.getNric();
                                                        if(userNric.equals(nric)){
                                                            out.println("<option value='" + assignee.getNric() + "' selected>" + assignee + "</option>");
                                                        }else{
                                                            out.println("<option value='" + assignee.getNric() + "'>" + assignee + "</option>");
                                                        }
                                                    }
                                                %>
                                            </select>
                                        </td>
                                        <td><input type='button' value='x' onClick='removeAdditional(this);'></td>
                                    </tr>    
                                </table>
                            </div>
                        <%
                                }
                            }
                        %>
                        </div>
                        <div id="additionalAssigned">
                            <table>
                                <tr>
                                    <td>
                                        <select name="assigned">
                                            <%
                                                for (User assignee : users) {
                                                    out.println("<option value='" + assignee.getNric() + "'>" + assignee + "</option>");
                                                }
                                            %>
                                        </select>
                                    </td>
                                    <td><input type='button' value='x' onClick='removeAdditional(this);'></td>
                                </tr>    
                            </table>
                        </div>                    
                    </td>
                </tr>
                <tr>
                    <td align="right"><b>Subject :</b></td>
                    <td>
                        <input type="text" id="subject" size="67" value="<%=ticket.getSubject()%>">
                    </td>
                </tr>
                <tr>
                    <td align="right"><b>Description :</b></td>
                    <td>
                        <textarea id="description" cols="60" rows="6"><%=ticket.getDescription()%></textarea>
                    </td>
                </tr>
            </table>
        </fieldset>
        <br>                               
        <table>
            <tr>
                <td><button onclick="updateTicket()">Update Ticket</button></td>
            </tr>
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
