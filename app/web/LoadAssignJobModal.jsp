<%@page import="com.vimbox.operations.Job"%>
<%@page import="com.vimbox.database.JobDAO"%>
<%@page import="com.vimbox.database.UserDAO"%>
<%@page import="com.vimbox.user.User"%>
<%@page import="java.util.ArrayList"%>
<%
    String leadIds = request.getParameter("leadIds");
    ArrayList<User> users = UserDAO.getAllFullTimeMovers();
    ArrayList<Job> jobs = JobDAO.getJobsByLeadId(Integer.parseInt(leadIds.split("\\|")[0]));
    User supervisor = jobs.get(0).getSupervisor();
%>
<div class="form-horizontal" style="font-size: 14px;">
    <input type="hidden" id="leadIds" value="<%=leadIds%>">
    <div class="form-group">
        <label class="col-sm-3 control-label">Moving Supervisor: </label>
        <div class="col-sm-5">
            <div class="input-group">
                <select name="supervisor" class="form-control">
                    <%
                        for (User assignee : users) {
                            out.println("<option value='" + assignee.getNric() + "' ");
                            if(supervisor != null && supervisor.getNric().equals(assignee.getNric())){
                                out.println("selected");
                            }
                            out.println(">" + assignee + "</option>");
                        }
                    %>
                </select>
            </div>
        </div>
    </div>
    <div class="form-group text-center">
        <button class="btn btn-primary" onclick="assignJob()">Assign</button>
    </div>
</div>
