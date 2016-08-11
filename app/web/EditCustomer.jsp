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
            if (customer.getContact() > 0) {
                contact = customer.getContact() + "";
            }
        %>
        <input type="hidden" id="customer_id" value="<%=customer_id%>"> 
        <div class="form-horizontal">
            <div class="form-group">
                <label class="col-sm-3 control-label">Salutation: </label>
                <div class="col-sm-6">
                    <select id="edit_salutation" autofocus class="form-control">
                        <%                        String[] salutations = {"Mr", "Ms", "Mrs", "Mdm"};
                            for (String salutation : salutations) {
                                if (salutation.equals(customer.getSalutation())) {
                                    out.println("<option value='" + salutation + "' selected>" + salutation + "</option>");
                                } else {
                                    out.println("<option value='" + salutation + "'>" + salutation + "</option>");
                                }
                            }

                        %>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">First Name: </label>
                <div class="col-sm-6">
                    <input type="text" class="form-control" id="edit_first_name" value="<%=customer.getFirst_name()%>" required>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Last Name: </label>
                <div class="col-sm-6">
                    <input type="text" class="form-control" id="edit_last_name" value="<%=customer.getLast_name()%>" required>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Customer's Contact: </label>
                <div class="col-sm-6">
                    <input type="number" class="form-control" id="edit_contact" value="<%=contact%>">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Email: </label>
                <div class="col-sm-6">
                    <input type="text" class="form-control" id="edit_email" value="<%=customer.getEmail()%>">
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label"></label>
                <div class="col-sm-6 text-center">
                    <button onclick="updateCustomer(); return false;" class="btn btn-primary">Edit</button>
                </div>
            </div>
        </div>
    </body>
</html>
