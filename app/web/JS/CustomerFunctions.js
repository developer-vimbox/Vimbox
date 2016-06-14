function addCustomer() {
    var modal = document.getElementById("csModal");
    var csStatus = document.getElementById("csStatus");
    var csMessage = document.getElementById("csMessage");

    var name = document.getElementById("name").value;
    if (name.length === 0 || !name.trim()) {
        csStatus.innerHTML = "<b>ERROR</b>";
        csMessage.innerHTML = "Please enter a customer name";
    } else {
        name = document.getElementById("salutation").value + " " + name;
        var contact = document.getElementById("contact").value;
        var email = document.getElementById("email").value;
        if (contact.trim().length != 0 || email.trim().length != 0) {
            var contactB = true;
            var emailB = true;
            var errorMsg = "";
            if (contact.trim().length != 0) {
                if (isNaN(contact) || !/^[0-9]{8,20}$/.test(contact)) {
                    contactB = false;
                    errorMsg += "Invalid contact<br>";
                }
            }

            if (email.trim().length != 0) {
                if (email.indexOf("@") === -1) {
                    emailB = false;
                    errorMsg += "Invalid email<br>";
                }
            }

            if (!contactB || !emailB) {
                csStatus.innerHTML = "<b>ERROR</b>";
                csMessage.innerHTML = errorMsg;
            } else {
                $.getJSON('CreateCustomerController', {getName: name, getContact: contact, getEmail: email}, function (data) {
                    var status = data.status;
                    var message = data.message;
                    var custId = data.custId;
                    document.getElementById("custId").value = custId;
                    csStatus.innerHTML = "<b>" + status + "</b>";
                    csMessage.innerHTML = message;
                    
                });
            }
        } else {
            csStatus.innerHTML = "<b>ERROR</b>";
            csMessage.innerHTML = "Please enter a contact or email";
        }
    }
    modal.style.display = "block";
}

function searchName() {
    var modal = document.getElementById("snModal");
    var name = document.getElementById("name").value;
    var snContent = document.getElementById("snContent");
    $.get("SearchCustomersByName.jsp", {getName: name, getAction: "ticket"}, function (data) {
        snContent.innerHTML = data;
    });
    modal.style.display = "block";
}
function selectCustomer(custid, custname, custcontact, custemail) {
    var salutation = document.getElementById("salutation");
    var name = document.getElementById("name");
    var contact = document.getElementById("contact");
    var cId = document.getElementById("custId");
    var email = document.getElementById("email");

    salutation.value = custname.substring(0,custname.indexOf(" "));
    name.value = custname.substring(custname.indexOf(" ") + 1);
    contact.value = custcontact;
    cId.value = custid;
    email.value = custemail;

    closeModal("snModal");
}