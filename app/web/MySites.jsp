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
    <body onload="survey_setup('<%=user.getNric()%>')">
        <h1>My Sites</h1><hr><br>
        <input type="text" id="nc_survey_search">
        <button onclick="loadSurveys($('#nc_survey_search').val(), '<%=user.getNric()%>', '')">Search Pending/Ongoing</button>
        <br><br>
        <div id="nc_surveys_table"></div>
        <br><br>
        <input type="text" id="c_survey_search">
        <button onclick="loadSurveys($('#c_survey_search').val(), '<%=user.getNric()%>', 'Completed')">Search Completed</button>
        <br><br>
        <div id="c_surveys_table"></div>
    </body>
</html>
