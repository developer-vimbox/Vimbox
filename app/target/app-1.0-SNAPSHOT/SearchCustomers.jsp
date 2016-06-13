<%@include file="ValidateLogin.jsp"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Search Customers</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script>src = "https://ajax.googleapis.com/ajax/libs/jquery/2.2.2/jquery.min.js" ></script>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
    </head>
    <body>
        <%
            ServletContext sc = request.getServletContext();
            String status = (String) sc.getAttribute("status");
            if(status != null){
                sc.removeAttribute("status");
                out.println("<h2>SUCCESS!</h2>");
                out.println("Customer details have been updated!<br><br>");
            }
        %>
        <table>
            <tr>
                <td>
                    <input type="text" id="name" name="name" autofocus>
                </td>
                <td>
                    <button onclick="searchName()">Search</button>
                </td>
            </tr>
        </table>
        <div id="results"></div>
        <div id="ticketsHistoryModel" class="modal">
            <!-- Modal content -->
            <div class="search-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('ticketsHistoryModel')">×</span>
                    <div id="ticketsHistoryContent"></div>
                </div>
            </div>
        </div>

        <script>
            function closeModal(modalName) {
                var modal = document.getElementById(modalName);
                modal.style.display = "none";
            }

            function searchName() {
                var name = document.getElementById("name").value;
                var results = document.getElementById("results");
                $.get("SearchCustomersByName.jsp", {getName: name, getAction: "crm"}, function (data) {
                    results.innerHTML = data;
                });
            }

            function viewTicketsHistory(custId) {
                var modal = document.getElementById("ticketsHistoryModel");
                var ticketsHistoryContent = document.getElementById("ticketsHistoryContent");
                $.get("TicketsHistory.jsp", {getId: custId}, function (data) {
                    ticketsHistoryContent.innerHTML = data;
                });
                modal.style.display = "block";
            }

            function viewTicket(ticketId) {
                var modal = document.getElementById("viewTicketModal" + ticketId);
                modal.style.display = "block";
            }
            function viewComments(ticketId) {
                var modal = document.getElementById("viewCommentsModal" + ticketId);
                var div1 = document.getElementById("commentsContent" + ticketId);
                $.get("RetrieveTicketComment.jsp", {getTid: ticketId}, function (data) {
                    div1.innerHTML = data;
                });
                modal.style.display = "block";
            }
        </script>
    </body>
</html>
