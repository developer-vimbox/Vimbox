package com.vimbox.hr;

import com.google.gson.JsonObject;
import com.vimbox.database.UserAttendanceDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

@WebServlet(name = "EditAttendanceController", urlPatterns = {"/EditAttendanceController"})
public class EditAttendanceController extends HttpServlet {

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

        String date = request.getParameter("attendance_date");
        DateTime dt = dtf.parseDateTime(date);

        String[] nrics = request.getParameterValues("attendance_nric");
        HashMap<String, String> attendance_record = new HashMap<String, String>();
        HashMap<String, Double> late_record = new HashMap<String, Double>();
        
        for (String nric : nrics) {
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
            
            attendance_record.put(nric, attendance);
            late_record.put(nric, lateDuration);
        }
        
        if(errorMsg.isEmpty()){
            UserAttendanceDAO.deleteAttendanceByDate(dt);
            UserAttendanceDAO.createAttendance(dt, attendance_record, late_record);
            jsonOutput.addProperty("status", "SUCCESS");
            jsonOutput.addProperty("message", "Attendance for " + date + " has been updated!");
        }else{
            jsonOutput.addProperty("status", "ERROR");
            jsonOutput.addProperty("message", errorMsg);
        }
        
        jsonOutput.addProperty("action", request.getParameter("attendance_action"));
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
