<%@page import="com.vimbox.util.Converter"%>
<%@page import="java.util.Random"%>
<%@page import="org.joda.time.DateTime"%>
<%@include file="PopulateLeadFields.jsp"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create new lead</title>
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
        <%@include file="header.jsp"%>
        <script src="http://malsup.github.com/jquery.form.js"></script> 
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAlr3mj-08qPnSvod0WtYbmE0NrulFq0RE&libraries=places"></script>
        <script src="JS/jquery.hotkeys.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <script src="JS/LeadFunctions.js"></script>
        <script src="JS/AddressSearch.js"></script>
        <script src="JS/CustomerFunctions.js"></script>
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
        <div id="customer_modal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('customer_modal')">×</span>
                    <center><h2>Select Customer</h2></center>
                </div>
                <div class="modal-body">
                    <br>
                    <div id="customer_content"></div>
                </div>
            </div>
        </div>
        <div id="add_customer_modal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('add_customer_modal')">×</span>
                    <center><h2>Add New Customer</h2></center>
                </div>
                <div class="modal-body">
                    <br>
                    <div id="add_customer_content"></div>
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
        <%            int leadId = new Random().nextInt(900000000) + 100000000;
        %>
        <div id="page-content-wrapper">

            <div id="page-content">
                <div class="container">
                    <div id="page-title">
                        <h2>Create New Lead</h2> <br>
                    </div>
                    <div class="panel">
                        <div class="panel-body">


                            <form class='form-horizontal' method="POST" action="CreateLeadController" autocomplete="on" id="create_lead_form">
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Lead ID: </label>
                                    <div class="col-sm-4" style="padding-top: 7px;">
                                        <%=leadId%><input type="hidden" id="leadId" name="leadId" value="<%=leadId%>">
                                        <br><br>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Status: </label>
                                    <div class="col-sm-4" style="padding-top: 7px;">
                                        Pending<input type="hidden" name="status" value="Pending">
                                        <br><br>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Source: </label>
                                    <div class="col-sm-4" style="padding-top: 7px;">
                                        <%
                                            for (int i = 0; i < sources.size(); i++) {
                                                String source = sources.get(i);
                                                if (i == 0) {
                                                    out.println("<input class='radio-inline' type='radio' name='source' value='" + source + "' checked>" + source);
                                                } else {
                                                    out.println("<input class='radio-inline' type='radio' name='source' value='" + source + "'>" + source);
                                                }
                                            }

                                        %>
                                    </div>
                                </div>  
                                <fieldset>
                                    <legend>Customer Information</legend>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"> </label>
                                        <div class="col-sm-4" style="padding-top: 7px;">
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
                                    <div id="customer_information_table" style="display:none">
                                        <input type="hidden" id="customer_id" name="customer_id">
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label">Salutation: </label>
                                            <div class="col-sm-4" style="padding-top: 7px;">
                                                <label id="customer_salutation"></label>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label">First Name: </label>
                                            <div class="col-sm-4" style="padding-top: 7px;">
                                                <label id="customer_first_name"></label>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label">Last Name: </label>
                                            <div class="col-sm-4" style="padding-top: 7px;">
                                                <label id="customer_last_name"></label>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label">Contact: </label>
                                            <div class="col-sm-4" style="padding-top: 7px;">
                                                <label id="customer_contact"></label>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label">Email: </label>
                                            <div class="col-sm-4" style="padding-top: 7px;">
                                                <label id="customer_email"></label>
                                            </div>
                                        </div>
                                    </div>        
                                </fieldset>
                                <br>
                                <fieldset>
                                    <legend>Moving Information</legend>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Move Type: </label>
                                        <div class="col-sm-6" style="padding-top: 7px;">
                                            <%                                                for (String type : moveTypes) {
                                                    out.println("<input class='checkbox-inline' type='checkbox' name='tom' value='" + type + "'>" + type);
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
                                                        <input class="btn btn-round btn-primary" type="button" value="+" onClick="addDom('dynamicDom');">
                                                    </span>
                                                    <div id="1">
                                                        <input class='form-control' type='date' name='dom'/>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>
                                    </div>
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
                                                <input class="form-control" type="date" id="sitesurvey_date">
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
                                        <div id="survey"></div>
                                    </fieldset>
                                    <br>
                                    <fieldset>
                                        <b><u>Sales Details</u></b><hr>
                                        <ul class="nav-responsive nav nav-tabs" id="sales_list">
                                        </ul>
                                        <div id="sales_container"></div>
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
                                                        <option value="SELECT">--Select--</option>
                                                        <%                                
                                                            for (String enquiry : enquiries) {
                                                                out.println("<option value='" + enquiry + "'>" + enquiry + "</option>");
                                                            }
                                                        %>
                                                        <option value="Others">Others</option>
                                                    </select>
                                                </div>
                                                <div class="col-sm-6">
                                                    <div id="enquiryOthers" style="display:inline-block"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <br>
                                    <div class="form-group ">
                                        <label class="col-sm-3 control-label">Referred by: </label>
                                        <div class="col-sm-4">
                                            <div class="form-group row">
                                                <div class="col-sm-6">
                                                    <select class="form-control" name="referral" id="referral" onchange="showfield(this.options[this.selectedIndex].value, this)">
                                                        <%                                
                                                            for (String referral : referrals) {
                                                                out.println("<option value='" + referral + "'>" + referral + "</option>");
                                                            }
                                                        %>
                                                        <option value="Others">Others</option>
                                                    </select>
                                                </div>
                                                <div class="col-sm-6">
                                                    <div id="referralOthers" style="display:inline-block"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </fieldset>
                                <!--                                <fieldset>
                                                                    <legend>Lead Information</legend>
                                                                    <div class="form-group">
                                                                        <label class="col-sm-3 control-label">Lead Type: </label>
                                                                        <div class="col-sm-6">
                                                                            <div id="leadInfo">
                                <%
                                    //for (String type : types) {
                                    //  out.println("<input class='checkbox-inline' type='checkbox' name='leadType' value='" + type + "'>" + type);
                                    // }
                                %>
                                                            </div>
                                
                                                        </div>
                                                    </div>
                                
                                                    <div id="Enquiry" style="display:none">
                                                        <br>
                                                        <fieldset>
                                                            <b><u>Enquiry Details</u></b><br><br>
                                                            <table>
                                                                <col width="100">
                                                                <tr>
                                                                    <td align="right"><b>Remarks :</b></td>
                                                                    <td>
                                                                        <textarea class='form-control' name="enquiry" cols="75" rows="6" autocomplete="off"></textarea>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </fieldset>
                                                    </div>
                                
                                                    <div id="Sales" style="display:none">
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
                                                            <div id="survey"></div>
                                                        </fieldset>
                                                        <br>
                                                        <fieldset>
                                                            <b><u>Sales Details</u></b><hr>
                                                            <ul class="tab" id="sales_list">
                                                            </ul>
                                                            <div id="sales_container"></div>
                                                        </fieldset>
                                                    </div>
                                                </fieldset>-->
                                <br>
                                <table>
                                    <tr>
                                        <td></td>
                                        <td>
                                            <div class="bg-default text-center">
                                                <button type="submit" data-loading-text="Loading..." class="btn loading-button btn-primary">Save</button></div>
                                            <!--<input type="submit" value="Generate Quotation" formaction="new_lead_pdf.pdf" formtarget="_blank">-->
                                            <!--<button onclick="return checkEmail();">Email Quotation</button>-->
                                        </td>
                                    </tr>
                                </table>
                            </form>
                        </div>
                    </div>
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
                            window.location.href = "MyLeads.jsp";
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
                while (tagname !== 'DIV') {
                    activeElement = activeElement.parentNode;
                    tagname = activeElement.tagName;
                }

                switch (tableClassName) {
                    case "table customerBoxTable":
                        addCustomerBox(activeElement.id);
                        break;
                    case "table customerItemTable":
                        addItem(activeElement.id);
                        break;
                    case "table customerSpecialItemTable":
                        addSpecialItem(activeElement.id);
                        break;
                    case "table vimboxBoxTable":
                        addVimboxBox(activeElement.id);
                        break;
                    case "table vimboxMaterialTable":
                        addVimboxMaterial(activeElement.id);
                        break;
                    case "table customerCommentTable":
                        addCustomerComment(activeElement.id);
                        break;
                    case "table customerRemarkTable":
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