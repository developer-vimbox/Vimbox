package com.vimbox.util;

import com.google.gson.JsonObject;
import com.vimbox.user.User;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Properties;
import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
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
import org.apache.catalina.core.ApplicationPart;

@WebServlet(name = "SendMessageController", urlPatterns = {"/SendMessageController"})
@MultipartConfig
public class SendMessageController extends HttpServlet {

    private String username;
    private String password;

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
        username = user.getAccount().getUsername();
        password = user.getAccount().getPassword();
        JsonObject jsonOutput = new JsonObject();
        PrintWriter jsonOut = response.getWriter();

        String to = request.getParameter("to");
        String cc = request.getParameter("cc");
        String bcc = request.getParameter("bcc");
        String subject = request.getParameter("subject");
        String content = request.getParameter("content");

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

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.socketFactory.port", "465");
        props.put("mail.smtp.socketFactory.class",
                "javax.net.ssl.SSLSocketFactory");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.port", "465");

        Session session = Session.getDefaultInstance(props,
                new javax.mail.Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(username, password);
                    }
                });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username));
            message.setRecipients(Message.RecipientType.TO,
                    InternetAddress.parse(to));
            message.setRecipients(Message.RecipientType.CC,
                    InternetAddress.parse(cc));
            message.setRecipients(Message.RecipientType.BCC,
                    InternetAddress.parse(bcc));
            message.setSubject(subject);

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
            String filePaths = "";
            for (Part filePart : parts) {
                ApplicationPart appFilePart = (ApplicationPart) filePart;
                String fileName = appFilePart.getSubmittedFileName();
                if (fileName != null) {
                    String directoryName = System.getProperty("user.dir") + "/documents/attachments/" + user.getAccount().getUsername() + "/send";
                    //String directoryName = "C:/Users/NYuSheng/Desktop/attachments/" + user.getAccount().getUsername() + "/send";

                    File directory = new File(directoryName);
                    if (!directory.exists()) {
                        System.out.println(directoryName);
                        directory.mkdirs();
                    }

                    String path = directoryName + "/" + fileName;

                    out = new FileOutputStream(new File(path));
                    filecontent = appFilePart.getInputStream();

                    int read = 0;
                    final byte[] bytes = new byte[1024];

                    while ((read = filecontent.read(bytes)) != -1) {
                        out.write(bytes, 0, read);
                    }

                    fileNames.add(path);
                    filePaths += path + "|";
                }
            }

            long start = System.currentTimeMillis();
            // Part two is attachment
            for (String fileName : fileNames) {
                messageBodyPart = new MimeBodyPart();
                DataSource source = new FileDataSource(fileName);
                messageBodyPart.setDataHandler(new DataHandler(source));
                messageBodyPart.setFileName(fileName.substring(fileName.lastIndexOf("/")));
                multipart.addBodyPart(messageBodyPart);
            }
            System.out.println("Time taken to attach : " + (System.currentTimeMillis() - start));
            if (out != null) {
                out.close();
            }
            if (filecontent != null) {
                filecontent.close();
            }
            if (!filePaths.isEmpty()) {
                jsonOutput.addProperty("files", filePaths);
            }

            // Send the complete message parts
            start = System.currentTimeMillis();
            message.setContent(multipart);
            System.out.println("Time taken to set : " + (System.currentTimeMillis() - start));

            start = System.currentTimeMillis();
            Transport.send(message);
            System.out.println("Time taken to send : " + (System.currentTimeMillis() - start));

            jsonOutput.addProperty("status", "SUCCESS");
            jsonOutput.addProperty("message", "Message sent!");
        } catch (Exception e) {
            e.printStackTrace();
            jsonOutput.addProperty("status", "ERROR");
            jsonOutput.addProperty("message", e.getMessage());
        }
        
        //response.sendRedirect("NewMessage.jsp");
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
