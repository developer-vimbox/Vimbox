package com.vimbox.sales;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Font;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.draw.LineSeparator;
import com.vimbox.customer.Customer;
import com.vimbox.database.LeadDAO;
import com.vimbox.database.LeadPopulationDAO;
import com.vimbox.database.OperationsDAO;
import com.vimbox.util.Converter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.joda.time.DateTime;

@WebServlet(name = "QuotationPDFGenerator", urlPatterns = {"/quotations/*"})
public class QuotationPDFGenerator extends HttpServlet {

    private BaseColor vHeaderColor = new BaseColor(202, 225, 255);
    private BaseColor cHeaderColor = new BaseColor(245, 188, 169);
    private BaseColor invoiceColor = new BaseColor(72, 136, 216);
    private BaseColor lineColor = new BaseColor(211, 211, 211);
    private BaseColor redColor = new BaseColor(255, 0, 0);
    private BaseColor linkColor = new BaseColor(51, 153, 255);

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
        String refNum = request.getParameter("refNum");
        Lead lead = LeadDAO.getLeadById(Integer.parseInt(leadId));
        ArrayList<LeadDiv> leadDivs = lead.getSalesDivs();
        Customer cust = lead.getCustomer();

        try {
            // Document Settings //
            Document document = new Document(PageSize.A4, 20, 20, 20, 20);
            PdfWriter.getInstance(document, response.getOutputStream());
            Font invoiceFont = new Font(Font.FontFamily.HELVETICA, 15, Font.NORMAL, invoiceColor);
            Font boldFont = new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD);
            Font underlineFont = new Font(Font.FontFamily.HELVETICA, 9, Font.UNDERLINE);
            Font linkFont = new Font(Font.FontFamily.HELVETICA, 9, Font.UNDERLINE, linkColor);
            Font normalFont = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL);
            Font redFont = new Font(Font.FontFamily.HELVETICA, 9, Font.NORMAL, redColor);
            Font tcFont = new Font(Font.FontFamily.HELVETICA, 8, Font.NORMAL);
            Font tcBoldFont = new Font(Font.FontFamily.HELVETICA, 8, Font.BOLD);
            Font tcUnderlineFont = new Font(Font.FontFamily.HELVETICA, 8, Font.UNDERLINE);
            DecimalFormat df = new DecimalFormat("#,###.00");
            document.open();
            //-------------------//

            // Company details and logo //
            PdfPTable table = new PdfPTable(2);
            Phrase phrase = null;
            // the cell object
            PdfPCell cell;
            float[] headerWidth = new float[]{51f, 49f};
            phrase = new Phrase();
            phrase.add(new Phrase("VIMBOX SERVICES PRIVATE LIMITED (201319626W)\n18 BOON LAY WAY #08-115\nTRADEHUB 21 SINGAPORE 609966\nTEL 63394439\n", normalFont));
            phrase.add(new Phrase("WWW.VIMBOXMOVERS.SG", linkFont));
            cell = new PdfPCell(phrase);
            cell.setBorder(Rectangle.BOTTOM);
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
            img.scaleAbsolute(70f, 70f);
            cell = new PdfPCell(img);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            cell.setRowspan(2);
            cell.setBorder(Rectangle.BOTTOM);
            table.addCell(cell);
            table.setWidthPercentage(100);
            table.setWidths(headerWidth);
            table.setSpacingAfter(8);
            document.add(table);

            //--------------------------//
            table = new PdfPTable(1);
            cell = new PdfPCell(new Phrase("QUOTATION", invoiceFont));
            cell.setBorder(Rectangle.NO_BORDER);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table.addCell(cell);
            document.add(table);

            table = new PdfPTable(2);
            cell = new PdfPCell(new Phrase("Our Ref: " + refNum, normalFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("Validity of Quote: ONE(1) Month", redFont));
            cell.setBorder(Rectangle.NO_BORDER);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            table.addCell(cell);
            table.setWidthPercentage(100);
            table.setSpacingAfter(8);
            document.add(table);

            table = new PdfPTable(1);
            String dateCreated = Converter.convertDateQuotationPdf(lead.getDt());
            cell = new PdfPCell(new Phrase(dateCreated, normalFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidthPercentage(100);
            table.setSpacingAfter(8);
            document.add(table);

            table = new PdfPTable(1);
            cell = new PdfPCell(new Phrase(cust.toString().toUpperCase(), boldFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidthPercentage(100);
            document.add(table);

            table = new PdfPTable(1);
            if (cust.getEmail().isEmpty()) {
                cell = new PdfPCell(new Phrase("TEL: " + cust.getContact(), boldFont));
            } else if (cust.getContact() == 0) {
                cell = new PdfPCell(new Phrase("EMAIL: " + cust.getEmail().toUpperCase(), boldFont));
            } else {
                cell = new PdfPCell(new Phrase("TEL: " + cust.getContact() + " / EMAIL: " + cust.getEmail().toUpperCase(), boldFont));
            }

            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidthPercentage(100);
            table.setSpacingAfter(8);
            document.add(table);

            table = new PdfPTable(1);
            cell = new PdfPCell(new Phrase("Dear " + cust.getSalutation() + " " + cust.getLast_name() + ",", normalFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidthPercentage(100);
            table.setSpacingAfter(8);
            document.add(table);

            table = new PdfPTable(1);
            String tom = lead.getTom();
            tom = tom.replaceAll("\\|", " | ");
            cell = new PdfPCell(new Phrase(tom + " Moving Service", underlineFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidthPercentage(100);
            table.setSpacingAfter(8);
            document.add(table);

            table = new PdfPTable(1);
            cell = new PdfPCell(new Phrase("Thank you for inviting Vimbox Services to assess and quote for your " + tom.toLowerCase() + " moving service.", normalFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidthPercentage(100);
            document.add(table);

            table = new PdfPTable(2);
            ArrayList<String[]> addFrom = lead.getAddressFrom();
            String fromStr = "";
            if (!addFrom.isEmpty()) {
                for (String[] fr : addFrom) {
                    String[] addressDetails = fr[0].split("_");
                    if (addFrom.size() == 1) {
                        fromStr += addressDetails[0] + " #" + addressDetails[1] + "-" + addressDetails[2] + " S" + addressDetails[3];
                    } else {
                        if (!fr[0].isEmpty()) {
                            fromStr += "\n";
                            fromStr += "    •    " + addressDetails[0] + " #" + addressDetails[1] + "-" + addressDetails[2] + " S" + addressDetails[3];
                        }
                    }
                }
            } else {
                fromStr += "N/A";
            }
            phrase = new Phrase();
            phrase.add(new Phrase("From: ", normalFont));
            phrase.add(new Phrase(fromStr, boldFont));
            cell = new PdfPCell(phrase);
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);

            ArrayList<String[]> addTo = lead.getAddressTo();
            String toStr = "";
            if (!addTo.isEmpty()) {
                for (String[] to : addTo) {
                    String[] addressDetails = to[0].split("_");
                    if (addTo.size() == 1) {
                        toStr += addressDetails[0] + " #" + addressDetails[1] + "-" + addressDetails[2] + " S" + addressDetails[3];
                    } else {
                        if (!to[0].isEmpty()) {
                            toStr += "\n";
                            toStr += "    •    " + addressDetails[0] + " #" + addressDetails[1] + "-" + addressDetails[2] + " S" + addressDetails[3];
                        }
                    }
                }
            } else {
                toStr += "N/A";
            }
            phrase = new Phrase();
            phrase.add(new Phrase("To: ", normalFont));
            phrase.add(new Phrase(toStr, boldFont));
            cell = new PdfPCell(phrase);
            cell.setBorder(Rectangle.NO_BORDER);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            table.setWidthPercentage(100);
            document.add(table);

            table = new PdfPTable(1);
            ArrayList<String[]> dateOfMove = OperationsDAO.getDOMbyLeadID(lead.getId());
            // always get the last dom, sql already sorted by descending order. just get(0) will do.
            String dateTs = "";
            if (!dateOfMove.isEmpty()) {
                String[] dts = dateOfMove.get(0);
                DateTime dt = Converter.convertStringtoDt(dts[0]);
                String dateStr = Converter.convertDateQuotationPdf(dt);
                dateTs += dateStr + " / " + dts[1] + " hrs";
            }
            phrase = new Phrase();
            phrase.add(new Phrase("Date and Time of moving service: ", normalFont));
            phrase.add(new Phrase(dateTs, boldFont));
            cell = new PdfPCell(phrase);
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidthPercentage(100);
            table.setSpacingAfter(8);
            document.add(table);

            table = new PdfPTable(1);
            cell = new PdfPCell(new Phrase("We are pleased to inform you that the job requirements are well within our capabilities.", normalFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidthPercentage(100);
            table.setSpacingAfter(8);
            document.add(table);

            table = new PdfPTable(1);
            phrase = new Phrase();
            phrase.add(new Phrase("The cost of your moving service is ", normalFont));
            double totalAmount = LeadDAO.getLeadConfirmedTotal(lead.getId());
            phrase.add(new Phrase("S$" + df.format(totalAmount) + "/-", boldFont));
            phrase.add(new Phrase(" which includes the following: -", normalFont));
            cell = new PdfPCell(phrase);
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidthPercentage(100);
            document.add(table);

            table = new PdfPTable(1);
            cell = new PdfPCell(new Phrase("     •     Moving service based on the items shown to our surveyor (listed in the messages) inclusive of manpower and transport;\n"
                    + "     •     Necessary dismantling / assembling of furniture;\n"
                    + "     •     Necessary protective wrapping of furniture;", normalFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidthPercentage(100);
            table.setSpacingAfter(8);
            document.add(table);

            float[] listWidth = new float[]{10f, 90f};

            table = new PdfPTable(2);
            cell = new PdfPCell(new Phrase("Optional: ", boldFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("•  Packing service of based on a maximum of 40 carton boxes at S$310/-\n"
                    + "•  Unpacking Service if needed is additional S$250/-", boldFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidths(listWidth);
            table.setWidthPercentage(100);
            table.setSpacingAfter(8);
            document.add(table);

            table = new PdfPTable(2);
            cell = new PdfPCell(new Phrase("Exclude: ", boldFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("a)  Mounting of LCD/plasma TVs/Fixtures\n"
                    + "b)  Decommissioning & Commissioning of computers/Electrical Appliances", boldFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidths(listWidth);
            table.setWidthPercentage(100);
            table.setSpacingAfter(8);
            document.add(table);

            table = new PdfPTable(2);
            cell = new PdfPCell(new Phrase("Note: ", boldFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("•  If you like our services, kindly\n"
                    + "   a)   “Like” of our “Vimbox Movers Singapore” Facebook Page\n"
                    + "   b)   Post a photo and review on our “Vimbox Movers Singapore” Facebook Page\n"
                    + "•  If labour via stairs is required, it will be S$40/level\n"
                    + "•  Long push if required is additional S$180/-\n"
                    + "•  For disposal services, Vimbox can only dispose of household and office items only. We do not\n   dispose food, plants, debris, oil and other liquid items.\n"
                    + "•  Dismantling / Reassembling of IKEA furniture may cause some alignment issues due to the\n   nature of the materials used in manufacturing the item.", boldFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidths(listWidth);
            table.setWidthPercentage(100);
            table.setSpacingAfter(8);
            document.add(table);

            table = new PdfPTable(1);
            cell = new PdfPCell(new Phrase("Kindly inform us Three (3) days in advance, if any additional job scope is required.", normalFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidthPercentage(100);
            table.setSpacingAfter(8);
            document.add(table);

            table = new PdfPTable(1);
            cell = new PdfPCell(new Phrase("In the event the Company as a result of its negligence in carrying out this contract, or as a result of the negligence of its employees or agents, causes loss / damage to the Customer, the Company would be liable to the customer for the actual loss / damages suffered up to the limit of:\n"
                    + "      •   S$150 per move.\n"
                    + "For the avoidance of doubt, the above liability the Company is exposed to do not extend to items as stipulated by Clause 9 of the company’s terms and conditions.", normalFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidthPercentage(100);
            table.setSpacingAfter(8);
            document.add(table);

            table = new PdfPTable(1);
            cell = new PdfPCell(new Phrase("Thank you for choosing Vimbox Services.", boldFont));
            cell.setBorder(Rectangle.NO_BORDER);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table.addCell(cell);
            table.setSpacingAfter(2);
            document.add(table);

            table = new PdfPTable(1);
            cell = new PdfPCell(new Phrase("Relocation Manager: KIM. Z\n"
                    + "TEL: 91731537 / EMAIL: KIM.Z@VIMBOXMOVERS.SG", boldFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidthPercentage(100);
            table.setSpacingAfter(8);
            document.add(table);

            table = new PdfPTable(1);
            cell = new PdfPCell(new Phrase("Acceptance by Customer: ", underlineFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidthPercentage(100);
            table.setSpacingAfter(15);
            document.add(table);

            table = new PdfPTable(2);
            cell = new PdfPCell(new Phrase("Name: __________________________", boldFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("NRIC/FIN No.: __________________________", boldFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidthPercentage(100);
            table.setSpacingAfter(15);
            document.add(table);

            table = new PdfPTable(2);
            cell = new PdfPCell(new Phrase("Signature: __________________________", boldFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("Date: __________________________", boldFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidthPercentage(100);
            document.add(table);

            table = new PdfPTable(1);
            cell = new PdfPCell(new Phrase("By Accepting this quotation, I the customer confirm that I have read Vimbox Services Private Limited’s terms and conditions below and agree to be bound by them.", tcFont));
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidthPercentage(100);
            table.setSpacingAfter(15);
            document.add(table);

            table = new PdfPTable(1);
            phrase = new Phrase();
            phrase.add(new Phrase("Privacy Note: ", tcUnderlineFont));
            phrase.add(new Phrase("By signing and agreeing to this quotation, you agree to the collection, use and processing of the personal information you provide us for the purposes of our execution of our services to you, payment of your dues; marketing and communicating with you in relation to products and services offered by us, our partners as well as our appointed agents and/or affiliates.", tcFont));
            cell = new PdfPCell(phrase);
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidthPercentage(100);
            document.add(table);

            // T&C
            document.newPage();

            table = new PdfPTable(2);
            phrase = new Phrase();
            phrase.add(new Phrase("VIMBOX SERVICES PRIVATE LIMITED (201319626W)\n18 BOON LAY WAY #08-115\nTRADEHUB 21 SINGAPORE 609966\nTEL 63394439\n", normalFont));
            phrase.add(new Phrase("WWW.VIMBOXMOVERS.SG", linkFont));
            cell = new PdfPCell(phrase);
            cell.setBorder(Rectangle.BOTTOM);
            table.addCell(cell);

            cell = new PdfPCell(img);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            cell.setRowspan(2);
            cell.setBorder(Rectangle.BOTTOM);
            table.addCell(cell);
            table.setWidthPercentage(100);
            table.setWidths(headerWidth);
            document.add(table);

            table = new PdfPTable(1);
            phrase = new Phrase();
            phrase.add(new Phrase("Terms and Conditions", tcUnderlineFont));
            cell = new PdfPCell(phrase);
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidthPercentage(100);
            document.add(table);

            table = new PdfPTable(1);
            phrase = new Phrase();
            phrase.add(new Phrase("Customer(s) are deemed to have read, understood and accepted the following terms and conditions. Vimbox Services Pte Ltd shall be known as “The Company” hereinafter.", tcFont));
            cell = new PdfPCell(phrase);
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidthPercentage(100);
            table.setSpacingAfter(8);
            document.add(table);

            table = new PdfPTable(1);
            phrase = new Phrase();
            phrase.add(new Phrase("1. QUOTATION: ", tcBoldFont));
            phrase.add(new Phrase("The Company reserves the right to amend any mistakes and/or omissions in the quotation at any point of time. Quotations are open for acceptance for a period of 60 calendar days, from the date of quotation, unless or otherwise stated in writing on the quotation. Once accepted, the quotation shall be read with and construed with the together with the terms and conditions herein, and in particular, references herein to the term “Agreement”, and all other instruments and documents executed thereunder or pursuant thereto, shall for all purposes refer to these terms and conditions incorporating and as supplemented by the quotation.\n\n", tcFont));
            phrase.add(new Phrase("2. SCHEDULE BOOKINGS: ", tcBoldFont));
            phrase.add(new Phrase("Booking of moving / storage dates and times are based on a first- come-first-serve basis and is subject to availability of the Company. 40% of the total costs of move will be collected as a deposit for the booking. Kindly note that, booking is only confirmed if The Company sends an acknowledgement receipt upon receiving the deposit as mentioned above.\n\n", tcFont));
            phrase.add(new Phrase("3. MOVING TIME: ", tcBoldFont));
            phrase.add(new Phrase("All timings given are at best an estimate. Actual arrival time may vary due to unforeseen circumstances such as bad weather, heavy traffic, etc.\n\n", tcFont));
            phrase.add(new Phrase("4. CHANGES IN SCHEDULE: ", tcBoldFont));
            phrase.add(new Phrase("Subject to the schedule of the company, an advance notice of at least 7 working days is required from the customers for changes in regard to date/time for moving/storage. The Company shall also reserve the right to make changes at any time to the schedule without compensation especially where unforeseen circumstances arise. However, the Company shall make reasonable effort to avoid such changes, and provide early notification to customers where possible.\n\n", tcFont));
            phrase.add(new Phrase("5. CANCELLATION OF BOOOKING: ", tcBoldFont));
            phrase.add(new Phrase("An advance notice of at least 7 working days is required from the customers for any cancellation. A late cancellation fee, comprising 50% of the total charges per agreement will be invoiced to the customer upon cancellation within 7 calendar days of the scheduled appointment and 100% of total charges if within 48 hours notice.\n\n", tcFont));
            phrase.add(new Phrase("6. ADDITIONAL SERVICES AND CHARGES: ", tcBoldFont));
            phrase.add(new Phrase("Additional charges are applicable for moving/storage of extra items, handyman services, dismantling/assembling of complex furniture (for e.g. sliding wardrobe/children bed set) and other services/items not stated in the quotation/inventory list. Do take note that additional costs for addition of last minute items will be higher as compared to at the point of quotation. In the event of non-lift access, additional fees will be charged for manual lifting, depending on the time and man-power required to carry out the move as stated in the quotation.\n\n", tcFont));
            phrase.add(new Phrase("7. PACKING OF MATERIALS: ", tcBoldFont));
            phrase.add(new Phrase("Delivery of materials shall be made within 3 working days after receiving confirmation from customers or at a date agreed upon by both parties and subject to the availability of the Company.\n\n", tcFont));
            phrase.add(new Phrase("8. LOADING AND UNLOADING: ", tcBoldFont));
            phrase.add(new Phrase("The Company will load and unload all items meant to be moved on its transport vehicles. It is however the responsibility of customer to ensure that after loading the transportation vehicle(s), and before its departure, that all item(s) that are meant to be transported are on the vehicle(s). Customers are also responsible for the security of goods at the departure and destination points during loading and unloading, and after.\n\n", tcFont));
            phrase.add(new Phrase("9. PROHIBITED ITEMS: ", tcBoldFont));
            phrase.add(new Phrase("Unless otherwise agreed to in writing, the Company reserves the right to reject transporting any dangerous or hazardous items, items with a value above $50,000, as well as any of the items listed below:-\n"
                    + "“Antiques, paintings, sculpture, works of arts, bulk cargo, bag cargo(unless in the containers), branded/boutiques designer goods and watches, cash, gold, bullion, negotiable instruments, jewelry, precious metals, ceramics, porcelain, pottery, sanitary ware, tiles, lightings, mirrors, cigarettes, tobacco, containers as cargo, electronics/semi- conductor components, frozen food, cargo requiring refrigeration, liquor, livestock, military, equipment/ ammunition explosives, logs, plywood, timber, vehicle, raw cotton and asbestos.”\n\n"
                    + "Unless otherwise stipulated, the Company will not be liable for any loss/damages to such items:\n"
                    + "    a)     In the event such items are inevitably moved without the written agreement of the Company;\n"
                    + "    b)     In the event that any of the abovementioned items are included in the goods slated for moving and/or storage and are thereafter damaged and/or\n            missing;\n"
                    + "    c)     With regard to (a) and (b), even if the Company or its agents have been negligent in any way;\n"
                    + "    d)     With regard to (a) and (b), even if the Company’s employees may have without the consent of the Company deliberately caused the damage/loss.\n\n", tcFont));
            phrase.add(new Phrase("10. EXCLUSION OF LIABILITY FOR MOVING / STORING:\n", tcBoldFont));
            phrase.add(new Phrase("    a)     Unless otherwise set out in this Agreement, the Company will not be responsible for any loss/damages caused by it, its employees, or agents to any\n            goods/items moved/stored by the Company, or for any loss/damage caused to any other property including land/premises belonging to the customer\n            during the move;\n"
                    + "    b)     In regard to (a), the Company shall not be liable for any loss/damage even if the Company or its agents have been negligent in any way.\n\n", tcFont));
            phrase.add(new Phrase("11. INSURANCE: ", tcBoldFont));
            phrase.add(new Phrase("Unless otherwise agreed to, utilisation of our services is at customer(s) sole risk. Customer(s) are advised to maintain adequate insurance to cover for unexpected loss/damages.", tcFont));
            phrase.add(new Phrase("12. ITEMS BEING MOVED: ", tcBoldFont));
            phrase.add(new Phrase("Customer warrants that the customer is the owner of all items to be moved or has the explicit or implied authority from the owner of any items to be moved by the Company under this Agreement. Unless otherwise stipulated, in the event the customer causes the Company to move/store any item(s) belonging to a third party, the customer agrees that it shall fully indemnify and hold the Company harmless against action for damages/loss that may be brought against the Company by such third parties in respect of such items. Such indemnity shall be applicable even where the Company may be negligent, or if the Company’s employees without the authorisation of the Company deliberately causes the loss/damage.\n\n", tcFont));
            phrase.add(new Phrase("13. PREMISES: ", tcBoldFont));
            phrase.add(new Phrase("Customer warrants that the customer is the owner / leaseholder / occupier of any premises, or is otherwise authorised by any of the aforementioned persons to allow the Company’s employees or agents to enter any premises necessary to complete the move. Unless otherwise stipulated, the customer agrees that it shall fully indemnify and hold the Company harmless against any action for loss/damage that may be"
                    + " brought against the Company by the owner / leaseholder / occupier of any premises which the customer authorises the Company, its employees or agents to enter. Such indemnity shall be applicable even where the Company may be negligent, or if the Company’s employees without the authorisation of the Company deliberately causes loss/damage to the premises.\n\n", tcFont));
            phrase.add(new Phrase("14. STORAGE / WAREHOUSING: ", tcBoldFont));
            phrase.add(new Phrase("Moving charges do not include storage costs. In the event the Company is made to store items, the Company’s standard terms and conditions with regards to storage / warehousing shall apply.\n\n", tcFont));
            phrase.add(new Phrase("15. PAYMENT MODE: ", tcBoldFont));
            phrase.add(new Phrase("Either Cash, Cheque or NETS payment is accepted. Cheque payment should be crossed and made payable to “VIMBOX SERVICES PTE LTD”. On the reverse side of the cheque, please indicate your Name, Contact, Number and Invoice No. Send the cheque to “18 Boon Lay Way #08-115, Tradehub 21, Singapore 609966”\n\nFor payment via internet banking or ATM, please contact our accounts at Tel: 63394439\n\n"
                    + "Full payment is required on the day of job completion, or if agreed by The Company, within 3 calendar days.\n\n"
                    + "Do take note that only Cash / NETS payment is accepted for scheduled appointments over the weekends.\n\n", tcFont));
            cell = new PdfPCell(phrase);
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidthPercentage(100);
            table.setSpacingAfter(8);
            document.add(table);

            document.newPage();

            table = new PdfPTable(2);
            phrase = new Phrase();
            phrase.add(new Phrase("VIMBOX SERVICES PRIVATE LIMITED (201319626W)\n18 BOON LAY WAY #08-115\nTRADEHUB 21 SINGAPORE 609966\nTEL 63394439\n", normalFont));
            phrase.add(new Phrase("WWW.VIMBOXMOVERS.SG", linkFont));
            cell = new PdfPCell(phrase);
            cell.setBorder(Rectangle.BOTTOM);
            table.addCell(cell);

            cell = new PdfPCell(img);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            cell.setRowspan(2);
            cell.setBorder(Rectangle.BOTTOM);
            table.addCell(cell);
            table.setWidthPercentage(100);
            table.setSpacingAfter(8);
            table.setWidths(headerWidth);
            document.add(table);

            table = new PdfPTable(1);
            phrase = new Phrase();
            phrase.add(new Phrase("16. PAYMENT POLICY: ", tcBoldFont));
            phrase.add(new Phrase("All payments due and owing by the customer to the Company for services rendered shall be made free of any restrictions or condition and without any deduction or withholding, whether by way of set-off (legal and/or equitable) or otherwise.\n\n", tcFont));
            phrase.add(new Phrase("17. RESPONSIBILITY & LIABILITY: ", tcBoldFont));
            phrase.add(new Phrase("All liabilities of the Company end upon handing over of goods to the customer or his/her authorized representative. The Company accepts no responsibility for any injury, loss, damages, accident, delay or irregularities that may be caused to the property where such occurrences are unforeseen. Such occurrences include for instance, natural disasters and bad traffic conditions.\n\n", tcFont));
            phrase.add(new Phrase("18. UNCONTROLLABLE CIRCUMSTANCES: ", tcBoldFont));
            phrase.add(new Phrase("The Company shall have no liability under or be considered to be in breach of this Agreement for any delay or failure in performance of its obligations under this Agreement which results from circumstances beyond its reasonable control. Such circumstances include any Act of God, riot, strike or lock-out, trade dispute or labour disturbance, accident, breakdown of plant or machinery, fire, flood, shortage of labour, materials or transport, electrical power failures, threat of or actual terrorism or environmental or health emergency or "
                    + "hazard, or arrest or seizure or confiscation of items/goods by competent authorities. If this happens, the Company will not be responsible for failing to allow access to your items/goods for so long as the circumstances continue. The Company shall however use reasonable endeavors to minimize any effects arising from such circumstances.\n\n", tcFont));
            phrase.add(new Phrase("19. JURISDICTION: ", tcBoldFont));
            phrase.add(new Phrase("All matters arising from or connected with this Agreement shall be governed by and construed in accordance with the laws of Singapore and the Parties hereto submit to the exclusive jurisdiction of the courts of Singapore.\n\n", tcFont));
            phrase.add(new Phrase("20. SMALL CLAIMS: ", tcBoldFont));
            phrase.add(new Phrase("Parties agree that, any dispute (within the maximum statutory limit of the Small Claims Tribunal of the State Courts of Singapore) arising out of or in connection with this contract, including any question regarding its existence, validity or termination, shall be referred to and finally resolved by the Small Claims Tribunal of the State Courts of Singapore, which rules are where appropriate deemed to be incorporated by reference in this clause.\n\n", tcFont));
            phrase.add(new Phrase("21. AMENDMENT TO TERMS & CONDITIONS: ", tcBoldFont));
            phrase.add(new Phrase("The Company reserves the rights to amend or update the current terms and conditions without prior notice.", tcFont));
            phrase.add(new Phrase("22. SEVERANCE: ", tcBoldFont));
            phrase.add(new Phrase("If any provision of the Agreement or part thereof is rendered void, illegal or unenforceable by any legislation to which it is subject, it shall be rendered void, illegal or unenforceable to that extent and it shall in no way affect or prejudice the enforceability of the remainder of such provision or the other provisions of this Agreement.\n\n", tcFont));
            phrase.add(new Phrase("23. THIRD PARTY RIGHTS: ", tcBoldFont));
            phrase.add(new Phrase("Unless expressly provided to the contrary in this Agreement, a person who is not a party has no right under the Contracts (Rights of Third Parties) Act, Chapter 53B of Singapore to enforce or to enjoy the benefit of any term of this Agreement. Notwithstanding any term of this Agreement the consent of any third party is not required for any variation (including any release or compromise of any liability under) or termination of this Agreement.\n\n", tcFont));
            phrase.add(new Phrase("24. ENTIRE AGREEMENT: ", tcBoldFont));
            phrase.add(new Phrase("The Parties expressly acknowledge that they have read this Agreement and understood its provisions. The Parties agree that this Agreement and its subsequent terms, conditions and variations constitute the entire agreement between them with respect to the subject matter of this Agreement and that it supersedes all prior or contemporaneous proposals, agreements, negotiations, representations, warranties, understandings, correspondence and all other communications (whether written or oral, express or implied) or arrangements entered into between "
                    + "the Parties prior to this Agreement in respect of the matters dealt with in it. No promise, inducement, representation or agreement other than as expressly set forth in this Agreement has been made to or by the Parties.", tcFont));
            cell = new PdfPCell(phrase);
            cell.setBorder(Rectangle.NO_BORDER);
            table.addCell(cell);
            table.setWidthPercentage(100);
            table.setSpacingAfter(8);
            document.add(table);

            // ITEM LISTS
            document.newPage();

            // loop through different addresses
            for (LeadDiv leadDiv : leadDivs) {
                String leadDivStr = leadDiv.getSalesDiv();
                String leadDivId = leadDivStr.substring(0, leadDivStr.indexOf("|"));
                String leadDivAddr = leadDivStr.substring(leadDivStr.indexOf("|") + 1);

                // CUSTOMER ITEM LIST IN NEW PAGE
                table = new PdfPTable(1);
                cell = new PdfPCell(new Phrase("Address: " + leadDivAddr, boldFont));
                cell.setBorder(Rectangle.NO_BORDER);
                table.addCell(cell);
                table.setWidthPercentage(100);
                table.setSpacingAfter(8);
                table.setSpacingBefore(20);
                document.add(table);

                table = new PdfPTable(1);
                cell = new PdfPCell(new Phrase("Customer Item List", underlineFont));
                cell.setBorder(Rectangle.NO_BORDER);
                cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
                table.addCell(cell);
                table.setWidthPercentage(100);
                table.setSpacingAfter(8);
                document.add(table);

                float[] contentColWidths = new float[]{40f, 40f, 10f};
                LineSeparator line = new LineSeparator();
                line.setOffset(-7);

                table = new PdfPTable(3);
                String[] tHeaders = {"Item(s)", "Remarks", "Qty"};
                for (int i = 0; i < tHeaders.length; i++) {
                    String tHeader = tHeaders[i];
                    cell = new PdfPCell(new Phrase(tHeader, boldFont));
                    cell.setBorder(Rectangle.NO_BORDER);
                    cell.setBackgroundColor(cHeaderColor);
                    table.addCell(cell);
                }
                table.setWidths(contentColWidths);
                table.setWidthPercentage(100);
                document.add(table);

                ArrayList<Item> customerItems = leadDiv.getCustomerItems();
                table = new PdfPTable(3);
                if (customerItems != null) {
                    for (Item item : customerItems) {
                        cell = new PdfPCell(new Phrase(item.getName(), boldFont));
                        cell.setBorder(Rectangle.NO_BORDER);
                        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
                        table.addCell(cell);

                        //Remarks
                        cell = new PdfPCell(new Phrase(item.getRemark(), normalFont));
                        cell.setBorder(Rectangle.NO_BORDER);
                        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
                        table.addCell(cell);

                        //Qty
                        cell = new PdfPCell(new Phrase(Double.toString(item.getQty()), normalFont));
                        cell.setBorder(Rectangle.NO_BORDER);
                        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
                        table.addCell(cell);
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

                // VIMBOX ITEM LIST + MATERIALS
                table = new PdfPTable(1);
                cell = new PdfPCell(new Phrase("Vimbox Item List", underlineFont));
                cell.setBorder(Rectangle.NO_BORDER);
                cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
                table.addCell(cell);
                table.setWidthPercentage(100);
                table.setSpacingBefore(20);
                table.setSpacingAfter(8);
                document.add(table);

                float[] contentColWidthss = new float[]{40f, 40f, 10f};
                LineSeparator linee = new LineSeparator();
                linee.setOffset(-7);

                table = new PdfPTable(3);
                String[] tHeaderss = {"Item(s)", "Charges ($)", "Qty"};
                for (int i = 0; i < tHeaderss.length; i++) {
                    String tHeader = tHeaderss[i];
                    cell = new PdfPCell(new Phrase(tHeader, boldFont));
                    cell.setBorder(Rectangle.NO_BORDER);
                    cell.setBackgroundColor(vHeaderColor);
                    table.addCell(cell);
                }
                table.setWidths(contentColWidthss);
                table.setWidthPercentage(100);
                document.add(table);

                table = new PdfPTable(3);
                ArrayList<Item> vimboxItems = leadDiv.getVimboxItems();
                for (Item item : vimboxItems) {
                    cell = new PdfPCell(new Phrase(item.getName(), boldFont));
                    cell.setBorder(Rectangle.NO_BORDER);
                    cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
                    table.addCell(cell);

                    //Charges
                    double charge = item.getCharges();
                    String c = "";
                    if (charge != 0) {
                        c = df.format(item.getCharges());
                    }
                    cell = new PdfPCell(new Phrase(c, normalFont));
                    cell.setBorder(Rectangle.NO_BORDER);
                    cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
                    table.addCell(cell);

                    //Qty
                    cell = new PdfPCell(new Phrase(Double.toString(item.getQty()), normalFont));
                    cell.setBorder(Rectangle.NO_BORDER);
                    cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
                    table.addCell(cell);
                }

                ArrayList<Item> materials = leadDiv.getMaterials();
                for (Item item : materials) {
                    cell = new PdfPCell(new Phrase(item.getName(), boldFont));
                    cell.setBorder(Rectangle.NO_BORDER);
                    cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
                    table.addCell(cell);

                    //Charges
                    double charge = item.getCharges();
                    String c = "";
                    if (charge != 0) {
                        c = df.format(item.getCharges());
                    }
                    cell = new PdfPCell(new Phrase(c, normalFont));
                    cell.setBorder(Rectangle.NO_BORDER);
                    cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
                    table.addCell(cell);

                    //Qty
                    cell = new PdfPCell(new Phrase(Double.toString(item.getQty()), normalFont));
                    cell.setBorder(Rectangle.NO_BORDER);
                    cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
                    table.addCell(cell);
                }

                table.setSpacingBefore(10);
                table.setWidths(contentColWidthss);
                table.setWidthPercentage(100);
                document.add(table);
                LineSeparator line2 = new LineSeparator();
                line2.setOffset(-7);
                line2.setLineColor(lineColor);
                document.add(line2);

            }
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
