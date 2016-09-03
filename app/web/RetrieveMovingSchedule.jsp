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
    DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd");
    String dateString = request.getParameter("date");
    
    String truucks = request.getParameter("truck");
    ArrayList<Truck> trucks = new ArrayList<Truck>();
    if (truucks.equals("alltt")) {
        trucks = TruckDAO.getAllTrucks();
    } else {
        trucks.add(TruckDAO.getTruckByCarplate(truucks));
    }
    
    
    String[] timings = new String[]{"0900 - 0930", "0930 - 1000", "1000 - 1030", "1030 - 1100", "1100 - 1130", "1130 - 1200", "1200 - 1230", "1230 - 1300", "1300 - 1330", "1330 - 1400", "1400 - 1430", "1430 - 1500", "1500 - 1530", "1530 - 1600", "1600 - 1630", "1630 - 1700", "1700 - 1730", "1730 - 1800"};
    ArrayList<String> addressesFrom = new ArrayList<String>();
    ArrayList<String> addressesTo = new ArrayList<String>();
    String fr = request.getParameter("addressFrom");
    String tot = request.getParameter("addressTo");
    String[] addressesFromArr = fr.split("\\|");
    String[] addressesToArr = tot.split("\\|");

    if (addressesFromArr.length > 1) {
        for (int i = 0; i < addressesFromArr.length; i += 4) {
            addressesFrom.add(addressesFromArr[i] + " #" + addressesFromArr[i + 1] + "-" + addressesFromArr[i + 2] + " S" + addressesFromArr[i + 3]);
        }
    }
    if (addressesToArr.length > 1) {
        for (int i = 0; i < addressesToArr.length; i += 4) {
            addressesTo.add(addressesToArr[i] + " #" + addressesToArr[i + 1] + "-" + addressesToArr[i + 2] + " S" + addressesToArr[i + 3]);
        }
    }

    String leadId = request.getParameter("leadId");
    String carplates = request.getParameter("carplate");
    String timeslots = request.getParameter("timeslots");
    String selectedAddsFrom = request.getParameter("addressesFr");
    String selectedAddsTo = request.getParameter("addressesTo");
    String remarks = request.getParameter("remarks");
    
    ArrayList<String> selecteds = new ArrayList<String>();
    String[] carplatesArray = carplates.split("\\|");
    for(String cp : carplatesArray){
        if(!cp.isEmpty())selecteds.add(cp);
    }
    
    String[] addFrArray = null;
    String[] addToArray = null;
    HashMap<String, ArrayList<String>> timeslotHM = null;
    if (!selecteds.isEmpty()) {
        addFrArray = selectedAddsFrom.split("\\|");
        addToArray = selectedAddsTo.split("\\|");
        timeslotHM = new HashMap<String, ArrayList<String>>();
        String[] timeslotArray = timeslots.split("\\|");
        for(String cp : selecteds){
            ArrayList<String> list = new ArrayList<String>();
            for(String tsa: timeslotArray){
                if(tsa.contains(cp)){
                    list.add(tsa.split("_")[1]);
                }
            }
            timeslotHM.put(cp, list);
        }
        
    }
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
                                                if (!fr.isEmpty() && !tot.isEmpty()) {
                                                    out.println("<td onclick='selectDOMSlot(this)'");
                                                    
                                                    if (selecteds.contains(truck.getCarplateNo()) && timeslots.contains(truck.getCarplateNo() + "_" + timing)) {
                                                        out.println("class='selected' data-state='selected'");
                                                    }
                                                    out.println("><input type='hidden' value='{" + truck.getCarplateNo() + "|" + truck.toString() + "|" + timing + "}'></td>");
                                                } else {
                                                    out.println("<td></td>");
                                                }
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
                                                if (taken){
                                                    HashMap<String, String> addresses = jb.getAddresses();
                                                    ArrayList<String> from = new ArrayList<String>();
                                                    ArrayList<String> to = new ArrayList<String>();
                                                    for (Map.Entry<String, String> entry : addresses.entrySet()) {
                                                        String key = entry.getKey();
                                                        String value = entry.getValue();
                                                        if(value.equals("from")){
                                                            from.add(key);
                                                        }else{
                                                            to.add(key);
                                                        }
                                                    }
                                                    
                                                    if(status.equals("Confirmed")) {
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
                                                    }else{
                                                        out.println("<td class='tooltipp' data-state='' onclick='selectDOMSlot(this)'");
                                                        if (selecteds.contains(truck.getCarplateNo()) && timeslots.contains(truck.getCarplateNo() + "_" + timing)) {
                                                            out.println("class='selected' data-state='selected'");
                                                        }
                                                        out.println("><input type='hidden' value='{" + truck.getCarplateNo() + "|" + truck.toString() + "|" + timing + "}'>");
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
                                                    if (!fr.isEmpty() && !tot.isEmpty()) {
                                                        out.println("<td onclick='selectDOMSlot(this)'");
                                                        if (selecteds.contains(truck.getCarplateNo()) && timeslots.contains(truck.getCarplateNo() + "_" + timing)) {
                                                            out.println("class='selected' data-state='selected'");
                                                        }
                                                        out.println("><input type='hidden' value='{" + truck.getCarplateNo() + "|" + truck.toString() + "|" + timing + "}'></td>");
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
                <%
                    if (!fr.isEmpty() && !tot.isEmpty()) {
                %>
                <tr>
                    <td>
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label class="col-sm-4 control-label">From: </label>
                                <div class="col-sm-6">
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
                                            <button class="btn btn-default" onclick="addMoveFrAddress();
                                                    return false;">+</button>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">To: </label>
                                <div class="col-sm-6">
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
                                            <button class="btn btn-default" onclick="addMoveToAddress();
                                                    return false;">+</button>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">Date: </label>
                                <div class="col-sm-6">
                                    <%=dateString%><input type="hidden" id="move_date" value="<%=dateString%>">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">Truck(s) assigned: </label>
                                <table id="truck_assigned_table" width="100%">
                                    <tbody>
                                        <%
                                            for(String cp : selecteds){
                                                Truck truck = TruckDAO.getTruckByCarplate(cp);
                                        %>
                                        <tr id="<%=cp%>">
                                            <td>
                                                <input type="hidden" name="move_carplates" value="<%=cp%>">
                                                <input type="hidden" name="move_truck_name" value="<%=truck%>">
                                                <label name="truck_label"><%=truck%></label>
                                            </td>
                                            <td>
                                                <table id="<%=cp%>_timeslot_table">
                                                    <tbody>
                                                        <%
                                                            ArrayList<String> list = timeslotHM.get(cp);
                                                            for (int i = 0; i < list.size(); i++) {
                                                                String li = list.get(i);
                                                        %>
                                                        <tr data-value='{<%=cp%>|<%=truck%>|<%=li%>}'>
                                                            <td><%=li%><input type='hidden' name='<%=cp%>_move_timeslot' value='<%=li%>'></td>
                                                            <td><input type='button' value='x' class='form-control' onclick='deleteMoveTimeRow(this)'/></td>
                                                        </tr>
                                                        <%
                                                            }
                                                        %>
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                        <%
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">From: </label>
                                <div class="col-sm-6">
                                    <table id="move_addressFrom_table">
                                        <tbody>
                                            <%
                                                if (addFrArray != null) {
                                                    for (int i = 0; i < addFrArray.length; i++) {
                                                        out.println("<tr><td>" + addFrArray[i] + "<input type='hidden' name='move_addressFrom' value='" + addFrArray[i] + "'></td>");
                                                        out.println("<td><input type='button' value='x' class='form-control' onclick='deleteAddressRow(this)'/></td></tr>");
                                                    }
                                                }
                                            %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">To: </label>
                                <div class="col-sm-6">
                                    <table id="move_addressTo_table">
                                        <tbody>
                                            <%
                                                if (addToArray != null) {
                                                    for (int i = 0; i < addToArray.length; i++) {
                                                        out.println("<tr><td>" + addToArray[i] + "<input type='hidden' name='move_addressTot' value='" + addToArray[i] + "'></td>");
                                                        out.println("<td><input type='button' value='x' class='form-control' onclick='deleteAddressRow(this)'/></td></tr>");
                                                    }
                                                }
                                            %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">Remarks: </label>
                                <div class="col-sm-6">
                                        <textarea class="form-control" id="move_remarks"><%if (remarks != null) {
                                            out.println(remarks);
                                        }%></textarea>
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td align="center" colspan="2"><button style="width:100%" onclick="assignDOM();
                            return false;">Select Timeslot!</button></td>
                </tr>
                <%
                    }
                %>
            </table>
        </td>
    </tr>
</table>
