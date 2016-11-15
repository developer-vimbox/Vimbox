/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.vimbox.sales;

import com.google.gson.JsonObject;
import com.vimbox.database.LeadDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author xuening
 */
@WebServlet(name = "SalesReportController", urlPatterns = {"/SalesReportController"})
public class SalesReportController extends HttpServlet {

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
        PrintWriter out = response.getWriter();
        String opt = request.getParameter("opt");

        JsonObject jsonOutput = new JsonObject();

        if (opt.equals("week")) {
            String date = request.getParameter("seldate");
            System.out.println("THE DATE IS: " + date);
            ArrayList<String[]> weekLeadConfirmation = LeadDAO.getWeekLeadConfirmation(date);
            if (weekLeadConfirmation.size() > 0) {
                int[] sales = new int[7];
                int mon = 0;
                int tues = 0;
                int weds = 0;
                int thurs = 0;
                int fri = 0;
                int sat = 0;
                int sun = 0;
                double total = 0;
                double montotal = 0;
                double tuestotal = 0;
                double wedstotal = 0;
                double thurstotal = 0;
                double fritotal = 0;
                double sattotal = 0;
                double suntotal = 0;
                double[] salesAmt = new double[7];
                DecimalFormat df = new DecimalFormat("##.00");
                for (String[] rec : weekLeadConfirmation) {
                    double totalAmt = Double.parseDouble(rec[1]);
                    total += totalAmt;
                    String nameOfDay = rec[2];
                    switch (nameOfDay) {
                        case "Monday":
                            mon++;
                            montotal += totalAmt;
                            break;
                        case "Tuesday":
                            tues++;
                            tuestotal += totalAmt;
                            break;
                        case "Wednesday":
                            weds++;
                            wedstotal += totalAmt;
                            break;
                        case "Thursday":
                            thurs++;
                            thurstotal += totalAmt;
                            break;
                        case "Friday":
                            fri++;
                            fritotal += totalAmt;
                            break;
                        case "Saturday":
                            sat++;
                            sattotal += totalAmt;
                            break;
                        case "Sunday":
                            sun++;
                            suntotal += totalAmt;
                            break;
                    }

                }
                sales[0] = mon;
                sales[1] = tues;
                sales[2] = weds;
                sales[3] = thurs;
                sales[4] = fri;
                sales[5] = sat;
                sales[6] = sun;
                salesAmt[0] = montotal;
                salesAmt[1] = tuestotal;
                salesAmt[2] = wedstotal;
                salesAmt[3] = thurstotal;
                salesAmt[4] = fritotal;
                salesAmt[5] = sattotal;
                salesAmt[6] = suntotal;
                int max = 0;
                //count max to set v axis
                for (int i = 0; i < sales.length; i++) {
                    sales[i] = max;

                    for (int j = i + 1; j < sales.length; j++) {
                        if (sales[j] > max) {
                            max = sales[j];
                        }

                    }
                }
                double maxAmt = 0;
                for (int i = 0; i < salesAmt.length; i++) {
                    salesAmt[i] = maxAmt;

                    for (int j = i + 1; j < salesAmt.length; j++) {
                        if (salesAmt[j] > maxAmt) {
                            maxAmt = salesAmt[j];
                        }

                    }
                }

                jsonOutput.addProperty("status", "SUCCESS");
                jsonOutput.addProperty("mon", mon);
                jsonOutput.addProperty("tues", tues);
                jsonOutput.addProperty("weds", weds);
                jsonOutput.addProperty("thurs", thurs);
                jsonOutput.addProperty("fri", fri);
                jsonOutput.addProperty("sat", sat);
                jsonOutput.addProperty("sun", sun);
                jsonOutput.addProperty("montotal", df.format(montotal));
                jsonOutput.addProperty("tuestotal", df.format(tuestotal));
                jsonOutput.addProperty("wedstotal", df.format(wedstotal));
                jsonOutput.addProperty("thurstotal", df.format(thurstotal));
                jsonOutput.addProperty("fritotal", df.format(fritotal));
                jsonOutput.addProperty("sattotal", df.format(sattotal));
                jsonOutput.addProperty("suntotal", df.format(suntotal));
                jsonOutput.addProperty("max", max);
                jsonOutput.addProperty("maxAmt", df.format(maxAmt));
                jsonOutput.addProperty("total", df.format(total));
            } else if (weekLeadConfirmation.size() == 0) {
                jsonOutput.addProperty("status", "noRecord");
            } else {
                jsonOutput.addProperty("status", "error");
            }
            out.println(jsonOutput);

        } else if (opt.equals("year")) {
            String year = request.getParameter("selyear");
            ArrayList<String[]> yrLeadConfirmation = LeadDAO.getYearLeadConfirmation(year);
            if (yrLeadConfirmation.size() > 0) {
                int sales[] = new int[12];
                double[] salesAmt = new double[12];
                int jan = 0;
                int feb = 0;
                int mar = 0;
                int apr = 0;
                int may = 0;
                int june = 0;
                int jul = 0;
                int aug = 0;
                int sep = 0;
                int oct = 0;
                int nov = 0;
                int dec = 0;
                double total = 0;
                double jantotal = 0;
                double febtotal = 0;
                double martotal = 0;
                double aprtotal = 0;
                double maytotal = 0;
                double juntotal = 0;
                double jultotal = 0;
                double augtotal = 0;
                double septotal = 0;
                double octtotal = 0;
                double novtotal = 0;
                double dectotal = 0;
                DecimalFormat df = new DecimalFormat("##.00");
                for (String[] rec : yrLeadConfirmation) {
                    double totalAmt = Double.parseDouble(rec[1]);
                    total += totalAmt;
                    String mthName = rec[2];
                    switch (mthName) {
                        case "January":
                            jan++;
                            jantotal += totalAmt;
                            break;
                        case "February":
                            feb++;
                            febtotal += totalAmt;
                            break;
                        case "March":
                            mar++;
                            martotal += totalAmt;
                            break;
                        case "April":
                            apr++;
                            aprtotal += totalAmt;
                            break;
                        case "May":
                            may++;
                            maytotal += totalAmt;
                            break;
                        case "June":
                            june++;
                            juntotal += totalAmt;
                            break;
                        case "July":
                            jul++;
                            jultotal += totalAmt;
                            break;
                        case "August":
                            aug++;
                            augtotal += totalAmt;
                            break;
                        case "September":
                            sep++;
                            septotal += totalAmt;
                            break;
                        case "October":
                            oct++;
                            octtotal += totalAmt;
                            break;
                        case "November":
                            nov++;
                            novtotal += totalAmt;
                            break;
                        case "December":
                            dec++;
                            dectotal += totalAmt;
                            break;
                    }

                }
                sales[0] = jan;
                sales[1] = feb;
                sales[2] = mar;
                sales[3] = apr;
                sales[4] = may;
                sales[5] = june;
                sales[6] = jul;
                sales[7] = aug;
                sales[8] = sep;
                sales[9] = oct;
                sales[10] = nov;
                sales[11] = dec;
                salesAmt[0] = jantotal;
                salesAmt[1] = febtotal;
                salesAmt[2] = martotal;
                salesAmt[3] = aprtotal;
                salesAmt[4] = maytotal;
                salesAmt[5] = juntotal;
                salesAmt[6] = jultotal;
                salesAmt[7] = augtotal;
                salesAmt[8] = septotal;
                salesAmt[9] = octtotal;
                salesAmt[10] = novtotal;
                salesAmt[11] = dectotal;

                int max = 0;
                //count max to set v axis
                for (int i = 0; i < sales.length; i++) {
                    sales[i] = max;

                    for (int j = i + 1; j < sales.length; j++) {
                        if (sales[j] > max) {
                            max = sales[j];
                        }

                    }
                }
                double maxAmt = 0;
                for (int i = 0; i < salesAmt.length; i++) {
                    salesAmt[i] = maxAmt;

                    for (int j = i + 1; j < salesAmt.length; j++) {
                        if (salesAmt[j] > maxAmt) {
                            maxAmt = salesAmt[j];
                        }

                    }
                }
                jsonOutput.addProperty("status", "SUCCESS");
                jsonOutput.addProperty("jan", jan);
                jsonOutput.addProperty("feb", feb);
                jsonOutput.addProperty("mar", mar);
                jsonOutput.addProperty("apr", apr);
                jsonOutput.addProperty("may", may);
                jsonOutput.addProperty("june", june);
                jsonOutput.addProperty("jul", jul);
                jsonOutput.addProperty("aug", aug);
                jsonOutput.addProperty("sep", sep);
                jsonOutput.addProperty("oct", oct);
                jsonOutput.addProperty("nov", nov);
                jsonOutput.addProperty("dec", dec);
                jsonOutput.addProperty("jantotal", df.format(jantotal));
                jsonOutput.addProperty("febtotal", df.format(febtotal));
                jsonOutput.addProperty("martotal", df.format(martotal));
                jsonOutput.addProperty("aprtotal", df.format(aprtotal));
                jsonOutput.addProperty("maytotal", df.format(maytotal));
                jsonOutput.addProperty("junetotal", df.format(juntotal));
                jsonOutput.addProperty("jultotal", df.format(jultotal));
                jsonOutput.addProperty("augtotal", df.format(augtotal));
                jsonOutput.addProperty("septotal", df.format(septotal));
                jsonOutput.addProperty("octtotal", df.format(octtotal));
                jsonOutput.addProperty("novtotal", df.format(novtotal));
                jsonOutput.addProperty("dectotal", df.format(dectotal));
                jsonOutput.addProperty("total", df.format(total));
                jsonOutput.addProperty("maxAmt", df.format(maxAmt));
                jsonOutput.addProperty("max", max);
            } else if (yrLeadConfirmation.size() == 0) {
                jsonOutput.addProperty("status", "noRecord");
            } else {
                jsonOutput.addProperty("status", "error");
            }
            out.println(jsonOutput);
        } else if (opt.equals("week_pending")) {
            String date = request.getParameter("seldate");
            ArrayList<String[]> weekLeadConfirmation = LeadDAO.getWeekLeadPending(date);
            if (weekLeadConfirmation.size() > 0) {
                int[] sales = new int[7];
                int mon = 0;
                int tues = 0;
                int weds = 0;
                int thurs = 0;
                int fri = 0;
                int sat = 0;
                int sun = 0;
                double total = 0;
                double montotal = 0;
                double tuestotal = 0;
                double wedstotal = 0;
                double thurstotal = 0;
                double fritotal = 0;
                double sattotal = 0;
                double suntotal = 0;
                double[] salesAmt = new double[7];
                DecimalFormat df = new DecimalFormat("##.00");
                for (String[] rec : weekLeadConfirmation) {
                    double totalAmt = Double.parseDouble(rec[1]);
                    total += totalAmt;
                    String nameOfDay = rec[2];
                    switch (nameOfDay) {
                        case "Monday":
                            mon++;
                            montotal += totalAmt;
                            break;
                        case "Tuesday":
                            tues++;
                            tuestotal += totalAmt;
                            break;
                        case "Wednesday":
                            weds++;
                            wedstotal += totalAmt;
                            break;
                        case "Thursday":
                            thurs++;
                            thurstotal += totalAmt;
                            break;
                        case "Friday":
                            fri++;
                            fritotal += totalAmt;
                            break;
                        case "Saturday":
                            sat++;
                            sattotal += totalAmt;
                            break;
                        case "Sunday":
                            sun++;
                            suntotal += totalAmt;
                            break;
                    }

                }
                sales[0] = mon;
                sales[1] = tues;
                sales[2] = weds;
                sales[3] = thurs;
                sales[4] = fri;
                sales[5] = sat;
                sales[6] = sun;
                salesAmt[0] = montotal;
                salesAmt[1] = tuestotal;
                salesAmt[2] = wedstotal;
                salesAmt[3] = thurstotal;
                salesAmt[4] = fritotal;
                salesAmt[5] = sattotal;
                salesAmt[6] = suntotal;

                int max = 0;
                //count max to set v axis
                for (int i = 0; i < sales.length; i++) {
                    sales[i] = max;

                    for (int j = i + 1; j < sales.length; j++) {
                        if (sales[j] > max) {
                            max = sales[j];
                        }

                    }
                }

                double maxAmt = 0;
                for (int i = 0; i < salesAmt.length; i++) {
                    salesAmt[i] = maxAmt;

                    for (int j = i + 1; j < salesAmt.length; j++) {
                        if (salesAmt[j] > maxAmt) {
                            maxAmt = salesAmt[j];
                        }

                    }
                }

                jsonOutput.addProperty("status", "SUCCESS");
                jsonOutput.addProperty("mon", mon);
                jsonOutput.addProperty("tues", tues);
                jsonOutput.addProperty("weds", weds);
                jsonOutput.addProperty("thurs", thurs);
                jsonOutput.addProperty("fri", fri);
                jsonOutput.addProperty("sat", sat);
                jsonOutput.addProperty("sun", sun);
                jsonOutput.addProperty("montotal", df.format(montotal));
                jsonOutput.addProperty("tuestotal", df.format(tuestotal));
                jsonOutput.addProperty("wedstotal", df.format(wedstotal));
                jsonOutput.addProperty("thurstotal", df.format(thurstotal));
                jsonOutput.addProperty("fritotal", df.format(fritotal));
                jsonOutput.addProperty("sattotal", df.format(sattotal));
                jsonOutput.addProperty("suntotal", df.format(suntotal));
                jsonOutput.addProperty("max", max);
                jsonOutput.addProperty("total", df.format(total));
                jsonOutput.addProperty("maxAmt", df.format(maxAmt));
            } else if (weekLeadConfirmation.size() == 0) {
                jsonOutput.addProperty("status", "noRecord");
            } else {
                jsonOutput.addProperty("status", "error");
            }
            out.println(jsonOutput);
        } else if (opt.equals("year_pending")) {
            String year = request.getParameter("selyear");
            ArrayList<String[]> yrLeadConfirmation = LeadDAO.getYearLeadPending(year);
            if (yrLeadConfirmation.size() > 0) {
                int sales[] = new int[12];
                double[] salesAmt = new double[12];
                int jan = 0;
                int feb = 0;
                int mar = 0;
                int apr = 0;
                int may = 0;
                int june = 0;
                int jul = 0;
                int aug = 0;
                int sep = 0;
                int oct = 0;
                int nov = 0;
                int dec = 0;
                double total = 0;
                double jantotal = 0;
                double febtotal = 0;
                double martotal = 0;
                double aprtotal = 0;
                double maytotal = 0;
                double juntotal = 0;
                double jultotal = 0;
                double augtotal = 0;
                double septotal = 0;
                double octtotal = 0;
                double novtotal = 0;
                double dectotal = 0;
                DecimalFormat df = new DecimalFormat("##.00");
                for (String[] rec : yrLeadConfirmation) {
                    double totalAmt = Double.parseDouble(rec[1]);
                    total += totalAmt;
                    String mthName = rec[2];
                    switch (mthName) {
                        case "January":
                            jan++;
                            jantotal += totalAmt;
                            break;
                        case "February":
                            feb++;
                            febtotal += totalAmt;
                            break;
                        case "March":
                            mar++;
                            martotal += totalAmt;
                            break;
                        case "April":
                            apr++;
                            aprtotal += totalAmt;
                            break;
                        case "May":
                            may++;
                            maytotal += totalAmt;
                            break;
                        case "June":
                            june++;
                            juntotal += totalAmt;
                            break;
                        case "July":
                            jul++;
                            jultotal += totalAmt;
                            break;
                        case "August":
                            aug++;
                            augtotal += totalAmt;
                            break;
                        case "September":
                            sep++;
                            septotal += totalAmt;
                            break;
                        case "October":
                            oct++;
                            octtotal += totalAmt;
                            break;
                        case "November":
                            nov++;
                            novtotal += totalAmt;
                            break;
                        case "December":
                            dec++;
                            dectotal += totalAmt;
                            break;
                    }

                }
                sales[0] = jan;
                sales[1] = feb;
                sales[2] = mar;
                sales[3] = apr;
                sales[4] = may;
                sales[5] = june;
                sales[6] = jul;
                sales[7] = aug;
                sales[8] = sep;
                sales[9] = oct;
                sales[10] = nov;
                sales[11] = dec;

                salesAmt[0] = jantotal;
                salesAmt[1] = febtotal;
                salesAmt[2] = martotal;
                salesAmt[3] = aprtotal;
                salesAmt[4] = maytotal;
                salesAmt[5] = juntotal;
                salesAmt[6] = jultotal;
                salesAmt[7] = augtotal;
                salesAmt[8] = septotal;
                salesAmt[9] = octtotal;
                salesAmt[10] = novtotal;
                salesAmt[11] = dectotal;

                int max = 0;
                //count max to set v axis
                for (int i = 0; i < sales.length; i++) {
                    sales[i] = max;

                    for (int j = i + 1; j < sales.length; j++) {
                        if (sales[j] > max) {
                            max = sales[j];
                        }

                    }
                }

                double maxAmt = 0;
                for (int i = 0; i < salesAmt.length; i++) {
                    salesAmt[i] = maxAmt;

                    for (int j = i + 1; j < salesAmt.length; j++) {
                        if (salesAmt[j] > maxAmt) {
                            maxAmt = salesAmt[j];
                        }

                    }
                }

                jsonOutput.addProperty("status", "SUCCESS");
                jsonOutput.addProperty("jan", jan);
                jsonOutput.addProperty("feb", feb);
                jsonOutput.addProperty("mar", mar);
                jsonOutput.addProperty("apr", apr);
                jsonOutput.addProperty("may", may);
                jsonOutput.addProperty("june", june);
                jsonOutput.addProperty("jul", jul);
                jsonOutput.addProperty("aug", aug);
                jsonOutput.addProperty("sep", sep);
                jsonOutput.addProperty("oct", oct);
                jsonOutput.addProperty("nov", nov);
                jsonOutput.addProperty("dec", dec);
                jsonOutput.addProperty("jantotal", df.format(jantotal));
                jsonOutput.addProperty("febtotal", df.format(febtotal));
                jsonOutput.addProperty("martotal", df.format(martotal));
                jsonOutput.addProperty("aprtotal", df.format(aprtotal));
                jsonOutput.addProperty("maytotal", df.format(maytotal));
                jsonOutput.addProperty("junetotal", df.format(juntotal));
                jsonOutput.addProperty("jultotal", df.format(jultotal));
                jsonOutput.addProperty("augtotal", df.format(augtotal));
                jsonOutput.addProperty("septotal", df.format(septotal));
                jsonOutput.addProperty("octtotal", df.format(octtotal));
                jsonOutput.addProperty("novtotal", df.format(novtotal));
                jsonOutput.addProperty("dectotal", df.format(dectotal));
                jsonOutput.addProperty("total", df.format(total));
                jsonOutput.addProperty("max", max);
                jsonOutput.addProperty("maxAmt", df.format(maxAmt));
            } else if (yrLeadConfirmation.size() == 0) {
                jsonOutput.addProperty("status", "noRecord");
            } else {
                jsonOutput.addProperty("status", "error");
            }
            out.println(jsonOutput);
        } else if (opt.equals("week_general_referral")) {
            String date = request.getParameter("seldate");
            ArrayList<String[]> weekTypeGeneral = LeadDAO.getReferalByWeek(date);
            if (weekTypeGeneral.size() > 0) {
                int fb = 0;
                int fr = 0;
                int wb = 0;
                int mg = 0;
                int others = 0;
                for (String[] rec : weekTypeGeneral) {
                    int count = Integer.parseInt(rec[0]);
                    String rBy = rec[1];
                    switch (rBy) {
                        case "Facebook":
                            fb += count;
                            break;
                        case "Friend":
                            fr += count;
                            break;
                        case "Website":
                            wb += count;
                            break;
                        case "Magazine":
                            mg += count;
                            break;
                        case "Others":
                            others += count;
                            break;
                    }
                }
                jsonOutput.addProperty("status", "SUCCESS");
                jsonOutput.addProperty("facebook", fb);
                jsonOutput.addProperty("friend", fr);
                jsonOutput.addProperty("website", wb);
                jsonOutput.addProperty("magazine", mg);
                jsonOutput.addProperty("others", others);
            }else if (weekTypeGeneral.size() == 0) {
                jsonOutput.addProperty("status", "noRecord");
            } else {
                jsonOutput.addProperty("status", "error");
            }
            out.println(jsonOutput);
        }else if (opt.equals("year_general_referral")) {
            String year = request.getParameter("selyear");
            ArrayList<String[]> weekTypeGeneral = LeadDAO.getReferalTypeByYr(year);
            System.out.println("THE date IS " + year);
            System.out.println("THE SIZE IS " + weekTypeGeneral.size());
            if (weekTypeGeneral.size() > 0) {
                int fb = 0;
                int fr = 0;
                int wb = 0;
                int mg = 0;
                int others = 0;
                for (String[] rec : weekTypeGeneral) {
                    int count = Integer.parseInt(rec[0]);
                    String rBy = rec[1];
                    switch (rBy) {
                        case "Facebook":
                            fb += count;
                            break;
                        case "Friend":
                            fr += count;
                            break;
                        case "Website":
                            wb += count;
                            break;
                        case "Magazine":
                            mg += count;
                            break;
                        case "Others":
                            others += count;
                            break;
                    }
                }
                jsonOutput.addProperty("status", "SUCCESS");
                jsonOutput.addProperty("facebook", fb);
                jsonOutput.addProperty("friend", fr);
                jsonOutput.addProperty("website", wb);
                jsonOutput.addProperty("magazine", mg);
                jsonOutput.addProperty("others", others);
            }else if (weekTypeGeneral.size() == 0) {
                jsonOutput.addProperty("status", "noRecord");
            } else {
                jsonOutput.addProperty("status", "error");
            }
            out.println(jsonOutput);
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
