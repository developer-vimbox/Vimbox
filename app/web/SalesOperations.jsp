<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Operations</title>
    </head>
    <%@include file="header.jsp"%>
    <body onload="sales_operation_setup()">
        <script src="http://malsup.github.com/jquery.form.js"></script> 
        <script src="JS/OperationFunctions.js"></script>
        <div id="change_dom_cal_modal" class="modal">
            <div class="modal-content" style="width: 90%;">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('change_dom_cal_modal')">×</span>
                    <br>
                    <div id="change_dom_cal_content"></div>
                    <br>
                    <div id="change_dom_cal_table"></div>
                </div>
            </div>
        </div>
        <div id="change_dom_schedule_modal" class="modal">
            <div class="modal-content" style="width: 95%;">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('change_dom_schedule_modal')">×</span>
                    <div id="change_dom_schedule_content"></div>
                </div>
            </div>
        </div>
        <div id="operation_error_modal" class="modal">
            <!-- Modal content -->
            <div class="message-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('operation_error_modal')">×</span>
                    <div id="operation_error_status"></div>
                    <hr>
                    <div id="operation_error_message"></div>
                </div>
            </div>
        </div> 
        <div id="page-content-wrapper">
            <div id="page-content">
                <div class="container">
                    <div id="page-title">
                        <h2>All Operations</h2> <br>
                    </div>
                    <div class="panel">
                        <div class="panel-body">
                            <!--<div class="form-horizontal">
                                <div class="form-group">
                                    <div class="col-sm-4">
                                        <div class="input-group bootstrap-touchspin"><span class="input-group-addon bootstrap-touchspin-prefix" style="display: none;"></span>
                                            <input type="text" id="operation_search" placeholder="Enter operation details" class="form-control" style="width: 400px;color:black;">
                                            <button class="btn btn-default  bootstrap-touchspin-up" type="button" onclick="loadSalesOperations($('#operation_search').val(), $('.tab-pane.active').attr('id'))">Search</button>
                                        </div>
                                    </div>
                                </div>
                            </div>-->
                            <div class="example-box-wrapper">
                                <ul class="nav-responsive nav nav-tabs">
                                    <li class="active"><a href="#Booked" data-toggle="tab">Booked</a></li>
                                    <li><a href="#Confirmed" data-toggle="tab">Confirmed</a></li>
                                    <li><a href="#Cancelled" data-toggle="tab">Cancelled</a></li>
                                </ul>
                                <div class="tab-content">
                                    <div id="Booked" class="tab-pane active"></div>
                                    <div id="Confirmed" class="tab-pane"></div>
                                    <div id="Cancelled" class="tab-pane"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
