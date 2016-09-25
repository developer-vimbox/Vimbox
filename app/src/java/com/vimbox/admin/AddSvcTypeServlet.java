package com.vimbox.admin;
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import com.google.gson.JsonObject;
import com.vimbox.database.LeadPopulationDAO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author kuahqw
 */
@WebServlet(urlPatterns = {"/AddSvcTypeServlet"})
public class AddSvcTypeServlet extends HttpServlet {

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

        // Retrieves the entered movetype //
        String primary = request.getParameter("svcType_primary");
        String secondary = request.getParameter("svcType_secondary");
        String formula = request.getParameter("svcType_formula");
        String description = request.getParameter("svcType_description");
        
        boolean error = false;
        String errorMsg = "";
        
        if(primary.isEmpty()) {
            error = true;
            errorMsg += "Please enter primary<br>";
        }
        if(secondary.isEmpty()) {
            error = true;
            errorMsg += "Please enter secondary<br>";
        }
        if(formula.isEmpty()) {
            error = true;
            errorMsg += "Please enter formula<br>";
        }
        if(description.isEmpty()) {
            error = true;
            errorMsg += "Please enter description<br>";
        }
        
        JsonObject jsonOutput = new JsonObject();
        if(error) {
            jsonOutput.addProperty("status", "ERROR");
            jsonOutput.addProperty("errorMsg", errorMsg);
        } else {
            LeadPopulationDAO.addSvcType(primary, secondary, formula, description);
            jsonOutput.addProperty("status", "SUCCESS");
            jsonOutput.addProperty("errorMsg", "Service type added!");
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
