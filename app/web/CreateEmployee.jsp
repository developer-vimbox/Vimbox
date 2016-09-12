<%@page import="com.vimbox.database.UserPopulationDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Employee</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.js"></script> 
        <script src="http://malsup.github.com/jquery.form.js"></script> 
        <script src="JS/ModalFunctions.js"></script>
        <script>
            $('#employee_form').ajaxForm({
                dataType: 'json',
                success: function (data) {
                    var modal = document.getElementById("employee_error_modal");
                    var status = document.getElementById("employee_error_status");
                    var message = document.getElementById("employee_error_message");
                    status.innerHTML = data.status;
                    message.innerHTML = data.message;
                    modal.style.display = "block";

                    var radios = document.getElementsByTagName('input');
                    var employeeType;
                    for (var i = 0; i < radios.length; i++) {
                        if (radios[i].type === 'radio' && radios[i].checked) {
                            // get value, set checked flag or do whatever you need to
                            employeeType = radios[i].value;
                        }
                    }
                    
                    if (data.status === "SUCCESS") {
                        if(employeeType === 'Full'){
                            setTimeout(function () {
                                window.location.href = "FullTimeEmployees.jsp";
                            }, 500);
                        }else{
                            setTimeout(function () {
                                window.location.href = "PartTimeEmployees.jsp";
                            }, 500);
                        }
                    }
                },
                error: function (data) {
                    var modal = document.getElementById("employee_error_modal");
                    var status = document.getElementById("employee_error_status");
                    var message = document.getElementById("employee_error_message");
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
        <div id="page-content-wrapper">
            <div id="page-content">
                <div class="container" style="width: 100%;">
                    <div id="page-title">
                        <h2>Add Employee</h2> <br>
                    </div>
                    <div class="panel">
                        <div class="panel-body">
                            <form class="form-horizontal" id="employee_form" action="CreateEmployeeController" method="post" enctype="multipart/form-data">
                                <div class="form-horizontal">
                                    <div class="form-group">
                                        <div class="col-sm-6">
                                            <h3 class="mrg10A">Employee Information </h3>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Employee Type: </label>
                                        <div class="col-sm-5">
                                            <label class="radio-inline">
                                                <input type="radio" name="employeeType" onclick="loadFullTimeDiv()" id="full-time" value="Full">Full-Time 
                                            </label>
                                            <label class="radio-inline">
                                                <input type="radio" name="employeeType" onclick="loadPartTimeDiv()" id="part-time" value="Part">Part-Time
                                            </label>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">First Name: </label>
                                        <div class="col-sm-5">
                                            <input type="text" class="form-control" name="user_first_name">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Last Name: </label>
                                        <div class="col-sm-5">
                                            <input type="text" class="form-control" name="user_last_name">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">NRIC / FIN: </label>
                                        <div class="col-sm-5">
                                            <input type="text" class="form-control" name="user_nric">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Date Joined: </label>
                                        <div class="col-sm-5">
                                            <input class="form-control" type="date" name="user_dj">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Mailing Address: </label>
                                        <div class="col-sm-5">
                                            <input class="form-control" type="text" name="user_madd">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Registered Address: </label>
                                        <div class="col-sm-5">
                                            <input class="form-control" type="text" name="user_radd">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Phone Number: </label>
                                        <div class="col-sm-5">
                                            <input class="form-control" type="number" min="0" name="user_phone">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Fax Number: </label>
                                        <div class="col-sm-5">
                                            <input class="form-control" type="number" min="0" name="user_fax">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Home Number: </label>
                                        <div class="col-sm-5">
                                            <input class="form-control" type="number" min="0" name="user_home">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Driver License (if any): </label>
                                        <div class="col-sm-5">
                                            <input class="form-control" type="file" name="driverLicense">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Department: </label>
                                        <div class="col-sm-5">
                                            <div id="full_time_department" style="display:none">
                                                <select name="fulltime_user_department" id="fulltime_user_department" onchange="loadDesignations('fulltime_user_department')" class="form-control">
                                                    <option value="">--Select--</option>
                                                    <%                                                    ArrayList<String> fulltimeDepartments = UserPopulationDAO.getFullUserDepartments();
                                                        for (String department : fulltimeDepartments) {
                                                            out.println("<option value='" + department + "'>" + department + "</option>");
                                                        }
                                                    %>
                                                </select>
                                            </div>
                                            <div id="part_time_department" style="display:none">
                                                <select name="parttime_user_department" id="parttime_user_department" onchange="loadDesignations('parttime_user_department')" class="form-control">
                                                    <option value="">--Select--</option>
                                                    <%
                                                        ArrayList<String> parttimeDepartments = UserPopulationDAO.getPartUserDepartments();
                                                        for (String department : parttimeDepartments) {
                                                            out.println("<option value='" + department + "'>" + department + "</option>");
                                                        }
                                                    %>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Designation: </label>
                                        <div class="col-sm-5">
                                            <div id="user_designation_div"></div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Basic Salary: </label>
                                        <div class="col-sm-5">
                                            <div class="input-group">
                                                <span class="input-group-addon">$</span>
                                                <input type="number" min="0" name="user_salary" class="form-control">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <hr>
                                <div class="form-horizontal">
                                    <div class="form-group">
                                        <div class="col-sm-6">
                                            <h3 class="mrg10A">Emergency Contact </h3>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Contact Person Name: </label>
                                        <div class="col-sm-5">
                                            <input type="text" name="emergency_name" class="form-control">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Relationship: </label>
                                        <div class="col-sm-5">
                                            <input type="text" name="emergency_relationship" class="form-control">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Contact Number: </label>
                                        <div class="col-sm-5">
                                            <input type="number" min="0" name="emergency_contact" class="form-control">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Office Number: </label>
                                        <div class="col-sm-5">
                                            <input type="number" min="0" name="emergency_office" class="form-control">
                                        </div>
                                    </div>
                                </div>
                                <div id="full_time_user_account" style="display:none">
                                    <hr>
                                    <div class="form-horizontal">
                                        <div class="form-group">
                                            <div class="col-sm-6">
                                                <h3 class="mrg10A">User Account Information </h3>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label">Email Address: </label>
                                            <div class="col-sm-5">
                                                <input type="text" name="user_username" class="form-control">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label">Password: </label>
                                            <div class="col-sm-5">
                                                <input type="password" name="user_password" class="form-control">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <hr>
                                <div class="form-horizontal">
                                    <div class="form-group">
                                        <div class="col-sm-6">
                                            <h3 class="mrg10A">Payment Information </h3>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Method of Payment: </label>
                                        <div class="col-sm-5">
                                            <select name="user_payment" class="form-control">
                                                <%
                                                    ArrayList<String> paymentModes = UserPopulationDAO.getUserPaymentModes();
                                                    for (String paymentMode : paymentModes) {
                                                        out.println("<option value='" + paymentMode + "'>" + paymentMode + "</option>");
                                                    }
                                                %>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Bank Name: </label>
                                        <div class="col-sm-5">
                                            <input type="text" name="user_bank_name" class="form-control">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Account Name: </label>
                                        <div class="col-sm-5">
                                            <input type="text" name="user_account_name" class="form-control">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Bank Account Number: </label>
                                        <div class="col-sm-5">
                                            <input type="text" name="user_account_no" class="form-control">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"></label>
                                        <div class="col-sm-5 text-center">
                                            <button type="submit" data-loading-text="Loading..." class="btn loading-button btn-primary">Add Employee</button>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div> 
        <div id="employee_error_modal" class="modal">
            <div class="modal-content" style="width: 400px;">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('employee_error_modal')">×</span>
                    <center><h2><div id="employee_error_status"></div></h2></center>
                </div>
                <div class="modal-body">
                    <div id="employee_error_message"></div>
                </div>
            </div>
        </div>
    </body>
</html>
