package com.vimbox.ticket;

import com.vimbox.database.CustomerHistoryDAO;
import com.vimbox.database.TicketDAO;
import com.vimbox.database.UserDAO;
import com.vimbox.user.User;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Random;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.joda.time.DateTime;

@WebServlet(name = "CreateTicketController", urlPatterns = {"/CreateTicketController"})
public class CreateTicketController extends HttpServlet {

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
        // Detect direct access to servlet //
        String buttonPushed = request.getParameter("submit");
        if (buttonPushed == null) {
            response.sendRedirect("CreateTicket.jsp");
            return;
        }
        
        // Validating fields //
        String errorMsg = "";
 
        String subject = request.getParameter("subject");
        if(subject.isEmpty()){
            errorMsg+="Please enter a subject title:";
        }
        
        String[] assigned = request.getParameterValues("assigned");
        
        String description = request.getParameter("description");
        if(description.isEmpty()){
            errorMsg+="Please enter a ticket description:";
        }
        
        // Setting error or no error paths //
        ServletContext sc = request.getServletContext();
        if(errorMsg.isEmpty()){
            // Generate 8 digit Ticket ID //
            int random = new Random().nextInt(100000000) + 1;
            String ticketId = String.format("%08d",random);
            
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
            
            // Retrieve user owner //
            User owner = (User) request.getSession().getAttribute("session");
            
            // Retrieve date time of ticket creation // 
            DateTime dt = new DateTime();
            
            // Retrieve the assigned users //
            ArrayList<User> assignedUsers = new ArrayList<User>();
            for(String aname: assigned){
                User assignee = UserDAO.getUserByFullname(aname);
                if(!assignedUsers.contains(assignee)){
                    assignedUsers.add(assignee);
                }
            }
            
            Ticket ticket = TicketDAO.createTicket(owner, ticketId, customerName, contactNumber, dt, subject, assignedUsers, description, "Pending", email);
            sc.setAttribute("ticket", ticket);
            response.sendRedirect("CreateTicket.jsp");
            return;
        }else{
            sc.setAttribute("errorMsg", errorMsg);
            response.sendRedirect("CreateTicket.jsp");
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
