<%@page import="com.vimbox.customer.Customer"%>
<%@page import="com.vimbox.user.User"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.database.TicketDAO"%>
<%@page import="com.vimbox.ticket.Ticket"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.CustomerHistoryDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Tickets History</title>
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
        $('#ticketsHistoryTable').dataTable();
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
            String custId = request.getParameter("getId");
            ArrayList<Integer> ids = CustomerHistoryDAO.getCustomerTicketIds(Integer.parseInt(custId));
            if (ids.isEmpty()) {
        %>
        No results found
        <%
        } else {
            if (ids.size() == 1) {
                out.println(ids.size() + " record found");
            } else {
                out.println(ids.size() + " records found");
            }
            ArrayList<Ticket> tickets = new ArrayList<Ticket>();
            for (int id : ids) {
                tickets.add(TicketDAO.getTicketById(id));
            }
        %>
        <br><br>
        <table class="table table-hover" id="ticketsHistoryTable">
            <thead>
            <tr>
                <th>Ticket ID</th>
                <th>Name</th>
                <th>Contact</th>
                <th>Email</th>
                <th>Subject</th>
                <th>Date & Time</th>
                <th>Status</th>
                <th>View</th>
            </tr>
            </thead>
            <tbody>
            <%
                for (Ticket ticket : tickets) {
                    int ticketId = ticket.getTicket_id();
                    Customer customer = ticket.getCustomer();
                    String customerName = customer.toString();
                    String contact = customer.getContact() + "";
                    if (contact.equals("0")) {
                        contact = "N/A";
                    }
                    String email = customer.getEmail();
                    if (email.isEmpty()) {
                        email = "N/A";
                    }
                    String subject = ticket.getSubject();
                    String dateTime = Converter.convertDate(ticket.getDatetime_of_creation());
                    String status = ticket.getStatus();
            %>
            <tr>
                <td><%=ticketId%></td>
                <td><%=customerName%></td>
                <td><%=contact%></td>
                <td><%=email%></td>
                <td><%=subject%></td>
                <td><%=dateTime%></td>
                <td><%=status%></td>
                <td>
                    <button class="btn btn-default" onclick="viewTicket('<%=ticketId%>')">VT</button>
                    <button class="btn btn-default" onclick="viewComments('<%=ticketId%>')">VC</button>

                </td>
            </tr>
            <%
                    }
                }
            %>
            </tbody>
        </table>
        <div id="viewTicketModal" class="modal">
            <div class="modal-content" style="width: 500px;">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('viewTicketModal')">×</span>
                    <center><h2>Ticket Details</h2></center>
                </div>
                <div class="modal-body">
                    <div id="viewTicketModalContent"></div> 
                </div>
            </div>
        </div>
        <div id="viewCommentsModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('viewCommentsModal')">×</span>
                    <center><h2>Comments History</h2></center>
                </div>
                <div class="modal-body">
                    <div id="commentsContent"></div> 
                </div>
            </div>
        </div>
    </body>
</html>
