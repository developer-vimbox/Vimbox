package com.vimbox.admin;

import com.google.gson.JsonObject;
import com.vimbox.database.LeadPopulationDAO;
import com.vimbox.database.UserDAO;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.catalina.core.ApplicationPart;

@WebServlet(name = "EditItemController", urlPatterns = {"/EditItemController"})
@MultipartConfig
public class EditItemController extends HttpServlet {

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
        String itemValues = request.getParameter("itemValues");

        String itemName = request.getParameter("itemName").trim();
        if (itemName.isEmpty()) {
            errorMsg += "Please enter an item name<br>";
        }

        String itemUnits = request.getParameter("itemUnits").trim();
        if (!itemUnits.isEmpty()) {
            try {
                double units = Double.parseDouble(itemUnits);
            } catch (NumberFormatException e) {
                errorMsg += "Please enter a valid item unit<br>";
            }
        }

        String itemDescription = request.getParameter("itemDescription").trim();
        String itemDimensions = request.getParameter("itemDimensions").trim();

        ApplicationPart filePart = (ApplicationPart) request.getPart("itemImg");
        String fileName = "";
        String path = "";

        if (filePart != null) {
            String fName = filePart.getSubmittedFileName();
            if (fName != null) {
                boolean fileCheck = fileValidation(filePart);
                if (!fileCheck) {
                    errorMsg += "Please upload a valid file (png, jpg, bmp)<br>";
                } else {
                    String fileExt = fName.substring(fName.lastIndexOf("."));
                    String imgName = (itemName + itemDescription).replaceAll(" ", "");
                    fileName = "/images/items/" + imgName + fileExt;
                    String user_path = System.getProperty("user.dir");
                    path = user_path.substring(0, user_path.lastIndexOf("/")) + "/app-root/runtime/dependencies/jbossews/webapps" + fileName;
                }
            }
        }
        if (errorMsg.isEmpty()) {
            OutputStream outpt = null;
            InputStream filecontent = null;
            try {
                LeadPopulationDAO.editItem(itemValues, itemName, itemDescription, itemDimensions, itemUnits, fileName);

                if (!path.isEmpty()) {
                    outpt = new FileOutputStream(new File(path),false);
                    filecontent = filePart.getInputStream();

                    int read = 0;
                    final byte[] bytes = new byte[1024];

                    while ((read = filecontent.read(bytes)) != -1) {
                        outpt.write(bytes, 0, read);
                    }
                }

                jsonOutput.addProperty("status", "SUCCESS");
                jsonOutput.addProperty("message", "Item edited!");
            } catch (FileNotFoundException fne) {
                errorMsg += "Error reading uploaded image<br>";
            } finally {
                if (outpt != null) {
                    outpt.close();
                }
                if (filecontent != null) {
                    filecontent.close();
                }
            }
        }
        if (!errorMsg.isEmpty()) {
            jsonOutput.addProperty("status", "ERROR");
            jsonOutput.addProperty("message", errorMsg);
        }
        
        jsonOut.println(jsonOutput);
    }

    private boolean fileValidation(ApplicationPart filePart) {
        String fName = filePart.getSubmittedFileName();
        if (fName != null) {
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
