package com.vimbox.ticket;

import com.google.gson.JsonObject;
import com.vimbox.database.CustomerHistoryDAO;
import com.vimbox.database.TicketDAO;
import com.vimbox.user.User;
import com.vimbox.util.Converter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;
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
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache");
        PrintWriter out = response.getWriter();

        // Validating fields //
        String errorMsg = "";

        String subject = request.getParameter("subject");
        if (subject.isEmpty()) {
            errorMsg += "Please enter a subject title<br>";
        }

        String assigned_users = Converter.convertDuplicates(request.getParameter("assigned_users"));

        String description = request.getParameter("description");
        if (description.isEmpty()) {
            errorMsg += "Please enter a ticket description<br>";
        }

        String c_id = request.getParameter("customer_id");
        int customer_id = 0;
        try {
            customer_id = Integer.parseInt(c_id);
        } catch (NumberFormatException nfe) {
            errorMsg += "Please choose or add a customer<br>";
        }

        JsonObject jsonOutput = new JsonObject();
        if (errorMsg.isEmpty()) {
            // Generate 8 digit Ticket ID //
            int ticket_id = new Random().nextInt(90000000) + 10000000;

            CustomerHistoryDAO.updateCustomerHistory(customer_id, ticket_id);

            // Retrieve user owner //
            User owner = (User) request.getSession().getAttribute("session");
            String owner_user = owner.getNric();

            // Retrieve date time of ticket creation // 
            DateTime dt = new DateTime();

            TicketDAO.createTicket(ticket_id, owner_user, assigned_users, customer_id, dt, dt, subject, description, "Pending");
            jsonOutput.addProperty("status", "SUCCESS");
            jsonOutput.addProperty("message", "Ticket submitted!");
            String[] assigned_usersArr = assigned_users.split("\\|");
            String assUserStr = "";
            for (int i = 0; i < assigned_usersArr.length; i++) {
                String assignee = assigned_usersArr[i];
                assUserStr += assignee;
                if (i < assigned_usersArr.length - 1) {
                    assUserStr += ",";
                }
            }
            jsonOutput.addProperty("notification", assUserStr + "|" + Converter.convertDate(new DateTime()) + " : You have been assigned ticket " + ticket_id + "|MyTickets.jsp");
        } else {
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
