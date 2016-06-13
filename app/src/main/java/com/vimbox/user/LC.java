package com.vimbox.user;

import com.vimbox.database.UserDAO;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginController", urlPatterns = {"/LC"})
public class LC extends HttpServlet {

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
        // Retrieves the entered emailID and password //
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String buttonPushed = request.getParameter("submit");
        
        // Detect direct access to servlet
        if (buttonPushed == null) {
            response.sendRedirect("Login.jsp");
            return;
        } else {
            User user = UserDAO.getUserByUsername(username);
            
            // Validates the login details //
            RequestDispatcher view;
            HttpSession session = request.getSession();
            if (user != null) {
                // Checks if user login //
                String currPassword = user.getPassword();
                if (currPassword.equals(password)) {
                    session.setAttribute("session", user);
                    response.sendRedirect("HomePage.jsp");
                    return;
                }
            }

            ServletContext sc = request.getServletContext();
            sc.setAttribute("errorMsg", "Incorrect Email ID / Password");
            response.sendRedirect("Login.jsp");
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
