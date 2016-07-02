<%@page import="com.vimbox.user.Emergency"%>
<%@page import="com.vimbox.user.Bank"%>
<%@page import="com.vimbox.user.Contact"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.user.User"%>
<%@page import="com.vimbox.database.UserDAO"%>
<%@page import="com.vimbox.database.UserPopulationDAO"%>
<%@page import="java.util.ArrayList"%>
<%
    String nric = request.getParameter("empId");
    User user = UserDAO.getUserByNRIC(nric);
%>
<h1>Edit Employee</h1>
<input type="hidden" id="old_nric" value="<%=nric%>">
<input type="hidden" id="user_leave" value="<%=user.getLeave()%>">
<input type="hidden" id="user_used_leave" value="<%=user.getUsed_leave()%>">
<input type="hidden" id="user_mc" value="<%=user.getMc()%>">
<input type="hidden" id="user_used_mc" value="<%=user.getUsed_mc()%>">
<input type="hidden" id="employeeType" value="<%=user.getType()%>">
<hr>
<fieldset>
    <legend>Employee Information</legend>
    <table width="100%">
        <col width="200">
        <tr>
            <td align="right"><b>First Name :</b></td>
            <td><input type="text" id="user_first_name" value="<%=user.getFirst_name()%>"></td>
        </tr>
        <tr>
            <td align="right"><b>Last Name :</b></td>
            <td><input type="text" id="user_last_name" value="<%=user.getLast_name()%>"></td>
        </tr>
        <tr>
            <td align="right"><b>NRIC :</b></td>
            <td>
                <select id="user_nric_first_alphabet">
                    <%
                        char[] first_alphabets = {'S', 'T', 'F', 'G'};
                        for (char alphabet : first_alphabets) {
                            if (alphabet == nric.charAt(0)) {
                                out.println("<option value='" + alphabet + "' selected>" + alphabet + "</option>");
                            } else {
                                out.println("<option value='" + alphabet + "'>" + alphabet + "</option>");
                            }
                        }
                    %>
                </select>&nbsp;
                <input type="number" id="user_nric" value="<%=nric.substring(1, nric.length() - 1)%>">&nbsp;
                <select id="user_nric_last_alphabet">
                    <%
                        char[] last_alphabets = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
                        for (char alphabet : last_alphabets) {
                            if (alphabet == nric.charAt(nric.length() - 1)) {
                                out.println("<option value='" + alphabet + "' selected>" + alphabet + "</option>");
                            } else {
                                out.println("<option value='" + alphabet + "'>" + alphabet + "</option>");
                            }
                        }

                    %>
                </select>
            </td>
        </tr>
        <tr>
            <td align="right"><b>Date Joined :</b></td>
            <td><input type="hidden" id="user_dj" value="<%=Converter.convertDateHtml(user.getDate_joined())%>"><%=Converter.convertDateHtml(user.getDate_joined())%></td>
        </tr>
        <tr>
            <td align="right"><b>Mailing Address :</b></td>
            <td>
                <input type="text" id="user_madd" value="<%=user.getMailing_address()%>">
            </td>
        </tr>
        <tr>
            <td align="right"><b>Registered Address :</b><br>(if different from above)</td>
            <td>
                <input type="text" id="user_radd" value="<%=user.getRegistered_address()%>">
            </td>
        </tr>
        <%
            Contact contact = user.getContact();
            String phone = contact.getPhone() + "";
            if (phone.equals("0")) {
                phone = "";
            }
            String fax = contact.getFax() + "";
            if (fax.equals("0")) {
                fax = "";
            }
            String home = contact.getHome() + "";
            if (home.equals("0")) {
                home = "";
            }
        %>
        <tr>
            <td align="right"><b>Phone Number :</b></td>
            <td><input type="number" min="0" id="user_phone" value="<%=phone%>"></td>
        </tr>
        <tr>
            <td align="right"><b>Fax Number :</b></td>
            <td><input type="number" min="0" id="user_fax" value="<%=fax%>"></td>
        </tr>
        <tr>
            <td align="right"><b>Home Number :</b></td>
            <td><input type="number" min="0" id="user_home" value="<%=home%>"></td>
        </tr>
        <tr>
            <td align="right"><b>Department :</b></td>
            <td>
                <%
                    String userDepartment = user.getDepartment();
                    String userDesignation = user.getDesignation();
                %>

                <div id="full_time_department" <%if (user.getType().equals("Full")) {
                        out.println("style=\"display:block\"");
                    } else {
                        out.println("style=\"display:none\"");
                    }%>>
                    <select id="user_department" onchange="loadDesignations()">
                        <option value="">--Select--</option>
                        <%
                            ArrayList<String> fulltimeDepartments = UserPopulationDAO.getFullUserDepartments();
                            for (String department : fulltimeDepartments) {
                                if (department.equals(userDepartment)) {
                                    out.println("<option value='" + department + "' selected>" + department + "</option>");
                                } else {
                                    out.println("<option value='" + department + "'>" + department + "</option>");
                                }
                            }
                        %>
                    </select>
                </div>
                <div id="part_time_department" <%if (user.getType().equals("Part")) {
                        out.println("style=\"display:block\"");
                    } else {
                        out.println("style=\"display:none\"");
                    }%>>
                    <select id="user_department" onchange="loadDesignations()">
                        <option value="">--Select--</option>
                        <%
                            ArrayList<String> parttimeDepartments = UserPopulationDAO.getPartUserDepartments();
                            for (String department : parttimeDepartments) {
                                if (department.equals(userDepartment)) {
                                    out.println("<option value='" + department + "' selected>" + department + "</option>");
                                } else {
                                    out.println("<option value='" + department + "'>" + department + "</option>");
                                }
                            }
                        %>
                    </select>
                </div>
            </td>
        </tr>
        <tr>
            <td align="right"><b>Designation :</b></td>
            <td>
                <div id="user_designation_div">
                    <%
                        ArrayList<String> designations = new ArrayList<String>();
                        designations = UserPopulationDAO.getUserDesignations(user.getType(), userDepartment);

                        if (!designations.isEmpty()) {
                    %>
                    <select id="user_designation">
                        <%
                            for (String designation : designations) {
                                if (designation.equals(userDesignation)) {
                                    out.println("<option value='" + designation + "' selected>" + designation + "</option>");
                                } else {
                                    out.println("<option value='" + designation + "'>" + designation + "</option>");
                                }
                            }
                        %>    
                    </select>
                    <%
                        }
                    %>
                </div>
            </td>
        </tr>
        <%
            String salary = user.getSalary() + "";
            if (salary.equals("0")) {
                salary = "";
            }
        %>
        <tr>
            <td align="right"><b>Basic Salary :</b></td>
            <td>$ <input type="number" min="0" id="user_salary" value="<%=salary%>"></td>
        </tr>
    </table>
