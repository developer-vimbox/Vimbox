<%@page import="com.vimbox.database.LeadPopulationDAO"%>
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
    <col width="10%">
    <col width="10%">  
    <col width="5%">
    <col width="15%">
    <col width="10%">
    <col width="25%">
    <col width="25%">
    <thead>
        <tr>
            <th>Date Created</th>
            <th>Lead Id</th>
            <th>Type</th>
            <th>Cust Name</th>
            <th>Cust Contact</th>
            <th>Action</th>
            <th>View</th>
        </tr>
    </thead>
    <tbody>
        <%
            for (Lead lead : myLeads) {
                String status = lead.getStatus();
                String leadType = lead.getType();
                
                String url = "window.location.href='EditLead.jsp?lId=" + lead.getId() + "'";
                out.println("<tr>");
                out.println("<td align='center'>" + Converter.convertDate(lead.getDt()) + "</td>");
                out.println("<td align='center'>" + lead.getId() + "</td>");
                out.println("<td align='center'>" + lead.getType() + "</td>");
                
                Customer customer = lead.getCustomer();
                String cust = "";
                if (customer != null) {
                    cust = customer.toString();
                    out.println("<td align='center'>" + customer.toString() + "</td>");
                    out.println("<td align='center'>" + customer.getContact() + "</td>");
                } else {
                    out.println("<td align='center'></td>");
                    out.println("<td align='center'></td>");
                }
        %>
    <td>
        <%
            if (status.equals("Pending")) {
        %>
            <input class="btn btn-default" type='button' value='Edit' onclick="<%=url%>">
            <button class="btn btn-default" onclick="addFollowup('<%=lead.getId()%>')">Follow-Up</button>
            <button class="btn btn-default" onclick="cancelLead('<%=lead.getId()%>')">Reject</button>
        <%
                if(leadType.equals("Sales")){
        %>
            <button class="btn btn-default" onclick="confirmLead('<%=lead.getId()%>')">Confirm</button>
        <%
                } 
            }else if (status.equals("Confirmed")){
        %>
            <button class="btn btn-default" onclick="amountCheck('<%=lead.getId()%>')">Amount</button>
            <form method="post" class="btn" style="
    padding-left: 0px;
    padding-right: 0px;
    border-left-width: 0px;
    border-right-width: 0px;
    border-top-width: 0px;
    border-bottom-width: 0px;
">
                <input type="hidden" name="leadId" value="<%=lead.getId()%>">
                <input class='btn btn-default' type="submit" value="Email" formaction="emails/<%=lead.getId()%>" formtarget="_blank">
            </form>
            <button class="btn btn-default" onclick="cancelLead('<%=lead.getId()%>')">Reject</button>
        <%
            }
        %>
    </td>
    <td>
        <button class="btn btn-default" onclick="viewLead('<%=lead.getId()%>')">VS</button>
        <button class="btn btn-default" onclick="viewFollowups('<%=lead.getId()%>')">VF</button>
        <%
            if(leadType.equals("Sales")){
                if(status.equals("Pending")){
        %>
            <button class="btn btn-default">Quotation</button>
        <%
                }else{
        %>
            <form method="post" class="btn" style="
    padding-left: 0px;
    padding-right: 0px;
    border-left-width: 0px;
    border-right-width: 0px;
    border-top-width: 0px;
    border-bottom-width: 0px;
">
                <input type="hidden" name="leadId" value="<%=lead.getId()%>">
                <input class='btn btn-default' type="submit" value="Invoice" formaction="invoices/<%=lead.getId()%>" formtarget="_blank">
            </form>
        <%
                }
            }
            if (status.equals("Rejected")) {
        %>
        <button class="btn btn-default" onclick="viewCancelReason()">VR</button>
        <div id="viewReasonModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('viewReasonModal')">×</span>
                    <center><h2>Rejected Reason for Lead <%=lead.getId()%></h2></center>
                </div>
                <div class="modal-body">
                    <table>
                        <tr>
                            <td>Reason :</td>
                            <td><textarea id="reason" name="reason" cols="75" rows="6" disabled><%=lead.getReason()%></textarea></td>
                        </tr>  
                    </table>
                </div>
            </div>
        </div>
        <%
            }
        %>
    </td>
    <%
        }
    %>
</tbody>
</table>  
