package com.vimbox.util;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.sun.mail.imap.IMAPFolder;
import com.vimbox.user.User;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import javax.mail.Address;
import javax.mail.Flags;
import javax.mail.Flags.Flag;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.NoSuchProviderException;
import javax.mail.Part;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ViewMessageController", urlPatterns = {"/ViewMessageController"})
public class ViewMessageController extends HttpServlet {

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
        HttpSession httpSession = request.getSession();
        User user = (User) httpSession.getAttribute("session");
        JsonObject jsonOutput = new JsonObject();
        PrintWriter jsonOut = response.getWriter();
        long uid = Long.parseLong(request.getParameter("uid"));
        String type = request.getParameter("type");
        String errorMsg = "";
        try {
            //create the folder object and open it
            HttpSession session = request.getSession();

            IMAPFolder emailFolder = (IMAPFolder) session.getAttribute(type);
            Message message = emailFolder.getMessageByUID(uid);

            jsonOutput.addProperty("subject", message.getSubject());

            jsonOutput.addProperty("from", (message.getFrom()[0]).toString());

            jsonOutput.addProperty("fromAddress", ((InternetAddress) message.getFrom()[0]).getAddress());

            JsonArray recipientArray = new JsonArray();
            Address[] recipients = message.getRecipients(Message.RecipientType.TO);
            if (recipients != null) {
                for (Address recipient : recipients) {
                    JsonObject recipientJson = new JsonObject();
                    recipientJson.addProperty("email", recipient.toString());
                    recipientArray.add(recipientJson);
                }
                jsonOutput.add("to", recipientArray);
            }

            Address[] ccs = message.getRecipients(Message.RecipientType.CC);
            if (ccs != null) {
                JsonArray ccArray = new JsonArray();
                for (Address cc : ccs) {
                    JsonObject ccJson = new JsonObject();
                    ccJson.addProperty("email", cc.toString());
                    ccArray.add(ccJson);
                }
                jsonOutput.add("cc", ccArray);
            }

            Date date = message.getSentDate();
            jsonOutput.addProperty("sentdate", Converter.convertMailDate(date));
            jsonOutput.addProperty("fulldate", Converter.convertMailTableDate(date));

            jsonOutput.addProperty("text", getText(message));

            if (message.isMimeType("multipart/mixed")) {
                Multipart mp = (Multipart) message.getContent();
                String attachFiles = "";
                if (mp.getCount() > 0) {
                    String user_path = System.getProperty("user.dir");
                    String directoryName = user_path.substring(0, user_path.lastIndexOf("/")) + "/app-root/runtime/dependencies/jbossews/webapps/attachments/" + user.getAccount().getUsername() + "/receive";
                    //String directoryName = "C:\\Users\\NYuSheng\\Documents\\GitHub\\Vimbox\\app\\build\\web\\Images\\" + user.getAccount().getUsername() + "\\receive";
                    File directory = new File(directoryName);
                    if (!directory.exists()) {
                        directory.mkdirs();
                    }
                    for (int i = 0; i < mp.getCount(); i++) {
                        MimeBodyPart part = (MimeBodyPart) mp.getBodyPart(i);
                        if (Part.ATTACHMENT.equalsIgnoreCase(part.getDisposition())) {
                            // this part is attachment
                            // code to save attachment...
                            String fileName = directoryName + File.separator + part.getFileName();
                            part.saveFile(fileName);
                            attachFiles += fileName + "|";
                        }
                    }
                }
                if(!attachFiles.isEmpty()){
                    jsonOutput.addProperty("files", attachFiles);
                }
            }

            if (!message.isSet(Flags.Flag.SEEN)) {
                message.setFlag(Flag.SEEN, true);
            }

        } catch (NoSuchProviderException e) {
            e.printStackTrace();
        } catch (MessagingException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        jsonOut.println(jsonOutput);
    }

    private String getText(Part p) throws
            MessagingException, IOException {
        if (p.isMimeType("text/*")) {
            String s = (String) p.getContent();
            return s;
        }

        if (p.isMimeType("multipart/alternative")) {
            // prefer html text over plain text
            Multipart mp = (Multipart) p.getContent();
            String text = null;
            for (int i = 0; i < mp.getCount(); i++) {
                Part bp = mp.getBodyPart(i);
                if (bp.isMimeType("text/plain")) {
                    if (text == null) {
                        text = getText(bp);
                    }
                    continue;
                } else if (bp.isMimeType("text/html")) {
                    String s = getText(bp);
                    if (s != null) {
                        return s;
                    }
                } else {
                    return getText(bp);
                }
            }
            return text;
        } else if (p.isMimeType("multipart/*")) {
            Multipart mp = (Multipart) p.getContent();
            for (int i = 0; i < mp.getCount(); i++) {
                String s = getText(mp.getBodyPart(i));
                if (s != null) {
                    return s;
                }
            }
        }

        return null;
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
