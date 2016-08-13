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
    <div class="form-group">
        <label class ="col-sm-3 control-label">Date of Move: </label>
        <div class ="col-sm-8" style="padding-top: 7px;">
            <%
                String[] doms = lead.getDom().split("\\|");
                for (int i = 0;
                        i < doms.length;
                        i++) {
                    String dom = doms[i];
                    out.println(dom);
                    if (i < doms.length - 1) {
                        out.println(", ");
                    }
                }
            %>
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
    <tr>
        <td colspan="2">
            <fieldset>
                <legend>Sales Info</legend>
                <!-- Site Survey -->
                <table width="100%">
                    <tr>
                        <th>Site Survey Details</th>
                    </tr>
                    <tr>
                        <td>
                            <%
                                ArrayList<SiteSurvey> surveys = lead.getSiteSurveys();
                                String ss = "";
                                String sId = "";
                                String sName = "";
                                String sRem = "";
                                String sStatus = "";
                                ArrayList<String> timeslots = new ArrayList<String>();
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
                                    }

                                    if (!s.equals(ss)) {
                                        out.println("<div id='" + ss + "'>");
                                        out.println("<hr><table><col width='100'>");
                                        out.println("<tr><td align='right'><b>Date :</b></td><td>" + ss + "</td></tr>");
                                        out.println("<tr><td align='right'><b>Timeslot :</b></td><td><table>");
                                        for (int j = 0; j < timeslots.size(); j++) {
                                            out.println("<tr><td>" + timeslots.get(j) + "</td></tr>");
                                        }
                                        out.println("</table></td></tr>");
                                        out.println("<tr><td align='right'><b>Address :</b></td><td><table>");
                                        for (int j = 0; j < addresses.size(); j++) {
                                            out.println("<tr><td>" + addresses.get(j) + "</td></tr>");
                                        }
                                        out.println("</table></td></tr>");
                                        out.println("<tr><td align='right'><b>Surveyor :</b></td><td>" + sName + "</td></tr>");
                                        out.println("<tr><td align='right'><b>Remarks :</b></td><td>" + sRem + "</td></tr>");
                                        out.println("<tr><td align='right'><b>Status :</b></td><td>" + sStatus + "</td></tr>");
                                        out.println("</table></div>");

                                        ss = s;
                                        sId = survey.getSiteSurveyor().getNric();
                                        sName = survey.getSiteSurveyor().toString();
                                        sRem = survey.getRemarks();
                                        sStatus = survey.getStatus();
                                        timeslots = new ArrayList<String>();
                                        addresses = new ArrayList<String>();
                                    }

                                    if (!timeslots.contains(survey.getTimeSlot())) {
                                        timeslots.add(survey.getTimeSlot());
                                    }
                                    if (!addresses.contains(survey.getAddress())) {
                                        addresses.add(survey.getAddress());
                                    }
                                    if (i == surveys.size() - 1) {
                                        out.println("<div id='" + ss + "'>");
                                        out.println("<hr><table><col width='100'>");
                                        out.println("<tr><td align='right'><b>Date :</b></td><td>" + ss + "</td></tr>");
                                        out.println("<tr><td align='right'><b>Timeslot :</b></td><td><table>");
                                        for (int j = 0; j < timeslots.size(); j++) {
                                            out.println("<tr><td>" + timeslots.get(j) + "</td></tr>");
                                        }
                                        out.println("</table></td></tr>");
                                        out.println("<tr><td align='right'><b>Address :</b></td><td><table>");
                                        for (int j = 0; j < addresses.size(); j++) {
                                            out.println("<tr><td>" + addresses.get(j) + "</td></tr>");
                                        }
                                        out.println("</table></td></tr>");
                                        out.println("<tr><td align='right'><b>Surveyor :</b></td><td>" + sName + "</td></tr>");
                                        out.println("<tr><td align='right'><b>Remarks :</b></td><td>" + sRem + "</td></tr>");
                                        out.println("<tr><td align='right'><b>Status :</b></td><td>" + survey.getStatus() + "</td></tr>");
                                        out.println("</table></div>");
                                    }
                                }
                            %>
                        </td>
                    </tr>
                </table>
                <hr>
                <table width="100%">
                    <tr>
                        <th>Sales Details</th>
                    </tr>
                    <tr>
                        <td>
                            <hr>

                            <!-- Sales -->
                            <ul class="tab" id="sales_list">
                                <%
                                    ArrayList<LeadDiv> leadDivs = lead.getSalesDivs();
                                    for (LeadDiv leadDiv : leadDivs) {
                                        String leadDivStr = leadDiv.getSalesDiv();
                                        String leadDivId = leadDivStr.substring(0, leadDivStr.indexOf("|"));
                                        String leadDivAddr = leadDivStr.substring(leadDivStr.indexOf("|") + 1);
                                        out.println("<li><a href='#' class='tablinks' onclick=\"openSales(event, '" + leadDivId + "')\"><label>" + leadDivAddr + "</label></a></li>");
                                    }
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
                                <table width="100%">
                                    <tr height="95%">
                                        <td style="width:60%">
                                            <table width="100%" border="1" style="height:500px">
                                                <tr style="background-color:DarkOrange" height="10%">
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
                                                <tr style="background-color:CornflowerBlue" height="10%">
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
                                            <table width="100%" border="1" style="height:500px">
                                                <tr style="height:5%;background-color:Plum;">
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
                                                <tr style="height:5%;background-color:Plum;">
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
                                                <tr style="height:5%;background-color:DarkCyan;">
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
                                                                            tr += "<table class='serviceTable'>";
                                                                            String secSvc = "";
                                                                            for (int i = 1; i < svc.length; i++) {
                                                                                secSvc += (svc[i]);
                                                                                if (i < svc.length - 1) {
                                                                                    secSvc += " ";
                                                                                }
                                                                            }

                                                                            tr += "<tr height='10%'><td>" + svc[0] + " - " + secSvc + "<input type='hidden' name='" + leadDivId + "_serviceName' value='" + service[0] + "'></td><td align='right'>$ <input type='number' step='0.01' min='0' name='" + leadDivId + "_serviceCharge' value='" + service[1] + "'><input type='hidden' value='" + service[2] + "'></td></tr>";
                                                                            tr += "</table></td></tr>";
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
                                                                out.println(sum);
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
                <table width="100%">
                    <tr>
                        <th>Grand Total</th>
                    </tr>
                    <tr>
                        <td align="center">
                            <hr>
                            <h2>S$<%out.println(overall);%></h2>
                        </td>
                    </tr>
                </table>
            </fieldset>
        </td>
    </tr>
    <%
        }
    %>
</table>
