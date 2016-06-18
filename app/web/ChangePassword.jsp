<%@include file="ValidateLogin.jsp"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Change Password</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/UserFunctions.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
    </head>
    <body>
        <%
            String nric = user.getNric();
        %>
        <h1>Change Password</h1>
        <input type="hidden" id="user_id" value="<%=nric%>">
        <table>
            <tr>
                <td align="right">Old password :</td>
                <td>
                    <input type="password" id="old_password" autofocus>
                </td>
            </tr>
            <tr>
                <td align="right">New password :</td>
                <td>
                    <input type="password" id="new_password">
                </td>
            </tr>
            <tr>
                <td align="right">Confirm new password :</td>
                <td>
                    <input type="password" id="confirm_new_password"><span id="message"></span>
                </td>
            </tr>
            <tr>
                <td></td>
                <td><button onclick="changePassword()">Change</button></td>
            </tr>
        </table>
                        
        <div id="messageModal" class="modal">
            <div class="message-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('messageModal')">×</span>
                    <div id="message-status"></div>
                    <hr>
                    <div id="message-content"></div>
                </div>
            </div>
        </div>
        <script>
            $('#confirm_new_password').on('keyup', function () {
                if ($(this).val() == $('#new_password').val()) {
                    $('#confirm_new_password').css('border-color', 'lime');
                    $('#message').html("");
                } 
                else{
                    $('#confirm_new_password').css('border-color', 'red');
                    $('#message').html("Passwords don\'t match");
                }
            });
        </script>
    </body>
</html>
