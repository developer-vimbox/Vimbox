var prorate = 1;

Date.prototype.toDateInputValue = (function () {
    var local = new Date(this);
    local.setMinutes(this.getMinutes() - this.getTimezoneOffset());
    return local.toJSON().slice(0, 10);
});

function loadLeaveMCs(keyword) {
    $.get("LoadLeaveMC.jsp", {keyword: keyword}, function (data) {
        document.getElementById('leave_mc_table').innerHTML = data;
    });
}

function leaveMc_setup() {
    loadLeaveMCs("");
}

function loadEmployees(keyword, timer) {
    $.get("LoadEmployees.jsp", {keyword: keyword, timer: timer}, function (data) {
        document.getElementById('employees_table').innerHTML = data;
    });
}

function loadDesignations(department) {
    var radios = document.getElementsByTagName('input');
    var value;
    for (var i = 0; i < radios.length; i++) {
        if (radios[i].type === 'radio' && radios[i].checked) {
            // get value, set checked flag or do whatever you need to
            value = radios[i].value;
        }
    }
    var user_department = document.getElementById(department);

    var selectedValue = user_department.options[user_department.selectedIndex].value;
    var content = document.getElementById("user_designation_div");
    $.get("RetrieveEmployeeDesignations.jsp", {user_department: selectedValue, type: value}, function (data) {
        content.innerHTML = data;
    });
}

function fulltime_setup() {
    loadEmployees("", "full-time");
}

function parttime_setup() {
    loadEmployees("", "part-time");
}

function loadFullTimeDiv() {
    var full_time_department = document.getElementById("full_time_department");
    full_time_department.style.display = "block";
    document.getElementById("fulltime_user_department").value = "";
    loadDesignations("fulltime_user_department");
    document.getElementById("full_time_user_account").style.display = "block";
    document.getElementById("part_time_department").style.display = "none";

}

function loadPartTimeDiv() {
    document.getElementById("full_time_department").style.display = "none";
    document.getElementById("full_time_user_account").style.display = "none";
    document.getElementById("part_time_department").style.display = "block";
    document.getElementById("parttime_user_department").value = "";
    loadDesignations("parttime_user_department");
}

function viewEmployee(empId) {
    $.get("LoadViewEmployeeModal.jsp", {empId: empId}, function (data) {
        document.getElementById('viewEmployeeContent').innerHTML = data;
    });
    document.getElementById("viewEmployeeModal").style.display = "block";
}

function editEmployee(empId) {
    var modal = document.getElementById("edit_employee_modal");
    $.get("EditEmployee.jsp", {empId: empId}, function (data) {
        document.getElementById('employee_content').innerHTML = data;
        $('#edit_employee_form').ajaxForm({
            dataType: 'json',
            success: function (data) {
                var modal = document.getElementById("employee_error_modal");
                var status = document.getElementById("employee_error_status");
                var message = document.getElementById("employee_error_message");
                status.innerHTML = data.status;
                message.innerHTML = data.message;
                modal.style.display = "block";
                if (data.status === "SUCCESS") {
                    var employeeType = $('#employeeType').val();
                    if (employeeType === 'Full') {
                        loadEmployees("", "full-time");
                        setTimeout(function () {
                            document.getElementById("edit_employee_modal").style.display = "none";
                            modal.style.display = "none";
                        }, 500);
                    } else {
                        loadEmployees("", "part-time");
                        setTimeout(function () {
                            document.getElementById("edit_employee_modal").style.display = "none";
                            modal.style.display = "none";
                        }, 500);
                    }
                }
            },
            error: function (data) {
                var modal = document.getElementById("employee_error_modal");
                var status = document.getElementById("employee_error_status");
                var message = document.getElementById("employee_error_message");
                status.innerHTML = "ERROR";
                message.innerHTML = data;
                modal.style.display = "block";
            }
        });
    });
    modal.style.display = "block";
}

