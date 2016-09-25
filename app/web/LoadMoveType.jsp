<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.LeadPopulationDAO"%>
<style type="text/css"> .javascriptMove { display: none; } </style>
 <div class="javascriptMove">
<script type="text/javascript" src="assets/widgets/datatable/datatable.js"></script>
<script type="text/javascript" src="assets/widgets/datatable/datatable-bootstrap.js"></script>
<script type="text/javascript" src="assets/widgets/datatable/datatable-tabletools.js"></script>
<script type="text/javascript">

    /* Datatables basic */

    $(document).ready(function() {
        $('#moveTypeTable').dataTable();
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
    ArrayList<String[]> moveTypeList = LeadPopulationDAO.getMoveTypes();
%>
<table class="table table-hover" id="moveTypeTable">
    <thead>
        <tr>
    <th>Move Type</th>
    <th>Abbreviation</th>
    <th>Delete</th>
        </tr>
</thead>
<tbody>
        <%
            for (String[] type : moveTypeList) {
        %>
    <tr>
        <td><%=type[0]%></td>
        <td><%=type[1]%></td>
        <td><button class="btn btn-sm btn-warning" id='del_moveType'type="button" value=<%=type[0]%> onclick="deleteMoveType('<%=type[0]%>')">x</button></td>
    </tr>
    <%
        }
    %>
</tbody>
</table>