<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.ticket.Ticket"%>
<%@page import="com.vimbox.database.TicketDAO"%>
<%@page import="com.vimbox.user.User"%>
<%
    String id = request.getParameter("tId");
    Ticket ticket = null;
    if (id == null || id.isEmpty()) {
        response.sendRedirect("MyTickets.jsp");
        return;
    }else{
        User owner = (User) request.getSession().getAttribute("session");
        ticket = TicketDAO.getTicketById(id);
        if(ticket == null || !owner.getUsername().equals(ticket.getOwner().getUsername())){
            ticket = null;
            response.sendRedirect("MyTickets.jsp");
            return;
        }
    }
%>
