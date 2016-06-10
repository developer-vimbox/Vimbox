package com.vimbox.ticket;

import com.vimbox.database.CustomerHistoryDAO;
import com.vimbox.database.TicketDAO;
import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "EditTicketController", urlPatterns = {"/EditTicketController"})
public class EditTicketController extends HttpServlet {

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
        String buttonPushed = request.getParameter("submit");
        if (buttonPushed == null) {
            response.sendRedirect("MyTickets.jsp");
            return;
        }
        
        // Validating fields //
        String errorMsg = "";
 
        String subject = request.getParameter("subject");
        if(subject.isEmpty()){
            errorMsg+="Please enter a subject title:";
        }
        
        String[] assigned = request.getParameterValues("assigned");
        ArrayList<String> assignees = new ArrayList<String>();
        for(String name:assigned){
            if(!assignees.contains(name)){
                assignees.add(name);
            }
        }
        
        String description = request.getParameter("description");
        if(description.isEmpty()){
            errorMsg+="Please enter a ticket description:";
        }
        
        String ticketId = request.getParameter("ticketId");
        
        // Setting error or no error paths //
        ServletContext sc = request.getServletContext();
        if(errorMsg.isEmpty()){
            
            // Retrieve customer details if available //
            String salutation = request.getParameter("salutation");
            String name = request.getParameter("name");
            String customerName = "";
            if(!name.isEmpty()){
                customerName = salutation + " " + name;
            }
            String contactNumber = request.getParameter("contact");
            String email = request.getParameter("email");
            
            String custId = request.getParameter("custId");
            if(custId != null){
                CustomerHistoryDAO.updateCustomerHistory(Integer.parseInt(custId), ticketId);
            }
            
            // Retrieve the assigned users //
            String assignedUsers = "";
            for(int i=0; i<assignees.size(); i++){
                String aname = assignees.get(i);
                assignedUsers += aname;
                if(i+1 < assigned.length){
                    assignedUsers += ",";
                }
            }
            
            TicketDAO.updateTicket(subject, assignedUsers, customerName, contactNumber, email,description, ticketId);
            sc.setAttribute("action", "update");
            response.sendRedirect("MyTickets.jsp");
            return;
        }else{
            sc.setAttribute("errorMsg", errorMsg);
            response.sendRedirect("EditTicket.jsp?tId=" + ticketId);
            return;
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
