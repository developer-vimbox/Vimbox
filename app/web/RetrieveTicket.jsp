<%@page import="com.vimbox.customer.Customer"%>
<%@page import="com.vimbox.user.User"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.database.TicketDAO"%>
<%@page import="com.vimbox.ticket.Ticket"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.CustomerHistoryDAO"%>
<%
    String ticID = request.getParameter("getTid");
    Ticket ticket = TicketDAO.getTicketById(Integer.parseInt(ticID));

    int ticketId = ticket.getTicket_id();
    Customer customer = ticket.getCustomer();
    String customerName = customer.toString();
    String contact = customer.getContact() + "";
    if (contact.equals("0")) {
        contact = "N/A";
    }
    String email = customer.getEmail();
    if (email.isEmpty()) {
        email = "N/A";
    }
    String subject = ticket.getSubject();
    String dateTime = Converter.convertDate(ticket.getDatetime_of_creation());
    String status = ticket.getStatus();
%>
<div class="form-horizontal" style="font-size: 14px;">
    <div class="form-group">
        <label class="col-sm-4 control-label">Ticket ID: </label>
        <div class="col-sm-5" style="padding-top: 7px;">
            <%=ticketId%>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-4 control-label">Date & Time: </label>
        <div class="col-sm-5" style="padding-top: 7px;">
            <%=dateTime%>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-4 control-label">Ticket Owner: </label>
        <div class="col-sm-5" style="padding-top: 7px;">
            <%=ticket.getOwner_user().toString()%>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-4 control-label">Assigned To: </label>
        <div class="col-sm-5" style="padding-top: 7px;">
            <%
                ArrayList<User> assigned = ticket.getAssigned_users();
                if (assigned.size() > 1) {
                    for (User assignee : assigned) {
                        out.println("<li>" + assignee.toString() + "</li>");
                    }
                } else if (assigned.size() == 1) {
                    out.println(assigned.get(0).toString());
                }
            %>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-4 control-label">Subject: </label>
        <div class="col-sm-5" style="padding-top: 7px;">
            <%=subject%>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-4 control-label">Customer Details: </label>
        <div class="col-sm-5" style="padding-top: 7px;">
            <%=customerName%><br>
            <%=contact%><br>
            <%=email%>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-4 control-label">Status: </label>
        <div class="col-sm-5" style="padding-top: 7px;">
            <%=status%>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-4 control-label">Description: </label>
        <div class="col-sm-5" style="padding-top: 7px;">
            <%=ticket.getDescription()%>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-4 control-label">Solution: </label>
        <div class="col-sm-5" style="padding-top: 7px;">
            <%=ticket.getSolution()%>
        </div>
    </div>
</div>
