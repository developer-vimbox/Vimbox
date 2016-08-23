<%@page import="com.vimbox.sitesurvey.SiteSurvey"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.SiteSurveyDAO"%>
<%
    String keyword = request.getParameter("keyword");
    String nric = request.getParameter("nric");
    ArrayList<SiteSurvey> surveys = SiteSurveyDAO.getSiteSurveysByOwnerKeyword(nric, keyword);
    
    if (!keyword.isEmpty()) {
        if (surveys.size() > 0) {
            out.println("Results found :");
        } else {
            out.println("No results found");
        }
        out.println("<br><br>");
    }
%>

<table border="1" width="100%">
    <col width="10%">
    <col width="10%">
    <col width="40%">
    <col width="10%">
    <col width="10%">
    <col width="10%">
    <col width="10%">
    <tr>
        <th>Lead ID</th>
        <th>Assignee</th>
        <th>Address</th>
        <th>Date</th>
        <th>Time Slot</th>
        <th>Status</th>
        <th>Action</th>
    </tr>
    <%
        String leadId = ""; 
        String date = "";
        String timeslot = "";
        String status = "";
        String surveyor = "";
        ArrayList<String> address = new ArrayList<String>();
        for(int i=0 ; i<surveys.size(); i++){
            SiteSurvey survey = surveys.get(i);
            String nextLeadId = survey.getLead() + "";
            String nextDate = survey.getDate();
            String nextTimeslot = survey.getTimeSlots();
            String nextStatus = survey.getStatus();
            String nextSurveyor = survey.getSiteSurveyor().toString();
            if(i==0){
                leadId = nextLeadId;
                date = nextDate;
                timeslot = nextTimeslot;
                status = nextStatus;
                surveyor = nextSurveyor;
                address.add(survey.getAddress());
            }
            
            if(!leadId.equals(nextLeadId) || !date.equals(nextDate) || !timeslot.equals(nextTimeslot)){
                out.println("<tr>");
                out.println("<td align='center'>" + leadId + "</td>");
                out.println("<td align='center'>" + surveyor + "</td>");
                out.println("<td align='center'><ul>");
                for(String add:address){
                    out.println("<li>" + add + "</li>");
                }
                out.println("</ul></td>");
                out.println("<td align='center'>" + date + "</td>");
                out.println("<td align='center'>" + timeslot + "</td>");
                out.println("<td align='center'>" + status + "</td>");
                out.println("<td align='center'>");
                if(status.equals("Pending")){
                    out.println("<button onclick=\"confirmCancel('" + leadId + "', '" + date + "', '" + timeslot + "', '" + nric + "')\">Cancel</button>");
                }
                out.println("</td>");
                out.println("</tr>");
                date = nextDate;
                timeslot = nextTimeslot;
                status = nextStatus;
                address.clear();
            }
            leadId = nextLeadId;
            date = nextDate;
            timeslot = nextTimeslot;
            status = nextStatus;
            surveyor = nextSurveyor;
            if(!address.contains(survey.getAddress())){
                address.add(survey.getAddress());
            }
            
            if(i == surveys.size()-1){
                out.println("<tr>");
                out.println("<td align='center'>" + leadId + "</td>");
                out.println("<td align='center'>" + surveyor + "</td>");
                out.println("<td align='center'><ul>");
                for(String add:address){
                    out.println("<li>" + add + "</li>");
                }
                out.println("</ul></td>");
                out.println("<td align='center'>" + date + "</td>");
                out.println("<td align='center'>" + timeslot + "</td>");
                out.println("<td align='center'>" + status + "</td>");
                out.println("<td align='center'>");
                if(status.equals("Pending")){
                    out.println("<button onclick=\"confirmCancel('" + leadId + "', '" + date + "', '" + timeslot + "', '" + nric + "')\">Cancel</button>");
                }
                out.println("</td>");
                out.println("</tr>");
            }
        }
    %>
</table>
