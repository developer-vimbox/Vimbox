function assign_jobs_setup() {
    loadAssignJobs('');
}

function selectAllJobs(source){
    var checkboxes = document.getElementsByName('selectedJobs');
    for(var i=0, n=checkboxes.length;i<n;i++) {
      checkboxes[i].checked = source.checked;
    }
}

function loadAssignJobs(keyword) {
    $.get("LoadAssignJobs.jsp", {keyword: keyword}, function (data) {
        document.getElementById("jobs_table").innerHTML = data;
    });
}

function assignJobModal(){
    var modal = document.getElementById("job_error_modal");
    var status = document.getElementById("job_error_status");
    var message = document.getElementById("job_error_message");
    
    var leadIds = "";
    var leadIdsArray = $("input[name=selectedJobs]");
    for (var i = 0; i < leadIdsArray.length; i++) {
        if(leadIdsArray[i].checked){
            leadIds += leadIdsArray[i].value + "|";
        }
    }
    
    if(!leadIds){
        status.innerHTML = "ERROR";
        message.innerHTML = "Please select at least one job";
        modal.style.display = "block";
    }else{
        $.get("LoadAssignJobModal.jsp", {leadIds: leadIds}, function (data) {
            document.getElementById("assignJobContent").innerHTML = data;
            document.getElementById("assignJobModal").style.display = "block";
        });
    }
}

function assignJob(){
    var modal = document.getElementById("job_error_modal");
    var status = document.getElementById("job_error_status");
    var message = document.getElementById("job_error_message");
    
    var leadIds = document.getElementById("leadIds").value;
    var supervisor = document.getElementsByName("supervisor")[0].value;
    
    $.get("AssignJobController", {leadIds: leadIds, supervisor: supervisor}, function (data) {
        status.innerHTML = data.status;
        message.innerHTML = data.message;
        modal.style.display = "block";
        loadAssignJobs('');
        setTimeout(function () {
            modal.style.display = "none";
            document.getElementById("assignJobModal").style.display = "none";
        }, 500);
    });
}

function sales_operation_setup() {
    loadSalesOperations('');
}

function loadSalesOperations(keyword) {
    $.get("LoadSalesOperations.jsp", {keyword: keyword}, function (data) {
        document.getElementById("operations_table").innerHTML = data;
    });
}

function confirmJobCancel(leadId, date, timeslot) {
    var modal = document.getElementById("operation_error_modal");
    var status = document.getElementById("operation_error_status");
    var message = document.getElementById("operation_error_message");

    status.innerHTML = "Cancel Confirmation";
    var table = "<table width='100%'>";
    table += "<tr><td colspan='2'>Are you sure that you want to cancel this job assignment?</td></tr>";
    table += "<tr><td align='center'><button onclick=\"jobCancel('" + leadId + "','" + date + "','" + timeslot + "')\">YES</button></td><td align='center'><button onclick=\"closeModal('operation_error_modal'); return false;\">No</button></td></tr>";
    table += "</table>";
    message.innerHTML = table;
    modal.style.display = "block";
}

function jobCancel(leadId, date, timeslot) {
    var modal = document.getElementById("operation_error_modal");
    var status = document.getElementById("operation_error_status");
    var message = document.getElementById("operation_error_message");
    $.get("CancelJobController", {leadId: leadId, date: date, timeslot: timeslot}, function (data) {
        status.innerHTML = data.status;
        message.innerHTML = data.message;
        loadSalesOperations('');
        setTimeout(function () {
            modal.style.display = "none";
        }, 500);
    });
}