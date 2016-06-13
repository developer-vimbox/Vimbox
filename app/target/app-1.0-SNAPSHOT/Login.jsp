<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Vimbox</title>
    </head>
    <body>
        <%
            ServletContext sc = request.getServletContext();
            String errorMsg = (String)sc.getAttribute("errorMsg");
            if (errorMsg != null) {
                out.println("<h1> Error : " + errorMsg + "</h1>");
                sc.removeAttribute("errorMsg");
            }
        %>

        <form action="LC" method="post">
            <table>
                <tr>
                    <td>Username :</td>
                    <td><input type="text" name="username"></td>
                </tr>
                
                <tr>
                    <td>Password :</td>
                    <td><input type="password" name="password"></td>
                </tr>
                
                <tr>
                    <td></td>
                    <td><input type="submit" name="submit" value="Login"></td>
                </tr>
            </table>
        </form>
    </body>
</html>
