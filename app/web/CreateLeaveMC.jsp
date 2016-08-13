<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.UserDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Leave / MC</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.js"></script> 
        <script src="http://malsup.github.com/jquery.form.js"></script> 
        <script src="JS/ModalFunctions.js"></script>
        <script>
            $('#leave_form').ajaxForm({
                dataType: 'json',
                success: function (data) {
                    var modal = document.getElementById("leave_error_modal");
                    var status = document.getElementById("leave_error_status");
                    var message = document.getElementById("leave_error_message");
                    status.innerHTML = data.status;
                    message.innerHTML = data.message;
                    modal.style.display = "block";

                    if (data.status === "SUCCESS") {
                        setTimeout(function () {
                            window.location.href = "LeaveMCs.jsp";
                        }, 500);
                    }
                },
                error: function (data) {
                    var modal = document.getElementById("leave_error_modal");
                    var status = document.getElementById("leave_error_status");
                    var message = document.getElementById("leave_error_message");
                    status.innerHTML = "ERROR";
                    message.innerHTML = data;
                    modal.style.display = "block";
                }
            });
        </script>
        <script src="JS/EmployeeFunctions.js"></script>
    </head>
    <body>
        <%@include file="header.jsp"%>
        <div id="leave_error_modal" class="modal">
            <div class="modal-content" style="width: 400px;">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('leave_error_modal')">×</span>
                    <center><h2><div id="leave_error_status"></div></h2></center>
                </div>
                <div class="modal-body">
                    <div id="leave_error_message"></div>
                </div>
            </div>
        </div>

        <div id="page-content-wrapper">
            <div id="page-content" style="min-height: 7630px;">
                <div class="container">
                    <div id="page-title">
                        <h2>Add New Leave / MC</h2>
                    </div>
                    <div class="panel">
                        <div class="panel-body">
                            <form class="form-horizontal" id="leave_form" action="CreateLeaveController" method="post" enctype="multipart/form-data">
                                <div class="form-group">
                                    <div class="col-sm-6">
                                        <h3 class="mrg10A">Employee Information </h3>
                                    </div>
                                </div>
                                 <div class="form-group">
                                    <label class="col-sm-3 control-label">Employee :</label>
                                    <div class="col-sm-3">
                                        <select name="nric" id="leaveEmployee" class="form-control">
                                             <option value="">--Select--</option>
                                                <%                                ArrayList<User> users = UserDAO.getFullTimeUsers();
                                                    for (User employee : users) {
                                                        out.println("<option value='" + employee.getNric() + "'>" + employee + "</option>");
                                                    }
                                                %>
                                        </select>
                                    </div>
                                </div>
                                        <div class="form-group">
                                    <label class="col-sm-3 control-label">Paid Leaves Left :</label>
                                    <div class="col-sm-3">
                                       <label class="control-label" id="leave_employee_leave"></label>
                                    </div>
                                </div>
                                         <div class="form-group">
                                    <label class="col-sm-3 control-label">Paid MC Left :</label>
                                    <div class="col-sm-3">
                                       <label class="control-label" id="leave_employee_mc"></label>
                                    </div>
                                </div>
                                        <hr>
                               <div class="form-group">
                                    <div class="col-sm-6">
                                        <h3 class="mrg10A">Leave/MC Information </h3>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Leave Type :</label>
                                    <div class="col-sm-3">
                                        <select name="leaveType" class="form-control">
                                            <option value="Paid">Paid</option>
                                            <option value="Unpaid">Unpaid</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Leave Name :</label>
                                    <div class="col-sm-3">
                                        <select name="leaveName" id="leaveName" class="form-control">
                                            <option value="Leave">Leave</option>
                                            <option value="Timeoff">Time-Off</option>
                                            <option value="MC">MC</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Image Proof :</label>
                                    <div class="col-sm-3">
                                        <input type="file" class="form-control" name="file" id="file" disabled>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label class="col-sm-3 control-label">Start :</label>
                                    <div class="col-sm-3">

                                        <input class="form-control" type="date" name="start_date" id="start_date"> &nbsp;
                                    </div>
                                    <div class="col-xs-2">
                                        <select name="start_hour" id="start_hour" class="form-control">
                                            <%
                                                for (int i = 8; i <= 18; i++) {
                                                    String value = "";
                                                    if (i < 10) {
                                                        value = "0" + i;
                                                    } else {
                                                        value = i + "";
                                                    }

                                                    out.println("<option value='" + value + "'>" + value + "</option>");
                                                }
                                            %>

                                        </select>
                                    </div>
                                    <div class="col-xs-1 control-label" style="width:0;">
                                        <label>:</label>
                                    </div>
                                    <div class="col-xs-2">
                                        <select name="start_minute" id="start_minute" class="form-control">
                                            <%
                                                for (int i = 0; i < 59; i++) {
                                                    String value = "";
                                                    if (i < 10) {
                                                        value = "0" + i;
                                                    } else {
                                                        value = i + "";
                                                    }

                                                    if (i == 30) {
                                                        out.println("<option value='" + value + "' selected>" + value + "</option>");
                                                    } else {
                                                        out.println("<option value='" + value + "'>" + value + "</option>");
                                                    }
                                                }
                                            %>
                                        </select> 
                                    </div>
                                </div>


                                <div class="form-group row">
                                    <label class="col-sm-3 control-label">End :</label>
                                    <div class="col-sm-3">
                                        <input class="form-control" type="date" name="end_date" id="end_date"> &nbsp;
                                    </div>
                                    <div class="col-xs-2">
                                        <select name="end_hour" id="end_hour" class="form-control">
                                            <%
                                                for (int i = 8; i <= 18; i++) {
                                                    String value = "";
                                                    if (i < 10) {
                                                        value = "0" + i;
                                                    } else {
                                                        value = i + "";
                                                    }

                                                    out.println("<option value='" + value + "'>" + value + "</option>");
                                                }
                                            %>
                                        </select>
                                    </div>
                                    <div class="col-xs-1 control-label" style="width:0;">
                                        <label>:</label>
                                    </div>
                                    <div class="col-xs-2">
                                        <select name="end_minute" id="end_minute" class="form-control">
                                            <%
                                                for (int i = 0; i < 59; i++) {
                                                    String value = "";
                                                    if (i < 10) {
                                                        value = "0" + i;
                                                    } else {
                                                        value = i + "";
                                                    }

                                                    if (i == 30) {
                                                        out.println("<option value='" + value + "' selected>" + value + "</option>");
                                                    } else {
                                                        out.println("<option value='" + value + "'>" + value + "</option>");
                                                    }
                                                }
                                            %>
                                        </select> 
                                    </div>
                                </div>
                                <div class="bg-default text-center">
                                    <button type="submit" data-loading-text="Loading..." class="btn loading-button btn-primary" >Add Leave/MC</button>
                                </div>
                            </form>


                        </div>

                    </div>
                </div>
            </div>
        </div>



    </body>
</html>
