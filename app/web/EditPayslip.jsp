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
<div class="form-horizontal">
    <div class="form-group">
        <div class="col-sm-6">
            <h3 class="mrg10A">Payslip Information </h3>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label">Start Date: </label>
        <div class="col-sm-5">
            <input type="hidden" id="original_startDate" value="<%=Converter.convertDateHtml(payslip.getStartDate())%>">
            <input type="date" id="payslip_startDate" class="form-control" value="<%=Converter.convertDateHtml(payslip.getStartDate())%>">
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label">End Date: </label>
        <div class="col-sm-5">
            <input type="date" class="form-control" id="payslip_endDate" value="<%=Converter.convertDateHtml(payslip.getEndDate())%>">
        </div>
        <div class="col-sm-2">
            <button class="btn btn-default" onclick="resetDates()">Reset Dates</button>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label">Payment Date: </label>
        <div class="col-sm-5">
            <input type="date" class="form-control" id="payslip_paymentDate" value="<%=Converter.convertDateHtml(payslip.getPaymentDate())%>">
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label">Employee: </label>
        <div class="col-sm-5">
            <label class="form-control"><%=payslip.getUser()%></label> 
            <input type="hidden" id="payslip_employee" value="<%=payslip.getUser().getNric()%>">
            <input type='hidden' id='original_basic' value="<%=payslip.getUser().getSalary()%>">
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-3 control-label">Mode of Payment: </label>
        <div class="col-sm-5">
            <select id="payslip_paymentMode" class="form-control">
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
        </div>
    </div>
