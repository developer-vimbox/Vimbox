<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.user.User"%>
<%
    User user = (User) request.getSession().getAttribute("session");
    ArrayList<String> moduleNames = user.getModuleNames();
    ArrayList<String> permittedPages = user.getPermittedPages();
    
    String url = request.getRequestURL().toString();
    
    if (user == null) {
        response.sendRedirect("Login.jsp");
        return;
    }else{
        boolean permitted = false;
        for(String ppage : permittedPages){
            if(url.contains(ppage)){
                permitted = true;
                break;
            }
        }
        
        if(!permitted){
            response.sendRedirect("UnauthorizedPage.jsp");
        }
    }
%>
