package com.vimbox.ticket;

import com.google.gson.JsonObject;
import com.vimbox.database.TicketDAO;
import com.vimbox.user.User;
import com.vimbox.util.Converter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.joda.time.DateTime;

@WebServlet(name = "ResolveTicketController", urlPatterns = {"/ResolveTicketController"})
public class ResolveTicketController extends HttpServlet {

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
        
        String solution = request.getParameter("resolve_ticket_solution");
        
        String errorMsg = "";
        if(solution.isEmpty()){
            errorMsg+="Please enter a solution";
        }
        
        JsonObject jsonOutput = new JsonObject();
        if(errorMsg.isEmpty()){
            int ticket_id = Integer.parseInt(request.getParameter("resolve_ticket_id"));
            TicketDAO.resolveTicket(ticket_id, solution);
            jsonOutput.addProperty("status", "SUCCESS");
            jsonOutput.addProperty("message", "Ticket resolved!");
            
            Ticket ticket = TicketDAO.getTicketById(ticket_id);
            ArrayList<User> assigned_usersArr = ticket.getAssigned_users();
            String assUserStr = "";
            for (int i = 0; i < assigned_usersArr.size(); i++) {
                User assignee = assigned_usersArr.get(i);
                assUserStr += assignee.getNric() + ",";
            }
            assUserStr += ticket.getOwner_user().getNric();
            
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("session");
            
            jsonOutput.addProperty("notification", assUserStr + "|" + Converter.convertDate(new DateTime()) + " : Ticket " + ticket_id + " has been resolved by " + user);
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
