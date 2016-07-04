<%@page import="com.vimbox.util.Converter"%>
<%@page import="java.util.Map"%>
<%@page import="com.vimbox.user.User"%>
<%@page import="com.vimbox.database.UserDAO"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.vimbox.hr.LeaveMC"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.UserLeaveDAO"%>
<%
    String keyword = request.getParameter("keyword");

    HashMap<String, ArrayList<LeaveMC>> leaveMCs = UserLeaveDAO.getLeaveMCRecordsByKeyword(keyword);
    ArrayList<User> users = UserDAO.getFullTimeUsersByKeyword(keyword);
    if (leaveMCs.isEmpty()) {
        for (User employee : users) {
            String nric = employee.getNric();
            ArrayList<LeaveMC> userLeaveMCs = UserLeaveDAO.getLeaveMCRecordByNric(nric);
            leaveMCs.put(nric, userLeaveMCs);
        }
    }

    if (!keyword.isEmpty()) {
        if (leaveMCs.size() >= 1) {
            out.println("Results found :");
        } else {
            out.println("No results found");
        }
        out.println("<br><br>");
    }
%>
<table border="1" width="100%">
    <tr>
        <th>NRIC</th>
        <th>Employee</th>
        <th>Date</th>
        <th>Time</th>
        <th>Leave Type</th>
        <th>Leave Category</th>
        <th>Duration</th>
        <th>Action</th>
    </tr>

    <%
        for (Map.Entry<String, ArrayList<LeaveMC>> entry : leaveMCs.entrySet()) {
            String nric = entry.getKey();
            User employee = null;
            for (User emp : users) {
                if (emp.getNric().equals(nric)) {
                    employee = emp;
                    break;
                }
            }
            ArrayList<LeaveMC> userLeaveMCs = entry.getValue();
            for (LeaveMC leaveMC : userLeaveMCs) {
    %>
    <tr>
        <td align="center"><%=nric%></td>
        <td align="center"><%=employee%></td>
        <td align="center"><%=Converter.convertDateHtml(leaveMC.getDate())%></td>
        <td align="center"><%=leaveMC.getTimeString()%></td>
        <td align="center"><%=leaveMC.getLeaveType()%></td>
        <td align="center"><%=leaveMC.getLeaveName()%></td>
        <td align="center">
            <%
                double leaveDuration = leaveMC.getLeaveDuration();
                if (leaveDuration < 9) {
                    out.println(leaveDuration + " H");
                } else {
                    out.println("Full Day");
                }
            %>
        </td>
        <td align="center">
            <%                String path = leaveMC.getImgPath();
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
            
             <button onclick="confirmDelete('<%=nric + "_" + Converter.convertDateHtml(leaveMC.getDate())%>', 'leave_mc')">Delete</button>
        </td>
    </tr>
    <%
            }
        }
    %>
</table>

<div id="leave_mc_error_modal" class="modal">
    <!-- Modal content -->
    <div class="message-modal-content">
        <div class="modal-body">
            <span class="close" onclick="closeModal('leave_mc_error_modal')">×</span>
            <div id="leave_mc_error_status"></div>
            <hr>
            <div id="leave_mc_error_message"></div>
        </div>
    </div>
</div>