</div>
<div class="form-horizontal">
    <hr>
    <div class="form-group">
        <div class="col-sm-6">
            <h3 class="mrg10A">Payment Breakdown </h3>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label"></label>
        <div class="col-sm-8">
            <table style="width: 100%;">
                <%
                    DecimalFormat df = new DecimalFormat("#0.00");
                %>
                <tr>
                    <td>
                        <table class="table table-hover">
                            <col width='50%'>
                            <tr>
                                <th colspan="2" align="center"><b>Basic & Allowance</b></th>
                            </tr>
                            <tr>
                                <td align="right"><b>(A) Basic Pay :</b></td>
                                <td>
                                    $ <label id="payslip_basic"><%=df.format(payslip.getBasicPay())%></label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>(B) Total Allowances :</b></td>
                                <td>
                                    $ <label id="payslip_allowance"><%=df.format(payslip.getTotalAllowances())%></label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan='2' align="center"><button onclick="addPayslipBDEntry('payslip_abd')" class="btn btn-default">Add Breakdown</button></td>
                            </tr>
                            <tr>
                                <td colspan='2'>
                                    <table id="payslip_abd" valign="top" style="width:100%;">
                                        <col width="50%">
                                        <col width="40%">
                                        <col width="10%">
                                        <tbody>
                                            <%
                                                HashMap<String, Double> allowanceBD = payslip.getAllowanceBreakdown();
                                                if (!allowanceBD.isEmpty()) {
                                                    for (Map.Entry<String, Double> entry : allowanceBD.entrySet()) {
                                                        String key = entry.getKey();
                                                        if (!key.isEmpty()) {
                                            %>
                                            <tr>
                                                <td align='center'><input type='text' class="form-control" name='payslip_abddescription' size='27' value="<%=key%>" placeholder='description'></td>
                                                <td align='center'>
                                                    <div class='input-group' style='margin-left: 5px;'>
                                                        <span class='input-group-addon'>$</span>
                                                        <input type='number' class="form-control" step='0.01' min='0' name='payslip_abdamount' value='<%=df.format(entry.getValue())%>' placeholder='amount'>
                                                    </div>
                                                </td>
                                                <td align='center'><input type='button' class='btn btn-warning' value='x' onclick='deleteEntry(this)'/>
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
                            <tr>
                                <th colspan="2" align="center"><b>Deduction</b></th>
                            </tr>
                            <tr>
                                <td align="right"><b>(C) Total Deduction :</b></td>
                                <td>
                                    $ <label id="payslip_deduction"><%=df.format(payslip.getTotalDeductions())%></label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan='2' align="center"><button onclick="addPayslipBDEntry('payslip_dbd')" class="btn btn-default">Add Breakdown</button></td>
                            </tr>
                            <tr>
                                <td colspan='2'>
                                    <table id="payslip_dbd" valign="top" style="width:100%;">
                                        <col width="50%">
                                        <col width="40%">
                                        <col width="10%">
                                        <tbody>
                                            <%
                                                HashMap<String, Double> deductionBD = payslip.getDeductionBreakdown();
                                                if (!deductionBD.isEmpty()) {
                                                    for (Map.Entry<String, Double> entry : deductionBD.entrySet()) {
                                                        String key = entry.getKey();
                                                        if (!key.isEmpty()) {
                                            %>
                                            <tr>
                                                <td align='center'><input type='text' class="form-control" name='payslip_dbddescription' size='27' value="<%=key%>" placeholder='description'></td>
                                                <td align='center'>
                                                    <div class='input-group' style='margin-left: 5px;'>
                                                        <span class='input-group-addon'>$</span>
                                                        <input type='number' class="form-control" step='0.01' min='0' name='payslip_abdamount' value='<%=df.format(entry.getValue())%>' placeholder='amount'>
                                                    </div>
                                                </td>
                                                <td align='center'><input type='button' class='btn btn-warning' value='x' onclick='deleteEntry(this)'/>
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
                            <tr>
                                <th colspan="2" align="center"><b>Overtime & Additional</b></th>
                            </tr>
                            <tr>
                                <td align="right"><b>Overtime Hours Worked :</b></td>
                                <td>
                                    <input type="number" class="form-control" id="payslip_ot" min='0' step='0.01' value='<%=payslip.getOvertimeHr()%>'>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Overtime Rate :</b></td>
                                <td>
                                    <div class="input-group">
                                        <span class="input-group-addon">$</span>
                                        <select id='payslip_otRate' class="form-control">
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
                                        </select>
                                        <span class="input-group-addon"> / Hr</span>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>(D) Total Overtime Pay :</b></td>
                                <td>
                                    $ <label id="payslip_overtime"><%=df.format(payslip.getOvertimePay())%></label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>(E) Other Additional Payments :</b></td>
                                <td>
                                    $ <label id="payslip_additional"><%=df.format(payslip.getAdditionalPayment())%></label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan='2' align="center"><button onclick="addPayslipBDEntry('payslip_apbd')" class="btn btn-default">Add Breakdown</button></td>
                            </tr>
                            <tr>
                                <td colspan='2'>
                                    <table id="payslip_apbd" valign="top" style="width:100%;">
                                        <col width="50%">
                                        <col width="40%">
                                        <col width="10%">
                                        <tbody>
                                            <%
                                                HashMap<String, Double> additionalBD = payslip.getAddPaymentBreakdown();
                                                if (!additionalBD.isEmpty()) {
                                                    for (Map.Entry<String, Double> entry : additionalBD.entrySet()) {
                                                        String key = entry.getKey();
                                                        if (!key.isEmpty()) {
                                            %>
                                            <tr>
                                                <td align='center'><input type='text' class="form-control" name='payslip_apbddescription' size='27' value="<%=key%>" placeholder='description'></td>
                                                <td align='center'>
                                                    <div class='input-group' style='margin-left: 5px;'>
                                                        <span class='input-group-addon'>$</span>
                                                        <input type='number' class="form-control" step='0.01' min='0' name='payslip_apbdamount' value='<%=df.format(entry.getValue())%>' placeholder='amount'>
                                                    </div>
                                                </td>
                                                <td align='center'><input type='button' class='btn btn-warning' value='x' onclick='deleteEntry(this)'/>
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
                            <tr>
                                <th colspan="2" align="center"><b>Total Pay</b></th>
                            </tr>
                            <tr>
                                <td align="right"><b>Net Pay (A+B-C+D+E) :</b></td>
                                <td>
                                    $ <label id="payslip_netpay"><%=df.format(payslip.getBasicPay() + payslip.getTotalAllowances() - payslip.getTotalDeductions() + payslip.getOvertimePay() + payslip.getAdditionalPayment())%></label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Employer's CPF Contribution :</b></td>
                                <td>
                                    <div class="input-group">
                                        <span class="input-group-addon">$</span>
                                        <input type="number" class="form-control" id="payslip_employerCpf" step="0.01" value='<%=df.format(payslip.getEmployerCpf())%>'>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label"></label>
        <div class="col-sm-8 text-center">
            <button class="btn btn-primary" onclick="updatePayslip()">Edit Payslip</button>
        </div>
    </div>
</div>

