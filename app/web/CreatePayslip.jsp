<%@page import="com.vimbox.database.UserPopulationDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.UserDAO"%>
<%@include file="ValidateLogin.jsp"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Payslip</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/EmployeeFunctions.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
        <style>
            table td{
                padding:5px;
            }
        </style>
    </head>
    <body>
        <h1>Add Payslip</h1>
        <hr>
        <fieldset>
            <legend>Payslip Information</legend>
            <table>
                <tr>
                    <td align="right">Employee :</td>
                    <td>
                        <select id="payslip_employee">
                            <option value="">---SELECT---</option>
                            <%                                ArrayList<User> employees = UserDAO.getFullTimeUsers();
                                for (User employee : employees) {
                                    out.println("<option value='" + employee.getNric() + "'>" + employee + "</option>");
                                }
                            %>
                        </select>
                        <input type='hidden' id='original_basic'>
                    </td>
                </tr>
                <tr>
                    <td align="right">Start Date :</td>
                    <td>
                        <input type="date" id="payslip_startDate"> &nbsp; End date :&nbsp;<input type="date" id="payslip_endDate">
                        &nbsp; <button onclick="resetDates()">Reset Dates</button>
                        <div id="payslip_error_modal" class="modal">
                            <!-- Modal content -->
                            <div class="message-modal-content">
                                <div class="modal-body">
                                    <span class="close" onclick="closeModal('payslip_error_modal')">×</span>
                                    <div id="payslip_error_status"></div>
                                    <hr>
                                    <div id="payslip_error_message"></div>
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td align="right">Payment Date :</td>
                    <td>
                        <input type="date" id="payslip_paymentDate">
                    </td>
                </tr>
                <tr>
                    <td align="right">Mode of Payment :</td>
                    <td>
                        <select id="payslip_paymentMode">
                            <option value="">---SELECT---</option>
                            <%
                                ArrayList<String> paymentModes = UserPopulationDAO.getUserPaymentModes();
                                for (String paymentMode : paymentModes) {
                                    out.println("<option value='" + paymentMode + "'>" + paymentMode + "</option>");
                                }
                            %>
                        </select>
                    </td>
                </tr>
            </table>
        </fieldset>
        <br>
        <fieldset>
            <legend>Payment Breakdown</legend>
            <table>
                <col width='500px'>
                <tr>
                    <td>
                        <table width='100%' border='1'>
                            <col width='50%'>
                            <tr style="background-color:RoyalBlue">
                                <td colspan="2" align="center"><b>Basic & Allowance</b></td>
                            </tr>
                            <tr>
                                <td align="right" style="background-color:lightgrey">(A) Basic Pay :</td>
                                <td>
                                    $ <label id="payslip_basic">0.00</label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" style="background-color:lightgrey">(B) Total Allowances :</td>
                                <td>
                                    $ <label id="payslip_allowance">0.00</label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan='2' align="center">Breakdown <button onclick="addPayslipBDEntry('payslip_abd')">+</button></td>
                            </tr>
                            <tr>
                                <td colspan='2'>
                                    <table id="payslip_abd" valign="top" style="width:100%;" border="1">
                                        <col width="50%">
                                        <col width="40%">
                                        <col width="10%">
                                        <tbody>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr style="background-color:RoyalBlue">
                                <td colspan="2" align="center"><b>Deduction</b></td>
                            </tr>
                            <tr>
                                <td align="right" style="background-color:lightgrey">(C) Total Deduction :</td>
                                <td>
                                    $ <label id="payslip_deduction">0.00</label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan='2' align="center" onclick="addPayslipBDEntry('payslip_dbd')">Breakdown <button>+</button></td>
                            </tr>
                            <tr>
                                <td colspan='2'>
                                    <table id="payslip_dbd" valign="top" style="width:100%;" border="1">
                                        <col width="50%">
                                        <col width="40%">
                                        <col width="10%">
                                        <tbody>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr style="background-color:RoyalBlue">
                                <td colspan="2" align="center"><b>Overtime & Additional</b></td>
                            </tr>
                            <tr>
                                <td align="right">Overtime Hours Worked :</td>
                                <td>
                                    <input type="number" id="payslip_ot" min='0' step='0.01' value='0'>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Overtime Rate :</td>
                                <td>
                                    $ <select id='payslip_otRate'>
                                        <%
                                            for (int i = 1; i <= 100; i++) {
                                                out.println("<option value='" + i + "'>" + i + "</option>");
                                            }
                                        %>
                                    </select> / hr
                                </td>
                            </tr>
                            <tr>
                                <td align="right" style="background-color:lightgrey">(D) Total Overtime Pay :</td>
                                <td>
                                    $ <label id="payslip_overtime">0.00</label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" style="background-color:lightgrey">(E) Other Additional Payments :</td>
                                <td>
                                    $ <label id="payslip_additional">0.00</label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan='2' align="center">Breakdown <button onclick="addPayslipBDEntry('payslip_apbd')">+</button></td>
                            </tr>
                            <tr>
                                <td colspan='2'>
                                    <table id="payslip_apbd" valign="top" style="width:100%;" border="1">
                                        <col width="50%">
                                        <col width="40%">
                                        <col width="10%">
                                        <tbody>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr style="background-color:RoyalBlue">
                                <td colspan="2" align="center"><b>Total Pay</b></td>
                            </tr>
                            <tr>
                                <td align="right" style="background-color:lightgrey">Net Pay (A+B-C+D+E) :</td>
                                <td>
                                    $ <label id="payslip_netpay">0.00</label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" style="background-color:lightgrey">Employer's CPF Contribution :</td>
                                <td>
                                    $ <input type="number" id="payslip_employerCpf" step="0.01" value='0.00'>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </fieldset>
        <br>
        <button onclick="createPayslip()">Create Payslip</button>
    </body>
</html>
