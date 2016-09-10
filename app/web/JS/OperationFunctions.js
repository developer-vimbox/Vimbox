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
    loadSalesOperations('', 'Booked');
    loadSalesOperations('', 'Confirmed');
    loadSalesOperations('', 'Cancelled');
}

function loadSalesOperations(keyword, type) {
    $.get("LoadSalesOperations.jsp", {keyword: keyword, type: type}, function (data) {
        document.getElementById(type).innerHTML = data;
    });
}

function confirmJobCancel(leadId, date, timeslot, status) {
    var modal = document.getElementById("operation_error_modal");
    var status = document.getElementById("operation_error_status");
    var message = document.getElementById("operation_error_message");

    var displayMsg = "";
    if(status === 'Booked'){
        displayMsg = "Are you sure that you want to cancel this job assignment?";
    }else{
        displayMsg = "There will be no refund for any cancellation done within 7 days from confirmation.<br>Are you sure that you want to cancel this job assignment?";
    }
    status.innerHTML = "Cancel Confirmation";
    var table = "<table width='100%'>";
    table += "<tr><td colspan='2'>" + displayMsg + "</td></tr>";
    table += "<tr><td align='center'>";
    if(status === 'Booked'){
        table += "<button onclick=\"jobCancel('" + leadId + "','" + date + "','" + timeslot + "')\">YES</button>";
    }else{
        table += "<button onclick=\"jobCancel('" + leadId + "','" + date + "','" + timeslot + "')\">YES</button>";
    }
    table += "</td><td align='center'><button onclick=\"closeModal('operation_error_modal'); return false;\">No</button></td></tr>";
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
        sales_operation_setup();
        setTimeout(function () {
            modal.style.display = "none";
        }, 500);
    });
}

function changeSupervisorMonthYear() {
    var content = document.getElementById("supervisorCalendar");
    var iYear = document.getElementById('sYear').value;
    var iMonth = document.getElementById('sMonth').value;
    var m_names = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    var n = m_names[iMonth];
    $("#dMonth").html(n);
    $("#dYear").html(iYear);
    $.get("SupervisorJobsCalendar.jsp", {getYear: iYear, getMonth: iMonth}, function (data) {
        content.innerHTML = data;
    });
}

function loadSupervisorCal() {
    var content = document.getElementById("supervisorCalendar");
    var d = new Date();
    var m = d.getMonth();
    var y = d.getFullYear();
    var m_names = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    var n = m_names[d.getMonth()];
    $("#dMonth").html(n);
    $("#dYear").html(y);

    $.get("SupervisorJobsCalendar.jsp", {getYear: y, getMonth: m}, function (data) {
        content.innerHTML = data;
    });
}

function loadMovers(empType) {
    var content = document.getElementById("movers");
    var dom = document.getElementById('dom').value;
    $.get("RetrieveMovers.jsp", {getDOM: dom, getEmpType: empType}, function (data) {
        content.innerHTML = data;
    });
    content.style.display = "block";
}

function removeMover(ic) {
    var supervisor = $('#supervisor').val();
    var dom = $('#dom').val();
    $.getJSON("RemoveMoverController", {supervisor: supervisor, mover: ic, dom: dom})
            .done(function (data) {
               document.getElementById("full-time").checked = true;
                loadBody('Full');
            })
            .fail(function (error) {
                document.getElementById("full-time").checked = true;
                loadBody('Full');
            });
}

function loadBody(empType) {
    loadMovers(empType);
    
    var dom = document.getElementById('dom').value;
    var supervisor = document.getElementById('supervisor').value;
    var table = document.getElementById("movers_table");
    $.get("LoadAssignedMovers.jsp", {getDOM: dom, getSupervisor: supervisor}, function (data) {
        table.innerHTML = data;
    });
    table.style.display = "block";
}

function assignMovers() {
    var supervisor = $('#supervisor').val();
    var mover = $('#selected_mover').val();
    var dom = $('#dom').val();

    var errorModal = document.getElementById("error_modal");
    var errorStatus = document.getElementById("error_status");
    var errorMessage = document.getElementById("error_message");
    $.getJSON("AssignMoverController", {supervisor: supervisor, mover: mover, dom: dom})
            .done(function (data) {
                var status = data.status;
                var errorMsg = data.message;
                
                errorStatus.innerHTML = status;
                errorMessage.innerHTML = errorMsg;
                errorModal.style.display = "block";
                setTimeout(function () {
                    errorModal.style.display = "none";
                }, 1000);
                document.getElementById("full-time").checked = true;
                loadBody('Full');
            })
            .fail(function (error) {
                errorStatus.innerHTML = "ERROR";
                errorMessage.innerHTML = error;
                errorModal.style.display = "block";
                document.getElementById("full-time").checked = true;
                loadBody('Full');
            });
}

$(document).on('change', '.attendance_radio', function(){
    
    var value = $(this).val();
    var name = $(this).attr('name');
    var nric = (name.split("_"))[1];
    if(value === 'Late'){
        document.getElementById("late_" + nric + "_h").disabled = false;
        document.getElementById("late_" + nric + "_m").disabled = false;
    }else{
        document.getElementById("late_" + nric + "_h").disabled = true;
        document.getElementById("late_" + nric + "_m").disabled = true;
    }
});
