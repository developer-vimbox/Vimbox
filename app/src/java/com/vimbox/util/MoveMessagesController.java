package com.vimbox.util;

import com.google.gson.JsonObject;
import com.sun.mail.imap.IMAPFolder;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Properties;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.NoSuchProviderException;
import javax.mail.Session;
import javax.mail.Store;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "MoveMessagesController", urlPatterns = {"/MoveMessagesController"})
public class MoveMessagesController extends HttpServlet {

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
        JsonObject jsonOutput = new JsonObject();
        PrintWriter jsonOut = response.getWriter();
        String type = request.getParameter("type");
        String dest = request.getParameter("dest");
        String[] uIds = request.getParameter("mail").split("\\|");

        try {
            HttpSession session = request.getSession();
            IMAPFolder emailFolder = (IMAPFolder) session.getAttribute(type);
            if (emailFolder == null) {
                //create properties field
                Properties properties = new Properties();

                properties.put("mail.smtp.host", "smtp.gmail.com");
                properties.put("mail.smtp.port", "465");
                properties.put("mail.smtp.starttls.enable", "true");
                properties.put("mail.smtp.auth", "true");
                Session emailSession = Session.getDefaultInstance(properties);

                //create the POP3 store object and connect with the pop server
                Store store = emailSession.getStore("imaps");
                store.connect("smtp.gmail.com", "developer.vimbox@gmail.com", "dev@vimbox");

                //create the folder object and open it
                emailFolder = (IMAPFolder) store.getFolder(type);
                emailFolder.open(Folder.READ_WRITE);
//                Folder[] f = store.getDefaultFolder().list("*");
//                for(Folder fd:f)
//                    System.out.println(">> "+fd.getName());
                session.setAttribute(type, emailFolder);
            }

            ArrayList<Message> tempList = new ArrayList<>();
            Flags deleted = new Flags(Flags.Flag.DELETED);
            for (String uId : uIds) {
                Message message = emailFolder.getMessageByUID(Long.parseLong(uId));
                tempList.add(message);
            }

            Message[] tempMessageArray = tempList.toArray(new Message[tempList.size()]);
            Folder destFolder = (Folder) session.getAttribute(dest);
            if (destFolder == null) {
                //create properties field
                Properties properties = new Properties();

                properties.put("mail.smtp.host", "smtp.gmail.com");
                properties.put("mail.smtp.port", "465");
                properties.put("mail.smtp.starttls.enable", "true");
                properties.put("mail.smtp.auth", "true");
                Session emailSession = Session.getDefaultInstance(properties);

                //create the POP3 store object and connect with the pop server
                Store store = emailSession.getStore("imaps");
                store.connect("smtp.gmail.com", "developer.vimbox@gmail.com", "dev@vimbox");

                //create the folder object and open it
                destFolder = store.getFolder(dest);
                destFolder.open(Folder.READ_WRITE);
//                Folder[] f = store.getDefaultFolder().list("*");
//                for(Folder fd:f)
//                    System.out.println(">> "+fd.getName());
                session.setAttribute(dest, destFolder);
            }
            emailFolder.copyMessages(tempMessageArray, destFolder);
            

            emailFolder.setFlags(tempMessageArray, deleted, true);
            emailFolder.expunge();
            //close the store and folder objects
//            emailFolder.close(false);
//            store.close();
        } catch (NoSuchProviderException e) {
            e.printStackTrace();
        } catch (MessagingException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        jsonOutput.addProperty("status", "SUCCESS");
        jsonOut.println(jsonOutput);
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
