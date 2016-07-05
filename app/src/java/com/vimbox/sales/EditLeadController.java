package com.vimbox.sales;

import com.vimbox.database.CustomerHistoryDAO;
import com.vimbox.database.LeadDAO;
import com.vimbox.user.User;
import com.vimbox.util.Converter;
import java.io.IOException;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.joda.time.DateTime;

@WebServlet(name = "EditLeadController", urlPatterns = {"/EditLeadController"})
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
        // Retrieve user owner //
        User owner = (User) request.getSession().getAttribute("session");
        //---------------------//
        
        // Lead ID //
        int leadId = Integer.parseInt(request.getParameter("leadId"));
        String dt = Converter.convertDateDatabase(new DateTime());
        String status = request.getParameter("status");
        String source = request.getParameter("source");
        String referral = request.getParameter("referral");
        if(referral.equals("Others")){
            referral = request.getParameter("referralOthers");
        }
        String[] leadTypes = request.getParameterValues("leadType");
        String leadType = "";
        if(leadTypes != null){
            for(int i=0; i<leadTypes.length; i++){
                String lt = leadTypes[i];
                leadType += lt;
                if(i<leadTypes.length-1){
                    leadType += "|";
                }
            }
        }
        //---------//
        
        // Clear database of current lead info//
        LeadDAO.deleteLead(leadId);
        //------------------------------------//
        
        // Customer details //
        String cId = request.getParameter("customer_id");
        int custId = -1;
        if(!cId.isEmpty()){
            custId = Integer.parseInt(cId);
        }
        //------------------//
        
        // Moving details //
        String[] tom = request.getParameterValues("tom");
        String typesOfMove = "";
        if(tom != null){
            for(int i=0; i<tom.length; i++){
                String move = tom[i];
                typesOfMove += move;
                if(i <= tom.length-2){
                    typesOfMove += "|";
                }
            }
        }
        
        String[] dom = request.getParameterValues("dom");
        String datesOfMove = "";
        if(dom != null){
            for(int i=0; i<dom.length; i++){
                String move = dom[i];
                datesOfMove += move;
                if(i <= dom.length-2){
                    datesOfMove += "|";
                }
            }
        }
            // Enter into leadinfo database // 
            LeadDAO.createLeadInfo(owner,leadId,leadType,custId,typesOfMove,datesOfMove,dt,status,source,referral);
            if(custId > -1){
                CustomerHistoryDAO.updateCustomerHistory(custId, leadId);
            }
            //------------------------------//
        
        if(leadType.contains("Enquiry")){
            String enquiry = request.getParameter("enquiry");
            LeadDAO.createLeadEnquiry(leadId, enquiry);
        }
        
          
        // Increment by 4 per address //
        String[] addressFrom = request.getParameterValues("addressfrom");
        String addFrom = "";
        if(addressFrom != null){
            for(int i=0; i<addressFrom.length; i+=4){
                String address = addressFrom[i];
                String level = addressFrom[i+1];
                String unit = addressFrom[i+2];
                String postal = addressFrom[i+3];
                String add = address + "_" + level + "_" + unit + "_" + postal;
                addFrom += add;
                if(i < addressFrom.length-5){
                    addFrom += "|";
                }
            }
        }
        //----------------------------//
        String[] storeysFrom = request.getParameterValues("storeysfrom");
        String storeFrom = "";
        if(storeysFrom != null){
            for(int i=0; i<storeysFrom.length; i++){
                String store = storeysFrom[i];
                if(store.isEmpty()){
                    store = " ";
                }
                storeFrom += store;
                if(i < storeysFrom.length-1){
                    storeFrom += "|";
                }
            }
        }
        String[] distanceFrom = request.getParameterValues("distancefrom");
        String distFrom = "";
        if(distanceFrom != null){
            for(int i=0; i<distanceFrom.length; i++){
                String dist = distanceFrom[i];
                if(dist.isEmpty()){
                    dist = " ";
                }
                distFrom += dist;
                if(i < distanceFrom.length-1){
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
        if(addressTo != null){
            for(int i=0; i<addressTo.length; i+=4){
                String address = addressTo[i];
                String level = addressTo[i+1];
                String unit = addressTo[i+2];
                String postal = addressTo[i+3];
                String add = address + "_" + level + "_" + unit + "_" + postal;
                addTo += add;
                if(i < addressTo.length-5){
                    addTo += "|";
                }
            }
        }
        //----------------------------//
        String[] storeysTo = request.getParameterValues("storeysto");
        String storeTo = "";
        if(storeysTo != null){
            for(int i=0; i<storeysTo.length; i++){
                String store = storeysTo[i];
                if(store.isEmpty()){
                    store = " ";
                }
                storeTo += store;
                if(i < storeysTo.length-1){
                    storeTo += "|";
                }
            }
        }
        String[] distanceTo = request.getParameterValues("distanceto");
        String distTo = "";
        if(distanceTo != null){
            for(int i=0; i<distanceTo.length; i++){
                String dist = distanceTo[i];
                if(dist.isEmpty()){
                    dist = " ";
                }
                distTo += dist;
                if(i < distanceTo.length-1){
                    distTo += "|";
                }
            }
        }
            // Enter into leadmoveto database //
            LeadDAO.createLeadMoveTo(leadId, addTo, storeTo, distTo);
            //----------------------------------//
        //----------------//

        if(leadType.contains("Sales")){  
            // Customer items //
            String[] custItemNames = request.getParameterValues("customerItemName");
            String[] custItemRemarks = request.getParameterValues("customerItemRemark");
            String[] custItemCharges = request.getParameterValues("customerItemCharge");
            String[] custItemQtys = request.getParameterValues("customerItemQty");
            String[] custItemUnits = request.getParameterValues("customerItemUnit");
                if(custItemNames != null){
                    // Enter into leadcustitem database //
                    LeadDAO.createLeadCustItem(leadId, custItemNames, custItemRemarks, custItemCharges, custItemQtys, custItemUnits);
                    //----------------------------------//
                }
            //----------------//

             // Vimbox items //
            String[] vimboxItemNames = request.getParameterValues("vimboxItemName");
            String[] vimboxItemRemarks = request.getParameterValues("vimboxItemRemark");
            String[] vimboxItemCharges = request.getParameterValues("vimboxItemCharge");
            String[] vimboxItemQtys = request.getParameterValues("vimboxItemQty");
            String[] vimboxItemUnits = request.getParameterValues("vimboxItemUnit");
                if(vimboxItemNames != null){
                    // Enter into leadvimboxitem database //
                    LeadDAO.createLeadVimboxItem(leadId, vimboxItemNames, vimboxItemRemarks, vimboxItemCharges, vimboxItemQtys, vimboxItemUnits);
                    //----------------------------------//
                }
            //---------------//

            // Materials //
            String[] vimboxMaterialNames = request.getParameterValues("vimboxMaterialName");
            String[] vimboxMaterialCharges = request.getParameterValues("vimboxMaterialCharge");
            String[] vimboxMaterialQtys = request.getParameterValues("vimboxMaterialQty");
                if(vimboxMaterialNames != null){
                    // Enter into leadvimboxitem database //
                    LeadDAO.createLeadMaterial(leadId, vimboxMaterialNames, vimboxMaterialCharges, vimboxMaterialQtys);
                    //----------------------------------//
                }
            //-----------//

            // Services //
            String[] serviceNames = request.getParameterValues("serviceName");
            String[] serviceCharges = request.getParameterValues("serviceCharge");
                if(serviceNames != null){
                    String leadServiceInsertString = "";
                    // Enter into leadvimboxitem database //
                    for (int i = 0; i < serviceNames.length; i++) {
                        String serviceName = serviceNames[i];
                        String serviceCharge = serviceCharges[i];
                        String serviceManpower = "";
                        String serviceRemark = "";
                        if(serviceName.contains("Manpower")){
                            serviceManpower = request.getParameter(serviceName + "manpowerInput");
                            serviceRemark = request.getParameter(serviceName + "reasonInput");
                        }
                        leadServiceInsertString += ("('" + leadId + "','" + serviceName + "','" + serviceCharge + "','" + serviceManpower + "','" + serviceRemark + "')");
                        if(i<serviceNames.length-1){
                            leadServiceInsertString += ",";
                        }
                    }
                    LeadDAO.createLeadService(leadServiceInsertString);
                    //----------------------------------//
                }
            //----------//

            // Others //
            String[] others = {"storeyCharge","pushCharge","detourCharge","materialCharge","markup","discount"};
            String[] otherCharges = new String[5];
            otherCharges[0] = request.getParameter("storeyCharge");
            otherCharges[1] = request.getParameter("pushCharge"); 
            otherCharges[2] = request.getParameter("detourCharge");
            otherCharges[3] = request.getParameter("materialCharge");
            otherCharges[4] = request.getParameter("markup");
            otherCharges[5] = request.getParameter("discount");
                // Enter into leadother database //
                LeadDAO.createLeadOther(leadId, others, otherCharges);
                //----------------------------------//
            //--------//


            // Customer c&r //
            String[] comments = request.getParameterValues("comments");
            if(comments != null){
                LeadDAO.createLeadComments(leadId, comments);
            }
            String[] remarks = request.getParameterValues("remarks");
            if(remarks != null){
                LeadDAO.createLeadRemarks(leadId, remarks);
            }
            //--------------//
        }
        
        ServletContext sc = request.getServletContext();
        sc.setAttribute("action", "update");
        response.sendRedirect("MyLeads.jsp");
        return;
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
