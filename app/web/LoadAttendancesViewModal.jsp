<%@page import="com.vimbox.user.User"%>
<%@page import="com.vimbox.database.UserDAO"%>
<%@page import="org.joda.time.LocalDateTime"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.hr.Attendance"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.UserAttendanceDAO"%>
<%
    String keyword = request.getParameter("keyword");
    ArrayList<User> employees = UserDAO.getFullTimeUsers();
    ArrayList<String> yearMonths = UserAttendanceDAO.getYearMonthByKeyword(keyword);

%>

<table class="table table-hover">
    <%        for (String yearMonth : yearMonths) {
            ArrayList<Attendance> attendances = UserAttendanceDAO.getAttendancesByYearMonth(yearMonth);
    %>


    <h2>Attendance for <%=yearMonth%></h2><hr>

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
                        out.println("<th>" + day + "<br><button class=\"btn btn-default\"  onclick=\"window.location.href='EditAttendance.jsp?date=" + Converter.convertDateHtml(attendance.getDate()) + "&action=2'\">Edit</button></th>");
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
                    out.println("<td align='center'>" + employeeAttendance.substring(0, 2) + "</td>");
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


