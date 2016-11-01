package com.vimbox.operations;

import com.google.gson.JsonObject;
import com.vimbox.database.JobDAO;
import com.vimbox.database.UserDAO;
import com.vimbox.user.User;
import com.vimbox.util.Converter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.joda.time.DateTime;

@WebServlet(name = "ChangeDomController", urlPatterns = {"/ChangeDomController"})
public class ChangeDomController extends HttpServlet {

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
        User owner = (User) request.getSession().getAttribute("session");
        String details = request.getParameter("details");
        String[] detailsArr = details.split("\\|");
        // 0 - leadId | 1 - date | 2 - timeslot | 3 - status //
        int leadId = Integer.parseInt(detailsArr[0]);
        String dDate = detailsArr[1];
        String dTimeslot = detailsArr[2];
        String dStatus = detailsArr[3];

        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache");
        JsonObject jsonOutput = new JsonObject();
        PrintWriter jsonOut = response.getWriter();
        String errorMsg = "";

        // Set-up the timetable schedule //
        HashMap<String, Integer> ts = new HashMap<String, Integer>();
        String[] timings = new String[]{"0900 - 0930", "0930 - 1000", "1000 - 1030", "1030 - 1100", "1100 - 1130", "1130 - 1200", "1200 - 1230", "1230 - 1300", "1300 - 1330", "1330 - 1400", "1400 - 1430", "1430 - 1500", "1500 - 1530", "1530 - 1600", "1600 - 1630", "1630 - 1700", "1700 - 1730", "1730 - 1800"};
        for (int i = 0; i < timings.length; i++) {
            ts.put(timings[i], i);
        }

        // Validate the DOM selected //
        String domDate = request.getParameter("move_date");
        String[] domTrucks = request.getParameterValues("move_carplates");
        HashMap<String, ArrayList<String>> domTimeslots = new HashMap<String, ArrayList<String>>();
        String[] domAddressesFr = request.getParameterValues("move_addressFrom");
        String[] domAddressesTo = request.getParameterValues("move_addressTot");
        String domRemark = request.getParameter("move_remarks");

        if (domTrucks == null) {
            errorMsg += "Please select a truck timeslot<br>";
        }

        if (domAddressesFr == null) {
            errorMsg += "Please select at least a moving from address<br>";
        }

        if (domAddressesTo == null) {
            errorMsg += "Please select at least a moving to address<br>";
        }

        if (dStatus.equals("Booked") && errorMsg.isEmpty()) {
            for (String domTruck : domTrucks) {
                String[] truckTimeslots = request.getParameterValues(domTruck + "_move_timeslot");
                ArrayList<String> list = new ArrayList<String>();
                for (String timeslot : truckTimeslots) {
                    boolean status = JobDAO.checkJobTimeslot(domDate, domTruck, timeslot);
                    if (status) {
                        errorMsg += "DOM booking on " + domDate + " " + timeslot + " is unavailable for Truck " + domTruck + " as there is an existing confirmed/booked move<br>";
                    }
                    list.add(timeslot);
                }
                domTimeslots.put(domTruck, list);
            }
        }

        if (errorMsg.isEmpty()) {
            JobDAO.deleteJobByIdDateTimeslot(leadId, dDate, dTimeslot);
            String remark = domRemark;
            String stts = dStatus;
            String action = "";
            if (dStatus.equals("Confirmed")) {
                action = "confirm";
            }
            HashMap<String, ArrayList<String>> times = new HashMap<String, ArrayList<String>>();
            ArrayList<String> adds = new ArrayList<String>();
            ArrayList<String> addsTags = new ArrayList<String>();

            for (String carplate : domTrucks) {
                times.put(carplate, domTimeslots.get(carplate));
            }

            for (String addr : domAddressesFr) {
                if (!adds.contains(addr)) {
                    adds.add(addr);
                    addsTags.add("from");
                }
            }

            for (String addr : domAddressesTo) {
                if (!adds.contains(addr)) {
                    adds.add(addr);
                    addsTags.add("to");
                }
            }

            HashMap<String, String> timest = new HashMap<String, String>();

            if (!times.isEmpty()) {
                for (Map.Entry<String, ArrayList<String>> entry : times.entrySet()) {
                    String cp = entry.getKey();
                    ArrayList<String> list = entry.getValue();
                    String timeslot = "";
                    timeslot = list.get(0);
                    int count = ts.get(timeslot);
                    for (int i = 1; i < list.size(); i++) {
                        String tts = list.get(i);
                        if (ts.get(tts) == count + 1) {
                            timeslot = timeslot.substring(0, timeslot.lastIndexOf(" ")) + " " + tts.substring(tts.lastIndexOf(" ") + 1);
                        } else {
                            timeslot += "<br>" + tts;
                        }
                        count = ts.get(tts);
                    }
                    timest.put(cp, timeslot);
                }

            }
            JobDAO.createOperationAssignment(leadId, owner.getNric(), adds, addsTags, domDate, times, timest, remark, stts, action);

            ArrayList<User> supervisors = UserDAO.getAllSupervisors();
            String userStr = "";
            for (int i = 0; i < supervisors.size(); i++) {
                User user = supervisors.get(i);
                userStr += user.getNric();
                if (i < supervisors.size() - 1) {
                    userStr += ",";
                }
            }
            jsonOutput.addProperty("notification", userStr + "|" + Converter.convertDate(new DateTime()) + " : Move for lead " + leadId + " has been changed|SupervisorJobs.jsp");
            jsonOutput.addProperty("status", "SUCCESS");
            jsonOutput.addProperty("message", "DOM changed!");
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
