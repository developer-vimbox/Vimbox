function loadEmployees(keyword, timer){
    $.get("LoadEmployees.jsp", {keyword: keyword, timer: timer}, function (data) {
        document.getElementById('employees_table').innerHTML = data;
    });
}

function fulltime_setup(){
    loadEmployees("","full-time");
}

function parttime_setup(){
    loadEmployees("","part-time");
}

function loadFullTimeForm(){
    var modal = document.getElementById("employee_form_modal");
    $( "#employee_form_content" ).load( "FullTimeEmployeeForm.jsp" );
    modal.style.display = "block";
}

function addFullTimeEmployee(){
    var ft_first_name = $('#ft_first_name').val();
    var ft_last_name = $('#ft_last_name').val();
    var ft_nric = $('#ft_nric_first_alphabet').val() + $('#ft_nric').val() + $('#ft_nric_last_alphabet').val();
    var ft_gender = $("input[name='ft_gender']:checked").val();
    if(ft_gender == null){
        ft_gender = "";
    }
    var ft_dob = $('#ft_dob').val();
    var ft_contact = $('#ft_contact').val();
    var ft_address = $('#ft_add_rd').val() + " | " + $('#ft_add_level').val() + " | " + $('#ft_add_unit').val() + " | " + $('#ft_add_postal').val();
    var ft_dj = $('#ft_dj').val();
    var ft_designation = $('#ft_designation').val();
    var ft_username = $('#ft_username').val();
    var ft_password = $('#ft_password').val();
    var ft_modules = "";
    $('#ft_modules :selected').each(function(i, sel){ 
        ft_modules += ($(sel).val() + "|"); 
    });
    
    
    var errorModal = document.getElementById("employee_error_modal");
    var errorStatus = document.getElementById("employee_error_status");
    var errorMessage = document.getElementById("employee_error_message");
    $.getJSON("CreateFullTimeController", {ft_first_name: ft_first_name, ft_last_name: ft_last_name, ft_nric: ft_nric, ft_gender: ft_gender, ft_dob: ft_dob, ft_contact: ft_contact, ft_address: ft_address, ft_dj: ft_dj, ft_designation: ft_designation, ft_username: ft_username, ft_password: ft_password, ft_modules: ft_modules})
            .done(function (data) {
                var status = data.status;
                var errorMsg = data.message;
                errorStatus.innerHTML = status;
                errorMessage.innerHTML = errorMsg;
                errorModal.style.display = "block";
                if (status === "SUCCESS") {
                    setTimeout(function() {location.reload()},500);
                }
            })
            .fail(function (error) {
                errorStatus.innerHTML = "ERROR";
                errorMessage.innerHTML = error;
                errorModal.style.display = "block";
            });
}

function loadPartTimeForm(){
    var modal = document.getElementById("employee_form_modal");
    $("#employee_form_content").load( "PartTimeEmployeeForm.jsp" );
    modal.style.display = "block";
}

function addPartTimeEmployee(){
    var pt_first_name = $('#pt_first_name').val();
    var pt_last_name = $('#pt_last_name').val();
    var pt_nric = $('#pt_nric_first_alphabet').val() + $('#pt_nric').val() + $('#pt_nric_last_alphabet').val();
    var pt_contact = $('#pt_contact').val();
    var pt_dj = $('#pt_dj').val();
    var pt_designation = $('#pt_designation').val();
    
    var errorModal = document.getElementById("employee_error_modal");
    var errorStatus = document.getElementById("employee_error_status");
    var errorMessage = document.getElementById("employee_error_message");
    $.getJSON("CreatePartTimeController", {pt_first_name: pt_first_name, pt_last_name: pt_last_name, pt_nric: pt_nric, pt_contact: pt_contact, pt_dj: pt_dj, pt_designation: pt_designation})
            .done(function (data) {
                var status = data.status;
                var errorMsg = data.message;
                errorStatus.innerHTML = status;
                errorMessage.innerHTML = errorMsg;
                errorModal.style.display = "block";
                if (status === "SUCCESS") {
                    setTimeout(function() {location.reload()},500);
                }
            })
            .fail(function (error) {
                errorStatus.innerHTML = "ERROR";
                errorMessage.innerHTML = error;
                errorModal.style.display = "block";
            });
}
