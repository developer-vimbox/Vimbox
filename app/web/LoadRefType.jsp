<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.LeadPopulationDAO"%>
<%

    ArrayList<String> refTypeList = LeadPopulationDAO.getReferrals();

%>
<table class="table table-hover">
    <th>Referral Type</th>
    <th>Delete</th>

    <%            for (String type : refTypeList) {

    %>
    <tr>
        <td><%=type%></td>
        <td><button class="btn btn-sm btn-warning" id='del_refType' value=<%=type%> onclick="deleteRefType('<%=type%>')">x</button></td>
    </tr>
    <%
        }
    %>
</table>
