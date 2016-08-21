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

        </script>
    </head>
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
                                String date = new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
                                ArrayList<SiteSurvey> surveys = SiteSurveyDAO.getSiteSurveysByUserandSd(user.getNric(), date);
                            %>
                            <div class="form-horizontal">
                                <table class ='table'>
                                    <thead>
                                        <tr>
                                            <td>TimeSlots</td>
                                            <td>Site Surveys</td>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            for (String slot : timings) {
                                        %>
                                        <tr>
                                            <td style='width:40%'><%=slot%></td>
                                            <td>
                                                <%
                                                    if (surveys != null) {
                                                        for (SiteSurvey ss : surveys) {
                                                            String times = ss.getTimeSlots();
                                                            Date sd = ss.getStart().toDate();
                                                            Date ed = ss.getEnd().toDate();
                                                            String startTime = new SimpleDateFormat("HHmm").format(sd);
                                                            String endTime = new SimpleDateFormat("HHmm").format(ed);
                                                            String fTime = startTime + " - " + endTime;
                                                            User ss_user = ss.getSiteSurveyor();
                                                            User ss_owner = ss.getOwner();
                                                            String ssOwner = ss_owner.getFirst_name() + " " + ss_owner.getLast_name();
                                                            String ssUser = ss_user.getFirst_name() + " " + ss_user.getLast_name();
                                                            String ssAddress = ss.getAddress();
                                                            String[] addrArray = ssAddress.split("\\|");
                                                            String ssAddressTag = ss.getAddressTag();
                                                            String[] addrTagArray = ssAddressTag.split("\\|");
                                                            String status = ss.getStatus();
                                                            String remarks = ss.getRemarks();
                                                            String statusCol = "";

                                                            if (status.equals("Completed")) {
                                                                statusCol = "btn-success";
                                                            } else if (status.equals("Cancelled")) {
                                                                statusCol = "btn-danger";
                                                            } else if (status.equals("Pending")) {
                                                                statusCol = "btn-info";
                                                            }
                                                            if (fTime.equals(slot)) {
                                                                int lead = ss.getLead();
                                                                String add = ss.getAddress();
                                                                String leadString = "Lead ID: " + lead;
                                                                String addString = "Address: " + add;

                                                %>
                                                <a id='takenImg'  title="<%=leadString%><%=addString%>">
                                                    <!--<button  data-toggle="tooltip" data-html="true" data-placement="right"><%=leadString%><br><%=addString%></button>-->
                                                    <img data-toggle="tooltip" data-html="true" data-placement="right" src='Images/Red_Square.png' style='width:3%;height:1%;' title="<%=leadString%><br>
                                                         <ul>
                                                         <%
                                                             if (addrArray != null) {
                                                                 for (int i = 0; i < addrArray.length; i++) {
                                                                     String addr = addrArray[i];
                                                                     String addTag = addrTagArray[i];%>
                                                                     <li><%=addr%></li>
                                                                 <%}
                                                             }
                                                         %>
                                                         </ul>"/> 
                                                </a>
                                                <%}
                                                        }
                                                    }
                                                %>
                                            </td>
                                        </tr>
                                        <%}%>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>      
    </body>
</html>