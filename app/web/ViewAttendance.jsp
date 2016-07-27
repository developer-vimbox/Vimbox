<%@page import="com.vimbox.database.UserAttendanceDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Attendances</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/EmployeeFunctions.js"></script>
        <script src="JS/ModalFunctions.js"></script>
    </head>
    <body onload="attendance_setup()">
        <%@include file="header.jsp"%>
        <div id="view_attendance_modal" class="modal" style="display:none;">
            <!-- Modal content -->
            <div class="attendance-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('view_attendance_modal')">×</span>
                    <div id="attendance_modal_details"></div>
                </div>
            </div>
        </div>
        <div id="page-content-wrapper">
            <div id="page-content" style="min-height: 7630px;">
                <div class="container">
                    <div id="page-title">
                        <h2>Attendances</h2> <br>
                    </div>
                    <div class="panel">
                        <div class="panel-body">
                            <div class="form-horizontal">
                                 <div class="form-group">
                                        <div class="col-sm-4">
                                            <div class="input-group bootstrap-touchspin"><span class="input-group-addon bootstrap-touchspin-prefix" style="display: none;"></span>
                                                <input type="text" id="attendance_search" placeholder="YYYY-MM" class="form-control" style="width: 400px;color:black;">
                                                <span class="input-group-btn">
                                                    <button class="btn btn-default  bootstrap-touchspin-up" type="button" onclick="loadAttendances($('#attendance_search').val())">Search</button>
                                                    <button class="btn btn-default  bootstrap-touchspin-up" type="button" onclick="location.href = 'TakeAttendance.jsp';">Take Attendance</button>
                                                </span>
                                            </div>
                                        </div>
                                    </div>

                                <br>
                                <div id="attendance_table">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
