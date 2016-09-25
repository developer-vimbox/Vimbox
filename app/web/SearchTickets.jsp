<%@page import="com.vimbox.customer.Customer"%>
<%@page import="com.vimbox.user.User"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.database.TicketDAO"%>
<%@page import="org.joda.time.format.DateTimeFormatter"%>
<%@page import="org.joda.time.format.DateTimeFormat"%>
<%@page import="org.joda.time.DateTime"%>
<%@page import="com.vimbox.ticket.Ticket"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ticket Results</title>
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
        $('#pendingTicketTable').dataTable();
        $('#resolvedTicketTable').dataTable();
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
        <%
            String keyword = request.getParameter("getKeyword");
            String status = request.getParameter("getStatus");
            
            ArrayList<Ticket> results = null;
            int num = 0;
            String string = "";
            DateTime dt = null;
            
            try{
                num = Integer.parseInt(keyword);
            }catch (NumberFormatException nfe){
                try{
                    DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd");
                    dt = formatter.parseDateTime(keyword);
                }catch (IllegalArgumentException iae){
                    string = keyword;
                }
            }
            
            if(num!=0){
                results = TicketDAO.getSearchTicketsByNumber(keyword, status);
            }else if(dt != null){
                results = TicketDAO.getSearchTicketsByDate(keyword, status);
            }else{
                results = TicketDAO.getSearchTicketsByString(keyword, status);
            }
            
            if(!keyword.trim().isEmpty()){
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
                }
            }
            String tableID = "";
            if (status.equals("pending")) {
                tableID = "pendingTicketTable";
            } else {
                tableID = "resolvedTicketTable";
            }
        %>
        <div id="resultsTable">
            <table class="table table-hover" id="<%=tableID%>">
                <thead>
                <tr>
                    <th>Ticket ID</th>
                    <th>Cust Name</th>
                    <th>Cust Contact</th>
                    <th>Cust Email</th>
                    <th>Subject</th>
                    <th>Date & Time</th>
                    <th>Status</th>
                    <th>View</th>
                </tr>
                </thead>
                <tbody>
        <%
            for(Ticket ticket:results){
                int ticketId = ticket.getTicket_id();
                Customer customer = ticket.getCustomer();
                String customerName = customer.toString();
                String contact  = customer.getContact() + "";
                if(contact.equals("0")){
                    contact = "N/A";
                }
                String email = customer.getEmail();
                if(email.isEmpty()){
                    email = "N/A";
                }
                String subject = ticket.getSubject();
                String dateTime = Converter.convertDate(ticket.getDatetime_of_creation());
                String ticket_status = ticket.getStatus();
        %>
                <tr>
                    <td><%=ticketId%></td>
                    <td><%=customerName%></td>
                    <td><%=contact%></td>
                    <td><%=email%></td>
                    <td><%=subject%></td>
                    <td><%=dateTime%></td>
                    <td><%=ticket_status%></td>
                    <td>
                        <button class="btn btn-default " onclick="viewTicket('<%=ticketId%>')">VT</button>
                        <button class="btn btn-default " onclick="viewComments('<%=ticketId%>')">VC</button>
                    </td>
                </tr>
        <%
            }
        %>
                </tbody>
            </table>
        </div>
    </body>
</html>
