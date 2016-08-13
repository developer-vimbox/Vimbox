<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Leave / MC</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/EmployeeFunctions.js"></script>
        <script src="JS/ModalFunctions.js"></script>
    </head>
    <body onload="leaveMc_setup()">
        <%@include file="header.jsp"%>
        <div id="leave_mc_error_modal" class="modal">
            <div class="modal-content" style="width: 350px;">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('leave_mc_error_modal')">×</span>
                    <center><h2><div id="leave_mc_error_status"></div></h2></center>
                </div>
                <div class="modal-body">
                    <div id="leave_mc_error_message"></div>
                </div>
            </div>
        </div>
        <div id="page-content-wrapper">
            <div id="page-content" style="min-height: 7630px;">
                <div class="container">
                    <div id="page-title">
                        <h2>Leave Record</h2> <br>
                    </div>
                    <div class="panel">
                        <div class="panel-body">
                            <div class="form-horizontal">
                                <div class="form-group">
                                    <div class="col-sm-4">
                                        <div class="input-group bootstrap-touchspin"><span class="input-group-addon bootstrap-touchspin-prefix" style="display: none;"></span>
                                            <input type="text" id="leave_mc_search" class="form-control" style="width: 400px;color:black;">
                                            <span class="input-group-btn">
                                                <button class="btn btn-default  bootstrap-touchspin-up" type="button"  onclick="loadLeaveMCs($('#leave_mc_search').val())">Search</button>
                                                <button class="btn btn-default  bootstrap-touchspin-up" type="button" onclick="location.href = 'CreateLeaveMC.jsp';">Add New</button>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <br>
                                <div id="leave_mc_table"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
