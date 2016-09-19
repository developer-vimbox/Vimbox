package com.vimbox.sitesurvey;

import com.google.gson.JsonObject;
import com.vimbox.database.LeadDAO;
import com.vimbox.database.SiteSurveyDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "SaveSiteSurveyController", urlPatterns = {"/SaveSiteSurveyController"})
public class SaveSiteSurveyController extends HttpServlet {

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
        double total = 0;
        String lead = request.getParameter("lead");
        String[] leadArr = lead.split("\\|");
        int leadId = Integer.parseInt(leadArr[0]);
        String date = leadArr[1];
        String timeslot = leadArr[2];

        String[] salesDivs = request.getParameterValues("salesDiv");
        String[] surveyAreas = request.getParameterValues("survey_area");
        for (String sD : salesDivs) {

            String[] sDArr = sD.split("\\|");
            String salesDiv = sDArr[0];

            ArrayList<String> sAs = new ArrayList<String>();
            if (surveyAreas != null) {
                for (String surveyArea : surveyAreas) {
                    if (surveyArea.contains(salesDiv)) {
                        sAs.add(surveyArea);
                    }
                }

            }
            String storeys = request.getParameter(salesDiv + "_storeys");
            String distance = request.getParameter(salesDiv + "_distance");

            LeadDAO.updateAddress(leadId, sD, storeys, distance);

            // Services //
            String[] serviceNames = request.getParameterValues(salesDiv + "_serviceName");
            String[] serviceCharges = request.getParameterValues(salesDiv + "_serviceCharge");
            if (serviceNames != null) {
                String leadServiceInsertString = "";
                // Enter into leadvimboxitem database //
                for (int i = 0; i < serviceNames.length; i++) {
                    String serviceName = serviceNames[i];
                    String serviceCharge = serviceCharges[i];
                    try {
                        if (serviceCharge.matches("-?\\d+(\\.\\d+)?")) {
                            total += Double.parseDouble(serviceCharge);
                        }

                    } catch (Exception e) {
                        total += 0;
                    }
                    String serviceManpower = "";
                    String serviceRemark = "";
                    if (serviceName.contains("Manpower")) {
                        serviceManpower = request.getParameter(salesDiv + "_" + serviceName + "manpowerInput");
                        serviceRemark = request.getParameter(salesDiv + "_" + serviceName + "reasonInput");
                    }
                    leadServiceInsertString += ("('" + leadId + "','" + sD + "','" + serviceName + "','" + serviceCharge + "','" + serviceManpower + "','" + serviceRemark + "')");
                    if (i < serviceNames.length - 1) {
                        leadServiceInsertString += ",";
                    }
                }
                LeadDAO.createSiteLeadService(leadServiceInsertString, leadId);
                //----------------------------------//
            }
            //----------//

            // Others //
            String[] others = {"storeyCharge", "pushCharge", "detourCharge", "materialCharge", "discount"};
            String[] otherCharges = new String[5];
            if (otherCharges != null) {
                try {

                    String otherCharge0 = request.getParameter(salesDiv + "_storeyCharge");
                    otherCharges[0] = otherCharge0;
                    if (otherCharge0.matches("-?\\d+(\\.\\d+)?")) {
                        total += Double.parseDouble(otherCharge0);
                    }

                    String otherCharge1 = request.getParameter(salesDiv + "_pushCharge");
                    otherCharges[1] = otherCharge1;
                      if (otherCharge1.matches("-?\\d+(\\.\\d+)?")) {
                        total += Double.parseDouble(otherCharge1);
                    }

                    String otherCharge2 = request.getParameter(salesDiv + "_detourCharge");
                    otherCharges[2] = otherCharge2;
                    total += Double.parseDouble(otherCharge2);
                    if (otherCharge2.matches("-?\\d+(\\.\\d+)?")) {
                        total += Double.parseDouble(otherCharge2);
                    }

                    String otherCharge3 = request.getParameter(salesDiv + "_materialCharge");
                    otherCharges[3] = otherCharge3;
                    total += Double.parseDouble(otherCharge3);
                    if (otherCharge3.matches("-?\\d+(\\.\\d+)?")) {
                        total += Double.parseDouble(otherCharge3);
                    }

                    String otherCharge4 = request.getParameter(salesDiv + "_discount");
                    otherCharges[4] = otherCharge4;
                    total += Double.parseDouble(otherCharge4);
                    if (otherCharge4.matches("-?\\d+(\\.\\d+)?")) {
                        total += Double.parseDouble(otherCharge4);
                    }
                    

                } catch (Exception e) {
                    total += 0;
                }

                // Enter into leadother database //
                LeadDAO.updateLeadOther(leadId, sD, others, otherCharges);
            }
                //----------------------------------//
            //--------//

            // Customer c&r //
            String comments = request.getParameter(salesDiv + "_comments");
            LeadDAO.createSiteLeadComments(leadId, sD, comments);
            //--------------//

            ArrayList<String> surveyAreasDBs = new ArrayList<String>();
            ArrayList<String> surveyAreaNamesDBs = new ArrayList<String>();

            for (String ssA : sAs) {
                String ss = ssA.split("\\|")[1];

                String siteName = request.getParameter(salesDiv + "+" + ss + "+siteAreaName");
                surveyAreasDBs.add(ss);
                surveyAreaNamesDBs.add(siteName);
                // Customer items //
                String[] custItemNames = request.getParameterValues(salesDiv + "_" + ss + "_CustomerName");
                String[] custItemRemarks = request.getParameterValues(salesDiv + "_" + ss + "_CustomerRemarks");
                String[] custItemCharges = request.getParameterValues(salesDiv + "_" + ss + "_CustomerAddCharges");
                String[] custItemQtys = request.getParameterValues(salesDiv + "_" + ss + "_CustomerQuantity");
                String[] custItemUnits = request.getParameterValues(salesDiv + "_" + ss + "_CustomerUnits");
                if (custItemCharges != null && custItemNames != null && custItemRemarks != null && custItemQtys != null && custItemUnits != null) {
                    // Enter into leadcustitem database //
                    LeadDAO.createSiteLeadCustItem(leadId, sD, ss, custItemNames, custItemRemarks, custItemCharges, custItemQtys, custItemUnits);
                    //----------------------------------//
                }
                //----------------//

                // Vimbox items //
                String[] vimboxItemNames = request.getParameterValues(salesDiv + "_" + ss + "_VimboxName");
                String[] vimboxItemRemarks = request.getParameterValues(salesDiv + "_" + ss + "_VimboxRemarks");
                String[] vimboxItemCharges = request.getParameterValues(salesDiv + "_" + ss + "_VimboxAddCharges");
                String[] vimboxItemQtys = request.getParameterValues(salesDiv + "_" + ss + "_VimboxQuantity");
                String[] vimboxItemUnits = request.getParameterValues(salesDiv + "_" + ss + "_VimboxUnits");

                if (vimboxItemNames != null && vimboxItemRemarks != null && vimboxItemCharges != null && vimboxItemQtys != null && vimboxItemUnits != null) {
                    // Enter into leadvimboxitem database //
                    LeadDAO.createSiteLeadVimboxItem(leadId, sD, ss, vimboxItemNames, vimboxItemRemarks, vimboxItemCharges, vimboxItemQtys, vimboxItemUnits);
                    //----------------------------------//
                }
                //---------------//
            }

            String surveyAreasDBString = "";
            if (surveyAreasDBs != null && surveyAreaNamesDBs != null) {
                for (int i = 0; i < surveyAreasDBs.size(); i++) {
                    String surveyAreasDB = surveyAreasDBs.get(i);
                    surveyAreasDBString += surveyAreasDB;
                    if (i < surveyAreasDBs.size() - 1) {
                        surveyAreasDBString += "|";
                    }
                }

                String surveyAreasNamesDBString = "";
                for (int i = 0; i < surveyAreaNamesDBs.size(); i++) {
                    String surveyAreaNamesDB = surveyAreaNamesDBs.get(i);
                    surveyAreasNamesDBString += surveyAreaNamesDB;
                    if (i < surveyAreaNamesDBs.size() - 1) {
                        surveyAreasNamesDBString += "|";
                    }
                }

                LeadDAO.updateLeadSalesDiv(leadId, sD, surveyAreasDBString, surveyAreasNamesDBString);
            }
        }

        LeadDAO.createLeadConfirmation(leadId, total);

        jsonOutput.addProperty("status", "SUCCESS");
        String message = "";
        String completed = request.getParameter("complete");
        if (completed != null) {
            if (completed.equals("yes")) {
                SiteSurveyDAO.completeSiteSurvey(leadId, date, timeslot);
                jsonOutput.addProperty("completed", "YES");
                message = "Survey completed!";
            } else {
                jsonOutput.addProperty("completed", "NO");
                message = "Survey saved!";
            }
        }

        jsonOutput.addProperty("message", message);
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
