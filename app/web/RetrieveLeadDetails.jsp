<%@page import="com.vimbox.operations.Job"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.vimbox.sitesurvey.SiteSurvey"%>
<%@page import="com.vimbox.sales.LeadDiv"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.vimbox.sales.Item"%>
<%@page import="com.vimbox.customer.Customer"%>
<%@page import="com.vimbox.sales.Lead"%>
<%@page import="com.vimbox.database.LeadDAO"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="java.util.ArrayList"%>
<%
    String leadId = request.getParameter("getLid");
    Lead lead = LeadDAO.getLeadById(Integer.parseInt(leadId));
    DecimalFormat df = new DecimalFormat("#,##0.00");
%>

<div class="form-horizontal" style="font-size: 14px; font-color: black;">
    <div class="form-group">
        <label class="col-sm-2 control-label">Status: </label>
        <label class="col-sm-4" style="padding-top: 7px;">
            <%=lead.getStatus()%>
        </label>
    </div>
    <%
        if (lead.getStatus().equals("Rejected")) {%>
    <div class="form-group">
        <label class="col-sm-2 control-label">Rejection Reason: </label>
        <label class="col-sm-4" style="padding-top: 7px;">
            <%=lead.getReason()%>
        </label>
    </div>
    <%}%>
</div>
<hr>
<div class="form-horizontal" style="font-size: 14px;">
    <div class="form-group">
        <div class="col-sm-6">
            <h3 class="mrg10A">Customer Information </h3>
        </div>
        <div class="col-sm-5">
            <h3 class="mrg10A">Lead Information </h3>
        </div>
    </div>
    <%
        Customer customer = lead.getCustomer();
        if (customer != null) {%>
    <div class="form-group">
        <label class ="col-sm-2 control-label">Name: </label>
        <div class ="col-sm-4" style="padding-top: 7px;">
            <%=customer.toString()%>
        </div>
        <label class ="col-sm-2 control-label">Lead ID: </label>
        <div class ="col-sm-4" style="padding-top: 7px;">
            <%=lead.getId()%>
        </div>
    </div>
    <div class="form-group">
        <label class ="col-sm-2 control-label">Contact: </label>
        <div class ="col-sm-4" style="padding-top: 7px;">
            <%=customer.getContact()%>
        </div>
        <label class ="col-sm-2 control-label">Lead Type: </label>
        <div class ="col-sm-4" style="padding-top: 7px;">
            <%
                String[] leadTypes = lead.getType().split("\\|");
                for (int i = 0;
                        i < leadTypes.length;
                        i++) {
                    String leadType = leadTypes[i];
                    out.println(leadType);
                    if (i < leadTypes.length - 1) {
                        out.println(", ");
                    }
                }
            %>
        </div>
    </div>
    <div class="form-group">
        <label class ="col-sm-2 control-label">Email: </label>
        <div class ="col-sm-4" style="padding-top: 7px;">
            <%=customer.getEmail()%>
        </div>
        <label class ="col-sm-2 control-label">Referral: </label>
        <div class ="col-sm-4" style="padding-top: 7px;">
            <%=lead.getReferral()%>
        </div>
    </div>
    <%}%>
