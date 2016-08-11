<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.vimbox.user.User"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.database.PayslipDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.vimbox.hr.Payslip"%>
<%@page import="java.util.ArrayList"%>
<%
    String keyword = request.getParameter("keyword");
    ArrayList<Payslip> results = new ArrayList<Payslip>();
    results = PayslipDAO.getSearchPayslips(keyword);

    if (!keyword.isEmpty()) {
        if (results.size() > 1) {
            out.println(results.size() + " results found");
        } else if (results.size() == 1) {
            out.println("1 result found");
        } else {
            out.println("No results found");
        }
        out.println("<br><br>");
    }
%>

<table class="table">
    <col width="20%">
    <col width="20%">
    <col width="20%">
    <col width="20%">
    <col width="20%">
    <tr>
        <th>Payslip ID</th>
        <th>NRIC</th>
        <th>Employee Name</th>
        <th>Pay Month</th>
        <th>Actions</th>
    </tr>

    <%
        for (Payslip payslip : results) {
            User employee = payslip.getUser();
            out.println("<tr>");
            out.println("<td align='center'>" + payslip.getPayslip_id() + "</td>");
            out.println("<td align='center'>" + employee.getNric() + "</td>");
            out.println("<td align='center'>" + employee + "</td>");
            out.println("<td align='center'>" + Converter.convertYearMonthPayslip(payslip.getStartDate()) + "</td>");
    %>
    <td>
        <button onclick="editPayslip('<%=employee.getNric() + ":" + Converter.convertDateDatabase(payslip.getStartDate())%>')" data-toggle="modal" data-target="#edit_payslip_modal">Edit</button>
        <button data-toggle="modal" data-target="#viewPayslipModal">View</button>

        <div class="modal fade bs-example-modal-lg" id="viewPayslipModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog" style="width: 900px;">
                <div class="modal-content" style="width: 900px;">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h3>Payslip Details</h3>
                    </div>
                    <div class="modal-body">
                        <h3 class="title-hero">
                            Payslip Information
                        </h3> <hr>
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label class="col-sm-3 control-label">Attention To: </label>
                                <div class="col-sm-5">
                                    <label class="form-control"><%=employee%></label>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">NRIC: </label>
                                <div class="col-sm-5">
                                    <label class="form-control"><%=employee.getNric()%></label>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">Payslip For: </label>
                                <div class="col-sm-5">
                                    <label class="form-control"><%=Converter.convertDatePayslip(payslip.getStartDate())%></label>
                                    <center>To</center>
                                    <label class="form-control"><%=Converter.convertDatePayslip(payslip.getEndDate())%></label>
                                </div>
                            </div>
                        </div>
                        <br>
                        <h3 class="title-hero">
                            Payment Breakdown
                        </h3>
                        <%
                            DecimalFormat df = new DecimalFormat("#,##0.00");
                        %>
                        <table width="100%" class="table">
                            <col width="50%">
                            <tr>
                                <td valign="top">
                                    <table width="100%" class="table">
                                        <col width="50%">
                                        <col width="30%">
                                        <col width="20%">
                                        <tr>
                                            <th align="center"><b>Item</b<</th>
                                            <th colspan="2" align="center"><b>Amount</b></th>
                                        </tr>
                                        <tr rowspan="2">
                                            <td><b>Basic Pay</b></td>
                                            <td align="center">S$<%=df.format(payslip.getBasicPay())%></td>
                                            <td align="center"><b>( A )</b></td>
                                        </tr>
                                        <tr rowspan="2">
                                            <td><b>Total Allowances</b></td>
                                            <td align="center">S$<%=df.format(payslip.getTotalAllowances())%></td>
                                            <td align="center"><b>( B )</b></td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">(Breakdown shown below)</td>
                                        </tr>
                                        <%
                                            HashMap<String, Double> allowanceBD = payslip.getAllowanceBreakdown();
                                            if (!allowanceBD.isEmpty()) {
                                                for (Map.Entry<String, Double> entry : allowanceBD.entrySet()) {
                                        %>
                                        <tr>
                                            <td align="center">
                                                <%
                                                    String key = entry.getKey();
                                                    if (!key.isEmpty()) {
                                                        out.println(key);
                                                    } else {
                                                        out.println("&nbsp;");
                                                    }
                                                %>
                                            </td>
                                            <td colspan="2" align="center">
                                                <%
                                                    double value = entry.getValue();
                                                    if (value > 0) {
                                                        out.println("S$" + df.format(value));
                                                    } else {
                                                        out.println("&nbsp;");
                                                    }
                                                %>
                                            </td>
                                        </tr>
                                        <%
                                                }
                                            }
                                            if (allowanceBD.size() < 4) {
                                                for (int i = 0; i < (4 - allowanceBD.size()); i++) {
                                        %>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td colspan="2">&nbsp;</td>
                                        </tr>
                                        <%
                                                }
                                            }
                                        %>
                                        <tr rowspan="2">
                                            <td><b>Total Deductions</b></td>
                                            <td align="center">S$<%=df.format(payslip.getTotalDeductions())%></td>
                                            <td align="center"><b>( C )</b></td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">(Breakdown shown below)</td>
                                        </tr>
                                        <%
                                            HashMap<String, Double> deductionBD = payslip.getDeductionBreakdown();
                                            if (!deductionBD.isEmpty()) {
                                                for (Map.Entry<String, Double> entry : deductionBD.entrySet()) {
                                        %>
                                        <tr>
                                            <td align="center">
                                                <%
                                                    String key = entry.getKey();
                                                    if (!key.isEmpty()) {
                                                        out.println(key);
                                                    } else {
                                                        out.println("&nbsp;");
                                                    }
                                                %>
                                            </td>
                                            <td colspan="2" align="center">
                                                <%
                                                    double value = entry.getValue();
                                                    if (value > 0) {
                                                        out.println("S$" + df.format(value));
                                                    } else {
                                                        out.println("&nbsp;");
                                                    }
                                                %>
                                            </td>
                                        </tr>
                                        <%
                                                }
                                            }
                                            if (deductionBD.size() < 5) {
                                                for (int i = 0; i < (5 - deductionBD.size()); i++) {
                                        %>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td colspan="2">&nbsp;</td>
                                        </tr>
                                        <%
                                                }
                                            }
                                        %>
                                    </table>
                                </td>
                                <td valign="top">
                                    <table width="100%" class="table">
                                        <col width="50%">
                                        <col width="30%">
                                        <col width="20%">
                                        <tr>
                                            <th colspan="3" align="center"><b>Date of Payment</b></th>
                                        </tr>
                                        <tr>
                                            <td colspan="3" align="center"><%=Converter.convertDatePayslip(payslip.getPaymentDate())%></td>
                                        </tr>
                                        <tr>
                                            <th colspan="3" align="center"><b>Mode of Payment</b></th>
                                        </tr>
                                        <tr rowspan="2">
                                            <td colspan="3" align="center"><%=payslip.getPaymentMode()%></td>
                                        </tr>
                                        <tr>
                                            <th colspan="3" align="center"><b>Overtime</b></th>
                                        </tr>
                                        <tr rowspan="2">
                                            <td><b>Overtime Hours Worked</b></td>
                                            <td align="center"><%=payslip.getOvertimeHr()%></td>
                                            <td></td>
                                        </tr>
                                        <tr rowspan="2">
                                            <td><b>Total Overtime Pay</b></td>
                                            <td align="center">S$<%=df.format(payslip.getOvertimePay())%></td>
                                            <td align="center"><b>( D )</b></td>
                                        </tr>
                                        <tr>
                                            <th align="center">Item</th>
                                            <th colspan="2" align="center">Amount</th>
                                        </tr>
                                        <tr rowspan="2">
                                            <td><b>Other Additional Payments</b></td>
                                            <td align="center">S$<%=df.format(payslip.getAdditionalPayment())%></td>
                                            <td align="center"><b>( E )</b></td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">(Breakdown shown below)</td>
                                        </tr>
                                        <%
                                            HashMap<String, Double> additionalBD = payslip.getAddPaymentBreakdown();
                                            if (!additionalBD.isEmpty()) {
                                                for (Map.Entry<String, Double> entry : additionalBD.entrySet()) {
                                        %>
                                        <tr>
                                            <td align="center">
                                                <%
                                                    String key = entry.getKey();
                                                    if (!key.isEmpty()) {
                                                        out.println(key);
                                                    } else {
                                                        out.println("&nbsp;");
                                                    }
                                                %>
                                            </td>
                                            <td colspan="2" align="center">
                                                <%
                                                    double value = entry.getValue();
                                                    if (value > 0) {
                                                        out.println("S$" + df.format(value));
                                                    } else {
                                                        out.println("&nbsp;");
                                                    }
                                                %>
                                            </td>
                                        </tr>
                                        <%
                                                }
                                            }

                                            if (additionalBD.size() < 3) {
                                                for (int i = 0; i < (3 - additionalBD.size()); i++) {
                                        %>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td colspan="2">&nbsp;</td>
                                        </tr>
                                        <%
                                                }
                                            }
                                        %>
                                        <tr>
                                            <td><b>Net Pay (A+B+C+D+E)</b></td>
                                            <td align="center" colspan="2">S$<%=df.format(payslip.getBasicPay() + payslip.getTotalAllowances() - payslip.getTotalDeductions() + payslip.getOvertimePay() + payslip.getAdditionalPayment())%></td>
                                        </tr>
                                        <tr rowspan="2">
                                            <td><b>Employer's CPF Contribution</b></td>
                                            <td align="center" colspan="2">S$<%=df.format(payslip.getEmployerCpf())%></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <button onclick="confirmDelete('<%=payslip.getPayslip_id()%>', 'payslip')">Delete</button>
    </td>
    <%
            out.println("</tr>");
        }
    %>
</table>

<div id="payslip_error_modal" class="modal">
    <!-- Modal content -->
    <div class="message-modal-content">
        <div class="modal-body">
            <span class="close" onclick="closeModal('payslip_error_modal')">×</span>
            <div id="payslip_error_status"></div>
            <hr>
            <div id="payslip_error_message"></div>
        </div>
    </div>
</div>
