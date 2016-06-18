package com.vimbox.customer;

import com.google.gson.JsonObject;
import com.vimbox.database.CustomerDAO;
import java.io.IOException;
import java.io.PrintWriter;
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
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache");
        PrintWriter out = response.getWriter();
        
        int customer_id = Integer.parseInt(request.getParameter("customer_id"));
        String salutation = request.getParameter("salutation");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String con = request.getParameter("contact");
        int contact = 0;
        String email = request.getParameter("email");

        boolean nameError = false;
        boolean emconError = false;
        String errorMsg = "";
        
        if(firstName.isEmpty() && lastName.isEmpty()){
            nameError = true;
            errorMsg += "Please enter a first name or last name<br>";
        }
        
        if(con.isEmpty() && email.isEmpty()){
            emconError = true;
            errorMsg += "Please enter a contact or email address<br>";
        }else{
            if(!con.isEmpty()){
                try{
                    contact = Integer.parseInt(con);
                }catch(NumberFormatException nfe){
                    emconError = true;
                    errorMsg += "Please enter a valid contact<br>";
                }
            }
            
            if(!email.isEmpty() && !email.contains("@")){
                emconError = true;
                errorMsg += "Please enter a valid email<br>";
            }
        }

        JsonObject jsonOutput = new JsonObject();
        if(nameError || emconError){
            jsonOutput.addProperty("status", "ERROR");
            jsonOutput.addProperty("message", errorMsg);
        }else{
            CustomerDAO.updateCustomer(customer_id, salutation, firstName, lastName, contact, email);
            jsonOutput.addProperty("status", "SUCCESS");
            jsonOutput.addProperty("message", "Customer updated!");
            
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
