<%@page import="com.vimbox.sitesurvey.SiteSurvey"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.SiteSurveyDAO"%>
<%
    String userId = request.getParameter("userId");
    String keyword = request.getParameter("keyword");
    String type = request.getParameter("type");
    ArrayList<SiteSurvey> surveys = new ArrayList<SiteSurvey>();
    if(type.equals("Completed")){
        surveys = SiteSurveyDAO.getCompletedSiteSurveysByUserKeyword(userId, keyword);
    }else{
        surveys = SiteSurveyDAO.getNonCompletedSiteSurveysByUserKeyword(userId, keyword);
    } 
    
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
        String leadId = ""; 
        String date = "";
        String timeslot = "";
        String status = "";
        ArrayList<String> address = new ArrayList<String>();
        for(int i=0 ; i<surveys.size(); i++){
            SiteSurvey survey = surveys.get(i);
            String nextLeadId = survey.getLead() + "";
            String nextDate = survey.getDate();
            String nextTimeslot = survey.getTimeSlots();
            String nextStatus = survey.getStatus();
            if(i==0){
                leadId = nextLeadId;
                date = nextDate;
                timeslot = nextTimeslot;
                status = nextStatus;
                address.add(survey.getAddress());
            }
            
            if(!leadId.equals(nextLeadId) || !date.equals(nextDate) || !timeslot.equals(nextTimeslot)){
                out.println("<tr>");
                out.println("<td align='center'>" + leadId + "</td>");
                out.println("<td align='center'><ul>");
                for(String add:address){
                    out.println("<li>" + add + "</li>");
                }
                out.println("</ul></td>");
                out.println("<td align='center'>" + date + "</td>");
                out.println("<td align='center'>" + timeslot + "</td>");
                out.println("<td align='center'>");
                if(status.equals("Pending")){
                    out.println("<button onclick=\"startSurvey('" + leadId + "', '" + date + "', '" + timeslot + "', 'Start')\">Start Survey</button>");
                }else if (status.equals("Ongoing")){
                    out.println("<button onclick=\"startSurvey('" + leadId + "', '" + date + "', '" + timeslot + "', '')\">Continue Survey</button>");
                }else{
                    out.println("<button onclick=\"viewSurvey('" + leadId + "', '" + date + "', '" + timeslot + "')\">View Survey</button>");
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
            if(!address.contains(survey.getAddress())){
                address.add(survey.getAddress());
            }
            
            if(i == surveys.size()-1){
                out.println("<tr>");
                out.println("<td align='center'>" + leadId + "</td>");
                out.println("<td align='center'><ul>");
                for(String add:address){
                    out.println("<li>" + add + "</li>");
                }
                out.println("</ul></td>");
                out.println("<td align='center'>" + date + "</td>");
                out.println("<td align='center'>" + timeslot + "</td>");
                out.println("<td align='center'>");
                if(status.equals("Pending")){
                    out.println("<button onclick=\"startSurvey('" + leadId + "', '" + date + "', '" + timeslot + "', 'Start')\">Start Survey</button>");
                }else if (status.equals("Ongoing")){
                    out.println("<button onclick=\"startSurvey('" + leadId + "', '" + date + "', '" + timeslot + "', '')\">Continue Survey</button>");
                }else{
                    out.println("<button onclick=\"viewSurvey('" + leadId + "', '" + date + "', '" + timeslot + "')\">View Survey</button>");
                }
                out.println("</td>");
                out.println("</tr>");
            }
        }
    %>
</table>