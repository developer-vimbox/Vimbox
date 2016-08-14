<%@page import="com.vimbox.customer.Customer"%>
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
    </head>
    <body>
        <%
            String keyword = request.getParameter("getKeyword");
            String status = request.getParameter("getStatus");
            
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
                results = TicketDAO.getSearchTicketsByNumber(keyword, status);
            }else if(dt != null){
                results = TicketDAO.getSearchTicketsByDate(keyword, status);
            }else{
                results = TicketDAO.getSearchTicketsByString(keyword, status);
            }
            
            if(!keyword.trim().isEmpty()){
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
                }
            }
        %>
        <br><br>
        <div id="resultsTable">
            <table class="table table-hover" width="100%">
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
                int ticketId = ticket.getTicket_id();
                Customer customer = ticket.getCustomer();
                String customerName = customer.toString();
                String contact  = customer.getContact() + "";
                if(contact.equals("0")){
                    contact = "N/A";
                }
                String email = customer.getEmail();
                if(email.isEmpty()){
                    email = "N/A";
                }
                String subject = ticket.getSubject();
                String dateTime = Converter.convertDate(ticket.getDatetime_of_creation());
                String ticket_status = ticket.getStatus();
        %>
                <tr>
                    <td><%=ticketId%></td>
                    <td><%=customerName%></td>
                    <td><%=contact%></td>
                    <td><%=email%></td>
                    <td><%=subject%></td>
                    <td><%=dateTime%></td>
                    <td><%=ticket_status%></td>
                    <td>
                        <button class="btn btn-default " onclick="viewTicket('<%=ticketId%>')">VT</button>
                        <button class="btn btn-default " onclick="viewComments('<%=ticketId%>')">VC</button>
                    </td>
                </tr>
        <%
            }
        %>
            </table>
        </div>
    </body>
</html>
