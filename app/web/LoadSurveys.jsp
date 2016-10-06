<%@page import="com.vimbox.database.LeadPopulationDAO"%>
<%@page import="com.vimbox.database.OperationsDAO"%>
<%@page import="com.vimbox.customer.Customer"%>
<%@page import="com.vimbox.sales.Lead"%>
<%@page import="com.vimbox.database.LeadDAO"%>
<%@page import="com.vimbox.sitesurvey.SiteSurvey"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.SiteSurveyDAO"%>
<style type="text/css"> .javascript { display: none; } </style>
 <div class="javascript">
<script type="text/javascript" src="assets/widgets/datatable/datatable.js"></script>
<script type="text/javascript" src="assets/widgets/datatable/datatable-bootstrap.js"></script>
<script type="text/javascript" src="assets/widgets/datatable/datatable-tabletools.js"></script>
<script type="text/javascript">

    /* Datatables basic */

    $(document).ready(function() {
        $('#completedSTable').dataTable();
        $('#pendingSTable').dataTable();
    });

    /* Datatables hide columns */

    $(document).ready(function() {
        var table = $('#datatable-hide-columns').DataTable( {
            "scrollY": "300px",
            "paging": false
        } );

        $('#datatable-hide-columns_filter').hide();

        $('a.toggle-vis').on( 'click', function (e) {
            e.preventDefault();

            // Get the column API object
            var column = table.column( $(this).attr('data-column') );

            // Toggle the visibility
            column.visible( ! column.visible() );
        } );
    } );

    /* Datatable row highlight */

    $(document).ready(function() {
        var table = $('#datatable-row-highlight').DataTable();

        $('#datatable-row-highlight tbody').on( 'click', 'tr', function () {
            $(this).toggleClass('tr-selected');
        } );
    });



    $(document).ready(function() {
        $('.dataTables_filter input').attr("placeholder", "Search...");
    });

</script>
 </div>
<%
    String userId = request.getParameter("userId");
    String keyword = request.getParameter("keyword");
    String type = request.getParameter("type");
    ArrayList<SiteSurvey> surveys = new ArrayList<SiteSurvey>();
    if(type.equals("Completed")){
        surveys = SiteSurveyDAO.getCompletedSiteSurveysByUserKeyword(userId, keyword);
    }else{
        surveys = SiteSurveyDAO.getNonCompletedSiteSurveysByUserKeyword(userId, keyword);
    } 
    
    if (!keyword.isEmpty()) {
        if (surveys.size() > 0) {
            out.println("Results found :");
        } else {
            out.println("No results found");
        }
        out.println("<br><br>");
    }
    String tableID = "";
    if (type.equals("Completed")) {
        tableID = "completedSTable";
    } else {
        tableID = "pendingSTable";
    }
