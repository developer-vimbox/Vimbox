<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Payslips</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/EmployeeFunctions.js"></script>
        <script src="JS/ModalFunctions.js"></script>
    </head>
    <body onload="payslipsSetup()">
        <%@include file="header.jsp"%>

        <div class="modal fade bs-example-modal-lg" id="edit_payslip_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog" style="width: 900px;">
                <div class="modal-content" style="width: 900px;">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h3>Edit Payslip</h3>
                    </div>
                    <div class="modal-body">
                        <div id="edit_payslip_content"></div>
                    </div>
                </div>
            </div>
        </div>

        <div id="page-content-wrapper">
            <div id="page-content">
                <div class="container">
                    <div id="page-title">
                        <h2>Payslips</h2>
                    </div>
                    <div class="panel">
                        <div class="panel-body">
                            <div class="form-horizontal">
                                <div class="form-group">
                                    <div class="col-sm-4">
                                        <div class="input-group bootstrap-touchspin">
                                            <input type="text" id="payslip_search" placeholder="Search Payslip" class="form-control" style="width: 400px;color:black;">
                                            <span class="input-group-btn">
                                                <button class="btn btn-default  bootstrap-touchspin-up" type="button" onclick="loadPayslips($('#payslip_search').val())">Search</button>
                                                <button class="btn btn-default  bootstrap-touchspin-up" type="button" data-toggle="modal" data-target="#fastCreateModal">Fast Create</button>
                                                <button class="btn btn-default  bootstrap-touchspin-up" type="button" onclick="location.href = 'CreatePayslip.jsp';">Create New</button>
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <br>
                                <div id="payslips_table"></div>
                            </div>

                            <div class="modal fade bs-example-modal-lg" id="fastCreateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                                <div class="modal-dialog" style="width: 400px;">
                                    <div class="modal-content" style="width: 400px;">
                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                            <h3>Date Input</h3>
                                        </div>
                                        <div class="modal-body">
                                            <div class="form-horizontal">
                                                <div class="form-group">
                                                    <label class="col-sm-4 control-label">Date of Payment: </label>
                                                    <div class="col-sm-7">
                                                        <input type="date" id="fc_paymentdate" class="form-control">
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="col-sm-4 control-label"></label>
                                                    <div class="col-sm-7 text-center">
                                                        <button class="btn btn-default" onclick="fgPayslips()">Generate Payslips</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
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
                    </div>
                </div>
            </div>
        </div> 
    </body>
</html>
