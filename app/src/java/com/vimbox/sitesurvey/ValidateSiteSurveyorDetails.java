package com.vimbox.sitesurvey;

import com.google.gson.JsonObject;
import com.vimbox.database.UserDAO;
import com.vimbox.user.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

@WebServlet(name = "ValidateSiteSurveyorDetails", urlPatterns = {"/ValidateSiteSurveyorDetails"})
public class ValidateSiteSurveyorDetails extends HttpServlet {

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
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd");
        JsonObject jsonOutput = new JsonObject();
        PrintWriter jsonOut = response.getWriter();

        String errorMsg = "";

        String date = request.getParameter("date");
        String siteSurveyor = request.getParameter("siteSurveyor");
        String addressFrom = request.getParameter("addressFrom");
        String addressTo = request.getParameter("addressTo");
        DateTime dt = null;
/*
        if (addressFrom.isEmpty() && addressTo.isEmpty()) {
            errorMsg += "Please input at least one address<br>";
        }
*/
        if (!addressFrom.isEmpty()) {
            addressFrom = addressFrom.substring(0, addressFrom.length() - 1);
            String[] arrays = addressFrom.split("\\|", -1);
            for (String array : arrays) {
                if (array.trim().isEmpty()) {
                    errorMsg += "Please ensure that the moving from addresses are correctly filled<br>";
                    break;
                }
            }
        }

        if (!addressTo.isEmpty()) {
            addressTo = addressTo.substring(0, addressTo.length() - 1);
            String[] arrays = addressTo.split("\\|");
            for (String array : arrays) {
                if (array.trim().isEmpty()) {
                    errorMsg += "Please ensure that the moving to addresses are correctly filled<br>";
                    break;
                }
            }
        }
/*
        if (date.isEmpty()) {
            errorMsg += "Please enter a survey date<br>";
        } else {
            try {
                dt = dtf.parseDateTime(date);
            } catch (Exception e) {
                errorMsg += "Please enter a valid survey date<br>";
            }
        }
*/
        ArrayList<User> users = new ArrayList<User>();
        if (siteSurveyor.equals("allss")) {
            users = UserDAO.getAllSurveyors();
        } else {
            User u = UserDAO.getUserByNRIC(siteSurveyor);
            users.add(u);
        }
        if (users.isEmpty()) {
            errorMsg += "No site surveyors found<br>";
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
