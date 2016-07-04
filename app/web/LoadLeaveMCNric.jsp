<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.hr.LeaveMC"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.UserLeaveDAO"%>
<h2>Leaves & MC History</h2>
<hr><br>
<%
    String nric = request.getParameter("nric");
    ArrayList<LeaveMC> leaveMCs = UserLeaveDAO.getLeaveMCRecordByNric(nric);
    if (leaveMCs.isEmpty()) {
        out.println("No results found");
    } else {
%>
<table border="1" width="100%">
    <col width="18%">
    <col width="18%">
    <col width="18%">
    <col width="18%">
    <col width="18%">
    <col width="10%">

    <tr>
        <th>Date</th>
        <th>Time</th>
        <th>Leave Type</th>
        <th>Leave Category</th>
        <th>Duration</th>
        <th>Image Proof</th>
    </tr>

    <%
        for (LeaveMC lmc : leaveMCs) {

    %>
    <tr>
        <td align="center"><%=Converter.convertDateHtml(lmc.getDate())%></td>
        <td align="center"><%=lmc.getTimeString()%></td>
        <td align="center"><%=lmc.getLeaveType()%></td>
        <td align="center"><%=lmc.getLeaveName()%></td>
        <td align="center">
            <%
                double leaveDuration = lmc.getLeaveDuration();
                if (leaveDuration < 9) {
                    out.println(leaveDuration + " H");
                } else {
                    out.println("Full Day");
                }
            %>
        </td>
        <td align="center">
            <%                String path = lmc.getImgPath();
                if (!path.isEmpty()) {
            %>
            <button onclick="viewMC()">View</button>
            <div id="view_mc_modal" class="modal">
                <!-- Modal content -->
                <div class="modal-content">
                    <div class="modal-body">
                        <span class="close" onclick="closeModal('view_mc_modal')">×</span>
                        <img src="${pageContext.request.contextPath}/Images/Rekted.png" />
                    </div>
                </div>
            </div>

            <%
                }
            %>

        </td>
    </tr>
    <%        }
        }
    %>
</table>