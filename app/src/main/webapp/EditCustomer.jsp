<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Customer</title>
    </head>
    <body>
        <%
            String name = "";
            String contact = "";
            String email = "";
            String custId = "";
            
            ServletContext sc = request.getServletContext();
            String errorMsg = (String) sc.getAttribute("errorMsg");
            if (errorMsg != null) {
                sc.removeAttribute("errorMsg");
                out.println("<h2>ERROR!</h2>");
                out.println(errorMsg + "<br>");
                name = (String) sc.getAttribute("name");
                contact = (String) sc.getAttribute("contact");
                email = (String) sc.getAttribute("email");
                custId = (String) sc.getAttribute("custId");
                sc.removeAttribute("name");
                sc.removeAttribute("contact");
                sc.removeAttribute("custId");
                sc.removeAttribute("email");
            } else {
                name = request.getParameter("getName");
                contact = request.getParameter("getContact");
                custId = request.getParameter("getId");;
                email = request.getParameter("getEmail");
            }
        %>
        <h2>Customer Details</h2><hr>
        <form action="EditCustomerController">
            <table>
                <tr>
                    <td align="right">Name :</td>
                    <td>
                        <input type="text" name="name" value="<%=name%>" required>
                    </td>
                </tr>
                <tr>
                    <td align="right">Contact :</td>
                    <td>
                        <input type="text" name="contact" value="<%=contact%>" pattern="[0-9]{8,13}" autofocus oninvalid="this.setCustomValidity('Please enter a valid contact number')" oninput="setCustomValidity('')">
                        <input type="hidden" name="custId" value="<%=custId%>">
                    </td>
                </tr>
                <tr>
                    <td align="right">Email :</td>
                    <td>
                        <input type="text" name="email" value="<%=email%>">
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input type="submit" value="Edit">
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>
