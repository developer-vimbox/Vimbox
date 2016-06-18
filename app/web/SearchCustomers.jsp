<%@include file="ValidateLogin.jsp"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Search Customers</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/CustomerFunctions.js"></script>
        <script src="JS/TicketFunctions.js"></script>
        <script src="JS/LeadFunctions.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
    </head>
    <body onload='reload()'>
        <table>
            <tr>
                <td>
                    <input type="text" id="customer_search" autofocus>
                </td>
                <td>
                    <button onclick='customerSearch("crm")'>Search</button>
                </td>
            </tr>
        </table>
        
        <div id="customer_modal">
            <div id="customer_content"></div>
        </div>
        
        <div id="edit_customer_modal" class="modal">
            <div class="modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('edit_customer_modal')">×</span>
                    <div id="edit_customer_content"></div>
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
        
        <div id="ticketsHistoryModel" class="modal">
            <!-- Modal content -->
            <div class="search-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('ticketsHistoryModel')">×</span>
                    <div id="ticketsHistoryContent"></div>
                </div>
            </div>
        </div>
        
        <div id="leadsHistoryModel" class="modal">
            <!-- Modal content -->
            <div class="search-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('leadsHistoryModel')">×</span>
                    <div id="leadsHistoryContent"></div>
                </div>
            </div>
        </div>
    </body>
</html>
