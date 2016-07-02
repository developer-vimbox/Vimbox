package com.vimbox.hr;

import com.vimbox.user.User;
import java.util.HashMap;
import org.joda.time.DateTime;

public class Payslip {
    private int payslip_id;
    private User user;
    private String paymentMode;
    
    private DateTime startDate;
    private DateTime endDate;
    private DateTime paymentDate;
    
    private double basicPay;
    private double totalAllowances;
    private double totalDeductions;
    private double overtimeHr;
    private double overtimePay;
    private double additionalPayment;
    private double employerCpf; 
    
    private HashMap<String, Double> allowanceBreakdown;
    private HashMap<String, Double> deductionBreakdown;
    private HashMap<String, Double> addPaymentBreakdown;

    public Payslip(int payslip_id, User user, String paymentMode, DateTime startDate, DateTime endDate, DateTime paymentDate, double basicPay, double totalAllowances, double totalDeductions, double overtimeHr, double overtimePay, double additionalPayment, double employerCpf, HashMap<String, Double> allowanceBreakdown, HashMap<String, Double> deductionBreakdown, HashMap<String, Double> addPaymentBreakdown) {
        this.payslip_id = payslip_id;
        this.user = user;
        this.paymentMode = paymentMode;
        this.startDate = startDate;
        this.endDate = endDate;
        this.paymentDate = paymentDate;
        this.basicPay = basicPay;
        this.totalAllowances = totalAllowances;
        this.totalDeductions = totalDeductions;
        this.overtimeHr = overtimeHr;
        this.overtimePay = overtimePay;
        this.additionalPayment = additionalPayment;
        this.employerCpf = employerCpf;
        this.allowanceBreakdown = allowanceBreakdown;
        this.deductionBreakdown = deductionBreakdown;
        this.addPaymentBreakdown = addPaymentBreakdown;
    }

    public int getPayslip_id() {
        return payslip_id;
    }

    public User getUser() {
        return user;
    }

    public String getPaymentMode() {
        return paymentMode;
    }

    public DateTime getStartDate() {
        return startDate;
    }

    public DateTime getEndDate() {
        return endDate;
    }

    public DateTime getPaymentDate() {
        return paymentDate;
    }

    public double getBasicPay() {
        return basicPay;
    }

    public double getTotalAllowances() {
        return totalAllowances;
    }

    public double getTotalDeductions() {
        return totalDeductions;
    }

    public double getOvertimeHr() {
        return overtimeHr;
    }
    
    public double getOvertimePay() {
        return overtimePay;
    }

    public double getAdditionalPayment() {
        return additionalPayment;
    }
    
    public double getEmployerCpf(){
        return employerCpf;
    }

    public HashMap<String, Double> getAllowanceBreakdown() {
        return allowanceBreakdown;
    }

    public HashMap<String, Double> getDeductionBreakdown() {
        return deductionBreakdown;
    }

    public HashMap<String, Double> getAddPaymentBreakdown() {
        return addPaymentBreakdown;
    }
}
