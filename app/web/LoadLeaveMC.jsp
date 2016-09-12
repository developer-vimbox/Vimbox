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
    ArrayList<User> employees = UserDAO.getFullTimeUsers();
    
    if (leaveMCs.isEmpty()) {
        ArrayList<User> users = UserDAO.getFullTimeUsersByKeyword(keyword);
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
<table class="table table-hover">
    <thead>
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
    </thead>

    <%
        for (Map.Entry<String, ArrayList<LeaveMC>> entry : leaveMCs.entrySet()) {
            String nric = entry.getKey();
            User employee = null;
            for (User emp : employees) {
                if (emp.getNric().equals(nric)) {
                    employee = emp;
                    break;
                }
            }
            ArrayList<LeaveMC> userLeaveMCs = entry.getValue();
            for (LeaveMC leaveMC : userLeaveMCs) {
    %>
    <tbody>
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
            <form method="post" class="btn" style="
    padding-left: 0px;
    padding-right: 0px;
    border-left-width: 0px;
    border-right-width: 0px;
    border-top-width: 0px;
    border-bottom-width: 0px;
">
                <input type="hidden" name="mc_name" value="<%=path%>">
                <input class="btn btn-default" type="submit" value="MC" formaction="mcs/<%=employee.getNric()%>" formtarget="_blank"> 
            </form>
            <%
                }
            %>
            
             <button class="btn btn-default" onclick="confirmDelete('<%=nric + "_" + Converter.convertDateHtml(leaveMC.getDate())%>', 'leave_mc')">Delete</button>
        </td>
    </tr>
    </tbody>
    <%
            }
        }
    %>
</table>

