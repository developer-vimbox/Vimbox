<%@page import="com.vimbox.database.UserAttendanceDAO"%>
<%@page import="java.util.ArrayList"%>
<%@include file="ValidateLogin.jsp"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Attendances</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/EmployeeFunctions.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
    </head>
    <body onload="attendance_setup()">
        <h1>Attendances</h1><hr><br>
        <input type="text" id="attendance_search" placeholder="YYYY-MM">
        <button onclick="loadAttendances($('#attendance_search').val())">Search</button>
        <button onclick="location.href = 'TakeAttendance.jsp';">Take Attendance</button>
        <br><br>
        <div id="attendance_table">
        </div>
    </body>
</html>