</div>
<hr>
<div class="form-horizontal" style="font-size: 14px;">
    <div class="form-group">
        <div class="col-sm-6">
            <h3 class="mrg10A">Moving Information</h3>
        </div>
    </div>
    <div class="form-group">
        <label class ="col-sm-3 control-label">Moving From: </label>
        <div class ="col-sm-8" style="padding-top: 7px;">
            <%
                ArrayList<String[]> movingFroms = lead.getAddressFrom();
                for (int i = 0;
                        i < movingFroms.size();
                        i++) {
                    String[] movingFrom = movingFroms.get(i);
                    String address = movingFrom[0];
                    if (!address.isEmpty()) {
                        String[] addressDetails = address.split("_");
                        out.println("<li>");
                        out.println("Address " + (i + 1) + " : " + addressDetails[0] + " #" + addressDetails[1] + "-" + addressDetails[2] + " S" + addressDetails[3]);
                        out.println("</li>");
                    }
                }
            %>
        </div>
    </div>
    <div class="form-group">
        <label class ="col-sm-3 control-label">Moving To: </label>
        <div class ="col-sm-8" style="padding-top: 7px;">
            <%
                ArrayList<String[]> movingTos = lead.getAddressTo();
                for (int i = 0;
                        i < movingTos.size();
                        i++) {
                    String[] movingTo = movingTos.get(i);
                    String address = movingTo[0];
                    if (!address.isEmpty()) {
                        String[] addressDetails = address.split("_");
                        out.println("<li>");
                        out.println("Address " + (i + 1) + " : " + addressDetails[0] + " #" + addressDetails[1] + "-" + addressDetails[2] + " S" + addressDetails[3]);
                        out.println("</li>");
                    }
                }
            %>
        </div>
    </div>
    <div class="form-group">
        <label class ="col-sm-3 control-label">Move Type: </label>
        <div class ="col-sm-8" style="padding-top: 7px;">
            <%
                String[] toms = lead.getTom().split("\\|");
                for (int i = 0;
                        i < toms.length;
                        i++) {
                    String tom = toms[i];
                    out.println(tom);
                    if (i < toms.length - 1) {
                        out.println(", ");
                    }
                }
            %>
        </div>
    </div>
    <div class="form-horizontal" style="font-size: 14px;">
        <div class="form-group">
            <div class="col-sm-6">
                <h4 class="mrg10A">Moving Details</h4>
            </div>
        </div>
    <%
            ArrayList<Job> jobs = lead.getJobs();
            String jj = "";
            String jLead = "";
            String jRem = "";
            String jStatus = "";
            HashMap<String, String> timeslot = new HashMap<String, String>();
            ArrayList<String> addressesFr = new ArrayList<String>();
            ArrayList<String> addressesTo = new ArrayList<String>();
            for (int i = 0; i < jobs.size(); i++) {
                Job job = jobs.get(i);
                String truck = job.getAssignedTruck() + "";
                String nextLeadId = job.getLeadId() + "";
                String nextTimeslot = job.getTimeslots();
                String rem = job.getRemarks();
                String j = job.getDate();
                if (i == 0) {
                    jj = j;
                    jLead = nextLeadId;
                    timeslot.put(truck, nextTimeslot);
                    jRem = rem;
                    jStatus = job.getStatus();
                }

                if (!j.equals(jj) || !nextLeadId.equals(jLead)) {%>
        <div class="form-group">
            <label class ="col-sm-3 control-label">Date: </label>
            <div class ="col-sm-8" style="padding-top: 7px;">
                <%=jj%>
            </div>
        </div>
        <div class="form-group">
            <label class ="col-sm-3 control-label">Timeslot: </label>
            <div class ="col-sm-8" style="padding-top: 7px;">
                <%=timeslot%>
            </div>
        </div>
        <div class="form-group">
            <label class ="col-sm-3 control-label">From: </label>
            <div class ="col-sm-8" style="padding-top: 7px;">
                <%
                    for (String add : addressesFr) {
                        out.println("<li>" + add + "</li>");
                    }
                %>
            </div>
        </div>
        <div class="form-group">
            <label class ="col-sm-3 control-label">To: </label>
            <div class ="col-sm-8" style="padding-top: 7px;">
                <%
                    for (String add : addressesTo) {
                        out.println("<li>" + add + "</li>");
                    }
                %>
            </div>
        </div>
        <div class="form-group">
            <label class ="col-sm-3 control-label">Remarks: </label>
            <div class ="col-sm-8" style="padding-top: 7px;">
                <%=jRem%>
            </div>
        </div>
        <div class="form-group">
            <label class ="col-sm-3 control-label">Status: </label>
            <div class ="col-sm-8" style="padding-top: 7px;">
                <%=jStatus%>
            </div>
        </div>

        <%
                jj = j;
                jLead = nextLeadId;
                timeslot = new HashMap<String, String>();
                timeslot.put(truck, nextTimeslot);
                jStatus = job.getStatus();
                addressesFr = new ArrayList<String>();
                addressesTo = new ArrayList<String>();
            }
                
            timeslot.put(truck, nextTimeslot);
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
            
            if (i == jobs.size() - 1) {%>
        <div class="form-group">
            <label class ="col-sm-3 control-label">Date: </label>
            <div class ="col-sm-8" style="padding-top: 7px;">
                <%=jj%>
            </div>
        </div>
        <div class="form-group">
            <label class ="col-sm-3 control-label">Timeslot: </label>
            <table>
                <%
                    for (Map.Entry<String, String> entry : timeslot.entrySet()) {
                        String cp = entry.getKey();
                        String ts = entry.getValue();
                        out.println("<tr><td>" + cp + "</td>");
                        out.println("<td>" + ts + "</td></tr>");
                    }
                %>
            </table>
        </div>
        <div class="form-group">
            <label class ="col-sm-3 control-label">From: </label>
            <div class ="col-sm-8" style="padding-top: 7px;">
                <%
                    for (String add : addressesFr) {
                        out.println("<li>" + add + "</li>");
                    }
                %>
            </div>
        </div>
        <div class="form-group">
            <label class ="col-sm-3 control-label">To: </label>
            <div class ="col-sm-8" style="padding-top: 7px;">
                <%
                    for (String add : addressesTo) {
                        out.println("<li>" + add + "</li>");
                    }
                %>
            </div>
        </div>
        <div class="form-group">
            <label class ="col-sm-3 control-label">Remarks: </label>
            <div class ="col-sm-8" style="padding-top: 7px;">
                <%=jRem%>
            </div>
        </div>
        <div class="form-group">
            <label class ="col-sm-3 control-label">Status: </label>
            <div class ="col-sm-8" style="padding-top: 7px;">
                <%=jStatus%>
            </div>
        </div>
        <%
                }
            }
        %>

    </div>
