<%@page import="com.vimbox.util.Converter"%>
<%@page import="java.util.Random"%>
<%@page import="org.joda.time.DateTime"%>
<%@include file="ValidateLogin.jsp"%>
<%@include file="PopulateLeadFields.jsp"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create new lead</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.2/jquery.min.js"></script>
        <script src="JS/jquery.hotkeys.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <script src="JS/AddressSearch.js"></script>
        <script src="JS/CustomerFunctions.js"></script>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
        <style>
            table.salesTable td {
                padding: 5px;
            }
            
            table.serviceTable{
                width:100%;
                height:50px;
            }
            
            table.dynamicDomTable{
                width:100px;
            }
            
            .sales{
                width:200px;
                height:200px;
            }
            
            table{
                width:100%;
                height:100%;
            }
            
            img#loader {
                display: none;
            }
        </style>
    </head>
    <body onload="setup()">
        <%
            ServletContext sc = request.getServletContext();
            String status = (String)sc.getAttribute("status");
            if(status!=null){
                sc.removeAttribute("status");
                out.println("<h2>Lead saved!</h2><br>");
            }
            int leadId = new Random().nextInt(900000000) + 100000000;
        %>
        <h1>Create New Lead</h1>

        <form method="POST" action="CreateLeadController" autocomplete="on">
            <table style="width:250px;">
                <tr>
                    <td align="right"><b>Lead ID :</b></td>
                    <td><%=leadId%><input type="hidden" name="leadId" value="<%=leadId%>"></td>
                </tr>
                <tr>
                    <td align="right"><b>Status :</b></td>
                    <td>Pending <input type="hidden" name="status" value="Pending"></td>
                </tr>
                <tr>
                    <td align="right"><b>Source :</b></td>
                    <td>
                        <%
                            for(int i=0; i<sources.size(); i++){
                                String source = sources.get(i);
                                if(i==0){
                                    out.println("<input type='radio' name='source' value='" + source + "' checked>" + source);
                                }else{
                                    out.println("<input type='radio' name='source' value='" + source + "'>" + source);
                                }
                            }
                        
                        %>
                    </td>
                </tr>
            </table>
            <fieldset>
                <legend>Customer Information</legend>
                <input type="text" id="customer_search" placeholder="Enter customer name">
                <button onclick='customerSearch("ticket");return false;'>Search</button>
                <button onclick="addNewCustomer();return false;">Add New</button>

                <div id="customer_modal" class="modal">
                    <div class="modal-content">
                        <div class="modal-body">
                            <span class="close" onclick="closeModal('customer_modal')">×</span>
                            <div id="customer_content"></div>
                        </div>
                    </div>
                </div>

                <div id="customer_error_modal" class="modal">
                    <div class="error-modal-content">
                        <div class="modal-body">
                            <span class="close" onclick="closeModal('customer_error_modal')">×</span>
                            <div id="customer_error_status"></div>
                            <hr>
                            <div id="customer_error_message"></div>
                        </div>
                    </div>
                </div>
                <hr>
                <table>
                    <col width="100">
                    <tr>
                        <td align="right"><b>Referred by :</b></td>
                        <td>
                            <select name="referral" id="referral" onchange="showfield(this.options[this.selectedIndex].value)">
                            <%
                                for(String referral:referrals){
                                    out.println("<option value='" + referral + "'>" + referral + "</option>");
                                }
                            %>
                                <option value="Others">Others</option>
                            </select>
                                <div id="referralOthers" style="display:inline-block"></div>
                        </td>
                    </tr>
                </table>
                <div id="customer_information_table" style="display:none">
                    <input type="hidden" id="customer_id" name="customer_id">
                    <table>
                        <col width="100">
                        <tr>
                            <td align="right"><b>Salutation :</b></td>
                            <td>
                                <label id="customer_salutation"></label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right"><b>First Name :</b></td>
                            <td>
                                <label id="customer_first_name"></label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right"><b>Last Name :</b></td>
                            <td>
                                <label id="customer_last_name"></label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right"><b>Contact :</b></td>
                            <td>
                                <label id="customer_contact"></label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right"><b>Email :</b></td>
                            <td>
                                <label id="customer_email"></label>
                            </td>
                        </tr>
                    </table>
                </div>        
            </fieldset>
            <br>
            <fieldset>
                <legend>Moving Information</legend>
                <table>
                    <col width="100">
                    <tr>
                        <td align="right"><b>Move Type :</b></td>
                        <td>
                            <%
                                for (String type : moveTypes) {
                                    out.println("<input type='checkbox' name='tom' value='" + type + "'>" + type);
                                }
                            %>
                        </td>
                    </tr>
                    <tr>
                        <td align="right"><b>DOM :</b></td>
                        <td>
                            <div id="dynamicDom">
                                <div id="1">
                                    <table class="dynamicDomTable">
                                        <tr>
                                            <td><input type="date" name="dom"></td>
                                            <td><input type="button" value="+" onClick="addDom('dynamicDom');"></td>
                                        </tr>    
                                    </table>
                                </div>
                            </div>
                            
                        </td>
                    </tr>
                </table>
                <br>
                <fieldset>
                    <b><u>Moving From</u></b><br><br>
                    <b>S </b><input type="text" id="postalfrom" placeholder="Enter Postal Code">
                    <button onclick="searchAddressFrom();
                            return false;">Search address from</button>
                    <div id="from">
                    </div>
                </fieldset>
                <br>
                <fieldset>
                    <b><u>Moving To</u></b><br><br>
                    <b>S </b><input type="text" id="postalto" placeholder="Enter Postal Code">
                    <button onclick="searchAddressTo();
                            return false;">Search address to</button>
                    <div id="to">
                    </div>
                </fieldset>
            </fieldset>
            <br>
            <fieldset>
                <legend>Lead Information</legend>
                <table>
                    <col width="100">
                    <tr>
                        <td align="right"><b>Lead Type :</b></td>
                        <td>
                            <div id="leadInfo">
                                <%
                                    for(String type:types){
                                        out.println("<input type='checkbox' name='leadType' value='" + type + "'>" + type);
                                    }
                                %>
                            </div>
                        </td>
                    </tr>
                </table>
                <div id="Enquiry" style="display:none">
                    <br>
                    <fieldset>
                        <b><u>Enquiry Details</u></b><br><br>
                        <table>
                            <col width="100">
                            <tr>
                                <td align="right"><b>Remarks :</b></td>
                                <td>
                                    <textarea name="enquiry" cols="75" rows="6" autocomplete="off"></textarea>
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </div>
                <div id="Sales" style="display:none">
                    <br>
                    <fieldset>
                        <b><u>Sales Details</u></b><hr>
                        <table class="salesInfoTable" id="salesTable">
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
                                                            <input type="number" min="0" id="customerBoxUnit">
                                                            <button onclick="addCustomerBox();return false;">Add box</button>
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
                                                            <input type="text" size="40" id="itemName" list="items" placeholder="Enter item">

                                                            <datalist id="items">
                                                                <%
                                                                    for (String[] item : existingItems) {
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
                                                            <input type="text" size="40" id="itemdimensions" placeholder="Dimensions" disabled>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="right">Units :</td>
                                                        <td>
                                                            <input type="number" min="0" id="itemUnit">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="right">Quantity :</td>
                                                        <td>
                                                            <input type="number" min="0" id="itemQty">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="right">Remarks :</td>
                                                        <td>
                                                            <input type="text" size="40" id="itemRemark" placeholder="Enter item remarks">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td></td>
                                                        <td>
                                                            <button onclick="addItem();return false;">Add item</button>
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
                                                            <input type="text" size="40" id="specialItemName" list="specialitems" placeholder="Enter item">

                                                            <datalist id="specialitems">
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
                                                            <input type="number" min="0" id="specialItemUnit">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="right">Quantity :</td>
                                                        <td>
                                                            <input type="number" min="0" id="specialItemQty">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="right">Additional Charges :</td>
                                                        <td>
                                                            $ <input type="number" min="0" step="0.01" id="specialItemCharges">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="right">Remarks :</td>
                                                        <td>
                                                            <input type="text" size="40" id="specialItemRemark" placeholder="Enter item remarks">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td></td>
                                                        <td>
                                                            <button onclick="addSpecialItem();return false;">Add special</button>
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
                                                            <input type="number" min="0" id="vimboxBoxUnit">
                                                            <button onclick="addVimboxBox();return false;">Add box</button>
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
                                                            <input type="text" id="vimboxMaterial">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="right">Quantity :</td>
                                                        <td>
                                                            <input type="number" step="0.01" min="0" id="vimboxMaterialUnit">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="right">Charges :</td>
                                                        <td>
                                                            $ <input type="number" min="0" step="0.01" id="vimboxMaterialCharge">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td></td>
                                                        <td>
                                                            <button onclick="addVimboxMaterial();return false;">Add material</button>
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
                                                <button style="width:100%" onclick="selectService();
                                                        return false;">Add service</button>
                                                <!-- Service Modal -->
                                                <div id="serviceModal" class="service">
                                                    <!-- Modal content -->
                                                    <div class="service-content">
                                                        <div class="service-body">
                                                            <span class="close" onclick="closeModal('serviceModal')">×</span>
                                                            <div id="serviceContent">
                                                                
                                                                <table width="100%" border="1" style="table-layout: fixed;" id="serviceTable">
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
                                                                                    out.println("<td bgcolor='#6698FF' align='center'>" + serviceChargeArray[0] + "</br>");
                                                                                    
                                                                                    if(serviceTable[0][j].equals("Manpower")){
                                                                                        String id = (serviceTable[0][j] + "_" + serviceChargeArray[0]).replaceAll(" ", "_");
                                                                                        out.println("Manpower : <label id='" + id + "manpowerLabel'></label><input type='hidden' name='" + id + "manpowerInput' id='" + id + "manpowerInput'></br>");
                                                                                        out.println("Reason : <label id='" + id + "manpowerReasonLabel'></label><input type='hidden' name='" + id + "reasonInput' id='" + id + "reasonInput'></br>");
                                                                                    }
                                                                                    try {
                                                                                        out.println("<input type='hidden' name='svcTableCell' value='{" + serviceTable[0][j] + "|" + serviceChargeArray[0] + "," + serviceChargeArray[1] + "}'>");
                                                                                    } catch (IndexOutOfBoundsException e) {}
                                                                                    
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
                                                            <input type="text" size="40" id="customerComment" placeholder="Enter customer comment">
                                                        </td>
                                                        <td>
                                                            <button onclick="addCustomerComment();return false;">Add Comment</button>
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
                                                            <input type="text" size="40" id="customerRemark" placeholder="Enter remark for customer">
                                                        </td>
                                                        <td>
                                                            <button onclick="addCustomerRemark();return false;">Add Remark</button>
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
                                                        <th style="width:20%"><div id="totalUnits"></div></th>
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
                                                                                        <table id="customerItemsTable" valign="top" style="width:100%;">
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
                                                                                        <table id="vimboxItemsTable" valign="top" style="width:100%;">
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
                                                                            <table class="servicesTable" id="servicesTable" valign="top" width="100%">
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
                                                                                <td align="right">$ <input type="number" step="0.01" min="0" id="storeyCharge" name="storeyCharge" value="0.00"></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr height="5%">
                                                                    <td>
                                                                        <table width="100%">
                                                                            <tr>
                                                                                <td align="left">Pushing Charges :</td>
                                                                                <td align="right">$ <input type="number" step="0.01" min="0" id="pushCharge" name="pushCharge" value="0.00"></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr height="5%">
                                                                    <td>
                                                                        <table width="100%">
                                                                            <tr>
                                                                                <td align="left">Detour Charges :</td>
                                                                                <td align="right">$ <input type="number" step="0.01" min="0" id="detourCharge" name="detourCharge" value="0.00"></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr height="5%">
                                                                    <td>
                                                                        <table width="100%">
                                                                            <tr>
                                                                                <td align="left">Material Charges :</td>
                                                                                <td align="right">$ <input type="number" step="0.01" min="0" id="materialCharge" name="materialCharge" value="0.00"></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr height="5%">
                                                                    <td>
                                                                        <table width="100%">
                                                                            <tr>
                                                                                <td align="left">Additional Markup :</td>
                                                                                <td align="right">$ <input type="number" step="0.01" min="0" id="markup" name="markup" value="0.00"></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr height="5%">
                                                                    <td>
                                                                        <table width="100%">
                                                                            <tr>
                                                                                <td align="left">Discount :</td>
                                                                                <td align="right">$ <input type="number" step="0.01" min="0" id="discount" name="discount" value="0.00"></td>
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
                                                                                        <table id="commentsTable" valign="top">
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
                                                                                        <table id="remarksTable" valign="top">
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
                                                        <td align="center">$ <input type="number" step="0.01" min="0" name="totalPrice" id="totalPrice" value="0.00"></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </div>
            </fieldset>
            <br>
            <table>
                <tr>
                    <td></td>
                    <td>
                        <input type="submit" value="Save">
                        <input type="submit" value="Generate Quotation" formaction="new_lead_pdf.pdf" formtarget="_blank">
                        <button onclick="return checkEmail();">Email Quotation</button>
                        <label><img id="loader" src="http://dev.cloudcell.co.uk/bin/loading.gif"/></label>
                    </td>
                </tr>
            </table>
        </form>

        <!-- The Modal -->
        <div id="saModal" class="modal">
            <!-- Modal content -->
            <div class="error-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('saModal')">×</span>
                    <div id="saStatus"></div>
                    <hr>
                    <div id="saMessage"></div>
                </div>
            </div>
        </div>

        <div id="salesModal" class="modal">
            <!-- Modal content -->
            <div class="error-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('salesModal')">×</span>
                    <div id="salesStatus"></div>
                    <hr>
                    <div id="salesMessage"></div>
                </div>
            </div>
        </div>

        <div id="manpowerModal" class="modal">
            <!-- Modal content -->
            <div class="modal-content">
                <div class="modal-body">
                    <input type="hidden" id="manpowerId">
                    <table>
                        <tr>
                            <td align="right">Additional Manpower :</td>
                            <td><input type="number" id="additionalManpower"></td>
                        </tr>
                        <tr>
                            <td align="right">Reason :</td>
                            <td><input type="text" id="manpowerReason"></td>
                        </tr>
                    </table>
                    <button align="center" onclick="submitManpower();return false;">Okay</button>
                </div>
            </div>
        </div>
        <script>
$('#leadForm').submit(function() {
    $('#loader').show(); // show animation
    return true; // allow regular form submission
});

function showfield(name){
  if(name=='Others'){
      document.getElementById('referralOthers').innerHTML='Others: <input type="text" name="referralOthers" />';
  } else {
      document.getElementById('referralOthers').innerHTML='';
  }
}

jQuery(document).bind('keydown', 'ctrl+shift', function(e) {  
    var tableClassName = $(document.activeElement.parentNode.parentNode.parentNode.parentNode).attr('class');
    switch(tableClassName){
        case "customerBoxTable":
            addCustomerBox();
            break;
        case "customerItemTable":
            addItem();
            break;
        case "customerSpecialItemTable":
            addSpecialItem();
            break;
        case "vimboxBoxTable":
            addVimboxBox();
            break;
        case "vimboxMaterialTable":
            addVimboxMaterial();
            break;
        case "customerCommentTable":
            addCustomerComment();
            break;
        case "customerRemarkTable":
            addCustomerRemark();
            break;
        default:
    }
    return false;
});

$(document).bind('DOMNodeInserted', function(e) {
    var element = e.target;
    var parent = element.parentNode.parentNode;
    if($(parent).is(".servicesTable")) {
        // Initialize the starting amount using the formula given //
        update_service(element);
    }           
});

$(document).ready(function () {
    $(window).keydown(function (event) {
        if (event.keyCode === 13) {
            event.preventDefault();
            return false;
        }
    });
});

function checkEmail() {
    var email = document.getElementById("email").value;
    if (email.length === 0 || !email.trim()) {
        alert("Please input an email address");
        return false;
    } else {
        return true;
    }
}

var domCounter = 2;
function addDom(divName){
    var newdiv = document.createElement('div');
    var stringDiv = "";
    stringDiv += "<div id='" + domCounter + "'><table class='dynamicDomTable'><tr><td><input type='date' name='dom'></td><td><input type='button' value='x' onClick='removeInput("+domCounter+");'></td></tr></table></div>";
    newdiv.innerHTML = stringDiv;
    document.getElementById(divName).appendChild(newdiv);
    domCounter++;
}

var formula = {};
var symbols = ["+", "-", "/", "x"];
var additionalCharges = 0;
var materialCharges = 0;
var totalUnits = 0;
var boxes = 0;
var manpower = {};

$("#servicesTable tbody").on("change keyup paste", "tr", function (event) {
    update_total();
});

$("#markup").on('change keyup paste', function () {
    update_total();
});

$("#materialCharge").on('change keyup paste', function () {
    update_total();
});

$("#pushCharge").on('change keyup paste', function () {
    update_total();
});

$("#storeyCharge").on('change keyup paste', function () {
    update_total();
});

$("#detourCharge").on('change keyup paste', function () {
    update_total();
});

$("#discount").on('change keyup paste', function () {
    update_total();
});


jQuery('#itemName').on('input', function () {
    var value = $('#itemName').val();
    var item = $('#items [value="' + value + '"]').data('value');
    if (typeof item !== "undefined") {
        var itemArray = item.split("|");
        $('#itemdimensions').val(itemArray[1]);
        $('#itemUnit').val(itemArray[2]);
        $('#itemQty').val("");
    }
});

function update_services() {
    $('#servicesTable > tbody  > tr').each(function () {
        update_service(this);
    });
    //just update the total to sum    
}

function calculate(sum, symbol, variable) {
    switch (symbol) {
        case "x":
            sum = sum * variable;
            break;
        case "/":
            sum = Math.ceil(sum / variable);
            break;
        case "+":
            sum += variable;
            break;
        case "-":
            sum -= variable;
            break;
    }
    return sum;
}

function update_service(element) {
    var id = $(element).attr("id");
    var fml = formula[id].split(" ");
    var symbol;
    var sum;
    for (i = 0; i < fml.length; i++) {
        var action = fml[i];
        if (i === 0) {
            if (isNaN(action)) {
                switch (action) {
                    case "U":
                        sum = totalUnits;
                        break;
                    case "B":
                        sum = boxes;
                        break;
                    case "AC":
                        sum = additionalCharges;
                        break;
                    case "MP":
                        sum = manpower[id];
                        break;
                }
            } else {
                sum = action;
            }
        } else {
            if (symbols.indexOf(action) !== -1) {
                symbol = action;
            } else {
                if (isNaN(action)) {
                    switch (action) {
                        case "U":
                            sum = calculate(sum, symbol, totalUnits);
                            break;
                        case "B":
                            sum = calculate(sum, symbol, boxes);
                            break;
                        case "AC":
                            sum = calculate(sum, symbol, additionalCharges);
                            break;
                        case "MP":
                            sum = calculate(sum, symbol, manpower[id]);
                            break;
                    }
                } else {
                    sum = calculate(sum, symbol, action);
                }
            }
        }
    }

    var input = $(element).find("input")[1];
    $(input).val(Number(sum).toFixed(2));

    for (i = 0; i < fml.length; i++) {
        var action = fml[i];
        switch (action) {
            case "U":
                var label = id + "unitsLbl";
                $('#' + label).html(totalUnits);
                break;
            case "B":
                var label = id + "boxesLbl";
                $('#' + label).html(boxes);
                break;
            case "AC":
                var label = id + "acLbl";
                $('#' + label).html(additionalCharges);
                break;
            case "MP":
                var label = id + "mpLbl";
                $('#' + label).html(manpower[id]);
                break;
        }
    }

    update_total();
}

function update_total() {
    var sum = 0;
    $('#servicesTable > tbody  > tr').each(function () {
        sum += Number(this.getElementsByTagName("input")[1].value);
    });
    sum += (Number($('#markup').val()) + Number($('#materialCharge').val()) + Number($('#pushCharge').val()) + Number($('#storeyCharge').val()) + Number($('#detourCharge').val()) - Number($('#discount').val()));
    $('#totalPrice').val(Number(sum).toFixed(2));
}

function addUnits(unit) {
    totalUnits = totalUnits + unit;
    document.getElementById('totalUnits').innerHTML = "Total Units : " + totalUnits;
}

function subtractUnits(unit) {
    totalUnits = totalUnits - unit;
    document.getElementById('totalUnits').innerHTML = "Total Units : " + totalUnits;
}

//----------------------Customer Item Functions-------------------------//
function addCustomerBox() {
    var boxUnit = $('#customerBoxUnit').val();

    var errorMsg = "";
    var add = true;
    if (!boxUnit) {
        add = false;
        errorMsg += "Please enter a quantity<br>";
    }

    if (add) {
        var tr = "<tr><td>Boxes<input type='hidden' name='customerItemName' value='Boxes'></td>";
        tr += "<td>&nbsp;<input type='hidden' name='customerItemRemark' value=''></td>";
        tr += "<td align='center'>&nbsp;&nbsp;&nbsp;&nbsp;<input type='hidden' name='customerItemCharge' value=''></td>";
        tr += "<td align='center'>" + boxUnit + "<input type='hidden' name='customerItemQty' value='" + boxUnit + "'></td>";
        tr += "<td align='center'>" + boxUnit + "<input type='hidden' name='customerItemUnit' value='" + boxUnit + "'></td>";
        tr += "<td align='right'><input type='button' value='x' onclick='deleteBox(this)'/></td></tr>";
        $(tr).prependTo("#customerItemsTable > tbody");
        addUnits(Number(boxUnit));
        boxes += (Number(boxUnit));
        $('#customerBoxUnit').val("");
        update_services();
    } else {
        var modal = document.getElementById("salesModal");
        var salesStatus = document.getElementById("salesStatus");
        var salesMessage = document.getElementById("salesMessage");
        salesStatus.innerHTML = "<b>ERROR</b>";
        salesMessage.innerHTML = errorMsg;
        modal.style.display = "block";
    }
}

function addItem() {
    var itemName = $('#itemName').val();
    var itemUnit = $('#itemUnit').val();
    var itemQty = $('#itemQty').val();
    var itemRemark = $('#itemRemark').val();

    var errorMsg = "";
    var add = true;
    if (!itemName) {
        add = false;
        errorMsg += "Please enter an item<br>";
    }
    if (!itemUnit) {
        add = false;
        errorMsg += "Please enter an unit<br>";
    }
    if (!itemQty) {
        add = false;
        errorMsg += "Please enter an quantity<br>";
    }

    if (add) {
        itemUnit = itemUnit * itemQty;
        var tr = "<tr><td>" + itemName + "<input type='hidden' name='customerItemName' value='" + itemName + "'></td>";
        tr += "<td>" + itemRemark + "<input type='hidden' name='customerItemRemark' value='" + itemRemark + "'></td>";
        tr += "<td align='center'>&nbsp;&nbsp;&nbsp;&nbsp;<input type='hidden' name='customerItemCharge' value=''></td>";
        tr += "<td align='center'>" + itemQty + "<input type='hidden' name='customerItemQty' value='" + itemQty + "'></td>";
        tr += "<td align='center'>" + itemUnit + "<input type='hidden' name='customerItemUnit' value='" + itemUnit + "'></td>";
        tr += "<td align='right'><input type='button' value='x' onclick='deleteItem(this)'/></td></tr>";
        $(tr).prependTo("#customerItemsTable > tbody");
        addUnits(Number(itemUnit));
        $('#itemName').val("");
        $('#itemUnit').val("");
        $('#itemQty').val("");
        $('#itemRemark').val("");
        $('#itemName').focus();
        update_services();
    } else {
        var modal = document.getElementById("salesModal");
        var salesStatus = document.getElementById("salesStatus");
        var salesMessage = document.getElementById("salesMessage");
        salesStatus.innerHTML = "<b>ERROR</b>";
        salesMessage.innerHTML = errorMsg;
        modal.style.display = "block";
    }
}

function addSpecialItem() {
    var itemName = $('#specialItemName').val();
    var itemCharges = $('#specialItemCharges').val();
    var itemUnit = $('#specialItemUnit').val();
    var itemQty = $('#specialItemQty').val();
    var itemRemark = $('#specialItemRemark').val();

    var add = true;
    var errorMsg = "";

    if (!itemName) {
        add = false;
        errorMsg += "Please enter a special item<br>";
    }
    if (!itemUnit) {
        add = false;
        errorMsg += "Please enter an unit<br>";
    }
    if (!itemQty) {
        add = false;
        errorMsg += "Please enter an quantity<br>";
    }

    if (add) {
        itemUnit = itemUnit * itemQty;
        itemName = "Special - " + itemName;
        var tr = "<tr><td>" + itemName + "<input type='hidden' name='customerItemName' value='" + itemName + "'></td>";
        tr += "<td>" + itemRemark + "<input type='hidden' name='customerItemRemark' value='" + itemRemark + "'></td>";
        tr += "<td align='center'>" + itemCharges + "<input type='hidden' name='customerItemCharge' value='" + itemCharges + "'></td>";
        tr += "<td align='center'>" + itemQty + "<input type='hidden' name='customerItemQty' value='" + itemQty + "'></td>";
        tr += "<td align='center'>" + itemUnit + "<input type='hidden' name='customerItemUnit' value='" + itemUnit + "'></td>";
        tr += "<td align='right'><input type='button' value='x' onclick='deleteItem(this)'/></td></tr>";
        $(tr).prependTo("#customerItemsTable > tbody");
        additionalCharges += (Number(itemCharges));
        addUnits(Number(itemUnit));
        $('#specialItemName').val("");
        $('#specialItemCharges').val("");
        $('#specialItemUnit').val("");
        $('#specialItemQty').val("");
        $('#specialItemRemark').val("");
        $('#specialItemName').focus();
        update_services();
    } else {
        var modal = document.getElementById("salesModal");
        var salesStatus = document.getElementById("salesStatus");
        var salesMessage = document.getElementById("salesMessage");
        salesStatus.innerHTML = "<b>ERROR</b>";
        salesMessage.innerHTML = errorMsg;
        modal.style.display = "block";
    }
}

function deleteItem(btn) {
    var row = btn.parentNode.parentNode;
    var nodes = row.childNodes;
    var unit = nodes[4].innerHTML.substring(0, nodes[4].innerHTML.indexOf("<"));
    subtractUnits(Number(unit));
    var charge = nodes[2].innerHTML.substring(0, nodes[2].innerHTML.indexOf("<"));
    if (!isNaN(charge)) {
        additionalCharges -= Number(charge);
    }
    row.parentNode.removeChild(row);
    update_services();
}
//--------------------------------End-----------------------------------//

//-----------------------Vimbox Item Functions--------------------------//
function addVimboxBox() {
    var boxUnit = $('#vimboxBoxUnit').val();

    var errorMsg = "";
    var add = true;
    if (!boxUnit) {
        add = false;
        errorMsg += "Please enter an unit<br>";
    }

    if (add) {
        var tr = "<tr><td>Boxes<input type='hidden' name='vimboxItemName' value='Boxes'></td>";
        tr += "<td>&nbsp;<input type='hidden' name='vimboxItemRemark' value=''></td>";
        tr += "<td align='center'>&nbsp;&nbsp;&nbsp;&nbsp;<input type='hidden' name='vimboxItemCharge' value=''></td>";
        tr += "<td align='center'>" + boxUnit + "<input type='hidden' name='vimboxItemQty' value='" + boxUnit + "'></td>";
        tr += "<td align='center'>" + boxUnit + "<input type='hidden' name='vimboxItemUnit' value='" + boxUnit + "'></td>";
        tr += "<td align='right'><input type='button' value='x' onclick='deleteBox(this)'/></td></tr>";
        $(tr).prependTo("#vimboxItemsTable > tbody");
        addUnits(Number(boxUnit));
        boxes += (Number(boxUnit));
        $('#vimboxBoxUnit').val("");
        update_services();
    } else {
        var modal = document.getElementById("salesModal");
        var salesStatus = document.getElementById("salesStatus");
        var salesMessage = document.getElementById("salesMessage");
        salesStatus.innerHTML = "<b>ERROR</b>";
        salesMessage.innerHTML = errorMsg;
        modal.style.display = "block";
    }
}

function addVimboxMaterial() {
    var itemName = $('#vimboxMaterial').val();
    var itemUnit = $('#vimboxMaterialUnit').val();
    var itemCharge = $('#vimboxMaterialCharge').val();

    var errorMsg = "";
    var add = true;
    if (!itemName) {
        add = false;
        errorMsg += "Please enter an item<br>";
    }
    if (!itemUnit) {
        add = false;
        errorMsg += "Please enter an unit<br>";
    }
    if (!itemCharge) {
        add = false;
        errorMsg += "Please enter a charge<br>";
    }

    if (add) {
        var tr = "<tr><td>" + itemName + "<input type='hidden' name='vimboxMaterialName' value='" + itemName + "'></td>";
        tr += "<td>&nbsp;</td>";
        tr += "<td align='center'>" + itemCharge + "<input type='hidden' name='vimboxMaterialCharge' value='" + itemCharge + "'></td>";
        tr += "<td align='center'>" + itemUnit + "<input type='hidden' name='vimboxMaterialQty' value='" + itemUnit + "'></td>";
        tr += "<td align='center'>&nbsp;</td>";
        tr += "<td align='right'><input type='button' value='x' onclick='deleteMaterial(this)'/></td></tr>";
        $(tr).prependTo("#vimboxItemsTable > tbody");
        materialCharges += (Number(itemCharge));
        $('#vimboxMaterial').val("");
        $('#vimboxMaterialUnit').val("");
        $('#vimboxMaterialCharge').val("");
        $('#materialCharge').val(Number(materialCharges).toFixed(2));
        $('#vimboxMaterial').focus();
        update_total();
    } else {
        var modal = document.getElementById("salesModal");
        var salesStatus = document.getElementById("salesStatus");
        var salesMessage = document.getElementById("salesMessage");
        salesStatus.innerHTML = "<b>ERROR</b>";
        salesMessage.innerHTML = errorMsg;
        modal.style.display = "block";
    }
}

function deleteMaterial(btn) {
    var row = btn.parentNode.parentNode;
    var nodes = row.childNodes;
    var charge = nodes[2].innerHTML.substring(0, nodes[2].innerHTML.indexOf("<"));
    if (!isNaN(charge)) {
        materialCharges -= Number(charge);
    }
    row.parentNode.removeChild(row);
    $('#materialCharge').val(materialCharges);
}

function deleteBox(btn) {
    var row = btn.parentNode.parentNode;
    var nodes = row.childNodes;
    var unit = nodes[4].innerHTML.substring(0, nodes[4].innerHTML.indexOf("<"));
    subtractUnits(Number(unit));
    boxes -= Number(unit);
    row.parentNode.removeChild(row);
    update_services();
}
//--------------------------------End-----------------------------------//

//-----------------------Customer C&R Functions-------------------------//
function addCustomerComment() {
    var comment = $('#customerComment').val();

    if (comment) {
        var tr = "<tr><td>" + comment + "<input type='hidden' name='comments' value='" + comment + "'></td><td align='right'><input type='button' value='x' onclick='deleteRow(this)'/></td></tr>";
        $(tr).prependTo("#commentsTable > tbody");
        $('#customerComment').val("");
    } else {
        var modal = document.getElementById("salesModal");
        var salesStatus = document.getElementById("salesStatus");
        var salesMessage = document.getElementById("salesMessage");
        salesStatus.innerHTML = "<b>ERROR</b>";
        salesMessage.innerHTML = "Please enter a comment";
        modal.style.display = "block";
    }
}

function addCustomerRemark() {
    var remark = $('#customerRemark').val();

    if (remark) {
        var tr = "<tr><td>" + remark + "<input type='hidden' name='remarks' value='" + remark + "'></td><td align='right'><input type='button' value='x' onclick='deleteRow(this)'/></td></tr>";
        $(tr).prependTo("#remarksTable > tbody");
        $('#customerRemark').val("");
    } else {
        var modal = document.getElementById("salesModal");
        var salesStatus = document.getElementById("salesStatus");
        var salesMessage = document.getElementById("salesMessage");
        salesStatus.innerHTML = "<b>ERROR</b>";
        salesMessage.innerHTML = "Please enter a remark";
        modal.style.display = "block";
    }
}

function deleteRow(btn) {
    var row = btn.parentNode.parentNode;
    row.parentNode.removeChild(row);
}
//--------------------------------End-----------------------------------//

//-------------------------Service Functions----------------------------//

$('#serviceTable td').click(function () {
    var cell = $(this);
    var state = cell.data('state') || '';
    var cellHtml = cell.html().trim();
    if (cellHtml) {
        var serviceCharge = cellHtml.substring(cellHtml.indexOf("{") + 1, cellHtml.lastIndexOf("}"));
        var serviceArray = serviceCharge.split(",");
        var svcSplit = serviceArray[0].split("|");
        var pri = svcSplit[0];
        var sec = svcSplit[1];
        var id = (pri + "_" + sec).replace(" ", "_");
        switch (state) {
            case '':
                if (pri === "Manpower") {
                    $('#manpowerId').val(id);
                    var modal = document.getElementById("manpowerModal");
                    modal.style.display = "block";
                }
                formula[id] = serviceArray[1];
                var tr = "<tr id='" + id + "'><td>";
                tr += "<table class='serviceTable'>"
                tr += "<tr height='10%'><td>" + pri + " - " + sec + "<input type='hidden' name='serviceName' value='" + id + "'></td><td align='right'>$ <input type='number' step='0.01' min='0' name='serviceCharge'></td></tr>";
                tr += "<tr>" + generateBreakdown(id) + "</tr></table></td></tr>";
                $('#servicesTable').append(tr);
                cell.addClass('selected');
                cell.data('state', 'selected');
                break;
            case 'selected':
                if (pri === "Manpower") {
                    removeManpower(id);
                }
                cell.removeClass('selected');
                cell.data('state', '');
                delete formula[id];
                $("#" + id).remove();
                break;
            default:
                break;
        }
    }
});

function generateBreakdown(id) {
    var fml = formula[id].split(" ");
    var breakdown = "<td colspan='2'><table width='100%' cellpadding=0 cellspacing=0 style='border-collapse: collapse;'><col width='50%'><col width='50%'>";
    for (i = 0; i < fml.length; i++) {
        var action = fml[i];
        switch (action) {
            case "U":
                breakdown += "<tr><td align='left'>&nbsp;&nbsp;&nbsp;Total Units</td>";
                breakdown += "<td align='right'><label id='" + id + "unitsLbl'>" + totalUnits + "</label></td></tr>";
                break;
            case "B":
                breakdown += "<tr><td align='left'>&nbsp;&nbsp;&nbsp;Boxes</td>";
                breakdown += "<td align='right'><label id='" + id + "boxesLbl'>" + boxes + "</label></td></tr>";
                break;
            case "MP":
                var man = manpower[id];
                if (man == null) {
                    man = 0;
                }
                breakdown += "<tr><td align='left'>&nbsp;&nbsp;&nbsp;Manpower</td>";
                breakdown += "<td align='right'><label id='" + id + "mpLbl'>" + man + "</label></td></tr>";
                break;
            case "AC":
                breakdown += "<tr><td align='left'>&nbsp;&nbsp;&nbsp;Additional Charges</td>";
                breakdown += "<td align='right'><label id='" + id + "acLbl'>" + additionalCharges + "</label></td></tr>";
                break;
            default:
                break;
        }
    }
    breakdown += "</table></td>";
    return breakdown;
}

function removeManpower(id) {
    var mpLbl = id + "manpowerLabel";
    var mprLbl = id + "manpowerReasonLabel";
    
    var mpIpt = id + "manpowerInput";
    var rIpt = id + "reasonInput";
    document.getElementById(mpIpt).value = "";
    document.getElementById(rIpt).value = "";
    
    delete manpower[id];
    document.getElementById(mpLbl).innerHTML = "";
    document.getElementById(mprLbl).innerHTML = "";
}

function submitManpower() {
    var id = $('#manpowerId').val();
    var addManpower = $('#additionalManpower').val();
    var manReason = $('#manpowerReason').val();

    manpower[id] = Number(addManpower);
    var mpLbl = id + "manpowerLabel";
    var mprLbl = id + "manpowerReasonLabel";
    document.getElementById(mpLbl).innerHTML = addManpower;
    document.getElementById(mprLbl).innerHTML = manReason;

    var mpIpt = id + "manpowerInput";
    var rIpt = id + "reasonInput";
    document.getElementById(mpIpt).value = addManpower;
    document.getElementById(rIpt).value = manReason;
    
    var modal = document.getElementById("manpowerModal");
    modal.style.display = "none";
    update_services();
}

function selectService() {
    var modal = document.getElementById("serviceModal");
    modal.style.display = "block";
}
//--------------------------------End-----------------------------------//
//-------------------------LeadType Functions---------------------------//
function checkLeadInformation() {
    var el = document.getElementById('leadInfo');
    var tops = el.getElementsByTagName('input');
    for (var i = 0, len = tops.length; i < len; i++) {
        if (tops[i].type === 'checkbox') {
            tops[i].onclick = showDiv;
        }
    }
}

function showDiv(e) {
    var divId = this.value;
    var div = document.getElementById(divId);
    if (this.checked) {
        div.style.display = "block";
        if (divId === "sales") {
            $('#' + divId + "Table").scrollView();
        } else {
            $('#' + divId).scrollView();
        }
    } else {
        div.style.display = "none";
    }
}

$.fn.scrollView = function () {
    return this.each(function () {
        $('html, body').animate({
            scrollTop: $(this).offset().top
        }, 1000);
    });
}
//--------------------------------End-----------------------------------//
function setup(){
    checkLeadInformation();
}

        </script>
    </body>
</html>