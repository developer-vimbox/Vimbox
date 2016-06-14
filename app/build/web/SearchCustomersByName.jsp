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
        <h2>Search Results</h2><hr>
        <%
            String name = request.getParameter("getName");
            String module = request.getParameter("getAction");
            ArrayList<Customer> results = null;
            if(module.equals("crm")){
                try{
                    int num = Integer.parseInt(name);
                    results = CustomerDAO.getCustomersByNumber(num);
                }catch (NumberFormatException nfe){
                    results = CustomerDAO.getCustomersByString(name);
                }
            }else{
               results = CustomerDAO.getCustomersByName(name);
            }
             
            if(results.isEmpty()){  
        %>
            No results found
        <%
            }else{
                if(results.size()==1){
                    out.println(results.size() + " record found");
                }else{
                    out.println(results.size() + " records found");
                }
        %>
        <br><br>
        <div id="resultsTable">
            <table border="1" width="100%">
                <tr>
                    <th>Name</th>
                    <th>Contact</th>
                    <th>Email</th>
                    <th>Action</th>
                </tr>
        <%
                for(Customer customer:results){
                    int custId = customer.getId();
                    String customerName = customer.getName();
                    String customerContact = customer.getContact();
                    String customerEmail = customer.getEmail();
        %>
                <tr>
                    <td><%=customerName%></td>
                    <td><%=customerContact%></td>
                    <td><%=customerEmail%></td>
                    <td>
        <%
                    if(module.equals("ticket")){
        %>            
                        <button onclick="selectCustomer('<%=custId%>','<%=customerName%>','<%=customerContact%>','<%=customerEmail%>');return false;">Select</button>
        <%
                    }else{
        %>
                        <input type="button" value="Edit" onclick="window.location.href='EditCustomer.jsp?getId=<%=custId%>&getName=<%=customerName%>&getContact=<%=customerContact%>&getEmail=<%=customerEmail%>'">
                        <button>VS</button>
                        <button onclick="viewTicketsHistory('<%=custId%>')">VT</button>
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
    </body>
</html>
