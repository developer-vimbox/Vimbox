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
        <style type="text/css"> .javascript { display: none; } </style>
 <div class="javascript">
<script type="text/javascript" src="assets/widgets/datatable/datatable.js"></script>
<script type="text/javascript" src="assets/widgets/datatable/datatable-bootstrap.js"></script>
<script type="text/javascript" src="assets/widgets/datatable/datatable-tabletools.js"></script>
<script type="text/javascript">

    /* Datatables basic */

    $(document).ready(function() {
        $('#custSearchTable').dataTable();
        $('#crmSearchTable').dataTable();
    });

    /* Datatables hide columns */

    $(document).ready(function() {
        var table = $('#datatable-hide-columns').DataTable( {
            "scrollY": "300px",
            "paging": false
        } );

        $('#datatable-hide-columns_filter').hide();

        $('a.toggle-vis').on( 'click', function (e) {
            e.preventDefault();

            // Get the column API object
            var column = table.column( $(this).attr('data-column') );

            // Toggle the visibility
            column.visible( ! column.visible() );
        } );
    } );

    /* Datatable row highlight */

    $(document).ready(function() {
        var table = $('#datatable-row-highlight').DataTable();

        $('#datatable-row-highlight tbody').on( 'click', 'tr', function () {
            $(this).toggleClass('tr-selected');
        } );
    });



    $(document).ready(function() {
        $('.dataTables_filter input').attr("placeholder", "Search...");
    });

</script>
 </div>
        <div class="form-horizontal" >
            <div class="form-group">
                <div class="col-sm-6">
                    <%
                        String name = request.getParameter("getName");
                        String module = request.getParameter("getAction");
                        String tableID = "";
                        ArrayList<Customer> results = null;
                        if (module.equals("crm")) {
                            tableID = "crmSearchTable";
                            try {
                                int num = Integer.parseInt(name);
                                results = CustomerDAO.getCustomersByContact(num);
                            } catch (NumberFormatException nfe) {
                                results = CustomerDAO.getCustomersByString(name);
                            }
                        } else {
                            tableID = "custSearchTable";
                            results = CustomerDAO.getCustomersByName(name);
                            out.println("<button class=\"btn btn-info\"onclick='addNewCustomer();return false;'>Add New</button>");
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
//                if (results.size() == 1) {
//                    out.println(results.size() + " record found");
//                } else {
//                    out.println(results.size() + " records found");
//                }
        %>
        <div id="resultsTable">
            <table class="table table-hover" id="<%=tableID%>">
                <thead>
                <tr>
                    <th>Name</th>
                    <th>Contact</th>
                    <th>Email</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
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
                        <button onclick="editCustomer('<%=custId%>','<%=module%>')" class="btn btn-default">Edit</button>
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
                </tbody>
            </table>
        </div>
        <%
            }
        %>
        </font>
    </body>
</html>
