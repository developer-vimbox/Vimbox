<%@page import="com.vimbox.sales.LeadDiv"%>
<%@page import="com.vimbox.sitesurvey.SiteSurvey"%>
<%@page import="com.vimbox.sales.Lead"%>
<%@page import="com.vimbox.database.LeadDAO"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.vimbox.sales.Item"%>
<%@page import="com.vimbox.customer.Customer"%>
<%@include file="ValidateLogin.jsp"%>
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
        <a href="MyLeads.jsp">Back</a><br>
        <form method="POST" action="EditLeadController" autocomplete="on" id="edit_lead_form">
            <table style="width:250px;">
                <tr>
                    <td align="right"><b>Lead ID :</b></td>
                    <td><%=lead.getId()%><input type="hidden" id="leadId" name="leadId" value="<%=lead.getId()%>"></td>
                </tr>
                <tr>
                    <td align="right"><b>Status :</b></td>
                    <td><%=lead.getStatus()%><input type="hidden" name="status" value="<%=lead.getStatus()%>"></td>
                </tr>
                <tr>
                    <td align="right"><b>Source :</b></td>
                    <td>
                        <%
                            String src = lead.getSource();
                            for (int i = 0; i < sources.size(); i++) {
                                String source = sources.get(i);
                                if (src.equals(source)) {
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
                <%                    Customer customer = lead.getCustomer();
                %>
                <table>
                    <col width="100">
                    <tr>
                        <td align="right"><b>Referred by :</b></td>
                        <td>
                            <select name="referral" id="referral" onchange="showfield(this.options[this.selectedIndex].value)">
                                <%
                                    String ref = lead.getReferral();
                                    boolean selected = false;
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
                            <div id='referralOthers' style='display:inline-block'>
                                <%
                                    if (!selected) {
                                        out.println("Others: <input type='text' name='referralOthers' value='" + ref + "' />");
                                    }
                                %>
                            </div>
                        </td>
                    </tr>
                </table>
                <div id="customer_information_table" <%if (customer == null) {
                        out.println("style='display:none'");
                    } else {
                        out.println("style='display:block'");
                    }%>>
                    <input type="hidden" id="customer_id" name="customer_id" <%if (customer != null) {
                            out.println("value='" + customer.getCustomer_id() + "'");
                        }%>>
                    <table>
                        <col width="100">
                        <tr>
                            <td align="right"><b>Salutation :</b></td>
                            <td>
                                <label id="customer_salutation"><%if (customer != null) {
                                        out.println(customer.getSalutation());
                                    }%></label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right"><b>First Name :</b></td>
                            <td>
                                <label id="customer_first_name"><%if (customer != null) {
                                        out.println(customer.getFirst_name());
                                    }%></label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right"><b>Last Name :</b></td>
                            <td>
                                <label id="customer_last_name"><%if (customer != null) {
                                        out.println(customer.getLast_name());
                                    }%></label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right"><b>Contact :</b></td>
                            <td>
                                <label id="customer_contact"><%if (customer != null) {
                                        out.println(customer.getContact());
                                    }%></label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right"><b>Email :</b></td>
                            <td>
                                <label id="customer_email"><%if (customer != null) {
                                        out.println(customer.getEmail());
                                    }%></label>
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
                                String[] tom = lead.getTom().split("\\|");

                                for (String type : moveTypes) {
                                    boolean present = false;
                                    for (String tm : tom) {
                                        if (tm.equals(type)) {
                                            present = true;
                                        }
                                    }
                                    if (present) {
                                        out.println("<input type='checkbox' name='tom' value='" + type + "' checked>" + type);
                                    } else {
                                        out.println("<input type='checkbox' name='tom' value='" + type + "'>" + type);
                                    }
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
                                        <%
                                            String dom = lead.getDom();
                                            if (dom.isEmpty()) {
                                        %>
                                        <tr>
                                            <td><input type="date" name="dom"></td>
                                            <td><input type="button" value="+" onClick="addDom('dynamicDom');"></td>
                                        </tr>
                                        <%
                                            } else {
                                                int counter = 2;
                                                String[] dates = dom.split("\\|");
                                                for (int i = 0; i < dates.length; i++) {
                                                    String date = dates[i];
                                                    if (i == 0) {
                                                        out.println("<tr>");
                                                        out.println("<td><input type='date' name'dom' value='" + date + "'></td>");
                                                        out.println("<td><input type='button' value='+' onClick=\"addDom('dynamicDom');\"></td>");
                                                        out.println("</tr></table></div>");
                                                    } else {
                                                        out.println("<div id='" + counter + "'>");
                                                        out.println("<table class='dynamicDomTable'>");
                                                        out.println("<tr>");
                                                        out.println("<td><input type='date' name'dom' value='" + date + "'></td>");
                                                        out.println("<td><input type='button' value='x' onClick='removeInput(" + counter + ");'></td>");
                                                        out.println("</tr></table></div>");
                                                        counter++;
                                                    }
                                                }
                                            }
                                        %>

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
                                    stringDiv = "<div class='address-box' id='from" + counter + "'><input type='hidden' id='tagId' value='" + salesDivId + "_lbl'><span class='close' onClick=\"removeAddress('from" + counter + "', '" + counter + "');\">×</span><hr><table><col width='100'><tr><td align='right'>";
                                    stringDiv += ("<b>Address :</b></td><td><input type='text' class='addressFromInput' name='addressfrom' size='30' value='" + address[0] + "'>");
                                    stringDiv += " #<input type='text' class='addressFromInput' name='addressfrom' size='2' value='" + address[1] + "'>-<input type='text' class='addressFromInput' name='addressfrom' size='3' value='" + address[2] + "'>";
                                    stringDiv += " S<input type='text' class='addressFromInput' name='addressfrom' size='5' value='" + address[3] + "'></td>";
                                    stringDiv += "<tr><td align='right'><b>Storeys :</b></td><td><input type='text' name='storeysfrom' size='5' value='" + storeys + "'></td></tr>";
                                    stringDiv += "<tr><td align='right'><b>Pushing Distance :</b></td><td><input type='text' name='distancefrom' size='5' value='" + pushingDistance + "'> M</td></tr>";
                                    stringDiv += "</table></div>";
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
                    <b>S </b><input type="text" id="postalto" placeholder="Enter Postal Code">
                    <button onclick="searchAddressTo();
                            return false;">Search address to</button>
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
                                    stringDiv = "<div class='address-box' id='to" + counter + "'><span class='close' onClick=\"removeAddress('to" + counter + "', '');\">×</span><hr><table><col width='100'><tr><td align='right'>";
                                    stringDiv += ("<b>Address :</b></td><td><input type='text' name='addressto' size='30' value='" + address[0] + "'>");
                                    stringDiv += " #<input type='text' name='addressto' size='2' value='" + address[1] + "'>-<input type='text' name='addressto' size='3' value='" + address[2] + "'>";
                                    stringDiv += " S<input type='text' name='addressto' size='5' value='" + address[3] + "'></td>";
                                    stringDiv += "<tr><td align='right'><b>Storeys :</b></td><td><input type='text' name='storeysto' size='5' value='" + storeys + "'></td></tr>";
                                    stringDiv += "<tr><td align='right'><b>Pushing Distance :</b></td><td><input type='text' name='distanceto' size='5' value='" + pushingDistance + "'> M</td></tr>";
                                    stringDiv += "</table></div>";
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
                <table>
                    <col width="100">
                    <tr>
                        <td align="right"><b>Lead Type :</b></td>
                        <td>
                            <div id="leadInfo">
                                <%
                                    String[] lts = lead.getType().split("\\|");
                                    for (String type : types) {
                                        boolean check = false;
                                        for (String lt : lts) {
                                            if (type.equals(lt)) {
                                                check = true;
                                                break;
                                            }
                                        }
                                        if (check) {
                                            out.println("<input type='checkbox' name='leadType' value='" + type + "' checked>" + type);
                                        } else {
                                            out.println("<input type='checkbox' name='leadType' value='" + type + "'>" + type);
                                        }
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
                                    <textarea name="enquiry" cols="75" rows="6" autocomplete="off"><%=lead.getEnquiry()%></textarea>
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
                                        if(sStatus.equals("Pending")){
                                            out.println("<span class='close' onClick=\"removeSiteSurvey('" + ss + "');\">×</span>");
                                        }
                                        out.println("<hr><table><col width='100'>");
                                        out.println("<tr><td align='right'><b>Date :</b></td><td><input type='hidden' name='siteSurvey_date' value='" + ss + "'>" + ss + "</td></tr>");
                                        out.println("<tr><td align='right'><b>Timeslot :</b></td><td><table>");
                                        for (int j = 0; j < timeslots.size(); j++) {
                                            out.println("<tr><td><input type='hidden' name='siteSurvey_timeslot' value='" + ss + "|" + timeslots.get(j) + "'>" + timeslots.get(j) + "</td></tr>");
                                        }
                                        out.println("</table></td></tr>");
                                        out.println("<tr><td align='right'><b>Address :</b></td><td><table>");
                                        for (int j = 0; j < addresses.size(); j++) {
                                            out.println("<tr><td><input type='hidden' name='siteSurvey_address' value='" + ss + "|" + addresses.get(j) + "'>" + addresses.get(j) + "</td></tr>");
                                        }
                                        out.println("</table></td></tr>");
                                        out.println("<tr><td align='right'><b>Surveyor :</b></td><td><input type='hidden' name='siteSurvey_surveyor' value='" + ss + "|" + sId + "'>" + sName + "</td></tr>");
                                        out.println("<tr><td align='right'><b>Remarks :</b></td><td><input type='hidden' name='siteSurvey_remarks' value='" + ss + "|" + sRem + "'>" + sRem + "</td></tr>");
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
                                        if(sStatus.equals("Pending")){
                                            out.println("<span class='close' onClick=\"removeSiteSurvey('" + ss + "');\">×</span>");
                                            out.println("<input type='hidden' name='surveyStatus' value='yes'>");
                                        }else{
                                            out.println("<input type='hidden' name='surveyStatus' value='no'>");
                                        }
                                        out.println("<hr><table><col width='100'>");
                                        out.println("<tr><td align='right'><b>Date :</b></td><td><input type='hidden' name='siteSurvey_date' value='" + ss + "'>" + ss + "</td></tr>");
                                        out.println("<tr><td align='right'><b>Timeslot :</b></td><td><table>");
                                        for (int j = 0; j < timeslots.size(); j++) {
                                            out.println("<tr><td><input type='hidden' name='siteSurvey_timeslot' value='" + ss + "|" + timeslots.get(j) + "'>" + timeslots.get(j) + "</td></tr>");
                                        }
                                        out.println("</table></td></tr>");
                                        out.println("<tr><td align='right'><b>Address :</b></td><td><table>");
                                        for (int j = 0; j < addresses.size(); j++) {
                                            out.println("<tr><td><input type='hidden' name='siteSurvey_address' value='" + ss + "|" + addresses.get(j) + "'>" + addresses.get(j) + "</td></tr>");
                                        }
                                        out.println("</table></td></tr>");
                                        out.println("<tr><td align='right'><b>Surveyor :</b></td><td><input type='hidden' name='siteSurvey_surveyor' value='" + ss + "|" + sId + "'>" + sName + "</td></tr>");
                                        out.println("<tr><td align='right'><b>Remarks :</b></td><td><input type='hidden' name='siteSurvey_remarks' value='" + ss + "|" + sRem + "'>" + sRem + "</td></tr>");
                                        out.println("<tr><td align='right'><b>Status :</b></td><td>" + survey.getStatus() + "</td></tr>");
                                        out.println("</table></div>");
                                    }
                                }
                            %>
                        </div>
                    </fieldset>
                </div>

                <div id="Sales" style="display:none">
                    <br>
                    <fieldset>
                        <b><u>Sales Details</u></b><hr>
                        <ul class="tab" id="sales_list">
                            <%
                                ArrayList<LeadDiv> leadDivs = lead.getSalesDivs();
                                for (LeadDiv leadDiv : leadDivs) {
                                    String leadDivStr = leadDiv.getSalesDiv();
                                    String leadDivId = leadDivStr.substring(0, leadDivStr.indexOf("|"));
                                    String leadDivAddr = leadDivStr.substring(leadDivStr.indexOf("|") + 1);
                                    out.println("<li id='li_" + leadDivId.substring(5) + "'><a href='#' class='tablinks' onclick=\"openSales(event, '" + leadDivId + "')\"><label id='" + leadDivId + "_lbl'>" + leadDivAddr + "</label></a></li>");
                                }
                            %>
                        </ul>
                        <div id="sales_container">
                            <%
                                for (LeadDiv leadDiv : leadDivs) {
                                    String leadDivStr = leadDiv.getSalesDiv();
                                    String leadDivId = leadDivStr.substring(0, leadDivStr.indexOf("|"));
                            %>
                            <div id="<%=leadDivId%>" class="tabcontent">
                                <input type="hidden" id="<%=leadDivId%>_divId" class="divId" name="divId" value="<%=leadDivStr%>">
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
                                                                    <input type="number" min="0" id="<%=leadDivId%>_customerBoxUnit">
                                                                    <button onclick="addCustomerBox('<%=leadDivId%>');
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
                                                                    <input type="text" size="40" class="itemName" id="<%=leadDivId%>_itemName" list="<%=leadDivId%>_items" placeholder="Enter item">

                                                                    <datalist id="<%=leadDivId%>_items">
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
                                                                    <input type="text" size="40" id="<%=leadDivId%>_itemdimensions" placeholder="Dimensions" disabled>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td align="right">Units :</td>
                                                                <td>
                                                                    <input type="number" min="0" id="<%=leadDivId%>_itemUnit">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td align="right">Quantity :</td>
                                                                <td>
                                                                    <input type="number" min="0" id="<%=leadDivId%>_itemQty">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td align="right">Remarks :</td>
                                                                <td>
                                                                    <input type="text" size="40" id="<%=leadDivId%>_itemRemark" placeholder="Enter item remarks">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td></td>
                                                                <td>
                                                                    <button onclick="addItem('<%=leadDivId%>');
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
                                                                    <input type="text" size="40" id="<%=leadDivId%>_specialItemName" list="<%=leadDivId%>_specialitems" placeholder="Enter item">

                                                                    <datalist id="<%=leadDivId%>_specialitems">
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
                                                                    <input type="number" min="0" id="<%=leadDivId%>_specialItemUnit">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td align="right">Quantity :</td>
                                                                <td>
                                                                    <input type="number" min="0" id="<%=leadDivId%>_specialItemQty">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td align="right">Additional Charges :</td>
                                                                <td>
                                                                    $ <input type="number" min="0" step="0.01" id="<%=leadDivId%>_specialItemCharges">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td align="right">Remarks :</td>
                                                                <td>
                                                                    <input type="text" size="40" id="<%=leadDivId%>_specialItemRemark" placeholder="Enter item remarks">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td></td>
                                                                <td>
                                                                    <button onclick="addSpecialItem('<%=leadDivId%>');
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
                                                                    <input type="number" min="0" id="<%=leadDivId%>_vimboxBoxUnit">
                                                                    <button onclick="addVimboxBox('<%=leadDivId%>');
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
                                                                    <input type="text" id="<%=leadDivId%>_vimboxMaterial">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td align="right">Quantity :</td>
                                                                <td>
                                                                    <input type="number" step="0.01" min="0" id="<%=leadDivId%>_vimboxMaterialUnit">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td align="right">Charges :</td>
                                                                <td>
                                                                    $ <input type="number" min="0" step="0.01" id="<%=leadDivId%>_vimboxMaterialCharge">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td></td>
                                                                <td>
                                                                    <button onclick="addVimboxMaterial('<%=leadDivId%>');
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
                                                        <button style="width:100%" onclick="selectService('<%=leadDivId%>');
                                                                return false;">Add service</button>
                                                        <!-- Service Modal -->
                                                        <div id="<%=leadDivId%>_serviceModal" class="service">
                                                            <!-- Modal content -->
                                                            <div class="service-content">
                                                                <div class="service-body">
                                                                    <span class="close" onclick="closeModal('<%=leadDivId%>_serviceModal')">×</span>
                                                                    <table width="100%" border="1" style="table-layout: fixed;" id="<%=leadDivId%>_serviceTable">
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
                                                                                        out.println("<td bgcolor='#6698FF' align='center' onclick=\"selectServiceSlot(this, '" + leadDivId + "')\"");
                                                                                        if (serviceTable[0][j].equals("Manpower")) {
                                                                                            out.println("id='" + leadDivId + (serviceTable[0][j] + "_" + serviceChargeArray[0]).replaceAll(" ", "_") + "_service'");
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
                                                                                            out.println("Manpower : <label id='" + leadDivId + "_" + id + "manpowerLabel'>" + mp + "</label><input type='hidden' name='" + leadDivId + "_" + id + "manpowerInput' id='" + leadDivId + "_" + id + "manpowerInput' value='" + mp + "'></br>");
                                                                                            out.println("Reason : <label id='" + leadDivId + "_" + id + "manpowerReasonLabel'>" + mr + "</label><input type='hidden' name='" + leadDivId + "_" + id + "reasonInput' id='" + leadDivId + "_" + id + "reasonInput' value='" + mr + "'></br>");
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
                                                                    <input type="text" size="40" id="<%=leadDivId%>_customerComment" placeholder="Enter customer comment">
                                                                </td>
                                                                <td>
                                                                    <button onclick="addCustomerComment('<%=leadDivId%>');
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
                                                                    <input type="text" size="40" id="<%=leadDivId%>_customerRemark" placeholder="Enter remark for customer">
                                                                </td>
                                                                <td>
                                                                    <button onclick="addCustomerRemark('<%=leadDivId%>');
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
                                                                <th style="width:20%"><div id="<%=leadDivId%>_totalUnits"></div></th>
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
                                                                                    <table id="<%=leadDivId%>_customerItemsTable" valign="top" style="width:100%;">
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
                                                                                                    String tr = "<tr><td>" + item.getName() + "<input type='hidden' name='" + leadDivId + "_customerItemName' value='" + item.getName() + "'></td>";
                                                                                                    tr += "<td>" + item.getRemark() + "<input type='hidden' name='" + leadDivId + "_customerItemRemark' value='" + item.getRemark() + "'></td>";
                                                                                                    if (item.getCharges() > 0) {
                                                                                                        tr += "<td align='center'>" + item.getCharges() + "<input type='hidden' name='" + leadDivId + "_customerItemCharge' value='" + item.getCharges() + "'></td>";
                                                                                                    } else {
                                                                                                        tr += "<td align='center'>&nbsp;&nbsp;&nbsp;&nbsp;<input type='hidden' name='" + leadDivId + "_customerItemCharge' value=''></td>";
                                                                                                    }

                                                                                                    tr += "<td align='center'>" + item.getQty() + "<input type='hidden' name='" + leadDivId + "_customerItemQty' value='" + item.getQty() + "'></td>";
                                                                                                    tr += "<td align='center'>" + item.getUnits() + "<input type='hidden' name='" + leadDivId + "_customerItemUnit' value='" + item.getUnits() + "'></td>";
                                                                                                    if (item.getName().equals("Boxes")) {
                                                                                                        tr += "<td align='right'><input type='button' value='x' onclick=\"deleteBox(this, '" + leadDivId + "')\"/></td></tr>";
                                                                                                    } else {
                                                                                                        tr += "<td align='right'><input type='button' value='x' onclick=\"deleteItem(this, '" + leadDivId + "')\"/></td></tr>";
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
                                                                    <table border="1">
                                                                        <tr style="background-color:CornflowerBlue" height="10%">
                                                                            <td align="center"><b><u>Vimbox Item List</u></b></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <div style="overflow:auto;height:100%;">
                                                                                    <table id="<%=leadDivId%>_vimboxItemsTable" valign="top" style="width:100%;">
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
                                                                                                    String tr = "<tr><td>Boxes<input type='hidden' name='" + leadDivId + "_vimboxItemName' value='Boxes'></td>";
                                                                                                    tr += "<td>&nbsp;<input type='hidden' name='" + leadDivId + "_vimboxItemRemark' value=''></td>";
                                                                                                    tr += "<td align='center'>&nbsp;&nbsp;&nbsp;&nbsp;<input type='hidden' name='" + leadDivId + "_vimboxItemCharge' value=''></td>";
                                                                                                    tr += "<td align='center'>" + item.getUnits() + "<input type='hidden' name='" + leadDivId + "_vimboxItemQty' value='" + item.getUnits() + "'></td>";
                                                                                                    tr += "<td align='center'>" + item.getUnits() + "<input type='hidden' name='" + leadDivId + "_vimboxItemUnit' value='" + item.getUnits() + "'></td>";
                                                                                                    tr += "<td align='right'><input type='button' value='x' onclick=\"deleteBox(this, '" + leadDivId + "')\"/></td></tr>";
                                                                                                    out.println(tr);
                                                                                                }

                                                                                                ArrayList<Item> materials = leadDiv.getMaterials();
                                                                                                for (Item item : materials) {
                                                                                                    String tr = "<tr><td>" + item.getName() + "<input type='hidden' name='" + leadDivId + "_vimboxMaterialName' value='" + item.getName() + "'></td>";
                                                                                                    tr += "<td>&nbsp;</td>";
                                                                                                    tr += "<td align='center'>" + item.getCharges() + "<input type='hidden' name='" + leadDivId + "_vimboxMaterialCharge' value='" + item.getCharges() + "'></td>";
                                                                                                    tr += "<td align='center'>" + item.getUnits() + "<input type='hidden' name='" + leadDivId + "_vimboxMaterialQty' value='" + item.getUnits() + "'></td>";
                                                                                                    tr += "<td align='center'>&nbsp;</td>";
                                                                                                    tr += "<td align='right'><input type='button' value='x' onclick=\"deleteMaterial(this, '" + leadDivId + "')\"/></td></tr>";
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
                                                                        <table class="servicesTable" id="<%=leadDivId%>_servicesTable" valign="top" width="100%">
                                                                            <tbody>
                                                                                <%
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
                                                            <tr height="5%">
                                                                <td>
                                                                    <table width="100%">
                                                                        <tr>
                                                                            <td align="left">Storey Charges :</td>
                                                                            <td align="right">$ <input type="number" step="0.01" min="0" id="<%=leadDivId%>_storeyCharge" class="storeyCharge" name="<%=leadDivId%>_storeyCharge" value="<%=others.get("storeyCharge")%>"></td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr height="5%">
                                                                <td>
                                                                    <table width="100%">
                                                                        <tr>
                                                                            <td align="left">Pushing Charges :</td>
                                                                            <td align="right">$ <input type="number" step="0.01" min="0" id="<%=leadDivId%>_pushCharge" class="pushCharge" name="<%=leadDivId%>_pushCharge" value="<%=others.get("pushCharge")%>"></td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr height="5%">
                                                                <td>
                                                                    <table width="100%">
                                                                        <tr>
                                                                            <td align="left">Detour Charges :</td>
                                                                            <td align="right">$ <input type="number" step="0.01" min="0" id="<%=leadDivId%>_detourCharge" class="detourCharge" name="<%=leadDivId%>_detourCharge" value="<%=others.get("detourCharge")%>"></td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr height="5%">
                                                                <td>
                                                                    <table width="100%">
                                                                        <tr>
                                                                            <td align="left">Material Charges :</td>
                                                                            <td align="right">$ <input type="number" step="0.01" min="0" id="<%=leadDivId%>_materialCharge" class="materialCharge" name="<%=leadDivId%>_materialCharge" value="<%=others.get("materialCharge")%>"></td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr height="5%">
                                                                <td>
                                                                    <table width="100%">
                                                                        <tr>
                                                                            <td align="left">Additional Markup :</td>
                                                                            <td align="right">$ <input type="number" step="0.01" min="0" id="<%=leadDivId%>_markup" class="markup" name="<%=leadDivId%>_markup" value="<%=others.get("markup")%>"></td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr height="5%">
                                                                <td>
                                                                    <table width="100%">
                                                                        <tr>
                                                                            <td align="left">Discount :</td>
                                                                            <td align="right">$ <input type="number" step="0.01" min="0" id="<%=leadDivId%>_discount" class="discount" name="<%=leadDivId%>_discount" value="<%=others.get("discount")%>"></td>
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
                                                                                    <table id="<%=leadDivId%>_commentsTable" valign="top">
                                                                                        <tbody>
                                                                                            <%
                                                                                                ArrayList<String> comments = leadDiv.getComments();
                                                                                                for (String comment : comments) {
                                                                                                    out.println("<tr><td>" + comment + "<input type='hidden' name='" + leadDivId + "_comments' value='" + comment + "'></td><td align='right'><input type='button' value='x' onclick='deleteRow(this)'/></td></tr>");
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
                                                                    <table border="1">
                                                                        <tr style="height:10%;background-color:Plum;">
                                                                            <th>Customer Remarks</th>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <div style="overflow:auto;height:100%;">
                                                                                    <table id="<%=leadDivId%>_remarksTable" valign="top">
                                                                                        <tbody>
                                                                                            <%
                                                                                                ArrayList<String> remarks = leadDiv.getRemarks();
                                                                                                for (String remark : remarks) {
                                                                                                    out.println("<tr><td>" + remark + "<input type='hidden' name='" + leadDivId + "_remarks' value='" + remark + "'></td><td align='right'><input type='button' value='x' onclick='deleteRow(this)'/></td></tr>");
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
                                            <table border="1">
                                                <tr>
                                                    <td align="right" style="width:80%">Total :</td>
                                                    <td align="center">$ <input type="number" step="0.01" min="0" name="totalPrice" id="<%=leadDivId%>_totalPrice" value="0.00"></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                                </td>
                                </tr>
                                </table>
                                
                                <div id="<%=leadDivId%>_manpowerModal" class="modal">
                                    <!-- Modal content -->
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <h3>Manpower Request</h3><hr>
                                            <input type="hidden" id="<%=leadDivId%>_manpowerId">
                                            <table width="100%">
                                                <tr>
                                                    <td align="right">Additional Manpower :</td>
                                                    <td><input type="number" id="<%=leadDivId%>_additionalManpower"></td>
                                                </tr>
                                                <tr>
                                                    <td align="right">Reason :</td>
                                                    <td><input type="text" id="<%=leadDivId%>_manpowerReason" style="width:90%"></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <button align="center" onclick="closeManpowerModal('<%=leadDivId%>'); return false;" style="width:100%;">CANCEL</button>
                                                    </td>
                                                    <td>
                                                        <button align="center" onclick="submitManpower('<%=leadDivId%>');
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
                </div>
            </fieldset>
            <br>
            <table>
                <tr>
                    <td></td>
                    <td>
                        <input type="submit" value="Save">
                        <!--<input type="submit" value="Generate Quotation" formaction="new_lead_pdf.pdf" formtarget="_blank">-->
                        <!--<button onclick="return checkEmail();">Email Quotation</button>-->
                        <!--<button onclick="cancelLead(lead.getId());
                                return false;">Reject</button>-->
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
