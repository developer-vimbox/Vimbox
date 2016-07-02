<%@include file="ValidateLogin.jsp"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Payslips</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/EmployeeFunctions.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
    </head>
    <body onload="payslipsSetup()">
        <h1>Payslips</h1><hr>
        <input type="text" id="payslip_search">
        <button onclick="loadPayslips($('#payslip_search').val())">Search</button>
        <button onclick="fcPayslips()">Fast Create</button>
        <button onclick="location.href = 'CreatePayslip.jsp';">Create New</button>
        <div id="fastCreateModal" class="modal">
            <!-- Modal content -->
            <div class="modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('fastCreateModal')">×</span>
                    <h2>Date Inputs</h2><hr>
                    <table>
                        <tr>
                            <td align="right">Date of Payment :</td>
                            <td><input type="date" id="fc_paymentdate"></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td><button onclick="fgPayslips()">Generate Payslips</button></td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <br><br>
        <div id="payslips_table"></div>

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
    </body>
</html>
