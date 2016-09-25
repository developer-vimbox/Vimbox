<%@page import="com.vimbox.user.User"%>
<%@page import="com.vimbox.database.UserDAO"%>
<%@page import="org.joda.time.LocalDateTime"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.hr.Attendance"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.UserAttendanceDAO"%>
<style type="text/css"> .javascriptt { display: none; } </style>
 <div class="javascriptt">
<script type="text/javascript" src="assets/widgets/datatable/datatable.js"></script>
<script type="text/javascript" src="assets/widgets/datatable/datatable-bootstrap.js"></script>
<script type="text/javascript" src="assets/widgets/datatable/datatable-tabletools.js"></script>
<script type="text/javascript">

    /* Datatables basic */

    $(document).ready(function() {
        $('#attendanceModalTable').dataTable();
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

%>


<table class="table table-hover" id="attendanceModalTable">
    <%        for (String yearMonth : yearMonths) {
            ArrayList<Attendance> attendances = UserAttendanceDAO.getAttendancesByYearMonth(yearMonth);
    %>
    <p style="font-size: 14px;">Attendance for <b><%=yearMonth%></b></p> <br>
    <thead>
        <tr>
            <th>NRIC</th>
            <th>Employee</th>
                <%
                    for (Attendance attendance : attendances) {
                        LocalDateTime ldt = attendance.getDate().toLocalDateTime();
                        int d = ldt.getDayOfMonth();
                        String day = d + "";
                        if (d < 10) {
                            day = 0 + day;
                        }
                        out.println("<th style='text-align: center'><button class=\"btn btn-default\"  onclick=\"window.location.href='EditAttendance.jsp?date=" + Converter.convertDateHtml(attendance.getDate()) + "&action=2'\">" + day + "</button></th>");
                    }
                %>
        </tr>
    </thead>
    <%
        for (User employee : employees) {
            String nric = employee.getNric();
    %>
    <tbody>
        <tr>
            <td align="center"><%=nric%></td>
            <td align="center"><%=employee%></td>
            <%
                for (Attendance attendance : attendances) {
                    String employeeAttendance = attendance.getUserAttendance(nric);
                    if (employeeAttendance == null) {
                        employeeAttendance = "NA";
                    }
                    out.println("<td style='text-align: center'>" + employeeAttendance.substring(0, 2) + "</td>");
                }
            %>
        </tr>
    </tbody>
    <%
            }
        }
    %>
</table>

<br>
<b>Pr:</b> Present &nbsp; <b>Ab:</b> Absent &nbsp; <b>La:</b> Late &nbsp; <b>Le:</b> Leave &nbsp; <b>MC:</b> MC &nbsp; <b>NA:</b> Not Available


