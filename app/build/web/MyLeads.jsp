<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.customer.Customer"%>
<%@page import="com.vimbox.database.LeadDAO"%>
<%@page import="com.vimbox.sales.Lead"%>
<%@page import="java.util.ArrayList"%>
<%@include file="ValidateLogin.jsp"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Leads</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <script src="JS/LeadFunctions.js"></script>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
    </head>
    <body>
        <h1>My Leads</h1><hr>
        <button onclick="location.href = 'CreateLead.jsp';">Add New</button>
        <br><br>
        <%            
            ArrayList<Lead> myLeads = LeadDAO.getLeadsByOwnerUser(user);
        %>
        <table border="1" width="100%">
            <tr>
                <th>#</th>
                <th>Cust Name</th>
                <th>Cust Contact</th>
                <th>Cust Email</th>
                <th>Status</th>
                <th>Date</th>
                <th>Action</th>
                <th>View</th>
            </tr>

            <%
                for (Lead lead : myLeads) {
                    String url = "window.location.href='EditLead.jsp?lId=" + lead.getId() + "'";
                    out.println("<tr>");
                    out.println("<td align='center'>" + lead.getId() + "</td>");
                    Customer customer = lead.getCustomer();
                    if(customer != null){
                        out.println("<td align='center'>" + customer.toString() + "</td>");
                        out.println("<td align='center'>" + customer.getContact() + "</td>");
                        out.println("<td align='center'>" + customer.getEmail() + "</td>");
                    }else{
                        out.println("<td align='center'></td>");
                        out.println("<td align='center'></td>");
                        out.println("<td align='center'></td>");
                    }
                    
                    out.println("<td align='center'>" + lead.getStatus() + "</td>");
                    out.println("<td align='center'>" + Converter.convertDate(lead.getDt()) + "</td>");
            %>
            <td>
                <%
                    if (!lead.getStatus().equals("Rejected") || ! !lead.getStatus().equals("Confirmed")) {
                %>

                <input type='button' value='E' onclick="<%=url%>">
                <button onclick="addFollowup('<%=lead.getId()%>')">F</button>
                <!-- The Modal -->
                <div id="commentModal<%=lead.getId()%>" class="modal">
                    <!-- Modal content -->
                    <div class="modal-content">
                        <div class="modal-body">
                            <span class="close" onclick="closeModal('commentModal<%=lead.getId()%>')">×</span>
                            <h3>Add Comment</h3>
                            <table>
                                <tr>
                                    <td>Lead ID :</td>
                                    <td><%=lead.getId()%><input type="hidden" id="comment_lead_id<%=lead.getId()%>" value="<%=lead.getId()%>" /></td>
                                </tr>
                                <tr>
                                    <td>Follow Up :</td>
                                    <td><textarea id="comment_lead_followup<%=lead.getId()%>" cols="75" rows="6" autofocus></textarea></td>
                                </tr>  
                                <tr>
                                    <td></td>
                                    <td><button onclick="followupLead(<%=lead.getId()%>)">Add Follow-Up</button></td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
                <%
                    }
                %>
            </td>
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
