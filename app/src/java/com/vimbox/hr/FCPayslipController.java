package com.vimbox.hr;

import com.google.gson.JsonObject;
import com.vimbox.database.PayslipDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import static org.joda.time.format.ISODateTimeFormat.dateTime;

@WebServlet(name = "FCPayslipController", urlPatterns = {"/FCPayslipController"})
public class FCPayslipController extends HttpServlet {

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
        DateTimeFormatter format = DateTimeFormat.forPattern("yyyy-MM-dd");

        String errorMsg = "";

        String fc_paymentdate = request.getParameter("fc_paymentdate");
        DateTime paymentDate = null;
        if (fc_paymentdate.isEmpty()) {
            errorMsg += "Please enter a payment date<br>";
        } else {
            try {
                paymentDate = format.parseDateTime(fc_paymentdate);
            } catch (Exception e) {
                errorMsg += "Please enter a valid payment date<br>";
            }
        }

        JsonObject jsonOutput = new JsonObject();
        if (errorMsg.isEmpty()) {
            PayslipDAO.fastCreatePayslips(paymentDate);
            jsonOutput.addProperty("status", "SUCCESS");
            jsonOutput.addProperty("message", "Payslips added!");
        } else {
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
