<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.customer.Customer"%>
<%@page import="com.vimbox.sales.Lead"%>
<%@page import="com.vimbox.database.CustomerHistoryDAO"%>
<%@page import="com.vimbox.database.LeadDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Leads History</title>
    </head>
    <body>
        <h2>Leads History</h2><hr>
        <%            
            String custId = request.getParameter("getId");
            ArrayList<Integer> ids = CustomerHistoryDAO.getCustomerLeadIds(Integer.parseInt(custId));
            if(ids.isEmpty()){
        %>
            No results found
        <%
            }else{
                if(ids.size()==1){
                    out.println(ids.size() + " record found");
                }else{
                    out.println(ids.size() + " records found");
                }
                ArrayList<Lead> leads = new ArrayList<Lead>();
                for(int id:ids){
                    leads.add(LeadDAO.getLeadById(id));
                }
        %>
        <br><br>
        <table border="1" width="100%">
            <tr>
                <th>#</th>
                <th>Cust Name</th>
                <th>Cust Contact</th>
                <th>Cust Email</th>
                <th>Status</th>
                <th>Date</th>
                <th>View</th>
            </tr>

            <%
                for (Lead lead : leads) {
                    out.println("<tr>");
                    out.println("<td>" + lead.getId() + "</td>");
                    Customer customer = lead.getCustomer();
                    out.println("<td>" + customer.toString() + "</td>");
                    out.println("<td>" + customer.getContact() + "</td>");
                    out.println("<td>" + customer.getEmail() + "</td>");
                    out.println("<td>" + lead.getStatus() + "</td>");
                    out.println("<td>" + Converter.convertDate(lead.getDt()) + "</td>");
            %>
            <td>
                <button onclick="viewLead('<%=lead.getId()%>')">VS</button>
                <!-- The Modal -->
                <div id="viewLeadModal<%=lead.getId()%>" class="lead-modal">
                    <!-- Modal content -->
                    <div class="lead-modal-content">
                        <div class="modal-body">
                            <span class="close" onclick="closeModal('viewLeadModal<%=lead.getId()%>')">×</span>
                            <div id="leadContent<%=lead.getId()%>"></div>
                        </div>
                    </div>
                </div>
                                
                <button onclick="viewFollowups('<%=lead.getId()%>')">VF</button>
                <!-- The Modal -->
                <div id="viewCommentsModal<%=lead.getId()%>" class="modal">
                    <!-- Modal content -->
                    <div class="modal-content">
                        <div class="modal-body">
                            <span class="close" onclick="closeModal('viewCommentsModal<%=lead.getId()%>')">×</span>
                            <div id="commentsContent<%=lead.getId()%>"></div> 
                        </div>
                    </div>
                </div>
            </td>
            <%
                }
            %>
        </table>  
        <%
            }
        %>
        
        <div id="lead_error_modal" class="modal">
            <div class="error-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('lead_error_modal')">×</span>
                    <div id="lead_error_status"></div>
                    <hr>
                    <div id="lead_error_message"></div>
                </div>
            </div>
        </div>
    </body>
</html>
