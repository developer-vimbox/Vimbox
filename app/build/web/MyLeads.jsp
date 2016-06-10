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
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
    </head>
    <body>
        <%@include file="MyLeadsAction.jsp"%>
        <h1>My Leads</h1>
        <%            
            ArrayList<Lead> myLeads = LeadDAO.getLeadsByOwnerUser(user);
        %>
        <table border="1">
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
                    out.println("<td>" + lead.getId() + "</td>");
                    Customer customer = lead.getCustomer();
                    out.println("<td>" + customer.getName() + "</td>");
                    out.println("<td>" + customer.getContact() + "</td>");
                    out.println("<td>" + customer.getEmail() + "</td>");
                    out.println("<td>" + lead.getStatus() + "</td>");
                    out.println("<td>" + Converter.convertDate(lead.getDt()) + "</td>");
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
                            <form method="post" action="LeadFollowupController">
                                <table>
                                    <tr>
                                        <td>Lead ID :</td>
                                        <td><%=lead.getId()%><input type="hidden" name="id" value="<%=lead.getId()%>" /></td>
                                    </tr>
                                    <tr>
                                        <td>Follow Up :</td>
                                        <td><textarea required name="followup" cols="75" rows="6" autofocus autocomplete="off" oninvalid="this.setCustomValidity('Please enter a comment')" oninput="setCustomValidity('')"></textarea></td>
                                    </tr>  
                                </table>
                                <input type="submit" value="Add Follow-Up">
                            </form>
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
        <script>
            function closeModal(modalName) {
                var modal = document.getElementById(modalName);
                modal.style.display = "none";
            }
            function addFollowup(leadId) {
                var modal = document.getElementById("commentModal" + leadId);
                modal.style.display = "block";
            }
            function viewLead(leadId){
                var modal = document.getElementById("viewLeadModal" + leadId);
                var div1 = document.getElementById("leadContent" + leadId);
                $.get("RetrieveLeadDetails.jsp", {getLid: leadId}, function (data) {
                    div1.innerHTML = data;
                });
                modal.style.display = "block";
            }
            function viewFollowups(leadId) {
                var modal = document.getElementById("viewCommentsModal" + leadId);
                var div1 = document.getElementById("commentsContent" + leadId);
                $.get("RetrieveLeadFollowup.jsp", {getLid: leadId}, function (data) {
                    div1.innerHTML = data;
                });
                modal.style.display = "block";
            }
        </script>
    </body>
</html>
