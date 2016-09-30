<%@page import="com.vimbox.database.LeadPopulationDAO"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.vimbox.operations.Job"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.sales.Lead"%>
<%@page import="com.vimbox.database.LeadDAO"%>
<%
    int leadId = Integer.parseInt(request.getParameter("leadId"));
    String nric = request.getParameter("nric");
    Lead lead = LeadDAO.getLeadById(leadId);
    double total = LeadDAO.getLeadConfirmedTotal(leadId);
    double deposit = LeadPopulationDAO.getDepositPercentage();

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
    <br>
    <fieldset>
        <b><u>DOM Details</u></b><br><br>
        <div>
            <%
                ArrayList<Job> jobs = lead.getJobs();
                String jj = "";
                String jRem = "";
                String jStatus = "";
                String timeslot = "";
                HashMap<String, ArrayList<String>> timeslots = new HashMap<String, ArrayList<String>>();
                ArrayList<String> addressesFr = new ArrayList<String>();
                ArrayList<String> addressesTo = new ArrayList<String>();
                for (int i = 0; i < jobs.size(); i++) {
                    Job job = jobs.get(i);
                    String j = job.getDate();
                    String jTruck = job.getAssignedTruck().toString();
                    String nextTimeslot = job.getTimeslots();
                    if (i == 0) {
                        jj = j;
                        jRem = job.getRemarks();
                        jStatus = job.getStatus();
                        timeslot = nextTimeslot;
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
                    <label class="col-sm-2 control-label"></label>
                    <div class="col-sm-3"  style="padding-top: 7px;">
                        <button class='btn btn-default' onclick="changeDom('<%=leadId%>', '<%=jj%>', '<%=timeslot%>', '<%=jStatus%>');">Change</button>
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
                    timeslot = nextTimeslot;
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
                    <label class="col-sm-2 control-label"></label>
                    <div class="col-sm-3"  style="padding-top: 7px;">
                        <button class='btn btn-default' onclick="changeDom('<%=leadId%>', '<%=jj%>', '<%=timeslot%>', '<%=jStatus%>')">Change</button>
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
            %>

        </div>
        <hr>
        <%
            if (lead.getStatus().equals("Pending")) {
        %>
        <div class="form-group">
            <label class="col-sm-3 control-label">Moving Calendar: </label>
            <div class="col-sm-4">
                <button class="btn btn-default bootstrap-touchspin-up" type="button" onclick="viewMovCal('Site');">View Calendar</button>
            </div>
        </div>
        <%
            }
        %>
        <form method="POST" action="SiteDomController" id="site_dom_form" enctype="multipart/form-data">
            <input type="hidden" name="leadId" value="<%=leadId%>">
            <input type="hidden" name="leadStatus" id="leadStatus" value="save"/>
            <div id="operation">

            </div>

            <div id="confirmLeadModal" class="modal">
                <!-- Modal content -->
                <div class="modal-content">
                    <div class="modal-header">
                        <span class="close" onclick="closeModal('confirmLeadModal')">×</span>
                        <center><h2>Lead Confirmation</h2></center>
                    </div>
                    <div class="modal-body">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label class="col-sm-4 control-label">Deposit to be collected: </label>
                                <div class="col-sm-6">
                                    <div class="input-group">
                                        <span class="input-group-addon">S$</span>
                                        <label class="form-control" id="cfmMessage" disabled><%=total * (deposit / 100)%></label>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">Amount Collected: </label>
                                <div class="col-sm-6">
                                    <div class="input-group">
                                        <span class="input-group-addon">S$</span>
                                        <input class="form-control" type="number" min="0" step="0.01" name="amountCollected"/>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">Confirmation Email: </label>
                                <div class="col-sm-6">
                                    <input class="form-control" type="file" name="file"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label"> </label>
                                <div class="col-sm-6 text-center">
                                    <button data-loading-text="Loading..." class="btn loading-button btn-primary" onclick="confirmSales();">Confirm</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <%
                if (lead.getStatus().equals("Pending")) {
            %>
            <div class="bg-default text-center">
                <button type="submit" data-loading-text="Loading..." class="btn loading-button btn-primary">Save</button>
                <button data-loading-text="Loading..." class="btn loading-button btn-primary" onclick="confirmLead();
                        return false;">Confirm</button>
            </div>

            <%
                }
            %>
        </form>
    </fieldset>
</fieldset>