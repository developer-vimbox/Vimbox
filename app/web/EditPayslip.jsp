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
<h1>Edit Payslip</h1>
<hr>
<fieldset>
    <legend>Payslip Information</legend>
    <input type="hidden" id="payslip_id" value="<%=payslip.getPayslip_id()%>">
    <table>
        <tr>
            <td align="right">Start Date :</td>
            <td>
                <input type="hidden" id="original_startDate" value="<%=Converter.convertDateHtml(payslip.getStartDate())%>">
                
                <input type="date" id="payslip_startDate" value="<%=Converter.convertDateHtml(payslip.getStartDate())%>"> &nbsp; End date :&nbsp;<input type="date" id="payslip_endDate" value="<%=Converter.convertDateHtml(payslip.getEndDate())%>">
                &nbsp; <button onclick="resetDates()">Reset Dates</button>
            </td>
        </tr>
        <tr>
            <td align="right">Payment Date :</td>
            <td>
                <input type="date" id="payslip_paymentDate" value="<%=Converter.convertDateHtml(payslip.getPaymentDate())%>">
            </td>
        </tr>
        <tr>
            <td align="right">Employee :</td>
            <td>
                <%=payslip.getUser()%>
                <input type="hidden" id="payslip_employee" value="<%=payslip.getUser().getNric()%>">
                <input type='hidden' id='original_basic' value="<%=payslip.getUser().getSalary()%>">
            </td>
        </tr>
        <tr>
            <td align="right">Mode of Payment :</td>
            <td>
                <select id="payslip_paymentMode">
                    <option value="">---SELECT---</option>
                    <%
                        String pm = payslip.getPaymentMode();
                        ArrayList<String> paymentModes = UserPopulationDAO.getUserPaymentModes();
                        for (String paymentMode : paymentModes) {
                            if (paymentMode.equals(pm)) {
                                out.println("<option value='" + paymentMode + "' selected>" + paymentMode + "</option>");
                            } else {
                                out.println("<option value='" + paymentMode + "'>" + paymentMode + "</option>");
                            }
                        }
                    %>
                </select>
            </td>
        </tr>
    </table>
