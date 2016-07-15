<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.ticket.TicketComment"%>
<%@page import="com.vimbox.database.TicketCommentDAO"%>
<%@page import="java.util.ArrayList"%>
<%
    int ticketId = Integer.parseInt(request.getParameter("getTid"));
    ArrayList<TicketComment> comments = TicketCommentDAO.getTicketCommentsById(ticketId);
    out.println(" <center><h3 class=\"modal-title\"><b>Comment History</b></h3></center>");
    out.println("Ticket ID :" + ticketId + "<br><br>");
    String table = "<table class=\"table table-hover\"><tr><th>Date & Time</th><th>Comment</th></tr>";
    for(TicketComment comment:comments){
        table+="<tr>";
        table+="<td align='center'>" + Converter.convertDate(comment.getDatetime()) + "</td>";
        table+="<td>" + comment.getComment() + "</td>";
        table+="</tr>";
    }
    table+="</table>";
    out.println(table);
%>
