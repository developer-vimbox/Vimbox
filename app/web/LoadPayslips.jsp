<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.vimbox.user.User"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.database.PayslipDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.vimbox.hr.Payslip"%>
<%@page import="java.util.ArrayList"%>
<style type="text/css"> .javascript { display: none; } </style>
 <div class="javascript">
<script type="text/javascript" src="assets/widgets/datatable/datatable.js"></script>
<script type="text/javascript" src="assets/widgets/datatable/datatable-bootstrap.js"></script>
<script type="text/javascript" src="assets/widgets/datatable/datatable-tabletools.js"></script>
<script type="text/javascript">

    /* Datatables basic */

    $(document).ready(function() {
        $('#payslipsTable').dataTable();
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
    String keyword = request.getParameter("keyword");
    ArrayList<Payslip> results = new ArrayList<Payslip>();
    results = PayslipDAO.getSearchPayslips(keyword);

    if (!keyword.isEmpty()) {
        if (results.size() > 1) {
            out.println(results.size() + " results found");
        } else if (results.size() == 1) {
            out.println("1 result found");
        } else {
            out.println("No results found");
        }
        out.println("<br><br>");
    }
%>

<table class="table table-hover" id="payslipsTable">
    <col width="20%">
    <col width="20%">
    <col width="20%">
    <col width="15%">
    <col width="25%">
    <thead>
    <tr>
        <th>Payslip ID</th>
        <th>NRIC</th>
        <th>Employee Name</th>
        <th>Pay Month</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <%
        for (Payslip payslip : results) {
            User employee = payslip.getUser();
            out.println("<tr>");
            out.println("<td align='center'>" + payslip.getPayslip_id() + "</td>");
            out.println("<td align='center'>" + employee.getNric() + "</td>");
            out.println("<td align='center'>" + employee + "</td>");
            out.println("<td align='center'>" + Converter.convertYearMonthPayslip(payslip.getStartDate()) + "</td>");
    %>
    <td>
        <button class="btn btn-default" onclick="editPayslip('<%=employee.getNric() + ":" + Converter.convertDateDatabase(payslip.getStartDate())%>')">Edit</button>
        <button class="btn btn-default" onclick="viewPayslip('<%=employee.getNric() + ":" + Converter.convertDateDatabase(payslip.getStartDate())%>')">View</button>
        <form method="post" class="btn" style="
    padding-left: 0px;
    padding-right: 0px;
    border-left-width: 0px;
    border-right-width: 0px;
    border-top-width: 0px;
    border-bottom-width: 0px;
">
            <input type="hidden" name="payslip_id" value="<%=payslip.getPayslip_id()%>">
            <input class="btn btn-default" type="submit" value="PDF" formaction="payslips/<%=employee.getNric()%>" formtarget="_blank">
        </form>
        <button class="btn btn-default" onclick="confirmDelete('<%=payslip.getPayslip_id()%>', 'payslip')">Delete</button>
        </td>
    <%
            out.println("</tr>");
        }
    %>
</tbody>
</table>
<div id="edit_payslip_modal" class="modal">
    <div class="modal-content" style="width: 800px;">
        <div class="modal-header">
            <span class="close" onclick="closeModal('edit_payslip_modal')">×</span>
            <center><h2>Edit Payslip</h2></center>
        </div>
        <div class="modal-body">
            <div id="edit_payslip_content"></div>
        </div>
    </div>
</div>
<div id="viewPayslipModal" class="modal">
    <div class="modal-content" style="width: 900px;">
        <div class="modal-header">
            <span class="close" onclick="closeModal('viewPayslipModal')">×</span>
            <center><h2>View Payslip</h2></center>
        </div>
        <div class="modal-body">
            <div id="viewPayslipContent"></div>
        </div>
    </div>
</div>
<div id="payslip_error_modal" class="modal">
    <div class="modal-content" style="width: 400px;">
        <div class="modal-header">
            <span class="close" onclick="closeModal('payslip_error_modal')">×</span>
            <center><h2><div id="payslip_error_status"></div></h2></center>
        </div>
        <div class="modal-body">
            <div id="payslip_error_message"></div>
        </div>
    </div>
</div>
