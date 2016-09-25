<%@page import="com.vimbox.user.User"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.vimbox.database.JobDAO"%>
<%@page import="com.vimbox.operations.Job"%>
<%@page import="com.vimbox.sitesurvey.SiteSurvey"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.SiteSurveyDAO"%>
<style type="text/css"> .javascript { display: none; } </style>
 <div class="javascript">
<script type="text/javascript" src="assets/widgets/datatable/datatable.js"></script>
<script type="text/javascript" src="assets/widgets/datatable/datatable-bootstrap.js"></script>
<script type="text/javascript" src="assets/widgets/datatable/datatable-tabletools.js"></script>
<script type="text/javascript">

    /* Datatables basic */

    $(document).ready(function() {
        $('#assignJobsTable').dataTable();
    });

    /* Datatables hide columns */

    $(document).ready(function() {
        var table = $('#datatable-hide-columns').DataTable( {
            "scrollY": "300px",
            "paging": false
        } );

        $('#datatable-hide-columns_filter').hide();

        $('a.toggle-vis').on( 'click', function (e) {
            e.preventDefault();

            // Get the column API object
            var column = table.column( $(this).attr('data-column') );

            // Toggle the visibility
            column.visible( ! column.visible() );
        } );
    } );

    /* Datatable row highlight */

    $(document).ready(function() {
        var table = $('#datatable-row-highlight').DataTable();

        $('#datatable-row-highlight tbody').on( 'click', 'tr', function () {
            $(this).toggleClass('tr-selected');
        } );
    });



    $(document).ready(function() {
        $('.dataTables_filter input').attr("placeholder", "Search...");
    });

</script>
 </div>
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
<button class='btn btn-info' onclick="assignJobModal()">Assign Supervisor</button><br><br>
<table class="table table-hover" id="assignJobsTable">
    <col width="5%">
    <col width="10%">
    <col width="10%">
    <col width="10%">
    <col width="10%">
    <col width="20%">
    <col width="20%">
    <col width="10%">
    <col width="5%">
    <thead>
    <tr>
        <th><input type='checkbox' onclick="selectAllJobs(this)"></th>
        <th>Lead ID</th>
        <th>Truck(s)</th>
        <th>Supervisor</th>
        <th>Date</th>
        <th>From</th>
        <th>To</th>
        <th>Time Slot</th>
        <th>View</th>
    </tr>
    </thead>
    <%
        String leadId = ""; 
        String jj = "";
        ArrayList<String> jTruck = new ArrayList<String>();
        String timeslot = "";
        String supervisor = "";
        ArrayList<String> addressesFr = new ArrayList<String>();
        ArrayList<String> addressesTo = new ArrayList<String>();
        for (int i = 0; i < jobs.size(); i++) {
            Job job = jobs.get(i);
            String nextLeadId = job.getLeadId() + "";
            String nextTruck = job.getAssignedTruck() + "";
            String nextTimeslot = job.getTimeslots();
            String nextSupervisor = "";
            User sup = job.getSupervisor();
            if(sup != null){
                nextSupervisor = sup.toString();
            }
            
            String j = job.getDate();
            if (i == 0) {
                jj = j;
                leadId = nextLeadId;
                supervisor = nextSupervisor;
                timeslot = nextTimeslot;
            }

            if (!j.equals(jj) || !nextLeadId.equals(leadId)) {
                out.println("<tr>");
                out.println("<td align='center'><input type='checkbox' name='selectedJobs' value='" + leadId + "'></td>");
                out.println("<td align='center'>" + leadId + "</td>");
                out.println("<td align='center'><ul>");
                for(String truck:jTruck){
                    out.println("<li>" + truck + "</li>");
                }
                out.println("<td align='center'>" + supervisor + "</td>");
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
                supervisor = nextSupervisor;
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
                out.println("<td align='center'><input type='checkbox' name='selectedJobs' value='" + leadId + "'></td>");
                out.println("<td align='center'>" + leadId + "</td>");
                out.println("<td align='center'><ul>");
                for(String truck:jTruck){
                    out.println("<li>" + truck + "</li>");
                }
                out.println("</ul></td>");
                out.println("<td align='center'>" + supervisor + "</td>");
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

