<%@page import="com.vimbox.sales.LeadFollowup"%>
<%@page import="com.vimbox.database.LeadFollowupDAO"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="java.util.ArrayList"%>
<%
    String leadId = request.getParameter("getLid");
    ArrayList<LeadFollowup> followups = LeadFollowupDAO.getLeadFollowupsById(Integer.parseInt(leadId));
    out.println("<center><h3 class=\"modal-title\"><b>Follow-Up History</b></h3></center><hr>");
    out.println("Lead ID :" + leadId + "<br><br>");
    String table = "<table class='table table-hover'width='100%'><thead><tr><th>Date & Time</th><th>Follow-Up</th></tr></thead><tbody>";
    for(LeadFollowup followup:followups){
        table+="<tr>";
        table+="<td align='center'>" + Converter.convertDate(followup.getDatetime()) + "</td>";
        table+="<td>" + followup.getFollowup() + "</td>";
        table+="</tr>";
    }
    table+="</tbody></table>";
    out.println(table);
%>
