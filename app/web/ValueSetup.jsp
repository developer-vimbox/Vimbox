<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.LeadPopulationDAO"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Value Setup</title>
    </head>
    <body onload="loadValueSetupTables()">
        <%@include file="header.jsp"%>
        <div id="page-content-wrapper">
            <div id="page-content" style="min-height: 545px;">
                <div class="container">
                    <div id="page-title">
                        <h2>Value Setup</h2> <br>
                        <div class="panel">
                            <div class="panel-body">
                                <div id="errorModal" class="modal">
                                    <div class="modal-content" style="width: 400px;">
                                        <div class="modal-header">
                                            <span class="close" onclick="closeModal('errorModal')">×</span>
                                            <center><h2><div id="error-status"></div></h2></center>
                                        </div>
                                        <div class="modal-body">
                                            <div id="error-content"></div>
                                        </div>
                                    </div>
                                </div>
                                <div id="delModal" class="modal">
                                    <div class="modal-content" style="width: 400px;">
                                        <div class="modal-header">
                                            <span class="close" onclick="closeModal('delModal')">×</span>
                                            <center><h2><div id="del-status"></div></h2></center>
                                        </div>
                                        <div class="modal-body">
                                            <div id="del-content"></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="example-box-wrapper">
                                    <ul class="nav-responsive nav nav-tabs">
                                        <li class="active"><a href="#moveTypeTab" data-toggle="tab">Move Type</a></li>
                                        <li><a href="#referrals" data-toggle="tab">Referrals</a></li>
                                        <li><a href="#services" data-toggle="tab">Services</a></li>
                                    </ul>
                                    <div class="tab-content">
                                        <div id="moveTypeTab" class="tab-pane active">
                                            <div id="moveType_table"></div>
                                            <hr>
                                            <h3 class="mrg10A">Add New Move Type</h3>
                                            <div class="form-horizontal">
                                                <div class="form-group">
                                                    <label class="col-sm-4 control-label">Move Type: </label>
                                                    <div class="col-sm-4">
                                                        <input type="text" class="form-control" id="moveType" required>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="col-sm-4 control-label"> </label>
                                                    <div class="col-sm-4 text-center">
                                                        <button onclick="addMoveType()" class="btn btn-primary">Add Move Type</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div id="referrals" class="tab-pane">
                                            <div id="refType_table"></div>
                                            <hr>
                                            <h3 class="mrg10A">Add New Referral Type</h3>
                                            <div class="form-horizontal">
                                                <div class="form-group">
                                                    <label class="col-sm-4 control-label">Referral Type: </label>
                                                    <div class="col-sm-4">
                                                        <input type="text" class="form-control" id="refType" required>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="col-sm-4 control-label"> </label>
                                                    <div class="col-sm-4 text-center">
                                                        <button onclick="addRefType()" class="btn btn-primary">Add Referral Type</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div id="services" class="tab-pane">
                                            <div id="svcType_table"></div>
                                            <hr>
                                            <h3 class="mrg10A">Add New Service Type</h3>
                                            <div class="form-horizontal">
                                                <div class="form-group">
                                                    <label class="col-sm-4 control-label">Primary: </label>
                                                    <div class="col-sm-4">
                                                        <input type="text" class="form-control" id="svcType_primary" required>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="col-sm-4 control-label">Secondary: </label>
                                                    <div class="col-sm-4">
                                                        <input type="text" class="form-control" id="svcType_secondary" required>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="col-sm-4 control-label">Formula: </label>
                                                    <div class="col-sm-4">
                                                        <input type="text" class="form-control" id="svcType_formula" required>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="col-sm-4 control-label">Description: </label>
                                                    <div class="col-sm-4">
                                                        <input type="text" class="form-control" id="svcType_description" required>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="col-sm-4 control-label"> </label>
                                                    <div class="col-sm-4 text-center">
                                                        <button onclick="addSvcType()" class="btn btn-primary">Add Service Type</button>
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