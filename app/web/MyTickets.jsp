<%@page import="com.vimbox.customer.Customer"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.database.TicketDAO"%>
<%@page import="com.vimbox.ticket.Ticket"%>
<%@page import="java.util.ArrayList"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Tickets</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <script src="JS/TicketFunctions.js"></script>
        <script src="JS/CustomerFunctions.js"></script>
        <script src="JS/LeadFunctions.js"></script>
    </head>
    <body>
        <%@include file="header.jsp"%>

<script type="text/javascript">

    /* Datatables basic */

    $(document).ready(function() {
        $('#myTicketsTable').dataTable();
        $('#assignedTicketsTable').dataTable();
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
        <%            ArrayList<Ticket> myTickets = TicketDAO.getTicketsByOwnerUser(user);
            ArrayList<Ticket> assignedTickets = TicketDAO.getTicketsByAssignedUser(user);

        %>
        <div class="modal" id="viewTicketModal">
            <div class="modal-content">
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

        <div id="page-content-wrapper">
            <div id="page-content" style="min-height: 545px;">
                <div class="container">
                    <div id="page-title">
                        <h2>My Tickets</h2> <br/>
                        <div class="panel">
                            <div class="panel-body">
                                <div class="example-box-wrapper">
                                    <ul class="nav-responsive nav nav-tabs">
                                        <li class="active"><a href="#myTickets" data-toggle="tab">My Tickets</a></li>
                                        <li><a href="#assignedTickets" data-toggle="tab">Assigned Tickets</a></li>
                                    </ul>
                                    <div class="tab-content">
                                        <div id="myTickets" class="tab-pane active">
                                            <table class="table table-hover" id="myTicketsTable">
                                                <thead>
                                                    <tr>
                                                        <th>Ticket ID</th>
                                                        <th>Cust Name</th>
                                                        <th>Cust Contact</th>
                                                        <th>Cust Email</th>
                                                        <th>Subject</th>
                                                        <th>Date & Time</th>
                                                        <th>Edited on</th>
                                                        <th>Status</th>
                                                        <th>Action</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%                                for (Ticket myTicket : myTickets) {
                                                            int ticketId = myTicket.getTicket_id();
                                                            Customer customer = myTicket.getCustomer();
                                                            String customerName = customer.toString();
                                                            String contact = customer.getContact() + "";
                                                            if (contact.equals("0")) {
                                                                contact = "N/A";
                                                            }
                                                            String email = customer.getEmail();
                                                            if (email.isEmpty()) {
                                                                email = "N/A";
                                                            }
                                                            String subject = myTicket.getSubject();
                                                            String dateTime = Converter.convertDate(myTicket.getDatetime_of_creation());
                                                            String edited = Converter.convertDate(myTicket.getDatetime_of_edit());
                                                            String status = myTicket.getStatus();
                                                    %>

                                                    <tr>
                                                        <td><%=ticketId%></td>
                                                        <td><%=customerName%></td>
                                                        <td><%=contact%></td>
                                                        <td><%=email%></td>
                                                        <td><%=subject%></td>
                                                        <td><%=dateTime%></td>
                                                        <td><%=edited%></td>
                                                        <td><%=status%></td>
                                                        <td>
                                                            <%
                                                                if (status.equals("Pending")) {
                                                            %>
                                                            <button class="btn btn-default" onclick="editTicket(<%=ticketId%>)">Edit</button>
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
                                        <div id="edit_ticket_modal" class="modal">
                                            <div class="modal-content" style="width:600px;">
                                                <div class="modal-header">
                                                    <span class="close" onclick="closeModal('edit_ticket_modal')">×</span>
                                                    <center><h2>Edit Ticket</h2></center>
                                                </div>
                                                <div class="modal-body">
                                                    <div id="edit_ticket_content"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="customer_modal" class="modal">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <span class="close" onclick="closeModal('customer_modal')">×</span>
                                                    <center><h2>Select Customer</h2></center>
                                                </div>
                                                <div class="modal-body">
                                                    <br>
                                                    <div id="customer_content"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="add_customer_modal" class="modal">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <span class="close" onclick="closeModal('add_customer_modal')">×</span>
                                                    <center><h2>Add New Customer</h2></center>
                                                </div>
                                                <div class="modal-body">
                                                    <br>
                                                    <div id="add_customer_content"></div>
                                                </div>
                                            </div>
                                        </div>

                                        <div id="customer_error_modal" class="modal">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <span class="close" onclick="closeModal('customer_error_modal')">×</span>
                                                    <center><h2><div id="customer_error_status"></div></h2></center>
                                                </div>
                                                <div class="modal-body">
                                                    <div id="customer_error_message"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="assignedTickets" class="tab-pane">
                                            <table class="table table-hover" id="assignedTicketsTable">
                                                <thead>
                                                <tr>
                                                    <th>Ticket ID</th>
                                                    <th>Cust Name</th>
                                                    <th>Cust Contact</th>
                                                    <th>Cust Email</th>
                                                    <th>Subject</th>
                                                    <th>Date & Time</th>
                                                    <th>Status</th>
                                                    <th>Action</th>
                                                    <th>View</th>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <%
                                                    for (Ticket ticket : assignedTickets) {
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
                                                        <button class="btn btn-default" onclick="commentTicket('<%=ticketId%>')">C</button>
                                                        <!-- The Modal -->
                                                        <div id="commentModal<%=ticketId%>" class="modal">
                                                            <!-- Modal content -->
                                                            <div class="modal-content" style="width: 450px;">
                                                                <div class="modal-header">
                                                                    <span class="close" onclick="closeModal('commentModal<%=ticketId%>')">×</span>
                                                                    <center><h2>Add Comment</h2></center>
                                                                </div>
                                                                <div class="modal-body">
                                                                    <br>
                                                                    <div class="form-horizontal">
                                                                        <div class="form-group">
                                                                            <label class="col-sm-3 control-label">Ticket ID: </label>
                                                                            <div class="col-sm-7">
                                                                                <label class="form-control"><%=ticketId%></label>
                                                                                <input type="hidden" id="comment_ticket_id<%=ticketId%>" value="<%=ticketId%>" />
                                                                            </div>
                                                                        </div>

                                                                        <div class="form-group">
                                                                            <label class="col-sm-3 control-label">Comment: </label>
                                                                            <div class="col-sm-7">
                                                                                <textarea class="form-control" id="ticket_comment<%=ticketId%>" cols="30" rows="6" autofocus></textarea>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group">
                                                                            <label class="col-sm-3 control-label">  </label>
                                                                            <div class="col-sm-7 text-center">
                                                                                <button class="btn btn-primary" onclick="followupTicket(<%=ticketId%>)">Add Comment</button>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <button class="btn btn-default" onclick="closeTicket('<%=ticketId%>')">R</button>
                                                        <div id="resolveModal<%=ticketId%>" class="modal">
                                                            <div class="modal-content" style="width: 450px;">
                                                                <div class="modal-header">
                                                                    <span class="close" onclick="closeModal('resolveModal<%=ticketId%>')">×</span>
                                                                    <center><h2>Resolve Ticket</h2></center>
                                                                </div>
                                                                <div class="modal-body">
                                                                    <div class="form-horizontal">
                                                                        <div class="form-group">
                                                                            <label class="col-sm-3 control-label">Ticket ID: </label>
                                                                            <div class="col-sm-7">
                                                                                <label class="form-control"><%=ticketId%></label>
                                                                                <input type="hidden" id="resolve_ticket_id<%=ticketId%>" value="<%=ticketId%>" />

                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group">
                                                                            <label class="col-sm-3 control-label">Solution: </label>
                                                                            <div class="col-sm-7">
                                                                                <textarea class="form-control" id="resolve_ticket_solution<%=ticketId%>" cols="75" rows="6" autofocus></textarea>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group">
                                                                            <label class="col-sm-3 control-label">  </label>
                                                                            <div class="col-sm-7 text-center">
                                                                                <button class="btn btn-primary" onclick="resolveTicket(<%=ticketId%>)">Resolve Ticket</button>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>

                                                    <td>
                                                        <button class="btn btn-default" onclick="viewTicket('<%=ticketId%>')">VT</button>
                                                        <button class="btn btn-default" onclick="viewComments('<%=ticketId%>')">VC</button>
                                                    </td>
                                                </tr>
                                                <%
                                                    }
                                                %>
                                                </tbody>
                                            </table>
                                        </div>
                                        <div id="ticket_error_modal" class="modal">
                                            <div class="modal-content" style="width: 400px;">
                                                <div class="modal-header">
                                                    <span class="close" onclick="closeModal('ticket_error_modal')">×</span>
                                                    <center><h2><div id="ticket_error_status"></div></h2></center>
                                                </div>
                                                <div class="modal-body">
                                                    <div id="ticket_error_message"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
