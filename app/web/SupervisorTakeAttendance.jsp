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
                                        MoversAttendance firstM = movers.get(0);
                                        String status = firstM.getStatus();
                                        double duration = firstM.getDuration();
                                        String supervisor = firstM.getSupervisor();
                                        if (!status.equals("Assigned")) {
                                            out.println("<div class='alert alert-success' style='width: 400px;'><button class=\"btn btn-sm btn-default\" onclick=\"window.location.href='SupervisorEditAttendance.jsp'\">Edit Attendance</button> &nbsp; Attendance for today has been taken</div>");
                                        }
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
                                        
                                        if (status.equals("Assigned")) {
                                            for (MoversAttendance m : movers) {
                                                User u = m.getMover();
                                    %>
                                    <tr>
                                        <td><%=u.getNric()%><input type="hidden" name="attendance_nric" value="<%=u.getNric()%>"></td>
                                        <td><%=u.toString()%></td>
                                        <td style="text-align: center"><input class="attendance_radio" type="radio" name="attendance_<%=u.getNric()%>" value="Present" checked></td>
                                        <td style="text-align: center"><input class="attendance_radio" type="radio" name="attendance_<%=u.getNric()%>" value="Absent"></td>
                                        <td style="text-align: right"><input class="attendance_radio" type="radio" name="attendance_<%=u.getNric()%>" value="Late"></td>
                                        <td>
                                            <select name="late_<%=u.getNric()%>_h" id="late_<%=u.getNric()%>_h" disabled>
                                                <%
                                                    for (int i = 1; i <= 9; i++) {
                                                        out.println("<option value='" + i + "'>" + i + "</option>");
                                                    }
                                                %>
                                            </select> H 
                                            <select name="late_<%=u.getNric()%>_m" id="late_<%=u.getNric()%>_m" disabled>
                                                <%
                                                    for (int i = 0; i <= 59; i++) {
                                                        out.println("<option value='" + i + "'>" + i + "</option>");
                                                    }
                                                %>
                                            </select> M
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } else {
                                            for (MoversAttendance m : movers) {
                                                User u = m.getMover();
                                                status = m.getStatus();
                                                duration = m.getDuration();
                                    %>
                                    <tr>
                                        <td><%=u.getNric()%><input type="hidden" name="attendance_nric" value="<%=u.getNric()%>"></td>
                                        <td><%=u.toString()%></td>
                                        <td style="text-align: center"><%if (status.equals("Present")) 
                                                out.println("x");%></td>
                                        <td style="text-align: center"><%if (status.equals("Absent")) 
                                                out.println("x");%></td>
                                        <td style="text-align: right"><%if (status.equals("Late")) 
                                                out.println("x");%></td>
                                        <td>
                                            <%
                                                if (status.equals("Late")){
                                                    int hour = (int) (duration / 60);
                                                    int min = (int) (duration % 60);
                                                    out.println(hour + " hr " + min + " min");
                                                }
                                            %>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        }
                                    %>
                                </table>
                                <%
                                        if (status.equals("Assigned")) {
                                %>
                                <div class='text-center'>
                                    <button type="submit" class="btn btn-primary">Take Attendance</button>
                                </div>
                                <%
                                    }
                                %>
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
