package com.vimbox.user;

import com.google.gson.JsonObject;
import com.vimbox.database.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ChangePasswordController", urlPatterns = {"/ChangePasswordController"})
public class ChangePasswordController extends HttpServlet {

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
        
        String errorMsg = "";
        boolean oldEmpty = false;
        boolean newEmpty = false;
        boolean cfmEmpty = false;
        
        String oldPassword = request.getParameter("old_password");
        if(oldPassword.isEmpty()){
            oldEmpty = true;
            errorMsg += "Please enter your old password<br>";
        }
        
        String newPassword = request.getParameter("new_password");
        if(newPassword.isEmpty()){
            newEmpty = true;
            errorMsg += "Please enter your new password<br>";
        }
        
        String confirmPassword = request.getParameter("confirm_new_password");
        if(confirmPassword.isEmpty()){
            cfmEmpty = true;
            errorMsg += "Please confirm your new password<br>";
        }
        
        if(!oldEmpty && !newEmpty && !cfmEmpty){
            if(!newPassword.equals(confirmPassword)){
                errorMsg += "New passwords do not match<br>";
            }

            if(oldPassword.equals(newPassword)){
                errorMsg += "New password cannot be the same as old password<br>";
            }
        }
        
        JsonObject jsonOutput = new JsonObject();
        if(errorMsg.isEmpty()){
            String user_id = request.getParameter("user_id");
            User user = UserDAO.getUserByNRIC(user_id);
            Account account = user.getAccount();
            String current_password = account.getPassword();
            
            if(oldPassword.equals(current_password)){
                UserDAO.updateUserPassword(newPassword, user_id);
                jsonOutput.addProperty("status", "SUCCESS");
                jsonOutput.addProperty("errorMsg", "Password has been updated!");
            }else{
                errorMsg += "Please enter the correct old password<br>";
                jsonOutput.addProperty("status", "ERROR");
                jsonOutput.addProperty("errorMsg", errorMsg);
            }
        }else{
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
