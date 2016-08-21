<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.sitesurvey.SiteSurvey"%>
<%@page import="com.vimbox.sales.Lead"%>
<%@page import="com.vimbox.database.LeadDAO"%>
<%@page import="com.vimbox.database.SiteSurveyDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js"></script>
        <script src="http://malsup.github.com/jquery.form.js"></script> 
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAlr3mj-08qPnSvod0WtYbmE0NrulFq0RE&libraries=places"></script>
        <script src="JS/jquery.hotkeys.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <script src="JS/LeadFunctions.js"></script>
        <script src="JS/SiteSurveyFunctions.js"></script>
        <script src="JS/AddressSearch.js"></script>
        <script src="JS/CustomerFunctions.js"></script>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title> Site Surveys Schedule</title>

        <script type="text/javascript">
            $(document).ready(function () {
                $("body").tooltip({
                    selector: '[data-toggle=tooltip]'
                });
            });
            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth() + 1; 
            if(mm < 10){
                mm = "0"+ mm;
            }
            var yyyy = today.getFullYear();
            document.body.onload = showSch(yyyy+"-"+mm+"-"+dd);
        </script>
    </head>
    <%
    String date = new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
    %>
    <body>
        <%@include file="header.jsp"%>
        <div id="page-content-wrapper">

            <div id="page-content">
                <div class="container" style="width: 100%;">
                    <div id="page-title">
                        <h2>My Site Surveys Schedule</h2> <br>
                    </div>
                    <div class="panel">
                        <div class="panel-body">
                            <%                                String[] timings = new String[]{"0900 - 0930", "0930 - 1000", "1000 - 1030", "1030 - 1100", "1100 - 1130", "1130 - 1200", "1200 - 1230", "1230 - 1300", "1300 - 1330", "1330 - 1400", "1400 - 1430", "1430 - 1500", "1500 - 1530", "1530 - 1600", "1600 - 1630", "1630 - 1700", "1700 - 1730", "1730 - 1800"};
                                
                                ArrayList<SiteSurvey> surveys = SiteSurveyDAO.getSiteSurveysByUserandSd(user.getNric(), date);
                            %>
                            <div class="form-horizontal">
                                <div class='form-group'>
                                    <label class="col-sm-3 control-label">View By: </label>
                                    <div class="col-sm-5">
                                        <div class="input-group">
                                            <select name="assigned" class="form-control" onchange="showWeeklySch(this)">
                                                <option value="day">Day</option>
                                                <option value="week">Week</option>
                                            </select>
                                        </div>

                                    </div>
                                </div>
                                <div class='form-group'>
                                    <label id="seldatelbl" class="col-sm-3 control-label">Date: </label>
                                    <div class="col-sm-5">
                                        <input class="form-control" id="seldate" type="date" name="seldate" value='<%=date%>' onchange='viewSch(this)'>

                                    </div>
                                </div>
                                    <div class='shwschedules' id="shwschedules">
                                    </div>
                               
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>      
    </body>
</html>
