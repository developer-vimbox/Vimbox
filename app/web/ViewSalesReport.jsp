<%@page import="java.text.DateFormat"%>
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
        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
        <script type="text/javascript">
            window.onload = function() {
                google.charts.load('current', {packages: ['corechart']});
        }
        </script>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <title>Sales Report</title>

        <!--        <script type="text/javascript">
                    $(document).ready(function () {
                        $("body").tooltip({
                            selector: '[data-toggle=tooltip]'
                        });
                    });
                    var today = new Date();
                    var dd = today.getDate();
                    var mm = today.getMonth() + 1;
                    if (mm < 10) {
                        mm = "0" + mm;
                    }
                    var yyyy = today.getFullYear();
                    document.body.onload = showSch(yyyy + "-" + mm + "-" + dd);
                </script>-->
    </head>
    <%
        String date = new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
        String month = new SimpleDateFormat("MM").format(new java.util.Date());
        String monthname = new SimpleDateFormat("MMMM").format(new java.util.Date());
        String year = new SimpleDateFormat("YYYY").format(new java.util.Date());
        String[] mths = {"January",
            "February",
            "March",
            "April",
            "May",
            "June",
            "July",
            "August",
            "September",
            "October",
            "November",
            "December"};
    %>
    <body onload='confirmedReport();'>
        <%@include file="header.jsp"%>

       
        <div id="page-content-wrapper">

            <div id="page-content">
                <div class="container" style="width: 100%;">
                    <div id="page-title">
                        <h2>Sales Report</h2> <br>
                    </div>
                    <div class="panel">
                        <div class="panel-body">
                            <%                                String[] timings = new String[]{"0900 - 0930", "0930 - 1000", "1000 - 1030", "1030 - 1100", "1100 - 1130", "1130 - 1200", "1200 - 1230", "1230 - 1300", "1300 - 1330", "1330 - 1400", "1400 - 1430", "1430 - 1500", "1500 - 1530", "1530 - 1600", "1600 - 1630", "1630 - 1700", "1700 - 1730", "1730 - 1800"};

                                ArrayList<SiteSurvey> surveys = SiteSurveyDAO.getSiteSurveysByUserandSd(user.getNric(), date);
                            %>
                            <div class="form-horizontal">
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Report For: </label>
                                    <div class="col-sm-5" style="padding-top: 7px;">
                                        <input class="radio-inline" type="radio" name="reportfor" value="confirmed" checked="" onclick="confirmedReport();">Confirmed
                                        <input class="radio-inline" type="radio" name="reportfor" value="pending" onclick="pendingReport();">Pending
                                        <input class="radio-inline" type="radio" name="reportfor" value="general" onclick="generalReport();">General

                                    </div>
                                </div>
                                <div class='form-group'>
                                    <label class="col-sm-3 control-label">View By: </label>
                                    <div class="col-sm-5">
                                        <div class="input-group">
                                            <select id="optns" name="optns" class="form-control" onchange="showConfirmedSalesReport(this)">
                                                <option value="week">Week</option>
                                                <!--<option value="month">Month</option>-->
                                                <option value="year">Year</option>
                                            </select>
                                        </div>
                                        <div class="input-group">
                                            <select id="optnspending" name="optnspending" class="form-control" onchange="showPendingSalesReport(this)" style="display:none">
                                                <option value="week">Week</option>
                                                <!--<option value="month">Month</option>-->
                                                <option value="year">Year</option>
                                            </select>
                                        </div>
                                         <div class="input-group">
                                            <select id="optnsgeneral" name="optnsgeneral" class="form-control" onchange="showGeneralSalesReport(this)" style="display:none">
                                                <option value="week">Week</option>
                                                <!--<option value="month">Month</option>-->
                                                <option value="year">Year</option>
                                            </select>
                                        </div>

                                    </div>
                                </div>
                                <div class='form-group'>
                                    <label id="seldatelbl" class="col-sm-3 control-label" >Start By: </label>
                                    <div class="col-sm-5">
                                        <input  class="form-control" id="seldate" type="date" name="seldate" value='<%=date%>' onchange='showConfirmedWeekReport()'>
                                        <input class="form-control" id="seldate_pending" type="date" name="seldate_pending" value='<%=date%>' onchange='showPendingWeekReport()' style="display:none">
                                        <input class="form-control" id="seldate_general" type="date" name="seldate_general" value='<%=date%>' onchange='showGeneralWeekReport()' style="display:none">
                                    </div>
                                </div>
                                <div class='form-group'>
                                    <label id="selyearlbl" class="col-sm-3 control-label" style="display:none" >Start By: </label>
                                    <div class="col-sm-5">

                                        <select id ="selyear" name="selyear" class="form-control" style="display:none"  onchange="showConfirmedYearReport()">
                                            <%
                                                int cyear = Integer.parseInt(year);
                                                for (int i = cyear - 5; i <= cyear; i++) {

                                                    if (i == cyear) {
                                            %>
                                            <option value="<%=i%>" selected="selected"><%=i%></option>
                                            <%} else {%>
                                            <option value="<%=i%>"><%=i%></option>
                                            <%}
                                                }%>
                                        </select>

                                        <select id ="selyear_pending" name="selyear_pending" class="form-control" style="display:none"  onchange="showPendingYearReport()">
                                            <%
                                                int cyear2 = Integer.parseInt(year);
                                                for (int i = cyear2 - 5; i <= cyear2; i++) {

                                                    if (i == cyear2) {
                                            %>
                                            <option value="<%=i%>" selected="selected"><%=i%></option>
                                            <%} else {%>
                                            <option value="<%=i%>"><%=i%></option>
                                            <%}
                                                }%>
                                        </select>
                                        
                                         <select id ="selyear_general" name="selyear_general" class="form-control" style="display:none"  onchange="showGeneralYearReport()">
                                            <%
                                                int cyear3 = Integer.parseInt(year);
                                                for (int i = cyear3 - 5; i <= cyear3; i++) {

                                                    if (i == cyear3) {
                                            %>
                                            <option value="<%=i%>" selected="selected"><%=i%></option>
                                            <%} else {%>
                                            <option value="<%=i%>"><%=i%></option>
                                            <%}
                                                }%>
                                        </select>

                                    </div>
                                </div>


                                <br>
                                <div id="rptTitle" style="
                                     text-align: center;
                                     font-weight: bold;
                                     font-size: large;
                                     "></div>
                                <div id='forTotalNo' style="display:none; margin-left: 70%;font-size: 15px;" class="bs-label label-blue-alt"></div>
                                <div class='shwreport' id="shwreport">
                                </div>
                                <div class="col-sm-5" style="margin-left: 5%;">
                                    <div class='shwReferralreport' id="shwReferralreport">
                                    </div>
                                </div>
                                <br/>
                                <div id="rptAmtTitle" style="
                                     text-align: center;
                                     font-weight: bold;
                                     font-size: large;
                                     "></div>
                                <div id='forTotalAmt' style="display:none; margin-left: 70%;font-size: 15px;" class="bs-label label-success"></div>
                                <div class='shwAmtreport' id="shwAmtreport">
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>      
    </body>
</html>
