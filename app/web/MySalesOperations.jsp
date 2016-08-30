<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Operations</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/OperationFunctions.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
    </head>
    <%@include file="header.jsp"%>
    <body onload="sales_operation_setup('<%=user.getNric()%>')">
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
                        <h2>My Operations</h2> <br/>
                        <div class="panel">
                            <div class="panel-body">
                                <div class="form-group">
                                    <div class="col-sm-4">
                                        <div class="input-group bootstrap-touchspin">
                                            <input type="text" id="operation_search" placeholder="Enter Lead ID or Date (YYYY-MM-DD)" class="form-control" style="width: 400px;color:black;">
                                            <span class="input-group-btn">
                                                <button class="btn btn-default bootstrap-touchspin-up" type="button" onclick="loadSalesOperations($('#operation_search').val(), '<%=user.getNric()%>')">Search</button>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <br><br>
                                <div id="operations_table"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
