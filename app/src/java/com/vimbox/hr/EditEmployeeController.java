package com.vimbox.hr;

import com.google.gson.JsonObject;
import com.vimbox.database.UserDAO;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.catalina.core.ApplicationPart;

@WebServlet(name = "EditEmployeeController", urlPatterns = {"/EditEmployeeController"})
@MultipartConfig
public class EditEmployeeController extends HttpServlet {

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
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");

        // Validating fields //
        String errorMsg = "";

        String employeeType = request.getParameter("employeeType");
        String user_first_name = request.getParameter("user_first_name");
        String user_last_name = request.getParameter("user_last_name");
        if (user_first_name.isEmpty()) {
            errorMsg += "Please enter employee's first name<br>";
        }
        if (user_last_name.isEmpty()) {
            errorMsg += "Please enter employee's last name<br>";
        }

        String user_nric = request.getParameter("user_nric");

        String user_dj = request.getParameter("user_dj");
        Date dj = null;
        try {
            dj = format.parse(user_dj);
        } catch (Exception e) {
            errorMsg += "Please enter a valid employee's date joined<br>";
        }

        String user_madd = request.getParameter("user_madd");
        if (user_madd.isEmpty()) {
            errorMsg += "Please enter employees's mailing address<br>";
        }

        String user_radd = request.getParameter("user_radd");

        boolean phoneEmpty = false;
        String user_phone = request.getParameter("user_phone");
        if (user_phone.isEmpty()) {
            phoneEmpty = true;
            user_phone = "0";
        } else {
            if (user_phone.length() < 8) {
                errorMsg += "Please enter a valid phone number<br>";
            }
        }

        String user_fax = request.getParameter("user_fax");
        if (user_fax.isEmpty()) {
            user_fax = "0";
        } else {
            if (user_fax.length() < 8) {
                errorMsg += "Please enter a valid fax number<br>";
            }
        }

        boolean homeEmpty = false;
        String user_home = request.getParameter("user_home");
        if (user_home.isEmpty()) {
            homeEmpty = true;
            user_home = "0";
        } else {
            if (user_home.length() < 8) {
                errorMsg += "Please enter a valid home number<br>";
            }
        }

        if (phoneEmpty && homeEmpty) {
            errorMsg += "Please enter either a phone or home number<br>";
        }

        ApplicationPart filePart = (ApplicationPart) request.getPart("driverLicense");
        String fileName = "";
        String path = "";

        if (filePart != null) {
            boolean fileCheck = fileValidation(filePart);
            try {
                String fName = filePart.getSubmittedFileName();
                String fileExt = fName.substring(fName.lastIndexOf("."));
                if (!fileCheck) {
                    errorMsg += "Please upload a valid image (png, jpg, bmp or pdf)<br>";
                } else {
                    fileName = user_nric + "-driver-license" + fileExt;
                    path = System.getProperty("user.dir") + "/documents/licenses/" + fileName;
                }
            } catch (Exception e) {
                fileName = request.getParameter("existing_driverLicense");
            }
        }

        String user_designation = request.getParameter("user_designation");
        String user_department = "";
        String fullTime = request.getParameter("fulltime_user_department");
        String partTime = request.getParameter("parttime_user_department");
        if (user_designation == null) {
            errorMsg += "Please enter employee's department<br>";
        } else {
            if (fullTime == null) {
                user_department = partTime;
            } else {
                user_department = fullTime;
            }
        }

        String user_salary = request.getParameter("user_salary");
        if (user_salary.isEmpty()) {
            errorMsg += "Please enter the employee's basic salary<br>";
        }

        String emergency_name = request.getParameter("emergency_name");
        if (emergency_name.isEmpty()) {
            errorMsg += "Please enter an emergency contact name<br>";
        }

        String emergency_relationship = request.getParameter("emergency_relationship");
        if (emergency_relationship.isEmpty()) {
            errorMsg += "Please enter the relationship of the employee and emergency contact<br>";
        }

        boolean eContactEmpty = false;
        String emergency_contact = request.getParameter("emergency_contact");
        if (emergency_contact.isEmpty()) {
            eContactEmpty = true;
            emergency_contact = "0";
        } else {
            if (emergency_contact.length() < 8) {
                errorMsg += "Please enter a valid emergency contact number<br>";
            }
        }

        boolean eOfficeEmpty = false;
        String emergency_office = request.getParameter("emergency_office");
        if (emergency_office.isEmpty()) {
            eOfficeEmpty = true;
            emergency_office = "0";
        } else {
            if (emergency_office.length() < 8) {
                errorMsg += "Please enter a valid emergency office number<br>";
            }
        }

        if (eContactEmpty && eOfficeEmpty) {
            errorMsg += "Please enter either an emergency office or contact number<br>";
        }

        String user_payment_mode = request.getParameter("user_payment");

        String user_bank_name = request.getParameter("user_bank_name");
        if (user_bank_name.isEmpty()) {
            errorMsg += "Please enter employee's bank name<br>";
        }

        String user_account_name = request.getParameter("user_account_name");
        if (user_account_name.isEmpty()) {
            errorMsg += "Please enter employee's account name<br>";
        }

        String user_account_no = request.getParameter("user_account_no");
        if (user_account_no.isEmpty()) {
            errorMsg += "Please enter employee's account number<br>";
        }

       
        if (errorMsg.isEmpty()) {
            OutputStream outpt = null;
            InputStream filecontent = null;
            try {
                if (!path.isEmpty()) {
                    outpt = new FileOutputStream(new File(path), false);
                    filecontent = filePart.getInputStream();

                    int read = 0;
                    final byte[] bytes = new byte[1024];

                    while ((read = filecontent.read(bytes)) != -1) {
                        outpt.write(bytes, 0, read);
                    }
                }
                UserDAO.deleteUser(user_nric);
                UserDAO.createUser(user_nric, user_first_name, user_last_name, dj, user_madd, user_radd, fileName, user_department, user_designation, Integer.parseInt(user_salary), employeeType);
                UserDAO.createUserContact(user_nric, Integer.parseInt(user_phone), Integer.parseInt(user_fax), Integer.parseInt(user_home));
                UserDAO.createUserEmergency(user_nric, emergency_name, emergency_relationship, Integer.parseInt(emergency_contact), Integer.parseInt(emergency_office));
                UserDAO.createUserBank(user_nric, user_payment_mode, user_bank_name, user_account_name, user_account_no);
                if (employeeType.equals("Full")) {
                    UserDAO.createUserLeave(user_nric, dj, Double.parseDouble(request.getParameter("user_leave")), Integer.parseInt(request.getParameter("user_mc")), Double.parseDouble(request.getParameter("user_used_leave")), Integer.parseInt(request.getParameter("user_used_mc")));
                }
                jsonOutput.addProperty("status", "SUCCESS");
                jsonOutput.addProperty("message", "Employee updated!");
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
        if (fName != null && !fName.isEmpty()) {
            String fileExt = fName.substring(fName.lastIndexOf("."));
            // Checks file for file extension //
            if (!(fileExt.matches(".png|.jpg|.bmp|.pdf"))) {
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
