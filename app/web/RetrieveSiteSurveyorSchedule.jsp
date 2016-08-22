<%@page import="com.vimbox.sitesurvey.SiteSurvey"%>
<%@page import="com.vimbox.database.SiteSurveyDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.UserDAO"%>
<%@page import="com.vimbox.user.User"%>
<%@page import="org.joda.time.DateTime"%>
<%@page import="org.joda.time.format.DateTimeFormatter"%>
<%@page import="org.joda.time.format.DateTimeFormat"%>
<style type="text/css">
    .tooltipp {
        position: relative;
    }

    .tooltipp .tooltiptextt {
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
        left: -50%;
        margin-left: -100px;
    }

    .tooltipp .tooltiptextt::after {
        content: "";
        position: absolute;
        top: 100%;
        left: 50%;
        margin-left: -5px;
        border-width: 5px;
        border-style: solid;
        border-color: black transparent transparent transparent;
    }

    .tooltipp:hover .tooltiptextt {
        visibility: visible;
    }

    .controls {
        margin-top: 10px;
        border: 1px solid transparent;
        border-radius: 2px 0 0 2px;
        box-sizing: border-box;
        -moz-box-sizing: border-box;
        height: 32px;
        outline: none;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
    }

    #pac-input {
        background-color: #fff;
        font-family: Roboto;
        font-size: 15px;
        font-weight: 300;
        margin-left: 12px;
        padding: 0 11px 0 13px;
        text-overflow: ellipsis;
        width: 300px;
        display: none;
    }

    #pac-input:focus {
        border-color: #4d90fe;
    }
</style>

<%
    DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd");
    String dateString = request.getParameter("date");
    DateTime date = dtf.parseDateTime(dateString);
    String siteSurveyorr = request.getParameter("siteSurveyor");
    ArrayList<User> siteSurveyors = new ArrayList<User>();
    if (siteSurveyorr.equals("allss")) {
        siteSurveyors = UserDAO.getAllSurveyors();
    } else {
        User u = UserDAO.getUserByNRIC(siteSurveyorr);
        siteSurveyors.add(u);
    }
    String[] timings = new String[]{"0900 - 0930", "0930 - 1000", "1000 - 1030", "1030 - 1100", "1100 - 1130", "1130 - 1200", "1200 - 1230", "1230 - 1300", "1300 - 1330", "1330 - 1400", "1400 - 1430", "1430 - 1500", "1500 - 1530", "1530 - 1600", "1600 - 1630", "1630 - 1700", "1700 - 1730", "1730 - 1800"};
    ArrayList<String> addresses = new ArrayList<String>();
    String[] addressesFrom = request.getParameter("addressFrom").split("\\|");
    String[] addressesTo = request.getParameter("addressTo").split("\\|");

    if (addressesFrom.length > 1) {
        for (int i = 0; i < addressesFrom.length; i += 4) {
            addresses.add(addressesFrom[i] + " #" + addressesFrom[i + 1] + "-" + addressesFrom[i + 2] + " S" + addressesFrom[i + 3]);
        }
    }
    if (addressesTo.length > 1) {
        for (int i = 0; i < addressesTo.length; i += 4) {
            addresses.add(addressesTo[i] + " #" + addressesTo[i + 1] + "-" + addressesTo[i + 2] + " S" + addressesTo[i + 3]);
        }
    }

    String leadId = request.getParameter("leadId");
    String nric = request.getParameter("nric");
    String timeslots = request.getParameter("timeslots");
    String selectedAdds = request.getParameter("addresses");
    String remarks = request.getParameter("remarks");
    User selected = UserDAO.getUserByNRIC(nric);
    String[] addArray = null;
    String[] timeslotArray = null;
    if (selected != null) {
        addArray = selectedAdds.split("\\|");
        timeslotArray = timeslots.split("\\|");
    }
%>

