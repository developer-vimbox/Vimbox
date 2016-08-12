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
    <div class="form-horizontal">
        <div class="form-group">
            <div class="col-sm-5 control-label">
                <h4>Employee Information </h4>
            </div>
            <div class="col-sm-5 control-label">
                <h4>Emergency Contact </h4>
            </div>
        </div>
        <%                    Emergency emergency = user.getEmergency();
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
            <label class="col-sm-3 control-label">Full Name:</label>
            <div class="col-sm-3" style="padding-top: 7px;">
                <%=user%>
            </div>
            <label class="col-sm-2 control-label">Contact Person:</label>
            <div class="col-sm-3"  style="padding-top: 7px;">
                <%=emergency.getName()%>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-3 control-label">NRIC:</label>
            <div class="col-sm-3">
                <%=user.getNric()%>
            </div>
            <label class="col-sm-2 control-label">Relationship :</label>
            <div class="col-sm-3" style="padding-top: 7px;">
                <%=emergency.getRelationship()%>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-3 control-label">Date Joined :</label>
            <div class="col-sm-3" style="padding-top: 7px;">
                <%=Converter.convertDateHtml(user.getDate_joined())%>
            </div>
            <label class="col-sm-2 control-label">Contact Number:</label>
            <div class="col-sm-3" style="padding-top: 7px;">
                <%=emergencyContact%>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-3 control-label">Mailing Address :</label>
            <div class="col-sm-3" style="padding-top: 7px;">
                <%=user.getMailing_address()%>
            </div>
            <label class="col-sm-2 control-label">Office Number :</label>
            <div class="col-sm-3" style="padding-top: 7px;">
                <%=emergencyOffice%>
            </div>
        </div>
        <%
            Bank bank = user.getBank();
        %>
        <div class="form-group">
            <label class="col-sm-3 control-label">Registered Address :</label>
            <div class="col-sm-3" style="padding-top: 7px;">
                <%=user.getRegistered_address()%>
            </div>
            <div class="col-sm-4 control-label">
                <h4>Payment Information</h4>
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
            <div class="col-sm-3" style="padding-top: 7px;">
                <%=phone%>
            </div>
            <label class="col-sm-2 control-label">Method of Payment :</label>
            <div class="col-sm-3" style="padding-top: 7px;">
                <%=bank.getPayment_mode()%>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-3 control-label">Fax Number :</label>
            <div class="col-sm-3" style="padding-top: 7px;">
                <%=fax%>
            </div>
            <label class="col-sm-2 control-label">Bank Name :</label>
            <div class="col-sm-3" style="padding-top: 7px;">
                <%=bank.getBank_name()%>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-3 control-label">Home Number :</label>
            <div class="col-sm-3" style="padding-top: 7px;">
                <%=home%>
            </div>
            <label class="col-sm-2 control-label">Account Number:</label>
            <div class="col-sm-3" style="padding-top: 7px;">
                <%=bank.getAccount_no()%>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-3 control-label">Department :</label>
            <div class="col-sm-3" style="padding-top: 7px;">
                <%=user.getDepartment()%>
            </div>
            <label class="col-sm-2 control-label">Account Name :</label>
            <div class="col-sm-3" style="padding-top: 7px;">
                <%=bank.getAccount_name()%>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-3 control-label">Designation :</label>
            <div class="col-sm-3" style="padding-top: 7px;">
                <%=user.getDesignation()%>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-3 control-label">Basic Salary :</label>
            <div class="col-sm-3" style="padding-top: 7px;">
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
            <div class="col-sm-3" style="padding-top: 7px;">
                <%
                    double leave = user.getLeave() - user.getUsed_leave();
                    out.println((int)(leave / 8) + " days " + (int)(leave % 8) + " hours");
                %>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-3 control-label">MC Left :</label>
            <div class="col-sm-3" style="padding-top: 7px;">
                <%
                    int mc = user.getMc() - user.getUsed_mc();
                    out.println(mc + " days");
                %>
            </div>
        </div>
    </div>
