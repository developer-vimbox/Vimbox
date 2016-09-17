<%@page import="com.vimbox.sitesurvey.SiteSurvey"%>
<%@page import="com.vimbox.sales.Lead"%>
<%@page import="com.vimbox.database.LeadDAO"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.vimbox.operations.Job"%>
<%@page import="com.vimbox.database.JobDAO"%>
<%@page import="com.vimbox.customer.Customer"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.database.TicketDAO"%>
<%@page import="com.vimbox.ticket.Ticket"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Daily Supervisor Jobs</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <script src="JS/TicketFunctions.js"></script>
        <script src="JS/OperationFunctions.js"></script>
        <script src="JS/CustomerFunctions.js"></script>
        <script src="JS/LeadFunctions.js"></script>
    </head>
    <body onload="loadBody('Full')">
        <%@include file="header.jsp"%>
        <%            String dom = request.getParameter("dom");
        String userIC = user.getNric();
            ArrayList<Job> jobs = JobDAO.getJobsBySupervisorAndDate(userIC, dom);
        %>
        <div id="viewLeadModal" class="modal">
            <div class="modal-content" style="width: 80%;">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('viewLeadModal')">×</span>
                    <center><h2>Lead Details</h2></center>
                </div>
                <div class="modal-body">
                    <div id="leadContent"></div>
                </div>
            </div>
        </div>
        <div id="page-content-wrapper">
            <div id="page-content" style="min-height: 545px;">
                <div class="container">
                    <script type="text/javascript" src="assets/widgets/sticky/sticky.js"></script>
                    <script type="text/javascript" src="assets/widgets/tocify/tocify.js"></script>

                    <script type="text/javascript">
                        $(function () {
                            var toc = $("#tocify-menu").tocify({context: ".toc-tocify", showEffect: "fadeIn", extendPage: false, selectors: "h2, h3, h4"});
                        });
                        jQuery(document).ready(function ($) {

                            /* Sticky bars */

                            $(function () {
                                "use strict";

                                $('.sticky-nav').hcSticky({
                                    top: 50,
                                    innerTop: 50,
                                    stickTo: 'document'
                                });

                            });

                        });

                        $(document).on('change', '.timeSlot', function () {

                            var value = $(this).val();

                            if (value === 'TimeSlot') {
                                document.getElementById("ts_h_to").disabled = false;
                                document.getElementById("ts_m_to").disabled = false;
                                document.getElementById("ts_h_fr").disabled = false;
                                document.getElementById("ts_m_fr").disabled = false;
                            } else {
                                document.getElementById("ts_h_to").disabled = true;
                                document.getElementById("ts_m_to").disabled = true;
                                document.getElementById("ts_h_fr").disabled = true;
                                document.getElementById("ts_m_fr").disabled = true;
                            }
                        });
                    </script>

                    <div id="page-title">
                        <h2>Supervisor Jobs assigned for <%=dom%></h2> <br/>
                        <div class="panel">
                            <div class="panel-body">
                                <button class="btn btn-default" style="float: right; z-index: 1;" onclick="location.href = 'SupervisorJobs.jsp';">Back to Calendar</button>
                                <div class="example-box-wrapper">
                                    <ul class="nav-responsive nav nav-tabs">
                                        <li class="active"><a href="#assignedJobs" data-toggle="tab">Assigned Jobs</a></li>
                                        <li><a href="#assignMovers" data-toggle="tab">Movers</a></li>
                                    </ul>
                                    <div class="tab-content">
                                        <div id="assignedJobs" class="tab-pane active">
                                            <table class="table table-hover" width="100%">
                                                <col width="5%">
                                                <col width="10%">
                                                <col width="15%">
                                                <col width="8%">
                                                <col width="20%">
                                                <col width="20%">
                                                <col width="7%">
                                                <col width="5%">
                                                <thead>
                                                    <tr>
                                                        <th>Lead ID</th>
                                                        <th>Truck(s)</th>
                                                        <th>Customer Info</th>
                                                        <th>Site Surveyor(s)</th>
                                                        <th>From</th>
                                                        <th>To</th>
                                                        <th>Time Slot</th>
                                                        <th>View</th>
                                                    </tr>
                                                </thead>
                                                <%
                                                    String leadId = "";
                                                    String jj = "";
                                                    ArrayList<String> jTruck = new ArrayList<String>();
                                                    ArrayList<SiteSurvey> ssa = new ArrayList<SiteSurvey>();
                                                    User ss = null;
                                                    String timeslot = "";
                                                    String supervisor = "";
                                                    String custName = "";
                                                    int custContact = 0;
                                                    Lead lead = null;
                                                    Customer cust = null;
                                                    ArrayList<String> addressesFr = new ArrayList<String>();
                                                    ArrayList<String> addressesTo = new ArrayList<String>();
                                                    for (int i = 0; i < jobs.size(); i++) {
                                                        Job job = jobs.get(i);
                                                        String nextLeadId = job.getLeadId() + "";
                                                        String nextTruck = job.getAssignedTruck() + "";
                                                        String nextTimeslot = job.getTimeslots();
                                                        String nextSupervisor = "";
                                                        User sup = job.getSupervisor();
                                                        if (sup != null) {
                                                            nextSupervisor = sup.toString();
                                                        }

                                                        String j = job.getDate();
                                                        if (i == 0) {
                                                            jj = j;
                                                            leadId = nextLeadId;
                                                            supervisor = nextSupervisor;
                                                            timeslot = nextTimeslot;
                                                        }

                                                        if (!j.equals(jj) || !nextLeadId.equals(leadId)) {
                                                            lead = LeadDAO.getLeadById(Integer.parseInt(leadId));
                                                            ssa = lead.getSiteSurveys();
                                                            cust = lead.getCustomer();
                                                            custName = cust.toString();
                                                            custContact = cust.getContact();
                                                            out.println("<tr>");
                                                            out.println("<td align='center'>" + leadId + "</td>");
                                                            out.println("<td align='center'><ul>");
                                                            for (String truck : jTruck) {
                                                                out.println("<li>" + truck + "</li>");
                                                            }
                                                            out.println("</ul></td>");
                                                            out.println("<td align='center'><b>Name:</b> " + custName + "<br><b>Contact:</b> " + custContact + "</td>");
                                                            out.println("<td align='center'>");
                                                            if (ssa.isEmpty()) {
                                                                out.println("N/A");
                                                            } else {
                                                                for (SiteSurvey s : ssa) {
                                                                    ss = s.getSiteSurveyor();
                                                                    out.println(ss.toString());
                                                                }
                                                            }
                                                            out.println("</td>");
                                                            out.println("<td align='center'><ul>");
                                                            for (String add : addressesFr) {
                                                                out.println("<li>" + add + "</li>");
                                                            }
                                                            out.println("</ul></td>");
                                                            out.println("<td align='center'><ul>");
                                                            for (String add : addressesTo) {
                                                                out.println("<li>" + add + "</li>");
                                                            }
                                                            out.println("</ul></td>");
                                                            out.println("<td align='center'>" + timeslot + "</td>");
                                                            out.println("<td align='center'><button class='btn btn-default' onclick=\"viewSalesPortion('" + leadId + "')\">VS</button></td>");
                                                            out.println("</tr>");

                                                            jj = j;
                                                            leadId = nextLeadId;
                                                            supervisor = nextSupervisor;
                                                            jTruck = new ArrayList<String>();
                                                            timeslot = nextTimeslot;
                                                            addressesFr = new ArrayList<String>();
                                                            addressesTo = new ArrayList<String>();
                                                        }

                                                        if (!jTruck.contains(nextTruck)) {
                                                            jTruck.add(nextTruck);
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
                                                            lead = LeadDAO.getLeadById(Integer.parseInt(leadId));
                                                            ssa = lead.getSiteSurveys();
                                                            cust = lead.getCustomer();
                                                            custName = cust.toString();
                                                            custContact = cust.getContact();
                                                            out.println("<tr>");
                                                            out.println("<td align='center'>" + leadId + "</td>");
                                                            out.println("<td align='center'><ul>");
                                                            for (String truck : jTruck) {
                                                                out.println("<li>" + truck + "</li>");
                                                            }
                                                            out.println("</ul></td>");
                                                            out.println("<td align='center'><b>Name:</b> " + custName + "<br><b>Contact:</b> " + custContact + "</td>");
                                                            out.println("<td align='center'>");
                                                            if (ssa.isEmpty()) {
                                                                out.println("N/A");
                                                            } else {
                                                                for (SiteSurvey s : ssa) {
                                                                    ss = s.getSiteSurveyor();
                                                                    out.println(ss.toString());
                                                                }
                                                            }
                                                            out.println("</td>");
                                                            out.println("<td align='center'><ul>");
                                                            for (String add : addressesFr) {
                                                                out.println("<li>" + add + "</li>");
                                                            }
                                                            out.println("</ul></td>");
                                                            out.println("<td align='center'><ul>");
                                                            for (String add : addressesTo) {
                                                                out.println("<li>" + add + "</li>");
                                                            }
                                                            out.println("</ul></td>");
                                                            out.println("<td align='center'>" + timeslot + "</td>");
                                                            out.println("<td align='center'><button class='btn btn-default' onclick=\"viewSalesPortion('" + leadId + "')\">VS</button></td>");
                                                            out.println("</tr>");
                                                        }
                                                    }
                                                %>
                                            </table>
                                        </div>

                                        <div id="assignMovers" class="tab-pane">
                                            <div id="error_modal" class="modal">
                                                <div class="modal-content" style="width: 300px;">
                                                    <div class="modal-body">
                                                        <span class="close" onclick="closeModal('error_modal')">×</span>
                                                        <div id="error_status"></div>
                                                        <hr>
                                                        <div id="error_message"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div id="movers_table" style="display:none"></div>
                                            <hr>
                                            <h3 class="mrg10A">Assign Movers</h3>
                                            <div class="form-horizontal">
                                                <div class="form-group">
                                                    <label class="col-sm-3 control-label">Date:</label>
                                                    <div class="col-sm-4">
                                                        <span class="form-control"><%=dom%></span>
                                                        <input type="hidden" id="dom" value="<%=dom%>"/>
                                                        <input type="hidden" id="supervisor" value="<%=userIC%>"/>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="col-sm-3 control-label">Employee Type: </label>
                                                    <div class="col-sm-4">
                                                        <label class="radio-inline">
                                                            <input type="radio" name="employeeType" onclick="loadMovers('Full')" id="full-time" value="Full" checked>Full-Time 
                                                        </label>
                                                        <label class="radio-inline">
                                                            <input type="radio" name="employeeType" onclick="loadMovers('Part')" id="part-time" value="Part">Part-Time
                                                        </label>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="col-sm-3 control-label">Employee: </label>
                                                    <div class="col-sm-4">
                                                        <div id="movers" style="display:none"></div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="col-sm-3 control-label"> </label>
                                                    <div class="col-sm-4 text-center">
                                                        <button class ="btn btn-primary" onclick="assignMovers()">Assign Mover</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
