<%@include file="ValidateLogin.jsp"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Leave / MC</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/EmployeeFunctions.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
    </head>
    <body onload="leaveMc_setup()">
        <h1>Leave Record</h1><hr><br>
        <input type="text" id="leave_mc_search">
        <button onclick="loadLeaveMCs($('#leave_mc_search').val())">Search</button>
        <button onclick="location.href = 'CreateLeaveMC.jsp';">Add New</button>
        <br><br>
        <div id="leave_mc_table"></div>
    </body>
</html>
