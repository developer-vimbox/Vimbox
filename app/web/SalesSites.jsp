<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Sites</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/SiteSurveyFunctions.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
    </head>
    <%@include file="header.jsp"%>
    <body onload="sales_survey_setup()">
        <div id="survey_error_modal" class="modal">
            <!-- Modal content -->
            <div class="message-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('survey_error_modal')">×</span>
                    <div id="survey_error_status"></div>
                    <hr>
                    <div id="survey_error_message"></div>
                </div>
            </div>
        </div> 
        <div id="page-content-wrapper">
            <div id="page-content">
                <div class="container">
                    <div id="page-title">
                        <h2>All Surveys</h2> <br>
                    </div>
                    <div class="panel">
                        <div class="panel-body">
                            <div class="form-horizontal">
                                <div class="form-group">
                                    <div class="col-sm-4">
                                        <div class="input-group bootstrap-touchspin"><span class="input-group-addon bootstrap-touchspin-prefix" style="display: none;"></span>
                                            <input type="text" id="survey_search" placeholder="Enter survey details" class="form-control" style="width: 400px;color:black;">
                                            <button class="btn btn-default  bootstrap-touchspin-up" type="button" onclick="loadSalesSurveys($('#survey_search').val(), $('.tab-pane.active').attr('id'))">Search</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="example-box-wrapper">
                                <ul class="nav-responsive nav nav-tabs">
                                    <li class="active"><a href="#Pending" data-toggle="tab">Pending</a></li>
                                    <li><a href="#Ongoing" data-toggle="tab">Ongoing</a></li>
                                    <li><a href="#Completed" data-toggle="tab">Completed</a></li>
                                    <li><a href="#Cancelled" data-toggle="tab">Canceled</a></li>
                                </ul>
                                <div class="tab-content">
                                    <div id="Pending" class="tab-pane active"></div>
                                    <div id="Ongoing" class="tab-pane"></div>
                                    <div id="Completed" class="tab-pane"></div>
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
