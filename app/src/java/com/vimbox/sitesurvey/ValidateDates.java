package com.vimbox.sitesurvey;

import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ValidateSiteSurveyDates", urlPatterns = {"/ValidateDates"})
public class ValidateDates extends HttpServlet {

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
        JsonObject jsonOutput = new JsonObject();
        PrintWriter jsonOut = response.getWriter();

        String errorMsg = "";

        String addressFrom = request.getParameter("addressFrom");
        String addressTo = request.getParameter("addressTo");

        if (addressTo.isEmpty() || addressFrom.isEmpty()) {
            errorMsg += "Please ensure that both the moving from and to addresses are correctly filled<br>";
        }else{
            addressFrom = addressFrom.substring(0, addressFrom.length() - 1);
            String[] arrays = addressFrom.split("\\|", -1);
            for (String array : arrays) {
                if (array.trim().isEmpty()) {
                    errorMsg += "Please ensure that the moving from addresses are correctly filled<br>";
                    break;
                }
            }

            addressTo = addressTo.substring(0, addressTo.length() - 1);
            arrays = addressTo.split("\\|");
            for (String array : arrays) {
                if (array.trim().isEmpty()) {
                    errorMsg += "Please ensure that the moving to addresses are correctly filled<br>";
                    break;
                }
            }
        }

        if (errorMsg.isEmpty()) {
            jsonOutput.addProperty("status", "SUCCESS");
        } else {
            jsonOutput.addProperty("status", "ERROR");
            jsonOutput.addProperty("message", errorMsg);
        }

        jsonOut.println(jsonOutput);
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
