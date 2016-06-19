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

        <h2><font color="white">Search Results</font></h2>
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
                    out.println("<button onclick='addNewCustomer();return false;'>Add New</button>");
                }
            %>
        <font color="white">
        <hr>
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
            <table width="100%" font-color="white">
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
                        <button onclick="selectCustomer('<%=custId%>', '<%=saluation%>', '<%=firstName%>', '<%=lastName%>', '<%=customerContact%>', '<%=customerEmail%>');
                                return false;">Select</button>
                        <%
                        } else {
                        %>
                        <button onclick="editCustomer(<%=custId%>)" class="btn btn-grey">Edit</button>
                        <button onclick="viewLeadsHistory('<%=custId%>')" class="btn btn-grey">VS</button>
                        <button onclick="viewTicketsHistory('<%=custId%>')" class="btn btn-grey">VT</button>
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