function confirmDelete(id, action) {
    var method = action.charAt(0).toUpperCase() + action.slice(1);
    var modal = document.getElementById(action + "_error_modal");
    var status = document.getElementById(action + "_error_status");
    var message = document.getElementById(action + "_error_message");
    status.innerHTML = "<center><h3 class=\"modal-title\"><b>Delete Confirmation</b></h3></center>";
    message.innerHTML = "<div class=\"form-horizontal\"> <div class=\"form-group\">Delete this " + action.replace("_", " ") + " record? Changes cannot be reverted.</div> <div class=\"form-group row\"><center><button class=\"btn btn-default\" onclick=\"delete" + method + "('" + id + "')\">Yes</button>&nbsp;<button class=\"btn btn-default\" onclick=\"closeModal('" + action + "_error_modal')\">No</button></center></div>";


//    message.innerHTML = "<table width='100%'><tr><td colspan='2'>Delete this " + action.replace("_" , " ") + " record? Changes cannot be reverted.</td></tr><tr><td align='center'><button onclick=\"delete" + method + "('" + id + "')\">Yes</button></td><td align='center'><button onclick=\"closeModal('" + action + "_error_modal')\">No</button></td></tr></table>";
    modal.style.display = "block";
}

function deleteEmployee(empId) {
    var modal = document.getElementById("employee_error_modal");
    var status = document.getElementById("employee_error_status");
    var message = document.getElementById("employee_error_message");
    $.getJSON("DeleteEmployeeController", {old_nric: empId})
            .done(function (data) {
                var dataStatus = data.status;
                var errorMsg = data.message;
                status.innerHTML = dataStatus;
                message.innerHTML = errorMsg;
                modal.style.display = "block";
                if (dataStatus === "SUCCESS") {
                    setTimeout(function () {
                        location.reload()
                    }, 500);
                }
            })
            .fail(function (error) {
                status.innerHTML = "ERROR";
                message.innerHTML = error;
                modal.style.display = "block";
            });
}

function deletePayslip(id) {
    var modal = document.getElementById("payslip_error_modal");
    var status = document.getElementById("payslip_error_status");
    var message = document.getElementById("payslip_error_message");
    $.getJSON("DeletePayslipController", {payslip_id: id})
            .done(function (data) {
                var dataStatus = data.status;
                var errorMsg = data.message;
                status.innerHTML = dataStatus;
                message.innerHTML = errorMsg;
                modal.style.display = "block";
                if (dataStatus === "SUCCESS") {
                    loadPayslips("");
                    setTimeout(function () {
                        modal.style.display = "none";
                    }, 500);
                }
            })
            .fail(function (error) {
                status.innerHTML = "ERROR";
                message.innerHTML = error;
                modal.style.display = "block";
            });
}

function deleteLeave_mc(id) {
    var modal = document.getElementById("leave_mc_error_modal");
    var status = document.getElementById("leave_mc_error_status");
    var message = document.getElementById("leave_mc_error_message");
    $.getJSON("DeleteLeaveMCController", {leaveMcId: id})
            .done(function (data) {
                var dataStatus = data.status;
                var errorMsg = data.message;
                status.innerHTML = dataStatus;
                message.innerHTML = errorMsg;
                modal.style.display = "block";
                if (dataStatus === "SUCCESS") {
                    loadLeaveMCs("");
                    setTimeout(function () {
                        modal.style.display = "none";
                    }, 500);
                }
            })
            .fail(function (error) {
                status.innerHTML = "ERROR";
                message.innerHTML = error;
                modal.style.display = "block";
            });
}

function fcPayslips() {
    document.getElementById("fastCreateModal").style.display = "block";
}

function fgPayslips() {
    var modal = document.getElementById("payslip_error_modal");
    var status = document.getElementById("payslip_error_status");
    var message = document.getElementById("payslip_error_message");

    var fc_paymentdate = $('#fc_paymentdate').val();

    $.getJSON("FCPayslipController", {fc_paymentdate: fc_paymentdate})
            .done(function (data) {
                var dataStatus = data.status;
                var errorMsg = data.message;
                status.innerHTML = dataStatus;
                message.innerHTML = errorMsg;
                modal.style.display = "block";
                if (dataStatus === "SUCCESS") {
                    loadPayslips("");
                    setTimeout(function () {
                        document.getElementById("fastCreateModal").style.display = "none";
                        modal.style.display = "none";
                    }, 500);
                }
            })
            .fail(function (error) {
                status.innerHTML = "ERROR";
                message.innerHTML = error;
                modal.style.display = "block";
            });
}

