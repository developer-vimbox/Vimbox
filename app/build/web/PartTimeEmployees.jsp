<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.user.User"%>
<%@page import="com.vimbox.database.UserDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Part Time Employees</title>
    </head>
    <body onload="parttime_setup()">
        <%@include file="header.jsp"%>
        <script src="http://malsup.github.com/jquery.form.js"></script> 
        <script src="JS/ModalFunctions.js"></script>
        <script src="JS/EmployeeFunctions.js"></script>
        <div id="page-content-wrapper">
            <div id="page-content">
                <div class="container" style="width: 100%">
                    <div id="page-title">
                        <h2>Part Time Employees</h2>
                    </div>
                    <div class="panel">
                        <div class="panel-body">
                            <div class="form-horizontal">
                                <div class="form-group">
                                    <div class="col-sm-4">
                                        <div class="input-group bootstrap-touchspin"><span class="input-group-addon bootstrap-touchspin-prefix" style="display: none;"></span>
                                            <input type="text" id="employee_search" placeholder="Enter employee name" class="form-control" style="width: 400px;color:black;">
                                            <span class="input-group-btn">
                                                <button class="btn btn-default  bootstrap-touchspin-up" type="button" onclick="loadEmployees($('#employee_search').val(), 'part-time')">Search</button>
                                                <button class="btn btn-default  bootstrap-touchspin-up" type="button" onclick="location.href = 'CreateEmployee.jsp';">Add New</button>
                                            </span>
                                        </div>
                                    </div>

                                </div>
                                <br><br>
                                <div id="employees_table"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div> 
    </body>
</html>
