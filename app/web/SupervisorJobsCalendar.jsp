<%@page import="com.vimbox.operations.Job"%>
<%@page import="com.vimbox.database.JobDAO"%>
<%@page import="org.joda.time.format.DateTimeFormat"%>
<%@page import="org.joda.time.format.DateTimeFormatter"%>
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
<%@include file="ValidateLogin.jsp"%>
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

    Calendar ca = new GregorianCalendar();
    int iTDate = ca.get(Calendar.DATE);
    int iTYear = ca.get(Calendar.YEAR);
    int iTMonth = ca.get(Calendar.MONTH);

    if (iYear == 0) {
        iYear = iTYear;
        iMonth = iTMonth;
    }

    GregorianCalendar cal = new GregorianCalendar(iYear, iMonth, 1);

    int days = cal.getActualMaximum(Calendar.DAY_OF_MONTH); // returns the max number of days within the given month.
    int weekStartDay = cal.get(Calendar.DAY_OF_WEEK);

    cal = new GregorianCalendar(iYear, iMonth, days);
    int iTotalweeks = cal.get(Calendar.WEEK_OF_MONTH);

    DateTime currDate = null;
    DateTime dt = new DateTime();
    DateTimeFormatter fmt = DateTimeFormat.forPattern("YYYY-MM-dd");
    ArrayList<Job> jobs = JobDAO.getJobsBySupervisor(user.getNric());
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
            <tr class="fc-first fc-last" bgcolor="#f9fafe" style="font-size: 14px;">
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
                    <div style="min-height: 120px; background-color: #fafafa;">
                        &nbsp;
                    </div>
                </td>
                <%
                } else {
                    if (curDate == iTDate && iYear == iTYear && iMonth == iTMonth) {
                %>
                <td class="fc-day fc-mon fc-widget-content fc-future fc-last" id="day_<%=curDate%>" style="vertical-align: top; background-color: #fcf8e3;">
                    <%
                    } else {
                    %>
                <td class="fc-day fc-mon fc-widget-content fc-future fc-last" id="day_<%=curDate%>" style="vertical-align: top;">
                    <%
                        }
                    %>
                    <div style="min-height: 120px;">
                        <div class="fc-day-number" style="font-size: 16px; padding-top: 2px;">
                            <%
                                currDate = fmt.parseDateTime(iYear + "-" + (iMonth + 1) + "-" + curDate);
                                String strDate = fmt.print(currDate);
                                String url = "window.location.href='SupervisorDailyJobs.jsp?dom=" + strDate + "'";
                                if (currDate.isBefore(dt)) {
                                    if (curDate == iTDate && iYear == iTYear && iMonth == iTMonth) { // today
                            %>
                            <button class="btn btn-round btn-primary" onclick="<%=url%>">
                                <%=curDate%>
                            </button>
                            <%
                            } else { // past dates
                            %>
                            <button class="btn btn-round btn-default" onclick="<%=url%>">
                                <%=curDate%>
                            </button>
                            <%
                                } } else { // future dates
                            %>
                            <button class="btn btn-round btn-default" onclick="<%=url%>">
                                <%=curDate%>
                            </button>
                            <%
                                }
                            %>
                        </div>
                        <input type="hidden" id="selectedDate" value=<%=strDate%>>
                        <div class="fc-day-content">
                            <%   for (Job job : jobs) {
                                    DateTime start = job.getStart();
                                    int dayOfMonth = start.getDayOfMonth();
                                    int surveyMonth = start.getMonthOfYear();
                                    int surveyYear = start.getYear();

                                    if ((dayOfMonth == curDate) && (iMonth == (surveyMonth - 1)) && (iYear == surveyYear)) {
                                        int lead = job.getLeadId();
                                        User ss_owner = job.getOwner();
                                        String ssOwner = ss_owner.getFirst_name() + " " + ss_owner.getLast_name();
                                        ArrayList<String> addressesFr = new ArrayList<String>();
                                        ArrayList<String> addressesTo = new ArrayList<String>();
                                        HashMap<String, String> addresses = job.getAddresses();
                                        for (Map.Entry<String, String> entry : addresses.entrySet()) {
                                            String key = entry.getKey();
                                            String value = entry.getValue();
                                            if(value.equals("from")){
                                                if (!addressesFr.contains(key)) {
                                                    addressesFr.add(key);
                                                }
                                            }else{
                                                if (!addressesTo.contains(key)) {
                                                    addressesTo.add(key);
                                                }
                                            }
                                        }
                                        String timeslot = job.getTimeslots();
                            %>
                            <div style="position: relative;">
                                <div class="tooltippp"><label class="btn-success"><b><%=timeslot%></b> <%=lead%></label>
                                    <table class='tooltiptexttt' width="100%">
                                        <tr>
                                            <td align="right" style="vertical-align: top; padding-right: 5px; width: 30%;">Lead ID:</td>
                                            <td align="left"><%=lead%></td>
                                        </tr>
                                        <tr>
                                            <td align="right" style="vertical-align: top; padding-right: 5px;">Time:</td>
                                            <td align="left"><%=timeslot%></td>
                                        </tr>
                                        <tr>
                                            <td align="right" style="vertical-align: top; padding-right: 5px;">Addresses:</td>
                                            <td align="left">
                                                <%
                                                    for (String fr : addressesFr) {
                                                        String addFr = fr;
                                                %>
                                        <li><%=addFr%></li>
                                            <%
                                                }
                                            %>
                                        <%
                                                    for (String to : addressesTo) {
                                                        String addTo = to;
                                                %>
                                        <li><%=addTo%></li>
                                            <%
                                                }
                                            %>
                                        </td>
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
    <label class="btn btn-success">Confirmed</label>
</div>

