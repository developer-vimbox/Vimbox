<%@page import="com.vimbox.database.LeadPopulationDAO"%>
<%@page import="java.util.ArrayList"%>
<%
    ArrayList<String[]> results = LeadPopulationDAO.getAdminExistingItemsSiteSurvey("");
    ArrayList<String[]> spcResults = LeadPopulationDAO.getAdminExistingSpecialItemsSiteSurvey("");
    spcResults.addAll(results);
    results = spcResults;
%>
<table class='table table-bordered' valign="top" style="width:100%;table-layout: fixed;border-color: #dfe8f1;" border="1">
    <%
        if (results.size() > 0) {
            for (int i = 0; i < results.size(); i += 3) {
                out.println("<tr>");

                String[] result = results.get(i);
                String value = result[0] + "|" + result[1] + "|" + result[2] + "|" + result[3] + "|" + result[4] + "|" + result[5];
    %>

    <td align="center" valign="top" style="word-wrap:break-word;" onclick="editItem('<%=value%>', 'item')"><img src="<%=result[4]%>" width="100%" height="200"><br><span><%=result[0] + " " + result[1]%></span></td>

    <%
        try {
            result = results.get(i + 1);
            value = result[0] + "|" + result[1] + "|" + result[2] + "|" + result[3] + "|" + result[4] + "|" + result[5];
    %>

    <td align="center" valign="top" style="word-wrap:break-word;" onclick="editItem('<%=value%>', 'item')"><img src="<%=result[4]%>" width="100%" height="200"><br><span><%=result[0] + " " + result[1]%></span></td>

    <%
        } catch (Exception e) {
            out.println("<td></td>");
        }

        try {
            result = results.get(i + 2);
            value = result[0] + "|" + result[1] + "|" + result[2] + "|" + result[3] + "|" + result[4] + "|" + result[5];
    %>

    <td align="center" valign="top" style="word-wrap:break-word;" onclick="editItem('<%=value%>', 'item')"><img src="<%=result[4]%>" width="100%" height="200"><br><span><%=result[0] + " " + result[1]%></span></td>

    <%
                } catch (Exception e) {
                    out.println("<td></td>");
                }
                out.println("</tr>");
            }

        }
    %>
</table>