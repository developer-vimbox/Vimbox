<%@page import="com.vimbox.customer.Customer"%>
<%@page import="com.vimbox.user.User"%>
<%@page import="com.vimbox.ticket.Ticket"%>
<%@page import="com.vimbox.database.TicketDAO"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="java.util.ArrayList"%>
<%
    int ticket_id = Integer.parseInt(request.getParameter("getTid"));
    Ticket newtick = TicketDAO.getTicketById(ticket_id);
    if (newtick != null) {
        out.println("<span class=\"close\" onclick=\"closeModal('viewTicketModal')\">×</span> <center><h3 class=\"modal-title\"><b>Ticket Details</b></h3></center><hr>");
        out.println("<table class=\"table table-hover\"><tr> <td align=\"right\">Ticket ID :</td><td>" + ticket_id + "</td></tr>");
        out.println("<tr> <td align=\"right\">Date & Time :</td><td>" + newtick.getDatetime_of_creation().toString() + "</td></tr><tr><td align=\"right\">Ticket Owner :</td><td>" + newtick.getOwner_user().toString() + "</td></tr>");
        ArrayList<User> assigned = newtick.getAssigned_users();
        out.println("<tr><td align=\"right\">Assigned To :</td><td>");
        if (assigned.size() > 1) {
            for (User assignee : assigned) {
                out.println("<li>" + assignee.toString() + "</li>");
            }
        } else if (assigned.size() == 1) {
            out.println(assigned.get(0).toString());
        }
        out.println("</td>");
        Customer customer = newtick.getCustomer();
        String customerName = customer.toString();
        String contact = customer.getContact() + "";
        if (contact.equals("0")) {
            contact = "N/A";
        }
        String email = customer.getEmail();
        if (email.isEmpty()) {
            email = "N/A";
        }
        out.println("<tr><td align=\"right\">Subject :</td><td>" + newtick.getSubject() + "</td></tr> <tr><td align=\"right\">Customer Details :</td><td>" + customerName + "<br>" + contact + "<br>" + email + "<br></td></tr>");
        out.println("<tr><td align=\"right\">Status :</td> <td>" + newtick.getStatus() + "</td></tr><tr> <td align=\"right\">Description :</td><td>" + newtick.getDescription() + "</td></tr>");
        out.println("<tr> <td align=\"right\">Solution :</td><td>" + newtick.getSolution() + "</td></tr></table>");
    }
%>
