<%@page import="com.vimbox.database.UserPopulationDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.UserDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Payslip</title>
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
                        <h2>Add Payslip</h2>
                    </div>
                    <div class="panel">
                        <div class="panel-body">
                            <h3 class="title-hero">
                                Payslip Information
                            </h3> <hr>
                            <div class="form-horizontal">
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Employee: </label>
                                    <div class="col-sm-5">
                                        <select id="payslip_employee" class="form-control">
                                            <option value="">---SELECT---</option>
                                            <%                                ArrayList<User> employees = UserDAO.getFullTimeUsers();
                                                for (User employee : employees) {
                                                    out.println("<option value='" + employee.getNric() + "'>" + employee + "</option>");
                                                }
                                            %>
                                        </select>
                                        <input type='hidden' id='original_basic'>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Start Date: </label>
                                    <div class="col-sm-5">
                                        <input type="date" id="payslip_startDate" class="form-control">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">End Date: </label>
                                    <div class="col-sm-5">
                                        <input type="date" id="payslip_endDate" class="form-control">
                                    </div>
                                    <div class="col-sm-2">
                                        <button onclick="resetDates()" class="btn btn-default">Reset Dates</button>
                                    </div>
                                </div>
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
                            </div>
                            <h3 class="title-hero">
                                Payslip Information
                            </h3> <hr>
                            <div class="form-horizontal">
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Payment Date: </label>
                                    <div class="col-sm-5">
                                        <input class="form-control" type="date" id="payslip_paymentDate">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Mode of Payment: </label>
                                    <div class="col-sm-5">
                                        <select id="payslip_paymentMode" class="form-control">
                                            <option value="">---SELECT---</option>
                                            <%
                                                ArrayList<String> paymentModes = UserPopulationDAO.getUserPaymentModes();
                                                for (String paymentMode : paymentModes) {
                                                    out.println("<option value='" + paymentMode + "'>" + paymentMode + "</option>");
                                                }
                                            %>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <h3 class="title-hero">
                                Payment Breakdown
                            </h3> <hr>
                            <div class="form-horizontal">
                                <div class="form-group">
                                    <label class="col-sm-2 control-label"></label>
                                    <div class="col-sm-6">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td>
                                                    <table class="table">
                                                        <col width="50%">
                                                        <tr>
                                                            <th colspan="2" align="center"><b>Basic & Allowance</b></th>
                                                        </tr>
                                                        <tr>
                                                            <td align="right"><b>(A) Basic Pay :</b></td>
                                                            <td>
                                                                $ <label id="payslip_basic">0.00</label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="right"><b>(B) Total Allowances :</b></td>
                                                            <td>
                                                                $ <label id="payslip_allowance">0.00</label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan='2' align="center"><button onclick="addPayslipBDEntry('payslip_abd')" class="btn btn-default">Add Breakdown</button></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan='2'>
                                                                <table id="payslip_abd" valign="top" style="width:100%;">
                                                                    <col width="50%">
                                                                    <col width="40%">
                                                                    <col width="10%">
                                                                    <tbody>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th colspan="2" align="center"><b>Deduction</b></th>
                                                        </tr>
                                                        <tr>
                                                            <td align="right"><b>(C) Total Deduction :</b></td>
                                                            <td>
                                                                $ <label id="payslip_deduction">0.00</label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan='2' align="center"><button onclick="addPayslipBDEntry('payslip_dbd')" class="btn btn-default">Add Breakdown</button></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan='2'>
                                                                <table id="payslip_dbd" valign="top" style="width:100%;">
                                                                    <col width="50%">
                                                                    <col width="40%">
                                                                    <col width="10%">
                                                                    <tbody>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th colspan="2" align="center"><b>Overtime & Additional</b></th>
                                                        </tr>
                                                        <tr>
                                                            <td align="right"><b>Overtime Hours Worked :</b></td>
                                                            <td>
                                                                <input type="number" class="form-control" id="payslip_ot" min='0' step='0.01' value='0'>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="right"><b>Overtime Rate :</b></td>
                                                            <td>
                                                                <div class="input-group">
                                                                    <span class="input-group-addon">$</span>
                                                                    <select id='payslip_otRate' class="form-control">
                                                                        <%
                                                                            for (int i = 1; i <= 100; i++) {
                                                                                out.println("<option value='" + i + "'>" + i + "</option>");
                                                                            }
                                                                        %>
                                                                    </select>
                                                                    <span class="input-group-addon"> / Hr</span>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="right"><b>(D) Total Overtime Pay :</b></td>
                                                            <td>
                                                                $ <label id="payslip_overtime">0.00</label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="right"><b>(E) Other Additional Payments :</b></td>
                                                            <td>
                                                                $ <label id="payslip_additional">0.00</label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan='2' align="center"><button onclick="addPayslipBDEntry('payslip_apbd')" class="btn btn-default">Add Breakdown</button></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan='2'>
                                                                <table id="payslip_apbd" valign="top" style="width:100%;">
                                                                    <col width="50%">
                                                                    <col width="40%">
                                                                    <col width="10%">
                                                                    <tbody>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th colspan="2" align="center"><b>Total Pay</b></th>
                                                        </tr>
                                                        <tr>
                                                            <td align="right"><b>Net Pay (A+B-C+D+E) :</b></td>
                                                            <td>
                                                                $ <label id="payslip_netpay">0.00</label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="right"><b>Employer's CPF Contribution :</b></td>
                                                            <td>
                                                                <div class="input-group">
                                                                    <span class="input-group-addon">$</span>
                                                                    <input type="number" class="form-control" id="payslip_employerCpf" step="0.01" value='0.00'>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label"></label>
                                    <div class="col-sm-6 text-center">
                                        <button data-loading-text="Loading..." class="btn loading-button btn-primary" onclick="createPayslip()">Create Payslip</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div> 
    </body> 
</html>
