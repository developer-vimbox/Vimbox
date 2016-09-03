<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Assign Jobs</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/OperationFunctions.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
    </head>
    <%@include file="header.jsp"%>
    <body onload="assign_jobs_setup()">
        <div id="viewLeadModal" class="modal">
            <div class="modal-content" style="width: 80%;">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('viewLeadModal')">×</span>
                    <center><h2>Lead Details</h2></center>
                </div>
                <div class="modal-body">
                    <div id="leadContent"></div>
                </div>
            </div>
        </div>
        <div class="modal" id="assignJobModal">
            <div class="modal-content">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('assignJobModal')">×</span>
                    <center><h2>Assign Job</h2></center>
                </div>
                <div class="modal-body">
                    <div id="assignJobContent"></div>
                </div>
            </div>
        </div>
        <div id="job_error_modal" class="modal">
            <!-- Modal content -->
            <div class="message-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('job_error_modal')">×</span>
                    <div id="job_error_status"></div>
                    <hr>
                    <div id="job_error_message"></div>
                </div>
            </div>
        </div> 
        <div id="page-content-wrapper">
            <div id="page-content">
                <div class="container">
                    <div id="page-title">
                        <h2>All Jobs</h2> <br/>
                        <div class="panel">
                            <div class="panel-body">
                                <div class="form-group">
                                    <div class="col-sm-4">
                                        <div class="input-group bootstrap-touchspin">
                                            <input type="text" id="job_search" placeholder="Enter Lead ID or Date (YYYY-MM-DD)" class="form-control" style="width: 400px;color:black;">
                                            
                                            <button class="btn btn-default bootstrap-touchspin-up" type="button" onclick="loadAssignJobs($('#job_search').val())">Search</button>
                                            
                                        </div>
                                    </div>
                                </div>
                                <br><br>
                                <div id="jobs_table"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
