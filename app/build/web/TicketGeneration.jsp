<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.user.User"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.ticket.Ticket"%>
<%
    ServletContext sc = request.getServletContext();
    String errorMsg = (String)sc.getAttribute("errorMsg");
    Ticket ticket = (Ticket)sc.getAttribute("ticket");
    
    if(errorMsg != null){
        sc.removeAttribute("errorMsg");
        String[] errors = errorMsg.split(":");
        out.println("<h2>Errors in Ticket Generation: </h2><br><ul>");
        for(int i=0; i<errors.length-1;i++){
            out.println("<li>" + errors[i] + "</li>");
        }
        out.println("</ul>");
    }
    
    if(ticket != null){
        sc.removeAttribute("ticket");
        out.println("<h2>Ticket Generated!</h2>");
        out.println("<table>");
        out.println("<tr><td align='right'>Date & Time :</td><td>" + Converter.convertDate(ticket.getDatetime()) + "</td></tr>");
        out.println("<tr><td align='right'>Ticket Id :</td><td>" + ticket.getTicketid() + "</td></tr>");
        out.println("<tr><td align='right'>Status :</td><td>" + ticket.getStatus() + "</td></tr>");
        out.println("<tr><td align='right'>Subject :</td><td>" + ticket.getSubject() + "</td></tr>");
      
        out.println("<tr><td align='right'>Cust Name :</td><td>");
        String customerName = ticket.getCustomerName();
        if(customerName.isEmpty()){
            out.println("Not provided");
        }else{
            out.println(customerName);
        }
        out.println("</td></tr>");
        
        out.println("<tr><td align='right'>Cust Contact :</td><td>");
        String contactNumber = ticket.getContactNumber();
        if(contactNumber.isEmpty()){
            out.println("Not provided");
        }else{
            out.println(contactNumber);
        }
        out.println("</td></tr>");
        
        out.println("<tr><td align='right'>Assigned To :</td><td>");
        ArrayList<User> assigned = ticket.getAssigned();
        if(assigned.size()>1){
            for(User assign:assigned){
                out.println("<li>" + assign.getFullname() + "</li>");
            }
        }else{
            out.println(assigned.get(0).getFullname());
        }
        out.println("</td>");
        out.println("</table>");
    }
%>