</div>
<%
    if (lead.getType()
            .contains("Enquiry")) {
%>
<hr>
<div class="form-horizontal" style="font-size: 14px;">
    <div class="form-group">
        <div class="col-sm-6">
            <h3 class="mrg10A">Enquiry Information</h3>
        </div>
    </div>
    <div class="form-group">
        <label class ="col-sm-3 control-label">Enquiry: </label>
        <div class ="col-sm-8" style="padding-top: 7px;">
            <%=lead.getEnquiry()%>
        </div>
    </div>
</div>
<%
    }
%>
<table width='100%'>

    <%
        if (lead.getType()
                .contains("Sales")) {
    %>
    <hr>
    <div class="form-horizontal" style="font-size: 14px;">
        <div class="form-group">
            <div class="col-sm-6">
                <h3 class="mrg10A">Sales Information</h3>
            </div>
        </div>
    </div>
    <div class="form-horizontal" style="font-size: 14px;">
        <div class="form-group">
            <div class="col-sm-6">
                <h4 class="mrg10A">Site Survey Details</h4>
            </div>
        </div>
        <%
            ArrayList<SiteSurvey> surveys = lead.getSiteSurveys();
            String ss = "";
            String sId = "";
            String sName = "";
            String sRem = "";
            String sStatus = "";
            String sTimeslot = "";
            ArrayList<String> addresses = new ArrayList<String>();
            for (int i = 0; i < surveys.size(); i++) {
                SiteSurvey survey = surveys.get(i);
                String s = survey.getDate();
                if (i == 0) {
                    ss = s;
                    sId = survey.getSiteSurveyor().getNric();
                    sName = survey.getSiteSurveyor().toString();
                    sRem = survey.getRemarks();
                    sStatus = survey.getStatus();
                    sTimeslot = survey.getTimeSlots();
                }

                if (!s.equals(ss)) {%>
        <div class="form-group">
            <label class ="col-sm-3 control-label">Date: </label>
            <div class ="col-sm-8" style="padding-top: 7px;">
                <%=ss%>
            </div>
        </div>
        <div class="form-group">
            <label class ="col-sm-3 control-label">Timeslot: </label>
            <div class ="col-sm-8" style="padding-top: 7px;">
                <%=sTimeslot%>
            </div>
        </div>
        <div class="form-group">
            <label class ="col-sm-3 control-label">Address: </label>
            <div class ="col-sm-8" style="padding-top: 7px;">
                <%
                    for (int j = 0; j < addresses.size(); j++) {
                        out.println("<li>" + addresses.get(j) + "</li>");
                    }
                %>
            </div>
        </div>
        <div class="form-group">
            <label class ="col-sm-3 control-label">Surveyor: </label>
            <div class ="col-sm-8" style="padding-top: 7px;">
                <%=sName%>
            </div>
        </div>
        <div class="form-group">
            <label class ="col-sm-3 control-label">Remarks: </label>
            <div class ="col-sm-8" style="padding-top: 7px;">
                <%=sRem%>
            </div>
        </div>
        <div class="form-group">
            <label class ="col-sm-3 control-label">Status: </label>
            <div class ="col-sm-8" style="padding-top: 7px;">
                <%=sStatus%>
            </div>
        </div>

        <%
                ss = s;
                sId = survey.getSiteSurveyor().getNric();
                sName = survey.getSiteSurveyor().toString();
                sRem = survey.getRemarks();
                sStatus = survey.getStatus();
                sTimeslot = survey.getTimeSlots();
                addresses = new ArrayList<String>();
            }

            if (!addresses.contains(survey.getAddress())) {
                addresses.add(survey.getAddress());
            }
            if (i == surveys.size() - 1) {%>
        <div class="form-group">
            <label class ="col-sm-3 control-label">Date: </label>
            <div class ="col-sm-8" style="padding-top: 7px;">
                <%=ss%>
            </div>
        </div>
        <div class="form-group">
            <label class ="col-sm-3 control-label">Timeslot: </label>
            <div class ="col-sm-8" style="padding-top: 7px;">
                <%=sTimeslot%>
            </div>
        </div>
        <div class="form-group">
            <label class ="col-sm-3 control-label">Address: </label>
            <div class ="col-sm-8" style="padding-top: 7px;">
                <%
                    for (int j = 0; j < addresses.size(); j++) {
                        out.println("<li>" + addresses.get(j) + "</li>");
                    }
                %>
            </div>
        </div>
        <div class="form-group">
            <label class ="col-sm-3 control-label">Surveyor: </label>
            <div class ="col-sm-8" style="padding-top: 7px;">
                <%=sName%>
            </div>
        </div>
        <div class="form-group">
            <label class ="col-sm-3 control-label">Remarks: </label>
            <div class ="col-sm-8" style="padding-top: 7px;">
                <%=sRem%>
            </div>
        </div>
        <div class="form-group">
            <label class ="col-sm-3 control-label">Status: </label>
            <div class ="col-sm-8" style="padding-top: 7px;">
                <%=sStatus%>
            </div>
        </div>
        <%
                }
            }
        %>

    </div>
    <hr>
    <div class="form-horizontal" style="font-size: 14px;">
        <div class="form-group">
            <div class="col-sm-6">
                <h4 class="mrg10A">Sales Details</h4>
            </div>
        </div>
    </div>
    <table width='100%'>
        <tr>
            <td colspan="2">
                <fieldset>
                    <table width="100%">
                        <tr>
                            <td>
                                <!-- Sales -->
                                <ul class="tab" id="sales_list">
                                    <%
                                        ArrayList<LeadDiv> leadDivs = lead.getSalesDivs();
                                         out.println(" <ul class='nav-responsive nav nav-tabs'>");
                                        for (LeadDiv leadDiv : leadDivs) {
                                            String leadDivStr = leadDiv.getSalesDiv();
                                            String leadDivId = leadDivStr.substring(0, leadDivStr.indexOf("|"));
                                            String leadDivAddr = leadDivStr.substring(leadDivStr.indexOf("|") + 1);
                                           
                                            out.println("<li><a data-toggle='tab' href='#' class='tablinks' onclick=\"openSales(event, '" + leadDivId + "')\"><label>" + leadDivAddr + "</label></a></li>");
                                            
                                        }
                                        out.println("</ul>");
                                    %>
                                </ul>

                                <%
                                    double overall = 0;
                                    for (LeadDiv leadDiv : leadDivs) {
                                        String leadDivStr = leadDiv.getSalesDiv();
                                        String leadDivId = leadDivStr.substring(0, leadDivStr.indexOf("|"));
                                        double sum = 0;
                                %>
                                <div id="<%=leadDivId%>" class="tabcontent">
                                    <table width="100%"  bordercolor="#ddd" border="1px;">
                                        <tr height="95%">
                                            <td style="width:60%">
                                                <table width="100%" border="1" style="height:500px"  bordercolor="#ddd">
                                                    <tr style="background-color:#F5BCA9" height="10%">
                                                        <td align="center"><b><u>Customer Item List</u></b></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <div style="overflow:auto;height:100%;">
                                                                <table style="width:100%;">
                                                                    <col width="30%">
                                                                    <col width="40%">
                                                                    <col width="10%">
                                                                    <col width="10%">
                                                                    <col width="10%">
                                                                    <tr>
                                                                        <th>Item</th>
                                                                        <th>Remarks</th>
                                                                        <th>Charges</th>
                                                                        <th>Qty</th>
                                                                        <th>Units</th>
                                                                    </tr> 
                                                                    <%
                                                                        ArrayList<Item> customerItems = leadDiv.getCustomerItems();
                                                                        for (Item item : customerItems) {
                                                                            String tr = "<tr><td>" + item.getName() + "</td>";
                                                                            tr += "<td>" + item.getRemark() + "</td>";
                                                                            if (item.getCharges() > 0) {
                                                                                tr += "<td align='center'>" + item.getCharges() + "</td>";
                                                                            } else {
                                                                                tr += "<td align='center'>&nbsp;&nbsp;&nbsp;&nbsp;</td>";
                                                                            }

                                                                            tr += "<td align='center'>" + item.getQty() + "</td>";
                                                                            tr += "<td align='center'>" + item.getUnits() + "</td>";
                                                                            out.println(tr);
                                                                        }
                                                                    %>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr style="background-color:#CEE3F6" height="10%">
                                                        <td align="center"><b><u>Vimbox Item List</u></b></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <div style="overflow:auto;height:100%;">
                                                                <table style="width:100%;">
                                                                    <col width="30%">
                                                                    <col width="40%">
                                                                    <col width="10%">
                                                                    <col width="10%">
                                                                    <col width="10%">
                                                                    <tr>
                                                                        <th>Item</th>
                                                                        <th>Remarks</th>
                                                                        <th>Charges</th>
                                                                        <th>Qty</th>
                                                                        <th>Units</th>
                                                                    </tr> 
                                                                    <%
                                                                        ArrayList<Item> vimboxItems = leadDiv.getVimboxItems();
                                                                        for (Item item : vimboxItems) {
                                                                            String tr = "<tr><td>" + item.getName() + "</td>";
                                                                            tr += "<td>&nbsp;</td>";
                                                                            tr += "<td align='center'>&nbsp;&nbsp;&nbsp;&nbsp;</td>";
                                                                            tr += "<td align='center'>" + item.getUnits() + "</td>";
                                                                            tr += "<td align='center'>" + item.getUnits() + "</td>";
                                                                            out.println(tr);
                                                                        }

                                                                        ArrayList<Item> materials = leadDiv.getMaterials();
                                                                        for (Item item : materials) {
                                                                            String tr = "<tr><td>" + item.getName() + "</td>";
                                                                            tr += "<td>&nbsp;</td>";
                                                                            tr += "<td align='center'>" + item.getCharges() + "</td>";
                                                                            tr += "<td align='center'>" + item.getUnits() + "</td>";
                                                                            tr += "<td align='center'>&nbsp;</td>";
                                                                            out.println(tr);
                                                                        }
                                                                    %>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td>
                                                <table width="100%" border="1" style="height:500px"  bordercolor="#ddd">
                                                    <tr style="height:5%;background-color:#F6CEE3;">
                                                        <td align="center"><b><u>Customer Comments</u></b></td>
                                                    </tr>
                                                    <tr style="height:15%">
                                                        <td>
                                                            <div style="overflow:auto;height:100%;">
                                                                <table valign="top">
                                                                    <tbody>
                                                                        <%
                                                                            ArrayList<String> comments = leadDiv.getComments();
                                                                            for (String comment : comments) {
                                                                                out.println("<tr><td>" + comment + "</td></tr>");
                                                                            }
                                                                        %>    
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr style="height:5%;background-color:#F6CEE3;">
                                                        <td align="center"><b><u>Customer Remarks</u></b></td>
                                                    </tr>
                                                    <tr style="height:15%">
                                                        <td>
                                                            <div style="overflow:auto;height:100%;">
                                                                <table  valign="top">
                                                                    <tbody>
                                                                        <%
                                                                            ArrayList<String> remarks = leadDiv.getRemarks();
                                                                            for (String remark : remarks) {
                                                                                out.println("<tr><td>" + remark + "</td></tr>");
                                                                            }
                                                                        %>  
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr style="height:5%;background-color:#A9F5D0;">
                                                        <td align="center"><b><u>Services</u></b></td>
                                                    </tr>
                                                    <tr style="height:30%">
                                                        <td>
                                                            <div style="overflow:auto;height:100%;">
                                                                <table valign="top" width="100%">
                                                                    <tbody>
                                                                        <%
                                                                            ArrayList<String[]> services = leadDiv.getServices();
                                                                            for (String[] service : services) {
                                                                                String[] svc = service[0].split("_");
                                                                                String tr = "<tr id='" + leadDivId + "_" + service[0] + "'><td>";
                                                                                tr += "<table width='100%'>";
                                                                                String secSvc = "";
                                                                                for (int i = 1; i < svc.length; i++) {
                                                                                    secSvc += (svc[i]);
                                                                                    if (i < svc.length - 1) {
                                                                                        secSvc += " ";
                                                                                    }
                                                                                }

                                                                                tr += "<tr height='10%'><td>" + svc[0] + " - " + secSvc + "</td><td align='right'>S$" + service[1] + "</td></tr>";
                                                                                tr += "</table></td></tr>";
                                                                                sum += Double.parseDouble(service[1]);
                                                                                out.println(tr);
                                                                            }
                                                                        %>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <%
                                                        HashMap<String, String> others = leadDiv.getOtherCharges();
                                                    %>
                                                    <tr style='height:5%'>
                                                        <td>
                                                            <table width='100%'>
                                                                <col width='50%'>
                                                                <tr>
                                                                    <td>Storey Charges</td>
                                                                    <td align='right'>$ 
                                                                        <%
                                                                            String storey = others.get("storeyCharge");
                                                                            out.println(storey);
                                                                            sum += Double.parseDouble(storey);
                                                                        %>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr style='height:5%'>
                                                        <td>
                                                            <table width='100%'>
                                                                <col width='50%'>
                                                                <tr>
                                                                    <td>Pushing Charges</td>
                                                                    <td align='right'>$
                                                                        <%
                                                                            String push = others.get("pushCharge");
                                                                            out.println(push);
                                                                            sum += Double.parseDouble(push);
                                                                        %>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr style='height:5%'>
                                                        <td>
                                                            <table width='100%'>
                                                                <col width='50%'>
                                                                <tr>
                                                                    <td>Detour Charges</td>
                                                                    <td align='right'>$ 
                                                                        <%
                                                                            String detour = others.get("detourCharge");
                                                                            out.println(detour);
                                                                            sum += Double.parseDouble(detour);
                                                                        %>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr style='height:5%'>
                                                        <td>
                                                            <table width='100%'>
                                                                <col width='50%'>
                                                                <tr>
                                                                    <td>Material Charges</td>
                                                                    <td align='right'>$ 
                                                                        <%
                                                                            String material = others.get("materialCharge");
                                                                            out.println(material);
                                                                            sum += Double.parseDouble(material);
                                                                        %>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr style='height:5%'>
                                                        <td>
                                                            <table width='100%'>
                                                                <col width='50%'>
                                                                <tr>
                                                                    <td>Markup</td>
                                                                    <td align='right'>$ 
                                                                        <%
                                                                            String markup = others.get("markup");
                                                                            out.println(markup);
                                                                            sum += Double.parseDouble(markup);
                                                                        %>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr style='height:5%'>
                                                        <td>
                                                            <table width='100%'>
                                                                <col width='50%'>
                                                                <tr>
                                                                    <td>Discount</td>
                                                                    <td align='right'>$ 
                                                                        <%
                                                                            String discount = others.get("discount");
                                                                            out.println(discount);
                                                                            sum -= Double.parseDouble(discount);
                                                                        %>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="right">
                                                            Total : <b>S$ 
                                                                <%
                                                                    out.println(df.format(sum));
                                                                    overall += sum;
                                                                %>
                                                            </b>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>  
                                </div>
                                <%
                                    }
                                %>
                            </td>
                        </tr>
                    </table>
                    <hr>
                    <div class="form-horizontal" style="font-size: 14px;">
                        <div class="form-group">
                            <div class="col-sm-6">
                                <h3 class="mrg10A">Grand Total</h3>
                            </div>
                        </div>
                    </div>
                    <table width="100%">
                        <tr>
                            <td align="center">
                                <h2><b>S$<%out.println(df.format(overall));%></b></h2>
                            </td>
                        </tr>
                    </table>
                </fieldset>
            </td>
        </tr>
    </table>
    <%
        }
    %>

