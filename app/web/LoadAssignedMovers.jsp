<%@page import="com.vimbox.user.Contact"%>
<%@page import="com.vimbox.user.User"%>
<%@page import="com.vimbox.database.OperationsDAO"%>
<%@page import="java.util.ArrayList"%>
<%
    String dom = request.getParameter("getDOM");
    String supervisor = request.getParameter("getSupervisor");
    
    ArrayList<User> movers = OperationsDAO.getMoversAssigned(dom);
    if (movers.isEmpty()) {
        out.println("No movers assigned");
    } else {
%>
<table class="table table-hover">
    <thead><tr>
        <th>S/N</th>
        <th>Mover's NRIC</th>
        <th>Mover's Name</th>
        <th>Mover's Contact</th>
        <th>Action</th>
        </tr></thead>
<%
        int count = 1;
        for(User u : movers) {
            String ic = u.getNric();
            String name = u.toString();
            Contact contact = u.getContact();
            int c = contact.getPhone();
%>
<tr>
    <td><%=count%></td>
    <td><%=ic%></td>
    <td><%=name%></td>
    <td><%=c%></td>
    <td>
        <button class="btn btn-sm btn-warning" onclick="removeMover('<%=ic%>')">Remove</button>
    </td>
</tr>
<%
        count++;
        }
%>
</table>
<%
    }
%>