<%@page import="com.vimbox.user.User"%>
<%@page import="com.vimbox.database.UserDAO"%>
<%@page import="org.joda.time.LocalDateTime"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.hr.Attendance"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.UserAttendanceDAO"%>
<style type="text/css"> .javascript { display: none; } </style>
 <div class="javascript">
<script type="text/javascript" src="assets/widgets/datatable/datatable.js"></script>
<script type="text/javascript" src="assets/widgets/datatable/datatable-bootstrap.js"></script>
<script type="text/javascript" src="assets/widgets/datatable/datatable-tabletools.js"></script>
<script type="text/javascript">

    /* Datatables basic */

    $(document).ready(function() {
        $('#attendanceTable').dataTable();
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
    ArrayList<User> employees = UserDAO.getFullTimeUsers();
    ArrayList<String> yearMonths = UserAttendanceDAO.getYearMonthByKeyword(keyword);

    if (!keyword.isEmpty()) {
        if (yearMonths.size() > 1) {
            out.println(yearMonths.size() + " results found");
        } else if (yearMonths.size() == 1) {
            out.println("1 result found");
        } else {
            out.println("No results found");
        }
        out.println("<br><br>");
    }
%>

<table class="table table-hover" id="attendanceTable">
    <col width="50%">
    <col width="50%">
    <thead>
        <tr>
            <th style="text-align: center">Month</th>
            <th style="text-align: center">Action</th>
        </tr>
    </thead>

    <%
        for (String yearMonth : yearMonths) {
            ArrayList<Attendance> attendances = UserAttendanceDAO.getAttendancesByYearMonth(yearMonth);
    %>
    <tbody>
        <tr>
            <td style="text-align: center"><%=yearMonth%></td>
            <td style="text-align: center">
                <button class="btn btn-default"  onclick="viewAttendance('<%=yearMonth%>')">View</button>
            </td>
        </tr>
    </tbody>
    <%        }
    %>
</table>

