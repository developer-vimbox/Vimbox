<%@page import="com.vimbox.database.OperationsDAO"%>
<%@page import="com.vimbox.database.LeadPopulationDAO"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.customer.Customer"%>
<%@page import="com.vimbox.sales.Lead"%>
<%@page import="com.vimbox.database.LeadDAO"%>
<%@page import="java.util.ArrayList"%>
<style type="text/css"> .javascript { display: none; } </style>
<div class="javascript">
    <script type="text/javascript" src="assets/widgets/datatable/datatable.js"></script>
    <script type="text/javascript" src="assets/widgets/datatable/datatable-bootstrap.js"></script>
    <script type="text/javascript" src="assets/widgets/datatable/datatable-tabletools.js"></script>
    <script type="text/javascript">

        /* Datatables basic */

        $(document).ready(function () {
            $('#pendingTable').dataTable();
            $('#confirmedTable').dataTable();
            $('#rejectedTable').dataTable();
        });

        /* Datatables hide columns */

        $(document).ready(function () {
            var table = $('#datatable-hide-columns').DataTable({
                "scrollY": "300px",
                "paging": false
            });

            $('#datatable-hide-columns_filter').hide();

            $('a.toggle-vis').on('click', function (e) {
                e.preventDefault();

                // Get the column API object
                var column = table.column($(this).attr('data-column'));

                // Toggle the visibility
                column.visible(!column.visible());
            });
        });

        /* Datatable row highlight */

        $(document).ready(function () {
            var table = $('#datatable-row-highlight').DataTable();

            $('#datatable-row-highlight tbody').on('click', 'tr', function () {
                $(this).toggleClass('tr-selected');
            });
        });



        $(document).ready(function () {
            $('.dataTables_filter input').attr("placeholder", "Search...");
        });

    </script>
</div>
<%
    String keyword = request.getParameter("keyword");
    String type = request.getParameter("type");

    ArrayList<Lead> myLeads = LeadDAO.getLeadsByOwnerUser(keyword, type);

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

    String tableID = "";
    if (type.equals("Pending")) {
        tableID = "pendingTable";
    } else if (type.equals("Confirmed")) {
        tableID = "confirmedTable";
    } else if (type.equals("Rejected")) {
        tableID = "rejectedTable";
    }
%>
<table class="table table-hover" id="<%=tableID%>">
    <col width="10%">
    <col width="5%">  
    <col width="5%">
    <col width="15%">
    <col width="10%">
    <col width="30%">
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
        <button class="btn btn-default" onclick="confirmDelete('<%=lead.getId()%>')">Delete</button>
        <%
            if (leadType.equals("Sales")) {
        %>
        <button class="btn btn-default" onclick="confirmLeadSM('<%=lead.getId()%>')">Confirm</button>
        <%
            }
        } else if (status.equals("Confirmed")) {
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
        } else {
        %>
        <button class="btn btn-default" onclick="reopenLead('<%=lead.getId()%>')">Reopen</button>
        <%
            }
        %>
    </td>
    <td>
        <button class="btn btn-default" onclick="viewLead('<%=lead.getId()%>')">VS</button>
        <button class="btn btn-default" onclick="viewFollowups('<%=lead.getId()%>')">VF</button>
        <%
            if (leadType.equals("Sales")) {
                if (status.equals("Pending")) {

                    String refNum = "VBSPL_";
                    String email = "";
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
                        email = customer.getEmail();
                    }

                    String toms = lead.getTom();
                    if (toms.contains("|")) {
                        String[] tomSplit = lead.getTom().split("\\|");
                        for (int i = 0; i < tomSplit.length; i++) {
                            refNum += LeadPopulationDAO.getMoveTypeAbb(tomSplit[i]);
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
            <div class="modal-content" style="width: 430px; min-height: 400px;">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('quotation_modal_<%=refNum%>')">×</span>
                    <center><h2>Input for Quotation Generation</h2></center>
                </div>
                <div class="modal-body">        
                    <form method="post" class="btn">
                        <label class="col-sm-3 control-label"> The cost of moving service includes: </label>
                        <br>
                        <div class="form-group">
                            <div class="col-sm-4">
                                <textarea rows="4" cols="41" class="form-control" id="serviceIncludes" name="serviceIncludes"><%=qService%></textarea>
                                <input type="hidden" name="leadId" id="leadId" value="<%=lead.getId()%>">
                                <input type="hidden" name="refNum" id="refNum" value="<%=refNum%>">
                            </div>
                        </div>
                        <br>
                        <label class="col-sm-3 control-label"> Email Address: </label>
                        <br>
                        <div class="form-group">
                            <div>
                                <input type="text" class="form-control" id="quotationEmail" value="<%=email%>">
                            </div>
                        </div>
                        <br><br>
                        <div class="form-group text-center">
                            <input class='btn btn-primary' onclick="closeModal('quotation_modal_<%=refNum%>')" type="submit" value="Quotation" formaction="quotations/<%=refNum%>" formtarget="_blank">
                            <button class='btn btn-primary' onclick="emailQuotation('quotation_modal_<%=refNum%>');return false;">Email</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <%
        } else {
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
                    <div class="form-horizontal">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">Reason: </label>
                            <div class="col-sm-7">
                                <textarea id="reason" name="reason" class="form-control textarea-autosize" disabled><%=lead.getReason()%></textarea>

                            </div>
                        </div>
                    </div>
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