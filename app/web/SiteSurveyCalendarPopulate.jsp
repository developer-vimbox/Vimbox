<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.user.User"%>
<%@page import="com.vimbox.sitesurvey.SiteSurvey"%>
<%@page import="com.vimbox.sales.Lead"%>
<%@page import="com.vimbox.database.LeadDAO"%>
<%@page import="com.vimbox.database.SiteSurveyDAO"%>
<%@page import="org.joda.time.DateTime"%>
<%@ page  language="java" import="java.util.*,java.text.*"%>
<%!
    public int nullIntconv(String inv) {
        int conv = 0;

        try {
            conv = Integer.parseInt(inv);
        } catch (Exception e) {
        }
        return conv;
    }
%>
<%
    int iYear = Integer.parseInt(request.getParameter("getYear"));
    int iMonth = Integer.parseInt(request.getParameter("getMonth"));
    String fullMonth = request.getParameter("getFullMonth");

    Calendar ca = new GregorianCalendar();
    int iTDay = ca.get(Calendar.DATE);
    int iTYear = ca.get(Calendar.YEAR);
    int iTMonth = ca.get(Calendar.MONTH);

    if (iYear == 0) {
        iYear = iTYear;
        iMonth = iTMonth;
    }

    GregorianCalendar cal = new GregorianCalendar(iYear, iMonth, 1);

    int days = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
    int weekStartDay = cal.get(Calendar.DAY_OF_WEEK);

    cal = new GregorianCalendar(iYear, iMonth, days);
    int iTotalweeks = cal.get(Calendar.WEEK_OF_MONTH);

    ArrayList<SiteSurvey> surveys = SiteSurveyDAO.getAllSiteSurveys();
%>

<style type="text/css">
    .tooltippp {
        position: relative;
    }

    .tooltippp .tooltiptexttt {
        visibility: hidden;
        width: 300px;
        background-color: black;
        color: #fff;
        text-align: center;
        border-radius: 6px;
        padding: 5px 0;
        position: absolute;
        z-index: 1;
        bottom: 150%;
        margin-left: -60px;
    }

    .tooltippp .tooltiptexttt::after {
        content: "";
        position: absolute;
        top: 100%;
        left: 50%;
        margin-left: -5px;
        border-width: 5px;
        border-style: solid;
        border-color: black transparent transparent transparent;
    }

    .tooltippp:hover .tooltiptexttt {
        visibility: visible;
    }
</style>

<!-- Calendar -->

<script type="text/javascript" src="assets/widgets/interactions-ui/resizable.js"></script>
<script type="text/javascript" src="assets/widgets/interactions-ui/draggable.js"></script>
<script type="text/javascript" src="assets/widgets/interactions-ui/sortable.js"></script>
<script type="text/javascript" src="assets/widgets/interactions-ui/selectable.js"></script>

