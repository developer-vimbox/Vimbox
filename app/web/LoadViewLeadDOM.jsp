<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.vimbox.operations.Job"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.sales.Lead"%>
<%@page import="com.vimbox.database.LeadDAO"%>
<%
    int leadId = Integer.parseInt(request.getParameter("leadId"));
    Lead lead = LeadDAO.getLeadById(leadId);

    ArrayList<Job> jobs = lead.getJobs();
    if (jobs.isEmpty()) {
        out.println("No booked / confirmed DOM");
    } else {
        String jj = "";
        String jRem = "";
        String jStatus = "";
        HashMap<String, ArrayList<String>> timeslots = new HashMap<String, ArrayList<String>>();
        ArrayList<String> addressesFr = new ArrayList<String>();
        ArrayList<String> addressesTo = new ArrayList<String>();
        for (int i = 0; i < jobs.size(); i++) {
            Job job = jobs.get(i);
            String j = job.getDate();
            String jTruck = job.getAssignedTruck().toString();
            if (i == 0) {
                jj = j;
                jRem = job.getRemarks();
                jStatus = job.getStatus();
            }

            if (!j.equals(jj)) {
%>
<hr>
<div class="form-horizontal">
    <div class="form-group">
        <label class="col-sm-3 control-label">Date of Move: </label>
        <div class="col-sm-4" style="padding-top: 7px;">
            <%=jj%>
        </div>
    </div>

    <div class="form-group">
        <label class="col-sm-3 control-label">Truck(s): </label>
        <div class="col-sm-3" style="padding-top: 7px;">
            <%
                for (Map.Entry<String, ArrayList<String>> entry : timeslots.entrySet()) {
                    String cp = entry.getKey();
                    ArrayList<String> list = entry.getValue();
                    out.println("<div><div class='col-sm-7' style='padding-left: 0px;'>" + cp + "</div>");
                    out.println("<div class='col-sm-5'>");
                    for (int k = 0; k < list.size(); k++) {
                        out.println(list.get(k) + "<br>");
                    }
                    out.println("</div></div><br>");
                }
            %>
        </div>
    </div>

    <div class="form-group">
        <label class="col-sm-3 control-label">From: </label>
        <div class="col-sm-4" style="padding-top: 7px;">
            <%
                for (int k = 0; k < addressesFr.size(); k++) {
                    out.println(addressesFr.get(k) + "<br>");
                }
            %>
        </div>
    </div>

    <div class="form-group">
        <label class="col-sm-3 control-label">To: </label>
        <div class="col-sm-4" style="padding-top: 7px;">
            <%
                for (int k = 0; k < addressesTo.size(); k++) {
                    out.println(addressesTo.get(k) + "<br>");
                }
            %>
        </div>
    </div>

    <div class="form-group">
        <label class="col-sm-3 control-label">Remarks: </label>
        <div class="col-sm-4" style="padding-top: 7px;">
            <%=jRem%>
        </div>
    </div>

    <div class="form-group">
        <label class="col-sm-3 control-label">Status: </label>
        <div class="col-sm-4" style="padding-top: 7px;">
            <%=jStatus%>
        </div>
    </div>
</div>
<%

        jj = j;
        jRem = job.getRemarks();
        jStatus = job.getStatus();
        timeslots = new HashMap<String, ArrayList<String>>();
        addressesFr = new ArrayList<String>();
        addressesTo = new ArrayList<String>();
    }

    ArrayList<String> slots = timeslots.get(jTruck);
    if (slots == null) {
        slots = new ArrayList<String>();
        slots.add(job.getTimeSlot());
        timeslots.put(jTruck, slots);
    } else {
        if (!slots.contains(job.getTimeSlot())) {
            slots.add(job.getTimeSlot());
        }
    }

    HashMap<String, String> addresses = job.getAddresses();
    for (Map.Entry<String, String> entry : addresses.entrySet()) {
        String key = entry.getKey();
        String value = entry.getValue();
        if (value.equals("from")) {
            if (!addressesFr.contains(key)) {
                addressesFr.add(key);
            }
        } else {
            if (!addressesTo.contains(key)) {
                addressesTo.add(key);
            }
        }
    }

    if (i == jobs.size() - 1) {
%>
<hr>
<div class="form-horizontal">
    <div class="form-group">
        <label class="col-sm-3 control-label">Date of Move: </label>
        <div class="col-sm-4" style="padding-top: 7px;">
            <%=jj%>
        </div>
    </div>

    <div class="form-group">
        <label class="col-sm-3 control-label">Truck(s): </label>
        <div class="col-sm-3" style="padding-top: 7px;">
            <%
                for (Map.Entry<String, ArrayList<String>> entry : timeslots.entrySet()) {
                    String cp = entry.getKey();
                    ArrayList<String> list = entry.getValue();
                    out.println("<div><div class='col-sm-7' style='padding-left: 0px;'>" + cp + "</div>");
                    out.println("<div class='col-sm-5'>");
                    for (int k = 0; k < list.size(); k++) {
                        out.println(list.get(k) + "<br>");
                    }
                    out.println("</div></div><br>");
                }
            %>
        </div>
    </div>

    <div class="form-group">
        <label class="col-sm-3 control-label">From: </label>
        <div class="col-sm-4" style="padding-top: 7px;">
            <%
                for (int k = 0; k < addressesFr.size(); k++) {
                    out.println(addressesFr.get(k) + "<br>");
                }
            %>
        </div>
    </div>

    <div class="form-group">
        <label class="col-sm-3 control-label">To: </label>
        <div class="col-sm-4" style="padding-top: 7px;">
            <%
                for (int k = 0; k < addressesTo.size(); k++) {
                    out.println(addressesTo.get(k) + "<br>");
                }
            %>
        </div>
    </div>

    <div class="form-group">
        <label class="col-sm-3 control-label">Remarks: </label>
        <div class="col-sm-4" style="padding-top: 7px;">
            <%=jRem%>
        </div>
    </div>

    <div class="form-group">
        <label class="col-sm-3 control-label">Status: </label>
        <div class="col-sm-4" style="padding-top: 7px;">
            <%=jStatus%>
        </div>
    </div> 
</div>
<%
            }
        }
    }
%>
