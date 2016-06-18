<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Employee</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/EmployeeFunctions.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
    </head>
    <body>
        <h1>Add Employee</h1>
        <input type="radio" name="employeeType" onclick="loadFullTimeForm()" id="full-time">Full-Time
        <input type="radio" name="employeeType" onclick="loadPartTimeForm()" id="part-time">Part-Time
        <div id="employee_form_modal" class="modal">
            <!-- Modal content -->
            <div class="employee-form-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('employee_form_modal')">×</span>
                    <div id="employee_form_content"></div>
                </div>
            </div>
        </div>
        
        <div id="employee_error_modal" class="modal">
            <div class="error-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('employee_error_modal')">×</span>
                    <div id="employee_error_status"></div>
                    <hr>
                    <div id="employee_error_message"></div>
                </div>
            </div>
        </div>
    </body>
</html>
