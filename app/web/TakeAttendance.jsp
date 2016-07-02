<%@page import="com.vimbox.hr.LeaveMC"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.vimbox.database.UserLeaveDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.UserDAO"%>
<%@page import="com.vimbox.hr.Attendance"%>
<%@page import="com.vimbox.database.UserAttendanceDAO"%>
<%@page import="java.util.Date"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="org.joda.time.DateTime"%>
<%@include file="ValidateLogin.jsp"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Attendance Taking</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.js"></script> 
        <script src="http://malsup.github.com/jquery.form.js"></script> 
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
    </head>
    <body>
        <%            
            DateTime dt = new DateTime();
            String dtString = Converter.convertDateHtml(dt);
            ArrayList<User> users = UserDAO.getFullTimeUsers();
            HashMap<String, LeaveMC> statuses = UserLeaveDAO.getLeaveMCRecordByDate(dt);
            Attendance attendance = UserAttendanceDAO.getAttendanceByDate(dt);
        %>
        <h1>Attendance Taking for <%=dtString%></h1><hr><br>
        <%
            HashMap<String, String> attendance_record = null;
            HashMap<String, Double> late_record = null;

            if (attendance != null) {
                attendance_record = attendance.getAttendance_record();
                late_record = attendance.getLate_record();
                out.println("Attendance for today has been taken. <button onclick=\"window.location.href='EditAttendance.jsp?date=" + dtString + "&action=1'\">Edit</button> <br><br>");
            } else {
                out.println("<form action='CreateAttendanceController' method='post' id='attendance_form'>");
            }
        %>
        <input type="hidden" name="attendance_date" value="<%=dtString%>">
        <table width='100%' border='1'>
            <col width='20%'>
            <col width='20%'>
            <col width='20%'>
            <col width='20%'>
            <col width='4%'>
            <col width='4%'>
            <col width='4%'>
            <col width='8%'>

            <tr>
                <th>NRIC</th>
                <th>Employee</th>
                <th>Status</th>
                <th>Duration</th>
                <th>Present</th>
                <th>Absent</th>
                <th colspan='2'>Late</th>
            </tr>

            <%
                for (User employee : users) {
                    String nric = employee.getNric();
                    LeaveMC status = statuses.get(nric);
                    String employeeStatus = "";
                    String employeeDuration = "";

                    if (status != null) {
                        employeeStatus = status.getLeaveName();
                        employeeDuration = status.getTimeString();
                    }
            %>
            <tr>
                <td align='center'><%=nric%><input type="hidden" name="attendance_nric" value="<%=nric%>"</td>
                <td align='center'><%=employee%></td>
                <td align='center'><%=employeeStatus%></td>
                <td align='center'><%=employeeDuration%></td>
                <%
                    if (attendance_record != null) {
                        String employeeAttendance = attendance_record.get(nric);
                %>
                    <td align='center'><%if (employeeAttendance.equals("Present")) 
                            out.println("x");%></td>
                    <td align='center'><%if (employeeAttendance.equals("Absent")) 
                            out.println("x");%></td>
                    <td align='center'><%if (employeeAttendance.equals("Late")) 
                            out.println("x");%></td>
                    <td align='center'>
                        <%
                            if (employeeAttendance.equals("Late")){
                                double totalMinutes = late_record.get(nric);
                                int hour = (int) (totalMinutes / 60);
                                int min = (int) (totalMinutes % 60);
                                out.println(hour + " hr " + min + " min");
                            }
                        %>
                    </td>
                    <%
                    } else if (!employeeDuration.matches("0900 - 1800|0830 - 1730")) {
                    %>
                <td align='center'><input class="attendance_radio" type="radio" name="attendance_<%=nric%>" value="Present" checked></td>
                <td align='center'><input class="attendance_radio" type="radio" name="attendance_<%=nric%>" value="Absent"></td>
                <td align='center'><input class="attendance_radio" type="radio" name="attendance_<%=nric%>" value="Late"></td>
                <td align='center'>
                    <select name="late_<%=nric%>_h" id="late_<%=nric%>_h" disabled>
                        <%
                            for (int i = 1; i <= 9; i++) {
                                out.println("<option value='" + i + "'>" + i + "</option>");
                            }
                        %>
                    </select> H 
                    <select name="late_<%=nric%>_m" id="late_<%=nric%>_m" disabled>
                        <%
                            for (int i = 0; i <= 59; i++) {
                                out.println("<option value='" + i + "'>" + i + "</option>");
                            }
                        %>
                    </select> M
                </td>
                <%
                } else {
                %>
                <td><input type="hidden" name="attendance_<%=nric%>" value="<%=employeeStatus%>"></td>
                <td></td>
                <td></td>
                <td></td>
                    <%
                        }
                    %>
            </tr>
            <%
                }
            %>
        </table>
        <div id="attendance_error_modal" class="modal">
            <!-- Modal content -->
            <div class="message-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('leave_error_modal')">×</span>
                    <div id="attendance_error_status"></div>
                    <hr>
                    <div id="attendance_error_message"></div>
                </div>
            </div>
        </div>
        <br>
        <%
            if (attendance == null) {
                out.println("<input type='submit' value='Take Attendance'/>");
                out.println("</form>");
            }
        %>
        <script>
            $('#attendance_form').ajaxForm({
                dataType: 'json',
                success: function (data) {
                    var modal = document.getElementById("attendance_error_modal");
                    var status = document.getElementById("attendance_error_status");
                    var message = document.getElementById("attendance_error_message");
                    status.innerHTML = data.status;
                    message.innerHTML = data.message;
                    modal.style.display = "block";

                    if (data.status === "SUCCESS") {
                        setTimeout(function () {
                            location.reload()
                        }, 500);
                    }
                },
                error: function (data) {
                    var modal = document.getElementById("attendance_error_modal");
                    var status = document.getElementById("attendance_error_status");
                    var message = document.getElementById("attendance_error_message");
                    status.innerHTML = "ERROR";
                    message.innerHTML = data;
                    modal.style.display = "block";
                }
            });
        </script>
        <script src="JS/EmployeeFunctions.js"></script>
    </body>
</html>
