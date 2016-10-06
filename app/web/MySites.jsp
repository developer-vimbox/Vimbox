<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Sites</title>
    </head>
    <%@include file="header.jsp"%>
    <body onload="survey_setup('<%=user.getNric()%>')">
        <script src="http://malsup.github.com/jquery.form.js"></script> 
        <script src="JS/SiteSurveyFunctions.js"></script>
        <script src="JS/OperationFunctions.js"></script>
        <div id="view_dom_modal" class="modal">
            <!-- Modal content -->
            <div class="message-modal-content" style="width: 50%;">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('view_dom_modal')">×</span>
                    <div id="dom_content"></div>
                </div>
            </div>
        </div>

        <div id="view_survey_modal" class="modal">
            <!-- Modal content -->
            <div class="message-modal-content" style="width: 90%;">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('view_survey_modal')">×</span>
                    <div id="view_survey_message"></div>
                </div>
            </div>
        </div>

        <div id="site_cal_modal" class="modal">
            <div class="modal-content" style="width: 90%;">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('site_cal_modal')">×</span>
                    <br>
                    <div id="site_cal_content"></div>
                    <br>
                    <div id="site_ssCalTable"></div>
                </div>
            </div>
        </div>

        <div id="site_schedule_modal" class="modal">
            <div class="modal-content" style="width: 95%;">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('site_schedule_modal')">×</span>
                    <div id="site_schedule_content"></div>
                </div>
            </div>
        </div>

        <div id="salesModal" class="modal">
            <!-- Modal content -->
            <div class="modal-content" style="width: 400px;">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('salesModal')">×</span>
                    <center><h3><div id="salesStatus"></div></h3></center>
                </div>
                <div class="modal-body">
                    <div id="salesMessage"></div>
                </div>
            </div>
        </div>



        <div id="lead_error_modal" class="modal">
            <div class="error-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('lead_error_modal')">×</span>
                    <div id="lead_error_status"></div>
                    <hr>
                    <div id="lead_error_message"></div>
                </div>
            </div>
        </div>

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
                        <h2>My Sites</h2> <br/>
                        <div class="panel">
                            <div class="panel-body">
                                <div class="example-box-wrapper">

                                    <ul class="nav-responsive nav nav-tabs">
                                        <li class="active"><a href="#pendingSurvey" data-toggle="tab" onclick="survey_setup('<%=user.getNric()%>')">Pending Survey</a></li>
                                        <li><a href="#completedSurvey" data-toggle="tab" onclick="survey_setup_completed('<%=user.getNric()%>')">Completed Survey</a></li>
                                    </ul>
                                    <div class="tab-content">
                                        <div id="pendingSurvey" class="tab-pane active">
                                            <!--<div class="form-group">
                                                <div class="col-sm-4">
                                                    <div class="input-group bootstrap-touchspin">
                                                        <input type="text" id="nc_survey_search" placeholder="Enter Lead ID" class="form-control" style="width: 400px;color:black;">
                                                        <span class="input-group-btn">
                                                            <button class="btn btn-default bootstrap-touchspin-up" type="button" onclick="loadSurveys($('#nc_survey_search').val(), '<%=user.getNric()%>', '')">Search Pending/ Ongoing</button>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>-->
                                            <div id="nc_surveys_table"></div>
                                        </div>


                                        <div id="completedSurvey" class="tab-pane">
                                            <!--<div class="form-group">
                                                <div class="col-sm-4">
                                                    <div class="input-group bootstrap-touchspin">
                                                        <input type="text" id="c_survey_search" placeholder="Enter Lead ID" class="form-control" style="width: 400px;color:black;">
                                                        <span class="input-group-btn">
                                                            <button class="btn btn-default bootstrap-touchspin-up" type="button" onclick="loadSurveys($('#c_survey_search').val(), '<%=user.getNric()%>', 'Completed')">Search Completed</button>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>-->
                                            <div id="c_surveys_table"></div>
                                        </div>
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
