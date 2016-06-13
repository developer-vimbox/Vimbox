<%@include file="ValidateLogin.jsp"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Change Password</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script>src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.2/jquery.min.js"></script>
    </head>
    <body>
        <%
            ServletContext sc = request.getServletContext();
            String errorMsg = (String)sc.getAttribute("errorMsg");
            if(errorMsg!=null){
                sc.removeAttribute("errorMsg");
                switch(errorMsg){
                    case "success":
                        out.println("<h2>SUCCESS!</h2>");
                        out.println("Password has been updated!<br>");
                        break;
                    default:
                        out.println("<h2>ERROR!</h2>");
                        out.println(errorMsg + "<br>");
                }
            }
        
        %>
        <h1>Change Password</h1>
        <form action="ChangePasswordController" method="POST">
            <table>
                <tr>
                    <td align="right">Old password :</td>
                    <td>
                        <input type="password" name="old_password" required autofocus oninvalid="this.setCustomValidity('Please enter your old password')" oninput="setCustomValidity('')">
                    </td>
                </tr>
                <tr>
                    <td align="right">New password :</td>
                    <td>
                        <input type="password" name="new_password" id="new_password" required autofocus oninvalid="this.setCustomValidity('Please enter your new password')" oninput="setCustomValidity('')">
                    </td>
                </tr>
                <tr>
                    <td align="right">Confirm new password :</td>
                    <td>
                        <input type="password" name="confirm_new_password" id="confirm_new_password" required autofocus oninvalid="this.setCustomValidity('Please confirm your new password')" oninput="setCustomValidity('')"><span id="message"></span>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input type="hidden" name="username" value="<%=user.getUsername()%>">
                        <input type="submit" value="Change">
                    </td>
                </tr>
            </table>
        </form>
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
