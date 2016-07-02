package com.vimbox.hr;

import com.google.gson.JsonObject;
import com.vimbox.database.UserDAO;
import com.vimbox.database.UserPopulationDAO;
import com.vimbox.user.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "RetrieveEmployeeLeaveMCController", urlPatterns = {"/RetrieveEmployeeLeaveMCController"})
public class RetrieveEmployeeLeaveMCController extends HttpServlet {

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
        DecimalFormat df = new DecimalFormat("0.0");

        String nric = request.getParameter("nric");
        String leave = "";
        String mc = "";
        String workingDays = "";

        User user = UserDAO.getUserByNRIC(nric);
        if (user != null) {
            leave = df.format((user.getLeave() - user.getUsed_leave()) / 9);
            mc = (user.getMc() - user.getUsed_mc()) + "";
            workingDays = UserPopulationDAO.getUserWorkingDays(user.getDepartment(), user.getDesignation()) + "";
        }

        JsonObject jsonOutput = new JsonObject();
        jsonOutput.addProperty("remainingLeave", leave);
        jsonOutput.addProperty("remainingMC", mc);
        jsonOutput.addProperty("workingDays", workingDays);
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
