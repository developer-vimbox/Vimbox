<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.LeadPopulationDAO"%>
<%
    ArrayList<String> moveTypeList = LeadPopulationDAO.getMoveTypes();
%>
<table class="table table-hover">
    <th>Move Type</th>
    <th>Delete</th>
        <%
            for (String type : moveTypeList) {
        %>
    <tr>
        <td><%=type%></td>
        <td><button class="btn btn-sm btn-warning" id='del_moveType'type="button" value=<%=type%> onclick="deleteMoveType('<%=type%>')">x</button></td>
    </tr>
    <%
        }
    %>
</table>




