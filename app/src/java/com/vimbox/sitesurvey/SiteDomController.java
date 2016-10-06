package com.vimbox.sitesurvey;

import com.google.gson.JsonObject;
import com.vimbox.database.JobDAO;
import com.vimbox.database.LeadDAO;
import com.vimbox.operations.Job;
import com.vimbox.sales.Lead;
import com.vimbox.user.User;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.catalina.core.ApplicationPart;

@WebServlet(name = "SiteDOMController", urlPatterns = {"/SiteDomController"})
@MultipartConfig
public class SiteDomController extends HttpServlet {

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

        // Set-up the timetable schedule //
        HashMap<String, Integer> ts = new HashMap<String, Integer>();
        String[] timings = new String[]{"0900 - 0930", "0930 - 1000", "1000 - 1030", "1030 - 1100", "1100 - 1130", "1130 - 1200", "1200 - 1230", "1230 - 1300", "1300 - 1330", "1330 - 1400", "1400 - 1430", "1430 - 1500", "1500 - 1530", "1530 - 1600", "1600 - 1630", "1630 - 1700", "1700 - 1730", "1730 - 1800"};
        for (int i = 0; i < timings.length; i++) {
            ts.put(timings[i], i);
        }

        // Retrieve user owner //
        User owner = (User) request.getSession().getAttribute("session");
        String nric = owner.getNric();

        int leadId = Integer.parseInt(request.getParameter("leadId"));
        String action = request.getParameter("leadStatus");
        // Validate the DOM selected //
        String[] domDates = request.getParameterValues("move_date");
        String[] domTrucks = request.getParameterValues("move_truck");
        HashMap<String, ArrayList<String>> domTimeslots = new HashMap<String, ArrayList<String>>();
        String[] domAddressesFr = request.getParameterValues("move_addressFr");
        String[] domAddressesTo = request.getParameterValues("move_addressTo");
        String[] domRemarks = request.getParameterValues("move_remarks");
        String[] domStatuses = request.getParameterValues("move_status");
        if (domDates != null) {
            for (String domDate : domDates) {
                for (String domTruck : domTrucks) {
                    if (domTruck.contains(domDate)) {
                        String truck = domTruck.split("\\|")[1];
                        String[] truckTimeslots = request.getParameterValues(truck + "_move_timeslots");
                        ArrayList<String> list = new ArrayList<String>();
                        for (String timeslot : truckTimeslots) {
                            boolean status = JobDAO.checkJobTimeslot(domDate, truck, timeslot);
                            if (status && action.equals("save")) {
                                errorMsg += "DOM booking on " + domDate + " " + timeslot + " is unavailable for Truck " + truck + " as there is an existing confirmed/booked move<br>";
                            }
                            list.add(timeslot);
                        }
                        domTimeslots.put(truck, list);
                    }
                }
            }
        } else {
            if (action.equals("confirm")) {
                Lead lead = LeadDAO.getLeadById(leadId);
                ArrayList<Job> jobs = lead.getJobs();
                if (jobs.isEmpty()) {
                    errorMsg += "Please select DOM to confirm<br>";
                }
            }
        }
        double collectedAmount = 0;
        String fileName = "";
        String path = "";
        ApplicationPart filePart = null;
        if (action.equals("confirm")) {
            String amount = request.getParameter("amountCollected");

            if (!amount.isEmpty()) {
                try {
                    collectedAmount = Double.parseDouble(amount);
                } catch (NumberFormatException e) {
                    errorMsg += "Please enter a valid amount<br>";
                }
            }

            filePart = (ApplicationPart) request.getPart("file");

            if (filePart != null) {
                boolean fileCheck = fileValidation(filePart);
                if (!fileCheck) {
                    errorMsg += "Please upload a valid image (png, jpg, bmp or pdf)<br>";
                } else {
                    String fName = filePart.getSubmittedFileName();
                    String fileExt = fName.substring(fName.lastIndexOf("."));
                    fileName = leadId + "-email" + fileExt;
                    path = System.getProperty("user.dir") + "/documents/emails/" + fileName;
                }
            }
        }
        if (errorMsg.isEmpty()) {

            // Enter into operation_assigned database //
            if (domDates != null) {
                for (String domDate : domDates) {
                    String remark = "";
                    String stts = "";
                    HashMap<String, ArrayList<String>> times = new HashMap<String, ArrayList<String>>();
                    ArrayList<String> adds = new ArrayList<String>();
                    ArrayList<String> addsTags = new ArrayList<String>();

                    for (String domTruck : domTrucks) {
                        if (domTruck.contains(domDate)) {
                            String carplate = domTruck.split("\\|")[1];
                            times.put(carplate, domTimeslots.get(carplate));
                        }
                    }

                    for (String addr : domAddressesFr) {
                        if (addr.contains(domDate)) {
                            if (!adds.contains(addr.split("\\|")[1])) {
                                adds.add(addr.split("\\|")[1]);
                                addsTags.add("from");
                            }
                        }
                    }

                    for (String addr : domAddressesTo) {
                        if (addr.contains(domDate)) {
                            if (!adds.contains(addr.split("\\|")[1])) {
                                adds.add(addr.split("\\|")[1]);
                                addsTags.add("to");
                            }
                        }
                    }

                    for (String rem : domRemarks) {
                        if (rem.contains(domDate)) {
                            remark = rem.split("\\|", -1)[1];
                        }
                    }

                    for (String stats : domStatuses) {
                        if (stats.contains(domDate)) {
                            stts = stats.split("\\|")[1];
                            if (action.equals("save")) {
                                stts = "Booked";
                            } else {
                                stts = "Confirmed";
                            }
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
                }
            }
            if (action.equals("confirm")) {
                OutputStream out = null;
                InputStream filecontent = null;
                try {
                    LeadDAO.confirmLead(nric, collectedAmount, fileName, leadId);
                    if (filePart != null) {
                        out = new FileOutputStream(new File(path));
                        filecontent = filePart.getInputStream();

                        int read = 0;
                        final byte[] bytes = new byte[1024];

                        while ((read = filecontent.read(bytes)) != -1) {
                            out.write(bytes, 0, read);
                        }
                    }
                    jsonOutput.addProperty("status", "SUCCESS");
                    jsonOutput.addProperty("message", "Lead confirmed!");
                } catch (FileNotFoundException fne) {
                    System.out.println("File errorrr: " + fne);
                    errorMsg += "Error reading uploaded image<br>";
                } finally {
                    if (out != null) {
                        out.close();
                    }
                    if (filecontent != null) {
                        filecontent.close();
                    }
                }
            }
            //----------------------------------------//
            String msg = "";
            if (action.equals("save")) {
                msg = "DOM booked!";
            } else {
                msg = "DOM confirmed!";
            }
            jsonOutput.addProperty("status", "SUCCESS");
            jsonOutput.addProperty("message", msg);
        }

        if (!errorMsg.isEmpty()) {
            jsonOutput.addProperty("status", "ERROR");
            jsonOutput.addProperty("message", errorMsg);
        }
        jsonOut.println(jsonOutput);
    }

    private boolean fileValidation(ApplicationPart filePart) {
        String fName = filePart.getSubmittedFileName();
        if (fName != null && !fName.isEmpty()) {
            String fileExt = fName.substring(fName.lastIndexOf("."));
            // Checks file for file extension //
            if (!(fileExt.matches(".png|.jpg|.bmp|.pdf"))) {
                return false;
            } else {
                return true;
            }
        } else {
            return false;
        }
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
