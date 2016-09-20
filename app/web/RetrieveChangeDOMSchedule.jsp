<%@page import="com.vimbox.sales.Lead"%>
<%@page import="com.vimbox.database.LeadDAO"%>
<%@page import="com.vimbox.operations.Truck"%>
<%@page import="com.vimbox.database.TruckDAO"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.vimbox.database.JobDAO"%>
<%@page import="com.vimbox.operations.Job"%>
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
    String details = request.getParameter("details");
    String[] detailsArr = details.split("\\|");
    // 0 - leadId | 1 - date | 2 - timeslot | 3 - status //
    int leadId = Integer.parseInt(detailsArr[0]);
    Lead lead = LeadDAO.getLeadById(leadId);

    ArrayList<String[]> addressesFromArr = lead.getAddressFrom();
    ArrayList<String> addressesFrom = new ArrayList<String>();
    for (String[] arr : addressesFromArr) {
        String[] add = arr[0].split("_");
        addressesFrom.add(add[0] + " #" + add[1] + "-" + add[2] + " S" + add[3]);
    }

    ArrayList<String[]> addressesToArr = lead.getAddressTo();
    ArrayList<String> addressesTo = new ArrayList<String>();
    for (String[] arr : addressesToArr) {
        String[] add = arr[0].split("_");
        addressesTo.add(add[0] + " #" + add[1] + "-" + add[2] + " S" + add[3]);
    }

    String dateString = request.getParameter("date");
    String trucksStr = request.getParameter("truck");
    ArrayList<Truck> trucks = new ArrayList<Truck>();
    if (trucksStr.equals("alltt")) {
        trucks = TruckDAO.getAllTrucks();
    } else {
        trucks.add(TruckDAO.getTruckByCarplate(trucksStr));
    }

    String[] timings = new String[]{"0900 - 0930", "0930 - 1000", "1000 - 1030", "1030 - 1100", "1100 - 1130", "1130 - 1200", "1200 - 1230", "1230 - 1300", "1300 - 1330", "1330 - 1400", "1400 - 1430", "1430 - 1500", "1500 - 1530", "1530 - 1600", "1600 - 1630", "1630 - 1700", "1700 - 1730", "1730 - 1800"};
%>