function loadPayslips(keyword) {
    $.get("LoadPayslips.jsp", {keyword: keyword}, function (data) {
        document.getElementById('payslips_table').innerHTML = data;
    });
}

function payslipsSetup() {
    loadPayslips("");
}

function viewPayslip(empId) {
    var modal = document.getElementById("viewPayslipModal");
    $.get("RetrievePayslipDetails.jsp", {empId: empId}, function (data) {
        document.getElementById('viewPayslipContent').innerHTML = data;
    });
    modal.style.display = "block";
}

function editPayslip(empId) {
    var modal = document.getElementById("edit_payslip_modal");
    $.get("EditPayslip.jsp", {empId: empId}, function (data) {
        document.getElementById('edit_payslip_content').innerHTML = data;
    });
    modal.style.display = "block";
}

$(document).on('change', '#payslip_employee', function () {
    var nric = $('#payslip_employee').val();
    $.getJSON("RetrieveEmployeeDetailsController", {nric: nric})
            .done(function (data) {
                prorate = 1;
                $('#payslip_startDate').val('');
                $('#payslip_endDate').val('');
                $('#payslip_paymentDate').val('');
                prorate = 1;
                var basic = (Number(data.basic) * prorate).toFixed(2);
                $('#payslip_paymentMode').val(data.payment_mode);
                $('#original_basic').val(basic);
                document.getElementById('payslip_basic').innerHTML = basic;
                $('#payslip_employerCpf').val((basic * 0.17).toFixed(2));
                clearBdTables();
                var tr = "<tr>";
                tr += "<td align='center'><input type='text' class='form-control' name='payslip_dbddescription' size='27' value=\"Employee's CPF Deduction\" placeholder='description'></td>";
                tr += "<td align='center'><div class='input-group' style='margin-left: 5px;'><span class='input-group-addon'>$</span><input type='number' class='form-control' step='0.01' min='0' name='payslip_dbdamount' value='" + (basic * 0.2).toFixed(2) + "' placeholder='amount'></div></td>";
                tr += "<td align='center'><input type='button' class='btn btn-warning' value='x' onclick='deleteEntry(this)'/>";
                tr += "</tr>";
                $('#payslip_dbd > tbody:last-child').append(tr);
                updatepayslip_dbd();
            })
            .fail(function (error) {
            });
});

$(document).on('change keyup paste', '#payslip_startDate', function () {
    var modal = document.getElementById("payslip_error_modal");
    var modalStatus = document.getElementById("payslip_error_status");
    var modalMessage = document.getElementById("payslip_error_message");

    var employee = $('#payslip_employee').val();
    if (employee == '') {
        modalStatus.innerHTML = "ERROR";
        modalMessage.innerHTML = "Select an employee first";
        $('#payslip_startDate').val('');
        modal.style.display = "block";
    } else {
        var startDate = new Date($('#payslip_startDate').val());

        var month = startDate.getMonth(); //months from 1-12
        var year = startDate.getFullYear();
        if (Number(year) > 1000) {
            $('#payslip_paymentDate').val(new Date(year, month + 1, 0).toDateInputValue());
            if (!$('#payslip_endDate').val()) {
                $('#payslip_endDate').val(new Date(year, month + 1, 0).toDateInputValue());
            }
            calculateProrate(employee, $('#payslip_startDate').val(), $('#payslip_endDate').val());
        }
    }
});

