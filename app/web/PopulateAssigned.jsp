<%@page import="com.vimbox.database.UserDAO"%>
<%@page import="java.util.ArrayList"%>
<%
    ArrayList<String> fullnames = new ArrayList<String>();
    fullnames = UserDAO.getUsersFullnames();
%>
