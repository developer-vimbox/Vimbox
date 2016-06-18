function login() {
    var username = $('#username').val();
    var password = $('#password').val();
    
    var modal = document.getElementById("messageModal");
    var msgStatus = document.getElementById("message-status");
    var msgContent = document.getElementById("message-content");
    $.getJSON("LoginController", {username:username, password:password})
            .done(function (data) {
                var status = data.status;
                if (status === "SUCCESS") {
                    $(location).attr('href', 'HomePage.jsp');
                } else {
                    var errorMsg = data.errorMsg;
                    msgStatus.innerHTML = status;
                    msgContent.innerHTML = errorMsg;
                    modal.style.display = "block";
                }
            })
            .fail(function (error) {
                msgStatus.innerHTML = "ERROR";
                msgContent.innerHTML = error;
                modal.style.display = "block";
            });
}

function changePassword(){
    var user_id = $('#user_id').val();
    var old_password = $('#old_password').val();
    var new_password = $('#new_password').val();
    var confirm_new_password = $('#confirm_new_password').val();
    
    var modal = document.getElementById("messageModal");
    var msgStatus = document.getElementById("message-status");
    var msgContent = document.getElementById("message-content");
    $.getJSON("ChangePasswordController", {user_id:user_id, old_password:old_password, new_password:new_password, confirm_new_password:confirm_new_password})
            .done(function (data) {
                var status = data.status;
                var errorMsg = data.errorMsg;
                msgStatus.innerHTML = status;
                msgContent.innerHTML = errorMsg;
                modal.style.display = "block";
                if (status === "SUCCESS") {
                    setTimeout(function() {location.reload()},500);
                } 
            })
            .fail(function (error) {
                msgStatus.innerHTML = "ERROR";
                msgContent.innerHTML = error;
                modal.style.display = "block";
            });
    
}

