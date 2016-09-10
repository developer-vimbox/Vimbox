<%@page import="com.vimbox.database.OperationsDAO"%>
<%@page import="com.vimbox.database.UserDAO"%>
<%@page import="com.vimbox.user.User"%>
<%@page import="java.util.ArrayList"%>
<%
    String dom = request.getParameter("getDOM");
    String mType = request.getParameter("getEmpType");
    
    ArrayList<User> allMovers = UserDAO.getMoversByType(mType);
    ArrayList<User> movers = new ArrayList<User>();
    boolean a = false;
    String nric = "";
    for (User m : allMovers) {
        nric = m.getNric();
        a = OperationsDAO.checkAssigned(dom, nric);
        if (!a) {
            movers.add(m);
        }
    }
    
    if (!movers.isEmpty()) {
%>
<select name="selected_mover" class="form-control" id="selected_mover">
<%
        for (User u : movers) {
%>
    <option value="<%=u.getNric()%>"><%=u.toString()%> (<%=u.getNric()%>)</option>
<%
        }
%>
</select>
<%
    }
    else {
        out.println("<input class='form-control' value='No " + mType.toLowerCase() + " time movers available' disabled/>");
    }
%>
