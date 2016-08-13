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

<table class="table table-hover">
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

