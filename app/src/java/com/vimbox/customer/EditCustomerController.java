package com.vimbox.customer;

import com.vimbox.database.CustomerDAO;
import java.io.IOException;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "EditCustomerController", urlPatterns = {"/EditCustomerController"})
public class EditCustomerController extends HttpServlet {

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
        ServletContext sc = request.getServletContext();

        String name = request.getParameter("name");
        String contact = request.getParameter("contact");
        String custId = request.getParameter("custId");
        String email = request.getParameter("email");

        String errorMsg = "";
        if (name == null || name.trim().isEmpty()) {
            errorMsg += "Please enter a customer name\n";
        } else {
            if (!contact.trim().isEmpty() || !email.trim().isEmpty()) {
                boolean contactB = true;
                boolean emailB = true;
                if (!contact.trim().isEmpty()) {
                    if (!contact.matches("[0-9]{8,20}")) {
                        contactB = false;
                        errorMsg += "Invalid contact\n";
                    }
                }

                if (!email.trim().isEmpty()) {
                    if (!email.contains("@")) {
                        emailB = false;
                        errorMsg += "Invalid email\n";
                    }
                }

                if (contactB && emailB) {
                    CustomerDAO.updateCustomer(name, contact, email,Integer.parseInt(custId));
                    sc.setAttribute("status", "success");
                    response.sendRedirect("SearchCustomers.jsp");
                    return;
                }
            } else {
                errorMsg += "Please enter a contact or email\n";
            }
        }
        sc.setAttribute("errorMsg", errorMsg);
        sc.setAttribute("name", name);
        sc.setAttribute("contact", contact);
        sc.setAttribute("email", email);
        sc.setAttribute("custId", custId);
        response.sendRedirect("EditCustomer.jsp");
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