</fieldset>
<br>
<fieldset>
    <legend>Emergency Contact</legend>
    <table width="100%">
        <col width="200">
        <%
            Emergency emergency = user.getEmergency();
            String eContact = emergency.getContact() + "";
            if (eContact.equals("0")) {
                eContact = "";
            }

            String eOffice = emergency.getOffice() + "";
            if (eOffice.equals("0")) {
                eOffice = "";
            }
        %>
        <tr>
            <td align="right"><b>Contact Person Name :</b></td>
            <td><input type="text" id="emergency_name" value="<%=emergency.getName()%>"></td>
        </tr>
        <tr>
            <td align="right"><b>Relationship :</b></td>
            <td><input type="text" id="emergency_relationship" value="<%=emergency.getRelationship()%>"></td>
        </tr>
        <tr>
            <td align="right"><b>Contact Number :</b></td>
            <td><input type="number" min="0" id="emergency_contact" value="<%=eContact%>"></td>
        </tr>
        <tr>
            <td align="right"><b>Office Number :</b></td>
            <td><input type="number" min="0" id="emergency_office" value="<%=eOffice%>"></td>
        </tr>
    </table>
</fieldset>
<br>
<fieldset>
    <legend>Payment Information</legend>
    <table width="100%">
        <col width="200">
        <%
            Bank bank = user.getBank();
        %>
        <tr>
            <td align="right"><b>Method of payment :</b></td>
            <td>
                <select id="user_payment">
                    <%
                        String payment = bank.getPayment_mode();
                        ArrayList<String> paymentModes = UserPopulationDAO.getUserPaymentModes();
                        for (String paymentMode : paymentModes) {
                            if (payment.equals(paymentMode)) {
                                out.println("<option value='" + paymentMode + "' selected>" + paymentMode + "</option>");
                            } else {
                                out.println("<option value='" + paymentMode + "'>" + paymentMode + "</option>");
                            }
                        }
                    %>
                </select>
            </td>
        </tr>
        <tr>
            <td align="right"><b>Bank Name :</b></td>
            <td><input type="text" id="user_bank_name" value="<%=bank.getBank_name()%>"></td>
        </tr>
        <tr>
            <td align="right"><b>Account Name :</b></td>
            <td><input type="text" id="user_account_name" value="<%=bank.getAccount_name()%>"></td>
        </tr>
        <tr>
            <td align="right"><b>Bank Account Number :</b></td>
            <td><input type="text" id="user_account_no" value="<%=bank.getAccount_no()%>"></td>
        </tr>
    </table>
</fieldset>
<br>
<button onclick="updateEmployee()">Edit Employee</button>


