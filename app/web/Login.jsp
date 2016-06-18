<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Vimbox</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <script src="JS/UserFunctions.js"></script>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
    </head>
    <body>
        <table>
            <tr>
                <td>Username :</td>
                <td><input type="text" id="username"></td>
            </tr>

            <tr>
                <td>Password :</td>
                <td><input type="password" id="password"></td>
            </tr>

            <tr>
                <td></td>
                <td><button onclick="login()">Login</button></td>
            </tr>
        </table>

        <div id="messageModal" class="modal">
            <!-- Modal content -->
            <div class="message-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('messageModal')">×</span>
                    <div id="message-status"></div>
                    <hr>
                    <div id="message-content"></div>
                </div>
            </div>
        </div>
    </body>
</html>
