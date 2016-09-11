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
    <body onload="survey_setup('<%=user.getNric()%>')">
        <div id="view_dom_modal" class="modal">
            <!-- Modal content -->
            <div class="message-modal-content">
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
                                            <div class="form-group">
                                                <div class="col-sm-4">
                                                    <div class="input-group bootstrap-touchspin">
                                                        <input type="text" id="nc_survey_search" placeholder="Enter Lead ID" class="form-control" style="width: 400px;color:black;">
                                                        <span class="input-group-btn">
                                                            <button class="btn btn-default bootstrap-touchspin-up" type="button" onclick="loadSurveys($('#nc_survey_search').val(), '<%=user.getNric()%>', '')">Search Pending/ Ongoing</button>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                                        <br><br>
                                            <div id="nc_surveys_table"></div>
                                        </div>

                                   
                                        <div id="completedSurvey" class="tab-pane">
                                            <div class="form-group">
                                                <div class="col-sm-4">
                                                    <div class="input-group bootstrap-touchspin">
                                                        <input type="text" id="c_survey_search" placeholder="Enter Lead ID" class="form-control" style="width: 400px;color:black;">
                                                        <span class="input-group-btn">
                                                            <button class="btn btn-default bootstrap-touchspin-up" type="button" onclick="loadSurveys($('#c_survey_search').val(), '<%=user.getNric()%>', 'Completed')">Search Completed</button>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                          
                                            <br><br>
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
