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
        $('#bookedOpsTable').dataTable();
        $('#confirmedOpsTable').dataTable();
        $('#cancelledOpsTable').dataTable();
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
    String type = request.getParameter("type");
    ArrayList<Job> jobs = JobDAO.getJobsByKeyword(keyword, type);
    
    if (!keyword.isEmpty()) {
        if (jobs.size() > 0) {
            out.println("Results found :");
        } else {
            out.println("No results found");
        }
        out.println("<br><br>");
    }
    
    String tableID = "";
    if(type.equals("Booked")) {
        tableID = "bookedOpsTable";
    } else if (type.equals("Confirmed")) {
        tableID = "confirmedOpsTable";
    } else if (type.equals("Cancelled")) {
        tableID = "cancelledOpsTable";
    }
%>

<table class="table table-hover" id="<%=tableID%>">
    <col width="10%">
    <col width="10%">
    <col width="25%">
    <col width="25%">
    <col width="10%">
    <col width="10%">
    <col width="10%">
    <thead>
    <tr>
        <th>Lead ID</th>
        <th>Date</th>
        <th>From</th>
        <th>To</th>
        <th>Time Slot</th>
        <th>Status</th>
        <th>Action</th>
    </tr>
    </thead>
    <%
        String leadId = ""; 
        String jj = "";
        String jStatus = "";
        String timeslot = "";
        ArrayList<String> addressesFr = new ArrayList<String>();
        ArrayList<String> addressesTo = new ArrayList<String>();
        for (int i = 0; i < jobs.size(); i++) {
            Job job = jobs.get(i);
            String nextLeadId = job.getLeadId() + "";
            String nextTimeslot = job.getTimeslots();
            String j = job.getDate();
            if (i == 0) {
                jj = j;
                leadId = nextLeadId;
                timeslot = nextTimeslot;
                jStatus = job.getStatus();
            }

            if (!j.equals(jj) || !nextLeadId.equals(leadId)) {
                out.println("<tr>");
                out.println("<td align='center'>" + leadId + "</td>");
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
                out.println("<td align='center'>" + jStatus + "</td>");
                out.println("<td align='center'>");
                if(jStatus.equals("Booked")){
                    out.println("<button class='btn btn-default' onclick=\"confirmJobCancel('" + leadId + "', '" + jj + "', '" + timeslot + "','" + jStatus + "')\">Cancel</button>");
                    out.println("<button class='btn btn-default' onclick=\"changeDom('" + leadId + "', '" + jj + "', '" + timeslot + "', 'Booked')\">Change</button>");
                }else if(jStatus.equals("Confirmed")){
                    // DIFFERENT CANCELLATION
                    out.println("<button class='btn btn-default' onclick=\"confirmJobCancel('" + leadId + "', '" + jj + "', '" + timeslot + "','" + jStatus + "')\">Cancel</button>");
                    // CHANGE OF DATES
                    out.println("<button class='btn btn-default' onclick=\"changeDom('" + leadId + "', '" + jj + "', '" + timeslot + "', 'Confirmed')\">Change</button>");
                }
                out.println("</td>");
                out.println("</tr>");
                
                jj = j;
                leadId = nextLeadId;
                timeslot = nextTimeslot;
                jStatus = job.getStatus();
                addressesFr = new ArrayList<String>();
                addressesTo = new ArrayList<String>();
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
                out.println("<td align='center'>" + leadId + "</td>");
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
                out.println("<td align='center'>" + jStatus + "</td>");
                out.println("<td align='center'>");
                if(jStatus.equals("Booked")){
                    out.println("<button class='btn btn-default' onclick=\"confirmJobCancel('" + leadId + "', '" + jj + "', '" + timeslot + "','" + jStatus + "')\">Cancel</button>");
                    out.println("<button class='btn btn-default' onclick=\"changeDom('" + leadId + "', '" + jj + "', '" + timeslot + "', 'Booked')\">Change</button>");
                }else if(jStatus.equals("Confirmed")){
                    // DIFFERENT CANCELLATION
                    out.println("<button class='btn btn-default' onclick=\"confirmJobCancel('" + leadId + "', '" + jj + "', '" + timeslot + "','" + jStatus + "')\">Cancel</button>");
                    // CHANGE OF DATES
                    out.println("<button class='btn btn-default' onclick=\"changeDom('" + leadId + "', '" + jj + "', '" + timeslot + "', 'Confirmed')\">Change</button>");
                }
                out.println("</td>");
                out.println("</tr>");
            }
        }
    %>
</table>
