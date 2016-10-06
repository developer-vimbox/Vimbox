package com.vimbox.sales;

import com.google.gson.JsonObject;
import com.vimbox.database.CustomerHistoryDAO;
import com.vimbox.database.JobDAO;
import com.vimbox.database.LeadDAO;
import com.vimbox.database.SiteSurveyDAO;
import com.vimbox.operations.Job;
import com.vimbox.user.User;
import com.vimbox.util.Converter;
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
import java.util.TreeSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.catalina.core.ApplicationPart;
import org.joda.time.DateTime;

@WebServlet(name = "EditLeadController", urlPatterns = {"/EditLeadController"})
@MultipartConfig
public class EditLeadController extends HttpServlet {

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

        String action = request.getParameter("leadStatus");
        int leadId = Integer.parseInt(request.getParameter("leadId"));
        // Validate the DOM selected //
        String[] domDates = request.getParameterValues("move_date");
        String[] domTrucks = request.getParameterValues("move_truck");
        HashMap<String, ArrayList<String>> domTimeslots = new HashMap<String, ArrayList<String>>();
        String[] domAddressesFr = request.getParameterValues("move_addressFr");
        String[] domAddressesTo = request.getParameterValues("move_addressTo");
        String[] domRemarks = request.getParameterValues("move_remarks");
        String[] domStatuses = request.getParameterValues("move_status");
        if (domDates != null) {
            for (int i = 0; i < domDates.length; i++) {
                String domDate = domDates[i];
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
            // Retrieve user owner //
            User owner = (User) request.getSession().getAttribute("session");
            //---------------------//

            // Lead ID //
            String dt = Converter.convertDateDatabase(new DateTime());
            String status = request.getParameter("status");
            String source = request.getParameter("source");
            String referral = request.getParameter("referral");
            if (referral.equals("Others")) {
                referral = request.getParameter("referralOthers");
            }

            String enquiry = request.getParameter("enquiry");
            if (enquiry.equals("Others")) {
                enquiry = request.getParameter("enquiryOthers");
            }
            //---------//

            // Clear database of current lead info//
            LeadDAO.deleteLead(leadId);
            //------------------------------------//

            String leadType = "";
            if (enquiry.equals("SELECT")) {
                leadType = "Sales";
            } else {
                leadType = "Enquiry";
            }
            LeadDAO.createLeadEnquiry(leadId, enquiry);

            // Customer details //
            String cId = request.getParameter("customer_id");
            int custId = -1;
            if (!cId.isEmpty()) {
                custId = Integer.parseInt(cId);
            }
            //------------------//

            // Moving details //
            String[] tom = request.getParameterValues("tom");
            String typesOfMove = "";
            if (tom != null) {
                for (int i = 0; i < tom.length; i++) {
                    String move = tom[i];
                    typesOfMove += move;
                    if (i <= tom.length - 2) {
                        typesOfMove += "|";
                    }
                }
            }

            // Enter into leadinfo database // 
            LeadDAO.createLeadInfo(owner, leadId, leadType, custId, typesOfMove, dt, status, source, referral);
            if (custId > -1) {
                CustomerHistoryDAO.updateCustomerHistory(custId, leadId);
            }
            //------------------------------//

            TreeSet<String> addressFromSet = new TreeSet<String>();
            TreeSet<String> addressToSet = new TreeSet<String>();
            String[] salesDivs = request.getParameterValues("divId");
            // Increment by 4 per address //
            String[] addressFrom = request.getParameterValues("addressfrom");
            ArrayList<String> salesDivFrom = new ArrayList<String>();
            ArrayList<String> addFrom = new ArrayList<String>();
            if (addressFrom != null) {
                for (int i = 0; i < addressFrom.length; i += 4) {
                    String address = addressFrom[i].trim();
                    String level = addressFrom[i + 1].trim();
                    String unit = addressFrom[i + 2].trim();
                    String postal = addressFrom[i + 3].trim();
                    if(level.isEmpty()){
                        level = " ";
                    }
                    if(unit.isEmpty()){
                        unit = " ";
                    }
                    String add = address + "_" + level + "_" + unit + "_" + postal;
                    addressFromSet.add(address + " #" + level + "-" + unit + " S" + postal);
                    for (String salesDiv : salesDivs) {
                        if (salesDiv.contains(address + " #" + level + "-" + unit + " S" + postal)) {
                            salesDivFrom.add(salesDiv);
                            break;
                        }
                    }
                    addFrom.add(add);
                }
            }
            //----------------------------//
            String[] storeysFrom = request.getParameterValues("storeysfrom");
            ArrayList<String> storeFrom = new ArrayList<String>();
            if (storeysFrom != null) {
                for (int i = 0; i < storeysFrom.length; i++) {
                    String store = storeysFrom[i];
                    if (store.isEmpty()) {
                        store = " ";
                    }
                    storeFrom.add(store);
                }
            }
            String[] distanceFrom = request.getParameterValues("distancefrom");
            ArrayList<String> distFrom = new ArrayList<String>();
            if (distanceFrom != null) {
                for (int i = 0; i < distanceFrom.length; i++) {
                    String dist = distanceFrom[i];
                    if (dist.isEmpty()) {
                        dist = " ";
                    }
                    distFrom.add(dist);
                }
            }
            // Enter into leadmovefrom database //
            LeadDAO.createLeadMove(leadId, salesDivFrom, "from", addFrom, storeFrom, distFrom);
                //----------------------------------//

            // Increment by 4 per address //
            ArrayList<String> salesDivTo = new ArrayList<String>();
            String[] addressTo = request.getParameterValues("addressto");
            ArrayList<String> addTo = new ArrayList<String>();
            if (addressTo != null) {
                for (int i = 0; i < addressTo.length; i += 4) {
                    String address = addressTo[i].trim();
                    String level = addressTo[i + 1].trim();
                    String unit = addressTo[i + 2].trim();
                    String postal = addressTo[i + 3].trim();
                    if(level.isEmpty()){
                        level = " ";
                    }
                    if(unit.isEmpty()){
                        unit = " ";
                    }
                    String add = address + "_" + level + "_" + unit + "_" + postal;
                    addressToSet.add(address + " #" + level + "-" + unit + " S" + postal);
                    for (String salesDiv : salesDivs) {
                        if (salesDiv.contains(address + " #" + level + "-" + unit + " S" + postal)) {
                            salesDivTo.add(salesDiv);
                            break;
                        }
                    }
                    addTo.add(add);
                }
            }
            //----------------------------//
            String[] storeysTo = request.getParameterValues("storeysto");
            ArrayList<String> storeTo = new ArrayList<String>();
            if (storeysTo != null) {
                for (int i = 0; i < storeysTo.length; i++) {
                    String store = storeysTo[i];
                    if (store.isEmpty()) {
                        store = " ";
                    }
                    storeTo.add(store);
                }
            }
            String[] distanceTo = request.getParameterValues("distanceto");
            ArrayList<String> distTo = new ArrayList<String>();
            if (distanceTo != null) {
                for (int i = 0; i < distanceTo.length; i++) {
                    String dist = distanceTo[i];
                    if (dist.isEmpty()) {
                        dist = " ";
                    }
                    distTo.add(dist);
                }
            }
            // Enter into leadmoveto database //
            LeadDAO.createLeadMove(leadId, salesDivTo, "to", addTo, storeTo, distTo);
            //----------------------------------//
            //----------------//

            if (salesDivs != null) {
                LeadDAO.createLeadSalesDiv(leadId, salesDivs);
            }

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

            //----------------------------------------//
            if (leadType.equals("Sales")) {
                double total = 0;
                String[] surveyDates = request.getParameterValues("siteSurvey_date");
                String[] timeslots = request.getParameterValues("siteSurvey_timeslot");
                String[] addresses = request.getParameterValues("siteSurvey_address");
                String[] surveyors = request.getParameterValues("siteSurvey_surveyor");
                String[] remarks = request.getParameterValues("siteSurvey_remarks");
                String[] statuses = request.getParameterValues("siteSurvey_status");

                if (surveyDates != null) {
                    for (String surveyDate : surveyDates) {
                        String surveyorId = "";
                        String remark = "";
                        String stts = "";
                        ArrayList<String> times = new ArrayList<String>();
                        ArrayList<String> adds = new ArrayList<String>();
                        ArrayList<String> addsTags = new ArrayList<String>();
                        for (String timeslot : timeslots) {
                            if (timeslot.contains(surveyDate)) {
                                if (!times.contains(timeslot.split("\\|")[1])) {
                                    times.add(timeslot.split("\\|")[1]);
                                }
                            }
                        }

                        for (String addr : addresses) {
                            if (addr.contains(surveyDate)) {
                                if (!adds.contains(addr.split("\\|")[1])) {
                                    adds.add(addr.split("\\|")[1]);
                                }
                            }
                        }

                        for (String add : adds) {
                            if (addressFromSet.contains(add)) {
                                addsTags.add("from");
                            } else {
                                addsTags.add("to");
                            }
                        }

                        for (String sur : surveyors) {
                            if (sur.contains(surveyDate)) {
                                surveyorId = sur.split("\\|")[1];
                            }
                        }

                        for (String rem : remarks) {
                            if (rem.contains(surveyDate)) {
                                remark = rem.split("\\|", -1)[1];
                            }
                        }

                        for (String stats : statuses) {
                            if (stats.contains(surveyDate)) {
                                stts = stats.split("\\|")[1];
                            }
                        }
                        String timeslot = "";
                        if (!times.isEmpty()) {
                            timeslot = times.get(0);
                            int count = ts.get(timeslot);
                            for (int i = 1; i < times.size(); i++) {
                                String tts = times.get(i);
                                if (ts.get(tts) == count + 1) {
                                    timeslot = timeslot.substring(0, timeslot.lastIndexOf(" ")) + " " + tts.substring(tts.lastIndexOf(" ") + 1);
                                } else {
                                    timeslot += "<br>" + tts;
                                }
                                count = ts.get(tts);
                            }
                        }
                        SiteSurveyDAO.createSiteSurveyAssignment(leadId, owner.getNric(), surveyorId, surveyDate, times, adds, addsTags, timeslot, remark, stts);
                    }
                }

                if (salesDivs != null) {
                    for (String salesDiv : salesDivs) {
                        String divId = salesDiv.split("\\|")[0];
                        // Customer items //
                        String[] custItemNames = request.getParameterValues(divId + "_customerItemName");
                        String[] custItemRemarks = request.getParameterValues(divId + "_customerItemRemark");
                        String[] custItemCharges = request.getParameterValues(divId + "_customerItemCharge");
                        String[] custItemQtys = request.getParameterValues(divId + "_customerItemQty");
                        String[] custItemUnits = request.getParameterValues(divId + "_customerItemUnit");
                        if (custItemNames != null) {
                            // Enter into leadcustitem database //
                            LeadDAO.createLeadCustItem(leadId, salesDiv, custItemNames, custItemRemarks, custItemCharges, custItemQtys, custItemUnits);
                            //----------------------------------//
                        }
                        //----------------//

                        // Vimbox items //
                        String[] vimboxItemNames = request.getParameterValues(divId + "_vimboxItemName");
                        String[] vimboxItemRemarks = request.getParameterValues(divId + "_vimboxItemRemark");
                        String[] vimboxItemCharges = request.getParameterValues(divId + "_vimboxItemCharge");
                        String[] vimboxItemQtys = request.getParameterValues(divId + "_vimboxItemQty");
                        String[] vimboxItemUnits = request.getParameterValues(divId + "_vimboxItemUnit");
                        if (vimboxItemNames != null) {
                            // Enter into leadvimboxitem database //
                            LeadDAO.createLeadVimboxItem(leadId, salesDiv, vimboxItemNames, vimboxItemRemarks, vimboxItemCharges, vimboxItemQtys, vimboxItemUnits);
                            //----------------------------------//
                        }
                        //---------------//

                        // Materials //
                        String[] vimboxMaterialNames = request.getParameterValues(divId + "_vimboxMaterialName");
                        String[] vimboxMaterialCharges = request.getParameterValues(divId + "_vimboxMaterialCharge");
                        String[] vimboxMaterialQtys = request.getParameterValues(divId + "_vimboxMaterialQty");
                        if (vimboxMaterialNames != null) {
                            // Enter into leadvimboxitem database //
                            LeadDAO.createLeadMaterial(leadId, salesDiv, vimboxMaterialNames, vimboxMaterialCharges, vimboxMaterialQtys);
                            //----------------------------------//
                        }
                        //-----------//

                        // Services //
                        String[] serviceNames = request.getParameterValues(divId + "_serviceName");
                        String[] serviceCharges = request.getParameterValues(divId + "_serviceCharge");
                        if (serviceNames != null) {
                            String leadServiceInsertString = "";
                            // Enter into leadvimboxitem database //
                            for (int i = 0; i < serviceNames.length; i++) {
                                String serviceName = serviceNames[i];
                                String serviceCharge = serviceCharges[i];
                                total += Double.parseDouble(serviceCharge);
                                String serviceManpower = "";
                                String serviceRemark = "";
                                if (serviceName.contains("Manpower")) {
                                    serviceManpower = request.getParameter(divId + "_" + serviceName + "manpowerInput");
                                    serviceRemark = request.getParameter(divId + "_" + serviceName + "reasonInput");
                                }
                                leadServiceInsertString += ("('" + leadId + "','" + salesDiv + "','" + serviceName + "','" + serviceCharge + "','" + serviceManpower + "','" + serviceRemark + "')");
                                if (i < serviceNames.length - 1) {
                                    leadServiceInsertString += ",";
                                }
                            }
                            LeadDAO.createLeadService(leadServiceInsertString);
                            //----------------------------------//
                        }
                        //----------//

                        // Others //
                        String[] others = {"storeyCharge", "pushCharge", "detourCharge", "materialCharge", "markup", "discount"};
                        String[] otherCharges = new String[6];

                        String otherCharge0 = request.getParameter(divId + "_storeyCharge");
                        if(otherCharge0.isEmpty()){
                            otherCharge0 = "0";
                        }
                        otherCharges[0] = otherCharge0;
                        total += Double.parseDouble(otherCharge0);

                        String otherCharge1 = request.getParameter(divId + "_pushCharge");
                        if(otherCharge1.isEmpty()){
                            otherCharge1 = "0";
                        }
                        otherCharges[1] = otherCharge1;
                        total += Double.parseDouble(otherCharge1);

                        String otherCharge2 = request.getParameter(divId + "_detourCharge");
                        if(otherCharge2.isEmpty()){
                            otherCharge2 = "0";
                        }
                        otherCharges[2] = otherCharge2;
                        total += Double.parseDouble(otherCharge2);

                        String otherCharge3 = request.getParameter(divId + "_materialCharge");
                        if(otherCharge3.isEmpty()){
                            otherCharge3 = "0";
                        }
                        otherCharges[3] = otherCharge3;
                        total += Double.parseDouble(otherCharge3);

                        String otherCharge4 = request.getParameter(divId + "_markup");
                        if(otherCharge4.isEmpty()){
                            otherCharge4 = "0";
                        }
                        otherCharges[4] = otherCharge4;
                        total += Double.parseDouble(otherCharge4);

                        String otherCharge5 = request.getParameter(divId + "_discount");
                        if(otherCharge5.isEmpty()){
                            otherCharge5 = "0";
                        }
                        otherCharges[5] = otherCharge5;
                        total += Double.parseDouble(otherCharge5);

                        // Enter into leadother database //
                        LeadDAO.createLeadOther(leadId, salesDiv, others, otherCharges);
                            //----------------------------------//
                        //--------//

                        // Customer c&r //
                        String[] comments = request.getParameterValues(divId + "_comments");
                        if (comments != null) {
                            LeadDAO.createLeadComments(leadId, salesDiv, comments);
                        }
                        String[] custRemarks = request.getParameterValues(divId + "_remarks");
                        if (custRemarks != null) {
                            LeadDAO.createLeadRemarks(leadId, salesDiv, custRemarks);
                        }
                        //--------------//
                    }
                }
                LeadDAO.createLeadConfirmation(leadId, total);
                if (action.equals("confirm")) {
                    OutputStream out = null;
                    InputStream filecontent = null;
                    try {
                        LeadDAO.confirmLead(owner.getNric(), collectedAmount, fileName, leadId);
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
            }
            String msg = "";
            if (action.equals("save")) {
                msg = "Lead saved!";
            } else {
                msg = "Lead confirmed!";
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
