<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.database.PayslipDAO"%>
<%@page import="com.vimbox.hr.Payslip"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.vimbox.database.UserPopulationDAO"%>
<%@page import="java.util.ArrayList"%>
<%
    String payslipId = request.getParameter("empId");
    String[] array = payslipId.split(":");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    Payslip payslip = PayslipDAO.getPayslip(array[0], sdf.parse(array[1]));
%>
<input type="hidden" id="payslip_id" value="<%=payslip.getPayslip_id()%>">
<div class="form-horizontal" style="font-size: 14px; color: black;">
    <div class="form-group">
        <div class="col-sm-6">
            <h3 class="mrg10A">Payslip Information </h3>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label">Attention To: </label>
        <div class ="col-sm-5" style="padding-top: 7px;">
            <%=payslip.getUser()%>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label">NRIC: </label>
        <div class ="col-sm-5" style="padding-top: 7px;">
            <%=payslip.getUser().getNric()%>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label">Payslip For: </label>
        <div class ="col-sm-7" style="padding-top: 7px;">
            <u><%=Converter.convertDatePayslip(payslip.getStartDate())%></u> &nbsp; To &nbsp; <u><%=Converter.convertDatePayslip(payslip.getEndDate())%></u>
        </div>
    </div>
    <hr>
    <div class="form-group">
        <div class="col-sm-6">
            <h3 class="mrg10A">Payment Breakdown </h3>
        </div>
    </div>
</div>
<%
    DecimalFormat df = new DecimalFormat("#,##0.00");
%>
<table width="100%" class="table">
    <col width="50%">
    <tr>
        <td valign="top">
            <table width="100%" class="table table-hover">
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
            <table width="100%" class="table table-hover">
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
                    <th align="center"><b>Item</b></th>
                    <th colspan="2" align="center"><b>Amount</b></th>
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

