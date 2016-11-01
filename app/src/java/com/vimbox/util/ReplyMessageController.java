package com.vimbox.util;

import com.google.gson.JsonObject;
import com.sun.mail.imap.IMAPFolder;
import com.vimbox.user.User;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet(name = "ReplyMessageController", urlPatterns = {"/ReplyMessageController"})
@MultipartConfig
public class ReplyMessageController extends HttpServlet {

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

        String mId = request.getParameter("mId");
        String folder = request.getParameter("folder");
        String action = request.getParameter("action");

        try {
            IMAPFolder emailFolder = (IMAPFolder) httpSession.getAttribute(folder);
            Message message = emailFolder.getMessageByUID(Long.parseLong(mId));

            String content = request.getParameter("content");
            Message newMessage = null;
            String filePaths = request.getParameter("filePaths");
            switch (action) {
                case "reply":
                    newMessage = (MimeMessage) message.reply(false);
                    newMessage.setContent(content, "text/html; charset=utf-8");
                    jsonOutput.addProperty("message", "Message replied!");
                    break;
                case "replyall":
                    newMessage = (MimeMessage) message.reply(true);
                    newMessage.setContent(content, "text/html; charset=utf-8");
                    jsonOutput.addProperty("message", "Message replied!");
                    break;
                case "forward":
                    String to = request.getParameter("to");
                    String cc = request.getParameter("cc");
                    String bcc = request.getParameter("bcc");
                    String subject = request.getParameter("subject");
                    ArrayList<Part> parts = new ArrayList<Part>();
                    int partCount = 0;
                    Part part;
                    do {
                        part = request.getPart("file-" + partCount);
                        if (part != null) {
                            parts.add(part);
                            partCount++;
                        }
                    } while (part != null);

                    ArrayList<String> fileNames = new ArrayList<String>();

                    newMessage = (MimeMessage) message.reply(true);
                    newMessage.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
                    newMessage.setRecipients(Message.RecipientType.CC, InternetAddress.parse(cc));
                    newMessage.setRecipients(Message.RecipientType.BCC, InternetAddress.parse(bcc));
                    newMessage.setSubject(subject);
                    // Create the message part
                    BodyPart messageBodyPart = new MimeBodyPart();

                    // Now set the actual message
                    messageBodyPart.setContent(content, "text/html; charset=utf-8");

                    // Create a multipart message
                    Multipart multipart = new MimeMultipart();

                    // Set text message part
                    multipart.addBodyPart(messageBodyPart);
                    OutputStream out = null;
                    InputStream filecontent = null;

                    for (Part filePart : parts) {
                        String fileName = filePart.getSubmittedFileName();
                        String directoryName = System.getProperty("user.dir") + "/documents/attachments/" + user.getAccount().getUsername();
                        //String directoryName = "C:/Users/NYuSheng/Desktop/attachments/" + user.getAccount().getUsername() + "/send";

                        File directory = new File(directoryName);
                        if (!directory.exists()) {
                            directory.mkdirs();
                        }

                        String path = directoryName + "/" + fileName;

                        out = new FileOutputStream(new File(path));
                        filecontent = filePart.getInputStream();

                        int read = 0;
                        final byte[] bytes = new byte[1024];

                        while ((read = filecontent.read(bytes)) != -1) {
                            out.write(bytes, 0, read);
                        }

                        fileNames.add(path);
                        filePaths += path + "|";
                    }

                    // Part two is attachment
                    for (String fileName : fileNames) {
                        messageBodyPart = new MimeBodyPart();
                        DataSource source = new FileDataSource(fileName);
                        messageBodyPart.setDataHandler(new DataHandler(source));
                        messageBodyPart.setFileName(fileName.substring(fileName.lastIndexOf("/")));
                        multipart.addBodyPart(messageBodyPart);
                    }

                    String files = request.getParameter("files");
                    if (!files.isEmpty()) {
                        String[] attachedFiles = files.split(",");
                        for (String fileName : attachedFiles) {
                            messageBodyPart = new MimeBodyPart();
                            DataSource source = new FileDataSource(fileName);
                            messageBodyPart.setDataHandler(new DataHandler(source));
                            messageBodyPart.setFileName(fileName.substring(fileName.lastIndexOf("/")));
                            multipart.addBodyPart(messageBodyPart);
                        }
                    }
                    if (out != null) {
                        out.close();
                    }
                    if (filecontent != null) {
                        filecontent.close();
                    }

                    // Send the complete message parts
                    newMessage.setContent(multipart);
                    jsonOutput.addProperty("message", "Message forwarded!");
                    break;
            }

            if (!filePaths.isEmpty()) {
                jsonOutput.addProperty("files", filePaths);
            }
            Transport.send(newMessage);
            jsonOutput.addProperty("status", "SUCCESS");

        } catch (Exception e) {
            e.printStackTrace();
            jsonOutput.addProperty("status", "ERROR");
            jsonOutput.addProperty("message", e.getMessage());
        }
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
