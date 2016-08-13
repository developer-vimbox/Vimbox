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
            <table class="table table-bordered salesTable" border="1">
                <thead>
                <tr style="background-color:#F5BCA9">
                    <td colspan="2"><center><b><u>Customer Item List</u></b></center></td>
                </tr>
                </thead>
                <tr>
                    <td align="right">Box :</td>
                    <td>
                        <table class="table  customerBoxTable">
<!--                            <col width="80">-->
                            <tr>
                                <td align="right">Quantity:</td>
                                <td>
                                    <input class='form-control' type="number" min="0" id="<%=divId%>_customerBoxUnit">
                                    <br>
                                    <button class='btn btn-default' onclick="addCustomerBox('<%=divId%>');
                                            return false;">Add</button>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="right">Item :</td>
                    <td>
                        <table class="table customerItemTable">
                            <col width="80">
                            <tr>
                                <td align="right">Name :</td>
                                <td>
                                    <input type="text" size="40" class="form-control itemName" id="<%=divId%>_itemName" list="<%=divId%>_items" placeholder="Enter item">

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
                                    <input class='form-control' type="text" size="40" id="<%=divId%>_itemdimensions" placeholder="Dimensions" disabled>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Units:</td>
                                <td>
                                    <input class='form-control' type="number" min="0" id="<%=divId%>_itemUnit">
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Quantity:</td>
                                <td>
                                    <input class='form-control' type="number" min="0" id="<%=divId%>_itemQty">
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Remarks:</td>
                                <td>
                                    <input class='form-control' type="text" size="40" id="<%=divId%>_itemRemark" placeholder="Enter item remarks">
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <button class='btn btn-default' onclick="addItem('<%=divId%>');
                                            return false;">Add item</button>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="right">Special Item :</td>
                    <td>
                        <table class="table customerSpecialItemTable">
                            <tr>
                                <td align="right">Name :</td>
                                <td>
                                    <input class='form-control' type="text" size="40" id="<%=divId%>_specialItemName" list="<%=divId%>_specialitems" placeholder="Enter item">

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
                                    <input class='form-control' type="number" min="0" id="<%=divId%>_specialItemUnit">
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Quantity:</td>
                                <td>
                                    <input class='form-control' type="number" min="0" id="<%=divId%>_specialItemQty">
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Additional Charges:</td>
                                <td>
                                    <div class="input-group">
                            <span class="input-group-addon">$</span>
                            <input class='form-control' type="number" min="0" step="0.01" id="<%=divId%>_specialItemCharges">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Remarks:</td>
                                <td>
                                    <input class='form-control' type="text" size="40" id="<%=divId%>_specialItemRemark" placeholder="Enter item remarks">
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <button class='btn btn-default' onclick="addSpecialItem('<%=divId%>');
                                            return false;">Add special</button>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr style="background-color:#CEE3F6">
                    <td colspan="2"><center><b><u>Vimbox Item List</u></b></center></td>
                </tr>
                <tr>
                    <td align="right">Box :</td>
                    <td>
                        <table class="table vimboxBoxTable">
                            <col width="80">
                            <tr>
                                <td align="right">Quantity:</td>
                                <td>
                                    
                                    <input class="form-control" type="number" min="0" id="<%=divId%>_vimboxBoxUnit">
                                    <br>
                                    <button class="btn btn-default" onclick="addVimboxBox('<%=divId%>');
                                            return false;">Add</button>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="right">Material:</td>
                    <td>
                        <table class="table vimboxMaterialTable">
                            <col width="80">
                            <tr>
                                <td align="right">Item :</td>
                                <td>
                                    <input class="form-control" type="text" id="<%=divId%>_vimboxMaterial">
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Quantity:</td>
                                <td>
                                    <input class="form-control" type="number" step="0.01" min="0" id="<%=divId%>_vimboxMaterialUnit">
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Charges:</td>
                                <td>
                                    <div class="input-group">
                            <span class="input-group-addon">$</span>
                            <input class="form-control" type="number" min="0" step="0.01" id="<%=divId%>_vimboxMaterialCharge">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <button class='btn btn-default' onclick="addVimboxMaterial('<%=divId%>');
                                            return false;">Add material</button>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr style="background-color:#A9F5D0">
                    <td colspan="2"><center><b><u>Services</u></b></center></td>
                </tr>
                <tr>
                    <td align="right">Svcs :</td>
                    <td align="center">
                        <button class='btn btn-default' style="width:100%" onclick="selectService('<%=divId%>');
                                return false;">Add service</button>
                        <!-- Service Modal -->
                        <div id="<%=divId%>_serviceModal" class="service">
                            <!-- Modal content -->
                            <div class="service-content">
                                <div class="service-body">
                                    <span class="close" onclick="closeModal('<%=divId%>_serviceModal')">×</span>
                                    <table class='table' width="100%" border="1" style="table-layout: fixed;" id="<%=divId%>_serviceTable">
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
                <tr style="background-color:#F6CEE3">
                    <td colspan="2"><center><b><u>Comments & Remarks</u></b></center></td>
                </tr>
                <tr>
                    <td align="right">Cmt :</td>
                    <td>
                        <table class="table customerCommentTable">
                            <tr>
                                <td>
                                    <input class='form-control' type="text" size="40" id="<%=divId%>_customerComment" placeholder="Enter customer comment">
                                    <br>
                                    <button class='btn btn-default' onclick="addCustomerComment('<%=divId%>');
                                            return false;">Add Comment</button>
                                </td>
                                
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="right">Rmk :</td>
                    <td>
                        <table class="table customerRemarkTable">
                            <tr>
                                <td>
                                    <input class='form-control' type="text" size="40" id="<%=divId%>_customerRemark" placeholder="Enter remark for customer">
                                    <br>
                                    <button class='btn btn-default' onclick="addCustomerRemark('<%=divId%>');
                                            return false;">Add Remark</button>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
        <td style="width:70%;">
            <table class="table table-bordered vimboxSystemTable">
                <tr style="height:50%;" >
                    <td>
                        <table class='table table-bordered' border="1">
                            <thead>
                            <tr style="height:10%">
                                <th style="width:20%">Item</th>
                                <th style="width:40%">Remarks</th>
                                <th style="width:10%">Additional Charges</th>
                                <th style="width:10%">Quantity</th>
                                <th style="width:10%">Units</th>
                                <th style="width:20%"><div id="<%=divId%>_totalUnits"></div></th>
                </tr> 
                                        </thead>
                <tr>
                    <td colspan="6">
                        <table class='table table-bordered' border="1">
                            <tr height="50%">
                                <td>
                                    <table class='table table-bordered' border="1">
                                        <thead>
                                        <tr style="background-color:#F5BCA9" height="10%">
                                            <td><center><b><u>Customer Item List</u></b></center></td>
                                        </tr>
                                        </thead>
                                        <tr>
                                            <td>
                                                <div style="overflow:auto;height:100%;">
                                                    <table class='table' id="<%=divId%>_customerItemsTable" valign="top" style="width:100%;">
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
                                    <table class='table table-bordered' border="1">
                                        <thead>
                                        <tr style="background-color:#CEE3F6" height="10%">
                                            <td><center><b><u>Vimbox Item List</u></b></center></td>
                                        </tr>
                                        </thead>
                                        <tr>
                                            <td>
                                                <div style="overflow:auto;height:100%;">
                                                    <table class='table' id="<%=divId%>_vimboxItemsTable" valign="top" style="width:100%;">
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
            <table class="table table-bordered">
                <tr>
                    <td style="width:50%">
                        <table> 
                            <tr style="height:10%;background-color:#A9F5D0!important;">
                                <th><center><u><b>Services</b></u></center></th>
                            </tr>
                            <tr>
                                <td>
                                    <div style="overflow:auto;height:100%;">
                                        <table class="table table-bordered servicesTable" id="<%=divId%>_servicesTable" valign="top" width="100%">
                                            <tbody></tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                            <tr height="5%">
                                <td>
                                    <table class='table' width="100%">
                                        <tr>
                                            <td align="left">Storey Charges:</td>
                                            <td align="right">
                                                <div class="input-group">
                            <span class="input-group-addon">$</span>
                            <input class='form-control' type="number" step="0.01" min="0" id="<%=divId%>_storeyCharge" class="storeyCharge" name="<%=divId%>_storeyCharge" value="0.00">
                                    </div>
                                                </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr height="5%">
                                <td>
                                    <table class='table' width="100%">
                                        <tr>
                                            <td align="left">Pushing Charges:</td>
                                            <td align="right">
                                                 <div class="input-group">
                            <span class="input-group-addon">$</span>
                            <input class='form-control'  type="number" step="0.01" min="0" id="<%=divId%>_pushCharge" class="pushCharge" name="<%=divId%>_pushCharge" value="0.00">
                                    </div>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr height="5%">
                                <td>
                                    <table class='table' width="100%">
                                        <tr>
                                            <td align="left">Detour Charges:</td>
                                            <td align="right">
                                                  <div class="input-group">
                            <span class="input-group-addon">$</span>
                            <input class='form-control' type="number" step="0.01" min="0" id="<%=divId%>_detourCharge" class="detourCharge" name="<%=divId%>_detourCharge" value="0.00">
                                    </div>
                                               </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr height="5%">
                                <td>
                                    <table class='table' width="100%">
                                        <tr>
                                            <td align="left">Material Charges:</td>
                                            <td align="right">
                                                   <div class="input-group">
                            <span class="input-group-addon">$</span>
                            <input class='form-control' type="number" step="0.01" min="0" id="<%=divId%>_materialCharge" class="materialCharge" name="<%=divId%>_materialCharge" value="0.00">
                                    </div>
                                                </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr height="5%">
                                <td>
                                    <table class='table' width="100%">
                                        <tr>
                                            <td align="left">Additional Markup:</td>
                                            <td align="right">
                                                 <div class="input-group">
                            <span class="input-group-addon">$</span>
                            <input class='form-control' type="number" step="0.01" min="0" id="<%=divId%>_markup" class="markup" name="<%=divId%>_markup" value="0.00">
                                    </div> </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr height="5%">
                                <td>
                                    <table class='table' width="100%">
                                        <tr>
                                            <td align="left">Discount:</td>
                                            <td align="right">
                                                    <div class="input-group">
                            <span class="input-group-addon">$</span>
                            <input class='form-control' type="number" step="0.01" min="0" id="<%=divId%>_discount" class="discount" name="<%=divId%>_discount" value="0.00">
                                    </div>
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
                                    <table>
                                        <tr style="height:10%;background-color:#F6CEE3;">
                                            <th><center><b><u>Customer Comments</u></b></center></th>
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
                                    <table>
                                        <tr style="height:10%;background-color:#F6CEE3;">
                                            <th><center><b><u>Customer Remarks</u></b></center></th>
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
            <table class='table'>
                <tr>
                    <td align="right" style="width:50%">Total :</td>
                    <td align="center">
                        <div class="input-group">
                            <span class="input-group-addon">$</span>
                            <input class="form-control" type="number" step="0.01" min="0" name="totalPrice" id="<%=divId%>_totalPrice" value="0.00">
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

<div id="<%=divId%>_manpowerModal" class="modal">
    <!-- Modal content -->
    <div class="modal-content">
        <div class="modal-body">
            <h3>Manpower Request</h3><hr>
            <input type="hidden" id="<%=divId%>_manpowerId">
            <table class='table' width="100%">
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
