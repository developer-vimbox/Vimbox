<%@page import="com.vimbox.database.UserLeaveDAO"%>
<%@page import="com.vimbox.hr.LeaveMC"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.vimbox.database.UserDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.UserAttendanceDAO"%>
<%@page import="org.joda.time.format.DateTimeFormatter"%>
<%@page import="org.joda.time.format.DateTimeFormat"%>
<%@page import="com.vimbox.hr.Attendance"%>
<%@include file="ValidateLogin.jsp"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Attendance</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.js"></script> 
        <script src="http://malsup.github.com/jquery.form.js"></script> 
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
    </head>
    <body>
        <%            
            String action = request.getParameter("action");
            String date = request.getParameter("date");
            DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd");
            Attendance attendance = null;
            ArrayList<User> users = new ArrayList<User>();
            HashMap<String, LeaveMC> statuses = null;
            HashMap<String, String> attendance_record = null;
            HashMap<String, Integer> late_record = null;
            
            if (date == null || date.trim().isEmpty()) {
                response.sendRedirect("TakeAttendance.jsp");
                return;
            } else {
                attendance = UserAttendanceDAO.getAttendanceByDate(dtf.parseDateTime(date));
                if(attendance == null){
                    response.sendRedirect("TakeAttendance.jsp");
                    return;
                }
                statuses = UserLeaveDAO.getLeaveMCRecordByDate(dtf.parseDateTime(date));
                attendance_record = attendance.getAttendance_record();
                late_record = attendance.getLate_record();
                ArrayList<String> userStrings = attendance.getUsers();
                for(String userString: userStrings){
                    users.add(UserDAO.getUserByNRIC(userString));
                }
            }
        %>
        <h1>Edit Attendance for <%=date%></h1><hr><br>
        <form action='EditAttendanceController' method='post' id='attendance_form'>
            <input type="hidden" name="attendance_date" value="<%=date%>">
            <input type="hidden" name="attendance_action" value="<%=action%>">
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
                        if (!employeeDuration.matches("0900 - 1800|0830 - 1730")) {
                            String employeeAttendance = attendance_record.get(nric);
                    %>
                    <td align='center'><input class="attendance_radio" type="radio" name="attendance_<%=nric%>" value="Present" <%if (employeeAttendance.equals("Present")) out.println("checked");%>></td>
                    <td align='center'><input class="attendance_radio" type="radio" name="attendance_<%=nric%>" value="Absent" <%if (employeeAttendance.equals("Absent")) out.println("checked");%>></td>
                    <td align='center'><input class="attendance_radio" type="radio" name="attendance_<%=nric%>" value="Late" <%if (employeeAttendance.equals("Late")) out.println("checked");%>></td>
                    <td align='center'>
                        <select name="late_<%=nric%>_h" id="late_<%=nric%>_h" <%if (!employeeAttendance.equals("Late")) out.println("disabled");%>>
                            <%
                                int hour = 1;
                                int min = 0;
                                if (employeeAttendance.equals("Late")) {
                                    double totalMinutes = late_record.get(nric);
                                    hour = (int) (totalMinutes / 60);
                                    min = (int) (totalMinutes % 60);
                                }
                                
                                for (int i = 1; i <= 9; i++) {
                                    if(hour == i){
                                        out.println("<option value='" + i + "' selected>" + i + "</option>");
                                    }else{
                                        out.println("<option value='" + i + "'>" + i + "</option>");
                                    }
                                }
                            %>
                        </select> H 
                        <select name="late_<%=nric%>_m" id="late_<%=nric%>_m" <%if (!employeeAttendance.equals("Late")) out.println("disabled");%>>
                            <%
                                for (int i = 0; i <= 59; i++) {
                                    if(min == i){
                                        out.println("<option value='" + i + "' selected>" + i + "</option>");
                                    }else{
                                        out.println("<option value='" + i + "'>" + i + "</option>");
                                    }
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
            <br>
            <input type='submit' value='Edit Attendance'/>
        </form>
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
                        if(data.action === "1"){
                            setTimeout(function () {
                                window.location.href = "TakeAttendance.jsp"
                            }, 1000);
                        }else{
                            setTimeout(function () {
                                window.location.href = "ViewAttendance.jsp"
                            }, 1000);
                        }
                        
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
    </form>
</body>
</html>
