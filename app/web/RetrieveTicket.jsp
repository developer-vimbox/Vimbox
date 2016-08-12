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
<table class="table">
    <tr>
        <td align="right">Ticket ID: </td>
        <td><%=ticketId%></td>
    </tr>
    <tr>
        <td align="right">Date & Time: </td>
        <td><%=dateTime%></td>
    </tr>
    <tr>
        <td align="right">Ticket Owner: </td>
        <td><%=ticket.getOwner_user().toString()%></td>
    </tr>
    <tr>
        <td align="right">Assigned To: </td>
        <td>
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
        </td>
    </tr>
    <tr>
        <td align="right">Subject: </td>
        <td><%=subject%></td>
    </tr>
    <tr>
        <td align="right">Customer Details: </td>
        <td>
            <%=customerName%><br>
            <%=contact%><br>
            <%=email%>
        </td>
    </tr>
    <tr>
        <td align="right">Status: </td>
        <td><%=status%></td>
    </tr>
    <tr>
        <td align="right">Description: </td>
        <td><%=ticket.getDescription()%></td>
    </tr>
    <tr>
        <td align="right">Solution: </td>
        <td><%=ticket.getSolution()%></td>
    </tr>
</table>
