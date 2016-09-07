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
        <script src="JS/ModalFunctions.js"></script>
        <script src="JS/LeadFunctions.js"></script>
    </head>
    <%@include file="header.jsp"%>
    <body onload="my_leads_setup('<%=user.getNric()%>')">
        <!-- The Modal -->
        <div id="cancelLeadModal" class="modal">
            <!-- Modal content -->
            <div class="modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('cancelLeadModal')">×</span>
                    <h3>Lead Cancellation</h3>
                    <input type="hidden" id="uId" value="<%=user.getNric()%>">
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
            <div class="error-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('lead_error_modal')">×</span>
                    <div id="lead_error_status"></div>
                    <hr>
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