</fieldset>
<br>
<fieldset>
    <legend>Payment Breakdown</legend>
    <table>
        <%
            DecimalFormat df = new DecimalFormat("#0.00");
        %>
        <col width='500px'>
        <tr>
            <td>
                <table width='100%' border='1'>
                    <col width='50%'>
                    <tr style="background-color:RoyalBlue">
                        <td colspan="2" align="center"><b>Basic & Allowance</b></td>
                    </tr>
                    <tr>
                        <td align="right" style="background-color:lightgrey">(A) Basic Pay :</td>
                        <td>
                            $ <label id="payslip_basic"><%=df.format(payslip.getBasicPay())%></label>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" style="background-color:lightgrey">(B) Total Allowances :</td>
                        <td>
                            $ <label id="payslip_allowance"><%=df.format(payslip.getTotalAllowances())%></label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan='2' align="center">Breakdown <button onclick="addPayslipBDEntry('payslip_abd')">+</button></td>
                    </tr>
                    <tr>
                        <td colspan='2'>
                            <table id="payslip_abd" valign="top" style="width:100%;" border="1">
                                <col width="50%">
                                <col width="40%">
                                <col width="10%">
                                <tbody>
                                    <%
                                        HashMap<String, Double> allowanceBD = payslip.getAllowanceBreakdown();
                                        if (!allowanceBD.isEmpty()) {
                                            for (Map.Entry<String, Double> entry : allowanceBD.entrySet()) {
                                                String key = entry.getKey();
                                                if(!key.isEmpty()){
                                    %>
                                    <tr>
                                        <td align='center'><input type='text' name='payslip_abddescription' size='27' value="<%=key%>" placeholder='description'></td>
                                        <td align='center'>$ <input type='number' step='0.01' min='0' name='payslip_abdamount' value='<%=df.format(entry.getValue())%>' placeholder='amount'></td>
                                        <td align='center'><input type='button' value='x' onclick='deleteEntry(this)'/>
                                    </tr>
                                    <%
                                                }
                                            }
                                        }
                                    %>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                    <tr style="background-color:RoyalBlue">
                        <td colspan="2" align="center"><b>Deduction</b></td>
                    </tr>
                    <tr>
                        <td align="right" style="background-color:lightgrey">(C) Total Deduction :</td>
                        <td>
                            $ <label id="payslip_deduction"><%=df.format(payslip.getTotalDeductions())%></label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan='2' align="center" onclick="addPayslipBDEntry('payslip_dbd')">Breakdown <button>+</button></td>
                    </tr>
                    <tr>
                        <td colspan='2'>
                            <table id="payslip_dbd" valign="top" style="width:100%;" border="1">
                                <col width="50%">
                                <col width="40%">
                                <col width="10%">
                                <tbody>
                                    <%
                                        HashMap<String, Double> deductionBD = payslip.getDeductionBreakdown();
                                        if (!deductionBD.isEmpty()) {
                                            for (Map.Entry<String, Double> entry : deductionBD.entrySet()) {
                                                String key = entry.getKey();
                                                if(!key.isEmpty()){
                                    %>
                                    <tr>
                                        <td align='center'><input type='text' name='payslip_dbddescription' size='27' value="<%=key%>" placeholder='description'></td>
                                        <td align='center'>$ <input type='number' step='0.01' min='0' name='payslip_dbdamount' value='<%=df.format(entry.getValue())%>' placeholder='amount'></td>
                                        <td align='center'><input type='button' value='x' onclick='deleteEntry(this)'/>
                                    </tr>
                                    <%
                                                }
                                            }
                                        }
                                    %>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                    <tr style="background-color:RoyalBlue">
                        <td colspan="2" align="center"><b>Overtime & Additional</b></td>
                    </tr>
                    <tr>
                        <td align="right">Overtime Hours Worked :</td>
                        <td>
                            <input type="number" id="payslip_ot" min='0' step='0.01' value='<%=payslip.getOvertimeHr()%>'>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">Overtime Rate :</td>
                        <td>
                            $ <select id='payslip_otRate'>
                                <%
                                    int rate = (int) (payslip.getOvertimePay() / payslip.getOvertimeHr());
                                    for (int i = 1; i <= 100; i++) {
                                        if (i == rate) {
                                            out.println("<option value='" + i + "' selected>" + i + "</option>");
                                        } else {
                                            out.println("<option value='" + i + "'>" + i + "</option>");
                                        }
                                    }
                                %>
                            </select> / hr
                        </td>
                    </tr>
                    <tr>
                        <td align="right" style="background-color:lightgrey">(D) Total Overtime Pay :</td>
                        <td>
                            $ <label id="payslip_overtime"><%=df.format(payslip.getOvertimePay())%></label>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" style="background-color:lightgrey">(E) Other Additional Payments :</td>
                        <td>
                            $ <label id="payslip_additional"><%=df.format(payslip.getAdditionalPayment())%></label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan='2' align="center">Breakdown <button onclick="addPayslipBDEntry('payslip_apbd')">+</button></td>
                    </tr>
                    <tr>
                        <td colspan='2'>
                            <table id="payslip_apbd" valign="top" style="width:100%;" border="1">
                                <col width="50%">
                                <col width="40%">
                                <col width="10%">
                                <tbody>
                                    <%
                                        HashMap<String, Double> additionalBD = payslip.getAddPaymentBreakdown();
                                        if (!additionalBD.isEmpty()) {
                                            for (Map.Entry<String, Double> entry : additionalBD.entrySet()) {
                                                String key = entry.getKey();
                                                if(!key.isEmpty()){
                                    %>
                                    <tr>
                                        <td align='center'><input type='text' name='payslip_apbddescription' size='27' value="<%=key%>" placeholder='description'></td>
                                        <td align='center'>$ <input type='number' step='0.01' min='0' name='payslip_apbdamount' value='<%=df.format(entry.getValue())%>' placeholder='amount'></td>
                                        <td align='center'><input type='button' value='x' onclick='deleteEntry(this)'/>
                                    </tr>
                                    <%
                                                }
                                            }
                                        }
                                    %>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                    <tr style="background-color:RoyalBlue">
                        <td colspan="2" align="center"><b>Total Pay</b></td>
                    </tr>
                    <tr>
                        <td align="right" style="background-color:lightgrey">Net Pay (A+B-C+D+E) :</td>
                        <td>
                            $ <label id="payslip_netpay"><%=df.format(payslip.getBasicPay() + payslip.getTotalAllowances() - payslip.getTotalDeductions() + payslip.getOvertimePay() + payslip.getAdditionalPayment())%></label>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" style="background-color:lightgrey">Employer's CPF Contribution :</td>
                        <td>
                            $ <input type="number" id="payslip_employerCpf" step="0.01" value='<%=df.format(payslip.getEmployerCpf())%>'>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</fieldset>
<br>
<button onclick="updatePayslip()">Edit Payslip</button>
