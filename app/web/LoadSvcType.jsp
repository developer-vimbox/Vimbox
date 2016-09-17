<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.LeadPopulationDAO"%>
<%

    ArrayList<String> svcList = LeadPopulationDAO.getAllServices();


%>

<table class="table table-hover">
    <th>Primary</th>
    <th>Secondary</th>
    <th>Formula</th>
    <th>Description</th>
    <th>Delete</th>
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
</table>