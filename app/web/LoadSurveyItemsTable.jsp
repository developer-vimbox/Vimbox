<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.LeadPopulationDAO"%>
<%
    String keyword = request.getParameter("keyword");
    String address = request.getParameter("address");
    String areaCounter = request.getParameter("areaCounter");
    String salesDiv = request.getParameter("salesDiv");
    ArrayList<String[]> results = LeadPopulationDAO.getExistingItemsSiteSurvey(keyword);
    ArrayList<String[]> spcResults = LeadPopulationDAO.getExistingSpecialItemsSiteSurvey(keyword);
    spcResults.addAll(results);
    results = spcResults;
%>

<table class='table table-bordered' id="<%=address%>_<%=areaCounter%>_ItemsTable" valign="top" style="width:100%;table-layout: fixed;border-color: #dfe8f1;" border="1">
    <%
        if (results.size() > 0) {
            if(keyword.isEmpty() || "boxes".contains(keyword.toLowerCase())){
                String[] result = null;
                // Print out the first row with Boxes in it //
                out.println("<tr>");
                String value = "Boxes||1";
    %>
    
                <td align="center" valign="top" style="word-wrap:break-word;" onclick="enterItem('<%=value%>', '<%=address%>', '<%=areaCounter%>', 'SelectedItemsTable', '<%=salesDiv%>'); return false;"><img src="/images/boxes.png" width="100%" height="200"><br><span>Boxes</span></td>
    
    <%
                try {
                    result = results.get(0);
                    value = result[0] + " " + result[1] + "|" + result[2] + "|" + result[3];
                    if(result.length > 5){
                        value += "|" + result[5];
                    }
    %>
    
                <td align="center" valign="top" style="word-wrap:break-word;" onclick="enterItem('<%=value%>', '<%=address%>', '<%=areaCounter%>', 'SelectedItemsTable', '<%=salesDiv%>'); return false;"><img src="<%=result[4]%>" width="100%" height="200"><br><span><%=result[0] + " " + result[1]%></span></td>
        
    <%
                } catch (Exception e) {
                    out.println("<td></td>");
                }

                try {
                    result = results.get(1);
                    value = result[0] + " " + result[1] + "|" + result[2] + "|" + result[3];
                    if(result.length > 5){
                        value += "|" + result[5];
                    }
    %>
    
                <td align="center" valign="top" style="word-wrap:break-word;" onclick="enterItem('<%=value%>', '<%=address%>', '<%=areaCounter%>', 'SelectedItemsTable', '<%=salesDiv%>'); return false;"><img src="<%=result[4]%>" width="100%" height="200"><br><span><%=result[0] + " " + result[1]%></span></td>
        
    <%
                } catch (Exception e) {
                    out.println("<td></td>");
                }
                out.println("</tr>");
                
                for (int i = 2; i < results.size(); i += 3) {
                    out.println("<tr>");
                
                    result = results.get(i);
                    value = result[0] + " " + result[1] + "|" + result[2] + "|" + result[3];
                    if(result.length > 5){
                        value += "|" + result[5];
                    }
    %>
    
                <td align="center" valign="top" style="word-wrap:break-word;" onclick="enterItem('<%=value%>', '<%=address%>', '<%=areaCounter%>', 'SelectedItemsTable', '<%=salesDiv%>'); return false;"><img src="<%=result[4]%>" width="100%" height="200"><br><span><%=result[0] + " " + result[1]%></span></td>
        
    <%
                    try {
                        result = results.get(i + 1);
                        value = result[0] + " " + result[1] + "|" + result[2] + "|" + result[3];
                        if(result.length > 5){
                            value += "|" + result[5];
                        }
    %>
                
                <td align="center" valign="top" style="word-wrap:break-word;" onclick="enterItem('<%=value%>', '<%=address%>', '<%=areaCounter%>', 'SelectedItemsTable', '<%=salesDiv%>'); return false;"><img src="<%=result[4]%>" width="100%" height="200"><br><span><%=result[0] + " " + result[1]%></span></td>
        
    <%
                    } catch (Exception e) {
                        out.println("<td></td>");
                    }

                    try {
                        result = results.get(i + 2);
                        value = result[0] + " " + result[1] + "|" + result[2] + "|" + result[3];
                        if(result.length > 5){
                            value += "|" + result[5];
                        }
    %>
                    
                <td align="center" valign="top" style="word-wrap:break-word;" onclick="enterItem('<%=value%>', '<%=address%>', '<%=areaCounter%>', 'SelectedItemsTable', '<%=salesDiv%>'); return false;"><img src="<%=result[4]%>" width="100%" height="200"><br><span><%=result[0] + " " + result[1]%></span></td>
        
    <%
                    } catch (Exception e) {
                        out.println("<td></td>");
                    }
                    out.println("</tr>");
                }
            }else{
            
                for (int i = 0; i < results.size(); i += 3) {
                    out.println("<tr>");

                    String[] result = results.get(i);
                    String value = result[0] + " " + result[1] + "|" + result[2] + "|" + result[3];
                    if(result.length > 5){
                        value += "|" + result[5];
                    }
    %>
    
                <td align="center" valign="top" style="word-wrap:break-word;" onclick="enterItem('<%=value%>', '<%=address%>', '<%=areaCounter%>', 'SelectedItemsTable', '<%=salesDiv%>'); return false;"><img src="<%=result[4]%>" width="100%" height="200"><br><span><%=result[0] + " " + result[1]%></span></td>
    
    <%
                    try {
                        result = results.get(i + 1);
                        value = result[0] + " " + result[1] + "|" + result[2] + "|" + result[3];
                        if(result.length > 5){
                            value += "|" + result[5];
                        }
    %>
    
                <td align="center" valign="top" style="word-wrap:break-word;" onclick="enterItem('<%=value%>', '<%=address%>', '<%=areaCounter%>', 'SelectedItemsTable', '<%=salesDiv%>'); return false;"><img src="<%=result[4]%>" width="100%" height="200"><br><span><%=result[0] + " " + result[1]%></span></td>
    
    <%
                    } catch (Exception e) {
                        out.println("<td></td>");
                    }

                    try {
                        result = results.get(i + 2);
                        value = result[0] + " " + result[1] + "|" + result[2] + "|" + result[3];
                        if(result.length > 5){
                            value += "|" + result[5];
                        }
    %>
    
                <td align="center" valign="top" style="word-wrap:break-word;" onclick="enterItem('<%=value%>', '<%=address%>', '<%=areaCounter%>', 'SelectedItemsTable', '<%=salesDiv%>'); return false;"><img src="<%=result[4]%>" width="100%" height="200"><br><span><%=result[0] + " " + result[1]%></span></td>
    
    <%
                    } catch (Exception e) {
                        out.println("<td></td>");
                    }
                    out.println("</tr>");
                }
            }
        }
    %>
</table>
