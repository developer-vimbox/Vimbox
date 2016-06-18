<%@page import="com.vimbox.database.UserDAO"%>
<%@page import="java.util.ArrayList"%>
<%@include file="ValidateLogin.jsp"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create new ticket</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/CustomerFunctions.js"></script>
        <script src="JS/TicketFunctions.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
        <style>
            #additionalAssigned{
                display:none;
            }
        </style>
    </head>
    <body>
        <%            ArrayList<User> users = UserDAO.getUsers();
        %>
        <h1>Create A Ticket</h1>
        <fieldset>
            <legend>Customer Information</legend>
            <input type="text" id="customer_search" placeholder="Enter customer name">
            <button onclick='customerSearch("ticket");return false;'>Search</button>
            <button onclick="addNewCustomer();return false;">Add New</button>

            <div id="customer_modal" class="modal">
                <div class="modal-content">
                    <div class="modal-body">
                        <span class="close" onclick="closeModal('customer_modal')">×</span>
                        <div id="customer_content"></div>
                    </div>
                </div>
            </div>

            <div id="customer_error_modal" class="modal">
                <div class="error-modal-content">
                    <div class="modal-body">
                        <span class="close" onclick="closeModal('customer_error_modal')">×</span>
                        <div id="customer_error_status"></div>
                        <hr>
                        <div id="customer_error_message"></div>
                    </div>
                </div>
            </div>

            <div id="customer_information_table" style="display:none">
                <hr>
                <input type="hidden" id="customer_id" name="customer_id">
                <table>
                    <tr>
                        <td align="right"><b>Salutation :</b></td>
                        <td>
                            <label id="customer_salutation"></label>
                        </td>
                    </tr>
                    <tr>
                        <td align="right"><b>First Name :</b></td>
                        <td>
                            <label id="customer_first_name"></label>
                        </td>
                    </tr>
                    <tr>
                        <td align="right"><b>Last Name :</b></td>
                        <td>
                            <label id="customer_last_name"></label>
                        </td>
                    </tr>
                    <tr>
                        <td align="right"><b>Contact Number :</b></td>
                        <td>
                            <label id="customer_contact"></label>
                        </td>
                    </tr>
                    <tr>
                        <td align="right"><b>Email :</b></td>
                        <td>
                            <label id="customer_email"></label>
                        </td>
                    </tr>
                </table>
            </div>
        </fieldset>
        <br>
        <fieldset>
            <legend>Ticket Information</legend>
            <table>
                <tr>
                    <td align="right"><b>Status :</b></td>
                    <td>Pending</td>
                </tr>
                <tr>
                    <td align="right"><b>Assigned To :</b></td>
                    <td>
                        <div id="dynamicInput">
                            <div id="1">
                                <table>
                                    <tr>
                                        <td>
                                            <select name="assigned">
                                                <%
                                                    for (User assignee : users) {
                                                        out.println("<option value='" + assignee.getNric() + "'>" + assignee + "</option>");
                                                    }
                                                %>
                                            </select>
                                        </td>
                                        <td><input type="button" value="+" onClick="addInput('dynamicInput');"></td>
                                    </tr>    
                                </table>
                            </div>
                        </div>
                        <div id="additionalAssigned">
                            <table>
                                <tr>
                                    <td>
                                        <select name="assigned">
                                            <%
                                                for (User assignee : users) {
                                                    out.println("<option value='" + assignee.getNric() + "'>" + assignee + "</option>");
                                                }
                                            %>
                                        </select>
                                    </td>
                                    <td><input type='button' value='x' onClick='removeAdditional(this);'></td>
                                </tr>    
                            </table>
                        </div>                    
                    </td>
                </tr>
                <tr>
                    <td align="right"><b>Subject :</b></td>
                    <td>
                        <input type="text" id="subject" size="84">
                    </td>
                </tr>
                <tr>
                    <td align="right"><b>Description :</b></td>
                    <td>
                        <textarea id="description" cols="75" rows="6"></textarea>
                    </td>
                </tr>
            </table>
        </fieldset>
        <br>                               
        <table>
            <tr>
                <td><button onclick="submitTicket()">Submit Ticket</button></td>
            </tr>
        </table> 
                                            
        <div id="ticket_error_modal" class="modal">
            <div class="error-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('ticket_error_modal')">×</span>
                    <div id="ticket_error_status"></div>
                    <hr>
                    <div id="ticket_error_message"></div>
                </div>
            </div>
        </div>
                                            
    </body>
</html>
