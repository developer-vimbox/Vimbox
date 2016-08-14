<%@page import="com.vimbox.customer.Customer"%>
<%@page import="com.vimbox.database.LeadDAO"%>
<%@page import="com.vimbox.sales.Lead"%>
<%@page import="java.util.ArrayList"%>
<%@include file="ValidateLogin.jsp" %>
<!DOCTYPE html>
<%    int templead = Integer.parseInt(request.getParameter("leadId"));
    Lead lead = LeadDAO.getLeadById(templead);
    if (lead != null) {
%>
    <%
        if (!lead.getStatus().equals("Rejected") || ! !lead.getStatus().equals("Confirmed")) {
    %>
<div class="form-horizontal">
    <div class="form-group">
        <label class="col-sm-3 control-label">Lead ID: </label>
        <div class="col-sm-3" style="padding-top: 7px;">
            <%=lead.getId()%><input type="hidden" id="comment_lead_id" value="<%=lead.getId()%>" />
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label">Follow Up: </label>
        
        <div class="col-sm-8">
            <textarea class="form-control" id="comment_lead_followup" cols="75" rows="6" autofocus></textarea>
        </div>
        </div>
    <div class="form-group text-center">
        <button class="btn btn-primary" onclick="followupLead(<%=lead.getId()%>)">Add Follow-Up</button>
    </div>
</div>

<%}%>
<%}%>
