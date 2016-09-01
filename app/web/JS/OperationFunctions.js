function sales_operation_setup() {
    loadSalesOperations('');
}

function loadSalesOperations(keyword) {
    $.get("LoadSalesOperations.jsp", {keyword: keyword}, function (data) {
        document.getElementById("operations_table").innerHTML = data;
    });
}

function confirmJobCancel(leadId, date, timeslot, nric) {
    var modal = document.getElementById("operation_error_modal");
    var status = document.getElementById("operation_error_status");
    var message = document.getElementById("operation_error_message");

    status.innerHTML = "Cancel Confirmation";
    var table = "<table width='100%'>";
    table += "<tr><td colspan='2'>Are you sure that you want to cancel this job assignment?</td></tr>";
    table += "<tr><td align='center'><button onclick=\"jobCancel('" + leadId + "','" + date + "','" + timeslot + "','" + nric + "')\">YES</button></td><td align='center'><button onclick=\"closeModal('operation_error_modal'); return false;\">No</button></td></tr>";
    table += "</table>";
    message.innerHTML = table;
    modal.style.display = "block";
}

function jobCancel(leadId, date, timeslot, nric) {
    var modal = document.getElementById("operation_error_modal");
    var status = document.getElementById("operation_error_status");
    var message = document.getElementById("operation_error_message");
    $.get("CancelJobController", {leadId: leadId, date: date, timeslot: timeslot}, function (data) {
        status.innerHTML = data.status;
        message.innerHTML = data.message;
        loadSalesOperations('', nric);
        setTimeout(function () {
            modal.style.display = "none";
        }, 500);
    });
}