function calculateProrate(employee, startdate, enddate) {
    $.getJSON("ProrateController", {employee: employee, startdate: startdate, enddate: enddate})
            .done(function (data) {
                var status = data.status;
                if (status === 'SUCCESS') {
                    prorate = data.prorate;
                    var original_basic = Number($('#original_basic').val());
                    document.getElementById('payslip_basic').innerHTML = (original_basic * prorate).toFixed(2);
                    var basic = Number(document.getElementById('payslip_basic').innerHTML);

                    var table = document.getElementById("payslip_dbd");

                    for (var i = 0, row; row = table.rows[i]; i++) {
                        //iterate through rows
                        //rows would be accessed using the "row" variable assigned in the for loop
                        var found = false;
                        for (var j = 0, col; col = row.cells[j]; j++) {
                            //iterate through columns
                            //columns would be accessed using the "col" variable assigned in the for loop
                            var cellHtml = col.innerHTML;
                            console.log(cellHtml);
                            if (cellHtml.includes("Employee's CPF Deduction") || cellHtml.includes("Absent") || cellHtml.includes("Late") || cellHtml.includes("Unpaid")) {

                                found = true;
                                break;
                            }
                        }

                        if (found) {
                            row.parentNode.removeChild(row);
                            i--;
                        }
                    }

                    var tr = "<tr>";
                    tr += "<td align='center'><input type='text' class='form-control' name='payslip_dbddescription' size='27' value=\"Employee's CPF Deduction\" placeholder='description'></td>";
                    tr += "<td align='center'><div class='input-group' style='margin-left: 5px;'><span class='input-group-addon'>$</span><input type='number' class='form-control' step='0.01' min='0' name='payslip_dbdamount' value='" + (basic * 0.2).toFixed(2) + "' placeholder='amount'></div></td>";
                    tr += "<td align='center'><input type='button' class='btn btn-warning' value='x' onclick='deleteEntry(this)'/>";
                    tr += "</tr>";
                    $(tr).prependTo("#payslip_dbd > tbody");

                    var totalDays = Number(data.totalDays);

                    var absent = Number(data.absent);
                    if (absent > 0) {
                        var tr = "<tr>";
                        tr += "<td align='center'><input type='text' class='form-control' name='payslip_dbddescription' size='27' value=\"Absent - " + absent + " day(s)\" placeholder='description'></td>";
                        tr += "<td align='center'><div class='input-group' style='margin-left: 5px;'><span class='input-group-addon'>$</span><input type='number' class='form-control' step='0.01' min='0' name='payslip_dbdamount' value='" + (basic / totalDays * absent * 1.5).toFixed(2) + "' placeholder='amount'></div></td>";
                        tr += "<td align='center'><input type='button' class='btn btn-warning' value='x' onclick='deleteEntry(this)'/>";
                        tr += "</tr>";
                        $(tr).prependTo("#payslip_dbd > tbody");
                    }

                    var late = Number(data.late);
                    if (late > 0) {
                        var tr = "<tr>";
                        tr += "<td align='center'><input type='text' class='form-control' name='payslip_dbddescription' size='27' value=\"Late - " + (late / 60) + " hours(s) " + (late % 60) + " min(s)\" placeholder='description'></td>";
                        tr += "<td align='center'><div class='input-group' style='margin-left= 5px;'><span class='input-group-addon'>$</span><input type='number' class='form-control' step='0.01' min='0' name='payslip_dbdamount' value='" + ((basic / (totalDays * 9 * 60)) * late).toFixed(2) + "' placeholder='amount'></div></td>";
                        tr += "<td align='center'><input type='button' class='btn btn-warning' value='x' onclick='deleteEntry(this)'/>";
                        tr += "</tr>";
                        $(tr).prependTo("#payslip_dbd > tbody");
                    }

                    var mc = Number(data.mc);
                    if (mc > 0) {
                        var tr = "<tr>";
                        tr += "<td align='center'><input type='text' class='form-control' name='payslip_dbddescription' size='27' value=\"Unpaid MC - " + mc + " day(s)\" placeholder='description'></td>";
                        tr += "<td align='center'><div class='input-group' style='margin-left: 5px;'><span class='input-group-addon'>$</span><input type='number' class='form-control' step='0.01' min='0' name='payslip_dbdamount' value='" + (basic / totalDays * mc).toFixed(2) + "' placeholder='amount'></div></td>";
                        tr += "<td align='center'><input type='button' class='btn btn-warning' value='x' onclick='deleteEntry(this)'/>";
                        tr += "</tr>";
                        $(tr).prependTo("#payslip_dbd > tbody");
                    }

                    var timeoff = Number(data.timeoff);
                    if (timeoff > 0) {
                        var tr = "<tr>";
                        tr += "<td align='center'><input type='text' class='form-control' name='payslip_dbddescription' size='27' value=\"Unpaid Time Off - " + (timeoff / 9) + " hour(s)\" placeholder='description'></td>";
                        tr += "<td align='center'><div class='input-group' style='margin-left: 5px;'><span class='input-group-addon'>$</span><input type='number' class='form-control' step='0.01' min='0' name='payslip_dbdamount' value='" + ((basic / (totalDays * 9)) * timeoff).toFixed(2) + "' placeholder='amount'></div></td>";
                        tr += "<td align='center'><input type='button' class='btn btn-warning' value='x' onclick='deleteEntry(this)'/>";
                        tr += "</tr>";
                        $(tr).prependTo("#payslip_dbd > tbody");
                    }

                    var leave = Number(data.leave);
                    if (leave > 0) {
                        var leaveString = "Unpaid Leave - ";
                        var leaveDays = leave / 9;
                        if (leaveDays > 0)
                            leaveString += leaveDays + " day(s) ";
                        var leaveHours = leave % 9;
                        if (leaveHours > 0)
                            leaveString += leaveHours + " hour(s) ";
                        var tr = "<tr>";
                        tr += "<td align='center'><input type='text' class='form-control' name='payslip_dbddescription' size='27' value=\"" + leaveString + "\" placeholder='description'></td>";
                        tr += "<td align='center'><div class='input-group' style='margin-left: 5px;'><span class='input-group-addon'>$</span><input type='number' class='form-control' step='0.01' min='0' name='payslip_dbdamount' value='" + ((basic / (totalDays * 9)) * leave).toFixed(2) + "' placeholder='amount'></div></td>";
                        tr += "<td align='center'><input type='button' class='btn btn-warning' value='x' onclick='deleteEntry(this)'/>";
                        tr += "</tr>";
                        $(tr).prependTo("#payslip_dbd > tbody");
                    }

                    $('#payslip_employerCpf').val((basic * 0.17).toFixed(2));
                    updatepayslip_dbd();
                } else {
                    var modal = document.getElementById("payslip_error_modal");
                    var modalStatus = document.getElementById("payslip_error_status");
                    var modalMessage = document.getElementById("payslip_error_message");
                    modalStatus.innerHTML = status;
                    modalMessage.innerHTML = data.errorMsg;
                    $('#payslip_startDate').val('');
                    modal.style.display = "block";
                }
            })
            .fail(function (error) {
            });
}

