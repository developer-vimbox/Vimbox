package com.vimbox.sales;

import com.google.gson.JsonObject;
import com.vimbox.database.CustomerHistoryDAO;
import com.vimbox.database.LeadDAO;
import com.vimbox.database.SiteSurveyDAO;
import com.vimbox.user.User;
import com.vimbox.util.Converter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.joda.time.DateTime;

@WebServlet(name = "CreateLeadController", urlPatterns = {"/CreateLeadController"})
public class CreateLeadController extends HttpServlet {

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

        // Retrieve user owner //
        User owner = (User) request.getSession().getAttribute("session");
        //---------------------//

        // Lead ID //
        int leadId = Integer.parseInt(request.getParameter("leadId"));
        String dt = Converter.convertDateDatabase(new DateTime());
        String status = request.getParameter("status");
        String source = request.getParameter("source");
        String referral = request.getParameter("referral");
        if (referral.equals("Others")) {
            referral = request.getParameter("referralOthers");
        }
        String[] leadTypes = request.getParameterValues("leadType");
        String leadType = "";
        if (leadTypes != null) {
            for (int i = 0; i < leadTypes.length; i++) {
                String lt = leadTypes[i];
                leadType += lt;
                if (i < leadTypes.length - 1) {
                    leadType += "|";
                }
            }
        }
        //---------//

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

        String[] dom = request.getParameterValues("dom");
        String datesOfMove = "";
        if (dom != null) {
            for (int i = 0; i < dom.length; i++) {
                String move = dom[i];
                datesOfMove += move;
                if (i <= dom.length - 2) {
                    datesOfMove += "|";
                }
            }
        }
        // Enter into leadinfo database // 
        LeadDAO.createLeadInfo(owner, leadId, leadType, custId, typesOfMove, datesOfMove, dt, status, source, referral);
        if (custId > -1) {
            CustomerHistoryDAO.updateCustomerHistory(custId, leadId);
        }
            //------------------------------//

        if (leadType.contains("Enquiry")) {
            String enquiry = request.getParameter("enquiry");
            LeadDAO.createLeadEnquiry(leadId, enquiry);
        }

        if (leadType.contains("Survey")) {
            String[] surveyDates = request.getParameterValues("siteSurvey_date");
            String[] timeslots = request.getParameterValues("siteSurvey_timeslot");
            String[] addresses = request.getParameterValues("siteSurvey_address");
            String[] surveyors = request.getParameterValues("siteSurvey_surveyor");
            String[] remarks = request.getParameterValues("siteSurvey_remarks");

            if (surveyDates != null) {
                HashMap<String, Integer> ts = new HashMap<String, Integer>();
                String[] timings = new String[]{"0900 - 0930", "0930 - 1000", "1000 - 1030", "1030 - 1100", "1100 - 1130", "1130 - 1200", "1200 - 1230", "1230 - 1300", "1300 - 1330", "1330 - 1400", "1400 - 1430", "1430 - 1500", "1500 - 1530", "1530 - 1600", "1600 - 1630", "1630 - 1700", "1700 - 1730", "1730 - 1800"};
                for (int i = 0; i < timings.length; i++) {
                    ts.put(timings[i], i);
                }

                for (String surveyDate : surveyDates) {
                    String surveyorId = "";
                    String remark = "";
                    ArrayList<String> times = new ArrayList<String>();
                    ArrayList<String> adds = new ArrayList<String>();
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
                    SiteSurveyDAO.createSiteSurveyAssignment(leadId, surveyorId, surveyDate, times, adds, timeslot, remark);
                }
            }
        }

