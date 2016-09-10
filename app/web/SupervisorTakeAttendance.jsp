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
    </head>
    <body>
        <%@include file="header.jsp"%>
        <%            DateTime dt = new DateTime();
            String today = Converter.convertDateHtml(dt);
            String supervisor = user.getNric();
            ArrayList<MoversAttendance> movers = OperationsDAO.getMoverAttendance(supervisor, today);
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
                                %>
                                <form action='CreateMoverAttendanceController' method='post' id='attendance_form'>
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
                                        MoversAttendance firstM = movers.get(0);
                                        String status = firstM.getStatus();
                                        int duration = firstM.getDuration();
                                        if (status.equals("Assigned")) {
                                            for (MoversAttendance m : movers) {
                                                User u = m.getMover();
                                    %>
                                    <tr>
                                        <td><%=u.getNric()%></td>
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