$(document).on('change keyup paste', '#payslip_endDate', function () {
    var modal = document.getElementById("payslip_error_modal");
    var modalStatus = document.getElementById("payslip_error_status");
    var modalMessage = document.getElementById("payslip_error_message");

    var employee = $('#payslip_employee').val();
    if (employee == '') {
        modalStatus.innerHTML = "ERROR";
        modalMessage.innerHTML = "Select an employee first";
        $('#payslip_startDate').val('');
        modal.style.display = "block";
    } else {
        if ($('#payslip_endDate').val()) {
            calculateProrate(employee, $('#payslip_startDate').val(), $('#payslip_endDate').val());
        }
    }
});

$(document).on('change keyup paste', '#payslip_ot', function () {
    var otHrs = $('#payslip_ot').val();
    var otRate = $('#payslip_otRate').val();
    document.getElementById('payslip_overtime').innerHTML = (Number(otHrs) * Number(otRate)).toFixed(2);
    updateTotal();
});

$(document).on('change keyup paste', '#payslip_otRate', function () {
    var otHrs = $('#payslip_ot').val();
    var otRate = $('#payslip_otRate').val();
    document.getElementById('payslip_overtime').innerHTML = (Number(otHrs) * Number(otRate)).toFixed(2);
    updateTotal();
});

function addPayslipBDEntry(tableName) {
    var tr = "<tr>";
    tr += "<td align='center'><input type='text' class='form-control' name='" + tableName + "description' size='27' placeholder='description'></td>";
    tr += "<td align='center'><div class='input-group' style='margin-left: 5px;'><span class='input-group-addon'>$</span><input type='number' class='form-control' step='0.01' min='0' name='" + tableName + "amount' size='3' placeholder='amount' onkeyup='update" + tableName + "()'></div></td>";
    tr += "<td align='center'><input type='button' class='btn btn-warning' value='x' onclick='deleteEntry(this)'/>";
    tr += "</tr>";
    tableName = '#' + tableName + " > tbody:last-child";
    $(tableName).append(tr);
}

