<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.LeadPopulationDAO"%>
<%
    ArrayList<String[]> moveTypeList = LeadPopulationDAO.getMoveTypes();
%>
<table class="table table-hover">
    <th>Move Type</th>
    <th>Abbreviation</th>
    <th>Delete</th>
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
</table>




