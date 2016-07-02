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

<table width="100%" border="1">
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
        <button onclick="editPayslip('<%=employee.getNric() + ":" + Converter.convertDateDatabase(payslip.getStartDate())%>')">Edit</button>
        <div id="edit_payslip_modal" class="form-modal">
            <!-- Modal content -->
            <div class="payslip-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('edit_payslip_modal')">×</span>
                    <div id="edit_payslip_content"></div>
                </div>
            </div>
        </div>
                
        <button onclick="viewPayslip('<%=employee.getNric() + Converter.convertYearMonthPayslip(payslip.getStartDate())%>')">View</button>
        <div id="viewPayslipModal<%=employee.getNric() + Converter.convertYearMonthPayslip(payslip.getStartDate())%>" class="payslip-modal">
            <!-- Modal content -->
            <div class="payslip-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('viewPayslipModal<%=employee.getNric() + Converter.convertYearMonthPayslip(payslip.getStartDate())%>')">×</span>
                    <h3>Payslip Details</h3><hr>
                    <fieldset>
                        <legend>Payslip Information</legend>
                        <table>
                            <col width="100">
                            <tr>
                                <td align="right">Attention To :</td>
                                <td><%=employee%></td>
                            </tr>
                            <tr>
                                <td align="right">NRIC :</td>
                                <td><%=employee.getNric()%></td>
                            </tr>
                            <tr>
                                <td align="right">Payslip For :</td>
                                <td><%=Converter.convertDatePayslip(payslip.getStartDate())%> &nbsp; To :&nbsp; <%=Converter.convertDatePayslip(payslip.getEndDate())%></td>
                            </tr>
                        </table>
                    </fieldset>
                    <br>
                    <fieldset>
                        <legend>Payment Breakdown</legend>
                        <%
                            DecimalFormat df = new DecimalFormat("#,##0.00");
                        %>
                        <table width="100%">
                            <col width="50%">
                            <tr>
                                <td valign="top">
                                    <table width="100%" border="1">
                                        <col width="50%">
                                        <col width="30%">
                                        <col width="20%">
                                        <tr style="background-color:RoyalBlue">
                                            <td align="center">Item</td>
                                            <td colspan="2" align="center">Amount</td>
                                        </tr>
                                        <tr rowspan="2">
                                            <td style="background-color:lightgrey"><b>Basic Pay</b></td>
                                            <td align="center">S$<%=df.format(payslip.getBasicPay())%></td>
                                            <td align="center" style="background-color:lightgrey"><b>( A )</b></td>
                                        </tr>
                                        <tr rowspan="2">
                                            <td style="background-color:lightgrey"><b>Total Allowances</b></td>
                                            <td align="center">S$<%=df.format(payslip.getTotalAllowances())%></td>
                                            <td align="center" style="background-color:lightgrey"><b>( B )</b></td>
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
                                            <td style="background-color:lightgrey"><b>Total Deductions</b></td>
                                            <td align="center">S$<%=df.format(payslip.getTotalDeductions())%></td>
                                            <td align="center" style="background-color:lightgrey"><b>( C )</b></td>
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
                                    <table width="100%" border="1">
                                        <col width="50%">
                                        <col width="30%">
                                        <col width="20%">
                                        <tr style="background-color:RoyalBlue">
                                            <td colspan="3" align="center"><b>Date of Payment</b></td>
                                        </tr>
                                        <tr>
                                            <td colspan="3" align="center"><%=Converter.convertDatePayslip(payslip.getPaymentDate())%></td>
                                        </tr>
                                        <tr style="background-color:RoyalBlue">
                                            <td colspan="3" align="center"><b>Mode of Payment</b></td>
                                        </tr>
                                        <tr rowspan="2">
                                            <td colspan="3" align="center"><%=payslip.getPaymentMode()%></td>
                                        </tr>
                                        <tr style="background-color:RoyalBlue">
                                            <td colspan="3" align="center"><b>Overtime</b></td>
                                        </tr>
                                        <tr rowspan="2">
                                            <td style="background-color:lightgrey"><b>Overtime Hours Worked</b></td>
                                            <td align="center"><%=payslip.getOvertimeHr()%></td>
                                            <td align="center" style="background-color:lightgrey"></td>
                                        </tr>
                                        <tr rowspan="2">
                                            <td style="background-color:lightgrey"><b>Total Overtime Pay</b></td>
                                            <td align="center">S$<%=df.format(payslip.getOvertimePay())%></td>
                                            <td align="center" style="background-color:lightgrey"><b>( D )</b></td>
                                        </tr>
                                        <tr style="background-color:RoyalBlue">
                                            <td align="center">Item</td>
                                            <td colspan="2" align="center">Amount</td>
                                        </tr>
                                        <tr rowspan="2">
                                            <td style="background-color:lightgrey"><b>Other Additional Payments</b></td>
                                            <td align="center">S$<%=df.format(payslip.getAdditionalPayment())%></td>
                                            <td align="center" style="background-color:lightgrey"><b>( E )</b></td>
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
                                            <td style="background-color:lightgrey"><b>Net Pay (A+B+C+D+E)</b></td>
                                            <td align="center" colspan="2">S$<%=df.format(payslip.getBasicPay() + payslip.getTotalAllowances() - payslip.getTotalDeductions() + payslip.getOvertimePay() + payslip.getAdditionalPayment())%></td>
                                        </tr>
                                        <tr rowspan="2">
                                            <td style="background-color:lightgrey"><b>Employer's CPF Contribution</b></td>
                                            <td align="center" colspan="2">S$<%=df.format(payslip.getEmployerCpf())%></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </div>
            </div>
        </div>
    </td>
    <%
            out.println("</tr>");
        }
    %>
</table>
