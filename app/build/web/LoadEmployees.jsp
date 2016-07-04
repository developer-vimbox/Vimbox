<%@page import="java.text.DecimalFormat"%>
<%@page import="com.vimbox.user.Bank"%>
<%@page import="com.vimbox.user.Emergency"%>
<%@page import="com.vimbox.user.Contact"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.database.UserDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.user.User"%>
<%
    String keyword = request.getParameter("keyword");
    String timer = request.getParameter("timer");
    ArrayList<User> users = new ArrayList<User>();
    if (timer.equals("full-time")) {
        users = UserDAO.getFullTimeUsersByKeyword(keyword);
    } else {
        users = UserDAO.getPartTimeUsersByKeyword(keyword);
    }
    if (!keyword.isEmpty()) {
        if (users.size() > 1) {
            out.println(users.size() + " results found");
        } else if (users.size() == 1) {
            out.println("1 result found");
        } else {
            out.println("No results found");
        }
        out.println("<br><br>");
    }
%>
<table border="1" width="100%">
    <col width="18%">
    <col width="18%">
    <col width="18%">
    <col width="18%">
    <col width="18%">
    <col width="10%">       
    <tr>
        <th>NRIC</th>
        <th>Name</th>
        <th>Date Joined</th>
        <th>Department</th>
        <th>Designation</th>
        <th>Action</th>
    </tr>
    <%
        DecimalFormat df = new DecimalFormat("#.0");
        for (User user : users) {
    %>
    <tr>
        <td align="center"><%=user.getNric()%></td>
        <td align="center"><%=user%></td>
        <td align="center"><%=Converter.convertDateHtml(user.getDate_joined())%></td>
        <td align="center"><%=user.getDepartment()%></td>
        <td align="center"><%=user.getDesignation()%></td>
        <td>
            <button onclick="editEmployee('<%=user.getNric()%>')">Edit</button>
            <div id="edit_employee_modal" class="form-modal">
                <!-- Modal content -->
                <div class="employee-form-modal-content">
                    <div class="modal-body">
                        <span class="close" onclick="closeModal('edit_employee_modal')">×</span>
                        <div id="employee_content"></div>
                    </div>
                </div>
            </div>

            <button onclick="viewEmployee('<%=user.getNric()%>')">View</button>
            <!-- The Modal -->
            <div id="viewEmployeeModal<%=user.getNric()%>" class="form-modal">
                <!-- Modal content -->
                <div class="modal-content">
                    <div class="modal-body">
                        <span class="close" onclick="closeModal('viewEmployeeModal<%=user.getNric()%>')">×</span>
                        <h3>Employee Details</h3><hr>
                        <fieldset>
                            <legend>Employee Details</legend>
                            <table>
                                <tr>
                                    <td align="right">Full Name :</td>
                                    <td><%=user%></td>
                                </tr>
                                <tr>
                                    <td align="right">NRIC :</td>
                                    <td><%=user.getNric()%></td>
                                </tr>
                                <tr>
                                    <td align="right">Date Joined :</td>
                                    <td><%=Converter.convertDateHtml(user.getDate_joined())%></td>
                                </tr>
                                <tr>
                                    <td align="right">Mailing Address :</td>
                                    <td><%=user.getMailing_address()%></td>
                                </tr>
                                <tr>
                                    <td align="right">Registered Address :</td>
                                    <td><%=user.getRegistered_address()%></td>
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
                                    <td align="right">Phone Number :</td>
                                    <td><%=phone%></td>
                                </tr>
                                <tr>
                                    <td align="right">Fax Number :</td>
                                    <td><%=fax%></td>
                                </tr>
                                <tr>
                                    <td align="right">Home Number :</td>
                                    <td><%=home%></td>
                                </tr>
                                <tr>
                                    <td align="right">Department :</td>
                                    <td><%=user.getDepartment()%></td>
                                </tr>
                                <tr>
                                    <td align="right">Designation :</td>
                                    <td><%=user.getDesignation()%></td>
                                </tr>
                                <tr>
                                    <td align="right">Basic Salary :</td>
                                    <td>
                                        <%
                                            String salary = user.getSalary() + "";
                                            if (salary.equals("0")) {
                                                salary = "";
                                            }
                                            out.println("$" + salary);
                                        %>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Annual Leave left :</td>
                                    <td>
                                        <%
                                            double leave = user.getLeave() - user.getUsed_leave();
                                            out.println(df.format(leave / 9) + " days");
                                        %>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">MC left :</td>
                                    <td>
                                        <%
                                            int mc = user.getMc() - user.getUsed_mc();
                                            out.println(mc + " days");
                                        %>
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                        <br>
                        <%
                            Emergency emergency = user.getEmergency();
                            String emergencyContact = emergency.getContact() + "";
                            if (emergencyContact.equals("0")) {
                                emergencyContact = "";
                            }

                            String emergencyOffice = emergency.getOffice() + "";
                            if (emergencyOffice.equals("0")) {
                                emergencyOffice = "";
                            }
                        %>
                        <fieldset>
                            <legend>Emergency Contact</legend>
                            <table>
                                <tr>
                                    <td align="right">Contact Person :</td>
                                    <td><%=emergency.getName()%></td>
                                </tr>
                                <tr>
                                    <td align="right">Relationship :</td>
                                    <td><%=emergency.getRelationship()%></td>
                                </tr>
                                <tr>
                                    <td align="right">Contact Number :</td>
                                    <td><%=emergencyContact%></td>
                                </tr>
                                <tr>
                                    <td align="right">Office Number :</td>
                                    <td><%=emergencyOffice%></td>
                                </tr>
                            </table>
                        </fieldset>
                        <br>
                        <%
                            Bank bank = user.getBank();
                        %>
                        <fieldset>
                            <legend>Payment Information</legend>
                            <table>
                                <tr>
                                    <td align="right">Method of Payment :</td>
                                    <td><%=bank.getPayment_mode()%></td>
                                </tr>
                                <tr>
                                    <td align="right">Bank Name :</td>
                                    <td><%=bank.getBank_name()%></td>
                                </tr>
                                <tr>
                                    <td align="right">Account Name :</td>
                                    <td><%=bank.getAccount_name()%></td>
                                </tr>
                                <tr>
                                    <td align="right">Account Number :</td>
                                    <td><%=bank.getAccount_no()%></td>
                                </tr>
                            </table>
                        </fieldset>
                    </div>
                </div>
            </div>

            <button onclick="loadLeaveMC('<%=user.getNric()%>')">L & MC</button>
            <div id="view_leavemc_modal" class="modal">
                <!-- Modal content -->
                <div class="modal-content">
                    <div class="modal-body">
                        <span class="close" onclick="closeModal('view_leavemc_modal')">×</span>
                        <div id="leavemc_content"></div>
                    </div>
                </div>
            </div>
        </td>
    </tr>
    <%
        }
    %>
</table>

<div id="employee_error_modal" class="modal">
    <!-- Modal content -->
    <div class="message-modal-content">
        <div class="modal-body">
            <span class="close" onclick="closeModal('employee_error_modal')">×</span>
            <div id="employee_error_status"></div>
            <hr>
            <div id="employee_error_message"></div>
        </div>
    </div>
</div>
