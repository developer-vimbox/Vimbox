<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.customer.Customer"%>
<%@page import="com.vimbox.database.LeadDAO"%>
<%@page import="com.vimbox.sales.Lead"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Leads</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.js"></script> 
        <script src="http://malsup.github.com/jquery.form.js"></script> 
        <script src="JS/ModalFunctions.js"></script>
        <script>
            $('#confirm_form').ajaxForm({
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
                            my_leads_setup($('#cfmuId').val());
                            document.getElementById("confirmLeadModal").style.display = "none";
                            modal.style.display = "none";
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

            $('#amount_form').ajaxForm({
                dataType: 'json',
                success: function (data) {
                    var modal = document.getElementById("lead_error_modal");
                    var status = document.getElementById("lead_error_status");
                    var message = document.getElementById("lead_error_message");
                    status.innerHTML = data.status;
                    message.innerHTML = data.message;
                    modal.style.display = "block";

                    if (data.status === "SUCCESS") {
                        $('#amountCollected').val('');
                        setTimeout(function () {
                            modal.style.display = "none";
                        }, 500);
                        $.getJSON("RetrieveLeadConfirmationDetails", {leadId: $('#amtlId').val()})
                                .done(function (data) {
                                    document.getElementById("ttlAmtLbl").innerHTML = Number(data.total);
                                    document.getElementById("dptLbl").innerHTML = Number(data.total) * (Number(data.deposit) / 100);
                                    document.getElementById("amtCltLbl").innerHTML = Number(data.collected);
                                })
                                .fail(function (error) {
                                    modal.innerHTML = "ERROR";
                                    status.innerHTML = error;
                                    message.style.display = "block";
                                });
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
        </script>
    </head>
    <%@include file="header.jsp"%>
    <body onload="my_leads_setup('<%=user.getNric()%>')">
        <!-- The Modal -->
        <div id="cancelLeadModal" class="modal">
            <!-- Modal content -->
            <div class="modal-content">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('cancelLeadModal')">×</span>
                    <center><h2>Lead Cancellation</h2></center>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="uId" value="<%=user.getNric()%>">
                    <div class="form-horizontal">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">Lead ID: </label>
                            <div class="col-sm-7">
                                <label id="leadIdLbl" class="form-control"></label><input type="hidden" id="lId" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">Rejection Reason: </label>
                            <div class="col-sm-7">
                                <textarea id="reason" class="form-control textarea-autosize" autofocus autocomplete="off" oninvalid="this.setCustomValidity('Please enter a comment')" oninput="setCustomValidity('')"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label"> </label>
                            <div class="col-sm-7 text-center">
                                <button class="btn btn-primary" onclick="confirmCancel()">Reject Lead</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="confirmLeadModal" class="modal">
            <!-- Modal content -->
            <div class="modal-content">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('confirmLeadModal')">×</span>
                    <center><h2>Lead Confirmation</h2></center>
                </div>
                <div class="modal-body">
                    <form action="ConfirmLeadController" id="confirm_form" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="cfmuId" id="cfmuId" value="<%=user.getNric()%>">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label class="col-sm-4 control-label">Deposit to be collected: </label>
                                <div class="col-sm-6">
                                    <div class="input-group">
                                        <span class="input-group-addon">S$</span>
                                        <label class="form-control" id="cfmMessage" disabled></label>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">Lead ID: </label>
                                <div class="col-sm-6">
                                    <label class="form-control" id="cfmleadIdLbl"></label><input type="hidden" name="cfmlId" id="cfmlId" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">Amount Collected: </label>
                                <div class="col-sm-6">
                                    <div class="input-group">
                                        <span class="input-group-addon">S$</span>
                                        <input class="form-control" type="number" min="0" step="0.01" name="amountCollected"/>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">Confirmation Email: </label>
                                <div class="col-sm-6">
                                    <input class="form-control" type="file" name="file"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label"> </label>
                                <div class="col-sm-6 text-center">
                                    <input class="btn btn-primary" type="submit" value="Confirm Lead"/>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <div id="amountModal" class="modal">
            <!-- Modal content -->
            <div class="modal-content">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('amountModal')">×</span>
                    <center><h2>Amount Details</h2></center>
                </div>
                <div class="modal-body">
                    <div class="form-horizontal">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">Total Amount: </label>
                            <div class="col-sm-6">
                                <div class="input-group">
                                    <span class="input-group-addon">S$</span>
                                    <label class="form-control" id="ttlAmtLbl" disabled></label>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-4 control-label">Deposit Required: </label>
                            <div class="col-sm-6">
                                <div class="input-group">
                                    <span class="input-group-addon">S$</span>
                                    <label class="form-control" id="dptLbl" disabled></label>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-4 control-label">Amount Collected: </label>
                            <div class="col-sm-6">
                                <div class="input-group">
                                    <span class="input-group-addon">S$</span>
                                    <label class="form-control" id="amtCltLbl" disabled></label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <div id="show_amt">
                        <form action="AddAmountController" id="amount_form" method="post">
                            <input type="hidden" name="amtlId" id="amtlId"/>
                            <div class="form-horizontal">
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">Collected: </label>
                                    <div class="col-sm-6">
                                        <div class="input-group">
                                            <span class="input-group-addon">S$</span>
                                            <input class="form-control" type="number" min="0" step="0.01" name="amountCollected" id="amountCollected"/>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label"> </label>
                                    <div class="col-sm-6 text-center">
                                        <input class="btn btn-primary" type="submit" value="Add payment"/>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <div id="commentModal" class="modal">
            <!-- Modal content -->
            <div class="modal-content" style="width: 450px;">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('commentModal')">×</span>
                    <center><h2>Follow Up Comment</h2></center>
                </div>
                <div class="modal-body">
                    <div id="comment-content"></div>
                </div>
            </div>
        </div>
        <div id="lead_error_modal" class="modal">
            <div class="modal-content" style="width: 400px;">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('lead_error_modal')">×</span>
                    <center><h2><div id="lead_error_status"></div></h2></center>
                </div>
                <div class="modal-body">
                    <div id="lead_error_message"></div>
                </div>
            </div>
        </div>
        <!-- The Modal -->
        <div id="viewLeadModal" class="modal">
            <div class="modal-content" style="width: 80%;">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('viewLeadModal')">×</span>
                    <center><h2>Lead Details</h2></center>
                </div>
                <div class="modal-body">
                    <div id="leadContent"></div>
                </div>
            </div>
        </div>

        <!-- The Modal -->
        <div id="viewCommentsModal" class="modal">
            <!-- Modal content -->
            <div class="modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('viewCommentsModal')">×</span>
                    <div id="commentsContent"></div> 
                </div>
            </div>
        </div>
        <div id="viewFollowUpModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('viewFollowUpModal')">×</span>
                    <center><h2>Follow Up History</h2></center>
                </div>
                <div class="modal-body">
                    <div id="followUpContent"></div> 
                </div>
            </div>
        </div>
        <div id="page-content-wrapper">
            <div id="page-content" style="min-height: 545px;">
                <div class="container">
                    <div id="page-title">
                        <h2>My Leads</h2> <br>
                    </div>
                    <div class="panel">
                        <div class="panel-body">
                            <div class="form-horizontal">
                                <div class="form-group">
                                    <div class="col-sm-4">
                                        <div class="input-group bootstrap-touchspin"><span class="input-group-addon bootstrap-touchspin-prefix" style="display: none;"></span>
                                            <input type="text" id="lead_search" placeholder="Enter search details" class="form-control" style="width: 400px;color:black;">
                                            <span class="input-group-btn">
                                                <button class="btn btn-default  bootstrap-touchspin-up" type="button" onclick="load_leads($('#lead_search').val(), '<%=user.getNric()%>', $('.tab-pane.active').attr('id'))">Search</button>
                                                <button class="btn btn-default  bootstrap-touchspin-up" type="button" onclick="location.href = 'CreateLead.jsp';">Add New</button>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="example-box-wrapper">
                                <ul class="nav-responsive nav nav-tabs">
                                    <li class="active"><a href="#Pending" data-toggle="tab">Pending</a></li>
                                    <li><a href="#Confirmed" data-toggle="tab">Confirmed</a></li>
                                    <li><a href="#Rejected" data-toggle="tab">Rejected</a></li>
                                </ul>
                                <div class="tab-content">
                                    <div id="Pending" class="tab-pane active"></div>
                                    <div id="Confirmed" class="tab-pane"></div>
                                    <div id="Rejected" class="tab-pane"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
