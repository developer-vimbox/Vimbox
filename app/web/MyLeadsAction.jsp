<%
    ServletContext sc = request.getServletContext();
    String action = (String) sc.getAttribute("action");
    if (action != null) {
        String errorMsg = (String) sc.getAttribute("errorMsg");
        sc.removeAttribute("action");
        sc.removeAttribute("errorMsg");
        if (action.equals("update")) {
            out.println("<h2>SUCCESS!</h2>");
            out.println("Lead has been updated!<br>");
        } else {
            out.println("<h2>SUCCESS!</h2>");
            out.println("Lead has been rejected!<br>");
        }
    }
%>
