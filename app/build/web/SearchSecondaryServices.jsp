<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.LeadPopulationDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Secondary Services</title>
    </head>
    <body>
        <b><u>Secondary Services</u></b>
                <%
                    String service = request.getParameter("getSecSvc");
                    ArrayList<String> secondaryServices = LeadPopulationDAO.getSecondaryServices(service);
                %>
        <table width="100%">
            <tr>
                <td>
                    <%
                        for (String secService : secondaryServices) {
                            out.println(secService + " <input type='checkbox' name='secservices' value='" + service + "|" + secService + "' onclick='checkSecSvc(this)'>");
                        }
                    %>
                </td>
            </tr>
        </table>
        <table>
            <col width="80">
            <tr>
                <td align="right">Required Manpower :</td>
                <td>
                    <input type="number" name="requiredmanpower" id="requiredmanpower">
                </td>
            </tr>
            <tr>
                <td align="right">Reason :</td>
                <td>
                    <input type="text" size="40" id="manpowerreason" name="manpowerreason" placeholder="Enter reason">
                </td>
            </tr>
        </table>
    </body>
</html>
