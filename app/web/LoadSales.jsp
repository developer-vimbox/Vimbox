<%@page import="com.vimbox.database.LeadPopulationDAO"%>
<%@page import="java.util.ArrayList"%>
<%
    ArrayList<String[]> existingItems = LeadPopulationDAO.getExistingItems();
    ArrayList<String> existingSpecialItems = LeadPopulationDAO.getExistingSpecialItems();

    ArrayList<String> primaryServices = LeadPopulationDAO.getPrimaryServices();

    ArrayList<ArrayList<String>> secondaryServices = new ArrayList<ArrayList<String>>();
    int max = 0;
    for (String primaryService : primaryServices) {
        ArrayList<String> secondaryService = LeadPopulationDAO.getSecondaryServices(primaryService);
        for (int i = 0; i < secondaryService.size(); i++) {
            String secSvc = secondaryService.get(i);
            String formula = LeadPopulationDAO.getServiceFormula(primaryService, secSvc);
            String str = secSvc + "," + formula;
            secondaryService.set(i, str);
        }
        secondaryServices.add(secondaryService);
        if (secondaryService.size() > max) {
            max = secondaryService.size();
        }
    }
    String[][] serviceTable = new String[max + 1][primaryServices.size()];
    for (int i = 0; i < serviceTable.length; i++) {
        for (int j = 0; j < serviceTable[i].length; j++) {
            if (i == 0) {
                // Table Header //
                serviceTable[i][j] = primaryServices.get(j);
            } else {
                // Table Data //
                ArrayList<String> secSvc = secondaryServices.get(j);
                try {
                    serviceTable[i][j] = secSvc.get(i - 1);
                } catch (Exception e) {
                    serviceTable[i][j] = "";
                    e.printStackTrace();
                }
            }
        }
    }

    String divId = request.getParameter("counter");
