<%@page import="com.vimbox.database.UserDAO"%>
<%@page import="java.util.ArrayList"%>
<!DOCTYPE html> 
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title> VIMBOX </title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/CustomerFunctions.js"></script>
        <script src="JS/TicketFunctions.js"></script>
        <script src="JS/LeadFunctions.js"></script>
        <script src="JS/ModalFunctions.js"></script>
    </head>
    <body>
        <%@include file="header.jsp"%>
        <%            ArrayList<User> users = UserDAO.getFullTimeUsers();
        %>
        <div id="customer_modal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('customer_modal')">×</span>
                    <center><h2>Select Customer</h2></center>
                </div>
                <div class="modal-body">
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
                    <div id="add_customer_content"></div>
                </div>
            </div>
        </div>
        <div id="ticket_error_modal" class="modal">
            <div class="error-modal-content">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('ticket_error_modal')">×</span>
                    <center><h2><div id="ticket_error_status"></div></h2></center>
                </div>
                <div class="modal-body">
                    <div id="ticket_error_message"></div>
                </div>
            </div>
        </div>
        <div id="page-content-wrapper">
            <div id="page-content">
                <div class="container">

                    <!-- Tocify -->

                    <!--<link rel="stylesheet" type="text/css" href="assets/widgets/tocify/tocify.css">-->
                    <script type="text/javascript" src="assets/widgets/sticky/sticky.js"></script>
                    <script type="text/javascript" src="assets/widgets/tocify/tocify.js"></script>

                    <script type="text/javascript">
                        $(function () {
                            var toc = $("#tocify-menu").tocify({context: ".toc-tocify", showEffect: "fadeIn", extendPage: false, selectors: "h2, h3, h4"});
                        });
                        jQuery(document).ready(function ($) {

                            /* Sticky bars */

                            $(function () {
                                "use strict";

                                $('.sticky-nav').hcSticky({
                                    top: 50,
                                    innerTop: 50,
                                    stickTo: 'document'
                                });

                            });

                        });
                    </script>

                    <div id="page-title">
                        <h2>Create Ticket</h2> <br>
                        <div class="panel">
                            <div class="panel-body">
                                <div class="form-horizontal">
                                    <div class="form-group">
                                        <div class="col-sm-6">
                                            <h3 class="mrg10A">Select Customer </h3>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="col-sm-4">
                                            <div class="input-group bootstrap-touchspin"><span class="input-group-addon bootstrap-touchspin-prefix" style="display: none;"></span>
                                                <input type="text" id="customer_search" placeholder="Enter customer name" class="form-control" style="width: 400px;color:black;">
                                                <span class="input-group-btn">
                                                    <button class="btn btn-default  bootstrap-touchspin-up" type="button" onclick="customerSearch('ticket')">Search</button>
                                                    <button class="btn btn-default  bootstrap-touchspin-up" type="button"  onclick="addNewCustomer()">Add New</button>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <br>
                                <div class="form-horizontal">
                                    <hr>
                                    <div class="form-group">
                                        <div class="col-sm-6">
                                            <h3 class="mrg10A">Ticket Information </h3>
                                        </div>
                                    </div>
                                    <div id="customer_information_table" style="display:none">
                                        <input type="hidden" id="customer_id" name="customer_id">
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label">Customer's Name: </label>
                                            <div class="col-sm-5">
                                                <label class="form-control" id="customer_name"></label>
                                            </div>
                                            <label class="col-sm-2 control-label"></label>
                                            <div class="col-sm-3"  style="padding-top: 7px;" id="cust_btn_input">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label">Customer's Contact: </label>
                                            <div class="col-sm-5">
                                                <label class="form-control" id="customer_contact"></label>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-sm-3 control-label">Customer's Email: </label>
                                            <div class="col-sm-5">
                                                <label class="form-control" id="customer_email"></label>    
                                            </div>
                                        </div>                             
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Status: </label>
                                        <div class="col-sm-5">
                                            <input type="text" class="form-control" id="staus" disabled="" placeholder="Pending">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Assigned To: </label>
                                        <div class="col-sm-5">
                                            <div id="dynamicInput">
                                                <div class="input-group">
                                                    <span class="input-group-btn">
                                                        <input class="btn btn-round btn-primary" type="button" value="+" onClick="addInput('dynamicInput');">
                                                    </span>
                                                    <select name="assigned" class="form-control">
                                                        <%
                                                            for (User assignee : users) {
                                                                out.println("<option value='" + assignee.getNric() + "'>" + assignee + "</option>");
                                                            }
                                                        %>
                                                    </select>
                                                </div>
                                            </div>
                                            <div id="additionalAssigned" style="margin-top: 15px">
                                                <div class="input-group">
                                                    <span class="input-group-btn">
                                                        <input class="btn btn-round btn-warning" type='button' value='x' onClick='removeAdditional(this);'>
                                                    </span>
                                                    <select name="assigned" class="form-control">
                                                        <%
                                                            for (User assignee : users) {
                                                                out.println("<option value='" + assignee.getNric() + "'>" + assignee + "</option>");
                                                            }
                                                        %>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Subject: </label>
                                        <div class="col-sm-5">
                                            <input type="text" class="form-control" id="subject"  size="84" name="">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Description: </label>
                                        <div class="col-sm-5">
                                            <textarea class="form-control" id="description" cols="75" rows="6"></textarea>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"></label>
                                        <div class="col-sm-5 text-center">
                                            <button type="submit" data-loading-text="Loading..." class="btn loading-button btn-primary" onclick="submitTicket()">Submit Ticket</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>