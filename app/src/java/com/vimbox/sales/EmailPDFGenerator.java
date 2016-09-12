package com.vimbox.sales;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Image;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.vimbox.database.LeadDAO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "EmailPDFGenerator", urlPatterns = {"/emails/*"})
public class EmailPDFGenerator extends HttpServlet {

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
        response.setContentType("application/pdf");

        try {
            // Document Settings //
            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // Loading MC //
            PdfPTable table = new PdfPTable(1);
            table.setWidthPercentage(100);
            // the cell object
            PdfPCell cell;

            String fileName = LeadDAO.getLeadConfirmedEmail(Integer.parseInt(request.getParameter("leadId")));
            String path = System.getProperty("user.dir") + "/documents/emails/" + fileName;
            path = path.replaceAll("%20", " ");
            Image img = Image.getInstance(path);
            int indentation = 0;
            float scaler = ((document.getPageSize().getWidth() - document.leftMargin() - document.rightMargin() - indentation) / img.getWidth()) * 100;
            img.scalePercent(scaler);
            //img.scaleAbsolute(80f, 80f);
            cell = new PdfPCell(img);
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            document.add(table);
            //-----------------------------------//
            document.close();
        } catch (DocumentException de) {
            throw new IOException(de.getMessage());
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
