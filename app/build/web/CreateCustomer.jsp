<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Customer</title>
    </head>
    <body>
        <div id="customer_error_modal" class="modal">
            <div class="modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('customer_error_modal')">×</span>
                    <div id="customer_error_status"></div>
                    <hr>
                    <div id="customer_error_message"></div>
                </div>
            </div>
        </div>
        <div class="form-horizontal" >
            <div class="form-group">
                <div class="form-group">
                    <label class="col-sm-3 control-label">Salutation : </label>
                    <div class="col-sm-6">

                        <select id="create_salutation" class="form-control">
                            <option value="Mr">Mr</option>
                            <option value="Ms">Ms</option>
                            <option value="Mrs">Mrs</option>
                            <option value="Mdm">Mdm</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label">First Name : </label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" id="create_first_name">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label">Last Name : </label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" id="create_last_name">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label">Contact : </label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" id="create_contact">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label">Email : </label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" id="create_email">
                    </div>
                </div>
                <div class="form-group text-center">
                    <button class="btn btn-primary" onclick="createCustomer();
                            return false;">Add</button>
                </div>
            </div>
        </div>
    </body>
</html>
