<%@page import="com.vimbox.user.User"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.customer.Customer"%>
<%@page import="com.vimbox.database.TicketDAO"%>
<%@page import="com.vimbox.ticket.Ticket"%>
<%@page import="java.util.ArrayList"%>
<!DOCTYPE html> 
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title> VIMBOX </title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <script src="JS/ModalFunctions.js"></script>
        <script src="JS/TicketFunctions.js"></script>
        <script src="JS/CustomerFunctions.js"></script>
        <script src="JS/LeadFunctions.js"></script>
    </head>
    <body onload="initForum()">
        <%@include file="header.jsp"%>
        <!-- The Modal for View Tickets-->
        <div class="modal" id="viewTicketModal">
            <div class="modal-content">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('viewTicketModal')">×</span>
                    <center><h2>Ticket Details</h2></center>
                </div>
                <div class="modal-body">
                    <div id="viewTicketModalContent"></div>
                </div>
            </div>
        </div>
        <!-- The Modal for View Comment-->
        <div id="viewCommentsModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('viewCommentsModal')">×</span>
                    <center><h2>Comments History</h2></center>
                </div>
                <div class="modal-body">
                    <div id="commentsContent"></div> 
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
                        <h2>Ticket Forum</h2> <br/>
                        <div class="panel">
                            <div class="panel-body">
                                <div class="example-box-wrapper">
                                    <ul class="nav-responsive nav nav-tabs">
                                        <li class="active"><a href="#pendingTickets" data-toggle="tab">Pending Tickets</a></li>
                                        <li><a href="#resolvedTickets" data-toggle="tab">Resolved Tickets</a></li>
                                    </ul>
                                    <div class="tab-content">
                                        <div id="pendingTickets" class="tab-pane active">
                                            <div class="form-group">
                                                <div class="col-sm-4">
                                                    <div class="input-group bootstrap-touchspin">
                                                        <input type = "text" id="pKw" placeholder="Enter keyword or date (YYYY-MM-DD)" class = "form-control"  style="width: 400px;color:black;">
                                                        <span class="input-group-btn">
                                                            <button class="btn btn-default bootstrap-touchspin-up" type="button" onclick="searchPending($('#pKw').val())">Search Pending</button>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                            <br/><br/>
                                            <div id="pending"></div>
                                        </div>
                                        <div id="resolvedTickets" class="tab-pane">
                                            <div class="form-group">
                                                <div class="col-sm-4">
                                                    <div class="input-group bootstrap-touchspin"><span class="input-group-addon bootstrap-touchspin-prefix" style="display: none;"></span>
                                                        <input type = "text"  id="rKw" placeholder="Enter keyword or date (YYYY-MM-DD)" class = "form-control"  style="width: 400px;color:black;">
                                                        <span class="input-group-btn">
                                                            <button class="btn btn-default bootstrap-touchspin-up" type="button" onclick="searchResolved($('#rKw').val())">Search Resolved</button>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                            <br/><br/>
                                            <div id="resolved"></div>
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
</div>
</body>
</html>