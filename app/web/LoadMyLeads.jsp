<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.customer.Customer"%>
<%@page import="com.vimbox.sales.Lead"%>
<%@page import="com.vimbox.database.LeadDAO"%>
<%@page import="java.util.ArrayList"%>
<%            
    String keyword = request.getParameter("keyword");
    String nric = request.getParameter("nric");
    String type = request.getParameter("type");
    
    ArrayList<Lead> myLeads = LeadDAO.getLeadsByOwnerUser(keyword, nric, type);
    
    if (!keyword.isEmpty()) {
        if (myLeads.size() > 1) {
            out.println(myLeads.size() + " results found");
        } else if (myLeads.size() == 1) {
            out.println("1 result found");
        } else {
            out.println("No results found");
        }
        out.println("<br><br>");
    }
%>
<table class="table table-hover">
    <thead>
        <tr>
            <th>#</th>
            <th>Type</th>
            <th>Cust Name</th>
            <th>Cust Contact</th>
            <th>Status</th>
            <th>Date</th>
            <th>Action</th>
            <th>View</th>
        </tr>
    </thead>
    <tbody>
        <%
            for (Lead lead : myLeads) {
                String url = "window.location.href='EditLead.jsp?lId=" + lead.getId() + "'";
                out.println("<tr>");
                out.println("<td align='center'>" + lead.getId() + "</td>");
                out.println("<td align='center'>" + lead.getType() + "</td>");

                Customer customer = lead.getCustomer();
                if (customer != null) {
                    out.println("<td align='center'>" + customer.toString() + "</td>");
                    out.println("<td align='center'>" + customer.getContact() + "</td>");
                } else {
                    out.println("<td align='center'></td>");
                    out.println("<td align='center'></td>");
                }

                out.println("<td align='center'>" + lead.getStatus() + "</td>");
                out.println("<td align='center'>" + Converter.convertDate(lead.getDt()) + "</td>");
        %>
    <td>
        <%
            if (lead.getStatus().equals("Pending")) {
        %>

        <input class="btn btn-default" type='button' value='Edit' onclick="<%=url%>">
        <button class="btn btn-default" onclick="addFollowup('<%=lead.getId()%>')">Follow-Up</button>

        <%
            }
        %>
    </td>
    <td>
        <button class="btn btn-default" onclick="viewLead('<%=lead.getId()%>')">VS</button>

        <button class="btn btn-default" onclick="viewFollowups('<%=lead.getId()%>')">VF</button>

    </td>
    <%
        }
    %>
</tbody>
</table>  
