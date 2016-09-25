<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.LeadPopulationDAO"%>
<style type="text/css"> .javascriptRef { display: none; } </style>
 <div class="javascriptRef">
<script type="text/javascript" src="assets/widgets/datatable/datatable.js"></script>
<script type="text/javascript" src="assets/widgets/datatable/datatable-bootstrap.js"></script>
<script type="text/javascript" src="assets/widgets/datatable/datatable-tabletools.js"></script>
<script type="text/javascript">

    /* Datatables basic */

    $(document).ready(function() {
        $('#refTypeTable').dataTable();
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

    ArrayList<String> refTypeList = LeadPopulationDAO.getReferrals();

%>
<table class="table table-hover" id="refTypeTable">
    <thead>
    <th>Referral Type</th>
    <th>Delete</th>
</thead>
<tbody>
    <%            for (String type : refTypeList) {

    %>
    <tr>
        <td><%=type%></td>
        <td><button class="btn btn-sm btn-warning" id='del_refType' value=<%=type%> onclick="deleteRefType('<%=type%>')">x</button></td>
    </tr>
    <%
        }
    %>
</tbody>
</table>
