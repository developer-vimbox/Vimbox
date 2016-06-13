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
import com.vimbox.database.LeadPopulationDAO;
import com.vimbox.util.Converter;
import java.io.IOException;
import java.text.DecimalFormat;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.joda.time.DateTime;

@WebServlet(name = "LeadPDFGenerator", urlPatterns = {"/new_lead_pdf.pdf"})
public class LeadPDFGenerator extends HttpServlet {

    private BaseColor tHeaderColor = new BaseColor(202, 225, 255);

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
            Font boldFont = new Font(Font.FontFamily.TIMES_ROMAN, 13, Font.BOLD);
            Font normalFont = new Font(Font.FontFamily.TIMES_ROMAN, 13, Font.NORMAL);
            Font tBoldFont = new Font(Font.FontFamily.TIMES_ROMAN, 11, Font.BOLD);
            Font tNormalFont = new Font(Font.FontFamily.TIMES_ROMAN, 11, Font.NORMAL);
            Font priceFont = new Font(Font.FontFamily.TIMES_ROMAN, 15, Font.BOLD);
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
                if (occurence == 3) {
                    slash = i;
                    break;
                }
            }
            path = path.substring(0, slash + 1) + "Images/VimboxIcon.png";
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
            table.setSpacingAfter(20);
            document.add(table);
            //--------------------------//

            // Customer address and quotation details //
            table = new PdfPTable(2);

            cell = new PdfPCell(new Phrase("QUOTATION", boldFont));
            cell.setBorder(Rectangle.NO_BORDER);
            cell.setColspan(2);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("ADDRESS", normalFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("QUOTATION NO. : " + request.getParameter("leadId"), normalFont));
            cell.setBorder(Rectangle.NO_BORDER);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            table.addCell(cell);

            String[] addressFrom = request.getParameterValues("addressfrom");
            String name = request.getParameter("salutation") + " " + request.getParameter("name");
            String address = name + "\n";
            if (addressFrom != null) {
                address += addressFrom[0] + "\nSingapore " + addressFrom[3];
            }
            cell = new PdfPCell(new Phrase(address, normalFont));
            cell.setPaddingBottom(10);
            cell.setBorder(Rectangle.BOTTOM);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("DATE : " + Converter.convertDatePdf(new DateTime()), normalFont));
            cell.setBorder(Rectangle.BOTTOM);
            cell.setPaddingBottom(10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
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
            String[] serviceNames = request.getParameterValues("serviceName");
            if (serviceNames != null) {
                
                String[] serviceCharges = request.getParameterValues("serviceCharge");
                for (int i = 0; i < serviceNames.length; i++) {
                    table = new PdfPTable(4);
                    String[] svcName = serviceNames[i].split("_");
                    String priSvc = svcName[0];
                    String secSvc = svcName[1];
                    String svcDescription = LeadPopulationDAO.getServiceDescription(priSvc, secSvc);

                    // Title //
                    cell = new PdfPCell(new Phrase(priSvc + " Service", tBoldFont));
                    cell.setColspan(3);
                    cell.setBorder(Rectangle.NO_BORDER);
                    table.addCell(cell);

                    // Charges //
                    double sCharge = Double.parseDouble(serviceCharges[i]);
                    String svcCharge = df.format(sCharge);
                    cell = new PdfPCell(new Phrase(svcCharge, tNormalFont));
                    cell.setBorder(Rectangle.NO_BORDER);
                    cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
                    table.addCell(cell);

                    // Title Description //
                    cell = new PdfPCell(new Phrase(svcDescription, tNormalFont));
                    cell.setColspan(4);
                    cell.setBorder(Rectangle.NO_BORDER);
                    table.addCell(cell);

                    // Special case : Moving (Display all the items, remarks and qtys //
                    if (priSvc.equals("Moving")) {
                        String[] custItemNames = request.getParameterValues("customerItemName");
                        if (custItemNames != null) {
                            String[] custItemRemarks = request.getParameterValues("customerItemRemark");
                            String[] custItemQtys = request.getParameterValues("customerItemQty");
                            for (int j = 0; j < custItemNames.length; j++) {
                                String itemName = custItemNames[j];
                                cell = new PdfPCell(new Phrase("- " + itemName, tNormalFont));
                                cell.setBorder(Rectangle.NO_BORDER);
                                table.addCell(cell);
                                String itemRemark = custItemRemarks[j];
                                cell = new PdfPCell(new Phrase(itemRemark, tNormalFont));
                                cell.setBorder(Rectangle.NO_BORDER);
                                table.addCell(cell);
                                String itemQty = custItemQtys[j];
                                cell = new PdfPCell(new Phrase(itemQty, tNormalFont));
                                cell.setColspan(2);
                                cell.setBorder(Rectangle.NO_BORDER);
                                table.addCell(cell);
                            }
                        }
                    }
                    table.setWidths(contentColWidths);
                    table.setWidthPercentage(100);
                    table.setSpacingBefore(10);
                    document.add(table);
                    document.add(line);
                }
            }
            //------------------------//

            
            
            
            table = new PdfPTable(2);
            cell = new PdfPCell(new Phrase("TOTAL : ", tNormalFont));
            cell.setBorder(Rectangle.NO_BORDER);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            cell.setVerticalAlignment(PdfPCell.ALIGN_BOTTOM);
            table.addCell(cell);
            
            String tPrice = request.getParameter("totalPrice");
            double totalPrice = Double.parseDouble(tPrice);
            cell = new PdfPCell(new Phrase("S$" + df.format(totalPrice), priceFont));
            cell.setBorder(Rectangle.NO_BORDER);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            table.addCell(cell);
            
            table.setWidthPercentage(100);
            table.setSpacingBefore(30);
            table.setWidths(new float[]{80,20});
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
