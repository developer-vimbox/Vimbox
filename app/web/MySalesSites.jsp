<%@include file="ValidateLogin.jsp"%>
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
    <body onload="sales_survey_setup('<%=user.getNric()%>')">
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
        <h1>My Sites</h1><hr><br>
        <input type="text" id="survey_search">
        <button onclick="loadSalesSurveys($('#survey_search').val(), '<%=user.getNric()%>')">Search</button>
        <br><br>
        <div id="surveys_table"></div>
    </body>
</html>