<h2>Schedule for <%=dateString%></h2><hr>
<table width="100%">
    <tr>
        <td>
            <table width="100%">
                <tr>
                    <td style="vertical-align: top;">
                        <div id="tableForm">
                            <table width="100%" class="table table-bordered" id="moving_table">
                                <tr>
                                    <th></th>
                                        <%
                                            for (String timing : timings) {
                                                out.println("<th>" + timing + "</th>");
                                            }
                                        %>
                                </tr>
                                <%
                                    for (Truck truck : trucks) {
                                        ArrayList<Job> jobs = JobDAO.getJobsByTruckDate(truck.getCarplateNo(), dateString);
                                %>
                                <tr>
                                    <td><%=truck%></td>
                                    <%
                                        for (String timing : timings) {
                                            if (jobs.isEmpty()) {
                                                out.println("<td onclick='selectDOMSlot(this)'><input type='hidden' value='{" + truck.getCarplateNo() + "|" + truck.toString() + "|" + timing + "}'></td>");
                                            } else {
                                                boolean taken = false;
                                                Job jb = null;
                                                String status = "";
                                                for (Job job : jobs) {
                                                    taken = job.checkTaken(timing);
                                                    if (taken) {
                                                        status = job.getStatus();
                                                        jb = job;
                                                        break;
                                                    }
                                                }
                                                if (taken) {
                                                    HashMap<String, String> addresses = jb.getAddresses();
                                                    ArrayList<String> from = new ArrayList<String>();
                                                    ArrayList<String> to = new ArrayList<String>();
                                                    for (Map.Entry<String, String> entry : addresses.entrySet()) {
                                                        String key = entry.getKey();
                                                        String value = entry.getValue();
                                                        if (value.equals("from")) {
                                                            from.add(key);
                                                        } else {
                                                            to.add(key);
                                                        }
                                                    }

                                                    if (status.equals("Confirmed")) {
                                                        out.println("<td class='occupied tooltipp' data-state='occupied'><input type='hidden' value='{" + truck.getCarplateNo() + "|" + truck.toString() + "|" + timing + "}'>");
                                    %>
                                <table class='tooltiptextt' width="100%">
                                    <tr>
                                        <td align="right">Lead ID :</td>
                                        <td><%=jb.getLeadId()%></td>
                                    </tr>
                                    <tr>
                                        <td align="right">Status :</td>
                                        <td><%=status%></td>
                                    </tr>
                                    <tr>
                                        <td align="right">From :</td>
                                        <td>
                                            <%
                                                for (String addr : from) {
                                                    out.println("<li>" + addr + "</li>");
                                                }
                                            %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">To :</td>
                                        <td>
                                            <%
                                                for (String addr : to) {
                                                    out.println("<li>" + addr + "</li>");
                                                }
                                            %>
                                        </td>
                                    </tr>
                                </table>
                                <%
                                    out.println("</td>");
                                } else {
                                    out.println("<td class='tooltipp' data-state='' bgcolor='orange' onclick='selectDOMSlot(this)'><input type='hidden' value='{" + truck.getCarplateNo() + "|" + truck.toString() + "|" + timing + "}'>");
                                %>
                                <table class='tooltiptextt' width="100%">
                                    <tr>
                                        <td align="right">Lead ID :</td>
                                        <td><%=jb.getLeadId()%></td>
                                    </tr>
                                    <tr>
                                        <td align="right">Status :</td>
                                        <td><%=status%></td>
                                    </tr>
                                    <tr>
                                        <td align="right">From :</td>
                                        <td>
                                            <%
                                                for (String addr : from) {
                                                    out.println("<li>" + addr + "</li>");
                                                }
                                            %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">To :</td>
                                        <td>
                                            <%
                                                for (String addr : to) {
                                                    out.println("<li>" + addr + "</li>");
                                                }
                                            %>
                                        </td>
                                    </tr>
                                </table>
                                <%
                                                    out.println("</td>");
                                                }
                                            } else {
                                                out.println("<td onclick='selectDOMSlot(this)'><input type='hidden' value='{" + truck.getCarplateNo() + "|" + truck.toString() + "|" + timing + "}'></td>");
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
    </tr>
    <tr>
        <td>

            <table width="100%">
                <tr>
                    <td>
                        <form class='form-horizontal' method="POST" action="ChangeDomController" id="change_dom_form">
                            <input type="hidden" name="details" value="<%=details%>">
                            <div class="form-horizontal">
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">From: </label>
                                    <div class="col-sm-4">
                                        <div class="input-group">
                                            <select id="move_addressFrom_select" class="form-control">
                                                <option value="">--Select--</option>
                                                <%
                                                    for (String address : addressesFrom) {
                                                        out.println("<option value='" + address + "'>" + address + "</option>");
                                                    }
                                                %>
                                            </select>
                                            <span class="input-group-btn">
                                                <button class="btn btn-round btn-primary" onclick="addMoveFrAddress();
                                                        return false;">+</button>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">To: </label>
                                    <div class="col-sm-4">
                                        <div class="input-group">
                                            <select id="move_addressTo_select" class="form-control">
                                                <option value="">--Select--</option>
                                                <%
                                                    for (String address : addressesTo) {
                                                        out.println("<option value='" + address + "'>" + address + "</option>");
                                                    }
                                                %>
                                            </select>
                                            <span class="input-group-btn">
                                                <button class="btn btn-round btn-primary" onclick="addMoveToAddress();
                                                        return false;">+</button>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">Date: </label>
                                    <div class="col-sm-4">
                                        <span class="form-control"><%=dateString%></span>
                                        <input type="hidden" name="move_date" value="<%=dateString%>">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">Truck(s) assigned: </label>
                                    <div class="col-sm-4">
                                        <table id="truck_assigned_table" width="100%">
                                            <tbody>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">From: </label>
                                    <div class="col-sm-4">
                                        <table id="move_addressFrom_table">
                                            <tbody>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">To: </label>
                                    <div class="col-sm-4">
                                        <table id="move_addressTo_table">
                                            <tbody>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">Remarks: </label>
                                    <div class="col-sm-4">
                                        <textarea class="form-control" name="move_remarks"></textarea>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label"> </label>
                                    <div class="col-sm-4 text-center">
                                        <button type="submit" data-loading-text="Loading..." class="btn loading-button btn-primary">Change</button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
