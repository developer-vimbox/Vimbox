<%@page import="com.vimbox.operations.MoversAttendance"%>
<%@page import="com.vimbox.database.OperationsDAO"%>
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
        <title>Supervisor Attendance Taking</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.js"></script> 
        <script src="http://malsup.github.com/jquery.form.js"></script> 
        <script src="JS/OperationFunctions.js"></script>
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
                            location.href = 'SupervisorTakeAttendance.jsp';
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
    </head>
    <body>
        <%@include file="header.jsp"%>
        <div id="attendance_error_modal" class="modal">
            <div class="modal-content" style="width: 400px;">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('attendance_error_modal')">×</span>
                    <center><h2><div id="attendance_error_status"></div></h2></center>
                </div>
                <div class="modal-body">
                    <div id="attendance_error_message"></div>
                </div>
            </div>
        </div>
        <%            DateTime dt = new DateTime();
            String today = Converter.convertDateHtml(dt);
            ArrayList<MoversAttendance> movers = OperationsDAO.getMoverAttendances(today);
        %>
        <div id="page-content-wrapper">
            <div id="page-content">
                <div class="container">
                    <div id="page-title">
                        <h2>Supervisor Attendance Taking for <%=today%></h2> <br>
                        <div class="panel">
                            <div class="panel-body">
                                <%
                                    if (movers.isEmpty()) {
                                        out.println("No movers assigned for today.");
                                    } else {
                                        String supervisor = movers.get(0).getSupervisor();
                                %>
                                <form action='CreateMoverAttendanceController' method='post' id='attendance_form'>
                                    <input type="hidden" name="today" value="<%=today%>">
                                    <input type="hidden" name="supervisor" value="<%=supervisor%>">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Mover's NRIC</th>
                                            <th>Mover's Name</th>
                                            <th style="text-align: center">Present</th>
                                            <th style="text-align: center">Absent</th>
                                            <th style="text-align: right">Late</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <%
                                        String status = "";
                                        double duration = 0;
                                        String nric = "";
                                            for (MoversAttendance m : movers) {
                                                User u = m.getMover();
                                                nric = u.getNric();
                                                status = m.getStatus();
                                                duration = m.getDuration();
                                    %>
                                    <tr>
                                        <td><%=nric%><input type="hidden" name="attendance_nric" value="<%=nric%>"></td>
                                        <td><%=u.toString()%></td>
                                        <td style="text-align: center"><input class="attendance_radio" type="radio" name="attendance_<%=nric%>" value="Present" <%if (status.equals("Present")) {
                                                    out.println("checked");
                                                }%>></td>
                                            <td style="text-align: center"><input class="attendance_radio" type="radio" name="attendance_<%=nric%>" value="Absent" <%if (status.equals("Absent")) {
                                                    out.println("checked");
                                                }%>></td>
                                            <td style="text-align: right"><input class="attendance_radio" type="radio" name="attendance_<%=nric%>" value="Late" <%if (status.equals("Late")) {
                                                    out.println("checked");
                                                }%>></td>
                                            <td>
                                                    <select name="late_<%=nric%>_h" id="late_<%=nric%>_h" <%if (!status.equals("Late"))out.println("disabled");%>>
                                                    
                                                    <%
                                                        int hour = 1;
                                                        int min = 0;
                                                        if (status.equals("Late")) {
                                                            hour = (int) (duration / 60);
                                                            min = (int) (duration % 60);
                                                        }

                                                        for (int i = 1; i <= 9; i++) {
                                                            if (hour == i) {
                                                                out.println("<option value='" + i + "' selected>" + i + "</option>");
                                                            } else {
                                                                out.println("<option value='" + i + "'>" + i + "</option>");
                                                            }
                                                        }
                                                    %>
                                                </select> H 
                                                        <select name="late_<%=nric%>_m" id="late_<%=nric%>_m" <%if(!status.equals("Late"))out.println("disabled");%>> 
                                                   
                                                    <%
                                                        for (int i = 0; i <= 59; i++) {
                                                            if (min == i) {
                                                                out.println("<option value='" + i + "' selected>" + i + "</option>");
                                                            } else {
                                                                out.println("<option value='" + i + "'>" + i + "</option>");
                                                            }
                                                        }
                                                    %>
                                                </select> M
                                            </td>
                                    <%
                                            }
                                    %>
                                </table>
                                <div class='text-center'>
                                    <button type="submit" class="btn btn-primary">Edit Attendance</button>
                                </div>
                                </form>
                                <%
                                    }
                                %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>

