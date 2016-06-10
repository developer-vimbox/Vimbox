<%@page import="com.vimbox.user.User"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.database.TicketDAO"%>
<%@page import="org.joda.time.format.DateTimeFormatter"%>
<%@page import="org.joda.time.format.DateTimeFormat"%>
<%@page import="org.joda.time.DateTime"%>
<%@page import="com.vimbox.ticket.Ticket"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ticket Results</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script>src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.2/jquery.min.js"></script>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
    </head>
    <body>
        
        <h2>Search Results</h2><hr>
        <%
            String keyword = request.getParameter("getKeyword");
            String action = request.getParameter("getAction");
            
            ArrayList<Ticket> results = null;
            int num = 0;
            String string = "";
            DateTime dt = null;
            
            try{
                num = Integer.parseInt(keyword);
            }catch (NumberFormatException nfe){
                try{
                    DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd");
                    dt = formatter.parseDateTime(keyword);
                }catch (IllegalArgumentException iae){
                    string = keyword;
                }
            }
            
            if(num!=0){
                results = TicketDAO.getSearchTicketsByNumber(keyword, action);
            }else if(dt != null){
                results = TicketDAO.getSearchTicketsByDate(keyword, action);
            }else{
                results = TicketDAO.getSearchTicketsByString(keyword, action);
            }
            
            if(results.isEmpty()){  
        %>
            No results found
        <%
            }else{
                if(results.size()==1){
                    out.println(results.size() + " record found");
                }else{
                    out.println(results.size() + " records found");
                }
        %>
        <br><br>
        <div id="resultsTable">
            <table border="1" width="100%">
                <tr>
                    <th>Ticket ID</th>
                    <th>Cust Name</th>
                    <th>Cust Contact</th>
                    <th>Cust Email</th>
                    <th>Subject</th>
                    <th>Date & Time</th>
                    <th>Status</th>
                    <th>View</th>
                </tr>
        <%
            for(Ticket ticket:results){
                String ticketId = ticket.getTicketid();
                String customerName = ticket.getCustomerName();
                if(customerName.isEmpty()){
                    customerName = "N/A";
                }
                String contact  = ticket.getContactNumber();
                if(contact.isEmpty()){
                    contact = "N/A";
                }
                String email = ticket.getEmail();
                if(email.isEmpty()){
                    email = "N/A";
                }
                
                String subject = ticket.getSubject();
                String dateTime = Converter.convertDate(ticket.getDatetime());
                String status = ticket.getStatus();
        %>
                <tr>
                    <td><%=ticketId%></td>
                    <td><%=customerName%></td>
                    <td><%=contact%></td>
                    <td><%=email%></td>
                    <td><%=subject%></td>
                    <td><%=dateTime%></td>
                    <td><%=status%></td>
                    <td>
                        <button onclick="viewTicket('<%=ticketId%>')">VT</button>
                        <button onclick="viewComments('<%=ticketId%>')">VC</button>
                    </td>
                </tr>
        <%
            }
        %>
            </table>
        </div>
        <%
            }
        %>
    </body>
</html>
