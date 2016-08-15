package com.vimbox.hr;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Image;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.vimbox.database.PayslipDAO;
import com.vimbox.user.User;
import com.vimbox.util.Converter;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author NYuSheng
 */
@WebServlet(name = "PayslipPDFGenerator", urlPatterns = {"/payslip_pdf.pdf"})
public class PayslipPDFGenerator extends HttpServlet {
    private BaseColor tHeaderColor = new BaseColor(0, 0, 0);
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
        String payslipId = request.getParameter("payslip_id");
        try {
            // Document Settings //
            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
    
            Font boldFont = new Font(Font.FontFamily.TIMES_ROMAN, 13, Font.BOLD);
            Font hBoldFont = new Font(Font.FontFamily.TIMES_ROMAN, 13, Font.BOLD, BaseColor.WHITE);
            Font normalFont = new Font(Font.FontFamily.TIMES_ROMAN, 13, Font.NORMAL);
            Font tBoldFont = new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.BOLD);
            Font tNormalFont = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.NORMAL);
            DecimalFormat df = new DecimalFormat("#,##0.00");
            document.open();
            
            // Company details and logo //
            PdfPTable table = new PdfPTable(2);
            // the cell object
            PdfPCell cell;
            float[] columnWidths = new float[] {5f, 30f};
            table.setWidths(columnWidths);
            
            // Logo //
            String path = this.getClass().getClassLoader().getResource("").getPath();
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
            path = path.substring(0, slash + 1) + "images/VimboxIcon.png";
            path = path.replaceAll("%20", " ");
            Image img = Image.getInstance(path);
            img.scaleAbsolute(80f, 80f);
            cell = new PdfPCell(img);
            cell.setRowspan(3);
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            
            // Company Details //
            cell = new PdfPCell(new Phrase("Vimbox Services Pte Ltd", boldFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("18 Boon Lay Way #08-115 Tradehub 21 S609966", normalFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            
            cell = new PdfPCell(new Phrase("PID: " + payslipId, normalFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidthPercentage(100);
            document.add(table);
            //--------------------------//
    
            // Getting Payslip //
            
            Payslip payslip = PayslipDAO.getPayslipById(Integer.parseInt(payslipId));
            User user = payslip.getUser();
            //-----------------//
            
            table = new PdfPTable(1);
            cell = new PdfPCell(new Phrase("PAYSLIP", boldFont));
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            
            cell = new PdfPCell(new Phrase(" ", boldFont));
            cell.setBackgroundColor(tHeaderColor);
            cell.setFixedHeight(5f);
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            
            table.setWidthPercentage(100);
            table.setSpacingAfter(20);
            document.add(table);
            
            // Attention, NRIC, Payslip Duration //
            table = new PdfPTable(2);
            columnWidths = new float[] {5f, 20f};
            table.setWidths(columnWidths);
            
            // Attention //
            cell = new PdfPCell(new Phrase("Attention To :", boldFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            
            cell = new PdfPCell(new Phrase(user.toString(), normalFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            
            // NRIC //
            cell = new PdfPCell(new Phrase("NRIC :", boldFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            
            cell = new PdfPCell(new Phrase(user.getNric(), normalFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            
            // Payslip Duration //
            cell = new PdfPCell(new Phrase("Payslip For :", boldFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            
            cell = new PdfPCell(new Phrase(Converter.convertDatePayslip(payslip.getStartDate()) + "  TO  " + Converter.convertDatePayslip(payslip.getEndDate()), normalFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            
            table.setWidthPercentage(100);
            table.setSpacingAfter(20);
            document.add(table);
            //-----------------------------------//
            
            // Payment Breakdown Table //
            table = new PdfPTable(2);
            columnWidths = new float[] {20f, 20f};
            table.setWidths(columnWidths);
            
            PdfPTable leftTable = new PdfPTable(3);
            columnWidths = new float[] {50f, 30f, 20f};
            leftTable.setWidths(columnWidths);
            
            // Header //
            cell = new PdfPCell(new Phrase("Item", hBoldFont));
            cell.setBackgroundColor(tHeaderColor);
            leftTable.addCell(cell);
            
            cell = new PdfPCell(new Phrase("Amount", hBoldFont));
            cell.setBackgroundColor(tHeaderColor);
            cell.setColspan(2);
            leftTable.addCell(cell);
            
            // Basic Pay //
            cell = new PdfPCell(new Phrase("Basic Pay", boldFont));
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setFixedHeight(34f);
            leftTable.addCell(cell);
            
            cell = new PdfPCell(new Phrase("S$" + df.format(payslip.getBasicPay()), normalFont));
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setFixedHeight(34f);
            leftTable.addCell(cell);
            
            cell = new PdfPCell(new Phrase("( A )", normalFont));
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER); 
            cell.setFixedHeight(34f);
            leftTable.addCell(cell);
            
            // Total Allowance //
            cell = new PdfPCell(new Phrase("Total Allowances", boldFont));
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setFixedHeight(34f);
            leftTable.addCell(cell);
            
            cell = new PdfPCell(new Phrase("S$" + df.format(payslip.getTotalAllowances()), normalFont));
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setFixedHeight(34f);
            leftTable.addCell(cell);
            
            cell = new PdfPCell(new Phrase("( B )", normalFont));
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setFixedHeight(34f);
            leftTable.addCell(cell);
            
            // Allowance Breakdown //
            cell = new PdfPCell(new Phrase("(Breakdown shown below)", normalFont));
            cell.setColspan(3);
            leftTable.addCell(cell);
            
            int counter = 0;
            HashMap<String, Double> allowanceBd = payslip.getAllowanceBreakdown();
            for (Map.Entry<String, Double> entry : allowanceBd.entrySet()) {
                cell = new PdfPCell(new Phrase(entry.getKey(), tNormalFont));
                leftTable.addCell(cell);
            
                cell = new PdfPCell(new Phrase("S$" + df.format(entry.getValue()), tNormalFont));
                cell.setColspan(2);
                leftTable.addCell(cell);
                
                counter++;
            }
            
            if(counter < 4){
                counter = 4 - counter;
                for(int i=0; i<counter; i++){
                    cell = new PdfPCell(new Phrase(" ", tNormalFont));
                    leftTable.addCell(cell);

                    cell = new PdfPCell(new Phrase(" ", tNormalFont));
                    cell.setColspan(2);
                    leftTable.addCell(cell);
                }
            }
            
            // Total Deductions //
            cell = new PdfPCell(new Phrase("Total Deductions", boldFont));
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setFixedHeight(34f);
            leftTable.addCell(cell);
            
            cell = new PdfPCell(new Phrase("S$" + df.format(payslip.getTotalDeductions()), normalFont));
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setFixedHeight(34f);
            leftTable.addCell(cell);
            
            cell = new PdfPCell(new Phrase("( C )", normalFont));
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setFixedHeight(34f);
            leftTable.addCell(cell);
            
            // Deduction Breakdown //
            cell = new PdfPCell(new Phrase("(Breakdown shown below)", normalFont));
            cell.setColspan(3);
            leftTable.addCell(cell);
            
            counter = 0;
            HashMap<String, Double> deductionBd = payslip.getDeductionBreakdown();
            for (Map.Entry<String, Double> entry : deductionBd.entrySet()) {
                cell = new PdfPCell(new Phrase(entry.getKey(), tNormalFont));
                leftTable.addCell(cell);
            
                cell = new PdfPCell(new Phrase("S$" + df.format(entry.getValue()), tNormalFont));
                cell.setColspan(2);
                leftTable.addCell(cell);
                
                counter++;
            }
            
            if(counter < 6){
                counter = 6 - counter;
                for(int i=0; i<counter; i++){
                    cell = new PdfPCell(new Phrase(" ", tNormalFont));
                    leftTable.addCell(cell);

                    cell = new PdfPCell(new Phrase(" ", tNormalFont));
                    cell.setColspan(2);
                    leftTable.addCell(cell);
                }
            }
            
            leftTable.setWidthPercentage(100);
            cell = new PdfPCell(leftTable);
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            
            PdfPTable rightTable = new PdfPTable(3);
            columnWidths = new float[] {50f, 30f, 20f};
            rightTable.setWidths(columnWidths);
            
            // Header //
            cell = new PdfPCell(new Phrase("Date Of Payment", hBoldFont));
            cell.setBackgroundColor(tHeaderColor);
            cell.setColspan(3);
            rightTable.addCell(cell);
            
            // Date of Payment //
            cell = new PdfPCell(new Phrase(Converter.convertDatePayslip(payslip.getPaymentDate()), normalFont));
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setColspan(3);
            rightTable.addCell(cell);
            
            // Mode of Payment //
            cell = new PdfPCell(new Phrase("Mode Of Payment", hBoldFont));
            cell.setBackgroundColor(tHeaderColor);
            cell.setColspan(3);
            rightTable.addCell(cell);
            
            cell = new PdfPCell(new Phrase(payslip.getPaymentMode(), normalFont));
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setColspan(3);
            rightTable.addCell(cell);
            
            // OverTime //
            cell = new PdfPCell(new Phrase("Overtime", hBoldFont));
            cell.setBackgroundColor(tHeaderColor);
            cell.setColspan(3);
            rightTable.addCell(cell);
            
            cell = new PdfPCell(new Phrase("Overtime Hours Worked", boldFont));
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setFixedHeight(34f);
            rightTable.addCell(cell);
            
            cell = new PdfPCell(new Phrase(payslip.getOvertimeHr() + "", normalFont));
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setFixedHeight(34f);
            rightTable.addCell(cell);
            
            cell = new PdfPCell(new Phrase(" ", normalFont));
            cell.setFixedHeight(34f);
            rightTable.addCell(cell);
            
            cell = new PdfPCell(new Phrase("Total Overtime Pay", boldFont));
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setFixedHeight(34f);
            rightTable.addCell(cell);
            
            cell = new PdfPCell(new Phrase("S$" + df.format(payslip.getOvertimePay()), normalFont));
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setFixedHeight(34f);
            rightTable.addCell(cell);
            
            cell = new PdfPCell(new Phrase("( D )", normalFont));
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setFixedHeight(34f);
            rightTable.addCell(cell);
            
            // Additional Payments //
            cell = new PdfPCell(new Phrase("Item", hBoldFont));
            cell.setBackgroundColor(tHeaderColor);
            rightTable.addCell(cell);
            
            cell = new PdfPCell(new Phrase("Amount", hBoldFont));
            cell.setBackgroundColor(tHeaderColor);
            cell.setColspan(2);
            rightTable.addCell(cell);
            
            cell = new PdfPCell(new Phrase("Other Additional Payments", boldFont));
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setFixedHeight(34f);
            rightTable.addCell(cell);
            
            cell = new PdfPCell(new Phrase("S$" + df.format(payslip.getAdditionalPayment()), normalFont));
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setFixedHeight(34f);
            rightTable.addCell(cell);
            
            cell = new PdfPCell(new Phrase("( E )", normalFont));
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setFixedHeight(34f);
            rightTable.addCell(cell);
            
            // Additional Breakdown //
            cell = new PdfPCell(new Phrase("(Breakdown shown below)", normalFont));
            cell.setColspan(3);
            rightTable.addCell(cell);
            
            counter = 0;
            HashMap<String, Double> additionalBd = payslip.getAddPaymentBreakdown();
            for (Map.Entry<String, Double> entry : additionalBd.entrySet()) {
                cell = new PdfPCell(new Phrase(entry.getKey(), tNormalFont));
                rightTable.addCell(cell);
            
                cell = new PdfPCell(new Phrase("S$" + df.format(entry.getValue()), tNormalFont));
                cell.setColspan(2);
                rightTable.addCell(cell);
                
                counter++;
            }
            
            if(counter < 3){
                counter = 3 - counter;
                for(int i=0; i<counter; i++){
                    cell = new PdfPCell(new Phrase(" ", tNormalFont));
                    rightTable.addCell(cell);

                    cell = new PdfPCell(new Phrase(" ", tNormalFont));
                    cell.setColspan(2);
                    rightTable.addCell(cell);
                }
            }
            
            // Net Pay //
            cell = new PdfPCell(new Phrase("Net Pay (A+B-C+D+E)", tBoldFont));
            rightTable.addCell(cell);

            cell = new PdfPCell(new Phrase("S$" + df.format(payslip.getBasicPay() + payslip.getTotalAllowances() - payslip.getTotalDeductions() + payslip.getOvertimePay() + payslip.getAdditionalPayment()), normalFont));
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setColspan(2);
            rightTable.addCell(cell);

            // Employer CPF //
            cell = new PdfPCell(new Phrase("Employer's CPF Contribution", boldFont));
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setFixedHeight(34f);
            rightTable.addCell(cell);

            cell = new PdfPCell(new Phrase("S$" + df.format(payslip.getBasicPay() * 0.17), normalFont));
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setColspan(2);
            cell.setFixedHeight(34f);
            rightTable.addCell(cell);
            
            cell = new PdfPCell(rightTable);
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            
            table.setWidthPercentage(100);
            table.setSpacingAfter(150);
            document.add(table);
            //-------------------------//
            
            PdfPTable lastTable = new PdfPTable(2);
            columnWidths = new float[] {50f, 50f};
            lastTable.setWidths(columnWidths);
            
            cell = new PdfPCell(new Phrase("PREPARED BY: _______________________", normalFont));
            cell.setBorder(Rectangle.NO_BORDER);
            lastTable.addCell(cell);
            
            cell = new PdfPCell(new Phrase("SIGNATURE: _______________________", normalFont));
            cell.setBorder(Rectangle.NO_BORDER);
            lastTable.addCell(cell);
            
            lastTable.setWidthPercentage(100);
            document.add(lastTable);
            
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
