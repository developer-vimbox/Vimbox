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
        $('#completedSTable').dataTable();
        $('#pendingSTable').dataTable();
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
    String tableID = "";
    if (type.equals("Completed")) {
        tableID = "completedSTable";
    } else {
        tableID = "pendingSTable";
    }
%>
<table class="table table-hover" id="<%=tableID%>">
    <col width="10%">
    <col width="30%">
    <col width="20%">
    <col width="10%">
    <col width="10%">
    <col width="20%">
    <thead>
    <tr>
        <th>Lead ID</th>
        <th>Address</th>
        <th>Remarks</th>
        <th>Date</th>
        <th>Time Slot</th>
        <th>Action</th>
    </tr>
    </thead>
    <%
        String leadId = ""; 
        String date = "";
        String timeslot = "";
        String status = "";
        String remarks = "";
        ArrayList<String> address = new ArrayList<String>();
        for(int i=0 ; i<surveys.size(); i++){
            SiteSurvey survey = surveys.get(i);
            String nextLeadId = survey.getLead() + "";
            String nextDate = survey.getDate();
            String nextTimeslot = survey.getTimeSlots();
            String nextRemarks = survey.getRemarks();
            String nextStatus = survey.getStatus();
            if(i==0){
                leadId = nextLeadId;
                date = nextDate;
                timeslot = nextTimeslot;
                status = nextStatus;
                remarks = nextRemarks;
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
                out.println("<td align='center'>" + remarks + "</td>");
                out.println("<td align='center'>" + date + "</td>");
                out.println("<td align='center'>" + timeslot + "</td>");
                out.println("<td align='center'>");
                if(status.equals("Pending")){
                    out.println("<button class='btn btn-default' onclick=\"startSurvey('" + leadId + "', '" + date + "', '" + timeslot + "', 'Start')\">Start Survey</button>");
                }else if (status.equals("Ongoing")){
                    out.println("<button class='btn btn-default' onclick=\"startSurvey('" + leadId + "', '" + date + "', '" + timeslot + "', '')\">Continue Survey</button>");
                }else{
                    out.println("<button class='btn btn-default' onclick=\"viewSurvey('" + leadId + "', '" + date + "', '" + timeslot + "')\">View Survey</button>");
                    out.println("<button class='btn btn-default' onclick=\"viewDom('" + leadId + "', '" + userId + "')\">DOM</button>");
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
            remarks = nextRemarks;
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
                out.println("<td align='center'>" + remarks + "</td>");
                out.println("<td align='center'>" + date + "</td>");
                out.println("<td align='center'>" + timeslot + "</td>");
                out.println("<td align='center'>");
                if(status.equals("Pending")){
                    out.println("<button class='btn btn-default' onclick=\"startSurvey('" + leadId + "', '" + date + "', '" + timeslot + "', 'Start')\">Start Survey</button>");
                }else if (status.equals("Ongoing")){
                    out.println("<button class='btn btn-default' onclick=\"startSurvey('" + leadId + "', '" + date + "', '" + timeslot + "', '')\">Continue Survey</button>");
                }else{
                    out.println("<button class='btn btn-default' onclick=\"viewSurvey('" + leadId + "', '" + date + "', '" + timeslot + "')\">View Survey</button>");
                    out.println("<button class='btn btn-default' onclick=\"viewDom('" + leadId + "', '" + userId + "')\">DOM</button>");
                }
                out.println("</td>");
                out.println("</tr>");
            }
        }
    %>
</table>