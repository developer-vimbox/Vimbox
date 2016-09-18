package com.vimbox.sales;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Font;
import com.itextpdf.text.Image;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPCellEvent;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfPTableEvent;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.draw.DottedLineSeparator;
import com.itextpdf.text.pdf.draw.LineSeparator;
import com.vimbox.database.LeadDAO;
import com.vimbox.database.LeadPopulationDAO;
import com.vimbox.util.Converter;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.joda.time.DateTime;

@WebServlet(name = "InvoicePDFGenerator", urlPatterns = {"/invoices/*"})
public class InvoicePDFGenerator extends HttpServlet {
    
    private BaseColor tHeaderColor = new BaseColor(202, 225, 255);
    private BaseColor invoiceColor = new BaseColor(72, 136, 216);
    private BaseColor lineColor = new BaseColor(211, 211, 211);

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
        String leadId = request.getParameter("leadId");
        Lead lead = LeadDAO.getLeadById(Integer.parseInt(leadId));
        ArrayList<LeadDiv> leadDivs = lead.getSalesDivs();
        
        try {
            // Document Settings //
            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            Font invoiceFont = new Font(Font.FontFamily.TIMES_ROMAN, 20, Font.NORMAL, invoiceColor);
            Font boldFont = new Font(Font.FontFamily.TIMES_ROMAN, 13, Font.BOLD);
            Font normalFont = new Font(Font.FontFamily.TIMES_ROMAN, 13, Font.NORMAL);
            Font tBoldFont = new Font(Font.FontFamily.TIMES_ROMAN, 11, Font.BOLD);
            Font tNormalFont = new Font(Font.FontFamily.TIMES_ROMAN, 11, Font.NORMAL);
            Font priceFont = new Font(Font.FontFamily.TIMES_ROMAN, 15, Font.BOLD);
            Font totalFont = new Font(Font.FontFamily.TIMES_ROMAN, 18, Font.BOLD);
            DecimalFormat df = new DecimalFormat("#,###.00");
            document.open();
            //-------------------//

            // Company details and logo //
            PdfPTable table = new PdfPTable(2);
            // the cell object
            PdfPCell cell;
            cell = new PdfPCell(new Phrase("Vimbox Services Pte Ltd", boldFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            
            String path = this.getClass().getClassLoader().getResource("").getPath();
            int occurence = 0;
            int slash = 0;
            for (int i = path.length() - 1; i >= 0; i--) {
                char ch = path.charAt(i);
                if (ch == '/') {
                    occurence += 1;
                }
                //occurence == 9 //
                if (occurence == 3) {
                    slash = i;
                    break;
                }
            }
            //webapps/images/VimboxIcon.png// 
            path = path.substring(0, slash + 1) + "images/VimboxIcon.png";
            path = path.replaceAll("%20", " ");
            Image img = Image.getInstance(path);
            img.scaleAbsolute(100f, 100f);
            cell = new PdfPCell(img);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            cell.setRowspan(2);
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            
            cell = new PdfPCell(new Phrase("18 Boon Lay Way\n#08-115\nTradehub 21\nSingapore\nSingapore 609966\n63394439\nadmin@vimboxmovers.com.sg\nwww.vimboxmovers.sg", normalFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidthPercentage(100);
            table.setSpacingAfter(10);
            document.add(table);
            //--------------------------//

            // INVOICE //
            table = new PdfPTable(1);
            cell = new PdfPCell(new Phrase("INVOICE", invoiceFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidthPercentage(100);
            table.setSpacingAfter(10);
            document.add(table);
            //---------//

            // Customer address and quotation details //
            table = new PdfPTable(2);
            Phrase phrase = null;
            
            cell = new PdfPCell(new Phrase("INVOICE TO", boldFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            
            phrase = new Phrase();
            phrase.add(new Phrase("INVOICE NO.  ", boldFont));
            phrase.add(new Phrase(leadId, normalFont));
            cell = new PdfPCell(phrase);
            cell.setBorder(Rectangle.NO_BORDER);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            table.addCell(cell);
            
            String name = "";
            if (lead.getCustomer() != null) {
                name = lead.getCustomer().toString();
            }
            cell = new PdfPCell(new Phrase(name, normalFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            
            phrase = new Phrase();
            phrase.add(new Phrase("DATE  ", boldFont));
            phrase.add(new Phrase(Converter.convertDatePdf(new DateTime()), normalFont));
            cell = new PdfPCell(phrase);
            cell.setBorder(Rectangle.NO_BORDER);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            table.addCell(cell);
            
            ArrayList<String[]> addressFroms = lead.getAddressFrom();
            String[] addressFrom = null;
            if (addressFroms.size() > 0) {
                addressFrom = addressFroms.get(0)[0].split("_");
            }
            String address = "";
            if (addressFrom != null) {
                address += addressFrom[0] + "\nSingapore " + addressFrom[3];
            }
            cell = new PdfPCell(new Phrase(address, normalFont));
            cell.setRowspan(2);
            cell.setPaddingBottom(10);
            cell.setBorder(Rectangle.BOTTOM);
            table.addCell(cell);
            
            phrase = new Phrase();
            phrase.add(new Phrase("DUE DATE  ", boldFont));
            phrase.add(new Phrase(Converter.convertDatePdf(new DateTime()), normalFont));
            cell = new PdfPCell(phrase);
            cell.setBorder(Rectangle.NO_BORDER);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            table.addCell(cell);
            
            phrase = new Phrase();
            phrase.add(new Phrase("TERMS  ", boldFont));
            phrase.add(new Phrase("Due on receipt", normalFont));
            cell = new PdfPCell(phrase);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            cell.setPaddingBottom(10);
            cell.setBorder(Rectangle.BOTTOM);
            table.addCell(cell);
            
            table.setWidthPercentage(100);
            table.setSpacingAfter(30);
            document.add(table);
            //----------------------------------------//

            // Services and breakdown //
            float[] contentColWidths = new float[]{40f, 40f, 10f, 10f};
            LineSeparator line = new LineSeparator();
            line.setOffset(-7);
            
            table = new PdfPTable(4);
            String[] tHeaders = {"Activity", "Remarks", "Qty", "Amount"};
            for (int i = 0; i < tHeaders.length; i++) {
                String tHeader = tHeaders[i];
                cell = new PdfPCell(new Phrase(tHeader, normalFont));
                cell.setBorder(Rectangle.NO_BORDER);
                cell.setBackgroundColor(tHeaderColor);
                if (i == tHeaders.length - 1) {
                    cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
                }
                table.addCell(cell);
            }
            table.setWidths(contentColWidths);
            table.setWidthPercentage(100);
            document.add(table);

            // Packing Materials //
            //ArrayList<Item> materials = leadDiv.getMaterials();
            String[] vimboxMaterialNames = request.getParameterValues("vimboxMaterialName");
            String[] vimboxItemNames = request.getParameterValues("vimboxItemName");
            if (vimboxMaterialNames != null || vimboxItemNames != null) {
                table = new PdfPTable(4);
                // Title //
                cell = new PdfPCell(new Phrase("Packing Materials", tBoldFont));
                cell.setColspan(3);
                cell.setBorder(Rectangle.NO_BORDER);
                table.addCell(cell);

                // Charges //
                double mCharge = Double.parseDouble(request.getParameter("materialCharge"));
                String materialCharge = df.format(mCharge);
                cell = new PdfPCell(new Phrase(materialCharge, tNormalFont));
                cell.setBorder(Rectangle.NO_BORDER);
                cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
                table.addCell(cell);

                // Title Description //
                cell = new PdfPCell(new Phrase("Provision of Packing Materials", tNormalFont));
                cell.setColspan(4);
                cell.setBorder(Rectangle.NO_BORDER);
                table.addCell(cell);
                
                if (vimboxItemNames != null) {
                    String[] vimboxItemRemarks = request.getParameterValues("vimboxItemRemark");
                    String[] vimboxItemQtys = request.getParameterValues("vimboxItemQty");
                    for (int i = 0; i < vimboxItemNames.length; i++) {
                        String itemName = vimboxItemNames[i];
                        cell = new PdfPCell(new Phrase("- " + itemName, tNormalFont));
                        cell.setBorder(Rectangle.NO_BORDER);
                        table.addCell(cell);
                        String itemRemark = vimboxItemRemarks[i];
                        cell = new PdfPCell(new Phrase(itemRemark, tNormalFont));
                        cell.setBorder(Rectangle.NO_BORDER);
                        table.addCell(cell);
                        String itemQty = vimboxItemQtys[i];
                        cell = new PdfPCell(new Phrase(itemQty, tNormalFont));
                        cell.setColspan(2);
                        cell.setBorder(Rectangle.NO_BORDER);
                        table.addCell(cell);
                    }
                }
                
                if (vimboxMaterialNames != null) {
                    String[] vimboxMaterialQtys = request.getParameterValues("vimboxMaterialQty");
                    for (int i = 0; i < vimboxMaterialNames.length; i++) {
                        String materialName = vimboxMaterialNames[i];
                        cell = new PdfPCell(new Phrase("- " + materialName, tNormalFont));
                        cell.setColspan(2);
                        cell.setBorder(Rectangle.NO_BORDER);
                        table.addCell(cell);
                        String materialQty = vimboxMaterialQtys[i];
                        cell = new PdfPCell(new Phrase(materialQty, tNormalFont));
                        cell.setColspan(2);
                        cell.setBorder(Rectangle.NO_BORDER);
                        table.addCell(cell);
                    }
                }
                
                table.setSpacingBefore(10);
                table.setWidths(contentColWidths);
                table.setWidthPercentage(100);
                document.add(table);
                document.add(line);
            }

            // Services //
            ArrayList<String[]> services = LeadDAO.getServicesByLeadId(leadId);
            table = new PdfPTable(4);
            double totalCharges = 0;
            if (services != null) {
                for (String[] s : services) {
                    String serviceName = s[0];
                    String serviceCharge = s[1];
                    String serviceMp = s[2];
                    String serviceRm = s[3];
                    String[] tempDescName = serviceName.split(" ");
                    String svcDescription = LeadPopulationDAO.getSelectedServiceDesc(tempDescName[0], tempDescName[1]);
                    String qty = "";
                    // Title //

                    cell = new PdfPCell();
                    cell.addElement(new Phrase(serviceName + " Service", tBoldFont));
                    cell.addElement(new Phrase(svcDescription, tNormalFont));
                    cell.setBorder(Rectangle.NO_BORDER);
                    cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
                    table.addCell(cell);
                    //Remarks
                    cell = new PdfPCell(new Phrase(serviceRm, tNormalFont));
                    cell.setBorder(Rectangle.NO_BORDER);
                    cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
                    table.addCell(cell);

                    //Qty
                    cell = new PdfPCell(new Phrase(qty, tNormalFont));
                    cell.setBorder(Rectangle.NO_BORDER);
                    cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
                    table.addCell(cell);

                    //charges
                    if (serviceCharge != null) {
                        double sCharge = Double.parseDouble(serviceCharge);
                        totalCharges += sCharge;
                        String svcCharge = df.format(sCharge);
                        cell = new PdfPCell(new Phrase(svcCharge, tNormalFont));
                        cell.setBorder(Rectangle.NO_BORDER);
                        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
                        table.addCell(cell);
                    }
                }
                
                table.setSpacingBefore(10);
                table.setWidths(contentColWidths);
                table.setWidthPercentage(100);
                document.add(table);
                LineSeparator line2 = new LineSeparator();
                line2.setOffset(-7);
                line2.setLineColor(lineColor);
                document.add(line2);
            }

//            
            //Calculate total
            table = new PdfPTable(4);
            table.setSpacingBefore(10);
            table.setWidthPercentage(100);
            table.setSpacingAfter(10);
            cell = new PdfPCell(new Phrase("BALANCE DUE", tNormalFont));
            cell.setColspan(3);
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            cell = new PdfPCell(new Phrase("$" + df.format(totalCharges), totalFont));
            cell.setBorder(Rectangle.NO_BORDER);
            cell.setColspan(1);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            
            table.addCell(cell);
            document.add(table);
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
