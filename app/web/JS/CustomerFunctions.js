function customerSearch(module) {
    var modal = document.getElementById("customer_modal");
    var name = $('#customer_search').val();
    var content = document.getElementById("customer_content");
    $.get("SearchCustomersByName.jsp", {getName: name, getAction: module}, function (data) {
        content.innerHTML = data;
        $('.javascript').each(function () {
            eval($(this).text());
        });
    });
    modal.style.display = "block";
}

function customerSearchHeader(module) {
    var modal = document.getElementById("customer_modal_header");
    var name = $('#customer_search_header').val();
    var content = document.getElementById("customer_content_header");
    $.get("SearchCustomersByName.jsp", {getName: name, getAction: module}, function (data) {
        content.innerHTML = data;
        $('.javascript').each(function () {
            eval($(this).text());
        });
    });
    modal.style.display = "block";
}

function addNewCustomer() {
    var modal = document.getElementById("add_customer_modal");
    $("#add_customer_content").load("CreateCustomer.jsp");
    modal.style.display = "block";
}

function createCustomer() {
    var create_salutation = $('#create_salutation').val();
    var create_first_name = $('#create_first_name').val();
    var create_last_name = $('#create_last_name').val();
    var create_contact = $('#create_contact').val();
    var create_email = $('#create_email').val();

    var errorModal = document.getElementById("customer_error_modal");
    var errorStatus = document.getElementById("customer_error_status");
    var errorMessage = document.getElementById("customer_error_message");
    $.getJSON("CreateCustomerController", {salutation: create_salutation, firstName: create_first_name, lastName: create_last_name, contact: create_contact, email: create_email})
            .done(function (data) {
                var status = data.status;
                var errorMsg = data.message;
                if (status === "SUCCESS") {
                    document.getElementById("add_customer_modal").style.display = "none";
                    document.getElementById("customer_modal").style.display = "none";
                    $('#customer_id').val(data.customer_id);
                    $("#customer_name").html(data.customer_salutation + " " + data.customer_first_name + " " + data.customer_last_name);
                    $("#customer_salutation").html(data.customer_salutation);
                    $("#customer_first_name").html(data.customer_first_name);
                    $("#customer_last_name").html(data.customer_last_name);
                    $("#customer_contact").html(data.customer_contact);
                    $("#customer_email").html(data.customer_email);
                    document.getElementById("cust_btn_input").innerHTML = "<button onclick=\"editCustomer('" + data.customer_id + "','Lead'); return false;\" class=\"btn btn-default\">Edit</button>";
                    document.getElementById("customer_information_table").style.display = "block";
                }
                errorStatus.innerHTML = status;
                errorMessage.innerHTML = errorMsg;
                errorModal.style.display = "block";
            })
            .fail(function (error) {
                errorStatus.innerHTML = "ERROR";
                errorMessage.innerHTML = error;
                errorModal.style.display = "block";
            });
}

function selectCustomer(customer_id, customer_salutation, customer_first_name, customer_last_name, customer_contact, customer_email) {
    document.getElementById("customer_modal").style.display = "none";
    $('#customer_id').val(customer_id);
    $("#customer_salutation").html(customer_salutation);
    $("#customer_first_name").html(customer_first_name);
    $("#customer_last_name").html(customer_last_name);
    $("#customer_contact").html(customer_contact);
    $("#customer_email").html(customer_email);
    $("#customer_name").html(customer_salutation + " " + customer_first_name + " " + customer_last_name)
    document.getElementById("cust_btn_input").innerHTML = "<button onclick=\"editCustomer('" + customer_id + "','Lead'); return false;\" class=\"btn btn-default\">Edit</button>";
    document.getElementById("customer_information_table").style.display = "block";
}

function editCustomer(customer_id, module) {
    var modal;
    if (module === "Lead") {
        modal = document.getElementById("lead_edit_customer_modal");
    } else {
        modal = document.getElementById("edit_customer_modal");
    }
    var content;
    if (module === "Lead") {
        content = document.getElementById("lead_edit_customer_content");
    } else {
        content = document.getElementById("edit_customer_content");
    }
    $.get("EditCustomer.jsp", {getId: customer_id, module: module}, function (data) {
        content.innerHTML = data;
    });
    modal.style.display = "block";
}

function updateCustomer(module) {
    var customer_id = $('#customer_id').val();
    var edit_salutation = $('#edit_salutation').val();
    var edit_first_name = $('#edit_first_name').val();
    var edit_last_name = $('#edit_last_name').val();
    var edit_contact = $('#edit_contact').val();
    var edit_email = $('#edit_email').val();

    var errorModal;
    var errorStatus;
    var errorMessage;
    if (module === "Lead") {
        errorModal = document.getElementById("lead_customer_error_modal");
        errorStatus = document.getElementById("lead_customer_error_status");
        errorMessage = document.getElementById("lead_customer_error_message");
    } else {
        errorModal = document.getElementById("customer_error_modal");
        errorStatus = document.getElementById("customer_error_status");
        errorMessage = document.getElementById("customer_error_message");
    }
    $.getJSON("EditCustomerController", {customer_id: customer_id, salutation: edit_salutation, firstName: edit_first_name, lastName: edit_last_name, contact: edit_contact, email: edit_email})
            .done(function (data) {
                var status = data.status;
                var errorMsg = data.message;
                errorStatus.innerHTML = status;
                errorMessage.innerHTML = errorMsg;
                errorModal.style.display = "block";
                if (status === "SUCCESS") {
                    if (module === "Lead") {
                        document.getElementById("lead_edit_customer_modal").style.display = "none";
                        $('#customer_id').val(customer_id);
                        $("#customer_salutation").html(edit_salutation);
                        $("#customer_first_name").html(edit_first_name);
                        $("#customer_last_name").html(edit_last_name);
                        $("#customer_contact").html(edit_contact);
                        $("#customer_email").html(edit_email);
                        $("#customer_name").html(edit_salutation + " " + edit_first_name + " " + edit_last_name)
                        document.getElementById("cust_btn_input").innerHTML = "<button onclick=\"editCustomer('" + customer_id + "','Lead'); return false;\" class=\"btn btn-default\">Edit</button>";
                    } else {
                        document.getElementById("edit_customer_modal").style.display = "none";
                        window.onbeforeunload = function () {
                            sessionStorage.setItem("customer_search", $('#customer_search').val());
                        }
                        $.get("SearchCustomersByName.jsp", {getName: "", getAction: module}, function (data) {
                            var content = document.getElementById("customer_content_header");
                            content.innerHTML = data;
                            $('.javascript').each(function () {
                                eval($(this).text());
                            });
                        });
                    }

                    setTimeout(function () {
                        errorModal.style.display = "none";
                    }, 500);
                }
            })
            .fail(function (error) {
                errorStatus.innerHTML = "ERROR";
                errorMessage.innerHTML = error;
                errorModal.style.display = "block";
            });
}

function reload() {
    var customer_search = sessionStorage.getItem("customer_search");
    if (customer_search !== null) {
        $('#customer_search').val(customer_search);
        sessionStorage.removeItem("customer_search");
        customerSearch("crm");
    }
}