%>
<table class="table table-hover" id="<%=tableID%>">
    <col width="10%">
    <col width="30%">
    <col width="20%">
    <col width="10%">
    <col width="10%">
    <col width="20%">
    <thead>
    <tr>
        <th>Lead ID</th>
        <th>Address</th>
        <th>Remarks</th>
        <th>Date</th>
        <th>Time Slot</th>
        <th>Action</th>
    </tr>
    </thead>
    <%
        String leadId = ""; 
        String date = "";
        String timeslot = "";
        String status = "";
        String remarks = "";
        ArrayList<String> address = new ArrayList<String>();
        for(int i=0 ; i<surveys.size(); i++){
            SiteSurvey survey = surveys.get(i);
            String nextLeadId = survey.getLead() + "";
            String nextDate = survey.getDate();
            String nextTimeslot = survey.getTimeSlots();
            String nextRemarks = survey.getRemarks();
            String nextStatus = survey.getStatus();
            if(i==0){
                leadId = nextLeadId;
                date = nextDate;
                timeslot = nextTimeslot;
                status = nextStatus;
                remarks = nextRemarks;
                address.add(survey.getAddress());
            }
            
            if(!leadId.equals(nextLeadId) || !date.equals(nextDate) || !timeslot.equals(nextTimeslot)){
                out.println("<tr>");
                out.println("<td align='center'>" + leadId + "</td>");
                out.println("<td align='center'><ul>");
                for(String add:address){
                    out.println("<li>" + add + "</li>");
                }
                out.println("</ul></td>");
                out.println("<td align='center'>" + remarks + "</td>");
                out.println("<td align='center'>" + date + "</td>");
                out.println("<td align='center'>" + timeslot + "</td>");
                out.println("<td align='center'>");
                if(status.equals("Pending")){
                    out.println("<button class='btn btn-default' onclick=\"startSurvey('" + leadId + "', '" + date + "', '" + timeslot + "', 'Start')\">Start Survey</button>");
                }else if (status.equals("Ongoing")){
                    out.println("<button class='btn btn-default' onclick=\"startSurvey('" + leadId + "', '" + date + "', '" + timeslot + "', '')\">Continue Survey</button>");
                }else{
                    out.println("<button class='btn btn-default' onclick=\"viewSurvey('" + leadId + "', '" + date + "', '" + timeslot + "')\">View Survey</button>");
                    out.println("<button class='btn btn-default' onclick=\"viewDom('" + leadId + "', '" + userId + "')\">DOM</button>");
                    Lead lead = LeadDAO.getLeadById(Integer.parseInt(leadId));
                    String refNum = "VBSPL_";
                    Customer customer = lead.getCustomer();
                    if (customer != null) {
                        String lastName = customer.getLast_name();
                        if (!lastName.trim().isEmpty()) {
                            refNum += lastName.charAt(0);
                        }
                        String firstName = customer.getLast_name();
                        if (!firstName.trim().isEmpty()) {
                            refNum += firstName.charAt(firstName.length() - 1);
                        }
                        int custContact = customer.getContact() % 1000;
                        refNum += Integer.toString(custContact) + "_";
                    }
                    
                    String toms = lead.getTom();
                    if (toms.contains("|")) {
                        String[] tomSplit = lead.getTom().split("\\|");
                        for (int k = 0; k < tomSplit.length; k++) {
                            refNum += LeadPopulationDAO.getMoveTypeAbb(tomSplit[k]);
                        }
                    } else {
                        refNum += LeadPopulationDAO.getMoveTypeAbb(toms);
                    }

                    ArrayList<String[]> dateOfMove = OperationsDAO.getDOMbyLeadID(lead.getId());
                    // always get the last dom, sql already sorted by descending order. just get(0) will do.
                    if (!dateOfMove.isEmpty()) {
                        String[] dts = dateOfMove.get(0);
                        String dd = dts[0];
                        if (dd != "") {
                            int index = dd.indexOf("-");
                            String yy = dd.substring(index - 2, index);
                            String mm = dd.substring(index + 1, index + 3);
                            refNum += "_" + mm + yy;
                        }
                    }

                    refNum = refNum.toUpperCase();
                    String qService = LeadDAO.getQuotationService(refNum);
        %>
        <button class="btn btn-default" onclick="viewQuotation('<%=refNum%>')">Quotation</button>
        <div id="quotation_modal_<%=refNum%>" class="modal">
            <div class="modal-content" style="width: 430px; min-height: 330px;">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('quotation_modal_<%=refNum%>')">×</span>
                    <center><h2>Input for Quotation Generation</h2></center>
                </div>
                <div class="modal-body">        
                    <form method="post" class="btn">
                        <div class="form-inline">
                            <label class="col-sm-3 control-label"> The cost of moving service includes: </label>
                            <br>
                            <div class="form-group">

                                <div class="col-sm-4">
                                    <textarea rows="4" cols="41" class="form-control" name="serviceIncludes"><%=qService%></textarea>
                                    <input type="hidden" name="leadId" value="<%=lead.getId()%>">
                                    <input type="hidden" name="refNum" value="<%=refNum%>">
                                </div>
                            </div>
                                <br><br>
                            <div class="form-group text-center">
                                 <input class='btn btn-primary' onclick="closeModal('quotation_modal_<%=refNum%>')" type="submit" value="Quotation" formaction="quotations/<%=refNum%>" formtarget="_blank">
                               
                            </div>
                          
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <%
                }
                out.println("</td>");
                out.println("</tr>");
                date = nextDate;
                timeslot = nextTimeslot;
                status = nextStatus;
                address.clear();
            }
            leadId = nextLeadId;
            date = nextDate;
            timeslot = nextTimeslot;
            status = nextStatus;
            remarks = nextRemarks;
            if(!address.contains(survey.getAddress())){
                address.add(survey.getAddress());
            }
            
            if(i == surveys.size()-1){
                out.println("<tr>");
                out.println("<td align='center'>" + leadId + "</td>");
                out.println("<td align='center'><ul>");
                for(String add:address){
                    out.println("<li>" + add + "</li>");
                }
                out.println("</ul></td>");
                out.println("<td align='center'>" + remarks + "</td>");
                out.println("<td align='center'>" + date + "</td>");
                out.println("<td align='center'>" + timeslot + "</td>");
                out.println("<td align='center'>");
                if(status.equals("Pending")){
                    out.println("<button class='btn btn-default' onclick=\"startSurvey('" + leadId + "', '" + date + "', '" + timeslot + "', 'Start')\">Start Survey</button>");
                }else if (status.equals("Ongoing")){
                    out.println("<button class='btn btn-default' onclick=\"startSurvey('" + leadId + "', '" + date + "', '" + timeslot + "', '')\">Continue Survey</button>");
                }else{
                    out.println("<button class='btn btn-default' onclick=\"viewSurvey('" + leadId + "', '" + date + "', '" + timeslot + "')\">View Survey</button>");
                    out.println("<button class='btn btn-default' onclick=\"viewDom('" + leadId + "', '" + userId + "')\">DOM</button>");
                    Lead lead = LeadDAO.getLeadById(Integer.parseInt(leadId));
                    String refNum = "VBSPL_";
                    Customer customer = lead.getCustomer();
                    if (customer != null) {
                        String lastName = customer.getLast_name();
                        if (!lastName.trim().isEmpty()) {
                            refNum += lastName.charAt(0);
                        }
                        String firstName = customer.getLast_name();
                        if (!firstName.trim().isEmpty()) {
                            refNum += firstName.charAt(firstName.length() - 1);
                        }
                        int custContact = customer.getContact() % 1000;
                        refNum += Integer.toString(custContact) + "_";
                    }
                    
                    String toms = lead.getTom();
                    if (toms.contains("|")) {
                        String[] tomSplit = lead.getTom().split("\\|");
                        for (int k = 0; k < tomSplit.length; k++) {
                            refNum += LeadPopulationDAO.getMoveTypeAbb(tomSplit[k]);
                        }
                    } else {
                        refNum += LeadPopulationDAO.getMoveTypeAbb(toms);
                    }

                    ArrayList<String[]> dateOfMove = OperationsDAO.getDOMbyLeadID(lead.getId());
                    // always get the last dom, sql already sorted by descending order. just get(0) will do.
                    if (!dateOfMove.isEmpty()) {
                        String[] dts = dateOfMove.get(0);
                        String dd = dts[0];
                        if (dd != "") {
                            int index = dd.indexOf("-");
                            String yy = dd.substring(index - 2, index);
                            String mm = dd.substring(index + 1, index + 3);
                            refNum += "_" + mm + yy;
                        }
                    }

                    refNum = refNum.toUpperCase();
                    String qService = LeadDAO.getQuotationService(refNum);
        %>
        <button class="btn btn-default" onclick="viewQuotation('<%=refNum%>')">Quotation</button>
        <div id="quotation_modal_<%=refNum%>" class="modal">
            <div class="modal-content" style="width: 430px; min-height: 330px;">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('quotation_modal_<%=refNum%>')">×</span>
                    <center><h2>Input for Quotation Generation</h2></center>
                </div>
                <div class="modal-body">        
                    <form method="post" class="btn">
                        <div class="form-inline">
                            <label class="col-sm-3 control-label"> The cost of moving service includes: </label>
                            <br>
                            <div class="form-group">

                                <div class="col-sm-4">
                                    <textarea rows="4" cols="41" class="form-control" name="serviceIncludes"><%=qService%></textarea>
                                    <input type="hidden" name="leadId" value="<%=lead.getId()%>">
                                    <input type="hidden" name="refNum" value="<%=refNum%>">
                                </div>
                            </div>
                                <br><br>
                            <div class="form-group text-center">
                                 <input class='btn btn-primary' onclick="closeModal('quotation_modal_<%=refNum%>')" type="submit" value="Quotation" formaction="quotations/<%=refNum%>" formtarget="_blank">
                               
                            </div>
                          
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <%
                }
                out.println("</td>");
                out.println("</tr>");
            }
        }
    %>
</table>