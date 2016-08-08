<%@page import="com.vimbox.database.UserPopulationDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Employee</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/EmployeeFunctions.js"></script>
        <script src="JS/ModalFunctions.js"></script>
    </head>
    <body>
        <%@include file="header.jsp"%>
        <div id="page-content-wrapper">
            <div id="page-content" style="min-height: 7630px;">
                <div class="container">
                    <div id="page-title">
                        <h2>Add Employee</h2> <br>
                    </div>
                    <div class="panel">
                        <div class="panel-body">
                            <h3 class="title-hero">
                                Employee Information
                            </h3> <hr>
                            <div class="form-horizontal">
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
                                        <input type="text" class="form-control" id="user_first_name">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Last Name: </label>
                                    <div class="col-sm-5">
                                        <input type="text" class="form-control" id="user_last_name">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">NRIC: </label>
                                    <div class="col-sm-5">
                                        <div class="input-group mrg15T mrg15B">
                                            <div class="input-group-btn">
                                                <select id="user_nric_first_alphabet" class="form-control" style="width: 57px;">
                                                    <option value="S">S</option>
                                                    <option value="T">T</option>
                                                    <option value="F">F</option>
                                                    <option value="G">G</option>
                                                </select>
                                            </div>
                                            <input type="number" class="form-control" id="user_nric">
                                            <div class="input-group-btn">
                                                <select id="user_nric_last_alphabet" class="form-control" style="width: 57px;">
                                                    <%                                char[] alphabets = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
                                                        for (char alphabet : alphabets) {
                                                            out.println("<option value='" + alphabet + "'>" + alphabet + "</option>");
                                                        }
                                                    %>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Date Joined: </label>
                                    <div class="col-sm-5">
                                        <input class="form-control" type="date" id="user_dj">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Mailing Address: </label>
                                    <div class="col-sm-5">
                                        <input class="form-control" type="text" id="user_madd">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Registered Address: </label>
                                    <div class="col-sm-5">
                                        <input class="form-control" type="text" id="user_radd">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Phone Number: </label>
                                    <div class="col-sm-5">
                                        <input class="form-control" type="number" min="0" id="user_phone">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Fax Number: </label>
                                    <div class="col-sm-5">
                                        <input class="form-control" type="number" min="0" id="user_fax">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Home Number: </label>
                                    <div class="col-sm-5">
                                        <input class="form-control" type="number" min="0" id="user_home">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Department: </label>
                                    <div class="col-sm-5">
                                        <div id="full_time_department" style="display:none">
                                            <select id="user_department" onchange="loadDesignations()" class="form-control">
                                                <option value="">--Select--</option>
                                                <%
                                                    ArrayList<String> fulltimeDepartments = UserPopulationDAO.getFullUserDepartments();
                                                    for (String department : fulltimeDepartments) {
                                                        out.println("<option value='" + department + "'>" + department + "</option>");
                                                    }
                                                %>
                                            </select>
                                        </div>
                                        <div id="part_time_department" style="display:none">
                                            <select id="user_department" onchange="loadDesignations()" class="form-control">
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
                                            <input type="number" min="0" id="user_salary" class="form-control">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <h3 class="title-hero">
                                Emergency Contact
                            </h3> <hr>
                            <div class="form-horizontal">
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Contact Person Name: </label>
                                    <div class="col-sm-5">
                                        <input type="text" id="emergency_name" class="form-control">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Relationship: </label>
                                    <div class="col-sm-5">
                                        <input type="text" id="emergency_relationship" class="form-control">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Contact Number: </label>
                                    <div class="col-sm-5">
                                        <input type="number" min="0" id="emergency_contact" class="form-control">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Office Number: </label>
                                    <div class="col-sm-5">
                                        <input type="number" min="0" id="emergency_office" class="form-control">
                                    </div>
                                </div>
                            </div>
                            <div id="full_time_user_account" style="display:none">
                                <h3 class="title-hero">
                                    User Account Information
                                </h3> <hr>
                                <div class="form-horizontal">
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Email Address: </label>
                                        <div class="col-sm-5">
                                            <input type="text" id="user_username" class="form-control">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Password: </label>
                                        <div class="col-sm-5">
                                            <input type="password" id="user_password" class="form-control">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <h3 class="title-hero">
                                Payment Information
                            </h3> <hr>
                            <div class="form-horizontal">
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Method of Payment: </label>
                                    <div class="col-sm-5">
                                        <select id="user_payment" class="form-control">
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
                                        <input type="text" id="user_bank_name" class="form-control">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Account Name: </label>
                                    <div class="col-sm-5">
                                        <input type="text" id="user_account_name" class="form-control">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Bank Account Number: </label>
                                    <div class="col-sm-5">
                                        <input type="text" id="user_account_no" class="form-control">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label"></label>
                                    <div class="col-sm-5 text-center">
                                        <button data-loading-text="Loading..." class="btn loading-button btn-primary" onclick="createEmployee()">Add Employee</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div> 
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
    </body>
</html>
