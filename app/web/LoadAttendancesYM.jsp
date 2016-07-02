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

<table width="100%" border="1">
    <col width="50%">
    <col width="50%">

    <tr>
        <th>Month</th>
        <th>Action</th>
    </tr>

    <%
        for (String yearMonth : yearMonths) {
            ArrayList<Attendance> attendances = UserAttendanceDAO.getAttendancesByYearMonth(yearMonth);
    %>
    <tr>
        <td align="center"><%=yearMonth%></td>
        <td align="center">
            <button onclick="viewAttendance()">View</button>
            <div id="view_attendance_modal" class="modal">
                <!-- Modal content -->
                <div class="attendance-modal-content">
                    <div class="modal-body">
                        <span class="close" onclick="closeModal('view_attendance_modal')">×</span>
                        <h2>Attendance for <%=yearMonth%></h2><hr>
                        <table width="100%" border="1">
                            <col width="10%">
                            <col width="10%">

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
                                            out.println("<th>" + day + "</th>");
                                        }
                                    %>
                            </tr>
                            <%
                                for (User employee : employees) {
                                    String nric = employee.getNric();
                            %>
                            <tr>
                                <td align="center"><%=nric%></td>
                                <td align="center"><%=employee%></td>
                                <%
                                    for (Attendance attendance : attendances) {
                                        out.println("<td align='center'>" + attendance.getUserAttendance(nric) + "</td>");
                                    }
                                %>
                            </tr>
                            <%
                                }
                            %>
                        </table>
                        <br>
                        <b>Pr:</b> Present &nbsp; <b>Ab:</b> Absent &nbsp; <b>La:</b> Late &nbsp; <b>Le:</b> Leave &nbsp; <b>MC:</b> MC 
                    </div>
                </div>
            </div>
        </td>
    </tr>
    <%        }
    %>
</table>