<link rel="stylesheet" type="text/css" href="assets/widgets/calendar/calendar.css">
<script type="text/javascript" src="assets/widgets/daterangepicker/moment.js"></script>
<script type="text/javascript" src="assets/widgets/calendar/calendar.js"></script>
<script type="text/javascript" src="assets/widgets/calendar/calendar-demo.js"></script>
<div class="fc-view fc-view-month fc-grid">
    <table width="100%" cellspacing="0" class="fc-border-separate">
        <thead>
            <tr class="fc-first fc-last">
                <th style="width: 14.2%" class="fc-day-header fc-sun fc-widget-header fc-first">Sun</th>
                <th style="width: 14.2%" class="fc-day-header fc-mon fc-widget-header">Mon</th>
                <th style="width: 14.2%" class="fc-day-header fc-tue fc-widget-header">Tue</th>
                <th style="width: 14.2%" class="fc-day-header fc-wed fc-widget-header">Wed</th>
                <th style="width: 14.2%" class="fc-day-header fc-thu fc-widget-header">Thu</th>
                <th style="width: 14.2%" class="fc-day-header fc-fri fc-widget-header">Fri</th>
                <th style="width: 14.2%" class="fc-day-header fc-sat fc-widget-header fc-last">Sat</th>
            </tr>
        </thead>
        <tbody>
            <%                                    int cnt = 1;
                for (int i = 1; i <= iTotalweeks; i++) {
            %>
            <tr class="fc-week fc-last">
                <%
                    for (int j = 1; j <= 7; j++) {
                        if (cnt < weekStartDay || (cnt - weekStartDay + 1) > days) {
                %>
                <td align="center" class="fc-day fc-mon fc-widget-content fc-future fc-last">
                    <div style="min-height: 100px;">
                        &nbsp;
                    </div>
                </td>
                <%
                } else {
                %>
                <td class="fc-day fc-mon fc-widget-content fc-future fc-last" id="day_<%=(cnt - weekStartDay + 1)%>" style="vertical-align: top;">
                    <div style="min-height: 100px;">
                        <div class="fc-day-number" style="font-size: 16px;">
                            <%=(cnt - weekStartDay + 1)%>
                        </div>
                        <div class="fc-day-content">
                            <%   for (SiteSurvey ss : surveys) {
                                    DateTime start = ss.getStart();
                                    String startTime = start.getHourOfDay() + ":" + start.getMinuteOfHour();
                                    if(startTime.length() < 5){
                                        startTime = startTime + "0";
                                    }
                                    DateTime end = ss.getEnd();
                                    String endTime = end.getHourOfDay() + ":" + end.getMinuteOfHour();
                                    if(endTime.length() < 5){
                                        endTime = endTime + "0";
                                    }
                                    String displayTime = startTime + " - " + endTime;
                                    int dayOfMonth = start.getDayOfMonth();
                                    int surveyMonth = start.getMonthOfYear();
                                    if ((dayOfMonth == (cnt - weekStartDay + 1)) && (iMonth == (surveyMonth - 1))) {
                                        int lead = ss.getLead();
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
                                        if(status.equals("Completed")){
                                            statusCol = "btn-success";
                                        } else if(status.equals("Cancelled")) {
                                            statusCol = "btn-danger";
                                        } else if(status.equals("Pending")) {
                                            statusCol = "btn-info";
                                        }
                            %>
                            <div style="position: relative;">
                                <div class="tooltippp"><label class="<%=statusCol%>"><b><%=displayTime%></b> <%=lead%> <%=ssUser%></label>
                                    <table class='tooltiptexttt' width="100%">
                                        <tr>
                                            <td align="right" style="vertical-align: top; padding-right: 5px; width: 30%;">Lead ID:</td>
                                            <td align="left"><%=lead%></td>
                                        </tr>
                                        <tr>
                                            <td align="right" style="vertical-align: top; padding-right: 5px;">Time:</td>
                                            <td align="left"><%=displayTime%></td>
                                        </tr>
                                        <tr>
                                            <td align="right" style="vertical-align: top; padding-right: 5px;">Status:</td>
                                            <td align="left"><%=status%></td>
                                        </tr>
                                        <tr>
                                            <td align="right" style="vertical-align: top; padding-right: 5px;">Addresses:</td>
                                            <td align="left">
                                            <%
                                                for (int a = 0; a < addrArray.length; a++) {
                                                    String add = addrArray[a];
                                                    String addTag = addrTagArray[a];
                                            %>
                                                <li><%=add%></li>
                                            <% 
                                                }
                                            %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" style="vertical-align: top; padding-right: 5px;">Assigned By:</td>
                                            <td align="left"><%=ssOwner%></td>
                                        </tr>
                                        <tr>
                                            <td align="right" style="vertical-align: top; padding-right: 5px;">Assigned To:</td>
                                            <td align="left"><%=ssUser%></td>
                                        </tr>
                                        <tr>
                                            <td align="right" style="vertical-align: top; padding-right: 5px;">Remarks:</td>
                                            <td align="left"><%=remarks%></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                            <%
                                }
                            %>
                            <div style="position: relative; height: 0px;"> &nbsp;</div>
                            <%
                                } %>
                        </div>
                    </div>
                </td>
                <%
                        }
                        cnt++;
                    }
                %>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
</div>
        <br>
        <div>
            Status:
            <label class="btn btn-danger">Cancelled</label>
            <label class="btn btn-info">Pending</label>
            <label class="btn btn-success">Completed</label>
        </div>

