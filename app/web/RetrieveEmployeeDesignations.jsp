<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.UserPopulationDAO"%>
<%
    String department = request.getParameter("user_department");
    String type = request.getParameter("type");
    ArrayList<String> designations = new ArrayList<String>();
    if(!department.isEmpty()){
        designations = UserPopulationDAO.getUserDesignations(type, department);
    }
            
    if(!designations.isEmpty()){
%>
<select name="user_designation" id="user_designation" class="form-control">
<%    
        for(String designation:designations){
            out.println("<option value='" + designation + "'>" + designation + "</option>");
        }
%>    
</select>
<%
    }
%>