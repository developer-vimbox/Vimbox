<%@page import="com.vimbox.sales.LeadDiv"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.vimbox.sales.Item"%>
<%@page import="com.vimbox.customer.Customer"%>
<%@page import="com.vimbox.sales.Lead"%>
<%@page import="com.vimbox.database.LeadDAO"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="java.util.ArrayList"%>
<%
    String leadId = request.getParameter("getLid");
    Lead lead = LeadDAO.getLeadById(Integer.parseInt(leadId));
%>
<div class="row" style="display:table;width:100%;">
  <div class="col" style="display: table-cell;width: 50%;"><h2>Lead Details</h2></div>
  <div class="col" style="display: table-cell;width: 50%;float: right;">Status : <%=lead.getStatus()%></div>
</div>
<hr>
<table width='100%'>
    <col width="50%">
    <col width="50%">
    <tr>
        <td>
            <fieldset>
                <legend>Customer Info</legend>
                <table width='100%' style="min-height:120px">
                    <col width="20%">
                <%
                    Customer customer = lead.getCustomer();
                    if(customer != null){
                        out.println("<tr>");
                        out.println("<td align='right'><b>Name :</b></td>");
                        out.println("<td>" + customer.toString() + "</td>");
                        out.println("</tr>");
                        
                        out.println("<tr>");
                        out.println("<td align='right'><b>Contact :</b></td>");
                        out.println("<td>" + customer.getContact() + "</td>");
                        out.println("</tr>");
                        
                        out.println("<tr>");
                        out.println("<td align='right'><b>Email :</b></td>");
                        out.println("<td>" + customer.getEmail() + "</td>");
                        out.println("</tr>");
                    }
                %>
                </table>
            </fieldset>
        </td>
        <td>
            <fieldset>
                <legend>Lead Info</legend>
                <table width='100%' style="min-height:120px">
                    <col width="20%">
                    <tr>
                        <td align="right"><b>Lead ID :</b></td>
                        <td><%=lead.getId()%></td>
                    </tr>
                    <tr>
                        <td align="right"><b>Lead Type :</b></td>
                        <td>
                            <%
                                String[] leadTypes = lead.getType().split("\\|");
                                for(int i=0; i<leadTypes.length; i++){
                                    String leadType = leadTypes[i];
                                    out.println(leadType);
                                    if(i < leadTypes.length-1){
                                        out.println(", ");
                                    }
                                }
                            %>
                        </td>
                    </tr>
                    <tr>
                        <td align="right"><b>Source :</b></td>
                        <td><%=lead.getSource()%></td>
                    </tr>
                    <tr>
                        <td align="right"><b>Referral :</b></td>
                        <td><%=lead.getReferral()%></td>
                    </tr>
                    <%
                        if(lead.getStatus().equals("Rejected")){
                            out.println("<tr>");
                            out.println("<td align='right'><b>Reason :</b></td>");
                            out.println("<td>" + lead.getReason() + "</td>");
                            out.println("</tr>");
                        }
                    %>
                </table>
            </fieldset>
        </td>
    </tr>
    <tr>
        <td colspan="2">
            <fieldset>
                <legend>Moving Info</legend>
                <table>
                    <col width="100">
                    <tr>
                        <td align="right"><b>Move Type :</b></td>
                        <td>
                            <%
                                String[] toms = lead.getTom().split("\\|");
                                for (int i=0; i<toms.length; i++) {
                                    String tom = toms[i];
                                    out.println(tom);
                                    if(i<toms.length-1){
                                        out.println(", ");
                                    }
                                }
                            %>
                        </td>
                    </tr>
                    <tr>
                        <td align="right"><b>DOM :</b></td>
                        <td>
                            <%
                                String[] doms = lead.getDom().split("\\|");
                                for (int i=0; i<doms.length; i++) {
                                    String dom = doms[i];
                                    out.println(dom);
                                    if(i<doms.length-1){
                                        out.println(", ");
                                    }
                                }
                            %>
                        </td>
                    </tr>
                </table>
                <fieldset>
                    <b><u>Moving From</u></b><br>
                    <div style="overflow:auto;height:40px;">
                        <%
                            ArrayList<String[]> movingFroms = lead.getAddressFrom();
                            for(int i=0; i<movingFroms.size(); i++){
                                String[] movingFrom = movingFroms.get(i);
                                String address = movingFrom[0];
                                if(!address.isEmpty()){
                                    String[] addressDetails = address.split("_");
                                    out.println("<li>");
                                    out.println("Address " + (i+1) + " : " + addressDetails[0] + " #" + addressDetails[1] + "-" + addressDetails[2] + " S" + addressDetails[3]);
                                    out.println("</li>");
                                }
                            }
                        %>
                    </div>
                </fieldset>
                <br>
                <fieldset>
                    <b><u>Moving To</u></b><br>
                    <div style="overflow:auto;height:40px;">
                        <%
                            ArrayList<String[]> movingTos = lead.getAddressTo();
                            for(int i=0; i<movingTos.size(); i++){
                                String[] movingTo = movingTos.get(i);
                                String address = movingTo[0];
                                if(!address.isEmpty()){
                                    String[] addressDetails = address.split("_");
                                    out.println("<li>");
                                    out.println("Address " + (i+1) + " : " + addressDetails[0] + " #" + addressDetails[1] + "-" + addressDetails[2] + " S" + addressDetails[3]);
                                    out.println("</li>");
                                }
                            }
                        %>
                    </div>
                </fieldset>
            </fieldset>      
        </td>
    </tr>
