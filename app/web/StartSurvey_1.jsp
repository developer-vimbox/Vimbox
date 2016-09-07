<%@page import="com.vimbox.sales.Item"%>
<%@page import="com.vimbox.sales.LeadArea"%>
<%@page import="com.vimbox.sales.LeadDiv"%>
<%@page import="com.vimbox.database.LeadPopulationDAO"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.vimbox.sales.Lead"%>
<%@page import="com.vimbox.database.LeadDAO"%>
<%@page import="com.vimbox.sitesurvey.SiteSurvey"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.SiteSurveyDAO"%>
<%@include file="ValidateLogin.jsp"%>
<%@include file="LoadServices.jsp"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Start Survey</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.2/jquery.min.js"></script>
        <script src="http://malsup.github.com/jquery.form.js"></script> 
        <script src="JS/SiteSurveyFunctions.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
    </head>
    <body onload="initSurvey()">
        <%            
            String leadId = request.getParameter("leadId");
            String date = request.getParameter("date");
            String timeslot = request.getParameter("timeslot");
            Lead lead = LeadDAO.getLeadById(Integer.parseInt(leadId));
            ArrayList<SiteSurvey> siteSurveys = SiteSurveyDAO.getSiteSurveysByLeadIdDateTimeslot(Integer.parseInt(leadId), date, timeslot);
            ArrayList<String> addressesFrom = new ArrayList<String>();
            ArrayList<String> addressesTo = new ArrayList<String>();
            for (SiteSurvey site : siteSurveys) {
                String add = site.getAddress();
                String tag = site.getAddressTag();
                if(tag.equals("from")){
                    if (!addressesFrom.contains(add)) {
                        addressesFrom.add(add);
                    }
                }else{
                    if (!addressesTo.contains(add)) {
                        addressesTo.add(add);
                    }
                }
            }
            String col = "<col width='20%'><col width='45%'><col width='10%'><col width='10%'><col width='10%'><col width='5%'>";
        %>
        <form action="SaveSiteSurveyController" id="siteSurvey_form">
            <input type="hidden" name="lead" value="<%=leadId%>|<%=date%>|<%=timeslot%>">
            <table width="100%" height="100%">
                <col width="250">
                <tr>
                    <td>
                        <table width="100%" border="1" height="100%">
                            <tr height="10%">
                                <td>
                                    <input type="hidden" id="complete_status" name="complete" value="no">
                                    <button style="width:100%;height:100%;" onclick="confirmComplete(); return false;">Complete Site Survey</button>
                                </td>
                            </tr>
                            <tr height="10%">
                                <td align='center' class="selected" id="siteInfo_tab" onclick='displaySiteInfo()'>Site Info</td>
                            </tr>
                            <tr height="10%">
                                <td align="center">FROM</td>
                            </tr>
                            <tr>
                                <td valign='top'>
                                <%
                                    int counter = 1;
                                    HashMap<String, String> addressTabs = new HashMap<String, String>();
                                    for (String address : addressesFrom) {
                                        out.println("<table border='1' id='addressTab" + counter + "' width='100%'>");
                                        addressTabs.put(address, "addressTab" + counter);
                                        LeadDiv sD = lead.getSalesDivByAddress(address);
                                        String salesDiv = sD.getSalesDiv().split("\\|")[0];
                                        out.println("<tr class='survey_address_tab' onclick='expandAddressTab(this)'>");
                                        out.println("<td>" + address + "<input type='hidden' name='salesDiv' value='" + salesDiv + "|" + address + "'></td>");
                                        out.println("</tr>");
                                        out.println("<tr>");
                                        out.println("<td align='center' onclick=\"addArea('addressTab" + counter + "', '" + salesDiv + "')\">Add New Area</td>");
                                        out.println("</tr>");
                                        ArrayList<LeadArea> leadAreas = sD.getLeadAreas();
                                        for(LeadArea leadArea : leadAreas){
                                            String leadAreaDivString = leadArea.getLeadAreaDiv();
                                            if(!leadAreaDivString.isEmpty()){
                                                String[] leadAreaDiv = leadAreaDivString.split("_");
                                                String leadName = leadArea.getLeadName();
                                                String aT = leadAreaDiv[0];
                                                String areaCounter = leadAreaDiv[1]; 
                                                out.println("<tr id='" + aT + "_area_" + areaCounter + "' onclick=\"displaySiteDiv(this, '" + aT + "_div_" + areaCounter + "')\" class='survey_area_tab'><td align='center'><input type='hidden' name='survey_area' value='" + salesDiv + "|" + aT + "_" + areaCounter + "'><label id='" + aT + "_lbl_" + areaCounter + "'>" + leadName + "</label></td></tr>");
                                            }
                                        }
                                        out.println("</table>");
                                        counter++;
                                    }
                                %>
                                </td>
                            </tr>
                            <tr height="10%">
                                <td align="center">TO</td>
                            </tr>
                            <tr>
                                <td valign='top'>
                                <%
                                    for (String address : addressesTo) {
                                        out.println("<table border='1' id='addressTab" + counter + "' width='100%'>");
                                        addressTabs.put(address, "addressTab" + counter);
                                        LeadDiv sD = lead.getSalesDivByAddress(address);
                                        String salesDiv = sD.getSalesDiv().split("\\|")[0];
                                        out.println("<tr class='survey_address_tab' onclick='expandAddressTab(this)'>");
                                        out.println("<td>" + address + "<input type='hidden' name='salesDiv' value='" + salesDiv + "|" + address + "'></td>");
                                        out.println("</tr>");
                                        out.println("<tr>");
                                        out.println("<td align='center' onclick=\"addArea('addressTab" + counter + "', '" + salesDiv + "')\">Add New Area</td>");
                                        out.println("</tr>");
                                        ArrayList<LeadArea> leadAreas = sD.getLeadAreas();
                                        for(LeadArea leadArea : leadAreas){
                                            String leadAreaDivString = leadArea.getLeadAreaDiv();
                                            if(!leadAreaDivString.isEmpty()){
                                                String[] leadAreaDiv = leadAreaDivString.split("_");
                                                String leadName = leadArea.getLeadName();
                                                String aT = leadAreaDiv[0];
                                                String areaCounter = leadAreaDiv[1]; 
                                                out.println("<tr id='" + aT + "_area_" + areaCounter + "' onclick=\"displaySiteDiv(this, '" + aT + "_div_" + areaCounter + "')\" class='survey_area_tab'><td align='center'><input type='hidden' name='survey_area' value='" + salesDiv + "|" + aT + "_" + areaCounter + "'><label id='" + aT + "_lbl_" + areaCounter + "'>" + leadName + "</label></td></tr>");
                                            }
                                        }
                                        out.println("</table>");
                                        counter++;
                                    }
                                %>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td>
                        <div id='content'>
                            <div id='siteInfo' style='display:block;height:790px;'>
                                <table width='100%'>
                                    <col width='165'>
                                    <tr>
                                        <td align='right'><b>Lead ID :</b></td>
                                        <td><%=lead.getId()%></td>
                                    </tr>
                                </table>
                                    <input type="submit" value="SAVE">
                                <br>
                                <h2>FROM</h2>
                                <%
                                    for (String address : addressesFrom) {
                                        String addressTab = addressTabs.get(address);
                                        String[] addrDetails = lead.getStoreysPushingDFrom(address);
                                        
                                        LeadDiv leadDiv = lead.getSalesDivByAddress(address);
                                        String divId = (leadDiv.getSalesDiv().split("\\|"))[0];
                                        
                                        out.println("<fieldset class='tabcontent' id='" + divId + "'>");
                                        out.println("<legend><b>" + address + "</b></legend>");
                                        out.println("<table width='100%' border='1'>");
                                        out.println("<col width='50%'>");
                                        

                                        out.println("<tr>");
                                        out.println("<td valign='top'>");
                                        out.println("<input type='hidden' name='" + divId + "' value='" + address + "'>");
                                        out.println("<table width='100%' border='1'>");
                                            out.println("<col width='20%'>");
                                            out.println("<col width='45%'>");
                                            out.println("<col width='10%'>");
                                            out.println("<col width='10%'>");
                                            out.println("<col width='5%'>");
                            
                                            out.println("<tr height='10%' style='background-color:DarkOrange'>");
                                            out.println("<td align='center' colspan='6'><b>CUSTOMER<b></td>");
                                            out.println("</tr>");
                                            
                                            out.println("<tr>");
                                            out.println("<td align='center'><b>Item</b></td>"); 
                                            out.println("<td align='center'><b>Remarks</b></td>"); 
                                            out.println("<td align='center'><b>Additional Charges</b></td>"); 
                                            out.println("<td align='center'><b>Qty</b></td>"); 
                                            out.println("<td align='center'><b>Units</b></td>"); 
                                            out.println("<td align='center'></td>"); 
                                            out.println("</tr>");
                                            
                                            out.println("<tr>");
                                            out.println("<td valign='top' height='150' colspan='6'>");
                                %>
                                            <div style="overflow:auto;height:100%;">
                                                <table id="<%=divId%>_CustomerItemTable" valign="top" width="100%">
                                                    <tbody>
                                <%
                                                        ArrayList<LeadArea> areas = leadDiv.getLeadAreas();
                                                        for(LeadArea leadArea : areas){
                                                            String leadAreaString = leadArea.getLeadAreaDiv();
                                                            if(!leadAreaString.isEmpty()){
                                                                String[] leadAreaDiv = leadAreaString.split("_");
                                                                String leadName = leadArea.getLeadName();
                                                                String aT = leadAreaDiv[0];
                                                                String areaCounter = leadAreaDiv[1];
                                                                
                                                                out.println("<tr><td><table id='" + divId + "_" + aT + "_" + areaCounter + "_CustomerItemTable' width='100%'>" + col + "<tr><th colspan='6'><label id='" + divId + "_" + aT + "_CustomerItemTableLbl'>" + leadName + "</label></tr>");
    
                                                                ArrayList<Item> customerItems = leadArea.getCustomerItems();
                                                                int trCounter = 1;
                                                                for(Item item : customerItems){
                                                                    out.println("<tr id='" + aT + "_" + areaCounter + "_SelectedItemsTable_tr" + trCounter + "'>");
                                                                    out.println("<td><input type='hidden' value='" + item.getName() + "' name='" + divId + "_" + aT + "_" + areaCounter + "_CustomerName'>" + item.getName() + "</td>");
                                                                    String remark = item.getRemark();
                                                                    if(remark.isEmpty()){
                                                                        remark = "&nbsp;";
                                                                    }
                                                                    out.println("<td><input type='hidden' value='" + item.getRemark() + "' name='" + divId + "_" + aT + "_" + areaCounter + "_CustomerRemarks'>" + remark + "</td>");
                                                                    String charges = item.getCharges() + "";
                                                                    String chargesValue = item.getCharges() + "";
                                                                    if(charges.equals("0.0")){
                                                                        charges = "&nbsp;";
                                                                        chargesValue = "";
                                                                    }
                                                                    out.println("<td align='center'><input type='hidden' value='" + chargesValue + "' name='" + divId + "_" + aT + "_" + areaCounter + "_CustomerAddCharges'>" + charges + "</td>");
                                                                    out.println("<td align='center'><input type='hidden' value='" + item.getQty() + "' name='" + divId + "_" + aT + "_" + areaCounter + "_CustomerQuantity'>" + item.getQty() + "</td>");
                                                                    out.println("<td align='center'><input type='hidden' value='" + item.getUnits() + "' name='" + divId + "_" + aT + "_" + areaCounter + "_CustomerUnits'>" + item.getUnits() + "</td>");
                                                                    out.println("<td align='center'><input type='button' value='x' onclick=\"deleteSiteItem(this, '" + aT + "_" + areaCounter + "_SelectedItemsTable" + "', '" + divId + "')\"/></td>");
                                                                    out.println("</tr>");
                                                                    trCounter++;
                                                                }
                                                                out.println("</table></td></tr>");
                                                            }
                                                        }
                                %>
                                                    </tbody>
                                                </table>
                                            </div>
                                <%
                                            out.println("</td>");
                                            out.println("</tr>");
                                            
                                            out.println("<tr height='10%' style='background-color:CornflowerBlue'>");
                                            out.println("<td align='center' colspan='6'><b>VIMBOX<b></td>");
                                            out.println("</tr>");
                                            
                                            out.println("<tr>");
                                            out.println("<td align='center'><b>Item</b></td>"); 
                                            out.println("<td align='center'><b>Remarks</b></td>"); 
                                            out.println("<td align='center'><b>Additional Charges</b></td>"); 
                                            out.println("<td align='center'><b>Qty</b></td>"); 
                                            out.println("<td align='center'><b>Units</b></td>"); 
                                            out.println("<td align='center'></td>"); 
                                            out.println("</tr>");
                                            
                                            out.println("<tr>");
                                            out.println("<td valign='top' height='150' colspan='6'>");
                                %>
                                            <div style="overflow:auto;height:100%;">
                                                <table id="<%=divId%>_VimboxItemTable" valign="top" width="100%">
                                                    <tbody>
                                <%
                                                        for(LeadArea leadArea : areas){
                                                            String leadAreaString = leadArea.getLeadAreaDiv();
                                                            if(!leadAreaString.isEmpty()){
                                                                String[] leadAreaDiv = leadAreaString.split("_");
                                                                String leadName = leadArea.getLeadName();
                                                                String aT = leadAreaDiv[0];
                                                                String areaCounter = leadAreaDiv[1];
                                                                
                                                                out.println("<tr><td><table id='" + divId + "_" + aT + "_" + areaCounter + "_VimboxItemTable' width='100%'>" + col + "<tr><th colspan='6'><label id='" + divId + "_" + aT + "_VimboxItemTableLbl'>" + leadName + "</label></tr>");
    
                                                                int trCounter = 1;
                                                                ArrayList<Item> vimboxItems = new ArrayList<Item>();
                                                                for(Item item : leadArea.getVimboxItems()){
                                                                    vimboxItems.add(item);
                                                                }
                                                                vimboxItems.addAll(leadArea.getMaterials());
                                                                for(Item item : vimboxItems){
                                                                    out.println("<tr id='" + aT + "_" + areaCounter + "_SelectedVimboxTable_tr" + trCounter + "'>");
                                                                    out.println("<td><input type='hidden' value='" + item.getName() + "' name='" + divId + "_" + aT + "_" + areaCounter + "_VimboxName'>" + item.getName() + "</td>");
                                                                    String remark = item.getRemark();
                                                                    if(remark.isEmpty()){
                                                                        remark = "&nbsp;";
                                                                    }
                                                                    out.println("<td><input type='hidden' value='" + item.getRemark() + "' name='" + divId + "_" + aT + "_" + areaCounter + "_VimboxRemarks'>" + remark + "</td>");
                                                                    String charges = item.getCharges() + "";
                                                                    String chargesValue = item.getCharges() + "";
                                                                    if(charges.equals("0.0")){
                                                                        charges = "&nbsp;";
                                                                        chargesValue = "";
                                                                    }
                                                                    out.println("<td align='center'><input type='hidden' value='" + chargesValue + "' name='" + divId + "_" + aT + "_" + areaCounter + "_VimboxAddCharges'>" + charges + "</td>");
                                                                    out.println("<td align='center'><input type='hidden' value='" + item.getQty() + "' name='" + divId + "_" + aT + "_" + areaCounter + "_VimboxQuantity'>" + item.getQty() + "</td>");
                                                                    out.println("<td align='center'><input type='hidden' value='" + item.getUnits() + "' name='" + divId + "_" + aT + "_" + areaCounter + "_VimboxUnits'>" + item.getUnits() + "</td>");
                                                                    out.println("<td align='center'><input type='button' value='x' onclick=\"deleteSiteItem(this, '" + aT + "_" + areaCounter + "_SelectedVimboxTable" + "', '" + divId + "')\"/></td>");
                                                                    out.println("</tr>");
                                                                    trCounter++;
                                                                }
                                                                out.println("</table></td></tr>");
                                                            }
                                                        }
                                %>
                                                    </tbody>
                                                </table>
                                            </div>
                                <%
                                            out.println("</td>");
                                            out.println("</tr>");
                                            
                                        out.println("</table>");
                                        out.println("</td>");
                                        
                                        out.println("<td valign='top'>");
                                        out.println("<table width='100%' border='1'>");
                                            out.println("<col width='50%'");
                                            out.println("<tr>");
                                            out.println("<td align='right'><b>Storeys :</b></td>");
                                            out.println("<td><input type='text' name='" + divId + "_storeys' size='5' value='");
                                            if(addrDetails != null){
                                                out.println(addrDetails[0]);
                                            }
                                            out.println("'></td></tr>");

                                            out.println("<tr>");
                                            out.println("<td align='right'><b>Pushing Distance :</b></td>");
                                            out.println("<td><input type='text' name='" + divId + "_distance' size='5' value='");
                                            if(addrDetails != null){
                                                out.println(addrDetails[1]);
                                            }
                                            out.println("'> m</td>");
                                            out.println("</tr>");
                                            
                                            out.println("<tr style='background-color:DarkCyan;'>");
                                            out.println("<td align='center' colspan='2'><b>CHARGES</b></td>");
                                            out.println("</tr>");
                                            
                                            HashMap<String, String> otherCharges = leadDiv.getOtherCharges();
                                            out.println("<tr>");
                                            out.println("<td align='right'><b>Storey Charges :</b></td>");
                                            out.println("<td>$ <input type='number' name='" + divId + "_storeyCharge' step='0.01' min='0' value='" + otherCharges.get("storeyCharge") + "'></td>");
                                            out.println("</tr>");
                                            
                                            out.println("<tr>");
                                            out.println("<td align='right'><b>Pushing Charges :</b></td>");
                                            out.println("<td>$ <input type='number' name='" + divId + "_pushCharge' step='0.01' min='0' value='" + otherCharges.get("pushCharge") + "'></td>");
                                            out.println("</tr>");
                                            
                                            out.println("<tr>");
                                            out.println("<td align='right'><b>Detour Charges :</b></td>");
                                            out.println("<td>$ <input type='number' name='" + divId + "_detourCharge' step='0.01' min='0' value='" + otherCharges.get("detourCharge") + "'></td>");
                                            out.println("</tr>");
                                            
                                            out.println("<tr>");
                                            out.println("<td align='right'><b>Material Charges :</b></td>");
                                            out.println("<td>$ <input type='number' id='" + divId + "_materialCharge' name='" + divId + "_materialCharge' step='0.01' min='0' value='" + otherCharges.get("materialCharge") + "'></td>");
                                            out.println("</tr>");
                                            
                                            out.println("<tr>");
                                            out.println("<td align='right'><b>Discount :</b></td>");
                                            out.println("<td>$ <input type='number' name='" + divId + "_discount' step='0.01' min='0' value='" + otherCharges.get("discount") + "'></td>");
                                            out.println("</tr>");
                                            
                                            out.println("<tr>");
                                            out.println("<td colspan='2'><button onclick=\"selectService('" + divId + "');return false;\" style='width:100%;'>SERVICES</button></td>");
                                            out.println("</td></tr>");
                                            
                                            out.println("<tr>");
                                            out.println("<td colspan='2' valign='top' height='100'>");
                                %>
                                            <div style="overflow:auto;height:100%;">
                                                <table class="servicesTable" id="<%=divId%>_servicesTable" valign="top" width="100%">
                                                    <tbody>
                                <%
                                                    ArrayList<String[]> services = leadDiv.getServices();
                                                    for (String[] service : services) {
                                                        String[] svc = service[0].split("_");
                                                        String tr = "<tr id='" + divId + "_" + service[0] + "'><td>";
                                                        tr += "<table class='serviceTable' width='100%'>";
                                                        String secSvc = "";
                                                        for (int i = 1; i < svc.length; i++) {
                                                            secSvc += (svc[i]);
                                                            if (i < svc.length - 1) {
                                                                secSvc += " ";
                                                            }
                                                        }

                                                        tr += "<tr height='10%'><td>" + svc[0] + " - " + secSvc + "<input type='hidden' name='" + divId + "_serviceName' value='" + service[0] + "'></td><td align='right'>$ <input type='number' step='0.01' min='0' name='" + divId + "_serviceCharge' value='" + service[1] + "'><input type='hidden' value='" + service[2] + "'></td></tr>";
                                                        tr += "</table></td></tr>";
                                                        out.println(tr);
                                                    }
                                %>  
                                                        
                                                    </tbody>
                                                </table>
                                            </div>
                                <%
                                            out.println("</td>");
                                            
                                            out.println("<tr style='height:10%;background-color:Plum;'>");
                                            out.println("<td align='center' colspan='2'><b>COMMENTS</b></td>");
                                            out.println("</tr>");
                                            
                                            ArrayList<String> comments = leadDiv.getComments();
                                            String comment = "";
                                            for(String c : comments){
                                                comment += c + " ";
                                            }
                                            out.println("<tr height='71'>");
                                            out.println("<td colspan='2'><input name='" + divId + "_comments' style='width:99%;height:100%' value='" + comment + "'></td>");
                                            out.println("</tr>");
                                            
                                        out.println("</table>");
                                        out.println("</td>"); 
                                        out.println("</tr>");
                                        out.println("</table>");
                                %>            
                                        <div id="<%=divId%>_serviceModal" class="service">
                                            <!-- Modal content -->
                                            <div class="service-content">
                                                <div class="service-body">
                                                    <span class="close" onclick="closeModal('<%=divId%>_serviceModal')">×</span>
                                                    <table width="100%" border="1" style="table-layout: fixed;" id="<%=divId%>_serviceTable">
                                <%
                                                    for (int i = 0; i < serviceTable.length; i++) {
                                                        out.println("<tr>");
                                                        for (int j = 0; j < serviceTable[i].length; j++) {
                                                            if (i == 0) {
                                                                // Table Header //
                                                                out.println("<th>" + serviceTable[i][j] + "</th>");
                                                            } else {
                                                                // Table Data //
                                                                String[] serviceChargeArray = serviceTable[i][j].split(",");
                                                                out.println("<td bgcolor='#6698FF' align='center' onclick=\"selectServiceSlot(this, '" + divId + "')\"");
                                                                if (serviceTable[0][j].equals("Manpower")) {
                                                                    out.println("id='" + divId + (serviceTable[0][j] + "_" + serviceChargeArray[0]).replaceAll(" ", "_") + "_service'");
                                                                }
                                                                out.println(">" + serviceChargeArray[0] + "</br>");

                                                                if (serviceTable[0][j].equals("Manpower")) {
                                                                    String id = (serviceTable[0][j] + "_" + serviceChargeArray[0]).replaceAll(" ", "_");
                                                                    String mp = "";
                                                                    String mr = "";
                                                                    for (String[] svc : services) {
                                                                        if (svc[0].replaceAll(" ", "_").equals(id)) {
                                                                            mp = svc[3];
                                                                            mr = svc[4];
                                                                            break;
                                                                        }
                                                                    }
                                                                    out.println("Manpower : <label id='" + divId + "_" + id + "manpowerLabel'>" + mp + "</label><input type='hidden' name='" + divId + "_" + id + "manpowerInput' id='" + divId + "_" + id + "manpowerInput' value='" + mp + "'></br>");
                                                                    out.println("Reason : <label id='" + divId + "_" + id + "manpowerReasonLabel'>" + mr + "</label><input type='hidden' name='" + divId + "_" + id + "reasonInput' id='" + divId + "_" + id + "reasonInput' value='" + mr + "'></br>");
                                                                }
                                                                try {
                                                                    out.println("<input type='hidden' name='svcTableCell' value='{" + serviceTable[0][j] + "|" + serviceChargeArray[0] + "," + serviceChargeArray[1] + "}'>");
                                                                } catch (IndexOutOfBoundsException e) {
                                                                }

                                                                out.println("</td>");
                                                            }
                                                        }
                                                        out.println("</tr>");
                                                    }
                                %>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                                    
                                        <div id="<%=divId%>_manpowerModal" class="modal">
                                            <!-- Modal content -->
                                            <div class="modal-content">
                                                <div class="modal-body">
                                                    <h3>Manpower Request</h3><hr>
                                                    <input type="hidden" id="<%=divId%>_manpowerId">
                                                    <table width="100%">
                                                        <tr>
                                                            <td align="right">Additional Manpower :</td>
                                                            <td><input type="number" id="<%=divId%>_additionalManpower"></td>
                                                        </tr>
                                                        <tr>
                                                            <td align="right">Reason :</td>
                                                            <td><input type="text" id="<%=divId%>_manpowerReason" style="width:90%"></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <button align="center" onclick="closeManpowerModal('<%=divId%>'); return false;" style="width:100%;">CANCEL</button>
                                                            </td>
                                                            <td>
                                                                <button align="center" onclick="submitManpower('<%=divId%>');
                                                            return false;" style="width:100%;">REQUEST</button>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                <%
                                        out.println("</fieldset>");
                                    }
                                %>
                                <br>
                                <h2>TO</h2>
                                <%
                                    for (String address : addressesTo) {
                                        out.println("<fieldset>");
                                        out.println("<legend><b>" + address + "</b></legend>");
                                        out.println("<table width='100%' border='1'>");
                                        out.println("<col width='50%'>");
                                        String addressTab = addressTabs.get(address);
                                        String[] addrDetails = lead.getStoreysPushingDFrom(address);
                                        
                                        LeadDiv leadDiv = lead.getSalesDivByAddress(address);
                                        String divId = (leadDiv.getSalesDiv().split("\\|"))[0];

                                        out.println("<tr>");
                                        out.println("<td valign='top'>");
                                        out.println("<input type='hidden' name='" + divId + "' value='" + address + "'>");
                                        out.println("<table width='100%' border='1'>");
                                            out.println("<col width='20%'>");
                                            out.println("<col width='45%'>");
                                            out.println("<col width='10%'>");
                                            out.println("<col width='10%'>");
                                            out.println("<col width='5%'>");
                                            
                                            out.println("<tr height='10%' style='background-color:DarkOrange'>");
                                            out.println("<td align='center' colspan='6'><b>CUSTOMER<b></td>");
                                            out.println("</tr>");
                                            
                                            out.println("<tr>");
                                            out.println("<td align='center'><b>Item</b></td>"); 
                                            out.println("<td align='center'><b>Remarks</b></td>"); 
                                            out.println("<td align='center'><b>Additional Charges</b></td>"); 
                                            out.println("<td align='center'><b>Qty</b></td>"); 
                                            out.println("<td align='center'><b>Units</b></td>"); 
                                            out.println("<td align='center'></td>"); 
                                            out.println("</tr>");
                                            
                                            out.println("<tr>");
                                            out.println("<td valign='top' height='150' colspan='6'>");
                                %>
                                            <div style="overflow:auto;height:100%;">
                                                <table id="<%=divId%>_CustomerItemTable" valign="top" width="100%">
                                                    <tbody>
                                <%
                                                        ArrayList<LeadArea> areas = leadDiv.getLeadAreas();
                                                        for(LeadArea leadArea : areas){
                                                            String leadAreaString = leadArea.getLeadAreaDiv();
                                                            if(!leadAreaString.isEmpty()){
                                                                String[] leadAreaDiv = leadAreaString.split("_");
                                                                String leadName = leadArea.getLeadName();
                                                                String aT = leadAreaDiv[0];
                                                                String areaCounter = leadAreaDiv[1];
                                                                
                                                                out.println("<tr><td><table id='" + divId + "_" + aT + "_" + areaCounter + "_CustomerItemTable' width='100%'>" + col + "<tr><th colspan='6'><label id='" + divId + "_" + aT + "_CustomerItemTableLbl'>" + leadName + "</label></tr>");
    
                                                                ArrayList<Item> customerItems = leadArea.getCustomerItems();
                                                                int trCounter = 1;
                                                                for(Item item : customerItems){
                                                                    out.println("<tr id='" + aT + "_" + areaCounter + "_SelectedItemsTable_tr" + trCounter + "'>");
                                                                    out.println("<td><input type='hidden' value='" + item.getName() + "' name='" + divId + "_" + aT + "_" + areaCounter + "_CustomerName'>" + item.getName() + "</td>");
                                                                    String remark = item.getRemark();
                                                                    if(remark.isEmpty()){
                                                                        remark = "&nbsp;";
                                                                    }
                                                                    out.println("<td><input type='hidden' value='" + item.getRemark() + "' name='" + divId + "_" + aT + "_" + areaCounter + "_CustomerRemarks'>" + remark + "</td>");
                                                                    String charges = item.getCharges() + "";
                                                                    String chargesValue = item.getCharges() + "";
                                                                    if(charges.equals("0.0")){
                                                                        charges = "&nbsp;";
                                                                        chargesValue = "";
                                                                    }
                                                                    out.println("<td align='center'><input type='hidden' value='" + chargesValue + "' name='" + divId + "_" + aT + "_" + areaCounter + "_CustomerAddCharges'>" + charges + "</td>");
                                                                    out.println("<td align='center'><input type='hidden' value='" + item.getQty() + "' name='" + divId + "_" + aT + "_" + areaCounter + "_CustomerQuantity'>" + item.getQty() + "</td>");
                                                                    out.println("<td align='center'><input type='hidden' value='" + item.getUnits() + "' name='" + divId + "_" + aT + "_" + areaCounter + "_CustomerUnits'>" + item.getUnits() + "</td>");
                                                                    out.println("<td align='center'><input type='button' value='x' onclick=\"deleteSiteItem(this, '" + aT + "_" + areaCounter + "_SelectedItemsTable" + "', '" + divId + "')\"/></td>");
                                                                    out.println("</tr>");
                                                                    trCounter++;
                                                                }
                                                                out.println("</table></td></tr>");
                                                            }
                                                        }
                                %>
                                                    </tbody>
                                                </table>
                                            </div>
                                <%
                                            out.println("</td>");
                                            out.println("</tr>");
                                            
                                            out.println("<tr height='10%' style='background-color:CornflowerBlue'>");
                                            out.println("<td align='center' colspan='6'><b>VIMBOX<b></td>");
                                            out.println("</tr>");
                                            
                                            out.println("<tr>");
                                            out.println("<td align='center'><b>Item</b></td>"); 
                                            out.println("<td align='center'><b>Remarks</b></td>"); 
                                            out.println("<td align='center'><b>Additional Charges</b></td>"); 
                                            out.println("<td align='center'><b>Qty</b></td>"); 
                                            out.println("<td align='center'><b>Units</b></td>"); 
                                            out.println("<td align='center'></td>"); 
                                            out.println("</tr>");
                                            
                                            out.println("<tr>");
                                            out.println("<td valign='top' height='150' colspan='6'>");
                                %>
                                            <div style="overflow:auto;height:100%;">
                                                <table id="<%=divId%>_VimboxItemTable" valign="top" width="100%">
                                                    <tbody>
                                <%
                                                        for(LeadArea leadArea : areas){
                                                            String leadAreaString = leadArea.getLeadAreaDiv();
                                                            if(!leadAreaString.isEmpty()){
                                                                String[] leadAreaDiv = leadAreaString.split("_");
                                                                String leadName = leadArea.getLeadName();
                                                                String aT = leadAreaDiv[0];
                                                                String areaCounter = leadAreaDiv[1];
                                                                
                                                                out.println("<tr><td><table id='" + divId + "_" + aT + "_" + areaCounter + "_VimboxItemTable' width='100%'>" + col + "<tr><th colspan='6'><label id='" + divId + "_" + aT + "_VimboxItemTableLbl'>" + leadName + "</label></tr>");
    
                                                                int trCounter = 1;
                                                                ArrayList<Item> vimboxItems = new ArrayList<Item>();
                                                                for(Item item : leadArea.getVimboxItems()){
                                                                    vimboxItems.add(item);
                                                                }
                                                                vimboxItems.addAll(leadArea.getMaterials());
                                                                for(Item item : vimboxItems){
                                                                    out.println("<tr id='" + aT + "_" + areaCounter + "_SelectedVimboxTable_tr" + trCounter + "'>");
                                                                    out.println("<td><input type='hidden' value='" + item.getName() + "' name='" + divId + "_" + aT + "_" + areaCounter + "_VimboxName'>" + item.getName() + "</td>");
                                                                    String remark = item.getRemark();
                                                                    if(remark.isEmpty()){
                                                                        remark = "&nbsp;";
                                                                    }
                                                                    out.println("<td><input type='hidden' value='" + item.getRemark() + "' name='" + divId + "_" + aT + "_" + areaCounter + "_VimboxRemarks'>" + remark + "</td>");
                                                                    String charges = item.getCharges() + "";
                                                                    String chargesValue = item.getCharges() + "";
                                                                    if(charges.equals("0.0")){
                                                                        charges = "&nbsp;";
                                                                        chargesValue = "";
                                                                    }
                                                                    out.println("<td align='center'><input type='hidden' value='" + chargesValue + "' name='" + divId + "_" + aT + "_" + areaCounter + "_VimboxAddCharges'>" + charges + "</td>");
                                                                    out.println("<td align='center'><input type='hidden' value='" + item.getQty() + "' name='" + divId + "_" + aT + "_" + areaCounter + "_VimboxQuantity'>" + item.getQty() + "</td>");
                                                                    out.println("<td align='center'><input type='hidden' value='" + item.getUnits() + "' name='" + divId + "_" + aT + "_" + areaCounter + "_VimboxUnits'>" + item.getUnits() + "</td>");
                                                                    out.println("<td align='center'><input type='button' value='x' onclick=\"deleteSiteItem(this, '" + aT + "_" + areaCounter + "_SelectedVimboxTable" + "', '" + divId + "')\"/></td>");
                                                                    out.println("</tr>");
                                                                    trCounter++;
                                                                }
                                                                out.println("</table></td></tr>");
                                                            }
                                                        }
                                %>
                                                    </tbody>
                                                </table>
                                            </div>
                                <%
                                            out.println("</td>");
                                            out.println("</tr>");
                                            
                                        out.println("</table>");
                                        out.println("</td>");
                                        
                                        out.println("<td valign='top'>");
                                        out.println("<table width='100%' border='1'>");
                                            out.println("<col width='50%'");
                                            out.println("<tr>");
                                            out.println("<td align='right'><b>Storeys :</b></td>");
                                            out.println("<td><input type='text' name='" + divId + "_storeys' size='5' value='");
                                            if(addrDetails != null){
                                                out.println(addrDetails[0]);
                                            }
                                            out.println("'></td></tr>");

                                            out.println("<tr>");
                                            out.println("<td align='right'><b>Pushing Distance :</b></td>");
                                            out.println("<td><input type='text' name='" + divId + "_distance' size='5' value='");
                                            if(addrDetails != null){
                                                out.println(addrDetails[1]);
                                            }
                                            out.println("'> m</td>");
                                            out.println("</tr>");
                                            
                                            out.println("<tr style='background-color:DarkCyan;'>");
                                            out.println("<td align='center' colspan='2'><b>CHARGES</b></td>");
                                            out.println("</tr>");
                                            
                                            HashMap<String, String> otherCharges = leadDiv.getOtherCharges();
                                            out.println("<tr>");
                                            out.println("<td align='right'><b>Storey Charges :</b></td>");
                                            out.println("<td>$ <input type='number' name='" + divId + "_storeyCharge' step='0.01' min='0' value='" + otherCharges.get("storeyCharge") + "'></td>");
                                            out.println("</tr>");
                                            
                                            out.println("<tr>");
                                            out.println("<td align='right'><b>Pushing Charges :</b></td>");
                                            out.println("<td>$ <input type='number' name='" + divId + "_pushCharge' step='0.01' min='0' value='" + otherCharges.get("pushCharge") + "'></td>");
                                            out.println("</tr>");
                                            
                                            out.println("<tr>");
                                            out.println("<td align='right'><b>Detour Charges :</b></td>");
                                            out.println("<td>$ <input type='number' name='" + divId + "_detourCharge' step='0.01' min='0' value='" + otherCharges.get("detourCharge") + "'></td>");
                                            out.println("</tr>");
                                            
                                            out.println("<tr>");
                                            out.println("<td align='right'><b>Material Charges :</b></td>");
                                            out.println("<td>$ <input type='number' id='" + divId + "_materialCharge' name='" + divId + "_materialCharge' step='0.01' min='0' value='" + otherCharges.get("materialCharge") + "'></td>");
                                            out.println("</tr>");
                                            
                                            out.println("<tr>");
                                            out.println("<td align='right'><b>Discount :</b></td>");
                                            out.println("<td>$ <input type='number' name='" + divId + "_discount' step='0.01' min='0' value='" + otherCharges.get("discount") + "'></td>");
                                            out.println("</tr>");
                                            
                                            out.println("<tr>");
                                            out.println("<td colspan='2'><button onclick=\"selectService('" + divId + "');return false;\" style='width:100%;'>SERVICES</button></td>");
                                            out.println("</td></tr>");
                                            
                                            out.println("<tr>");
                                            out.println("<td colspan='2' valign='top' height='100'>");
                                %>
                                            <div style="overflow:auto;height:100%;">
                                                <table class="servicesTable" id="<%=divId%>_servicesTable" valign="top" width="100%">
                                                    <tbody>
                                <%
                                                    ArrayList<String[]> services = leadDiv.getServices();
                                                    for (String[] service : services) {
                                                        String[] svc = service[0].split("_");
                                                        String tr = "<tr id='" + divId + "_" + service[0] + "'><td>";
                                                        tr += "<table class='serviceTable' width='100%'>";
                                                        String secSvc = "";
                                                        for (int i = 1; i < svc.length; i++) {
                                                            secSvc += (svc[i]);
                                                            if (i < svc.length - 1) {
                                                                secSvc += " ";
                                                            }
                                                        }

                                                        tr += "<tr height='10%'><td>" + svc[0] + " - " + secSvc + "<input type='hidden' name='" + divId + "_serviceName' value='" + service[0] + "'></td><td align='right'>$ <input type='number' step='0.01' min='0' name='" + divId + "_serviceCharge' value='" + service[1] + "'><input type='hidden' value='" + service[2] + "'></td></tr>";
                                                        tr += "</table></td></tr>";
                                                        out.println(tr);
                                                    }
                                %> 
                                                    </tbody>
                                                </table>
                                            </div>
                                <%
                                            out.println("</td>");
                                            
                                            out.println("<tr style='height:10%;background-color:Plum;'>");
                                            out.println("<td align='center' colspan='2'><b>COMMENTS</b></td>");
                                            out.println("</tr>");
                                            
                                            ArrayList<String> comments = leadDiv.getComments();
                                            String comment = "";
                                            for(String c : comments){
                                                comment += c + " ";
                                            }
                                            out.println("<tr height='71'>");
                                            out.println("<td colspan='2'><input name='" + divId + "_comments' style='width:99%;height:100%' value='" + comment + "'></td>");
                                            out.println("</tr>");
                                            
                                        out.println("</table>");
                                        out.println("</td>"); 
                                        out.println("</tr>");
                                        out.println("</table>");
                                %>            
                                        <div id="<%=divId%>_serviceModal" class="service">
                                            <!-- Modal content -->
                                            <div class="service-content">
                                                <div class="service-body">
                                                    <span class="close" onclick="closeModal('<%=divId%>_serviceModal')">×</span>
                                                    <table width="100%" border="1" style="table-layout: fixed;" id="<%=divId%>_serviceTable">
                                <%
                                                        for (int i = 0; i < serviceTable.length; i++) {
                                                            out.println("<tr>");
                                                            for (int j = 0; j < serviceTable[i].length; j++) {
                                                                if (i == 0) {
                                                                    // Table Header //
                                                                    out.println("<th>" + serviceTable[i][j] + "</th>");
                                                                } else {
                                                                    // Table Data //
                                                                    String[] serviceChargeArray = serviceTable[i][j].split(",");
                                                                    out.println("<td bgcolor='#6698FF' align='center' onclick=\"selectServiceSlot(this, '" + divId + "')\"");
                                                                    if (serviceTable[0][j].equals("Manpower")) {
                                                                        out.println("id='" + divId + (serviceTable[0][j] + "_" + serviceChargeArray[0]).replaceAll(" ", "_") + "_service'");
                                                                    }
                                                                    out.println(">" + serviceChargeArray[0] + "</br>");

                                                                    if (serviceTable[0][j].equals("Manpower")) {
                                                                        String id = (serviceTable[0][j] + "_" + serviceChargeArray[0]).replaceAll(" ", "_");
                                                                        String mp = "";
                                                                        String mr = "";
                                                                        for (String[] svc : services) {
                                                                            if (svc[0].replaceAll(" ", "_").equals(id)) {
                                                                                mp = svc[3];
                                                                                mr = svc[4];
                                                                                break;
                                                                            }
                                                                        }
                                                                        out.println("Manpower : <label id='" + divId + "_" + id + "manpowerLabel'>" + mp + "</label><input type='hidden' name='" + divId + "_" + id + "manpowerInput' id='" + divId + "_" + id + "manpowerInput' value='" + mp + "'></br>");
                                                                        out.println("Reason : <label id='" + divId + "_" + id + "manpowerReasonLabel'>" + mr + "</label><input type='hidden' name='" + divId + "_" + id + "reasonInput' id='" + divId + "_" + id + "reasonInput' value='" + mr + "'></br>");
                                                                    }
                                                                    try {
                                                                        out.println("<input type='hidden' name='svcTableCell' value='{" + serviceTable[0][j] + "|" + serviceChargeArray[0] + "," + serviceChargeArray[1] + "}'>");
                                                                    } catch (IndexOutOfBoundsException e) {
                                                                    }

                                                                    out.println("</td>");
                                                                }
                                                            }
                                                            out.println("</tr>");
                                                        }
                                %>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                                    
                                        <div id="<%=divId%>_manpowerModal" class="modal">
                                            <!-- Modal content -->
                                            <div class="modal-content">
                                                <div class="modal-body">
                                                    <h3>Manpower Request</h3><hr>
                                                    <input type="hidden" id="<%=divId%>_manpowerId">
                                                    <table width="100%">
                                                        <tr>
                                                            <td align="right">Additional Manpower :</td>
                                                            <td><input type="number" id="<%=divId%>_additionalManpower"></td>
                                                        </tr>
                                                        <tr>
                                                            <td align="right">Reason :</td>
                                                            <td><input type="text" id="<%=divId%>_manpowerReason" style="width:90%"></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <button align="center" onclick="closeManpowerModal('<%=divId%>'); return false;" style="width:100%;">CANCEL</button>
                                                            </td>
                                                            <td>
                                                                <button align="center" onclick="submitManpower('<%=divId%>');
                                                            return false;" style="width:100%;">REQUEST</button>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                <%
                                        out.println("</fieldset>");
                                    }
                                %>
                            </div>
                            
                                <%
                                    ArrayList<LeadDiv> leadDivs = lead.getSalesDivs();
                                    for(LeadDiv leadDiv : leadDivs){
                                        ArrayList<LeadArea> areas = leadDiv.getLeadAreas();
                                        String salesDiv = leadDiv.getSalesDiv().split("\\|")[0];
                                        for(LeadArea leadArea : areas){
                                            String leadAreaString = leadArea.getLeadAreaDiv();
                                            if(!leadAreaString.isEmpty()){
                                                String[] leadAreaDiv = leadAreaString.split("_");
                                                String leadName = leadArea.getLeadName();
                                                String aT = leadAreaDiv[0];
                                                String areaCounter = leadAreaDiv[1];
                                                out.println("<div id='" + aT + "_div_" + areaCounter + "' class='survey_area_div' style='display:none'>");
                                %>
                                <table width="100%" border="1" height="100%">
                                    <col width="33%">
                                    <col width="33%">
                                    <tr height="20">
                                        <td colspan="2">
                                            <input type="hidden" class="lblId" value="<%=aT%>_lbl_<%=areaCounter%>|<%=salesDiv%>">
                                            Area Name : <input type="text" id="siteArea_name" name="<%=salesDiv%>+<%=aT%>_<%=areaCounter%>+siteAreaName" value="<%=leadName%>">
                                        </td>
                                        <td>
                                            Total Units : <label id="<%=aT%>_<%=areaCounter%>_total">0</label>
                                            <span class='close' onClick="confirmRemoveArea('<%=salesDiv%>', '<%=aT%>', '<%=areaCounter%>');">×</span>
                                        </td>
                                    </tr>
                                    <tr height="100">
                                        <!-- Item Menu -->
                                        <td colspan="2">
                                            <table width="100%">
                                                <tr>
                                                    <td colspan="2">
                                                        <input type="text" id="<%=aT%>_<%=areaCounter%>_search" placeholder="Search Item Name" style="width:100%">
                                                    </td>
                                                    <td>
                                                        <button style="width:100%" onclick="loadSurveyItemsTable($('#<%=aT%>_<%=areaCounter%>_search').val(), '<%=aT%>', '<%=areaCounter%>', '<%=salesDiv%>'); return false;">Search</button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2" width="50%" align="center" class="selected" onclick="showTableDiv(this, '<%=aT%>', '<%=areaCounter%>', 'ItemsDiv'); return false;"><b>CUSTOMER</b></td>
                                                    <td align="center" onclick="showTableDiv(this, '<%=aT%>', '<%=areaCounter%>', 'VimboxDiv'); return false;"><b>VIMBOX</b></td>
                                                </tr>
                                                <tr>
                                                    <td colspan="3" height="690">
                                                        <div style="overflow:auto;height:100%;" id="<%=aT%>_<%=areaCounter%>_ItemsDiv">

                                                        </div>
                                                        <div style="overflow:auto;height:100%;display:none;" id="<%=aT%>_<%=areaCounter%>_VimboxDiv">

                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <!-- Item List -->
                                        <td>
                                            <div style="overflow:auto;height:100%;">
                                                <table width="100%">
                                                    <col width="20%">
                                                    <col width="45%">
                                                    <col width="10%">
                                                    <col width="10%">
                                                    <col width="10%">
                                                    <col width="5%">
                                                    <tr style="background-color:DarkOrange" height="10%">
                                                        <td align="center" colspan="6"><b><u>Customer Item List</u></b></td>
                                                    </tr>
                                                    <tr height="10%">
                                                        <td align="center"><b>Item</b></td>
                                                        <td align="center"><b>Remarks</b></td>
                                                        <td align="center"><b>Additional Charges</b></td>
                                                        <td align="center"><b>Qty</b></td>
                                                        <td align="center"><b>Units</b></td>
                                                        <td align="center"></td>
                                                    </tr>
                                                    <tr height="300">
                                                        <td colspan="6" valign="top">
                                                            <table width="100%" id="<%=aT%>_<%=areaCounter%>_SelectedItemsTable">
                                                                <col width="20%">
                                                                <col width="45%">
                                                                <col width="10%">
                                                                <col width="10%">
                                                                <col width="10%">
                                                                <col width="5%">
                                                                <tbody>
                                <%
                                                                ArrayList<Item> customerItems = leadArea.getCustomerItems();
                                                                int trCounter = 1;
                                                                for(Item item : customerItems){
                                                                    out.println("<tr id='" + aT + "_" + areaCounter + "_SelectedItemsTable_tr" + trCounter + "'>");
                                                                    out.println("<td><input type='hidden' value='" + item.getName() + "'>" + item.getName() + "</td>");
                                                                    String remark = item.getRemark();
                                                                    if(remark.isEmpty()){
                                                                        remark = "&nbsp;";
                                                                    }
                                                                    out.println("<td><input type='hidden' value='" + item.getRemark() + "'>" + remark + "</td>");
                                                                    String charges = item.getCharges() + "";
                                                                    String chargesValue = item.getCharges() + "";
                                                                    if(charges.equals("0.0")){
                                                                        charges = "&nbsp;";
                                                                        chargesValue = "";
                                                                    }
                                                                    out.println("<td align='center'><input type='hidden' value='" + chargesValue + "'>" + charges + "</td>");
                                                                    out.println("<td align='center'><input type='hidden' value='" + item.getQty() + "'>" + item.getQty() + "</td>");
                                                                    out.println("<td align='center'><input type='hidden' value='" + item.getUnits() + "'>" + item.getUnits() + "</td>");
                                                                    out.println("<td align='center'><input type='button' value='x' onclick=\"deleteSiteItem(this, '" + aT + "_" + areaCounter + "_SelectedItemsTable" + "', '" + salesDiv + "')\"/></td>");
                                                                    out.println("</tr>");
                                                                    trCounter++;
                                                                }
                                %>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr style="background-color:CornflowerBlue" height="10%">
                                                        <td align="center" colspan="6"><b><u>Vimbox Item List</u></b></td>
                                                    </tr>
                                                    <tr height="10%">
                                                        <td align="center"><b>Item</b></td>
                                                        <td align="center"><b>Remarks</b></td>
                                                        <td align="center"><b>Additional Charges</b></td>
                                                        <td align="center"><b>Qty</b></td>
                                                        <td align="center"><b>Units</b></td>
                                                        <td align="center"></td>
                                                    </tr>
                                                    <tr height="300">
                                                        <td colspan="6" valign="top">
                                                            <table width="100%" id="<%=aT%>_<%=areaCounter%>_SelectedVimboxTable">
                                                                <col width="20%">
                                                                <col width="45%">
                                                                <col width="10%">
                                                                <col width="10%">
                                                                <col width="10%">
                                                                <col width="5%">
                                                                <tbody>
                                <%
                                                                ArrayList<Item> vimboxItems = new ArrayList<Item>();
                                                                for(Item item : leadArea.getVimboxItems()){
                                                                    vimboxItems.add(item);
                                                                }
                                                                vimboxItems.addAll(leadArea.getMaterials());
                                                                trCounter = 1;
                                                                for(Item item : vimboxItems){
                                                                    out.println("<tr id='" + aT + "_" + areaCounter + "_SelectedVimboxTable_tr" + trCounter + "'>");
                                                                    out.println("<td><input type='hidden' value='" + item.getName() + "'>" + item.getName() + "</td>");
                                                                    String remark = item.getRemark();
                                                                    if(remark.isEmpty()){
                                                                        remark = "&nbsp;";
                                                                    }
                                                                    out.println("<td><input type='hidden' value='" + item.getRemark() + "'>" + remark + "</td>");
                                                                    String charges = item.getCharges() + "";
                                                                    String chargesValue = item.getCharges() + "";
                                                                    if(charges.equals("0.0")){
                                                                        charges = "&nbsp;";
                                                                        chargesValue = "";
                                                                    }
                                                                    out.println("<td align='center'><input type='hidden' value='" + chargesValue + "'>" + charges + "</td>");
                                                                    out.println("<td align='center'><input type='hidden' value='" + item.getQty() + "'>" + item.getQty() + "</td>");
                                                                    out.println("<td align='center'><input type='hidden' value='" + item.getUnits() + "'>" + item.getUnits() + "</td>");
                                                                    out.println("<td align='center'><input type='button' value='x' onclick=\"deleteSiteItem(this, '" + aT + "_" + areaCounter + "_SelectedVimboxTable" + "', '" + salesDiv + "')\"/></td>");
                                                                    out.println("</tr>");
                                                                    trCounter++;
                                                                }
                                %>                                      
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr height="20">
                                        <td align="center" onclick="addNew('<%=aT%>', '<%=areaCounter%>', ''); return false;">New</td>
                                        <td align="center" onclick="addNew('<%=aT%>', '<%=areaCounter%>', 'Special'); return false;">Special</td>
                                        <td>
                                            <input type="submit" style="width:100%;" value="SAVE">
                                        </td>
                                    </tr>
                                </table>
                                            
                                            
                                <%
                                                out.println("</div>");
                                            }
                                        }
                                    }
                                %>
                        </div>
                    </td>
                </tr>
            </table>
        </form>                    
        <div id="item_details_modal" class="modal">
            <!-- Modal content -->
            <div class="item-details-modal-content">
                <div class="modal-body" style="height:100%">
                    <span class="close" onclick="closeItemModal('item_details_modal')">×</span>
                    <input type="hidden" id="itemTableId">
                    <input type="hidden" id="itemSalesDiv">
                    <table width="100%" border="1" style="height:95%" id='item_details_table'>
                        <tr height="10%">
                            <td colspan="3">Item : <label id="itemName"></label></td>
                        </tr>
                        <tr height="10%">
                            <td colspan="3">Dimensions : <label id="itemDimensions"></label></td>
                        </tr>
                        <tr height="10%">
                            <td onclick="selectItemDetail(this, 'itemUnits'); return false;" width="33%">
                                Units : <label id="itemUnits"></label>
                            </td>
                            <td onclick="selectItemDetail(this, 'itemQty'); return false;" width="33%">
                                Quantity : <label id="itemQty"></label>
                            </td>
                            <td onclick="selectItemDetail(this, 'itemAddChrges'); return false;" width="33%">
                                Charges : <label id="itemAddChrges"></label>
                            </td>
                        </tr>
                        <tr height="10%">
                            <td colspan="3">Remarks : <input type="text" id="itemRemarks" style="width:80%"></td>
                        </tr>
                        <tr height="50%">
                            <td colspan="3">
                                <table width="100%" border="1" height="100%">
                                    <%
                                        String[] numpad = new String[]{"1", "2", "3", "4", "5", "6", "7", "8", "9", " ", "0", "<"};
                                        for(int i=0; i<numpad.length; i+=3){
                                            out.println("<tr>");
                                            out.println("<td align='center' onclick=\"addNum('" + numpad[i] + "')\"><b>" + numpad[i] + "</b></td>");
                                            out.println("<td align='center' onclick=\"addNum('" + numpad[i+1] + "')\"><b>" + numpad[i+1] + "</b></td>");
                                            out.println("<td align='center' onclick=\"addNum('" + numpad[i+2] + "')\"><b>" + numpad[i+2] + "</b></td>");
                                            out.println("</tr>");
                                        }
                                    %>
                                </table>
                            </td>
                        </tr>
                        <tr height='10%'>
                            <td colspan="2" width="50%"><button style='width:100%;height:100%;' onclick="closeItemModal('item_details_modal')">Cancel</button></td>
                            <td width="50%"><button style='width:100%;height:100%;' onclick="addItem($('#itemTableId').val(), $('#itemSalesDiv').val())">Add</button></td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div id="survey_error_modal" class="modal">
            <!-- Modal content -->
            <div class="message-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('survey_error_modal')">×</span>
                    <div id="survey_error_status"></div>
                    <hr>
                    <div id="survey_error_message"></div>
                </div>
            </div>
        </div> 
                                
        <script>  
            $('#siteSurvey_form').ajaxForm({
                dataType: 'json',
                success: function (data) {
                    var modal = document.getElementById("survey_error_modal");
                    var status = document.getElementById("survey_error_status");
                    var message = document.getElementById("survey_error_message");
                    status.innerHTML = data.status;
                    message.innerHTML = data.message;
                    modal.style.display = "block";

                    if (data.completed === "YES") {
                        setTimeout(function () {
                            window.location.href = "MySites.jsp";
                        }, 500);
                    }
                },
                error: function (data) {
                    var modal = document.getElementById("survey_error_modal");
                    var status = document.getElementById("survey_error_status");
                    var message = document.getElementById("survey_error_message");
                    status.innerHTML = "ERROR";
                    message.innerHTML = data;
                    modal.style.display = "block";
                }
            });
        </script>
    </body>
</html>
