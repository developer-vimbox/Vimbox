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
                        <ul class="tab" id="sales_list">
                        </ul>
                        <div id="sales_container"></div>
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
                
                var activeElement = document.activeElement.parentNode;
                var tagname = activeElement.tagName;
                while(tagname !== 'DIV'){
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
                    while(tagname !== 'DIV' || id == null || id === ''){
                        activeElement = activeElement.parentNode;
                        tagname = activeElement.tagName;
                        id = activeElement.id;
                    }
                    update_service(element, activeElement.id);
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
    </body>
</html>