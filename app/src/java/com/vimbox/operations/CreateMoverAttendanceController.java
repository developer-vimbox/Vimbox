package com.vimbox.operations;

import com.google.gson.JsonObject;
import com.vimbox.database.OperationsDAO;
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

@WebServlet(name = "CreateMoverAttendanceController", urlPatterns = {"/CreateMoverAttendanceController"})
public class CreateMoverAttendanceController extends HttpServlet {
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

        String supervisor = request.getParameter("supervisor");
        String date = request.getParameter("today");

        String[] nrics = request.getParameterValues("attendance_nric");
        ArrayList<MoversAttendance> mAtt = new ArrayList<MoversAttendance>();
        
        for (String nric : nrics) {
            User u = UserDAO.getUserByNRIC(nric);
            String attendance = request.getParameter("attendance_" + nric);
            double lateDuration = 0;
            if (attendance == null) {
                errorMsg += "Please take attendance for all employees<br>";
                break;
            }else if(attendance.equals("Late")){
                double hour = Double.parseDouble(request.getParameter("late_" + nric + "_h"));
                double minute = Double.parseDouble(request.getParameter("late_" + nric + "_m"));
                lateDuration = (hour * 60) + minute;
            }
            mAtt.add(new MoversAttendance(supervisor, u, date, attendance, lateDuration));
        }
        
        if(errorMsg.isEmpty()){
            OperationsDAO.updateAttendance(mAtt);
            jsonOutput.addProperty("status", "SUCCESS");
            jsonOutput.addProperty("message", "Attendance for " + date + " has been taken!");
        }else{
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

