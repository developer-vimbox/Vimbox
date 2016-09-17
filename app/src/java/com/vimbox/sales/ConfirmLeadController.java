package com.vimbox.sales;

import com.google.gson.JsonObject;
import com.vimbox.database.JobDAO;
import com.vimbox.database.LeadDAO;
import com.vimbox.util.Converter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import org.apache.catalina.core.ApplicationPart;

@WebServlet(name = "ConfirmLeadController", urlPatterns = {"/ConfirmLeadController"})
@MultipartConfig
public class ConfirmLeadController extends HttpServlet {

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

        String errorMsg = "";

        String nric = request.getParameter("cfmuId");
        int leadId = Integer.parseInt(request.getParameter("cfmlId"));

        boolean checkBooked = JobDAO.checkBookedJobsByLeadId(leadId);

        if (checkBooked) {
            String amount = request.getParameter("amountCollected");
            double collectedAmount = 0;
            if (!amount.isEmpty()) {
                try {
                    collectedAmount = Double.parseDouble(amount);
                } catch (NumberFormatException e) {
                    errorMsg += "Please enter a valid amount<br>";
                }
            }

            ApplicationPart filePart = (ApplicationPart) request.getPart("file");
            String fileName = "";
            String path = "";

            if (filePart != null) {
                boolean fileCheck = fileValidation(filePart);
                if (!fileCheck) {
                    errorMsg += "Please upload a valid image (png, jpg or bmp)<br>";
                } else {
                    String fName = filePart.getSubmittedFileName();
                    String fileExt = fName.substring(fName.lastIndexOf("."));
                    fileName = leadId + "-email" + fileExt;
                    path = System.getProperty("user.dir") + "/documents/emails/" + fileName;
                }
            }

            if (errorMsg.isEmpty()) {
                OutputStream out = null;
                InputStream filecontent = null;
                try {
                    LeadDAO.confirmLead(nric, collectedAmount, fileName, leadId);
                    if (filePart != null) {
                        out = new FileOutputStream(new File(path));
                        filecontent = filePart.getInputStream();

                        int read = 0;
                        final byte[] bytes = new byte[1024];

                        while ((read = filecontent.read(bytes)) != -1) {
                            out.write(bytes, 0, read);
                        }
                    }
                    jsonOutput.addProperty("status", "SUCCESS");
                    jsonOutput.addProperty("message", "Lead confirmed!");
                } catch (FileNotFoundException fne) {
                    System.out.println("File errorrr: " + fne);
                    errorMsg += "Error reading uploaded image<br>";
                } finally {
                    if (out != null) {
                        out.close();
                    }
                    if (filecontent != null) {
                        filecontent.close();
                    }
                }
            }
        } else {
            errorMsg += "There is no booked/confirmed DOM for this lead.<br>Please select DOM to confirm.";
        }

        if (!errorMsg.isEmpty()) {
            jsonOutput.addProperty("status", "ERROR");
            jsonOutput.addProperty("message", errorMsg);
        }

        jsonOut.println(jsonOutput);
    }

    private boolean fileValidation(ApplicationPart filePart) {
        String fName = filePart.getSubmittedFileName();
        if (fName != null && !fName.isEmpty()) {
            String fileExt = fName.substring(fName.lastIndexOf("."));
            // Checks file for file extension //
            if (!(fileExt.matches(".png|.jpg|.bmp"))) {
                return false;
            } else {
                return true;
            }
        } else {
            return false;
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
