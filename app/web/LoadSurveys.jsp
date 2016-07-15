<%@page import="com.vimbox.sitesurvey.SiteSurvey"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.SiteSurveyDAO"%>
<%
    String userId = request.getParameter("userId");
    String keyword = request.getParameter("keyword");
    ArrayList<SiteSurvey> surveys = SiteSurveyDAO.getSiteSurveysByUserKeyword(userId, keyword);
    
    if (!keyword.isEmpty()) {
        if (surveys.size() > 1) {
            out.println(surveys.size() + " results found");
        } else if (surveys.size() == 1) {
            out.println("1 result found");
        } else {
            out.println("No results found");
        }
        out.println("<br><br>");
    }
%>
<table border="1" width="100%">
    <col width="20%">
    <col width="20%">
    <col width="20%">
    <col width="20%">
    <col width="20%">
    <tr>
        <th>Lead ID</th>
        <th>Address</th>
        <th>Date</th>
        <th>Time Slot</th>
        <th>Action</th>
    </tr>
    <%
        for(SiteSurvey survey : surveys){
            out.println("<tr>");
            out.println("<td align='center'>" + survey.getLead() + "</td>");
            out.println("<td align='center'>" + survey.getAddress() + "</td>");
            out.println("<td align='center'>" + survey.getDate() + "</td>");
            out.println("<td align='center'>" + survey.getTimeSlots() + "</td>");
            out.println("<td></td>");
            out.println("</tr>");
        }
    %>
</table>