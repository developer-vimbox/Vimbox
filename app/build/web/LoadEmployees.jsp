<%@page import="com.vimbox.database.UserDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.user.User"%>
<%
    String keyword = request.getParameter("keyword");
    String timer = request.getParameter("timer");
    ArrayList<User> users = new ArrayList<User>();
    switch(timer){
        case "full-time":
            users = UserDAO.getUsersByKeyword(keyword);
            break;
        case "part-time":
            users = UserDAO.getPartTimeUsersByKeyword(keyword);
    }
    if(!keyword.isEmpty()){
        if(users.size() > 1){
            out.println(users.size() + " results found");
        }else if(users.size() == 1){
            out.println("1 result found");
        }else{
            out.println("No results found");
        }
        out.println("<br><br>");
    }
%>
<table border="1" width="100%">
    <col width="20%">
    <col width="20%">
    <col width="20%">
    <col width="20%">
    <col width="20%">
            
    <tr>
        <th>NRIC</th>
        <th>Name</th>
        <th>Contact</th>
        <th>Designation</th>
        <th>Action</th>
    </tr>
<%
    for(User user:users){
%>
    <tr>
        <td align="center"><%=user.getNric()%></td>
        <td align="center"><%=user%></td>
        <td align="center"><%=user.getContact()%></td>
        <td align="center"><%=user.getDesignation()%></td>
        <td align="center">
            <button>Edit</button>
            <button>View</button>
        </td>
    </tr>
<%
    }
%>
</table>