function deleteEntry(btn) {
    var row = btn.parentNode.parentNode;
    var id = $(row.parentNode.parentNode).attr('id');
    row.parentNode.removeChild(row);
    window["update" + id]();
}

function updateTotal() {
    var basic = document.getElementById('payslip_basic').innerHTML;
    var allowance = document.getElementById('payslip_allowance').innerHTML;
    var deduction = document.getElementById('payslip_deduction').innerHTML;
    var overtime = document.getElementById('payslip_overtime').innerHTML;
    var additional = document.getElementById('payslip_additional').innerHTML;
    document.getElementById('payslip_netpay').innerHTML = (Number(basic) + Number(allowance) - Number(deduction) + Number(overtime) + Number(additional)).toFixed(2);
}

function updatepayslip_abd() {
    var total = 0;
    $("input[name='payslip_abdamount']").each(function () {
        var value = $(this).val(); // grab name of original
        if (!isNaN(value)) {
            total += Number(value);
        }
    });
    document.getElementById('payslip_allowance').innerHTML = total.toFixed(2);
    updateTotal();
}

function updatepayslip_dbd() {
    var total = 0;
    $("input[name='payslip_dbdamount']").each(function () {
        var value = $(this).val(); // grab name of original
        console.log(value);
        if (!isNaN(value)) {
            total += Number(value);
        }
    });
    document.getElementById('payslip_deduction').innerHTML = total.toFixed(2);
    updateTotal();
}

function updatepayslip_apbd() {
    var total = 0;
    $("input[name='payslip_apbdamount']").each(function () {
        var value = $(this).val(); // grab name of original
        if (!isNaN(value)) {
            total += Number(value);
        }
    });
    document.getElementById('payslip_additional').innerHTML = total.toFixed(2);
    updateTotal();
}

function clearBdTables() {
    var abdTable = document.getElementById("payslip_abd");
    for (var i = 0, abdRow; abdRow = abdTable.rows[i]; i++) {
        abdRow.parentNode.removeChild(abdRow);
        i--;
    }

    var dbdTable = document.getElementById("payslip_dbd");
    for (var i = 0, dbdRow; dbdRow = dbdTable.rows[i]; i++) {
        dbdRow.parentNode.removeChild(dbdRow);
        i--;
    }

    var apbdTable = document.getElementById("payslip_apbd");
    for (var i = 0, apbdRow; apbdRow = apbdTable.rows[i]; i++) {
        apbdRow.parentNode.removeChild(apbdRow);
        i--;
    }
}