        // Increment by 4 per address //
        String[] addressFrom = request.getParameterValues("addressfrom");
        String addFrom = "";
        if (addressFrom != null) {
            for (int i = 0; i < addressFrom.length; i += 4) {
                String address = addressFrom[i];
                String level = addressFrom[i + 1];
                String unit = addressFrom[i + 2];
                String postal = addressFrom[i + 3];
                String add = address + "_" + level + "_" + unit + "_" + postal;
                addFrom += add;
                if (i < addressFrom.length - 5) {
                    addFrom += "|";
                }
            }
        }
        //----------------------------//
        String[] storeysFrom = request.getParameterValues("storeysfrom");
        String storeFrom = "";
        if (storeysFrom != null) {
            for (int i = 0; i < storeysFrom.length; i++) {
                String store = storeysFrom[i];
                if (store.isEmpty()) {
                    store = " ";
                }
                storeFrom += store;
                if (i < storeysFrom.length - 1) {
                    storeFrom += "|";
                }
            }
        }
        String[] distanceFrom = request.getParameterValues("distancefrom");
        String distFrom = "";
        if (distanceFrom != null) {
            for (int i = 0; i < distanceFrom.length; i++) {
                String dist = distanceFrom[i];
                if (dist.isEmpty()) {
                    dist = " ";
                }
                distFrom += dist;
                if (i < distanceFrom.length - 1) {
                    distFrom += "|";
                }
            }
        }
        // Enter into leadmovefrom database //
        LeadDAO.createLeadMoveFrom(leadId, addFrom, storeFrom, distFrom);
            //----------------------------------//

        // Increment by 4 per address //
        String[] addressTo = request.getParameterValues("addressto");
        String addTo = "";
        if (addressTo != null) {
            for (int i = 0; i < addressTo.length; i += 4) {
                String address = addressTo[i];
                String level = addressTo[i + 1];
                String unit = addressTo[i + 2];
                String postal = addressTo[i + 3];
                String add = address + "_" + level + "_" + unit + "_" + postal;
                addTo += add;
                if (i < addressTo.length - 5) {
                    addTo += "|";
                }
            }
        }
        //----------------------------//
        String[] storeysTo = request.getParameterValues("storeysto");
        String storeTo = "";
        if (storeysTo != null) {
            for (int i = 0; i < storeysTo.length; i++) {
                String store = storeysTo[i];
                if (store.isEmpty()) {
                    store = " ";
                }
                storeTo += store;
                if (i < storeysTo.length - 1) {
                    storeTo += "|";
                }
            }
        }
        String[] distanceTo = request.getParameterValues("distanceto");
        String distTo = "";
        if (distanceTo != null) {
            for (int i = 0; i < distanceTo.length; i++) {
                String dist = distanceTo[i];
                if (dist.isEmpty()) {
                    dist = " ";
                }
                distTo += dist;
                if (i < distanceTo.length - 1) {
                    distTo += "|";
                }
            }
        }
        // Enter into leadmoveto database //
        LeadDAO.createLeadMoveTo(leadId, addTo, storeTo, distTo);
            //----------------------------------//
        //----------------//

        if (leadType.contains("Sales")) {
            String[] salesDivs = request.getParameterValues("divId");
            LeadDAO.createLeadSalesDiv(leadId, salesDivs);
            for(String salesDiv: salesDivs){
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
                otherCharges[0] = request.getParameter(divId + "_storeyCharge");
                otherCharges[1] = request.getParameter(divId + "_pushCharge");
                otherCharges[2] = request.getParameter(divId + "_detourCharge");
                otherCharges[3] = request.getParameter(divId + "_materialCharge");
                otherCharges[4] = request.getParameter(divId + "_markup");
                otherCharges[5] = request.getParameter(divId + "_discount");
                // Enter into leadother database //
                LeadDAO.createLeadOther(leadId, salesDiv, others, otherCharges);
                    //----------------------------------//
                //--------//

                // Customer c&r //
                String[] comments = request.getParameterValues(divId + "_comments");
                if (comments != null) {
                    LeadDAO.createLeadComments(leadId, salesDiv, comments);
                }
                String[] remarks = request.getParameterValues(divId + "_remarks");
                if (remarks != null) {
                    LeadDAO.createLeadRemarks(leadId, salesDiv, remarks);
                }
                //--------------//
            }
        }

        jsonOutput.addProperty("status", "SUCCESS");
        jsonOutput.addProperty("message", "Lead saved!");
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
