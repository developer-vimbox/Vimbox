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
<%@include file="LoadServices.jsp"%>
<script src="JS/SiteSurveyFunctions.js"></script>
<script src="JS/ModalFunctions.js"></script>
<%    String fieldId = request.getParameter("getField");
    String divId = request.getParameter("getDivId");
    String address = request.getParameter("address");
    String leadId = request.getParameter("leadId");
    Lead lead = LeadDAO.getLeadById(Integer.parseInt(leadId));
%>

<%
    String[] addrDetails = lead.getStoreysPushingDFrom(address);
    LeadDiv leadDiv = lead.getSalesDivByAddress(address);
    out.println("<fieldset id='" + divId + "'>");

    out.println("<div id='" + divId + "' class='tab-pane active' >");
    out.println("<table width='100%' border='1'' id='table_" + divId + " >");

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
    out.println("<td valign='top' height='150' colspan='6'>");%>
<div style="overflow:auto;height:100%;">
    <table id="<%=divId%>_CustomerItemTable" valign="top" width="100%">
        <tbody>
            <%
                ArrayList<LeadArea> areas = leadDiv.getLeadAreas();
                for (LeadArea leadArea : areas) {
                    String leadAreaString = leadArea.getLeadAreaDiv();
                    if (!leadAreaString.isEmpty()) {
                        String[] leadAreaDiv = leadAreaString.split("_");
                        String leadName = leadArea.getLeadName();
                        String aT = leadAreaDiv[0];
                        String areaCounter = leadAreaDiv[1];

                        out.println("<tr><td><table id='" + divId + "_" + aT + "_" + areaCounter + "_CustomerItemTable' width='100%'>" + col + "<tr><th colspan='6'><label id='" + divId + "_" + aT + "_CustomerItemTableLbl'>" + leadName + "</label></tr>");

                        ArrayList<Item> customerItems = leadArea.getCustomerItems();
                        int trCounter = 1;
                        for (Item item : customerItems) {
                            out.println("<tr id='" + aT + "_" + areaCounter + "_SelectedItemsTable_tr" + trCounter + "'>");
                            out.println("<td><input type='hidden' value='" + item.getName() + "' name='" + divId + "_" + aT + "_" + areaCounter + "_CustomerName'>" + item.getName() + "</td>");
                            String remark = item.getRemark();
                            if (remark.isEmpty()) {
                                remark = "&nbsp;";
                            }
                            out.println("<td><input type='hidden' value='" + item.getRemark() + "' name='" + divId + "_" + aT + "_" + areaCounter + "_CustomerRemarks'>" + remark + "</td>");
                            String charges = item.getCharges() + "";
                            String chargesValue = item.getCharges() + "";
                            if (charges.equals("0.0")) {
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
                for (LeadArea leadArea : areas) {
                    String leadAreaString = leadArea.getLeadAreaDiv();
                    if (!leadAreaString.isEmpty()) {
                        String[] leadAreaDiv = leadAreaString.split("_");
                        String leadName = leadArea.getLeadName();
                        String aT = leadAreaDiv[0];
                        String areaCounter = leadAreaDiv[1];

                        out.println("<tr><td><table id='" + divId + "_" + aT + "_" + areaCounter + "_VimboxItemTable' width='100%'>" + col + "<tr><th colspan='6'><label id='" + divId + "_" + aT + "_VimboxItemTableLbl'>" + leadName + "</label></tr>");

                        int trCounter = 1;
                        ArrayList<Item> vimboxItems = new ArrayList<Item>();
                        for (Item item : leadArea.getVimboxItems()) {
                            vimboxItems.add(item);
                        }
                        vimboxItems.addAll(leadArea.getMaterials());
                        for (Item item : vimboxItems) {
                            out.println("<tr id='" + aT + "_" + areaCounter + "_SelectedVimboxTable_tr" + trCounter + "'>");
                            out.println("<td><input type='hidden' value='" + item.getName() + "' name='" + divId + "_" + aT + "_" + areaCounter + "_VimboxName'>" + item.getName() + "</td>");
                            String remark = item.getRemark();
                            if (remark.isEmpty()) {
                                remark = "&nbsp;";
                            }
                            out.println("<td><input type='hidden' value='" + item.getRemark() + "' name='" + divId + "_" + aT + "_" + areaCounter + "_VimboxRemarks'>" + remark + "</td>");
                            String charges = item.getCharges() + "";
                            String chargesValue = item.getCharges() + "";
                            if (charges.equals("0.0")) {
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
    if (addrDetails != null) {
        out.println(addrDetails[0]);
    }
    out.println("'></td></tr>");

    out.println("<tr>");
    out.println("<td align='right'><b>Pushing Distance :</b></td>");
    out.println("<td><input type='text' name='" + divId + "_distance' size='5' value='");
    if (addrDetails != null) {
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
    for (String c : comments) {
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
                        <button align="center" onclick="closeManpowerModal('<%=divId%>');
                                return false;" style="width:100%;">CANCEL</button>
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

%>