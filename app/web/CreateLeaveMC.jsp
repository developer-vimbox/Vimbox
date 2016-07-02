<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.UserDAO"%>
<%@include file="ValidateLogin.jsp"%>
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
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
    </head>
    <body>
        <h1>Add New Leave / MC</h1>
        <form id="leave_form" action="CreateLeaveController" method="post" enctype="multipart/form-data">
            <fieldset>
                <legend>Employee Information</legend>
                <table>
                    <tr>
                        <td align="right"><b>Employee :</b></td>
                        <td>
                            <select name="nric" id="leaveEmployee">
                                <option value="">--Select--</option>
                                <%                                ArrayList<User> users = UserDAO.getFullTimeUsers();
                                    for (User employee : users) {
                                        out.println("<option value='" + employee.getNric() + "'>" + employee + "</option>");
                                    }
                                %>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td align="right"><b>Paid Leaves Left :</b></td>
                        <td><label id="leave_employee_leave"></label></td>
                    </tr>
                    <tr>
                        <td align="right"><b>Paid MC Left :</b></td>
                        <td><label id="leave_employee_mc"></label></td>
                    </tr>
                </table>
            </fieldset>
            <br>
            <fieldset>
                <legend>Leave / MC Information</legend>
                <table>
                    <tr>
                        <td align="right"><b>Leave Type :</b></td>
                        <td>
                            <select name="leaveType">
                                <option value="Paid">Paid</option>
                                <option value="Unpaid">Unpaid</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td align="right"><b>Leave Name :</b></b></td>
                        <td>
                            <select name="leaveName" id="leaveName">
                                <option value="Leave">Leave</option>
                                <option value="Timeoff">Time-Off</option>
                                <option value="MC">MC</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td align="right"><b>Image Proof :</td>
                        <td><input type="file" name="file" id="file" disabled></td>
                    </tr>
                    <tr>
                        <td align="right"><b>Start :</b></td>
                        <td>
                            <input type="date" name="start_date" id="start_date"> &nbsp;
                            <select name="start_hour" id="start_hour">
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
                            </select> :
                            <select name="start_minute" id="start_minute">
                                <%
                                    for (int i = 0; i < 59; i++) {
                                        String value = "";
                                        if (i < 10) {
                                            value = "0" + i;
                                        } else {
                                            value = i + "";
                                        }

                                        if(i == 30){
                                            out.println("<option value='" + value + "' selected>" + value + "</option>");
                                        }else{
                                            out.println("<option value='" + value + "'>" + value + "</option>");
                                        }
                                    }
                                %>
                            </select> &nbsp;
                            <b>End :</b> &nbsp;
                            <input type="date" name="end_date" id="end_date"> &nbsp;
                            <select name="end_hour" id="end_hour">
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
                            </select> :
                            <select name="end_minute" id="end_minute">
                                <%
                                    for (int i = 0; i < 59; i++) {
                                        String value = "";
                                        if (i < 10) {
                                            value = "0" + i;
                                        } else {
                                            value = i + "";
                                        }
                                        
                                        if(i == 30){
                                            out.println("<option value='" + value + "' selected>" + value + "</option>");
                                        }else{
                                            out.println("<option value='" + value + "'>" + value + "</option>");
                                        }
                                    }
                                %>
                            </select> 
                        </td>
                    </tr>
                </table>
            </fieldset>
            <br>
            <input type="submit" value="Add Leave / MC" />
        </form>

        <div id="leave_error_modal" class="modal">
            <!-- Modal content -->
            <div class="message-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('leave_error_modal')">×</span>
                    <div id="leave_error_status"></div>
                    <hr>
                    <div id="leave_error_message"></div>
                </div>
            </div>
        </div>
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
                            location.reload()
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
    </body>
</html>
