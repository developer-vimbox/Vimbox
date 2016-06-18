<%@page import="com.vimbox.sales.LeadFollowup"%>
<%@page import="com.vimbox.database.LeadFollowupDAO"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="java.util.ArrayList"%>
<%
    String leadId = request.getParameter("getLid");
    ArrayList<LeadFollowup> followups = LeadFollowupDAO.getLeadFollowupsById(Integer.parseInt(leadId));
    out.println("<h2>Follow-Up History</h2><hr>");
    out.println("Lead ID :" + leadId + "<br><br>");
    String table = "<table border='1' width='100%'><tr><th>Date & Time</th><th>Follow-Up</th></tr>";
    for(LeadFollowup followup:followups){
        table+="<tr>";
        table+="<td align='center'>" + Converter.convertDate(followup.getDatetime()) + "</td>";
        table+="<td>" + followup.getFollowup() + "</td>";
        table+="</tr>";
    }
    table+="</table>";
    out.println(table);
%>
