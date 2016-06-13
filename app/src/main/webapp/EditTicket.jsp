<%@page import="com.vimbox.util.Converter"%>
<%@include file="ValidateLogin.jsp"%>
<%@include file="PopulateAssigned.jsp"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Ticket</title>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/CustomerFunctions.js"></script>
        <script src="JS/ModalFunctions.js"></script>
    </head>
    <body>
        <%@include file="EditTicketCheck.jsp"%>
        <a href="MyTickets.jsp">Back</a><br>
        <%
            if(ticket!=null){
                String customerName = ticket.getCustomerName();
                String salutation = "";
                String name = "";
                if(!customerName.isEmpty()){
                    salutation = customerName.substring(0,customerName.indexOf(" "));
                    name = customerName.substring(customerName.indexOf(" ")+1);
                }
                String contact = ticket.getContactNumber();
                String email = ticket.getEmail();
                String subject = ticket.getSubject();
                String description = ticket.getDescription();
                ArrayList<User> assigned = ticket.getAssigned();
        %>
        <form method="POST" action="EditTicketController" autocomplete="on">
            <table>
                <tr>
                    <td align="right"><b>Ticket ID :</b></td>
                <input type='hidden' name='ticketId' value='<%=ticket.getTicketid()%>'><td><%=ticket.getTicketid()%></td>
                </tr>
                <tr>
                    <td align="right"><b>Salutation :</b></td>
                    <td>
                        <select name="salutation" autofocus>
                            <%
                                String[] sals = new String[]{"Mr","Ms","Mrs","Mdm"};
                                for(String sal:sals){
                                    if(sal.equals(salutation)){
                                        out.println("<option value='" + sal + "' selected>" + sal + "</option>");
                                    }else{
                                        out.println("<option value='" + sal + "'>" + sal + "</option>");
                                    }
                                }
                            %>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td align="right"><b>Name :</b></td>
                    <td>
                        <input type="text" id="name" name="name" value='<%=name%>' autofocus>
                        <button class="customer-search" onclick="searchName();return false;">Search</button>
                        <!-- The Modal -->
                        <div id="snModal" class="modal">
                            <!-- Modal content -->
                            <div class="modal-content">
                                <div class="modal-body">
                                    <span class="close" onclick="closeModal('snModal')">×</span>
                                    <div id="snContent"></div>
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td align="right"><b>Contact Number :</b></td>
                    <td>
                        <input type="number" id="contact" name="contact" value='<%=contact%>' autofocus>
                        <input type="hidden" name="dbExist" id="dbExist" value='<%=contact%>'>
                    </td>
                </tr>
                <tr>
                    <td align="right"><b>Email :</b></td>
                    <td>
                        <input type="text" id="email" name="email" value='<%=email%>' autofocus>
                    </td>
                </tr>
                <tr>
                    <td align="right"><b>Assigned To :</b></td>
                    <td>
                        <div id="dynamicInput">
                        <%
                            for(int i = 0; i<assigned.size(); i++){
                                User assign = assigned.get(i);
                                out.println("<div id='" + i + "'><table><tr><td><select name='assigned'>");
                                for(String fullname:fullnames){
                                    if(fullname.equals(assign.getFullname())){
                                        out.println("<option value='" + fullname + "' selected>"+ fullname + "</option>");
                                    }else{
                                        out.println("<option value='" + fullname + "'>"+ fullname + "</option>");
                                    }
                                }
                                out.println("</select></td><td>");
                                if(i == 0){
                                    out.println("<input type='button' value='+' onClick=\"addInput('dynamicInput');\">");
                                }else{
                                    out.println("<input type='button' value='x' onClick='removeInput("+i+");'>");
                                }
                                out.println("</td></tr></table></div>");
                            }

                        %>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td align="right"><b>Subject :</b></td>
                    <td>
                        <input type="text" required name="subject" size="84" autofocus oninvalid="this.setCustomValidity('Please enter a subject title')" oninput="setCustomValidity('')" value='<%=subject%>'>
                    </td>
                </tr>
                <tr>
                    <td align="right"><b>Description :</b></td>
                    <td>
                        <textarea required name="description" cols="75" rows="6" autofocus autocomplete="off" oninvalid="this.setCustomValidity('Please enter ticket description')" oninput="setCustomValidity('')"><%=description%></textarea>
                    </td>
                </tr>
                <tr>
                    <td align="right"><b>Status :</b></td>
                    <td>Pending</td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input type="submit" name="submit" value="Edit Ticket">
                    </td>
                </tr>
            </table>  
        </form>
        
        <%
            }
        %>
        <script>
            var counter = 10000;
            function addInput(divName){
                var newdiv = document.createElement('div');
                var stringDiv = "";
                var jsArray = <%= Converter.toJavascriptArray(fullnames) %>;
                stringDiv += "<div id='" + counter + "'><table><tr><td><select name='assigned'>";
                for (i = 0; i < jsArray.length; i++) { 
                    stringDiv += "<option value='" + jsArray[i] + "'>" + jsArray[i] + "</option>";
                }
                stringDiv +="</select></td><td><input type='button' value='x' onClick='removeInput("+counter+");'></td></tr></table></div>";
                newdiv.innerHTML = stringDiv;
                document.getElementById(divName).appendChild(newdiv);
                counter++;
            }
        </script>
    </body>
</html>
