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
        <input type="text" id="survey_search">
        <button onclick="loadSurveys($('#survey_search').val(), '<%=user.getNric()%>')">Search</button>
        <br><br>
        <div id="surveys_table"></div>
    </body>
</html>
