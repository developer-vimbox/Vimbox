<%@page import="com.vimbox.database.UserPopulationDAO"%>
<%@page import="java.util.ArrayList"%>
<%@include file="ValidateLogin.jsp"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Employee</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/EmployeeFunctions.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
    </head>
    <body>
        <h1>Add Employee</h1>
        <hr>
        <input type="radio" name="employeeType" onclick="loadFullTimeDiv()" id="full-time" value="Full">Full-Time
        <input type="radio" name="employeeType" onclick="loadPartTimeDiv()" id="part-time" value="Part">Part-Time 
        <fieldset>
            <legend>Employee Information</legend>
            <table width="100%">
                <col width="200">
                <tr>
                    <td align="right"><b>First Name :</b></td>
                    <td><input type="text" id="user_first_name"></td>
                </tr>
                <tr>
                    <td align="right"><b>Last Name :</b></td>
                    <td><input type="text" id="user_last_name"></td>
                </tr>
                <tr>
                    <td align="right"><b>NRIC :</b></td>
                    <td>
                        <select id="user_nric_first_alphabet">
                            <option value="S">S</option>
                            <option value="T">T</option>
                            <option value="F">F</option>
                            <option value="G">G</option>
                        </select>&nbsp;
                        <input type="number" id="user_nric">&nbsp;
                        <select id="user_nric_last_alphabet">
                            <%
                                char[] alphabets = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
                                for (char alphabet : alphabets) {
                                    out.println("<option value='" + alphabet + "'>" + alphabet + "</option>");
                                }
                            %>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td align="right"><b>Date Joined :</b></td>
                    <td><input type="date" id="user_dj"></td>
                </tr>
                <tr>
                    <td align="right"><b>Mailing Address :</b></td>
                    <td>
                        <input type="text" id="user_madd">
                    </td>
                </tr>
                <tr>
                    <td align="right"><b>Registered Address :</b><br>(if different from above)</td>
                    <td>
                        <input type="text" id="user_radd">
                    </td>
                </tr>
                <tr>
                    <td align="right"><b>Phone Number :</b></td>
                    <td><input type="number" min="0" id="user_phone"></td>
                </tr>
                <tr>
                    <td align="right"><b>Fax Number :</b></td>
                    <td><input type="number" min="0" id="user_fax"></td>
                </tr>
                <tr>
                    <td align="right"><b>Home Number :</b></td>
                    <td><input type="number" min="0" id="user_home"></td>
                </tr>
                <tr>
                    <td align="right"><b>Department :</b></td>
                    <td>
                        <div id="full_time_department" style="display:none">
                            <select id="user_department" onchange="loadDesignations()">
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
                            <select id="user_department" onchange="loadDesignations()">
                                <option value="">--Select--</option>
                                <%
                                    ArrayList<String> parttimeDepartments = UserPopulationDAO.getPartUserDepartments();
                                    for (String department : parttimeDepartments) {
                                        out.println("<option value='" + department + "'>" + department + "</option>");
                                    }
                                %>
                            </select>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td align="right"><b>Designation :</b></td>
                    <td><div id="user_designation_div"></div></td>
                </tr>
                <tr>
                    <td align="right"><b>Basic Salary :</b></td>
                    <td>$ <input type="number" min="0" id="user_salary"></td>
                </tr>
            </table>
        </fieldset>
        <br>
        <fieldset>
            <legend>Emergency Contact</legend>
            <table width="100%">
                <col width="200">
                <tr>
                    <td align="right"><b>Contact Person Name :</b></td>
                    <td><input type="text" id="emergency_name"></td>
                </tr>
                <tr>
                    <td align="right"><b>Relationship :</b></td>
                    <td><input type="text" id="emergency_relationship"></td>
                </tr>
                <tr>
                    <td align="right"><b>Contact Number :</b></td>
                    <td><input type="number" min="0" id="emergency_contact"></td>
                </tr>
                <tr>
                    <td align="right"><b>Office Number :</b></td>
                    <td><input type="number" min="0" id="emergency_office"></td>
                </tr>
            </table>
        </fieldset>
        <br>
        <div id="full_time_user_account" style="display:none">
            <fieldset>
                <legend>User Account Information</legend>
                <table width="100%">
                    <col width="200">
                    <tr>
                        <td align="right"><b>Email Address :</b></td>
                        <td><input type="text" id="user_username"></td>
                    </tr>
                    <tr>
                        <td align="right"><b>Password :</b></td>
                        <td><input type="password" id="user_password"></td>
                    </tr>
                </table>
            </fieldset>
            <br>
        </div>
        <fieldset>
            <legend>Payment Information</legend>
            <table width="100%">
                <col width="200">
                <tr>
                    <td align="right"><b>Method of payment :</b></td>
                    <td>
                        <select id="user_payment">
                            <%
                                ArrayList<String> paymentModes = UserPopulationDAO.getUserPaymentModes();
                                for (String paymentMode : paymentModes) {
                                    out.println("<option value='" + paymentMode + "'>" + paymentMode + "</option>");
                                }
                            %>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td align="right"><b>Bank Name :</b></td>
                    <td><input type="text" id="user_bank_name"></td>
                </tr>
                <tr>
                    <td align="right"><b>Account Name :</b></td>
                    <td><input type="text" id="user_account_name"></td>
                </tr>
                <tr>
                    <td align="right"><b>Bank Account Number :</b></td>
                    <td><input type="text" id="user_account_no"></td>
                </tr>
            </table>
        </fieldset>
        <br>
        <button onclick="createEmployee()">Add Employee</button>

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