%>
<input type="hidden" id="<%=divId%>_divId" class="divId" name="divId">
<table class="salesInfoTable">
    <tr>
        <td style="width:30%;">
            <table border="1" class="salesTable">
                <tr style="background-color:DarkOrange">
                    <td colspan="2" align="center"><b><u>Customer Item List</u></b></td>
                </tr>
                <tr>
                    <td align="right">Box :</td>
                    <td>
                        <table class="customerBoxTable">
                            <col width="80">
                            <tr>
                                <td align="right">Quantity :</td>
                                <td>
                                    <input type="number" min="0" id="<%=divId%>_customerBoxUnit">
                                    <button onclick="addCustomerBox('<%=divId%>');
                                            return false;">Add box</button>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="right">Item :</td>
                    <td>
                        <table class="customerItemTable">
                            <col width="80">
                            <tr>
                                <td align="right">Name :</td>
                                <td>
                                    <input type="text" size="40" class="itemName" id="<%=divId%>_itemName" list="<%=divId%>_items" placeholder="Enter item">

                                    <datalist id="<%=divId%>_items">
                                        <%                                            for (String[] item : existingItems) {
                                                String value = item[0] + " " + item[1] + "|" + item[2] + "|" + item[3];
                                                out.println("<option data-value='" + value + "' value='" + item[0] + " " + item[1] + "'>");
                                            }
                                        %>
                                    </datalist>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <input type="text" size="40" id="<%=divId%>_itemdimensions" placeholder="Dimensions" disabled>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Units :</td>
                                <td>
                                    <input type="number" min="0" id="<%=divId%>_itemUnit">
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Quantity :</td>
                                <td>
                                    <input type="number" min="0" id="<%=divId%>_itemQty">
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Remarks :</td>
                                <td>
                                    <input type="text" size="40" id="<%=divId%>_itemRemark" placeholder="Enter item remarks">
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <button onclick="addItem('<%=divId%>');
                                            return false;">Add item</button>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="right">Special Item :</td>
                    <td>
                        <table class="customerSpecialItemTable">
                            <col width="80">
                            <tr>
                                <td align="right">Name :</td>
                                <td>
                                    <input type="text" size="40" id="<%=divId%>_specialItemName" list="<%=divId%>_specialitems" placeholder="Enter item">

                                    <datalist id="<%=divId%>_specialitems">
                                        <%
                                            for (String specialItem : existingSpecialItems) {
                                                out.println("<option  value='" + specialItem + "'>");
                                            }
                                        %>
                                    </datalist>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Units :</td>
                                <td>
                                    <input type="number" min="0" id="<%=divId%>_specialItemUnit">
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Quantity :</td>
                                <td>
                                    <input type="number" min="0" id="<%=divId%>_specialItemQty">
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Additional Charges :</td>
                                <td>
                                    $ <input type="number" min="0" step="0.01" id="<%=divId%>_specialItemCharges">
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Remarks :</td>
                                <td>
                                    <input type="text" size="40" id="<%=divId%>_specialItemRemark" placeholder="Enter item remarks">
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <button onclick="addSpecialItem('<%=divId%>');
                                            return false;">Add special</button>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr style="background-color:CornflowerBlue">
                    <td colspan="2" align="center"><b><u>Vimbox Item List</u></b></td>
                </tr>
                <tr>
                    <td align="right">Box :</td>
                    <td>
                        <table class="vimboxBoxTable">
                            <col width="80">
                            <tr>
                                <td align="right">Quantity :</td>
                                <td>
                                    <input type="number" min="0" id="<%=divId%>_vimboxBoxUnit">
                                    <button onclick="addVimboxBox('<%=divId%>');
                                            return false;">Add box</button>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="right">Material :</td>
                    <td>
                        <table class="vimboxMaterialTable">
                            <col width="80">
                            <tr>
                                <td align="right">Item :</td>
                                <td>
                                    <input type="text" id="<%=divId%>_vimboxMaterial">
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Quantity :</td>
                                <td>
                                    <input type="number" step="0.01" min="0" id="<%=divId%>_vimboxMaterialUnit">
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Charges :</td>
                                <td>
                                    $ <input type="number" min="0" step="0.01" id="<%=divId%>_vimboxMaterialCharge">
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <button onclick="addVimboxMaterial('<%=divId%>');
                                            return false;">Add material</button>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr style="background-color:DarkCyan">
                    <td colspan="2" align="center"><b><u>Services</u></b></td>
                </tr>
                <tr>
                    <td align="right">Svcs :</td>
                    <td align="center">
                        <button style="width:100%" onclick="selectService('<%=divId%>');
                                return false;">Add service</button>
                        <!-- Service Modal -->
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
                                                            out.println("Manpower : <label id='" + divId + "_" + id + "manpowerLabel'></label><input type='hidden' name='" + divId + "_" + id + "manpowerInput' id='" + divId + "_" + id + "manpowerInput'></br>");
                                                            out.println("Reason : <label id='" + divId + "_" + id + "manpowerReasonLabel'></label><input type='hidden' name='" + divId + "_" + id + "reasonInput' id='" + divId + "_" + id + "reasonInput'></br>");
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
                    </td>
                </tr> 
                <tr style="background-color:Plum">
                    <td colspan="2" align="center"><b><u>Comments & Remarks</u></b></td>
                </tr>
                <tr>
                    <td align="right">Cmt :</td>
                    <td>
                        <table class="customerCommentTable">
                            <tr>
                                <td>
                                    <input type="text" size="40" id="<%=divId%>_customerComment" placeholder="Enter customer comment">
                                </td>
                                <td>
                                    <button onclick="addCustomerComment('<%=divId%>');
                                            return false;">Add Comment</button>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="right">Rmk :</td>
                    <td>
                        <table class="customerRemarkTable">
                            <tr>
                                <td>
                                    <input type="text" size="40" id="<%=divId%>_customerRemark" placeholder="Enter remark for customer">
                                </td>
                                <td>
                                    <button onclick="addCustomerRemark('<%=divId%>');
                                            return false;">Add Remark</button>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
        <td style="width:70%;">
            <table class="vimboxSystemTable">
                <tr style="height:50%">
                    <td>
                        <table border="1">
                            <tr style="height:10%">
                                <th style="width:20%">Item</th>
                                <th style="width:40%">Remarks</th>
                                <th style="width:10%">Additional Charges</th>
                                <th style="width:10%">Quantity</th>
                                <th style="width:10%">Units</th>
                                <th style="width:20%"><div id="<%=divId%>_totalUnits"></div></th>
                </tr> 
                <tr>
                    <td colspan="6">
                        <table border="1">
                            <tr height="50%">
                                <td>
                                    <table border="1">
                                        <tr style="background-color:DarkOrange" height="10%">
                                            <td align="center"><b><u>Customer Item List</u></b></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div style="overflow:auto;height:100%;">
                                                    <table id="<%=divId%>_customerItemsTable" valign="top" style="width:100%;">
                                                        <col width="20%">
                                                        <col width="40%">
                                                        <col width="10%">
                                                        <col width="10%">
                                                        <col width="10%">
                                                        <col width="20%">
                                                        <tbody>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table border="1">
                                        <tr style="background-color:CornflowerBlue" height="10%">
                                            <td align="center"><b><u>Vimbox Item List</u></b></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div style="overflow:auto;height:100%;">
                                                    <table id="<%=divId%>_vimboxItemsTable" valign="top" style="width:100%;">
                                                        <col width="20%">
                                                        <col width="40%">
                                                        <col width="10%">
                                                        <col width="10%">
                                                        <col width="10%">
                                                        <col width="20%">
                                                        <tbody>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td> 
    </tr>
    <tr style="height:40%">
        <td>
            <table>
                <tr>
                    <td style="width:50%">
                        <table border="1">
                            <tr style="height:10%;background-color:DarkCyan;">
                                <th>Services</th>
                            </tr>
                            <tr>
                                <td>
                                    <div style="overflow:auto;height:100%;">
                                        <table class="servicesTable" id="<%=divId%>_servicesTable" valign="top" width="100%">
                                            <tbody></tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                            <tr height="5%">
                                <td>
                                    <table width="100%">
                                        <tr>
                                            <td align="left">Storey Charges :</td>
                                            <td align="right">$ <input type="number" step="0.01" min="0" id="<%=divId%>_storeyCharge" class="storeyCharge" name="<%=divId%>_storeyCharge" value="0.00"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr height="5%">
                                <td>
                                    <table width="100%">
                                        <tr>
                                            <td align="left">Pushing Charges :</td>
                                            <td align="right">$ <input type="number" step="0.01" min="0" id="<%=divId%>_pushCharge" class="pushCharge" name="<%=divId%>_pushCharge" value="0.00"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr height="5%">
                                <td>
                                    <table width="100%">
                                        <tr>
                                            <td align="left">Detour Charges :</td>
                                            <td align="right">$ <input type="number" step="0.01" min="0" id="<%=divId%>_detourCharge" class="detourCharge" name="<%=divId%>_detourCharge" value="0.00"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr height="5%">
                                <td>
                                    <table width="100%">
                                        <tr>
                                            <td align="left">Material Charges :</td>
                                            <td align="right">$ <input type="number" step="0.01" min="0" id="<%=divId%>_materialCharge" class="materialCharge" name="<%=divId%>_materialCharge" value="0.00"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr height="5%">
                                <td>
                                    <table width="100%">
                                        <tr>
                                            <td align="left">Additional Markup :</td>
                                            <td align="right">$ <input type="number" step="0.01" min="0" id="<%=divId%>_markup" class="markup" name="<%=divId%>_markup" value="0.00"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr height="5%">
                                <td>
                                    <table width="100%">
                                        <tr>
                                            <td align="left">Discount :</td>
                                            <td align="right">$ <input type="number" step="0.01" min="0" id="<%=divId%>_discount" class="discount" name="<%=divId%>_discount" value="0.00"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td>
                        <table>
                            <tr style="height:50%">
                                <td>
                                    <table border="1">
                                        <tr style="height:10%;background-color:Plum;">
                                            <th>Customer Comments</th>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div style="overflow:auto;height:100%;">
                                                    <table id="<%=divId%>_commentsTable" valign="top">
                                                        <tbody></tbody>
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table border="1">
                                        <tr style="height:10%;background-color:Plum;">
                                            <th>Customer Remarks</th>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div style="overflow:auto;height:100%;">
                                                    <table id="<%=divId%>_remarksTable" valign="top">
                                                        <tbody>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr style="height:10%">
        <td>
            <table border="1">
                <tr>
                    <td align="right" style="width:80%">Total :</td>
                    <td align="center">$ <input type="number" step="0.01" min="0" name="totalPrice" id="<%=divId%>_totalPrice" value="0.00"></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</td>
</tr>
</table>

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
