package com.vimbox.user;

import com.google.gson.JsonObject;
import com.vimbox.database.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "CreatePartTimeController", urlPatterns = {"/CreatePartTimeController"})
public class CreatePartTimeController extends HttpServlet {

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
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        
        // Validating fields //
        String errorMsg = "";
 
        String pt_first_name = request.getParameter("pt_first_name");
        String pt_last_name = request.getParameter("pt_last_name");
        if(pt_first_name.isEmpty()){ 
            errorMsg+="Please enter employee's first name<br>";
        }
        if(pt_last_name.isEmpty()){
            errorMsg+="Please enter employee's last name<br>";
        }
        
        String pt_nric = request.getParameter("pt_nric");
        if(pt_nric.length() != 9){
            errorMsg+="Please enter a valid NRIC<br>";
        }
        
        String pt_contact = request.getParameter("pt_contact");
        if(pt_contact.length() < 8){
            errorMsg+="Please enter a valid contact number<br>";
        }
        
        String pt_dj = request.getParameter("pt_dj");
        Date dj = null;
        if(pt_dj.isEmpty()){
            errorMsg+="Please enter employee's date joined<br>";
        }else{
            try{
                dj = format.parse(pt_dj);
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        
        String pt_designation = request.getParameter("pt_designation");
        if(pt_designation.isEmpty()){
            errorMsg+="Please enter employee's designation<br>";
        }
        
        JsonObject jsonOutput = new JsonObject();
        if(errorMsg.isEmpty()){
            UserDAO.createPartTimeUser(pt_nric, pt_first_name, pt_last_name, dj, Integer.parseInt(pt_contact), pt_designation);
            jsonOutput.addProperty("status", "SUCCESS");
            jsonOutput.addProperty("message", "Full-Time employee added!");
        }else{
            jsonOutput.addProperty("status", "ERROR");
            jsonOutput.addProperty("message", errorMsg);
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