<h2>Schedule for <%=dateString%></h2><hr>
<table width="100%">
    <col width="80%">
    <col width="20%">
    <tr>
        <td>
            <table width="100%">
                <tr>
                    <td style="vertical-align: top;">
                        <div id="mapForm" style="visibility: hidden">
                            <input id="pac-input" class="controls" type="text" placeholder="Search Box">
                            <div id="map"></div>
                            <div id="map-legends" style="display: none"></div>
                        </div>
                        <div id="tableForm">
                            <table width="100%" class="table table-bordered" id="sitesurveyor_table">
                                <tr>
                                    <th></th>
                                        <%
                                            for (String timing : timings) {
                                                out.println("<th>" + timing + "</th>");
                                            }
                                        %>
                                </tr>
                                <%
                                    for (User siteSurveyor : siteSurveyors) {
                                        ArrayList<SiteSurvey> surveys = SiteSurveyDAO.getSiteSurveysByUserDate(siteSurveyor.getNric(), dateString, Integer.parseInt(leadId));
                                %>
                                <tr>
                                    <td><%=siteSurveyor%></td>
                                    <%
                                        for (String timing : timings) {
                                            if (surveys.isEmpty()) {
                                                if (!addresses.isEmpty()) {
                                                    out.println("<td onclick='selectSlot(this)'");
                                                    out.println("><input type='hidden' value='{" + siteSurveyor.getNric() + "|" + siteSurveyor.toString() + "|" + timing + "}'></td>");
                                                } else {
                                                    out.println("<td></td>");
                                                }
                                            } else {
                                                boolean taken = false;
                                                SiteSurvey ss = null;
                                                String status = "";
                                                for (SiteSurvey survey : surveys) {
                                                    taken = survey.checkTaken(timing);
                                                    if (taken) {
                                                        status = survey.getStatus();
                                                        ss = survey;
                                                        break;
                                                    }
                                                }
                                                if (taken && !status.equals("Cancelled")) {
                                                    out.println("<td class='occupied tooltipp' data-state='occupied'><input type='hidden' value='{" + siteSurveyor.getNric() + "|" + siteSurveyor.toString() + "|" + timing + "}'>");
                                    %>
                                <table class='tooltiptextt' width="100%">
                                    <tr>
                                        <td align="right">Lead ID :</td>
                                        <td><%=ss.getLead()%></td>
                                    </tr>
                                    <tr>
                                        <td align="right">Address :</td>
                                        <td>
                                            <%
                                                String ssAdd = ss.getAddress();
                                                String showAdd = ssAdd;
                                                for (SiteSurvey survey : surveys) {
                                                    if (!survey.getAddress().equals(ssAdd) && survey.checkTaken(timing)) {
                                                        showAdd += "<br>" + survey.getAddress();
                                                    }
                                                }
                                            %>
                                            <input type="hidden" name="surveyors_addresses" value="<%=siteSurveyor%>|<%=showAdd%>|<%=ss.getTimeSlots()%>|<%=ss.getLead()%>"><%=showAdd%></td>
                                    </tr>
                                </table>
                                <%
                                                out.println("</td>");
                                            } else {
                                                if (!addresses.isEmpty()) {
                                                    out.println("<td onclick='selectSlot(this)'");
                                                    if (siteSurveyor.getNric().equals(nric) && timeslots.contains(timing) && !status.equals("Cancelled")) {
                                                        out.println("class='selected' data-state='selected'");
                                                    }
                                                    out.println("><input type='hidden' value='{" + siteSurveyor.getNric() + "|" + siteSurveyor.toString() + "|" + timing + "}'></td>");
                                                } else {
                                                    out.println("<td></td>");
                                                }
                                            }
                                        }
                                    }
                                %>
                                </tr>
                                <%
                                    }
                                %>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
        </td>
        <td>
            <table width="100%">
                <col width="50%">
                <col width="50%">
                <tr>
                    <td align="center" colspan="2"  style="vertical-align: top;">
                        <button class="btn btn-border btn-alt border-blue-alt btn-link font-blue-alt glyph-icon icon-exchange" style="width:100%" onclick="toggleView();
                                return false;"> &nbsp; &nbsp;Toggle
                        </button>
                        <%
                            if (addresses.isEmpty()) {
                                out.println("<br><br>Please input at least one address.");
                            }
                        %>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td colspan="2"  style="vertical-align: top;">
                        <div id="mapInput" style="display:none;">
                            <%
                                if (!addresses.isEmpty()) {
                            %>
                            <table width="100%">
                                <col width="80">
                                <tr>
                                    <td align="right"><b>Surveyor :</b></td>
                                    <td>
                                        <select id="surveyor_select">
                                            <option value="">--Select--</option>
                                            <%
                                                for (User siteSurveyor : siteSurveyors) {
                                                    if (selected != null) {
                                                        out.println("<option value='" + siteSurveyor.getNric() + "|" + siteSurveyor + "' ");
                                                        if (selected.getNric().equals(siteSurveyor.getNric())) {
                                                            out.println("selected");
                                                        }
                                                        out.println(">" + siteSurveyor + "</option>");
                                                    } else {
                                                        out.println("<option value='" + siteSurveyor.getNric() + "|" + siteSurveyor + "'>" + siteSurveyor + "</option>");
                                                    }
                                                }
                                            %>
                                        </select>
                                        <button onclick="selectSurveyor();
                                                return false;">Select</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right"><b>Time Slot :</b></td>
                                    <td>
                                        <select id="timeslot">
                                            <option value="">--Select--</option>
                                            <%
                                                for (String timing : timings) {
                                                    out.println("<option value='" + timing + "'>" + timing + "</option>");
                                                }
                                            %>
                                        </select>
                                        <button onclick="selectTimeSlot();
                                                return false;">+</button>
                                    </td> 
                                </tr>
                            </table>
                            <%
                                }
                            %>
                        </div>
                    </td>
                    <td></td>
                </tr>
                <%
                    if (!addresses.isEmpty()) {
                %>
                <tr>
                    <td align="right" style="vertical-align: top;"><b>Address :</b></td>
                    <td>
                        <select id="address_select">
                            <option value="">--Select--</option>
                            <%
                                for (String address : addresses) {
                                    out.println("<option value='" + address + "'>" + address + "</option>");
                                }
                            %>
                        </select>
                        <button onclick="addAddress();
                                return false;">+</button>
                    </td>
                </tr>
                <tr>
                    <td align="right"><b>Date :</b></td>
                    <td><%=dateString%><input type="hidden" id="survey_date" value="<%=dateString%>"></td>
                </tr>
                <tr>
                    <td align="right"><b>Time Slot :</b></td>
                    <td>
                        <table id="timeslot_table">
                            <tbody>
                                <%
                                    if (timeslotArray != null) {
                                        for (int i = 0; i < timeslotArray.length; i++) {
                                            out.println("<tr data-value='{" + nric + "|" + selected + "|" + timeslotArray[i] + "}'><td>" + timeslotArray[i] + "<input type='hidden' name='timeslot' value='" + timeslotArray[i] + "'></td>");
                                            out.println("<td><input type='button' value='x' onclick='deleteSurveyRow(this)'/></td></tr>");
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="right"><b>Surveyor :</b></td>
                    <td><input type="hidden" id="surveyor" <%if (!nric.isEmpty()) {
                            out.println("value='" + nric + "'");
                        }%>>
                        <input type="hidden" id="surveyor_name" <%if (selected != null) {
                                out.println("value='" + selected.toString() + "'");

                            }%>>
                        <label id="surveyor_label"><%if (selected != null) {
                                out.println(selected);
                            }%></label></td>
                </tr>
                <tr>
                    <td align="right"><b>Address :</b></td>
                    <td>
                        <table id="address_table">
                            <tbody>
                                <%
                                    if (addArray != null) {
                                        for (int i = 0; i < addArray.length; i++) {
                                            out.println("<tr><td>" + addArray[i] + "<input type='hidden' name='site_address' value='" + addArray[i] + "'></td>");
                                            out.println("<td><input type='button' value='x' onclick='deleteAddressRow(this)'/></td></tr>");
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="right"><b>Remarks :</b></td>
                    <td>
                        <textarea id="site_remarks"><%if (remarks != null) {
                                out.println(remarks);
                            }%></textarea>
                    </td>
                </tr>
                <tr>
                    <td align="center" colspan="2"><button style="width:100%" onclick="assignSiteSurveyor();
                            return false;">Assign!</button></td>
                </tr>
                <%
                    }
                %>
            </table>
        </td>
    </tr>
</table>