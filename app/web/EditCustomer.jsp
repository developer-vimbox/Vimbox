<%@page import="com.vimbox.customer.Customer"%>
<%@page import="com.vimbox.database.CustomerDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Customer</title>
    </head>
    <body>
        <%
            int customer_id = Integer.parseInt(request.getParameter("getId"));
            Customer customer = CustomerDAO.getCustomerById(customer_id);
            String contact = "";
            if(customer.getContact() > 0){
                contact = customer.getContact() + "";
            }
        %>
        <h2>Customer Details</h2><hr>
        <input type="hidden" id="customer_id" value="<%=customer_id%>"> 
        <table>
            <tr>
                <td align="right"><b>Salutation :</b></td>
                <td>
                    <select id="edit_salutation" autofocus>
                    <%
                        String[] salutations = {"Mr", "Ms", "Mrs", "Mdm"};
                        for(String salutation:salutations){
                            if(salutation.equals(customer.getSalutation())){
                                out.println("<option value='" + salutation + "' selected>" + salutation + "</option>");
                            }else{
                                out.println("<option value='" + salutation + "'>" + salutation + "</option>");
                            }
                        }

                    %>
                    </select>
                </td>
            </tr>
            <tr>
                <td align="right"><b>First Name :</b></td>
                <td>
                    <input type="text" id="edit_first_name" value="<%=customer.getFirst_name()%>" required>
                </td>
            </tr>
            <tr>
                <td align="right"><b>Last Name :</b></td>
                <td>
                    <input type="text" id="edit_last_name" value="<%=customer.getLast_name()%>" required>
                </td>
            </tr>
            <tr>
                <td align="right"><b>Contact :</b></td>
                <td>
                    <input type="number" id="edit_contact" value="<%=contact%>">
                </td>
            </tr>
            <tr>
                <td align="right"><b>Email :</b></td>
                <td>
                    <input type="text" id="edit_email" value="<%=customer.getEmail()%>">
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <button onclick="updateCustomer();return false;">Edit</button>
                </td>
            </tr>
        </table>
    </body>
</html>
