package com.vimbox.hr;

import com.google.gson.JsonObject;
import com.vimbox.database.UserDAO;
import com.vimbox.database.UserLeaveDAO;
import com.vimbox.database.UserPopulationDAO;
import com.vimbox.user.User;
import com.vimbox.util.Converter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

@WebServlet(name = "CreateLeaveController", urlPatterns = {"/CreateLeaveController"})
@MultipartConfig
public class CreateLeaveController extends HttpServlet {

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
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        JsonObject jsonOutput = new JsonObject();
        PrintWriter jsonOut = response.getWriter();

        String errorMsg = "";

        String leaveType = request.getParameter("leaveType");
        String leaveName = request.getParameter("leaveName");

        String nric = request.getParameter("nric");
        User user = null;
        int workingDays = -1;
        if (nric.isEmpty()) {
            errorMsg += "Please select an employee<br>";
        } else {
            user = UserDAO.getUserByNRIC(nric);
            workingDays = UserPopulationDAO.getUserWorkingDays(user.getDepartment(), user.getDesignation());
        }

        String sd = null;
        String ed = null;
        if (leaveName.equals("MC")) {
            sd = request.getParameter("start_date") + " 09:00:00";
            ed = request.getParameter("end_date") + " 09:00:00";
        } else {
            sd = request.getParameter("start_date") + " " + request.getParameter("start_hour") + ":" + request.getParameter("start_minute") + ":00";
            ed = request.getParameter("end_date") + " " + request.getParameter("end_hour") + ":" + request.getParameter("end_minute") + ":00";
        }
        DateTime start_date = null;
        try {
            start_date = dtf.parseDateTime(sd);
        } catch (Exception e) {
            errorMsg += "Please input a valid start date time<br>";
        }

        DateTime end_date = null;
        try {
            end_date = dtf.parseDateTime(ed);
        } catch (Exception e) {
            errorMsg += "Please input a valid end date time<br>";
        }

        HashMap<Date, Double> used = null;
        HashMap<Date, String> usedString = null;
        if (start_date != null && end_date != null) {
            if (start_date.isAfter(end_date)) {
                errorMsg += "Start date time must be earlier than end date time<br>";
            } else {
                try {
                    used = Converter.getLeaveHoursBetweenTwoDateTimes(start_date, end_date, workingDays);
                    usedString = Converter.getLeaveStringsBetweenTwoDateTimes(start_date, end_date, workingDays);
                } catch (Exception e) {
                    errorMsg += e.getMessage();
                }
            }
        }

        if (used != null) {
            double[] remaining = UserDAO.getUserRemainingLeaveMC(nric);
            if (leaveType.equals("Paid")) {
                double leftOver = 0.0;
                switch (leaveName) {
                    case "MC":
                        leftOver = remaining[1] - used.size();
                        break;
                    default:
                        leftOver = remaining[0];
                        for (Map.Entry<Date, Double> entry : used.entrySet()) {
                            leftOver -= entry.getValue();
                        }
                }
                if (leftOver < 0) {
                    errorMsg += "Requested paid leave/time-off/mc is more than employee's current amount<br>";
                }
            }
        }

        Part filePart = request.getPart("file");
        String fileName = "";
        String path = "";

        if (filePart != null) {
            fileName = getFileName(filePart);
            if (fileName == null) {
                errorMsg += "Please upload image proof for MC<br>";
            } else {
                //path = System.getProperty("user.dir") + "/MC" + File.separator + fileName;
                path = this.getClass().getClassLoader().getResource("").getPath();
                int occurence = 0;
                int slash = 0;
                for (int i = path.length() - 1; i >= 0; i--) {
                    char ch = path.charAt(i);
                    if (ch == '/') {
                        occurence += 1;
                    }
                    if (occurence == 3) {
                        slash = i;
                        break;
                    }
                }
                path = path.substring(0, slash + 1) + "images/MC";
                path = path.replaceAll("%20", " ");
                path = path + File.separator + fileName;
            }
        }

        if (errorMsg.isEmpty()) {
            OutputStream out = null;
            InputStream filecontent = null;
            try {
                UserLeaveDAO.createLeaveRecord(leaveType, leaveName, nric, used, usedString, "/images/MC/" + fileName);
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
                jsonOutput.addProperty("message", "LEAVE / MC ADDED!");
            } catch (SQLException se) {
                errorMsg += "Employee is on leave/MC on the stated days<br>";
            } catch (FileNotFoundException fne) {
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

        if (!errorMsg.isEmpty()) {
            jsonOutput.addProperty("status", "ERROR");
            jsonOutput.addProperty("message", errorMsg);
        }

        jsonOut.println(jsonOutput);
    }

    private String getFileName(final Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(
                        content.indexOf('=') + 1).trim().replace("\"", "");
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
