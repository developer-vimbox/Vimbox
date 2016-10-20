package com.vimbox.util;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.sun.mail.imap.IMAPMessage;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.MimeMultipart;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoadMessagesController", urlPatterns = {"/LoadMessagesController"})
public class LoadMessagesController extends HttpServlet {

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

        String errorMsg = "";
        try {
            HttpSession session = request.getSession();
            Folder emailFolder = (Folder) session.getAttribute(type);
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
                emailFolder = store.getFolder(type);
                emailFolder.open(Folder.READ_WRITE);
//                Folder[] f = store.getDefaultFolder().list("*");
//                for(Folder fd:f)
//                    System.out.println(">> "+fd.getName());
                session.setAttribute(type, emailFolder);
            }

            // retrieve the messages from the folder in an array and print it
            Message[] messages = emailFolder.getMessages();
            jsonOutput.addProperty("size", messages.length);
            JsonArray inboxMessages = new JsonArray();

            FetchProfile fetchProfile = new FetchProfile();
            fetchProfile.add(FetchProfile.Item.ENVELOPE);
            fetchProfile.add(FetchProfile.Item.CONTENT_INFO);
            fetchProfile.add(FetchProfile.Item.FLAGS);
            fetchProfile.add(UIDFolder.FetchProfileItem.UID);
            emailFolder.fetch(messages, fetchProfile);

            for (int i = 0, n = messages.length; i < n; i++) {
                Message message = messages[i];
                ((IMAPMessage) message).setPeek(true);
                JsonObject jsonMsg = new JsonObject();

                jsonMsg.addProperty("uid", ((UIDFolder) emailFolder).getUID(message));

                jsonMsg.addProperty("subject", message.getSubject());
                
                Address[] froms = message.getFrom();
                String from = "";
                if(froms != null && froms.length > 0){
                    from = (message.getFrom()[0]).toString();
                }
                jsonMsg.addProperty("from", from);

                jsonMsg.addProperty("sentdate", Converter.convertMailDate(message.getSentDate()));

                jsonMsg.addProperty("text", getTextFromMessage(message));

                if (message.isMimeType("multipart/mixed")) {
                    Multipart mp = (Multipart) message.getContent();
                    if (mp.getCount() > 1) {
                        jsonMsg.addProperty("attachment", "YES");
                    }
                }

                if (message.isSet(Flags.Flag.SEEN)) {
                    jsonMsg.addProperty("seen", "YES");
                }

                inboxMessages.add(jsonMsg);
            }

            jsonOutput.add("messages", inboxMessages);

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
        jsonOut.println(jsonOutput);
    }

    private String getTextFromMessage(Message message) throws Exception {
        String result = "";
        if (message.isMimeType("text/plain")) {
            result = message.getContent().toString();
        } else if (message.isMimeType("multipart/*")) {
            MimeMultipart mimeMultipart = (MimeMultipart) message.getContent();
            result = getTextFromMimeMultipart(mimeMultipart);
        }
        return result;
    }

    private String getTextFromMimeMultipart(MimeMultipart mimeMultipart) throws Exception {
        String result = "";
        int count = mimeMultipart.getCount();
        for (int i = 0; i < count; i++) {
            BodyPart bodyPart = mimeMultipart.getBodyPart(i);
            if (bodyPart.isMimeType("text/plain")) {
                result = result + "\n" + bodyPart.getContent();
                break; // without break same text appears twice in my tests
            } else if (bodyPart.isMimeType("text/html")) {
                String html = (String) bodyPart.getContent();
                result = result + "\n" + html;
            } else if (bodyPart.getContent() instanceof MimeMultipart) {
                result = result + getTextFromMimeMultipart((MimeMultipart) bodyPart.getContent());
            }
        }
        return result;
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
