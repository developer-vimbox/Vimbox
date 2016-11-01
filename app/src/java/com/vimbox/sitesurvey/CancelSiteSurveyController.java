package com.vimbox.sitesurvey;

import com.google.gson.JsonObject;
import com.vimbox.database.SiteSurveyDAO;
import com.vimbox.user.User;
import com.vimbox.util.Converter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.joda.time.DateTime;

@WebServlet(name = "CancelSiteSurveyController", urlPatterns = {"/CancelSiteSurveyController"})
public class CancelSiteSurveyController extends HttpServlet {

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
        
        int leadId = Integer.parseInt(request.getParameter("leadId"));
        String date = request.getParameter("date");
        String timeslot = request.getParameter("timeslot");
        ArrayList<SiteSurvey> surveys = SiteSurveyDAO.getSiteSurveysByLeadIdDateTimeslot(leadId, date, timeslot);
        ArrayList<String> users = new ArrayList<String>();
        for(SiteSurvey survey : surveys){
            User user = survey.getSiteSurveyor();
            if(!users.contains(user.getNric())){
                users.add(user.getNric());
            }
        }
        
        SiteSurveyDAO.cancelSiteSurvey(leadId, date, timeslot);
        
        String userStr = "";
        for (int i = 0; i < users.size(); i++) {
            String user = users.get(i);
            userStr += user;
            if (i < users.size() - 1) {
                userStr += ",";
            }
        }
        jsonOutput.addProperty("status", "SUCCESS");
        jsonOutput.addProperty("message", "Site survey cancelled!");
        jsonOutput.addProperty("notification", userStr + "|" + Converter.convertDate(new DateTime()) + " : Site survey for lead " + leadId + " has been canceled|MySites.jsp");
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
