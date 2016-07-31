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
    <legend>Edit Ticket</legend>
    <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
    <style>
        #additionalAssigned{
            display:none;
        }
    </style>
</head>
<body>
    <%            int ticket_id = Integer.parseInt(request.getParameter("ticket_id"));
        Ticket ticket = TicketDAO.getTicketById(ticket_id);
        ArrayList<User> users = UserDAO.getFullTimeUsers();
        Customer customer = ticket.getCustomer();
    %>
    <div class="form-horizontal">
        <div class="form-group">
            <label class="col-sm-4 control-label">Ticket ID: </label>
            <div class="col-sm-6">
                <input type='hidden' id='ticket_id' value='<%=ticket_id%>'>
                <input type="text" class="form-control" value="<%=ticket_id%>" disabled>
            </div>
        </div>
    </div>
    <br>
    <h3 class="title-hero">
        Customer Information
    </h3> <hr>
    <div class="form-horizontal">
        <div class="form-group">
            <div class="col-sm-4">
                <div class="input-group bootstrap-touchspin" style="margin-left: 40px;"><span class="input-group-addon bootstrap-touchspin-prefix" style="display: none;"></span>
                    <input type="text" id="customer_search" placeholder="Enter customer name" class="form-control" style="width: 300px;color:black;">
                    <span class="input-group-btn">
                        <button class="btn btn-default  bootstrap-touchspin-up" type="button" onclick="customerSearch('ticket')">Search</button>
                        <button class="btn btn-default  bootstrap-touchspin-up" type="button"  onclick="addNewCustomer()">Add New</button>
                    </span>
                </div>
            </div>
        </div>
    </div>
    <br>
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
        <input type="hidden" id="customer_id" name="customer_id" value="<%=customer.getCustomer_id()%>">
        <div class="form-horizontal">
            <div class="form-group">
                <label class="col-sm-4 control-label">Customer's Name: </label>
                <div class="col-sm-6">
                    <label class="form-control"><%=customer.getSalutation()%>. <%=customer.getFirst_name()%> <%=customer.getLast_name()%></label>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-4 control-label">Customer's Contact: </label>
                <div class="col-sm-6">
                    <label class="form-control">
                        <%
                            int contact = customer.getContact();
                            if (contact != 0) {
                                out.println(contact + "");
                            }
                        %>    
                    </label>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-4 control-label">Customer's Email: </label>
                <div class="col-sm-6">
                    <label class="form-control"><%=customer.getEmail()%></label>    
                </div>
            </div>    
        </div>
    </div>
    <br>
    <h3 class="title-hero">
        Ticket Information
    </h3> <hr>
    <input type="hidden" id="datetime_of_creation" value="<%=Converter.convertDateDatabase(ticket.getDatetime_of_creation())%>">
    <div class="form-horizontal">
        <div class="form-group">
            <label class="col-sm-4 control-label">Status: </label>
            <div class="col-sm-6">
                <input type="text" class="form-control" value="<%=ticket.getStatus()%>" disabled>
            </div>
        </div>

        <div class="form-group">
            <label class="col-sm-4 control-label">Assigned To: </label>
            <div class="col-sm-6">
                <div id="dynamicInput">
                    <%
                        ArrayList<User> assigned_users = ticket.getAssigned_users();
                        for (int i = 0; i < assigned_users.size(); i++) {
                            String nric = assigned_users.get(i).getNric();
                            if (i == 0) {
                    %>
                    <div id="<%=i%>">
                        <div class="input-group">
                            <span class="input-group-btn">
                                <input class="btn btn-round btn-primary" type="button" value="+" onClick="addInput('dynamicInput');">
                            </span>
                            <select name="assigned" class="form-control">
                                <%
                                    for (User assignee : users) {
                                        String userNric = assignee.getNric();
                                        if (userNric.equals(nric)) {
                                            out.println("<option value='" + assignee.getNric() + "' selected>" + assignee + "</option>");
                                        } else {
                                            out.println("<option value='" + assignee.getNric() + "'>" + assignee + "</option>");
                                        }
                                    }
                                %>
                            </select>
                        </div>
                    </div>
                    <%
                    } else {
                    %>
                    <div id="<%=i%>">
                        <div class="input-group" style="margin-top: 15px">
                            <span class="input-group-btn">
                                <input class="btn btn-round btn-warning" type="button" value="x" onClick='removeAdditional(this);'>
                            </span>
                            <select name="assigned" class="form-control">
                                <%
                                    for (User assignee : users) {
                                        String userNric = assignee.getNric();
                                        if (userNric.equals(nric)) {
                                            out.println("<option value='" + assignee.getNric() + "' selected>" + assignee + "</option>");
                                        } else {
                                            out.println("<option value='" + assignee.getNric() + "'>" + assignee + "</option>");
                                        }
                                    }
                                %>
                            </select>
                        </div>
                    </div>
                    <%
                            }
                        }
                    %>
                </div>
                <div id="additionalAssigned">
                    <div class="input-group" style="margin-top: 15px">
                        <span class="input-group-btn">
                            <input class="btn btn-round btn-warning" type='button' value='x' onClick='removeAdditional(this);'>
                        </span>
                        <select name="assigned" class="form-control">
                            <%
                                for (User assignee : users) {
                                    out.println("<option value='" + assignee.getNric() + "'>" + assignee + "</option>");
                                }
                            %>
                        </select>
                    </div>
                </div>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-4 control-label">Subject: </label>
            <div class="col-sm-6">
                <input type="text" id="subject" class="form-control" value="<%=ticket.getSubject()%>">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-4 control-label">Description: </label>
            <div class="col-sm-6">
                <textarea id="description" class="form-control"><%=ticket.getDescription()%></textarea>
            </div>
        </div>
        <div class="bg-default text-center">
            <button class="btn loading-button btn-primary" onclick="updateTicket()">Update Ticket</button>
        </div> 
    </div>
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
