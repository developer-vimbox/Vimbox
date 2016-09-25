<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.LeadPopulationDAO"%>
<style type="text/css"> .javascriptSvc { display: none; } </style>
 <div class="javascriptSvc">
<script type="text/javascript" src="assets/widgets/datatable/datatable.js"></script>
<script type="text/javascript" src="assets/widgets/datatable/datatable-bootstrap.js"></script>
<script type="text/javascript" src="assets/widgets/datatable/datatable-tabletools.js"></script>
<script type="text/javascript">

    /* Datatables basic */

    $(document).ready(function() {
        $('#serviceTypeTable').dataTable();
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
    ArrayList<String> svcList = LeadPopulationDAO.getAllServices();
%>

<table class="table table-hover" id="serviceTypeTable">
    <thead>
    <th>Primary</th>
    <th>Secondary</th>
    <th>Formula</th>
    <th>Description</th>
    <th>Delete</th>
</thead>
<tbody>
    <%            for (int i = 0; i < svcList.size(); i += 4) {
            String primary = svcList.get(i);
            String secondary = svcList.get(i + 1);
            String formula = svcList.get(i + 2);
            String description = svcList.get(i + 3);
            String value = primary + "@" + secondary;

    %>
    <tr>
        <td><%=primary%></td>
        <td><%=secondary%></td>
        <td><%=formula%></td>
        <td><%=description%></td>
        <td><button class="btn btn-sm btn-warning" id='del_svcType' value=<%=value%> onclick="deleteSvcType('<%=value%>')">x</button></td>
    </tr>
    <%
        }
    %>
</tbody>
</table>