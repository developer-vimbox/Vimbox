<%@page import="java.util.Date"%>
<%@include file="ValidateLogin.jsp"%> 
<%@page import="com.vimbox.sitesurvey.SiteSurvey"%>
<%@page import="com.vimbox.database.SiteSurveyDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%    String date = request.getParameter("date");
    String[] timings = new String[]{"0900 - 0930", "0930 - 1000", "1000 - 1030", "1030 - 1100", "1100 - 1130", "1130 - 1200", "1200 - 1230", "1230 - 1300", "1300 - 1330", "1330 - 1400", "1400 - 1430", "1430 - 1500", "1500 - 1530", "1530 - 1600", "1600 - 1630", "1630 - 1700", "1700 - 1730", "1730 - 1800"};

    ArrayList<SiteSurvey> surveys = SiteSurveyDAO.getSiteSurveysByUserandSd(user.getNric(), date);
%>
<table class ='table table-rounded'>
    <thead>
        <tr>
            <td align='right'>TimeSlots</td>
            <td>Site Surveys on: <br>
                <b><%=date%></b>
            </td>
        </tr>
    </thead>
    <tbody>
        <%
            for (String slot : timings) {
        %>
        <tr>
            <td align='right'><%=slot%></td>
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
                            User ss_owner = ss.getOwner();
                            String ssOwner = ss_owner.getFirst_name() + " " + ss_owner.getLast_name();
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

                %>
                <a id='takenImg'  title="<%=leadString%>">
                    <!--<img data-toggle="tooltip" data-html="true" data-placement="right" src='Images/Red_Square.png' style='width:3%;height:1%;' title="<%=leadString%><br>-->
                    <button class='<%=statusCol%>' data-toggle="tooltip" data-html="true" data-placement="right" title="
                            <table>
                            <tr><td align='right' style='vertical-align: top; padding-right: 5px;'>Lead ID:</td><td align='left'><%=lead%></td></tr>
                            <tr><td align='right' style='vertical-align: top; padding-right: 5px;'>Status:</td><td align='left'><%=status%></td></tr>
                            <tr><td align='right' style='vertical-align: top; padding-right: 5px;'>Assigned By:</td><td align='left'><%=ssOwner%></td></tr>
                            <tr><td align='right' style='vertical-align: top; padding-right: 5px;'>Remarks:</td><td align='left'><%=remarks%></td></tr>
                            <tr><td align='right' style='vertical-align: top; padding-right: 5px;'>Addresses: </td>
                            <td align='left'>
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
                            </ul></td></tr>
                            </table>
                            "/> 
                    <%=leadString%></button>
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