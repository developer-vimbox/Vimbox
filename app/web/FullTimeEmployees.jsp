<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.user.User"%>
<%@page import="com.vimbox.database.UserDAO"%>
<%@include file="ValidateLogin.jsp"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Full Time Employees</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/EmployeeFunctions.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
    </head>
    <body onload="fulltime_setup()">
        <h1>Full Time Employees</h1><hr><br>
        <input type="text" id="employee_search">
        <button onclick="loadEmployees($('#employee_search').val(), 'full-time')">Search</button>
        <button onclick="location.href = 'CreateEmployee.jsp';">Add New</button>
        <br><br>
        <div id="employees_table"></div>
    </body>
</html>
