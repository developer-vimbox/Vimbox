<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.database.UserPopulationDAO"%>
<h1>Full-Time Employee</h1>
<hr>
<fieldset>
    <legend>Employee Information</legend>
    <table width="100%">
        <col width="150">
        <tr>
            <td align="right"><b>First Name :</b></td>
            <td><input type="text" id="ft_first_name"></td>
        </tr>
        <tr>
            <td align="right"><b>Last Name :</b></td>
            <td><input type="text" id="ft_last_name"></td>
        </tr>
        <tr>
            <td align="right"><b>NRIC :</b></td>
            <td>
                <select id="ft_nric_first_alphabet">
                    <option value="S">S</option>
                    <option value="T">T</option>
                    <option value="F">F</option>
                    <option value="G">G</option>
                </select>&nbsp;
                <input type="number" id="ft_nric" style="width: 72px;">&nbsp;
                <select id="ft_nric_last_alphabet">
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
            <td><input type="number" id="ft_contact"></td>
        </tr>
        <tr>
            <td align="right"><b>Address :</b></td>
            <td>
                <table>
                    <tr>
                        <td><input type="text" id="ft_add_rd"></td>
                    </tr>
                    <tr>
                        <td>
                            #<input type="number" id="ft_add_level" min="0" style="width:30px"> - <input type="number" id="ft_add_unit" min="0" style="width:40px">
                            S<input type="text" id="ft_add_postal" size="3">
                        </td>
                    </tr>
                </table>  
            </td>
        </tr>
        <tr>
            <td align="right"><b>Date Joined :</b></td>
            <td><input type="date" id="ft_dj" style="width: 155px;"></td>
        </tr>
        <tr>
            <td align="right"><b>Designation :</b></td>
            <td>
                <select id="ft_designation" style="width: 160px;">
                    <option value="">------------Select------------</option>
            <%
                ArrayList<String> designations = UserPopulationDAO.getUserDesignations();
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
<fieldset>
    <legend>User Account Information</legend>
    <table width="100%">
        <col width="150">
        <tr>
            <td align="right"><b>Email Address :</b></td>
            <td><input type="text" id="ft_username"></td>
        </tr>
        <tr>
            <td align="right"><b>Password :</b></td>
            <td><input type="password" id="ft_password"></td>
        </tr>
    </table>
</fieldset>
<br>
<button onclick="addFullTimeEmployee()">Add Full Time Employee</button>