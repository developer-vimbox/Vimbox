<%
    ServletContext sc = request.getServletContext();
    String action = (String)sc.getAttribute("action");
    if(action != null){
        String errorMsg = (String)sc.getAttribute("errorMsg");
        sc.removeAttribute("action");
        sc.removeAttribute("errorMsg");
        switch(action){
            case "followup":
                if(errorMsg.equals("success")){
                    out.println("<h2>SUCCESS!</h2>");
                    out.println("Follow-up has been added!<br>");
                }else{
                    out.println("<h2>ERROR!</h2>");
                    out.println(errorMsg + "<br>");
                }
                break;
            case "update":
                out.println("<h2>SUCCESS!</h2>");
                out.println("Lead has been updated!<br>");
                break;
            case "reject":
                out.println("<h2>SUCCESS!</h2>");
                out.println("Lead has been rejected!<br>");
        }
    }
%>
