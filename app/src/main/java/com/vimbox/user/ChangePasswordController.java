package com.vimbox.user;

import com.vimbox.database.UserDAO;
import java.io.IOException;
import javax.servlet.ServletContext;
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
        String username = request.getParameter("username");
        User user = UserDAO.getUserByUsername(username);
        String oldPassword = request.getParameter("old_password");
        
        String errorMsg = "";
        if(!user.getPassword().equals(oldPassword)){
            errorMsg += "Old password is incorrect";
        }else{
            String newPassword = request.getParameter("new_password");
            String confirmPassword = request.getParameter("confirm_new_password");
            if(newPassword.equals(oldPassword)){
                errorMsg += "New password cannot be the same as old password";
            }else{
                if(newPassword.equals(confirmPassword)){
                    UserDAO.updateUserPassword(newPassword, username);
                    errorMsg += "success";
                }else{
                    errorMsg += "New passwords do not match";
                }
            }
        }
        
        ServletContext sc = request.getServletContext();
        sc.setAttribute("errorMsg",errorMsg);
        response.sendRedirect("ChangePassword.jsp");
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
