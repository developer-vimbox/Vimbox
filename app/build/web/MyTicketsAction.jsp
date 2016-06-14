<%
    ServletContext sc = request.getServletContext();
    String action = (String)sc.getAttribute("action");
    if(action != null){
        String errorMsg = (String)sc.getAttribute("errorMsg");
        sc.removeAttribute("action");
        sc.removeAttribute("errorMsg");
        switch(action){
            case "comment":
                if(errorMsg.equals("success")){
                    out.println("<h2>SUCCESS!</h2>");
                    out.println("Comment has been added!<br>");
                }else{
                    out.println("<h2>ERROR!</h2>");
                    out.println(errorMsg + "<br>");
                }
                break;
            case "resolve":
                if(errorMsg.equals("success")){
                    out.println("<h2>SUCCESS!</h2>");
                    out.println("Ticket has been resolved!<br>");
                }else{
                    out.println("<h2>ERROR!</h2>");
                    out.println(errorMsg + "<br>");
                }
                break;
            case "update":
                out.println("<h2>SUCCESS!</h2>");
                out.println("Ticket has been updated!<br>");
        }
    }
%>