function createPayslip() {
    var start_date = $('#payslip_startDate').val();
    var end_date = $('#payslip_endDate').val();
    var payment_date = $('#payslip_paymentDate').val();

    var employee = $('#payslip_employee').val();
    var payment_mode = $('#payslip_paymentMode').val();

    var abd_description = "";
    $("input[name='payslip_abddescription']").each(function () {
        var value = $(this).val(); // grab name of original
        abd_description += (value + "|");
    });
    var abd_amount = "";
    $("input[name='payslip_abdamount']").each(function () {
        var value = $(this).val(); // grab name of original
        abd_amount += (value + "|");
    });

    var dbd_description = "";
    $("input[name='payslip_dbddescription']").each(function () {
        var value = $(this).val(); // grab name of original
        dbd_description += (value + "|");
    });
    var dbd_amount = "";
    $("input[name='payslip_dbdamount']").each(function () {
        var value = $(this).val(); // grab name of original
        dbd_amount += (value + "|");
    });

    var apbd_description = "";
    $("input[name='payslip_apbddescription']").each(function () {
        var value = $(this).val(); // grab name of original
        apbd_description += (value + "|");
    });
    var apbd_amount = "";
    $("input[name='payslip_apbdamount']").each(function () {
        var value = $(this).val(); // grab name of original
        apbd_amount += (value + "|");
    });

    var basic = document.getElementById('payslip_basic').innerHTML;
    var allowance = document.getElementById('payslip_allowance').innerHTML;
    var deduction = document.getElementById('payslip_deduction').innerHTML;
    var overtimeHr = $('#payslip_ot').val();
    var overtime = document.getElementById('payslip_overtime').innerHTML;
    var additional = document.getElementById('payslip_additional').innerHTML;
    var employer_cpf = $('#payslip_employerCpf').val();

    var modal = document.getElementById("payslip_error_modal");
    var status = document.getElementById("payslip_error_status");
    var message = document.getElementById("payslip_error_message");

    $.getJSON("CreatePayslipController", {start_date: start_date, end_date: end_date, payment_date: payment_date, employee: employee,
        payment_mode: payment_mode, abd_description: abd_description, abd_amount: abd_amount, dbd_description: dbd_description,
        dbd_amount: dbd_amount, apbd_description: apbd_description, apbd_amount: apbd_amount, basic: basic, allowance: allowance,
        deduction: deduction, overtimeHr: overtimeHr, overtime: overtime, additional: additional, employer_cpf: employer_cpf})
            .done(function (data) {
                var dataStatus = data.status;
                status.innerHTML = dataStatus;
                message.innerHTML = data.message;
                modal.style.display = "block";
                if (dataStatus === "SUCCESS") {
                    setTimeout(function () {
                        window.location.href = "Payslips.jsp";
                    }, 500);
                }
            })
            .fail(function (error) {
                status.innerHTML = "ERROR";
                message.innerHTML = error;
                modal.style.display = "block";
            });
}

function updatePayslip() {
    var payslip_id = $('#payslip_id').val();

    var original_startDate = $('#original_startDate').val();
    var start_date = $('#payslip_startDate').val();
    var end_date = $('#payslip_endDate').val();
    var payment_date = $('#payslip_paymentDate').val();

    var employee = $('#payslip_employee').val();
    var payment_mode = $('#payslip_paymentMode').val();

    var abd_description = "";
    $("input[name='payslip_abddescription']").each(function () {
        var value = $(this).val(); // grab name of original
        abd_description += (value + "|");
    });
    var abd_amount = "";
    $("input[name='payslip_abdamount']").each(function () {
        var value = $(this).val(); // grab name of original
        abd_amount += (value + "|");
    });

    var dbd_description = "";
    $("input[name='payslip_dbddescription']").each(function () {
        var value = $(this).val(); // grab name of original
        dbd_description += (value + "|");
    });
    var dbd_amount = "";
    $("input[name='payslip_dbdamount']").each(function () {
        var value = $(this).val(); // grab name of original
        dbd_amount += (value + "|");
    });

    var apbd_description = "";
    $("input[name='payslip_apbddescription']").each(function () {
        var value = $(this).val(); // grab name of original
        apbd_description += (value + "|");
    });
    var apbd_amount = "";
    $("input[name='payslip_apbdamount']").each(function () {
        var value = $(this).val(); // grab name of original
        apbd_amount += (value + "|");
    });

    var basic = document.getElementById('payslip_basic').innerHTML;
    var allowance = document.getElementById('payslip_allowance').innerHTML;
    var deduction = document.getElementById('payslip_deduction').innerHTML;
    var overtimeHr = $('#payslip_ot').val();
    var overtime = document.getElementById('payslip_overtime').innerHTML;
    var additional = document.getElementById('payslip_additional').innerHTML;
    var employer_cpf = $('#payslip_employerCpf').val();

    var modal = document.getElementById("payslip_error_modal");
    var status = document.getElementById("payslip_error_status");
    var message = document.getElementById("payslip_error_message");

    $.getJSON("EditPayslipController", {payslip_id: payslip_id, original_startDate: original_startDate, start_date: start_date, end_date: end_date, payment_date: payment_date, employee: employee,
        payment_mode: payment_mode, abd_description: abd_description, abd_amount: abd_amount, dbd_description: dbd_description,
        dbd_amount: dbd_amount, apbd_description: apbd_description, apbd_amount: apbd_amount, basic: basic, allowance: allowance,
        deduction: deduction, overtimeHr: overtimeHr, overtime: overtime, additional: additional, employer_cpf: employer_cpf})
            .done(function (data) {
                var dataStatus = data.status;
                status.innerHTML = dataStatus;
                message.innerHTML = data.message;
                modal.style.display = "block";
                if (dataStatus === "SUCCESS") {
                    loadPayslips("");
                    setTimeout(function () {
                        modal.style.display = "none"
                    }, 500);
                }
            })
            .fail(function (error) {
                status.innerHTML = "ERROR";
                message.innerHTML = error;
                modal.style.display = "block";
            });
}

