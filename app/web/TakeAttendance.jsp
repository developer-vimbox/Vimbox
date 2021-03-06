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
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Attendance Taking</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.js"></script> 
        <script src="http://malsup.github.com/jquery.form.js"></script> 
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
    </head>
    <body>
        <%@include file="header.jsp"%>
        <div id="attendance_error_modal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('attendance_error_modal')">×</span>
                    <center><h2><div id="attendance_error_status"></div></h2></center>
                </div>
                <div class="modal-body">
                    <div id="attendance_error_message"></div>
                </div>
            </div>
        </div>
        <%            
            DateTime dt = new DateTime();
            String dtString = Converter.convertDateHtml(dt);
            ArrayList<User> users = UserDAO.getFullTimeUsers();
            HashMap<String, LeaveMC> statuses = UserLeaveDAO.getLeaveMCRecordByDate(dt);
            Attendance attendance = UserAttendanceDAO.getAttendanceByDate(dt);
        %>
        <div id="page-content-wrapper">
            <div id="page-content">

                <div class="container" style="width: 100%;">




                    <div id="page-title">
                        <h2>Attendance Taking for <%=dtString%></h2> <br>
                    </div>


                    <div class="panel">
                        <div class="panel-body">
        <%
            HashMap<String, String> attendance_record = null;
            HashMap<String, Integer> late_record = null;

            if (attendance != null) {
                attendance_record = attendance.getAttendance_record();
                late_record = attendance.getLate_record();
                out.println("<div class='alert alert-success' style='width: 400px;'><button class=\"btn btn-sm btn-default\" onclick=\"window.location.href='EditAttendance.jsp?date=" + dtString + "&action=1'\">Edit Attendance</button> &nbsp; Attendance for today has been taken</div>");
            } else {
                out.println("<form action='CreateAttendanceController' method='post' id='attendance_form'>");
            }
        %>
        <input type="hidden" name="attendance_date" value="<%=dtString%>">
        <table class="table table-hover">
            <thead>
            <tr>
                <th>NRIC</th>
                <th>Employee</th>
                <th>Status</th>
                <th>Duration</th>
                <th style="text-align: center">Present</th>
                <th style="text-align: center">Absent</th>
                <th style="text-align: right">Late</th>
                <th></th>
            </tr>
            </thead>

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
            <tbody>
            <tr>
                <td><%=nric%><input type="hidden" name="attendance_nric" value="<%=nric%>"></td>
                <td><%=employee%></td>
                <td><%=employeeStatus%></td>
                <td><%=employeeDuration%></td>
                <%
                    if (attendance_record != null) {
                        String employeeAttendance = attendance_record.get(nric);
                %>
                    <td style="text-align: center"><%if (employeeAttendance != null && employeeAttendance.equals("Present")) 
                            out.println("x");%></td>
                    <td style="text-align: center"><%if (employeeAttendance != null && employeeAttendance.equals("Absent")) 
                            out.println("x");%></td>
                    <td style="text-align: right"><%if (employeeAttendance != null && employeeAttendance.equals("Late")) 
                            out.println("x");%></td>
                    <td>
                        <%
                            if (employeeAttendance != null && employeeAttendance.equals("Late")){
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
                <td style="text-align: center"><input class="attendance_radio" type="radio" name="attendance_<%=nric%>" value="Present" checked></td>
                <td style="text-align: center"><input class="attendance_radio" type="radio" name="attendance_<%=nric%>" value="Absent"></td>
                <td style="text-align: right"><input class="attendance_radio" type="radio" name="attendance_<%=nric%>" value="Late"></td>
                <td>
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
            </tbody>
            <%
                }
            %>
        </table>
        
        
        <br>
        <%
            if (attendance == null) {
                 out.println("<div class='bg-default text-center'>");
                out.println("<button type=\"submit\" data-loading-text=\"Loading...\"  class=\"btn loading-button btn-primary\">" + "Take Attendance</button></div>");
                out.println("</form>");
            }
        %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
                       
    </body>
</html>
