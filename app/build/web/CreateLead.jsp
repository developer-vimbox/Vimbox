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
        <script src="http://malsup.github.com/jquery.form.js"></script> 
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAlr3mj-08qPnSvod0WtYbmE0NrulFq0RE&libraries=places"></script>
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
    <body onload="create_leadSetup()">
        <%            int leadId = new Random().nextInt(900000000) + 100000000;
        %>
        <h1>Create New Lead</h1>

        <form method="POST" action="CreateLeadController" autocomplete="on" id="create_lead_form">
            <table style="width:250px;">
                <tr>
                    <td align="right"><b>Lead ID :</b></td>
                    <td><%=leadId%><input type="hidden" id="leadId" name="leadId" value="<%=leadId%>"></td>
                </tr>
                <tr>
                    <td align="right"><b>Status :</b></td>
                    <td>Pending <input type="hidden" name="status" value="Pending"></td>
                </tr>
                <tr>
                    <td align="right"><b>Source :</b></td>
                    <td>
                        <%
                            for (int i = 0; i < sources.size(); i++) {
                                String source = sources.get(i);
                                if (i == 0) {
                                    out.println("<input type='radio' name='source' value='" + source + "' checked>" + source);
                                } else {
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
                <button onclick='customerSearch("ticket");
                        return false;'>Search</button>
                <button onclick="addNewCustomer();
                        return false;">Add New</button>

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
                                <%                                for (String referral : referrals) {
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
                                    for (String type : types) {
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

                <div id="SiteSurvey" style="display:none">
                    <br>
                    <fieldset>
                        <b><u>Site Survey Details</u></b><br><br>
                        <table>
                            <col width="100">
                            <tr>
                                <td align="right"><b>Survey Date :</b></td>
                                <td>
                                    <input type="date" id="sitesurvey_date">
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Surveyor :</b></td>
                                <td>
                                    <input type="text" id="employee_search" placeholder="Enter site surveyor name">
                                    <button onclick="viewSchedule();
                                            return false;">View Schedule</button>
                                </td>
                            </tr>
                        </table>
                        <div id="schedule_modal" class="modal">
                            <div class="survey-modal-content">
                                <div class="modal-body">
                                    <span class="close" onclick="closeModal('schedule_modal')">×</span>
                                    <div id="schedule_content"></div>
                                </div>
                            </div>
                        </div>
                        <div id="survey"></div>
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
                                                            <button onclick="addCustomerBox();
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
                                                            <button onclick="addItem();
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
                                                            <button onclick="addSpecialItem();
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
                                                            <input type="number" min="0" id="vimboxBoxUnit">
                                                            <button onclick="addVimboxBox();
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
                                                            <button onclick="addVimboxMaterial();
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

                                                                                    if (serviceTable[0][j].equals("Manpower")) {
                                                                                        String id = (serviceTable[0][j] + "_" + serviceChargeArray[0]).replaceAll(" ", "_");
                                                                                        out.println("Manpower : <label id='" + id + "manpowerLabel'></label><input type='hidden' name='" + id + "manpowerInput' id='" + id + "manpowerInput'></br>");
                                                                                        out.println("Reason : <label id='" + id + "manpowerReasonLabel'></label><input type='hidden' name='" + id + "reasonInput' id='" + id + "reasonInput'></br>");
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
                                                            <button onclick="addCustomerComment();
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
                                                            <input type="text" size="40" id="customerRemark" placeholder="Enter remark for customer">
                                                        </td>
                                                        <td>
                                                            <button onclick="addCustomerRemark();
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
                    <button align="center" onclick="submitManpower();
                            return false;">Okay</button>
                </div>
            </div>
        </div>
        <script>
            $('#create_lead_form').ajaxForm({
                dataType: 'json',
                success: function (data) {
                    var modal = document.getElementById("salesModal");
                    var status = document.getElementById("salesStatus");
                    var message = document.getElementById("salesMessage");
                    status.innerHTML = data.status;
                    message.innerHTML = data.message;
                    modal.style.display = "block";

                    if (data.status === "SUCCESS") {
                        setTimeout(function () {
                            location.reload()
                        }, 500);
                    }
                },
                error: function (data) {
                    var modal = document.getElementById("salesModal");
                    var status = document.getElementById("salesStatus");
                    var message = document.getElementById("salesMessage");
                    status.innerHTML = "ERROR";
                    message.innerHTML = data;
                    modal.style.display = "block";
                }
            });

            jQuery(document).bind('keydown', 'ctrl+shift', function (e) {
                var tableClassName = $(document.activeElement.parentNode.parentNode.parentNode.parentNode).attr('class');
                switch (tableClassName) {
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

            $(document).bind('DOMNodeInserted', function (e) {
                var element = e.target;
                var parent = element.parentNode.parentNode;
                if ($(parent).is(".servicesTable")) {
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
        </script>
        <script src="JS/LeadFunctions.js"></script>
    </body>
</html>