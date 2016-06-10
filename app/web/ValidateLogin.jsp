<%@page import="com.vimbox.user.User"%>
<%
    User user = (User) request.getSession().getAttribute("session");
    if (user == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>
