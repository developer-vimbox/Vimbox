<%@page import="java.text.DecimalFormat"%>
<%@page import="com.vimbox.user.Bank"%>
<%@page import="com.vimbox.user.Emergency"%>
<%@page import="com.vimbox.user.Contact"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.database.UserDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.user.User"%>
<style type="text/css"> .javascript { display: none; } </style>
 <div class="javascript">
<script type="text/javascript" src="assets/widgets/datatable/datatable.js"></script>
<script type="text/javascript" src="assets/widgets/datatable/datatable-bootstrap.js"></script>
<script type="text/javascript" src="assets/widgets/datatable/datatable-tabletools.js"></script>
<script type="text/javascript">

    /* Datatables basic */

    $(document).ready(function() {
        $('#employeesTable').dataTable();
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
    String timer = request.getParameter("timer");
    ArrayList<User> users = new ArrayList<User>();
    if (timer.equals("full-time")) {
        users = UserDAO.getFullTimeUsersByKeyword(keyword);
    } else {
        users = UserDAO.getPartTimeUsersByKeyword(keyword);
    }
    if (!keyword.isEmpty()) {
        if (users.size() > 1) {
            out.println(users.size() + " results found");
        } else if (users.size() == 1) {
            out.println("1 result found");
        } else {
            out.println("No results found");
        }
        out.println("<br><br>");
    }
%>
<table class="table table-hover" id="employeesTable">
    <thead>
        <tr>
            <th>NRIC</th>
            <th>Name</th>
            <th>Date Joined</th>
            <th>Department</th>
            <th>Designation</th>
            <th>Action</th>
        </tr>
    </thead>
    <tbody>
    <%
        DecimalFormat df = new DecimalFormat("#.0");
        for (User user : users) {
    %>
        <tr>
            <td align="center"><%=user.getNric()%></td>
            <td align="center"><%=user%></td>
            <td align="center"><%=Converter.convertDateHtml(user.getDate_joined())%></td>
            <td align="center"><%=user.getDepartment()%></td>
            <td align="center"><%=user.getDesignation()%></td>
            <td>
                <button class="btn btn-default" onclick="editEmployee('<%=user.getNric()%>')">Edit</button>
                <button class="btn btn-default" onclick="viewEmployee('<%=user.getNric()%>')">View</button>
                <button class="btn btn-default" onclick="loadLeaveMCNric('<%=user.getNric()%>')">L & MC</button>
            </td>
        </tr>
    <%
        }
    %>
    </tbody>
</table>