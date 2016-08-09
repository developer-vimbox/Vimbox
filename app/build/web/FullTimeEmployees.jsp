<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.user.User"%>
<%@page import="com.vimbox.database.UserDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Full Time Employees</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/EmployeeFunctions.js"></script>
        <script src="JS/ModalFunctions.js"></script>
    </head>
    <body onload="fulltime_setup()">
        <%@include file="header.jsp"%>
        <div id="employee_error_modal" class="modal">
            <!-- Modal content -->
            <div class="message-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('employee_error_modal')">×</span>
                    <div id="employee_error_status"></div>
                    <hr>
                    <div id="employee_error_message"></div>
                </div>
            </div>
        </div>
        <div id="edit_employee_modal" class="modal"  style="display:none;">
            <div class="employee-form-modal-content" style="width: 1200px;">
                <div class="modal-body">
                    <div id="employee_content"></div>
                </div>
            </div>
        </div>
        <div id="viewEmployeeModal" class="modal" style="display:none;">
            <!-- Modal content -->
            <div class="viewEmployeeModal">
                <div class="modal-body">
                    <div id="viewEmployeeModal-details"></div>
                </div>
            </div>
        </div>

        <div id="view_leavemc_modal" class="modal">
            <!-- Modal content -->
            <div class="modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('view_leavemc_modal')">×</span>
                    <div id="leavemc_content"></div>
                </div>
            </div>
        </div>

        <div id="page-content-wrapper">
            <div id="page-content">
                <div class="container">
                    <div id="page-title">
                        <h2>Full Time Employees</h2>
                    </div>
                    <div class="panel">
                        <div class="panel-body">
                            <div class="form-horizontal">
                                <div class="form-group">
                                    <div class="col-sm-4">
                                        <div class="input-group bootstrap-touchspin"><span class="input-group-addon bootstrap-touchspin-prefix" style="display: none;"></span>
                                            <input type="text" id="employee_search" placeholder="Enter employee name" class="form-control" style="width: 400px;color:black;">
                                            <span class="input-group-btn">
                                                <button class="btn btn-default  bootstrap-touchspin-up" type="button" onclick="loadEmployees($('#employee_search').val(), 'full-time')">Search</button>
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
