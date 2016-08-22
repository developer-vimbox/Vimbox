<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.customer.Customer"%>
<%@page import="com.vimbox.database.LeadDAO"%>
<%@page import="com.vimbox.sales.Lead"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Leads</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <script src="JS/LeadFunctions.js"></script>
        <style>
            /* Style the list */
            ul.tab {
                list-style-type: none;
                margin: 0;
                padding: 0;
                overflow: hidden;
                border: 1px solid #ccc;
                background-color: #f1f1f1;
            }

            /* Float the list items side by side */
            ul.tab li {float: left;}

            /* Style the links inside the list items */
            ul.tab li a {
                display: inline-block;
                color: black;
                text-align: center;
                padding: 14px 16px;
                text-decoration: none;
                transition: 0.3s;
                font-size: 17px;
            }

            /* Change background color of links on hover */
            ul.tab li a:hover {background-color: #ddd;}

            /* Create an active/current tablink class */
            ul.tab li a:focus, .active {background-color: #ccc;}

            /* Style the tab content */
            .tabcontent {
                display: none;
                padding: 6px 12px;
                border: 1px solid #ccc;
                border-top: none;
            }

            .tabcontent {
                -webkit-animation: fadeEffect 1s;
                animation: fadeEffect 1s; /* Fading effect takes 1 second */
            }

            @-webkit-keyframes fadeEffect {
                from {opacity: 0;}
                to {opacity: 1;}
            }

            @keyframes fadeEffect {
                from {opacity: 0;}
                to {opacity: 1;}
            }
        </style>
    </head>
    <body>
        <%@include file="header.jsp"%>

        <!-- The Modal -->
        <div id="commentModal" class="modal">
            <!-- Modal content -->
            <div class="modal-content" style="width: 450px;">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('commentModal')">×</span>
                    <center><h2>Follow Up Comment</h2></center>
                </div>
                <div class="modal-body">
                    <div id="comment-content"></div>
                </div>
            </div>
        </div>
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
        <!-- The Modal -->
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

        <!-- The Modal -->
        <div id="viewCommentsModal" class="modal">
            <!-- Modal content -->
            <div class="modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('viewCommentsModal')">×</span>
                    <div id="commentsContent"></div> 
                </div>
            </div>
        </div>
        <div id="viewFollowUpModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('viewFollowUpModal')">×</span>
                    <center><h2>Follow Up History</h2></center>
                </div>
                <div class="modal-body">
                    <div id="followUpContent"></div> 
                </div>
            </div>
        </div>
        <div id="page-content-wrapper">

            <div id="page-content">
                <div class="container" style="width: 100%;">
                    <div id="page-title">
                        <h2>My Leads</h2> <br>
                    </div>
                    <div class="panel">
                        <div class="panel-body">
                            <div class="form-horizontal">
                                <div class="form-group">
                                    <div class="col-sm-4">
                                        <button class="btn btn-default" onclick="location.href = 'CreateLead.jsp';">Add New</button>
                                        <br><br>
                                    </div>
                                    <%            ArrayList<Lead> myLeads = LeadDAO.getLeadsByOwnerUser(user);
                                    %>
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Type</th>
                                                <th>Cust Name</th>
                                                <th>Cust Contact</th>
                                                <th>Cust Email</th>
                                                <th>Status</th>
                                                <th>Date</th>
                                                <th>Action</th>
                                                <th>View</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                for (Lead lead : myLeads) {
                                                    String url = "window.location.href='EditLead.jsp?lId=" + lead.getId() + "'";
                                                    out.println("<tr>");
                                                    out.println("<td align='center'>" + lead.getId() + "</td>");
                                                    out.println("<td align='center'>" + lead.getType() + "</td>");

                                                    Customer customer = lead.getCustomer();
                                                    if (customer != null) {
                                                        out.println("<td align='center'>" + customer.toString() + "</td>");
                                                        out.println("<td align='center'>" + customer.getContact() + "</td>");
                                                        out.println("<td align='center'>" + customer.getEmail() + "</td>");
                                                    } else {
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

                                            <input class="btn btn-default" type='button' value='Edit' onclick="<%=url%>">
                                            <button class="btn btn-default" onclick="addFollowup('<%=lead.getId()%>')">Follow-Up</button>

                                            <%
                                                }
                                            %>
                                        </td>
                                        <td>
                                            <button class="btn btn-default" onclick="viewLead('<%=lead.getId()%>')">VS</button>

                                            <button class="btn btn-default" onclick="viewFollowups('<%=lead.getId()%>')">VF</button>

                                        </td>
                                        <%
                                            }
                                        %>
                                        </tbody>
                                    </table>  

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>


    </body>
</html>
