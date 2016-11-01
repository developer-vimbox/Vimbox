package com.vimbox.sales;

import com.google.gson.JsonObject;
import com.vimbox.database.LeadDAO;
import com.vimbox.database.UserDAO;
import com.vimbox.operations.Job;
import com.vimbox.sitesurvey.SiteSurvey;
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

@WebServlet(name = "DeleteLeadController", urlPatterns = {"/DeleteLeadController"})
public class DeleteLeadController extends HttpServlet {

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
        ArrayList<String> notificationList = new ArrayList<String>();
        Lead lead = LeadDAO.getLeadById(leadId);
        ArrayList<SiteSurvey> surveys = lead.getSiteSurveys();
        ArrayList<String> surveyors = new ArrayList<String>();
        if (!surveys.isEmpty()) {
            for (SiteSurvey survey : surveys) {
                User user = survey.getSiteSurveyor();
                if (!surveyors.contains(user.getNric())) {
                    surveyors.add(user.getNric());
                }
            }
            String surveyorStr = "";
            for (int i = 0; i < surveyors.size(); i++) {
                String assignee = surveyors.get(i);
                surveyorStr += assignee;
                if (i < surveyors.size() - 1) {
                    surveyorStr += ",";
                }
            }
            notificationList.add(surveyorStr + "|" + Converter.convertDate(new DateTime()) + " : Site survey for lead " + leadId + " has been canceled|MySites.jsp");
        }

        ArrayList<Job> jobs = lead.getJobs();
        if (!jobs.isEmpty()) {
            boolean confirmed = false;
            for (Job job : jobs) {
                if (job.getStatus().equals("Confirmed")) {
                    confirmed = true;
                    break;
                }
            }
            if (confirmed) {
                ArrayList<User> supervisors = UserDAO.getAllSupervisors();
                String userStr = "";
                for (int i = 0; i < supervisors.size(); i++) {
                    User user = supervisors.get(i);
                    userStr += user.getNric();
                    if (i < supervisors.size() - 1) {
                        userStr += ",";
                    }
                    notificationList.add(userStr + "|" + Converter.convertDate(new DateTime()) + " : Move for lead " + leadId + " has been canceled");
                }
            }
        }
        LeadDAO.removeLead(leadId);
        if(!notificationList.isEmpty()){
            String notificationStr = "";
            for (int i = 0; i < notificationList.size(); i++) {
                String notification = notificationList.get(i);
                notificationStr += notification;
                if (i < notificationList.size() - 1) {
                    notificationStr += "}{";
                }
            }
            jsonOutput.addProperty("notification", notificationStr);
        }
        jsonOutput.addProperty("status", "SUCCESS");
        jsonOutput.addProperty("message", "Lead deleted!");
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
