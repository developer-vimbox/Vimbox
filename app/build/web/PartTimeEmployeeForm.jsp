<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.UserPopulationDAO"%>
<h1>Part-Time Employee</h1>
<hr>
<fieldset>
    <legend>Employee Information</legend>
    <table width="100%">
        <col width="150">
        <tr>
            <td align="right"><b>First Name :</b></td>
            <td><input type="text" id="pt_first_name"></td>
        </tr>
        <tr>
            <td align="right"><b>Last Name :</b></td>
            <td><input type="text" id="pt_last_name"></td>
        </tr>
        <tr>
            <td align="right"><b>NRIC :</b></td>
            <td>
                <select id="pt_nric_first_alphabet">
                    <option value="S">S</option>
                    <option value="T">T</option>
                    <option value="F">F</option>
                    <option value="G">G</option>
                </select>&nbsp;
                <input type="number" id="pt_nric" style="width: 72px;">&nbsp;
                <select id="pt_nric_last_alphabet">
                <%
                    char[] alphabets = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
                    for(char alphabet:alphabets){
                        out.println("<option value='" + alphabet + "'>" + alphabet + "</option>");
                    }
                %>
                </select>
            </td>
        </tr>
        <tr>
            <td align="right"><b>Contact :</b></td>
            <td><input type="number" id="pt_contact"></td>
        </tr>
        <tr>
            <td align="right"><b>Date Joined :</b></td>
            <td><input type="date" id="pt_dj" style="width: 155px;"></td>
        </tr>
        <tr>
            <td align="right"><b>Designation :</b></td>
            <td>
                <select id="pt_designation" style="width: 160px;">
                    <option value="">------------Select------------</option>
            <%
                ArrayList<String> designations = UserPopulationDAO.getPartTimeUserDesignations();
                for(String designation:designations){
                    out.println("<option value='" + designation + "'>" + designation + "</option>");
                }
            %>    
                </select>
            </td>
        </tr>
    </table>
</fieldset>
<br>
<button onclick="addPartTimeEmployee()">Add Part Time Employee</button>
