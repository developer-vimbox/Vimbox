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

<input type="hidden" id="user_leave" value="<%=user.getLeave()%>">
<input type="hidden" id="user_used_leave" value="<%=user.getUsed_leave()%>">
<input type="hidden" id="user_mc" value="<%=user.getMc()%>">
<input type="hidden" id="user_used_mc" value="<%=user.getUsed_mc()%>">
<input type="hidden" id="employeeType" value="<%=user.getType()%>">
<div class="form-horizontal">
    <div class="form-group">
        <div class="col-sm-4 control-label">
            <h4>Employee Information </h4>
        </div>
        <div class="col-sm-6 control-label">
            <h4>Emergency Contact </h4>
        </div>
    </div>
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
    <div class="form-group">
        <label class="col-sm-1 control-label">First Name: </label>
        <div class="col-sm-4">
            <input class="form-control" type="text" id="user_first_name" value="<%=user.getFirst_name()%>">
        </div>
        <label class="col-sm-2 control-label">Contact Person Name: </label>
        <div class="col-sm-4">
            <input class="form-control" type="text" id="emergency_name" value="<%=emergency.getName()%>">
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-1 control-label">Last Name: </label>
        <div class="col-sm-4">
            <input class="form-control" type="text" id="user_last_name" value="<%=user.getLast_name()%>">
        </div>
        <label class="col-sm-2 control-label">Relationship:</label>
        <div class="col-sm-4">
            <input class="form-control" type="text" id="emergency_relationship" value="<%=emergency.getRelationship()%>">
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-1 control-label">NRIC: </label>
        <div class="col-sm-4">
            <input class="form-control" type="text" id="user_nric" value="<%=nric%>" disabled>
        </div>
        <label class="col-sm-2 control-label">Contact Number:</label>
        <div class="col-sm-4">
            <input class="form-control" type="number" min="0" id="emergency_contact" value="<%=eContact%>">
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-1 control-label">Date Joined: </label>
        <div class="col-sm-4">
            <input class="form-control" type="text" id="user_dj" value="<%=Converter.convertDateHtml(user.getDate_joined())%>" disabled>
        </div>
        <label class="col-sm-2 control-label">Office Number: </label>
        <div class="col-sm-4">
            <input class="form-control" type="number" min="0" id="emergency_office" value="<%=eOffice%>">
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-1 control-label">Mailing Address: </label>
        <div class="col-sm-4">
            <input class="form-control" type="text" id="user_madd" value="<%=user.getMailing_address()%>">
        </div>
        <div class="col-sm-5 control-label">
            <h4>Payment Information </h4>
        </div>
    </div>
    <%
        Bank bank = user.getBank();
    %>
    <div class="form-group">
        <label class="col-sm-1 control-label">Registered Address: </label>
        <div class="col-sm-4">
            <input class="form-control" type="text" id="user_radd" value="<%=user.getRegistered_address()%>">
        </div>
        <label class="col-sm-2 control-label">Method of Payment: </label>
        <div class="col-sm-4">
            <select class="form-control" id="user_payment">
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
        </div>
    </div>
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
    <div class="form-group">
        <label class="col-sm-1 control-label">Phone:</label>
        <div class="col-sm-4">
            <input class="form-control" type="number" min="0" id="user_phone" value="<%=phone%>">
        </div>
        <label class="col-sm-2 control-label">Bank Name: </label>
        <div class="col-sm-4">
            <input class="form-control" type="text" id="user_bank_name" value="<%=bank.getBank_name()%>">
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-1 control-label">Fax:</label>
        <div class="col-sm-4">
            <input class="form-control" type="number" min="0" id="user_fax" value="<%=fax%>">
        </div>
        <label class="col-sm-2 control-label">Account Name: </label>
        <div class="col-sm-4">
            <input class="form-control"  type="text" id="user_account_name" value="<%=bank.getAccount_name()%>">
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-1 control-label">Home:</label>
        <div class="col-sm-4">
            <input class="form-control" type="number" min="0" id="user_home" value="<%=home%>">
        </div>
        <label class="col-sm-2 control-label">Bank Account Number: </label>
        <div class="col-sm-4">
            <input class="form-control" type="text" id="user_account_no" value="<%=bank.getAccount_no()%>">
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-1 control-label">Department:</label>
        <%
            String userDepartment = user.getDepartment();
            String userDesignation = user.getDesignation();
        %>

        <div class="col-sm-4">
            <div id="full_time_department" <%if (user.getType().equals("Full")) {
                    out.println("style=\"display:block\"");
                } else {
                    out.println("style=\"display:none\"");
                }%>>
                <select class="form-control" id="user_department" onchange="loadDesignations()">
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
                <select class="form-control" id="user_department" onchange="loadDesignations()">
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
        </div>
    </div>

    <div class="form-group">
        <label class="col-sm-1 control-label">Designation: </label>
        <div class="col-sm-4">
            <div id="user_designation_div">
                <%
                    ArrayList<String> designations = new ArrayList<String>();
                    designations = UserPopulationDAO.getUserDesignations(user.getType(), userDepartment);

                    if (!designations.isEmpty()) {
                %>
                <select class="form-control" id="user_designation">
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
        </div>
    </div>
    <%
        String salary = user.getSalary() + "";
        if (salary.equals("0")) {
            salary = "";
        }
    %>
    <div class="form-group">
        <label class="col-sm-1 control-label">Basic Salary: </label>
        <div class="col-sm-4">
            <div class="input-group">
                <span class="input-group-addon">$</span>
                <input class="form-control" type="number" min="0" id="user_salary" value="<%=salary%>" placeholder="Salary">
            </div>
        </div>
    </div>    
    <div class="form-group text-center">
        <button class="btn btn-primary" onclick="updateEmployee()">Edit Employee</button>
    </div>

</div>





