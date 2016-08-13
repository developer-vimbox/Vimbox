<%@page import="com.vimbox.customer.Customer"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.CustomerDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Customer Search</title>
    </head>
    <body>
        <div class="form-horizontal" >
            <div class="form-group">
                <!--
                <center><h3 class="modal-title"><b>Search Results</b></h3></center>
                <br> -->
                <div class="col-sm-6">
                    <%
                        String name = request.getParameter("getName");
                        String module = request.getParameter("getAction");
                        ArrayList<Customer> results = null;
                        if (module.equals("crm")) {
                            try {
                                int num = Integer.parseInt(name);
                                results = CustomerDAO.getCustomersByContact(num);
                            } catch (NumberFormatException nfe) {
                                results = CustomerDAO.getCustomersByString(name);
                            }
                        } else {
                            results = CustomerDAO.getCustomersByName(name);
                            out.println("<button class=\"btn btn-default\"onclick='addNewCustomer();return false;'>Add New</button>");
                        }
                    %>
                </div>
            </div>
        </div>
        <font>
        <%
            if (results.isEmpty()) {
                out.println("No results found");
            } else {
                if (results.size() == 1) {
                    out.println(results.size() + " record found");
                } else {
                    out.println(results.size() + " records found");
                }
        %>
        <br><br>
        <div id="resultsTable">
            <table class="table table-hover">
                <tr>
                    <th>Name</th>
                    <th>Contact</th>
                    <th>Email</th>
                    <th>Action</th>
                </tr>
                <%
                    for (Customer customer : results) {
                        int custId = customer.getCustomer_id();
                        String saluation = customer.getSalutation();
                        String firstName = customer.getFirst_name();
                        String lastName = customer.getLast_name();
                        String customerName = customer.toString();
                        int contact = customer.getContact();
                        String customerContact = "";
                        if (contact != 0) {
                            customerContact = contact + "";
                        }
                        String customerEmail = customer.getEmail();
                %>
                <tr>
                    <td><%=customerName%></td>
                    <td><%=customerContact%></td>
                    <td><%=customerEmail%></td>
                    <td>
                        <%
                            if (module.equals("ticket")) {
                        %>            
                        <button class="btn btn-default" onclick="selectCustomer('<%=custId%>', '<%=saluation%>', '<%=firstName%>', '<%=lastName%>', '<%=customerContact%>', '<%=customerEmail%>');
                                return false;">Select</button>
                        <%
                        } else {
                        %>
                        <button onclick="editCustomer(<%=custId%>)" class="btn btn-default">Edit</button>
                        <button onclick="viewLeadsHistory('<%=custId%>')" class="btn btn-default">VS</button>
                        <button onclick="viewTicketsHistory('<%=custId%>')" class="btn btn-default">VT</button>
                        <%
                            }
                        %>
                    </td>
                </tr>
                <%
                    }
                %>
            </table>
        </div>
        <%
            }
        %>
        </font>
    </body>
</html>
