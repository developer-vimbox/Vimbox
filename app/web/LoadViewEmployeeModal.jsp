<%@page import="java.text.DecimalFormat"%>
<%@page import="com.vimbox.user.Bank"%>
<%@page import="com.vimbox.user.Emergency"%>
<%@page import="com.vimbox.user.Contact"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.database.UserDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vimbox.user.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    DecimalFormat df = new DecimalFormat("#.0");
    String keyword = request.getParameter("empId");
    User user = UserDAO.getUserByNRIC(keyword);

%>
<!DOCTYPE html>
<!-- Modal content -->
<div class="modal-content">
   <span class="close" onclick="closeModal('viewEmployeeModal')">×</span>
        <center><h3 class="modal-title"><b>Employee Details</b></h3></center><hr>
        <div class="form-horizontal">
            <div class="form-group">
                <label class="col-sm-3 control-label">Full Name :</label>
                <div class="col-sm-6">
                    <%=user%>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">NRIC :</label>
                <div class="col-sm-6">
                    <%=user.getNric()%>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Date Joined :</label>
                <div class="col-sm-6">
                    <%=Converter.convertDateHtml(user.getDate_joined())%>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Mailing Address :</label>
                <div class="col-sm-6">
                    <%=user.getMailing_address()%>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Registered Address :</label>
                <div class="col-sm-6">
                    <%=user.getRegistered_address()%>
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
                <label class="col-sm-3 control-label">Phone Number :</label>
                <div class="col-sm-6">
                    <%=phone%>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Fax Number :</label>
                <div class="col-sm-6">
                    <%=fax%>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Home Number :</label>
                <div class="col-sm-6">
                    <%=home%>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Department :</label>
                <div class="col-sm-6">
                    <%=user.getDepartment()%>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Designation :</label>
                <div class="col-sm-6">
                    <%=user.getDesignation()%>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Basic Salary :</label>
                <div class="col-sm-6">
                    <%
                        String salary = user.getSalary() + "";
                        if (salary.equals("0")) {
                            salary = "";
                        }
                        out.println("$" + salary);
                    %>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Annual Leave Left :</label>
                <div class="col-sm-6">
                    <%
                        double leave = user.getLeave() - user.getUsed_leave();
                        out.println(df.format(leave / 9) + " days");
                    %>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">MC Left :</label>
                <div class="col-sm-6">
                    <%
                        int mc = user.getMc() - user.getUsed_mc();
                        out.println(mc + " days");
                    %>
                </div>
            </div>

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
            <div class="form-group">
                 <div class="col-sm-5 control-label">
                <b> Emergency Contact </b>
                 </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Contact Person :</label>
                <div class="col-sm-6">
                    <%=emergency.getName()%>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Relationship :</label>
                <div class="col-sm-6">
                    <%=emergency.getRelationship()%>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Contact Number:</label>
                <div class="col-sm-6">
                    <%=emergencyContact%>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Office Number :</label>
                <div class="col-sm-6">
                    <%=emergencyOffice%>
                </div>
            </div>

            <br>
            <%
                Bank bank = user.getBank();
            %>
            <div class="form-group">
                 <div class="col-sm-5 control-label">
                <b>Payment information </b>
                 </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Method of Payment :</label>
                <div class="col-sm-6">
                    <%=bank.getPayment_mode()%>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Bank Name :</label>
                <div class="col-sm-6">
                    <%=bank.getBank_name()%>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Account Number:</label>
                <div class="col-sm-6">
                    <%=bank.getAccount_no()%>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Account Name :</label>
                <div class="col-sm-6">
                    <%=bank.getAccount_name()%>
                </div>
            </div>
            
        </div>
</div>
