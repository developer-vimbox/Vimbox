package com.vimbox.user;

import com.google.gson.JsonObject;
import com.vimbox.database.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "CreateFullTimeController", urlPatterns = {"/CreateFullTimeController"})
public class CreateFullTimeController extends HttpServlet {

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
 
        String ft_first_name = request.getParameter("ft_first_name");
        String ft_last_name = request.getParameter("ft_last_name");
        if(ft_first_name.isEmpty()){ 
            errorMsg+="Please enter employee's first name<br>";
        }
        if(ft_last_name.isEmpty()){
            errorMsg+="Please enter employee's last name<br>";
        }
        
        String ft_nric = request.getParameter("ft_nric");
        if(ft_nric.length() != 9){
            errorMsg+="Please enter a valid NRIC<br>";
        }
        
        String ft_address = request.getParameter("ft_address");
        String[] address_array = ft_address.split("\\|");
        boolean addEmpty = false;
        for(String address:address_array){
            if(address.trim().isEmpty()){
                addEmpty = true;
                break;
            }
        }
        if(addEmpty){
            errorMsg+="Please enter a valid employees's address<br>";
        }else{
            ft_address = address_array[0].trim() + "|#" + address_array[1].trim() + "-" + address_array[2].trim() + "|S" + address_array[3].trim();
        
        }
        
        String ft_gender = request.getParameter("ft_gender");
        if(ft_gender.isEmpty()){
            errorMsg+="Please enter employee's gender<br>";
        }
        
        String ft_dob = request.getParameter("ft_dob");
        Date dob = null;
        if(ft_dob.isEmpty()){
            errorMsg+="Please enter employee's date of birth<br>";
        }else{
            try{
                dob = format.parse(ft_dob);
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        
        String ft_contact = request.getParameter("ft_contact");
        if(ft_contact.length() < 8){
            errorMsg+="Please enter a valid contact number<br>";
        }
        
        String ft_dj = request.getParameter("ft_dj");
        Date dj = null;
        if(ft_dj.isEmpty()){
            errorMsg+="Please enter employee's date joined<br>";
        }else{
            try{
                dj = format.parse(ft_dj);
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        
        String ft_designation = request.getParameter("ft_designation");
        if(ft_designation.isEmpty()){
            errorMsg+="Please enter employee's designation<br>";
        }
        
        String ft_username = request.getParameter("ft_username");
        if(!ft_username.contains("@")){
            errorMsg+="Please enter a valid email address<br>";
        }
        
        String ft_password = request.getParameter("ft_password");
        if(ft_password.isEmpty()){
            errorMsg+="Please enter a password<br>";
        }
        
        String ft_modules = request.getParameter("ft_modules");
        if(ft_modules.endsWith("|")){
            ft_modules = ft_modules.substring(0,ft_modules.length()-1);
        }
        
        JsonObject jsonOutput = new JsonObject();
        if(errorMsg.isEmpty()){
            UserDAO.createUser(ft_nric, ft_username, ft_password, ft_first_name, ft_last_name, ft_gender, dob, ft_address, dj, Integer.parseInt(ft_contact), ft_designation, ft_modules);
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
