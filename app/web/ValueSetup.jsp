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
        <script src="http://malsup.github.com/jquery.form.js"></script> 
        <div id="page-content-wrapper">
            <div id="page-content" style="min-height: 545px;">
                <div class="container">
                    <div id="page-title">
                        <h2>Value Setup</h2> <br>
                        <div class="panel">
                            <div class="panel-body">
                                <div id="formulaModal" class="modal">
                                    <div class="modal-content" style="width: 400px;">
                                        <div class="modal-header">
                                            <span class="close" onclick="closeModal('formulaModal')">×</span>
                                            <center><h2>FORMULA ENTRY</h2></center>
                                        </div>
                                        <div class="modal-body">
                                            <div id="formula-content"></div>
                                        </div>
                                    </div>
                                </div>

                                <div id="itemModal" class="modal">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <span class="close" onclick="closeModal('itemModal')">×</span>
                                            <center><h2>Edit Item</h2></center>
                                        </div>
                                        <div class="modal-body">
                                            <div class="form-horizontal">
                                                <form class='form-horizontal' method="POST" action="EditItemController" id="edit_item_form" enctype="multipart/form-data">
                                                    <input type="hidden" id="itemValues" name="itemValues">
                                                    <div class="form-group">
                                                        <label class="col-sm-4 control-label">Name: </label>
                                                        <div class="col-sm-4">
                                                            <input type="text" class="form-control" id="itemName" name="itemName" required>
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <label class="col-sm-4 control-label">Description: </label>
                                                        <div class="col-sm-4">
                                                            <input type="text" class="form-control" id="itemDescription" name="itemDescription">
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <label class="col-sm-4 control-label">Dimensions: </label>
                                                        <div class="col-sm-4">
                                                            <input type="text" class="form-control" id="itemDimensions" name="itemDimensions">
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <label class="col-sm-4 control-label">Units: </label>
                                                        <div class="col-sm-4">
                                                            <input type="number" min="0" step="0.01" class="form-control" id="itemUnits" name="itemUnits" required>
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <label class="col-sm-4 control-label">Image: </label>
                                                        <div class="col-sm-4">
                                                            <label class="col-sm-7" id="imageLbl"></label>
                                                            <input type="file" class="form-control" name="itemImg">
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <label class="col-sm-4 control-label"></label>
                                                        <div class="col-sm-4">
                                                            <button type="submit" data-loading-text="Loading..." class="btn loading-button btn-primary">Edit</button>
                                                        </div>
                                                    </div>
                                                </form>
                                            </div>
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

                                <div class="example-box-wrapper">
                                    <ul class="nav-responsive nav nav-tabs">
                                        <li class="active"><a href="#moveTypeTab" data-toggle="tab">Move Type</a></li>
                                        <li><a href="#referrals" data-toggle="tab">Referrals</a></li>
                                        <li><a href="#services" data-toggle="tab">Services</a></li>
                                        <li><a href="#adminItemsTab" data-toggle="tab">Items</a></li>
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
                                                    <label class="col-sm-4 control-label">Abbreviation: </label>
                                                    <div class="col-sm-4">
                                                        <input type="text" class="form-control" id="abb" required>
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
                                                        <label class="col-sm-4" id="svcType_formula" style="padding-top: 7px;"></label>
                                                        <button onclick="serviceFormula()" class="btn btn-default" id="formula-btn">Formula</button>
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

                                        <div id="adminItemsTab" class="tab-pane">
                                            <div class="example-box-wrapper">
                                                <ul class="nav-responsive nav nav-tabs">
                                                    <li class="active"><a href="#customer" data-toggle="tab">Customer</a></li>
                                                    <li><a href="#vimbox" data-toggle="tab">Vimbox</a></li>
                                                </ul>
                                                <div class="tab-content">
                                                    <div id="customer" class="tab-pane active">
                                                        <div id="customer_table"></div>
                                                    </div>
                                                    <div id="vimbox" class="tab-pane">
                                                        <div id="vimbox_table"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            <hr>
                                            <h3 class="mrg10A">Add Item</h3>
                                            <div class="form-horizontal">
                                                <form class='form-horizontal' method="POST" action="CreateItemController" id="create_item_form" enctype="multipart/form-data">
                                                    <div class="form-group">
                                                        <label class="col-sm-4 control-label">Type: </label>
                                                        <div class="col-sm-4">
                                                            <select class="form-control" id="entry_itemType" name="entry_itemType" onchange="changeItemType();
                                                                    return false;">
                                                                <option value="normalItem">Normal Item</option>
                                                                <option value="specialItem">Special Item</option>
                                                                <option value="material">Material</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <label class="col-sm-4 control-label">Name: </label>
                                                        <div class="col-sm-4">
                                                            <input type="text" class="form-control" id="entry_itemName" name="entry_itemName" required>
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <label class="col-sm-4 control-label">Description: </label>
                                                        <div class="col-sm-4">
                                                            <input type="text" class="form-control" name="entry_itemDescription" id="entry_itemDescription">
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <label class="col-sm-4 control-label">Dimensions: </label>
                                                        <div class="col-sm-4">
                                                            <input type="text" class="form-control" name="entry_itemDimensions" id="entry_itemDimensions">
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <label class="col-sm-4 control-label">Units: </label>
                                                        <div class="col-sm-4">
                                                            <input type="number" min="0" step="0.01" class="form-control" name="entry_itemUnits" id="entry_itemUnits">
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <label class="col-sm-4 control-label">Image: </label>
                                                        <div class="col-sm-4">
                                                            <input type="file" class="form-control" name="entry_itemImg" id="entry_itemImg">
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <label class="col-sm-4 control-label"> </label>
                                                        <div class="col-sm-4 text-center">
                                                            <button type="submit" data-loading-text="Loading..." class="btn loading-button btn-primary">Add</button>
                                                        </div>
                                                    </div>
                                                </form>
                                            </div>
                                            <script>
                                                $('#create_item_form').ajaxForm({
                                                    dataType: 'json',
                                                    success: function (data) {
                                                        var errmodal = document.getElementById("errorModal");
                                                        var status = document.getElementById("error-status");
                                                        var message = document.getElementById("error-content");
                                                        status.innerHTML = data.status;
                                                        message.innerHTML = data.message;
                                                        errmodal.style.display = "block";

                                                        if (data.status === "SUCCESS") {
                                                            setTimeout(function () {
                                                                errmodal.style.display = "none";
                                                            }, 500);
                                                            viewAdmItems();
                                                            $('#entry_itemType').val('normalItem');
                                                            $('#entry_itemName').val('');
                                                            $('#entry_itemDescription').val('');
                                                            $('#entry_itemDimensions').val('');
                                                            $('#entry_itemUnits').val('');
                                                            $('#entry_itemImg').val('');
                                                        }
                                                    },
                                                    error: function (data) {
                                                        var errmodal = document.getElementById("errorModal");
                                                        var status = document.getElementById("error-status");
                                                        var message = document.getElementById("error-content");
                                                        status.innerHTML = "ERROR";
                                                        message.innerHTML = data;
                                                        errmodal.style.display = "block";
                                                    }
                                                });
                                            </script>
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