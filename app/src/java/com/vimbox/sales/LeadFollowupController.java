package com.vimbox.sales;

import com.google.gson.JsonObject;
import com.vimbox.database.LeadFollowupDAO;
import com.vimbox.database.TicketCommentDAO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.joda.time.DateTime;

/**
 *
 * @author NYuSheng
 */
@WebServlet(name = "LeadFollowupController", urlPatterns = {"/LeadFollowupController"})
public class LeadFollowupController extends HttpServlet {

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
        
        String comment = request.getParameter("comment_lead_followup");
        
        String errorMsg = "";
        if(comment.isEmpty()){
            errorMsg+="Please enter a follow-up comment<br>";
        }
        
        JsonObject jsonOutput = new JsonObject();
        if(errorMsg.isEmpty()){
            int lead_id = Integer.parseInt(request.getParameter("comment_lead_id"));
            DateTime dt = new DateTime();
            LeadFollowupDAO.createLeadFollowup(lead_id, comment, dt);
            jsonOutput.addProperty("status", "SUCCESS");
            jsonOutput.addProperty("message", "Lead follow-up comment added!");
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