<%
    if(lead.getType().contains("Enquiry")){
%>
<tr>
    <td colspan="2">
        <fieldset>
            <legend>Enquiry Info</legend>
            <table width="100%">
                <col width="10%">
                <tr>
                    <td align="right"><b>Enquiry :</b></td>
                    <td><%=lead.getEnquiry()%></td>
                </tr>
            </table>    
        </fieldset>
    </td>
</tr>
<%
    }
%>

<%
    if(lead.getType().contains("Sales")){
%>
    <tr>
        <td colspan="2">
            <fieldset>
                <legend>Sales Info</legend>
                <!-- Site Survey -->
                <table>
                    
                    
                </table>
                <br>
                <!-- Sales -->
                <table width="100%">
                    <tr height="95%">
                        <td style="width:60%">
                            <table width="100%" border="1" style="height:500px">
                                <tr style="background-color:DarkOrange" height="10%">
                                    <td align="center"><b><u>Customer Item List</u></b></td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="overflow:auto;height:100%;">
                                            <table style="width:100%;">
                                                <col width="30%">
                                                <col width="40%">
                                                <col width="10%">
                                                <col width="10%">
                                                <col width="10%">
                                                <tr>
                                                    <th>Item</th>
                                                    <th>Remarks</th>
                                                    <th>Charges</th>
                                                    <th>Qty</th>
                                                    <th>Units</th>
                                                </tr> 
                                               
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                                <tr style="background-color:CornflowerBlue" height="10%">
                                    <td align="center"><b><u>Vimbox Item List</u></b></td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="overflow:auto;height:100%;">
                                            <table style="width:100%;">
                                                <col width="30%">
                                                <col width="40%">
                                                <col width="10%">
                                                <col width="10%">
                                                <col width="10%">
                                                <tr>
                                                    <th>Item</th>
                                                    <th>Remarks</th>
                                                    <th>Charges</th>
                                                    <th>Qty</th>
                                                    <th>Units</th>
                                                </tr> 
                                                
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td>
                            <table width="100%" border="1" style="height:500px">
                                <tr style="height:5%;background-color:Plum;">
                                    <td align="center"><b><u>Customer Comments</u></b></td>
                                </tr>
                                <tr style="height:15%">
                                    <td>
                                        <div style="overflow:auto;height:100%;">
                                            
                                        </div>
                                    </td>
                                </tr>
                                <tr style="height:5%;background-color:Plum;">
                                    <td align="center"><b><u>Customer Remarks</u></b></td>
                                </tr>
                                <tr style="height:15%">
                                    <td>
                                        <div style="overflow:auto;height:100%;">
                                            
                                        </div>
                                    </td>
                                </tr>
                                <tr style="height:5%;background-color:DarkCyan;">
                                    <td align="center"><b><u>Services</u></b></td>
                                </tr>
                                <tr style="height:30%">
                                    <td>
                                        <div style="overflow:auto;height:100%;">
                                            <table width="100%">
                                                <col width="50">
                                                
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                                
                                <tr style='height:5%'>
                                    <td>
                                        <table width='100%'>
                                            <col width='50%'>
                                            <tr>
                                                <td>Storey Charges</td>
                                                <td align='right'>$ 
                                                    
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr style='height:5%'>
                                    <td>
                                        <table width='100%'>
                                            <col width='50%'>
                                            <tr>
                                                <td>Pushing Charges</td>
                                                <td align='right'>$
                                                    
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr style='height:5%'>
                                    <td>
                                        <table width='100%'>
                                            <col width='50%'>
                                            <tr>
                                                <td>Detour Charges</td>
                                                <td align='right'>$ 
                                                    
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr style='height:5%'>
                                    <td>
                                        <table width='100%'>
                                            <col width='50%'>
                                            <tr>
                                                <td>Material Charges</td>
                                                <td align='right'>$ 
                                                    
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr style='height:5%'>
                                    <td>
                                        <table width='100%'>
                                            <col width='50%'>
                                            <tr>
                                                <td>Markup</td>
                                                <td align='right'>$ 
                                                    
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" colspan="2">
                            Total : <b>S$ </b>
                        </td>
                    </tr>
                </table>    
            </fieldset>
        </td>
    </tr>
<%
    }
%>
</table>
