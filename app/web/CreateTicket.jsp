<%@include file="ValidateLogin.jsp"%>
<%@include file="PopulateAssigned.jsp"%>
<%@include file="TicketGeneration.jsp"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create new ticket</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/CustomerFunctions.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
    </head>
    <body>
        
        <h1>Create A Ticket</h1>
        
        <form method="POST" action="CreateTicketController" autocomplete="on">
            <table>
                <tr>
                    <td align="right"><b>Salutation :</b></td>
                    <td>
                        <select id="salutation" name="salutation" autofocus>
                            <option value="Mr">Mr</option>
                            <option value="Ms">Ms</option>
                            <option value="Mrs">Mrs</option>
                            <option value="Mdm">Mdm</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td align="right"><b>Name :</b></td>
                    <td>
                        <input type="text" id="name" name="name">
                        <button onclick="searchName();return false;">Search</button>
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
                        <input type="text" id="contact" name="contact" pattern="[0-9]{8,13}" autofocus oninvalid="this.setCustomValidity('Please enter a valid contact number')" oninput="setCustomValidity('')">
                        <input type="hidden" name="custId" id="custId" value="">
                    </td>
                </tr>
                <tr>
                    <td align="right"><b>Email :</b></td>
                    <td>
                        <input type="text" id="email" name="email" autofocus>
                    </td>
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
                                                    for(String fullname:fullnames){
                                                        out.println("<option value='" + fullname + "'>"+ fullname + "</option>");
                                                    }
                                                %>
                                            </select>
                                        </td>
                                        <td><input type="button" value="+" onClick="addInput('dynamicInput');"></td>
                                    </tr>    
                                </table>
                            </div>
                        </div>
                        
                    </td>
                </tr>
                <tr>
                    <td align="right"><b>Subject :</b></td>
                    <td>
                        <input type="text" required name="subject" size="84" autofocus oninvalid="this.setCustomValidity('Please enter a subject title')" oninput="setCustomValidity('')">
                    </td>
                </tr>
                <tr>
                    <td align="right"><b>Description :</b></td>
                    <td>
                        <textarea required name="description" cols="75" rows="6" autofocus autocomplete="off" oninvalid="this.setCustomValidity('Please enter ticket description')" oninput="setCustomValidity('')"></textarea>
                    </td>
                </tr>
                <tr>
                    <td align="right"><b>Status :</b></td>
                    <td>Pending</td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input type="submit" name="submit" value="Submit Ticket">
                    </td>
                </tr>
            </table>  
        </form>
        
                            
        <script>
            var counter = 2;
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
