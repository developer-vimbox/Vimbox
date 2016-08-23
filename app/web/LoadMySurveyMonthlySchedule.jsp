<%@include file="ValidateLogin.jsp"%> 
<%@page import="org.joda.time.format.DateTimeFormat"%>
<%@page import="org.joda.time.format.DateTimeFormatter"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.sitesurvey.SiteSurvey"%>
<%@page import="com.vimbox.database.SiteSurveyDAO"%>
<%@page import="org.joda.time.DateTime"%>
<%@page import="java.text.SimpleDateFormat"%>
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
<%    int iYear = Integer.parseInt(request.getParameter("getYear"));
    int iMonth = Integer.parseInt(request.getParameter("getMonth"));

    Calendar ca = new GregorianCalendar();
    int caDate = ca.get(Calendar.DATE);
    int caYear = ca.get(Calendar.YEAR);
    int caMonth = ca.get(Calendar.MONTH);

    if (iYear == 0) {
        iYear = caYear;
        iMonth = caMonth;
    }

    GregorianCalendar cal = new GregorianCalendar(iYear, iMonth, 1);

    int days = cal.getActualMaximum(Calendar.DAY_OF_MONTH); // returns the max number of days within the given month.
    int weekStartDay = cal.get(Calendar.DAY_OF_WEEK);

    cal = new GregorianCalendar(iYear, iMonth, days);
    int iTotalweeks = cal.get(Calendar.WEEK_OF_MONTH);

    DateTime currDate = null;
    DateTime dt = new DateTime();
    DateTimeFormatter fmt = DateTimeFormat.forPattern("YYYY-MM-dd");
    ArrayList<SiteSurvey> surveys = SiteSurveyDAO.getSiteSurveysByIC(user.getNric());
%>



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
            <%
                int cnt = 1;
                int curDate = 0;
                for (int i = 1; i <= iTotalweeks; i++) {
            %>
            <tr class="fc-week fc-last">
                <%
                    for (int j = 1; j <= 7; j++) {
                        curDate = cnt - weekStartDay + 1;
                        if (cnt < weekStartDay || curDate > days) {
                %>
                <td align="center" class="fc-day fc-mon fc-widget-content fc-future fc-last">
                    <div style="min-height: 100px; background-color: #fafafa;">
                        &nbsp;
                    </div>
                </td>
                <%
                } else {
                    if (curDate == caDate && iYear == caYear && iMonth == caMonth) {
                %>
                <td class="fc-day fc-mon fc-widget-content fc-future fc-last" id="day_<%=curDate%>" style="vertical-align: top; background-color: #fcf8e3;">
                    <%
                    } else {
                    %>
                <td class="fc-day fc-mon fc-widget-content fc-future fc-last" id="day_<%=curDate%>" style="vertical-align: top;">
                    <%
                        }
                    %>
                    <div style="min-height: 100px;">
                        <div class="fc-day-number" style="font-size: 16px; padding-top: 2px;">
                            <%
                                currDate = fmt.parseDateTime(iYear + "-" + (iMonth + 1) + "-" + curDate);
                                String strDate = fmt.print(currDate);
                               %>


                            <%=curDate%>
                        </div>
                        <input type="hidden" id="selectedDate" value='<%=strDate%>'>
                        <div class="fc-day-content">
                            <%   for (SiteSurvey ss : surveys) {
                                    DateTime start = ss.getStart();
                                    int dayOfMonth = start.getDayOfMonth();
                                    int surveyMonth = start.getMonthOfYear();
                                    int surveyYear = start.getYear();

                                    if ((dayOfMonth == curDate) && (iMonth == (surveyMonth - 1)) && (iYear == surveyYear)) {
                                        int lead = ss.getLead();
                                        User ss_owner = ss.getOwner();
                                        String ssOwner = ss_owner.getFirst_name() + " " + ss_owner.getLast_name();
                                        String ssAddress = ss.getAddress();
                                        String[] addrArray = ssAddress.split("\\|");
                                        String status = ss.getStatus();
                                        String remarks = ss.getRemarks();
                                        String timeslot = ss.getTimeSlots();
                                        String statusCol = "";
                                        String leadString = "Lead ID: " + lead;
                                        if (status.equals("Completed")) {
                                            statusCol = "btn-success";
                                        } else if (status.equals("Pending")) {
                                            statusCol = "btn-warning";
                                        } else if (status.equals("Cancelled")) {
                                            statusCol = "btn-danger";
                                        } else if (status.equals("Ongoing")) {
                                            statusCol = "btn-info";
                                        }
                            %>
                            <a id='takenImg'  title="<%=leadString%>">
                   <!--<img data-toggle="tooltip" data-html="true" data-placement="right" src='Images/Red_Square.png' style='width:3%;height:1%;' title="<%=leadString%><br>-->
                                <button class='<%=statusCol%>' data-toggle="tooltip" data-html="true" data-placement="right" title="
                                        <table>
                                        <tr><td align='right' style='vertical-align: top; padding-right: 5px;'>Lead ID:</td><td align='left'><%=lead%></td></tr>
                                        <tr><td align='right' style='vertical-align: top; padding-right: 5px;'>Status:</td><td align='left'><%=status%></td></tr>
                                        <tr><td align='right' style='vertical-align: top; padding-right: 5px;'>Assigned By:</td><td align='left'><%=ssOwner%></td></tr>
                                        <tr><td align='right' style='vertical-align: top; padding-right: 5px;'>Remarks:</td><td align='left'><%=remarks%></td></tr>
                                        <tr><td align='right' style='vertical-align: top; padding-right: 5px;'>Time:</td><td align='left'><%=timeslot%></td></tr>
                                        <tr><td align='right' style='vertical-align: top; padding-right: 5px;'>Addresses: </td>
                                        <td align='left'>
                                        <ul>
                                        <%
                                            if (addrArray != null) {
                                                for (int k = 0; k < addrArray.length; k++) {
                                                    String addr = addrArray[k];%>
                                        <li><%=addr%></li>
                                        <%}
                                            }
                                        %>
                                        </ul></td></tr>
                                        </table>
                                        "/> 
                                <%=leadString%></button>
                            </a>
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
    <label class="btn btn-info">Ongoing</label>
    <label class="btn btn-warning">Pending</label>
    <label class="btn btn-success">Completed</label>
    <label class="btn btn-danger">Cancelled</label>
</div>

