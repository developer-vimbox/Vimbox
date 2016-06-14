<%@page import="com.vimbox.database.LeadDAO"%>
<%@page import="com.vimbox.user.User"%>
<%@page import="com.vimbox.sales.Lead"%>
<%
    String lId = request.getParameter("lId");
    Lead lead = null;
    if (lId == null || lId.isEmpty()) {
        response.sendRedirect("MyLeads.jsp");
        return;
    }else{
        User owner = (User) request.getSession().getAttribute("session");
        lead = LeadDAO.getLeadById(lId);
        if(lead == null || !owner.getUsername().equals(lead.getOwner().getUsername())){
            lead = null;
            response.sendRedirect("MyLeads.jsp");
            return;
        }
    }
%>
