<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.sales.Lead"%>
<%@page import="com.vimbox.database.LeadDAO"%>
<%
    int leadId = Integer.parseInt(request.getParameter("leadId"));
    Lead lead = LeadDAO.getLeadById(leadId);

    ArrayList<String[]> addressFrom = lead.getAddressFrom();
    for (String[] addFrom : addressFrom) {
        String[] address = addFrom[0].split("_");
        if (address.length > 1) {
            out.println("<input type='hidden' name='addressfrom' value='" + address[0] + "'>");
            out.println("<input type='hidden' name='addressfrom' value='" + address[1] + "'>");
            out.println("<input type='hidden' name='addressfrom' value='" + address[2] + "'>");
            out.println("<input type='hidden' name='addressfrom' value='" + address[3] + "'>");
        }
    }

    ArrayList<String[]> addressTo = lead.getAddressTo();
    for (String[] addTo : addressTo) {
        String[] address = addTo[0].split("_");
        if (address.length > 1) {
            out.println("<input type='hidden' name='addressto' value='" + address[0] + "'>");
            out.println("<input type='hidden' name='addressto' value='" + address[1] + "'>");
            out.println("<input type='hidden' name='addressto' value='" + address[2] + "'>");
            out.println("<input type='hidden' name='addressto' value='" + address[3] + "'>");
        }
    }
%>
<fieldset>
    <legend>Lead DOM</legend>
<%
    if(lead.getStatus().equals("Pending")){
%>
<button class="btn btn-default" onclick="confirmLead('<%=leadId%>')">Confirm</button>
<%
    }
%>
    <br>
    <fieldset>
        <div id="lead_dom"></div>
    </fieldset>
</fieldset>
<%
    if (lead.getStatus().equals("Pending")) {
%>
<hr>
<fieldset>
    <legend>Select DOM</legend>
    <br>
    <fieldset>
        <b><u>DOM Details</u></b><br><br>
        <div class="form-group">
            <label class="col-sm-3 control-label">Moving Calendar: </label>
            <div class="col-sm-4">
                <button class="btn btn-default bootstrap-touchspin-up" type="button" onclick="viewMovCal('Site');">View Calendar</button>
            </div>
        </div>
        <form method="POST" action="SiteDomController" id="site_dom_form">
            <input type="hidden" name="leadId" value="<%=leadId%>">
            <div id="operation"></div>
            <div class="bg-default text-center">
                <button type="submit" data-loading-text="Loading..." class="btn loading-button btn-primary">Save</button>
            </div>
        </form>
    </fieldset>
</fieldset>
<%
    }
%>