<%@page import="com.vimbox.customer.Customer"%>
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
        <%
            String custId = request.getParameter("getId");
            ArrayList<Integer> ids = CustomerHistoryDAO.getCustomerTicketIds(Integer.parseInt(custId));
            if (ids.isEmpty()) {
        %>
        No results found
        <%
        } else {
            if (ids.size() == 1) {
                out.println(ids.size() + " record found");
            } else {
                out.println(ids.size() + " records found");
            }
            ArrayList<Ticket> tickets = new ArrayList<Ticket>();
            for (int id : ids) {
                tickets.add(TicketDAO.getTicketById(id));
            }
        %>
        <br><br>
        <table class="table table-hover">
            <tr>
                <th>Ticket ID</th>
                <th>Name</th>
                <th>Contact</th>
                <th>Email</th>
                <th>Subject</th>
                <th>Date & Time</th>
                <th>Status</th>
                <th>View</th>
            </tr>
            <%
                for (Ticket ticket : tickets) {
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
            <tr>
                <td><%=ticketId%></td>
                <td><%=customerName%></td>
                <td><%=contact%></td>
                <td><%=email%></td>
                <td><%=subject%></td>
                <td><%=dateTime%></td>
                <td><%=status%></td>
                <td>
                    <button onclick="viewTicket('<%=ticketId%>')" data-toggle="modal" data-target="#viewTicketModal">VT</button>
                        
                    <button onclick="viewComments('<%=ticketId%>')" data-toggle="modal" data-target="#viewCommentsModal">VC</button>
                </td>
            </tr>
            <%
                    }
                }
            %>
        </table>

    </body>
</html>
