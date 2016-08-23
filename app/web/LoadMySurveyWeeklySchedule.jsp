<%@page import="java.util.Date"%>
<%@include file="ValidateLogin.jsp"%> 
<%@page import="com.vimbox.sitesurvey.SiteSurvey"%>
<%@page import="com.vimbox.database.SiteSurveyDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%    String[] timings = new String[]{"0900 - 0930", "0930 - 1000", "1000 - 1030", "1030 - 1100", "1100 - 1130", "1130 - 1200", "1200 - 1230", "1230 - 1300", "1300 - 1330", "1330 - 1400", "1400 - 1430", "1430 - 1500", "1500 - 1530", "1530 - 1600", "1600 - 1630", "1630 - 1700", "1700 - 1730", "1730 - 1800"};

    ArrayList<ArrayList<SiteSurvey>> allsurveys = new ArrayList<ArrayList<SiteSurvey>>();
%>
<table class ='table table-bordered'>
    <thead>
        <tr>
            <th align='right'>TimeSlots</th>
            <%
                Date shwdate = new java.util.Date();

                for (int i = 0; i < 7; i++) {
                    String currdate = new SimpleDateFormat("yyyy-MM-dd").format(shwdate);
                    allsurveys.add(SiteSurveyDAO.getSiteSurveysByUserandSd(user.getNric(), currdate));
            %>
            <th>Site Surveys on:<br>
                <b><%=currdate%></b>
            </th>
            <%
                    Date tmrw = new Date(shwdate.getTime() + (1000 * 60 * 60 * 24));
                    shwdate = tmrw;
                }%>
        </tr>
    </thead>
    <tbody>
        <%            for (String slot : timings) {
        %>
        <tr>
            <td align='right'><%=slot%></td>
            <%
                for (int k = 0; k < 7; k++) {
                    ArrayList<SiteSurvey> surveys = allsurveys.get(k);
            %>
            <td>
                <%
                    if (surveys != null) {
                        for (SiteSurvey ss : surveys) {
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
                            String dataplacement = "";
                            if(k < 5){
                                dataplacement = "right";
                            }else{
                                dataplacement = "left";
                            }
                            if (status.equals("Completed")) {
                                statusCol = "btn-success";
                            } else if (status.equals("Cancelled")) {
                                statusCol = "btn-danger";
                            } else if (status.equals("Pending")) {
                                statusCol = "btn-warning";
                            }else if(status.equals("Ongoing")) {
                                statusCol= "btn-info";
                            }
                            if (fTime.equals(slot)) {
                                int lead = ss.getLead();
                                String add = ss.getAddress();
                                String leadString = "Lead ID: " + lead;

                %>
                <a id='takenImg'  title="<%=leadString%>">
                    <!--<img data-toggle="tooltip" data-html="true" data-placement="right" src='Images/Red_Square.png' style='width:3%;height:1%;' title="<%=leadString%><br>-->
                    <button class='<%=statusCol%>' data-toggle="tooltip" data-html="true" data-placement="<%=dataplacement%>" title="
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
            <%
                }%>
        </tr>
        <%}%>
    </tbody>
</table>