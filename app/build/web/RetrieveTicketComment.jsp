<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.ticket.TicketComment"%>
<%@page import="com.vimbox.database.TicketCommentDAO"%>
<%@page import="java.util.ArrayList"%>
<%
    String ticketId = request.getParameter("getTid");
    ArrayList<TicketComment> comments = TicketCommentDAO.getTicketCommentsById(ticketId);
    out.println("<h2>Comment History</h2><hr>");
    out.println("Ticket ID :" + ticketId + "<br><br>");
    String table = "<table border='1' width='100%'><tr><th>Date & Time</th><th>Comment</th></tr>";
    for(TicketComment comment:comments){
        table+="<tr>";
        table+="<td align='center'>" + Converter.convertDate(comment.getDatetime()) + "</td>";
        table+="<td>" + comment.getComment() + "</td>";
        table+="</tr>";
    }
    table+="</table>";
    out.println(table);
%>
