<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.user.User"%>
<%
    User user = (User) request.getSession().getAttribute("session");
    ArrayList<String> moduleNames = null;
    ArrayList<String> permittedPages = null; 
    
    if (user == null) {
        response.sendRedirect("Login.jsp");
        return;
    }else{
        moduleNames = user.getModuleNames();
        permittedPages = user.getPermittedPages();

        String urll = request.getRequestURL().toString();
        boolean permitted = false;
        for(String ppage : permittedPages){
            if(urll.contains(ppage)){
                permitted = true;
                break;
            }
        }
        
        if(!permitted){
            response.sendRedirect("UnauthorizedPage.jsp");
        }
    }
%>
