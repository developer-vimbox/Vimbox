package com.vimbox.hr;

import com.google.gson.JsonObject;
import com.vimbox.database.PayslipDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "CreatePayslipController", urlPatterns = {"/CreatePayslipController"})
public class CreatePayslipController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache");
        PrintWriter out = response.getWriter();
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        
        String errorMsg = "";
        
        String sd = request.getParameter("start_date");
        Date start_date = null;
        if(sd.isEmpty()){
            errorMsg+="Please enter a start date<br>";
        }else{
            try{
                start_date = format.parse(sd);
            }catch(Exception e){
                errorMsg += "Please enter a valid start date<br>";
            }
        }
        
        String ed = request.getParameter("end_date");
        Date end_date = null;
        if(ed.isEmpty()){
            errorMsg+="Please enter an end date<br>";
        }else{
            try{
                end_date = format.parse(ed);
            }catch(Exception e){
                errorMsg += "Please enter a valid end date<br>";
            }
        }
        
        String pd = request.getParameter("payment_date");
        Date payment_date = null;
        if(pd.isEmpty()){
            errorMsg+="Please enter a payment date<br>";
        }else{
            try{
                payment_date = format.parse(pd);
            }catch(Exception e){
                errorMsg += "Please enter a valid payment date<br>";
            }
        }
        
        String nric = request.getParameter("employee");
        if(nric.isEmpty()){                         
            errorMsg+="Please select an employee<br>";
        }else if(start_date != null){
            if(PayslipDAO.checkPayslipMonthExists(nric, sd)){
                errorMsg+="Employee's payslip for this month has already been generated<br>";
            }
        }
        
        String payment_mode = request.getParameter("payment_mode");
        if(payment_mode.isEmpty()){                         
            errorMsg+="Please select a mode of payment<br>";
        }
        
        String abd_desc = request.getParameter("abd_description");
        String abd_amt = request.getParameter("abd_amount");
        ArrayList<String> abd_description = null;
        ArrayList<String> abd_amount = null;
        if(!abd_desc.trim().isEmpty()){
            abd_description = new ArrayList<String>();
            abd_amount = new ArrayList<String>();
            String[] arrayD = abd_desc.split("\\|");
            for(int i=0; i<arrayD.length; i++){
                String string = arrayD[i];
                abd_description.add(string);
            }
            String[] arrayA = abd_amt.split("\\|");
            for(int i=0; i<arrayA.length; i++){
                String string = arrayA[i];
                abd_amount.add(string);
            }
        }
        
        String dbd_desc = request.getParameter("dbd_description");
        
        String dbd_amt = request.getParameter("dbd_amount");
        ArrayList<String> dbd_description = null;
        ArrayList<String> dbd_amount = null;
        if(!dbd_desc.trim().isEmpty()){                         
            dbd_description = new ArrayList<String>();
            dbd_amount = new ArrayList<String>();
            String[] arrayD = dbd_desc.split("\\|");
            for(int i=0; i<arrayD.length; i++){
                String string = arrayD[i];
                dbd_description.add(string);
            }
            String[] arrayA = dbd_amt.split("\\|");
            for(int i=0; i<arrayA.length; i++){
                String string = arrayA[i];
                dbd_amount.add(string);
            }
        }
        
        String apbd_desc = request.getParameter("apbd_description");
        String apbd_amt = request.getParameter("apbd_amount");
        ArrayList<String> apbd_description = null;
        ArrayList<String> apbd_amount = null;
        if(!apbd_desc.trim().isEmpty()){        
            apbd_description = new ArrayList<String>();
            apbd_amount = new ArrayList<String>();
            String[] arrayD = apbd_desc.split("\\|");
            for(int i=0; i<arrayD.length; i++){
                String string = arrayD[i];
                apbd_description.add(string);
            }
            String[] arrayA = apbd_amt.split("\\|");
            for(int i=0; i<arrayA.length; i++){
                String string = arrayA[i];
                apbd_amount.add(string);
            }
        }
        
        String basic = request.getParameter("basic");
        String allowance = request.getParameter("allowance");
        String deduction = request.getParameter("deduction");
        String overtimeHr = request.getParameter("overtimeHr");
        String overtime = request.getParameter("overtime");
        String additional = request.getParameter("additional");
        String employer_cpf = request.getParameter("employer_cpf");
        
        JsonObject jsonOutput = new JsonObject();
        if(errorMsg.isEmpty()){
            int payslip_id = new Random().nextInt(90000000) + 10000000;
            PayslipDAO.createPayslip(payslip_id, start_date, end_date, payment_date, nric, payment_mode, basic, allowance, deduction, overtimeHr, overtime, additional, employer_cpf);
            
            if(abd_description != null){
                PayslipDAO.createPayslipABD(payslip_id, abd_description, abd_amount);
            }
            
            if(dbd_description != null){
                PayslipDAO.createPayslipDBD(payslip_id, dbd_description, dbd_amount);
            }
            
            if(apbd_description != null){
                PayslipDAO.createPayslipAPBD(payslip_id, apbd_description, apbd_amount);
            }
            
            jsonOutput.addProperty("status", "SUCCESS");
            jsonOutput.addProperty("message", "Payslip added!");
        }else{
            jsonOutput.addProperty("status", "ERROR");
            jsonOutput.addProperty("message", errorMsg);
        }
        
        out.println(jsonOutput);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
