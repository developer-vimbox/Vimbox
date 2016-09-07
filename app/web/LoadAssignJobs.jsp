<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.vimbox.database.JobDAO"%>
<%@page import="com.vimbox.operations.Job"%>
<%@page import="com.vimbox.sitesurvey.SiteSurvey"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.SiteSurveyDAO"%>
<%
    String keyword = request.getParameter("keyword");
    ArrayList<Job> jobs = JobDAO.getConfirmedJobsByKeyword(keyword);
    
    if (!keyword.isEmpty()) {
        if (jobs.size() > 0) {
            out.println("Results found :");
        } else {
            out.println("No results found");
        }
        out.println("<br><br>");
    }
%>
<button class='btn btn-default' onclick="assignJobModal()">Assign Supervisor</button>
<table class="table table-bordered" width="100%">
    <col width="5%">
    <col width="5%">
    <col width="10%">
    <col width="10%">
    <col width="25%">
    <col width="25%">
    <col width="10%">
    <col width="5%">
    <col width="5%">
    <thead>
    <tr>
        <th><input type='checkbox' onclick="selectAllJobs()"></th>
        <th>Job ID</th>
        <th>Lead ID</th>
        <th>Truck(s)</th>
        <th>Date</th>
        <th>From</th>
        <th>To</th>
        <th>Time Slot</th>
        <th>View</th>
    </tr>
    </thead>
    <%
        String jobId = "";
        String leadId = ""; 
        String jj = "";
        ArrayList<String> jTruck = new ArrayList<String>();
        String timeslot = "";
        ArrayList<String> addressesFr = new ArrayList<String>();
        ArrayList<String> addressesTo = new ArrayList<String>();
        for (int i = 0; i < jobs.size(); i++) {
            Job job = jobs.get(i);
            String nextJobId = job.getJobId() + "";
            String nextLeadId = job.getLeadId() + "";
            String nextTruck = job.getAssignedTruck() + "";
            String nextTimeslot = job.getTimeslots();
            String j = job.getDate();
            if (i == 0) {
                jj = j;
                leadId = nextLeadId;
                jobId = nextJobId;
                timeslot = nextTimeslot;
            }

            if (!j.equals(jj) || !nextLeadId.equals(leadId)) {
                out.println("<tr>");
                out.println("<td align='center'><input type='checkbox' name='selectedJobs' value='" + jobId + "'></td>");
                out.println("<td align='center'>" + jobId + "</td>");
                out.println("<td align='center'>" + leadId + "</td>");
                out.println("<td align='center'><ul>");
                for(String truck:jTruck){
                    out.println("<li>" + truck + "</li>");
                }
                out.println("</ul></td>");
                out.println("<td align='center'>" + jj + "</td>");
                out.println("<td align='center'><ul>");
                for(String add:addressesFr){
                    out.println("<li>" + add + "</li>");
                }
                out.println("</ul></td>");
                out.println("<td align='center'><ul>");
                for(String add:addressesTo){
                    out.println("<li>" + add + "</li>");
                }
                out.println("</ul></td>");
                out.println("<td align='center'>" + timeslot + "</td>");
                out.println("<td align='center'><button class='btn btn-default' onclick=\"viewLead('" + leadId + "')\">VS</button></td>");
                out.println("</tr>");
                
                jj = j;
                leadId = nextLeadId;
                jobId = nextJobId;
                jTruck = new ArrayList<String>();
                timeslot = nextTimeslot;
                addressesFr = new ArrayList<String>();
                addressesTo = new ArrayList<String>();
            }

            if(!jTruck.contains(nextTruck)){
                jTruck.add(nextTruck);
            }
            
            HashMap<String, String> addresses = job.getAddresses();
            for (Map.Entry<String, String> entry : addresses.entrySet()) {
                String key = entry.getKey();
                String value = entry.getValue();
                if(value.equals("from")){
                    if (!addressesFr.contains(key)) {
                        addressesFr.add(key);
                    }
                }else{
                    if (!addressesTo.contains(key)) {
                        addressesTo.add(key);
                    }
                }
            }

            if (i == jobs.size() - 1) {
                out.println("<tr>");
                out.println("<td align='center'><input type='checkbox' name='selectedJobs' value='" + jobId + "'></td>");
                out.println("<td align='center'>" + jobId + "</td>");
                out.println("<td align='center'>" + leadId + "</td>");
                out.println("<td align='center'><ul>");
                for(String truck:jTruck){
                    out.println("<li>" + truck + "</li>");
                }
                out.println("</ul></td>");
                out.println("<td align='center'>" + jj + "</td>");
                out.println("<td align='center'><ul>");
                for(String add:addressesFr){
                    out.println("<li>" + add + "</li>");
                }
                out.println("</ul></td>");
                out.println("<td align='center'><ul>");
                for(String add:addressesTo){
                    out.println("<li>" + add + "</li>");
                }
                out.println("</ul></td>");
                out.println("<td align='center'>" + timeslot + "</td>");
                out.println("<td align='center'><button class='btn btn-default' onclick=\"viewLead('" + leadId + "')\">VS</button></td>");
                out.println("</tr>");
            }
        }
    %>
</table>

