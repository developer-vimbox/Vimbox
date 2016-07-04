package com.vimbox.hr;

import com.google.gson.JsonObject;
import com.vimbox.database.UserAttendanceDAO;
import com.vimbox.database.UserDAO;
import com.vimbox.database.UserLeaveDAO;
import com.vimbox.database.UserPopulationDAO;
import com.vimbox.user.User;
import com.vimbox.util.Converter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

@WebServlet(name = "ProrateController", urlPatterns = {"/ProrateController"})
public class ProrateController extends HttpServlet {

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
        JsonObject jsonOutput = new JsonObject();
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd");
        String errorMsg = "";

        String startdate = request.getParameter("startdate");
        String enddate = request.getParameter("enddate");

        DateTime sd = dtf.parseDateTime(startdate);
        DateTime ed = dtf.parseDateTime(enddate);

        if (sd.getMonthOfYear() != ed.getMonthOfYear()) {
            errorMsg += "Start and end dates must be in the same month<br>";
        } else if (sd.isAfter(ed)) {
            errorMsg += "Start date must be before end date<br>";
        }

        if (errorMsg.isEmpty()) {
            DecimalFormat df = new DecimalFormat("#.00");
            try {
                String nric = request.getParameter("employee");
                User user = UserDAO.getUserByNRIC(nric);
                Date start_date = format.parse(startdate);
                Date end_date = format.parse(enddate);

                Calendar c = Calendar.getInstance();
                c.setTime(start_date);
                c.set(Calendar.DAY_OF_MONTH, 1);
                Date firstDayOfMonth = c.getTime();
                c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
                Date lastDayOfMonth = c.getTime();

                int working_days = UserPopulationDAO.getUserWorkingDays(user.getDepartment(), user.getDesignation());

                int currDays = Converter.getWorkingDaysBetweenTwoDates(start_date, end_date, working_days);
                int totalDays = Converter.getWorkingDaysBetweenTwoDates(firstDayOfMonth, lastDayOfMonth, working_days);

                int absent = 0;
                int late = 0;

                ArrayList<Attendance> attendances = UserAttendanceDAO.getAttendancesBetweenTwoDates(sd, ed);
                for (Attendance attendance : attendances) {
                    String status = attendance.getUserAttendance(nric);
                    if (status != null) {
                        switch (status) {
                            case "Absent":
                                absent++;
                                break;
                            case "Late":
                                late += attendance.getUserLateDuration(nric);
                        }
                    }
                }

                ArrayList<LeaveMC> leaveMcs = UserLeaveDAO.getUnpaidLeaveMCRecordByNricBetweenTwoDates(nric, sd, ed);
                int mc = 0;
                int leave = 0;
                int timeoff = 0;

                for (LeaveMC leaveMc : leaveMcs) {
                    String leaveName = leaveMc.getLeaveName();
                    switch (leaveName) {
                        case "MC":
                            mc++;
                            break;
                        case "Leave":
                        case "Timeoff":
                            leave += leaveMc.getLeaveDuration();
                    }
                }

                jsonOutput.addProperty("status", "SUCCESS");
                jsonOutput.addProperty("prorate", (double) currDays / totalDays);
                jsonOutput.addProperty("totalDays", totalDays);
                jsonOutput.addProperty("absent", absent);
                jsonOutput.addProperty("late", late);
                jsonOutput.addProperty("mc", mc);
                jsonOutput.addProperty("timeoff", timeoff);
                jsonOutput.addProperty("leave", leave);
            } catch (Exception e) {
            }
        } else {
            jsonOutput.addProperty("status", "ERROR");
            jsonOutput.addProperty("errorMsg", errorMsg);
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