function resetDates() {
    $("#payslip_startDate").val('');
    $("#payslip_endDate").val('');
}

$(document).on('change', '#leaveName', function () {
    var value = $('#leaveName').val();
    if (value === "MC") {
        document.getElementById('file').disabled = false;
        document.getElementById('start_hour').disabled = true;
        document.getElementById('start_minute').disabled = true;
        document.getElementById('end_hour').disabled = true;
        document.getElementById('end_minute').disabled = true;
    } else {
        document.getElementById('file').disabled = true;
        document.getElementById('start_hour').disabled = false;
        document.getElementById('start_minute').disabled = false;
        document.getElementById('end_hour').disabled = false;
        document.getElementById('end_minute').disabled = false;
    }
});

$(document).on('change', '#leaveEmployee', function () {
    var value = $('#leaveEmployee').val();
    $.getJSON("RetrieveEmployeeLeaveMCController", {nric: value})
            .done(function (data) {
                var leave = data.remainingLeave;
                var mc = data.remainingMC;
                if (leave !== '') {
                    document.getElementById('leave_employee_leave').innerHTML = leave;
                } else {
                    document.getElementById('leave_employee_leave').innerHTML = "";
                }

                if (mc !== '') {
                    document.getElementById('leave_employee_mc').innerHTML = mc + " Days";
                } else {
                    document.getElementById('leave_employee_mc').innerHTML = "";
                }
                var workingDays = data.workingDays;
                if (workingDays === '5') {
                    $('#start_hour').val("09");
                    $('#start_minute').val("00");
                    $('#end_hour').val("09");
                    $('#end_minute').val("00");
                } else if (workingDays === '6') {
                    $('#start_hour').val("08");
                    $('#start_minute').val("30");
                    $('#end_hour').val("08");
                    $('#end_minute').val("30");
                }
            })
            .fail(function (error) {
            });
});

function loadLeaveMCNric(nric) {
    var modal = document.getElementById('view_leavemc_modal');
    $.get("LoadLeaveMCNric.jsp", {nric: nric}, function (data) {
        document.getElementById('leavemc_content').innerHTML = data;
    });
    modal.style.display = "block";
}

$(document).on('change', '#start_date', function () {
    var eDate = $('#end_date').val();
    if (eDate === '') {
        var startDate = new Date($('#start_date').val());
        var date = startDate.getDate();
        var month = startDate.getMonth(); //months from 1-12
        var year = startDate.getFullYear();
        if (Number(year) > 1000) {
            $('#end_date').val(new Date(year, month, date + 1).toDateInputValue());
        }
    }
});

$(document).on('change', '.attendance_radio', function () {

    var value = $(this).val();
    var name = $(this).attr('name');
    var nric = (name.split("_"))[1];
    if (value === 'Late') {
        document.getElementById("late_" + nric + "_h").disabled = false;
        document.getElementById("late_" + nric + "_m").disabled = false;
    } else {
        document.getElementById("late_" + nric + "_h").disabled = true;
        document.getElementById("late_" + nric + "_m").disabled = true;
    }
});

function attendance_setup() {
    loadAttendances("");
}

function loadAttendances(keyword) {
    $.get("LoadAttendancesYM.jsp", {keyword: keyword}, function (data) {
        document.getElementById('attendance_table').innerHTML = data;
    });
}

function viewAttendance(keyword) {
    $.get("LoadAttendancesViewModal.jsp", {keyword: keyword}, function (data) {
        document.getElementById('attendance_modal_details').innerHTML = data;
    });
    document.getElementById("view_attendance_modal").style.display = "block";
}