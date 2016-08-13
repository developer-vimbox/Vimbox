<%@page import="com.vimbox.sales.LeadDiv"%>
<%@page import="com.vimbox.sitesurvey.SiteSurvey"%>
<%@page import="com.vimbox.sales.Lead"%>
<%@page import="com.vimbox.database.LeadDAO"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.vimbox.sales.Item"%>
<%@page import="com.vimbox.customer.Customer"%>
<%@include file="PopulateLeadFields.jsp"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Lead</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.2/jquery.min.js"></script>
        <script src="http://malsup.github.com/jquery.form.js"></script> 
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAlr3mj-08qPnSvod0WtYbmE0NrulFq0RE&libraries=places"></script>
        <script src="JS/jquery.hotkeys.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <script src="JS/LeadFunctions.js"></script>
        <script src="JS/AddressSearch.js"></script>
        <script src="JS/CustomerFunctions.js"></script>
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

            /* Style the list */
            ul.tab {
                list-style-type: none;
                margin: 0;
                padding: 0;
                overflow: hidden;
                border: 1px solid #ccc;
                background-color: #f1f1f1;
            }

            /* Float the list items side by side */
            ul.tab li {float: left;}

            /* Style the links inside the list items */
            ul.tab li a {
                display: inline-block;
                color: black;
                text-align: center;
                padding: 14px 16px;
                text-decoration: none;
                transition: 0.3s;
                font-size: 17px;
            }

            /* Change background color of links on hover */
            ul.tab li a:hover {background-color: #ddd;}

            /* Create an active/current tablink class */
            ul.tab li a:focus, .active {background-color: #ccc;}

            /* Style the tab content */
            .tabcontent {
                display: none;
                padding: 6px 12px;
                border: 1px solid #ccc;
                border-top: none;
            }

            .tabcontent {
                -webkit-animation: fadeEffect 1s;
                animation: fadeEffect 1s; /* Fading effect takes 1 second */
            }

            @-webkit-keyframes fadeEffect {
                from {opacity: 0;}
                to {opacity: 1;}
            }

            @keyframes fadeEffect {
                from {opacity: 0;}
                to {opacity: 1;}
            }
        </style>
    </head>
    <body onload="edit_leadSetup()">
        <%@include file="header.jsp"%>
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

        <div id="cancelLeadModal" class="modal">
            <!-- Modal content -->
            <div class="modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('cancelLeadModal')">×</span>
                    <h3>Lead Cancellation</h3>
                    <table>
                        <tr>
                            <td>Lead ID :</td>
                            <td><label id="leadIdLbl"></label><input type="hidden" name="lId" id="lId" /></td>
                        </tr>
                        <tr>
                            <td>Reason :</td>
                            <td><textarea id="reason" name="reason" cols="75" rows="6" autofocus autocomplete="off" oninvalid="this.setCustomValidity('Please enter a comment')" oninput="setCustomValidity('')"></textarea></td>
                        </tr>  
                    </table>
                    <button onclick="confirmCancel()">Reject Lead</button>
                </div>
            </div>
        </div>

        <div id="lead_error_modal" class="modal">
            <!-- Modal content -->
            <div class="message-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('lead_error_modal')">×</span>
                    <div id="lead_error_status"></div>
                    <hr>
                    <div id="lead_error_message"></div>
                </div>
            </div>
        </div>
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
        <%            String lId = request.getParameter("lId");
            Lead lead = LeadDAO.getLeadById(Integer.parseInt(lId));
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
        %>
        <div id="page-content-wrapper">

            <div id="page-content" style="min-height: 7630px;">
                <div class="container">
                    <div id="page-title">
                        <h2>Edit Lead</h2> <br>
                    </div>
                    <div class="panel">
                        <div class="panel-body">
                            <div class="form-horizontal">
                                <form method="POST" action="EditLeadController" autocomplete="on" id="edit_lead_form">
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Lead ID: </label>
                                        <div class="col-sm-4">
                                            <%=lead.getId()%><input type="hidden" id="leadId" name="leadId" value="<%=lead.getId()%>">
                                            <br><br>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Status: </label>
                                        <div class="col-sm-4">
                                            <%=lead.getStatus()%><input type="hidden" name="status" value="<%=lead.getStatus()%>">
                                            <br><br>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Source: </label>
                                        <div class="col-sm-4">
                                            <%
                                                String src = lead.getSource();
                                                for (int i = 0; i < sources.size(); i++) {
                                                    String source = sources.get(i);
                                                    if (src.equals(source)) {
                                                        out.println("<input class=\"radio-inline\" type='radio' name='source' value='" + source + "' checked>" + source);
                                                    } else {
                                                        out.println("<input class=\"radio-inline\" type='radio' name='source' value='" + source + "'>" + source);
                                                    }
                                                }

                                            %>
                                            <br><br>
                                        </div>
                                    </div>
                                    <fieldset>
                                        <legend>Customer Information</legend>
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label"> </label>
                                            <div class="col-sm-4">
                                                <div class="input-group bootstrap-touchspin"><span class="input-group-addon bootstrap-touchspin-prefix" style="display: none;"></span>
                                                    <input type="text" id="customer_search" placeholder="Enter customer name" class="form-control" style="width: 400px;color:black;">
                                                    <span class="input-group-btn"> 
                                                        <button class="btn btn-default  bootstrap-touchspin-up" type="button" onclick="customerSearch('ticket')" >Search</button>
                                                        <button class="btn btn-default  bootstrap-touchspin-up" type="button" onclick="addNewCustomer()">Add New</button>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>

                                        <hr>
                                        <%                    Customer customer = lead.getCustomer();
                                        %>
                                        <div id="customer_information_table" <%if (customer == null) {
                                                out.println("style='display:none'");
                                            } else {
                                                out.println("style='display:block'");
                                            }%>>
                                            <input type="hidden" id="customer_id" name="customer_id" <%if (customer != null) {
                                                    out.println("value='" + customer.getCustomer_id() + "'");
                                                }%>>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label">Salutation: </label>
                                                <div class="col-sm-4">
                                                    <label id="customer_salutation"><%if (customer != null) {
                                                            out.println(customer.getSalutation());
                                                        }%></label>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label">First Name: </label>
                                                <div class="col-sm-4">
                                                    <label id="customer_first_name"><%if (customer != null) {
                                                            out.println(customer.getFirst_name());
                                                        }%></label>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label">Last Name: </label>
                                                <div class="col-sm-4">
                                                    <label id="customer_last_name"><%if (customer != null) {
                                                            out.println(customer.getLast_name());
                                                        }%></label>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label">Contact: </label>
                                                <div class="col-sm-4">
                                                    <label id="customer_contact"><%if (customer != null) {
                                                            out.println(customer.getContact());
                                                        }%></label>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label">Email: </label>
                                                <div class="col-sm-4">
                                                    <label id="customer_email"><%if (customer != null) {
                                                            out.println(customer.getEmail());
                                                        }%></label>
                                                </div>
                                            </div>
                                        </div >      
                                    </fieldset>
                                    <br>
                                    <fieldset>
                                        <legend>Moving Information</legend>
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label">Move Type: </label>
                                            <div class="col-sm-6">
                                                <%
                                                    String[] tom = lead.getTom().split("\\|");

                                                    for (String type : moveTypes) {
                                                        boolean present = false;
                                                        for (String tm : tom) {
                                                            if (tm.equals(type)) {
                                                                present = true;
                                                            }
                                                        }
                                                        if (present) {
                                                            out.println(" <label class=\"checkbox-inline\"><input type='checkbox' name='tom' value='" + type + "' checked>" + type + "</label>");
                                                        } else {
                                                            out.println("<label class=\"checkbox-inline\"><input type='checkbox' name='tom' value='" + type + "'>" + type + "</label>");
                                                        }
                                                    }
                                                %>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label">Date Of Move: </label>
                                            <div class="col-sm-5">
                                                <div id="dynamicDom">
                                                    <div class="input-group">
                                                        <span class="input-group-btn">
                                                            <input class="btn btn-round btn-primary" type="button" value="+" onclick="addDom('dynamicDom');">
                                                        </span>
                                                        <div id="1">
                                                            <%
                                                                String dom = lead.getDom();
                                                                if (dom.isEmpty()) {
                                                            %>
                                                            <input class="form-control" type="date" name="dom">
                                                        </div>
                                                        <%
                                                            } else {
                                                                int counter = 2;
                                                                String[] dates = dom.split("\\|");
                                                                for (int i = 0; i < dates.length; i++) {
                                                                    String date = dates[i];
                                                                    if (i == 0) {
                                                                        out.println("<input class='form-control' type='date' name'dom' value='" + date + "'>");
//                                                                    out.println("<input class='btn btn-round btn-primary' type='button' value='+' onClick=\"addDom('dynamicDom');\"></div>");
                                                                    } else {
                                                                        out.println("<div id='" + counter + "'>");
                                                                        out.println("<span class=\"input-group-btn\"><input class='btn btn-round btn-warning' type='button' value='x' onClick='removeInput(" + counter + ");'></span>");
                                                                        out.println("<input class='form-control' type='date' name'dom' value='" + date + "'>");
                                                                        out.println("/div>");
                                                                        counter++;
                                                                    }
                                                                }
                                                            }
                                                        %>
                                                    </div>

                                                </div>
                                            </div>
                                        </div>
                                    </fieldset>


                                    <br>
                                    <fieldset>
                                        <b><u>Moving From</u></b><br><br>
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label">S </label>
                                            <div class="col-sm-4">
                                                <div class="input-group bootstrap-touchspin"><span class="input-group-addon bootstrap-touchspin-prefix" style="display: none;"></span>
                                                    <input type="text" id="postalfrom" placeholder="Enter Postal Code" class="form-control" style="width: 400px;color:black;">
                                                    <span class="input-group-btn"> 
                                                        <button class="btn btn-default  bootstrap-touchspin-up" type="button" onclick="searchAddressFrom()">Search address from</button>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="from">
                                            <%
                                                ArrayList<String[]> addressFrom = lead.getAddressFrom();
                                                for (String[] addFrom : addressFrom) {
                                                    String[] address = addFrom[0].split("_");
                                                    String storeys = addFrom[1];
                                                    String pushingDistance = addFrom[2];
                                                    String stringDiv = "";
                                                    if (address.length > 1) {
                                                        String salesDivId = lead.getSalesDivIdByAddress(address[0] + " #" + address[1] + "-" + address[2] + " S" + address[3]);
                                                        int counter = Integer.parseInt(salesDivId.substring(5));
                                                        stringDiv += "<div class='address-box' id='from" + counter + "'><input type='hidden' id='tagId' value='" + salesDivId + "_lbl'><span class='close' onClick=\"removeAddress('from" + counter + "', '" + counter + "');\">×</span><hr>";
                                                        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Address: </label>";
                                                        stringDiv += " <div class='col-sm-8'><div class='form-group row'>";
                                                        stringDiv += "<div class ='col-sm-4'>";
                                                        stringDiv += "<input type='text' class='form-control addressFromInput' name='addressfrom' size='30' value='" + address[0] + "'>";
                                                        stringDiv += "</div>"; //close col-sm-4
                                                        stringDiv += "<div class ='col-sm-6'>";
                                                        stringDiv += "<div class='input-group'>";
                                                        stringDiv += "<span class='input-group-addon bg-black'>#</span>";
                                                        stringDiv += "<input type='text' class='form-control addressFromInput' name='addressfrom' size='2' value='" + address[1] + "'>";
                                                        stringDiv += "<span class='input-group-addon bg-black'>-</span>";
                                                        stringDiv += "<input type='text' class='form-control addressFromInput' name='addressfrom' size='3' value='" + address[2] + "'>";
                                                        stringDiv += "<span class='input-group-addon bg-black'>S</span>";
                                                        stringDiv += "<input type='text' class='form-control addressFromInput' name='addressfrom' size='5' value='" + address[3] + "'>";
                                                        stringDiv += " </div>";// close input group
                                                        stringDiv += "</div>";//close col-sm-6
                                                        stringDiv += "</div>"; //close form-group row
                                                        stringDiv += "</div></div>"; // col-sm-8, form group
                                                        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Storeys: </label>";
                                                        stringDiv += "<div class ='col-sm-4'>";
                                                        stringDiv += "<input class='form-control' type='text' name='storeysfrom' size='5' value='" + storeys + "'>";
                                                        stringDiv += "</div>"; //close col-sm-4
                                                        stringDiv += "</div>"; //close form group
                                                        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Pushing Distance: </label>";
                                                        stringDiv += "<div class ='col-sm-4'>";
                                                        stringDiv += "<div class='input-group'>";
                                                        stringDiv += "<input class='form-control' type='text' name='distancefrom' size='5' value='" + pushingDistance + "'>";
                                                        stringDiv += "<span class='input-group-addon bg-black'>M</span>";
                                                        stringDiv += "</div></div>"; //close input group, col-sm-4
                                                        stringDiv += "</div>"; //close form group
                                                        stringDiv += "</div>"; //close div id tag

                                                        out.println(stringDiv);
                                                        counter++;
                                                    }
                                                }
                                            %>
                                        </div>

                                    </fieldset>
                                    <br>
                                    <fieldset>
                                        <b><u>Moving To</u></b><br><br>
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label">S </label>
                                            <div class="col-sm-4">
                                                <div class="input-group bootstrap-touchspin"><span class="input-group-addon bootstrap-touchspin-prefix" style="display: none;"></span>
                                                    <input type="text" id="postalto" placeholder="Enter Postal Code" class="form-control" style="width: 400px;color:black;">
                                                    <span class="input-group-btn"> 
                                                        <button class="btn btn-default  bootstrap-touchspin-up" type="button" onclick="searchAddressTo()">Search address to</button>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="to">
                                            <%
                                                ArrayList<String[]> addressTo = lead.getAddressTo();
                                                int counter = 1;
                                                for (String[] addTo : addressTo) {
                                                    String[] address = addTo[0].split("_");
                                                    String storeys = addTo[1];
                                                    String pushingDistance = addTo[2];
                                                    String stringDiv = "";
                                                    if (address.length > 1) {
                                                        stringDiv += "<div class='address-box' id='to" + counter + "'><span class='close' onClick=\"removeAddress('to" + counter + "', '');\">×</span><hr>";
                                                        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Address: </label>";
                                                        stringDiv += " <div class='col-sm-8'><div class='form-group row'>";
                                                        stringDiv += "<div class ='col-sm-4'>";
                                                        stringDiv += "<input class='form-control addressFromInput' type='text' name='addressto' size='30' value='" + address[0] + "'>";
                                                        stringDiv += "</div>"; //close col-sm-4
                                                        stringDiv += "<div class ='col-sm-6'>";
                                                        stringDiv += "<div class='input-group'>";
                                                        stringDiv += "<span class='input-group-addon bg-black'>#</span>";
                                                        stringDiv += "<input class='form-control addressFromInput' type='text' name='addressto' size='2' value='" + address[1] + "''>";
                                                        stringDiv += "<span class='input-group-addon bg-black'>-</span>";
                                                        stringDiv += "<input type='text' class='form-control addressFromInput' name='addressto' size='3' value='" + address[2] + "'>";
                                                        stringDiv += "<span class='input-group-addon bg-black'>S</span>";
                                                        stringDiv += "<input type='text' class='form-control addressFromInput' name='addressto' size='5' value='" + address[3] + "'>";
                                                        stringDiv += " </div>";// close input group
                                                        stringDiv += "</div>";//close col-sm-6
                                                        stringDiv += "</div>"; //close form-group row
                                                        stringDiv += "</div></div>"; // col-sm-8, form group
                                                        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Storeys: </label>";
                                                        stringDiv += "<div class ='col-sm-4'>";
                                                        stringDiv += "<input class='form-control' type='text' name='storeysto' size='5' value='" + storeys + "'>";
                                                        stringDiv += "</div>"; //close col-sm-4
                                                        stringDiv += "</div>"; //close form group
                                                        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Pushing Distance: </label>";
                                                        stringDiv += "<div class ='col-sm-4'>";
                                                        stringDiv += "<div class='input-group'>";
                                                        stringDiv += "<input class='form-control' type='text' name='distanceto' size='5' value='" + pushingDistance + "'>";
                                                        stringDiv += "<span class='input-group-addon bg-black'>M</span>";
                                                        stringDiv += "</div></div>"; //close input group, col-sm-4
                                                        stringDiv += "</div>"; //close form group
                                                        stringDiv += "</div>"; //close div id tag

                                                        out.println(stringDiv);
                                                        counter++;
                                                    }
                                                }
                                            %>
                                        </div>
                                    </fieldset>
                                    </fieldset>
                                    <br>
                                    <fieldset>
                                        <legend>Lead Information</legend>
                                        <br>
                                        <fieldset>
                                            <b><u>Site Survey Details</u></b><br><br>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label">Survey Date: </label>
                                                <div class="col-sm-4">
                                                    <input class='form-control' type="date" id="sitesurvey_date">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label">Surveyor: </label>
                                                <div class="col-sm-4">
                                                    <div class="input-group bootstrap-touchspin"><span class="input-group-addon bootstrap-touchspin-prefix" style="display: none;"></span>
                                                        <input type="text" id="employee_search" placeholder="Enter site surveyor name" class="form-control" style="width: 400px;color:black;">
                                                        <span class="input-group-btn"> 
                                                            <button class="btn btn-default  bootstrap-touchspin-up" type="button" onclick="viewSchedule();">View Schedule</button>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div id="schedule_modal" class="modal">
                                                <div class="survey-modal-content">
                                                    <div class="modal-body">
                                                        <span class="close" onclick="closeModal('schedule_modal')">×</span>
                                                        <div id="schedule_content"></div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div id="survey">
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
                                                            if (sStatus.equals("Pending")) {
                                                                out.println("<span class='close' onClick=\"removeSiteSurvey('" + ss + "');\">×</span>");
                                                            }
                                                            out.println("<hr><table style='margin-left: 20%;'><col width='100'>");
                                                            out.println("<tr><td ><b>Date :</b></td><td><input type='hidden' name='siteSurvey_date' value='" + ss + "'>" + ss + "</td></tr>");
                                                            out.println("<tr><td ><b>Timeslot :</b></td><td><table>");
                                                            for (int j = 0; j < timeslots.size(); j++) {
                                                                out.println("<tr><td><input type='hidden' name='siteSurvey_timeslot' value='" + ss + "|" + timeslots.get(j) + "'>" + timeslots.get(j) + "</td></tr>");
                                                            }
                                                            out.println("</table></td></tr>");
                                                            out.println("<tr><td ><b>Address :</b></td><td><table>");
                                                            for (int j = 0; j < addresses.size(); j++) {
                                                                out.println("<tr><td><input type='hidden' name='siteSurvey_address' value='" + ss + "|" + addresses.get(j) + "'>" + addresses.get(j) + "</td></tr>");
                                                            }
                                                            out.println("</table></td></tr>");
                                                            out.println("<tr><td ><b>Surveyor :</b></td><td><input type='hidden' name='siteSurvey_surveyor' value='" + ss + "|" + sId + "'>" + sName + "</td></tr>");
                                                            out.println("<tr><td ><b>Remarks :</b></td><td><input type='hidden' name='siteSurvey_remarks' value='" + ss + "|" + sRem + "'>" + sRem + "</td></tr>");
                                                            out.println("<tr><td ><b>Status :</b></td><td>" + sStatus + "</td></tr>");
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
                                                            if (sStatus.equals("Pending")) {
                                                                out.println("<span class='close' onClick=\"removeSiteSurvey('" + ss + "');\">×</span>");
                                                                out.println("<input type='hidden' name='surveyStatus' value='yes'>");
                                                            } else {
                                                                out.println("<input type='hidden' name='surveyStatus' value='no'>");
                                                            }
                                                            out.println("<hr><table style='margin-left: 20%;'><col width='100'>");
                                                            out.println("<tr><td ><b>Date :</b></td><td><input type='hidden' name='siteSurvey_date' value='" + ss + "'>" + ss + "</td></tr>");
                                                            out.println("<tr><td ><b>Timeslot :</b></td><td><table>");
                                                            for (int j = 0; j < timeslots.size(); j++) {
                                                                out.println("<tr><td><input type='hidden' name='siteSurvey_timeslot' value='" + ss + "|" + timeslots.get(j) + "'>" + timeslots.get(j) + "</td></tr>");
                                                            }
                                                            out.println("</table></td></tr>");
                                                            out.println("<tr><td ><b>Address :</b></td><td><table>");
                                                            for (int j = 0; j < addresses.size(); j++) {
                                                                out.println("<tr><td><input type='hidden' name='siteSurvey_address' value='" + ss + "|" + addresses.get(j) + "'>" + addresses.get(j) + "</td></tr>");
                                                            }
                                                            out.println("</table></td></tr>");
                                                            out.println("<tr><td><b>Surveyor :</b></td><td><input type='hidden' name='siteSurvey_surveyor' value='" + ss + "|" + sId + "'>" + sName + "</td></tr>");
                                                            out.println("<tr><td><b>Remarks :</b></td><td><input type='hidden' name='siteSurvey_remarks' value='" + ss + "|" + sRem + "'>" + sRem + "</td></tr>");
                                                            out.println("<tr><td><b>Status :</b></td><td>" + survey.getStatus() + "</td></tr>");
                                                            out.println("</table></div>");
                                                        }
                                                    }
                                                %>
                                            </div>
                                        </fieldset>
                                        <br>
                                        <fieldset>
                                            <b><u>Sales Details</u></b><hr>
                                            <ul class="nav-responsive nav nav-tabs" id="sales_list">
                                                <%
                                                    ArrayList<LeadDiv> leadDivs = lead.getSalesDivs();
                                                    for (LeadDiv leadDiv : leadDivs) {
                                                        String leadDivStr = leadDiv.getSalesDiv();
                                                        String divId = leadDivStr.substring(0, leadDivStr.indexOf("|"));
                                                        String leadDivAddr = leadDivStr.substring(leadDivStr.indexOf("|") + 1);
                                                        out.println("<li style='background: none;' id='li_" + divId.substring(5) + "'><a data-toggle='tab' href='#' class='tablinks' onclick=\"openSales(event, '" + divId + "')\"><label id='" + divId + "_lbl'>" + leadDivAddr + "</label></a></li>");
                                                    }
                                                %>
                                            </ul>
                                            <div id="sales_container">
                                                <%
                                                    for (LeadDiv leadDiv : leadDivs) {
                                                        String leadDivStr = leadDiv.getSalesDiv();
                                                        String divId = leadDivStr.substring(0, leadDivStr.indexOf("|"));
                                                %>
                                                <div id="<%=divId%>" class="tabcontent">
                                                    <input type="hidden" id="<%=divId%>_divId" class="divId" name="divId" value="<%=leadDivStr%>">
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
                                                                <table class="customerItemTable">
                                                                    <col width="80">
                                                                    <tr>
                                                                        <td align="right">Name:</td>
                                                                        <td>
                                                                            <input class='form-control' type="text" size="40" class="itemName" id="<%=divId%>_itemName" list="<%=divId%>_items" placeholder="Enter item">

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
                                                            <td align="right">Special Item:</td>
                                                            <td>
                                                                <table class="customerSpecialItemTable">
                                                                    <col width="80">
                                                                    <tr>
                                                                        <td align="right">Name :</td>
                                                                        <td>
                                                                            <input class='form-control'  type="text" size="40" id="<%=divId%>_specialItemName" list="<%=divId%>_specialitems" placeholder="Enter item">

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
                                                                        <td align="right">Units:</td>
                                                                        <td>
                                                                            <input class='form-control'  type="number" min="0" id="<%=divId%>_specialItemUnit">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="right">Quantity:</td>
                                                                        <td>
                                                                            <input class='form-control'  type="number" min="0" id="<%=divId%>_specialItemQty">
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
                                                            <td align="right">Box:</td>
                                                            <td>
                                                                <table class="vimboxBoxTable">
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
                                                            <td align="right">Material :</td>
                                                            <td>
                                                                <table class="vimboxMaterialTable">
                                                                    <col width="80">
                                                                    <tr>
                                                                        <td align="right">Item:</td>
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
                                                            <td align="right">Svcs:</td>
                                                            <td align="center">
                                                                <button class='btn btn-default' style="width:100%" onclick="selectService('<%=divId%>');
                                                                        return false;">Services</button>
                                                                <!-- Service Modal -->
                                                                <div id="<%=divId%>_serviceModal" class="service">
                                                                    <!-- Modal content -->
                                                                    <div class="service-content">
                                                                        <div class="service-body">
                                                                            <span class="close" onclick="closeModal('<%=divId%>_serviceModal')">×</span>
                                                                            <table class='table' width="100%" border="1" style="table-layout: fixed;" id="<%=divId%>_serviceTable">
                                                                                <%
                                                                                    ArrayList<String[]> services = leadDiv.getServices();
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
                                                            </td>
                                                        </tr> 
                                                        <tr style="background-color:#F6CEE3">
                                                            
                    <td colspan="2"><center><b><u>Comments & Remarks</u></b></center></td>
                                                        </tr>
                                                        <tr>
                                                            <td align="right">Cmt:</td>
                                                            <td>
                                                                <table class="customerCommentTable">
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
                                                            <td align="right">Rmk:</td>
                                                            <td>
                                                                <table class="customerRemarkTable">
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
                                                            <tr style="height:50%">
                                                                <td>
                                                                    <table class='table table-bordered' border="1"><thead>
                                                                        <tr style="height:10%">
                                                                            <th style="width:20%">Item</th>
                                                                            <th style="width:40%">Remarks</th>
                                                                            <th style="width:10%">Additional Charges</th>
                                                                            <th style="width:10%">Quantity</th>
                                                                            <th style="width:10%">Units</th>
                                                                            <th style="width:20%"><div id="<%=divId%>_totalUnits"></div></th>
                                                                                </tr> </thead>
                                                            <tr>
                                                                <td colspan="6">
                                                                    <table class='table table-bordered' border="1">
                                                                        <tr height="50%">
                                                                            <td>
                                                                                <table class='table table-bordered' border="1">
                                                                                    <tr style="background-color:#F5BCA9" height="10%">
                                                                                         <td><center><b><u>Customer Item List</u></b></center></td>
                                                                                    </tr>
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
                                                                                                        <%
                                                                                                            ArrayList<Item> customerItems = leadDiv.getCustomerItems();
                                                                                                            for (Item item : customerItems) {
                                                                                                                String tr = "<tr><td>" + item.getName() + "<input type='hidden' name='" + divId + "_customerItemName' value='" + item.getName() + "'></td>";
                                                                                                                tr += "<td>" + item.getRemark() + "<input type='hidden' name='" + divId + "_customerItemRemark' value='" + item.getRemark() + "'></td>";
                                                                                                                if (item.getCharges() > 0) {
                                                                                                                    tr += "<td align='center'>" + item.getCharges() + "<input type='hidden' name='" + divId + "_customerItemCharge' value='" + item.getCharges() + "'></td>";
                                                                                                                } else {
                                                                                                                    tr += "<td align='center'>&nbsp;&nbsp;&nbsp;&nbsp;<input type='hidden' name='" + divId + "_customerItemCharge' value=''></td>";
                                                                                                                }

                                                                                                                tr += "<td align='center'>" + item.getQty() + "<input type='hidden' name='" + divId + "_customerItemQty' value='" + item.getQty() + "'></td>";
                                                                                                                tr += "<td align='center'>" + item.getUnits() + "<input type='hidden' name='" + divId + "_customerItemUnit' value='" + item.getUnits() + "'></td>";
                                                                                                                if (item.getName().equals("Boxes")) {
                                                                                                                    tr += "<td align='right'><input class='btn btn-default' type='button' value='x' onclick=\"deleteBox(this, '" + divId + "')\"/></td></tr>";
                                                                                                                } else {
                                                                                                                    tr += "<td align='right'><input class='btn btn-default' type='button' value='x' onclick=\"deleteItem(this, '" + divId + "')\"/></td></tr>";
                                                                                                                }
                                                                                                                out.println(tr);
                                                                                                            }
                                                                                                        %>
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
                                                                                    <tr style="background-color:#CEE3F6" height="10%">
                                                                                        <td><center><b><u>Vimbox Item List</u></b></center></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td>
                                                                                            <div style="overflow:auto;height:100%;">
                                                                                                <table  class='table' id="<%=divId%>_vimboxItemsTable" valign="top" style="width:100%;">
                                                                                                    <col width="20%">
                                                                                                    <col width="40%">
                                                                                                    <col width="10%">
                                                                                                    <col width="10%">
                                                                                                    <col width="10%">
                                                                                                    <col width="20%">
                                                                                                    <tbody>
                                                                                                        <%
                                                                                                            ArrayList<Item> vimboxItems = leadDiv.getVimboxItems();
                                                                                                            for (Item item : vimboxItems) {
                                                                                                                String tr = "<tr><td>" + item.getName() + "<input type='hidden' name='" + divId + "_vimboxItemName' value='" + item.getName() + "'></td>";
                                                                                                                tr += "<td>&nbsp;<input type='hidden' name='" + divId + "_vimboxItemRemark' value=''></td>";
                                                                                                                tr += "<td align='center'>&nbsp;&nbsp;&nbsp;&nbsp;<input type='hidden' name='" + divId + "_vimboxItemCharge' value=''></td>";
                                                                                                                tr += "<td align='center'>" + item.getUnits() + "<input type='hidden' name='" + divId + "_vimboxItemQty' value='" + item.getUnits() + "'></td>";
                                                                                                                tr += "<td align='center'>" + item.getUnits() + "<input type='hidden' name='" + divId + "_vimboxItemUnit' value='" + item.getUnits() + "'></td>";
                                                                                                                tr += "<td align='right'><input class='btn btn-default' type='button' value='x' onclick=\"deleteBox(this, '" + divId + "')\"/></td></tr>";
                                                                                                                out.println(tr);
                                                                                                            }

                                                                                                            ArrayList<Item> materials = leadDiv.getMaterials();
                                                                                                            for (Item item : materials) {
                                                                                                                String tr = "<tr><td>" + item.getName() + "<input type='hidden' name='" + divId + "_vimboxMaterialName' value='" + item.getName() + "'></td>";
                                                                                                                tr += "<td>&nbsp;</td>";
                                                                                                                tr += "<td align='center'>" + item.getCharges() + "<input type='hidden' name='" + divId + "_vimboxMaterialCharge' value='" + item.getCharges() + "'></td>";
                                                                                                                tr += "<td align='center'>" + item.getUnits() + "<input type='hidden' name='" + divId + "_vimboxMaterialQty' value='" + item.getUnits() + "'></td>";
                                                                                                                tr += "<td align='center'>&nbsp;</td>";
                                                                                                                tr += "<td align='right'><input clas='btn btn-default' type='button' value='x' onclick=\"deleteMaterial(this, '" + divId + "')\"/></td></tr>";
                                                                                                                out.println(tr);
                                                                                                            }
                                                                                                        %>
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
                                                                                            <tbody>
                                                                                                <%
                                                                                                    for (String[] service : services) {
                                                                                                        String[] svc = service[0].split("_");
                                                                                                        String tr = "<tr id='" + divId + "_" + service[0] + "'><td>";
                                                                                                        tr += "<table class='serviceTable'>";
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
                                                                                </td>
                                                                            </tr>
                                                                            <%
                                                                                HashMap<String, String> others = leadDiv.getOtherCharges();
                                                                            %>
                                                                            <tr height="5%">
                                                                                <td>
                                                                                    <table class='table' width="100%">
                                                                                        <tr>
                                                                                            <td align="left">Storey Charges:</td>
                                                                                            <td align="right">
                                                                                                  <div class="input-group">
                            <span class="input-group-addon">$</span>
                            <input class='form-control storeyCharge' type="number" step="0.01" min="0" id="<%=divId%>_storeyCharge" name="<%=divId%>_storeyCharge" value="<%=others.get("storeyCharge")%>">
                                    </div> </td>
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
                            <input class='form-control pushCharge'  type="number" step="0.01" min="0" id="<%=divId%>_pushCharge"  name="<%=divId%>_pushCharge" value="<%=others.get("pushCharge")%>">
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
                                                                                            <td align="left">Detour Charges:</td>
                                                                                            <td align="right">
                                                                                                <div class="input-group">
                            <span class="input-group-addon">$</span>
                            <input class='form-control detourCharge' type="number" step="0.01" min="0" id="<%=divId%>_detourCharge"  name="<%=divId%>_detourCharge" value="<%=others.get("detourCharge")%>">
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
                            <input class='form-control materialCharge' type="number" step="0.01" min="0" id="<%=divId%>_materialCharge"  name="<%=divId%>_materialCharge" value="<%=others.get("materialCharge")%>">
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
                            <input class='form-control markup' type="number" step="0.01" min="0" id="<%=divId%>_markup"  name="<%=divId%>_markup" value="<%=others.get("markup")%>">
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
                                                                                            <td align="left">Discount:</td>
                                                                                            <td align="right">
                                                                                                <div class="input-group">
                            <span class="input-group-addon">$</span>
                            <input  class='form-control discount' type="number" step="0.01" min="0" id="<%=divId%>_discount"  name="<%=divId%>_discount" value="<%=others.get("discount")%>">
                                    </div>
                                                                                            </td>
                                                                                                
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
                                                                                                        <tbody>
                                                                                                            <%
                                                                                                                ArrayList<String> comments = leadDiv.getComments();
                                                                                                                for (String comment : comments) {
                                                                                                                    out.println("<tr><td>" + comment + "<input type='hidden' name='" + divId + "_comments' value='" + comment + "'></td><td align='right'><input type='button' value='x' onclick='deleteRow(this)'/></td></tr>");
                                                                                                                }
                                                                                                            %>    
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
                                                                                    <table>
                                                                                        <tr style="height:10%;background-color:#F6CEE3;">
                                            <th><center><b><u>Remarks</u></b></center></th>
                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <div style="overflow:auto;height:100%;">
                                                                                                    <table id="<%=divId%>_remarksTable" valign="top">
                                                                                                        <tbody>
                                                                                                            <%
                                                                                                                ArrayList<String> remarks = leadDiv.getRemarks();
                                                                                                                for (String remark : remarks) {
                                                                                                                    out.println("<tr><td>" + remark + "<input type='hidden' name='" + divId + "_remarks' value='" + remark + "'></td><td align='right'><input type='button' value='x' onclick='deleteRow(this)'/></td></tr>");
                                                                                                                }
                                                                                                            %>  
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
                                                                <table width="100%">
                                                                    <tr>
                                                                        <td align="right">Additional Manpower :</td>
                                                                        <td><input class='form-control' type="number" id="<%=divId%>_additionalManpower"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="right">Reason :</td>
                                                                        <td><input class='form-control' type="text" id="<%=divId%>_manpowerReason" style="width:90%"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <button class='btn btn-default' align="center" onclick="closeManpowerModal('<%=divId%>');
                                                                                    return false;" style="width:100%;">CANCEL</button>
                                                                        </td>
                                                                        <td>
                                                                            <button class='btn btn-default' align="center" onclick="submitManpower('<%=divId%>');
                                                                                    return false;" style="width:100%;">REQUEST</button>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>    
                                                <%
                                                    }
                                                %>    
                                            </div>
                                        </fieldset>
                                    </fieldset>
                                    <br>
                                    <fieldset>
                                        <legend>Enquiry Information</legend>
                                        <div class="form-group ">
                                            <label class="col-sm-3 control-label">Enquiry: </label>
                                            <div class="col-sm-4">
                                                <div class="form-group row">
                                                    <div class="col-sm-6">
                                                        <select class="form-control" name="enquiry" id="enquiry" onchange="showfield(this.options[this.selectedIndex].value, this)">
                                                            <%
                                                                String enq = lead.getEnquiry();
                                                                boolean selected = false;
                                                                enquiries.add(0, "SELECT");
                                                                for (String enquiry : enquiries) {
                                                                    if (enquiry.equals(enq)) {
                                                                        selected = true;
                                                                        if (enquiry.equals("SELECT")) {
                                                                            out.println("<option value='" + enquiry + "' selected>--SELECT--</option>");
                                                                        } else {
                                                                            out.println("<option value='" + enquiry + "' selected>" + enquiry + "</option>");
                                                                        }
                                                                    } else {
                                                                        if (enquiry.equals("SELECT")) {
                                                                            out.println("<option value='" + enquiry + "'>--SELECT--</option>");
                                                                        } else {
                                                                            out.println("<option value='" + enquiry + "'>" + enquiry + "</option>");
                                                                        }
                                                                    }
                                                                }
                                                                if (!selected) {
                                                                    out.println("<option value='Others' selected>Others</option>");
                                                                } else {
                                                                    out.println("<option value='Others'>Others</option>");
                                                                }
                                                            %>
                                                        </select>
                                                    </div>
                                                    <div class="col-sm-6">
                                                        <div id='enquiryOthers'>
                                                            <%
                                                                if (!selected) {%>

                                                            <%
                                                                    out.println("<input class='form-control' type='text' name='enquiryOthers' value='" + enq + "' />");
                                                                }
                                                            %>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>                             

                                        <div class="form-group ">
                                            <label class="col-sm-3 control-label">Referred by: </label>
                                            <div class="col-sm-4">
                                                <div class="form-group row">
                                                    <div class="col-sm-6">
                                                        <select class="form-control" name="referral" id="referral" onchange="showfield(this.options[this.selectedIndex].value, this)">
                                                            <%
                                                                String ref = lead.getReferral();
                                                                selected = false;
                                                                for (String referral : referrals) {
                                                                    if (referral.equals(ref)) {
                                                                        selected = true;
                                                                        out.println("<option value='" + referral + "' selected>" + referral + "</option>");
                                                                    } else {
                                                                        out.println("<option value='" + referral + "'>" + referral + "</option>");
                                                                    }
                                                                }
                                                                if (!selected) {
                                                                    out.println("<option value='Others' selected>Others</option>");
                                                                } else {
                                                                    out.println("<option value='Others'>Others</option>");
                                                                }
                                                            %>
                                                        </select>
                                                    </div>
                                                    <div class="col-sm-6">
                                                        <div id='referralOthers'>
                                                            <%
                                                                if (!selected) {%>

                                                            <%
                                                                    out.println("<input class='form-control' type='text' name='referralOthers' value='" + ref + "' />");
                                                                }
                                                            %>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>             
                                    </fieldset>
                                    <br>
                                    <table>
                                        <tr>
                                            <td></td>
                                            <td>
                                                <div class="bg-default text-center">
                                                    <button type="submit" data-loading-text="Loading..." class="btn loading-button btn-primary">Save</button></div>
                                                <!--<input type="submit" value="Generate Quotation" formaction="new_lead_pdf.pdf" formtarget="_blank">-->
                                                <!--<button onclick="return checkEmail();">Email Quotation</button>-->
                                                <!--<button onclick="cancelLead(lead.getId());
                                                        return false;">Reject</button>-->
                                            </td>
                                        </tr>
                                    </table>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            $('#edit_lead_form').ajaxForm({
                dataType: 'json',
                success: function (data) {
                    var modal = document.getElementById("lead_error_modal");
                    var status = document.getElementById("lead_error_status");
                    var message = document.getElementById("lead_error_message");
                    status.innerHTML = data.status;
                    message.innerHTML = data.message;
                    modal.style.display = "block";

                    if (data.status === "SUCCESS") {
                        setTimeout(function () {
                            window.location.href = "MyLeads.jsp";
                        }, 500);
                    }
                },
                error: function (data) {
                    var modal = document.getElementById("lead_error_modal");
                    var status = document.getElementById("lead_error_status");
                    var message = document.getElementById("lead_error_message");
                    status.innerHTML = "ERROR";
                    message.innerHTML = data;
                    modal.style.display = "block";
                }
            });

            jQuery(document).bind('keydown', 'ctrl+shift', function (e) {
                var tableClassName = $(document.activeElement.parentNode.parentNode.parentNode.parentNode).attr('class');

                var activeElement = document.activeElement.parentNode;
                var tagname = activeElement.tagName;
                while (tagname !== 'DIV') {
                    activeElement = activeElement.parentNode;
                    tagname = activeElement.tagName;
                }

                switch (tableClassName) {
                    case "customerBoxTable":
                        addCustomerBox(activeElement.id);
                        break;
                    case "customerItemTable":
                        addItem(activeElement.id);
                        break;
                    case "customerSpecialItemTable":
                        addSpecialItem(activeElement.id);
                        break;
                    case "vimboxBoxTable":
                        addVimboxBox(activeElement.id);
                        break;
                    case "vimboxMaterialTable":
                        addVimboxMaterial(activeElement.id);
                        break;
                    case "customerCommentTable":
                        addCustomerComment(activeElement.id);
                        break;
                    case "customerRemarkTable":
                        addCustomerRemark(activeElement.id);
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
                    var activeElement = parent.parentNode;
                    var tagname = activeElement.tagName;
                    var id = activeElement.id;
                    while (tagname !== 'DIV' || id == null || id === '') {
                        activeElement = activeElement.parentNode;
                        tagname = activeElement.tagName;
                        id = activeElement.id;
                    }
                    update_service(element, activeElement.id);
                }
            });

            $(document).ready(function () {
                $(window).keydown(function (event) {
                    if (event.keyCode == 13) {
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
    </body>
</html>
