package com.vimbox.database;

import com.vimbox.customer.Customer;
import com.vimbox.operations.Job;
import com.vimbox.sales.Item;
import com.vimbox.sales.Lead;
import com.vimbox.sales.LeadArea;
import com.vimbox.sales.LeadDiv;
import com.vimbox.sitesurvey.SiteSurvey;
import com.vimbox.user.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public class LeadDAO {

    private static final String CREATE_LEAD_INFO = "INSERT INTO leadinfo(owner_user,lead_id,type,customer_id,tom,datetime_of_creation,status,reason,source,referral) VALUES (?,?,?,?,?,?,?,?,?,?)";
    private static final String CREATE_LEAD_ENQUIRY = "INSERT INTO leadenquiry(lead_id,enquiry) VALUES (?,?)";
    private static final String CREATE_LEAD_MOVE = "INSERT INTO leadmove VALUES (?,?,?,?,?,?)";
    private static final String CREATE_LEAD_CUST_ITEM = "INSERT INTO leadcustitem VALUES (?,?,?,?,?,?,?,?)";
    private static final String CREATE_LEAD_VIMBOX_ITEM = "INSERT INTO leadvimboxitem VALUES (?,?,?,?,?,?,?,?)";
    private static final String CREATE_LEAD_MATERIAL = "INSERT INTO leadmaterial VALUES (?,?,?,?,?,?)";
    private static final String CREATE_LEAD_OTHER = "INSERT INTO leadother VALUES (?,?,?,?)";
    private static final String CREATE_LEAD_COMMENT = "INSERT INTO leadcomment VALUES (?,?,?)";
    private static final String CREATE_LEAD_REMARK = "INSERT INTO leadremark VALUES (?,?,?)";
    private static final String CREATE_LEAD_SALES_DIV = "INSERT INTO leadsalesdiv VALUES (?,?,?,?)";
    private static final String CREATE_LEAD_CONFIRMATION = "INSERT INTO leadconfirmation VALUES (?,?,?,?,?)";
    private static final String CREATE_QUOTATION_REF = "INSERT INTO leadquotation VALUES (?,?)";

    private static final String GET_ALL_LEAD_INFO_BY_KEYWORD = "SELECT * FROM (SELECT  * FROM leadinfo ldi left outer join customers cust USING (customer_id)) joined, users urs WHERE joined.owner_user = urs.nric AND (CONCAT(joined.last_name, ' ', joined.first_name) LIKE ? OR CONCAT(urs.last_name, ' ', urs.first_name) LIKE ? OR contact LIKE ? OR email LIKE ? OR lead_id LIKE ? OR status LIKE ? OR datetime_of_creation LIKE ?)  ORDER BY datetime_of_creation DESC";
    private static final String GET_LEAD_INFO_USER = "SELECT * FROM leadinfo left outer join customers USING (customer_id) WHERE (CONCAT(last_name, ' ', first_name) LIKE ? OR type LIKE ? OR contact LIKE ? OR lead_id LIKE ? OR datetime_of_creation LIKE ?) AND owner_user=? AND status=? ORDER BY datetime_of_creation DESC";
    private static final String GET_LEAD_ENQUIRY = "SELECT * FROM leadenquiry WHERE lead_id=?";
    private static final String GET_LEAD_INFO_BY_ID = "SELECT * FROM leadinfo WHERE lead_id=?";
    private static final String GET_LEAD_MOVE_FROM = "SELECT * FROM leadmove WHERE lead_id=? AND type='from'";
    private static final String GET_LEAD_MOVE_TO = "SELECT * FROM leadmove WHERE lead_id=? AND type='to'";
    private static final String GET_LEAD_CUST_ITEM = "SELECT * FROM leadcustitem WHERE lead_id=? AND sales_div=? AND survey_area=?";
    private static final String GET_LEAD_VIMBOX_ITEM = "SELECT * FROM leadvimboxitem WHERE lead_id=? AND sales_div=? AND survey_area=?";
    private static final String GET_LEAD_MATERIAL = "SELECT * FROM leadmaterial WHERE lead_id=? AND sales_div=? AND survey_area=?";
    private static final String GET_LEAD_SERVICE = "SELECT * FROM leadservice WHERE lead_id=? AND sales_div=?";
    private static final String GET_LEAD_OTHER = "SELECT * FROM leadother WHERE lead_id=? AND sales_div=?";
    private static final String GET_LEAD_COMMENT = "SELECT * FROM leadcomment WHERE lead_id=? AND sales_div=?";
    private static final String GET_LEAD_REMARK = "SELECT * FROM leadremark WHERE lead_id=? AND sales_div=?";
    private static final String GET_LEAD_SALES_DIV = "SELECT * FROM leadsalesdiv WHERE lead_id=?";
    private static final String GET_LEAD_CONFIRMATION = "SELECT * FROM leadconfirmation WHERE lead_id=?";
    private static final String GET_QUOTATION_SERVICE = "SELECT * FROM leadquotation WHERE ref_num=?";
     private static final String GET_WEEK_LEAD_CONFIRMATION = "SELECT lc.`lead_id`, lc.`total_amount`, DAYNAME(li.`datetime_of_creation`) as name_of_day FROM `leadconfirmation`as lc inner join `leadinfo` li on lc.`lead_id` = li.`lead_id` where lc.`lead_id` in (SELECT `lead_id` FROM `leadinfo` WHERE YEARWEEK(`datetime_of_creation`, 1)=YEARWEEK(?, 1)) ORDER BY name_of_day ASC";
    private static final String GET_MTH_LEAD_CONFIRMATION = "SELECT lc.`lead_id`, lc.`total_amount`, MONTHNAME(li.`datetime_of_creation`) as month_name FROM `leadconfirmation`as lc inner join `leadinfo` li on lc.`lead_id` = li.`lead_id` where lc.`lead_id` in (SELECT `lead_id` FROM `leadinfo` WHERE  YEAR(`datetime_of_creation`)=YEAR(NOW())) ORDER BY month_name ASC";
    private static final String GET_YR_LEAD_CONFIRMATION = "SELECT lc.`lead_id`, lc.`total_amount`, MONTHNAME(li.`datetime_of_creation`) as month_name FROM `leadconfirmation`as lc inner join `leadinfo` li on lc.`lead_id` = li.`lead_id` where lc.`lead_id` in (SELECT `lead_id` FROM `leadinfo` WHERE  YEAR(`datetime_of_creation`) = ?) ORDER BY month_name ASC;  ";

    private static final String DELETE_LEAD_INFO = "DELETE FROM leadinfo WHERE lead_id=?";
    private static final String DELETE_LEAD_ENQUIRY = "DELETE FROM leadenquiry WHERE lead_id=?";
    private static final String DELETE_LEAD_MOVE = "DELETE FROM leadmove WHERE lead_id=?";
    private static final String DELETE_LEAD_CUST_ITEM = "DELETE FROM leadcustitem WHERE lead_id=?";
    private static final String DELETE_SITE_LEAD_CUST_ITEM = "DELETE FROM leadcustitem WHERE lead_id=? AND sales_div=? AND survey_area=?";
    private static final String DELETE_LEAD_VIMBOX_ITEM = "DELETE FROM leadvimboxitem WHERE lead_id=?";
    private static final String DELETE_SITE_LEAD_VIMBOX_ITEM = "DELETE FROM leadvimboxitem WHERE lead_id=? AND sales_div=? AND survey_area=?";
    private static final String DELETE_SITE_LEAD_MATERIAL = "DELETE FROM leadmaterial WHERE lead_id=? AND sales_div=? AND survey_area=?";
    private static final String DELETE_LEAD_MATERIAL = "DELETE FROM leadmaterial WHERE lead_id=?";
    private static final String DELETE_LEAD_SERVICE = "DELETE FROM leadservice WHERE lead_id=?";
    private static final String DELETE_LEAD_OTHER = "DELETE FROM leadother WHERE lead_id=?";
    private static final String DELETE_LEAD_COMMENT = "DELETE FROM leadcomment WHERE lead_id=?";
    private static final String DELETE_LEAD_REMARK = "DELETE FROM leadremark WHERE lead_id=?";
    private static final String DELETE_LEAD_SALES_DIV = "DELETE FROM leadsalesdiv WHERE lead_id=?";
    private static final String CANCEL_LEAD = "UPDATE leadinfo SET status=?, reason=? WHERE lead_id=?";
    private static final String DELETE_SITE_LEAD_COMMENT = "DELETE FROM leadcomment WHERE lead_id=? AND sales_div=?";

    private static final String UPDATE_LEAD_CONFIRMATION_COLLECTED = "UPDATE leadconfirmation SET collected_amount=? WHERE lead_id=?";
    private static final String CONFIRM_LEAD = "UPDATE leadconfirmation SET confirmed_user=?, collected_amount=?, email_path=? WHERE lead_id=?";
    private static final String CONFIRM_LEAD_STATUS = "UPDATE leadinfo SET status='Confirmed' WHERE lead_id=?";
    private static final String REOPEN_LEAD_STATUS = "UPDATE leadinfo SET status='Pending' WHERE lead_id=?";
    private static final String UPDATE_LEAD_CONFIRMATION = "UPDATE leadconfirmation SET total_amount=? WHERE lead_id=?";
    private static final String UPDATE_ADDRESS = "UPDATE leadmove SET storeys=?, pushing=? WHERE lead_id=? AND sales_div=?";
    private static final String UPDATE_LEAD_OTHER = "UPDATE leadother SET charge=? WHERE lead_id=? AND sales_div=? AND other=?";
    private static final String UPDATE_LEAD_SALES_DIV = "UPDATE leadsalesdiv SET survey_area=?, survey_area_name=? WHERE lead_id=? AND sales_div=?";
    private static final String GET_LEAD_SERVICES_BY_LEADID = "SELECT * FROM leadservice WHERE lead_id=?";
    private static final String UPDATE_QUOTATION_SERVICE = "UPDATE leadquotation SET service_include=? WHERE ref_num=?";

    public static void deleteLead(int leadId) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(DELETE_LEAD_INFO);
            ps.setInt(1, leadId);
            ps.executeUpdate();
            ps = con.prepareStatement(DELETE_LEAD_ENQUIRY);
            ps.setInt(1, leadId);
            ps.executeUpdate();
            ps = con.prepareStatement(DELETE_LEAD_MOVE);
            ps.setInt(1, leadId);
            ps.executeUpdate();
            ps = con.prepareStatement(DELETE_LEAD_CUST_ITEM);
            ps.setInt(1, leadId);
            ps.executeUpdate();
            ps = con.prepareStatement(DELETE_LEAD_VIMBOX_ITEM);
            ps.setInt(1, leadId);
            ps.executeUpdate();
            ps = con.prepareStatement(DELETE_LEAD_MATERIAL);
            ps.setInt(1, leadId);
            ps.executeUpdate();
            ps = con.prepareStatement(DELETE_LEAD_SERVICE);
            ps.setInt(1, leadId);
            ps.executeUpdate();
            ps = con.prepareStatement(DELETE_LEAD_OTHER);
            ps.setInt(1, leadId);
            ps.executeUpdate();
            ps = con.prepareStatement(DELETE_LEAD_COMMENT);
            ps.setInt(1, leadId);
            ps.executeUpdate();
            ps = con.prepareStatement(DELETE_LEAD_REMARK);
            ps.setInt(1, leadId);
            ps.executeUpdate();
            ps = con.prepareStatement(DELETE_LEAD_SALES_DIV);
            ps.setInt(1, leadId);
            ps.executeUpdate();
            SiteSurveyDAO.deleteSiteSurveysByLeadId(leadId);
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static double getLeadConfirmedTotal(int leadId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_LEAD_CONFIRMATION);
            ps.setInt(1, leadId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total_amount");
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return 0;
    }

    public static String getLeadConfirmedEmail(int leadId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_LEAD_CONFIRMATION);
            ps.setInt(1, leadId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("email_path");
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return null;
    }

    public static double getLeadConfirmedCollected(int leadId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_LEAD_CONFIRMATION);
            ps.setInt(1, leadId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("collected_amount");
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return 0;
    }

    public static ArrayList<Lead> getAllLeadsByKeyword(String keyword) {
        ArrayList<Lead> results = new ArrayList<Lead>();
        DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ResultSet rs1 = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_ALL_LEAD_INFO_BY_KEYWORD);
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");
            ps.setString(4, "%" + keyword + "%");
            ps.setString(5, "%" + keyword + "%");
            ps.setString(6, "%" + keyword + "%");
            ps.setString(7, "%" + keyword + "%");

            rs = ps.executeQuery();
            while (rs.next()) {
                // Lead Info //
                User user = UserDAO.getUserByNRIC(rs.getString("owner_user"));
                int leadId = Integer.parseInt(rs.getString("lead_id"));
                String type = rs.getString("type");
                int custId = rs.getInt("customer_id");
                Customer customer = CustomerDAO.getCustomerById(custId);
                String tom = rs.getString("tom");
                ArrayList<Job> jobs = JobDAO.getJobsByLeadId(leadId);
                String tempDateTimeString = rs.getString("datetime_of_creation");
                String datetimeString = tempDateTimeString.substring(0, tempDateTimeString.lastIndexOf("."));
                DateTime dt = formatter.parseDateTime(datetimeString);
                String status = rs.getString("status");
                String reason = rs.getString("reason");
                String source = rs.getString("source");
                String referral = rs.getString("referral");

                String enquiry = "";
                ps = con.prepareStatement(GET_LEAD_ENQUIRY);
                ps.setInt(1, leadId);
                rs1 = ps.executeQuery();
                if (rs1.next()) {
                    enquiry = rs1.getString("enquiry");
                }

                ArrayList<String[]> addressFrom = new ArrayList<String[]>();
                ps = con.prepareStatement(GET_LEAD_MOVE_FROM);
                ps.setInt(1, leadId);
                rs1 = ps.executeQuery();
                while (rs1.next()) {
                    String address = rs1.getString("address");
                    String storeys = rs1.getString("storeys");
                    String pushing = rs1.getString("pushing");
                    addressFrom.add(new String[]{address, storeys, pushing});
                }

                ArrayList<String[]> addressTo = new ArrayList<String[]>();
                ps = con.prepareStatement(GET_LEAD_MOVE_TO);
                ps.setInt(1, leadId);
                rs1 = ps.executeQuery();
                while (rs1.next()) {
                    String address = rs1.getString("address");
                    String storeys = rs1.getString("storeys");
                    String pushing = rs1.getString("pushing");
                    addressTo.add(new String[]{address, storeys, pushing});
                }

                // Get the salesDivs //
                HashMap<String, String[]> salesDivs = new HashMap<String, String[]>();
                ps = con.prepareStatement(GET_LEAD_SALES_DIV);
                ps.setInt(1, leadId);
                rs1 = ps.executeQuery();
                while (rs1.next()) {
                    salesDivs.put(rs1.getString("sales_div"), new String[]{rs1.getString("survey_area"), rs1.getString("survey_area_name")});
                }

                ArrayList<LeadDiv> leadDivs = new ArrayList<LeadDiv>();
                for (Map.Entry<String, String[]> entry : salesDivs.entrySet()) {
                    String salesDiv = entry.getKey();
                    String[] survey = entry.getValue();

                    String[] surveyAreas = survey[0].split("\\|");
                    String[] surveyAreaNames = survey[1].split("\\|");

                    ArrayList<LeadArea> leadAreas = new ArrayList<LeadArea>();
                    for (int j = 0; j < surveyAreas.length; j++) {
                        String leadAreaDiv = surveyAreas[j];
                        String leadName = surveyAreas[j];
                        // Customer Items //
                        ArrayList<Item> customerItems = new ArrayList<Item>();
                        ps = con.prepareStatement(GET_LEAD_CUST_ITEM);
                        ps.setInt(1, leadId);
                        ps.setString(2, salesDiv);
                        ps.setString(3, leadAreaDiv);
                        rs1 = ps.executeQuery();
                        while (rs1.next()) {
                            String itemName = rs1.getString("itemname");
                            String itemRemark = rs1.getString("itemremark");
                            String itemCharge = rs1.getString("itemcharge");
                            double charge;
                            if (itemCharge.trim().isEmpty()) {
                                charge = 0.0;
                            } else {
                                charge = Double.parseDouble(itemCharge);
                            }
                            String itemQty = rs1.getString("itemqty");
                            double qty;
                            if (itemQty.isEmpty()) {
                                qty = 0;
                            } else {
                                qty = Double.parseDouble(itemQty);
                            }
                            String itemUnit = rs1.getString("itemunit");
                            double unit;
                            if (itemUnit.isEmpty()) {
                                unit = 0;
                            } else {
                                unit = Double.parseDouble(itemUnit);
                            }
                            customerItems.add(new Item(itemName, itemRemark, charge, unit, qty));
                        }

                        // Vimbox Items //
                        ArrayList<Item> vimboxItems = new ArrayList<Item>();
                        ps = con.prepareStatement(GET_LEAD_VIMBOX_ITEM);
                        ps.setInt(1, leadId);
                        ps.setString(2, salesDiv);
                        ps.setString(3, leadAreaDiv);
                        rs1 = ps.executeQuery();
                        while (rs1.next()) {
                            String itemName = rs1.getString("itemname");
                            String itemRemark = rs1.getString("itemremark");
                            String itemCharge = rs1.getString("itemcharge");
                            double charge;
                            if (itemCharge.isEmpty()) {
                                charge = 0.0;
                            } else {
                                charge = Double.parseDouble(itemCharge);
                            }
                            String itemQty = rs1.getString("itemqty");
                            double qty;
                            if (itemQty.isEmpty()) {
                                qty = 0;
                            } else {
                                qty = Double.parseDouble(itemQty);
                            }
                            String itemUnit = rs1.getString("itemunit");
                            double unit;
                            if (itemUnit.isEmpty()) {
                                unit = 0;
                            } else {
                                unit = Double.parseDouble(itemUnit);
                            }
                            vimboxItems.add(new Item(itemName, itemRemark, charge, unit, qty));
                        }

                        // Vimbox Materials //
                        ArrayList<Item> materials = new ArrayList<Item>();
                        ps = con.prepareStatement(GET_LEAD_MATERIAL);
                        ps.setInt(1, leadId);
                        ps.setString(2, salesDiv);
                        ps.setString(3, leadAreaDiv);
                        rs1 = ps.executeQuery();
                        while (rs1.next()) {
                            String itemName = rs1.getString("materialname");
                            String itemCharge = rs1.getString("materialcharge");
                            double charge;
                            if (itemCharge.isEmpty()) {
                                charge = 0.0;
                            } else {
                                charge = Double.parseDouble(itemCharge);
                            }
                            String itemQty = rs1.getString("materialqty");
                            double qty;
                            if (itemQty.isEmpty()) {
                                qty = 0;
                            } else {
                                qty = Double.parseDouble(itemQty);
                            }
                            materials.add(new Item(itemName, "", charge, 0, qty));
                        }
                        leadAreas.add(new LeadArea(leadAreaDiv, leadName, customerItems, vimboxItems, materials));
                    }

                    // Services //
                    ArrayList<String[]> services = new ArrayList<String[]>();
                    ps = con.prepareStatement(GET_LEAD_SERVICE);
                    ps.setInt(1, leadId);
                    ps.setString(2, salesDiv);
                    rs1 = ps.executeQuery();
                    while (rs1.next()) {
                        String serviceName = rs1.getString("service");
                        String serviceCharge = rs1.getString("charge");
                        String[] svc = serviceName.split("_");
                        String secSvc = "";
                        for (int i = 1; i < svc.length; i++) {
                            secSvc += (svc[i]);
                            if (i < svc.length - 1) {
                                secSvc += " ";
                            }
                        }
                        String formula = LeadPopulationDAO.getServiceFormula(svc[0], secSvc);
                        String serviceMp = rs1.getString("manpower");
                        String serviceRm = rs1.getString("remarks");
                        services.add(new String[]{serviceName, serviceCharge, formula, serviceMp, serviceRm});
                    }

                    // Other Charges // 
                    HashMap<String, String> otherCharges = new HashMap<String, String>();
                    ps = con.prepareStatement(GET_LEAD_OTHER);
                    ps.setInt(1, leadId);
                    ps.setString(2, salesDiv);
                    rs1 = ps.executeQuery();
                    while (rs1.next()) {
                        String serviceName = rs1.getString("other");
                        String serviceCharge = rs1.getString("charge");
                        otherCharges.put(serviceName, serviceCharge);
                    }

                    // Customer comments //
                    ArrayList<String> comments = new ArrayList<String>();
                    ps = con.prepareStatement(GET_LEAD_COMMENT);
                    ps.setInt(1, leadId);
                    ps.setString(2, salesDiv);
                    rs1 = ps.executeQuery();
                    while (rs1.next()) {
                        String comment = rs1.getString("comment");
                        comments.add(comment);
                    }

                    // Customer Remarks //
                    ArrayList<String> remarks = new ArrayList<String>();
                    ps = con.prepareStatement(GET_LEAD_REMARK);
                    ps.setInt(1, leadId);
                    ps.setString(2, salesDiv);
                    rs1 = ps.executeQuery();
                    while (rs1.next()) {
                        String remark = rs1.getString("remark");
                        remarks.add(remark);
                    }

                    leadDivs.add(new LeadDiv(salesDiv, leadAreas, services, otherCharges, comments, remarks));
                }

                ArrayList<SiteSurvey> siteSurveys = SiteSurveyDAO.getSiteSurveysByLeadId(leadId);
                results.add(new Lead(user, leadId, type, customer, status, reason, source, referral, enquiry, siteSurveys, dt, tom, jobs, addressFrom, addressTo, leadDivs));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
            ConnectionManager.close(null, null, rs1);
        }
        return results;
    }

    public static ArrayList<Lead> getLeadsByOwnerUser(String keyword, String nric, String queryStatus) {
        ArrayList<Lead> results = new ArrayList<Lead>();
        DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ResultSet rs1 = null;
        User user = UserDAO.getUserByNRIC(nric);
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_LEAD_INFO_USER);
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");
            ps.setString(4, "%" + keyword + "%");
            ps.setString(5, "%" + keyword + "%");
            ps.setString(6, nric);
            ps.setString(7, queryStatus);

            rs = ps.executeQuery();
            while (rs.next()) {
                // Lead Info //
                int leadId = Integer.parseInt(rs.getString("lead_id"));
                String type = rs.getString("type");
                int custId = rs.getInt("customer_id");
                Customer customer = CustomerDAO.getCustomerById(custId);
                String tom = rs.getString("tom");
                ArrayList<Job> jobs = JobDAO.getJobsByLeadId(leadId);
                String tempDateTimeString = rs.getString("datetime_of_creation");
                String datetimeString = tempDateTimeString.substring(0, tempDateTimeString.lastIndexOf("."));
                DateTime dt = formatter.parseDateTime(datetimeString);
                String status = rs.getString("status");
                String reason = rs.getString("reason");
                String source = rs.getString("source");
                String referral = rs.getString("referral");

                String enquiry = "";
                ps = con.prepareStatement(GET_LEAD_ENQUIRY);
                ps.setInt(1, leadId);
                rs1 = ps.executeQuery();
                if (rs1.next()) {
                    enquiry = rs1.getString("enquiry");
                }

                ArrayList<String[]> addressFrom = new ArrayList<String[]>();
                ps = con.prepareStatement(GET_LEAD_MOVE_FROM);
                ps.setInt(1, leadId);
                rs1 = ps.executeQuery();
                while (rs1.next()) {
                    String address = rs1.getString("address");
                    String storeys = rs1.getString("storeys");
                    String pushing = rs1.getString("pushing");
                    addressFrom.add(new String[]{address, storeys, pushing});
                }

                ArrayList<String[]> addressTo = new ArrayList<String[]>();
                ps = con.prepareStatement(GET_LEAD_MOVE_TO);
                ps.setInt(1, leadId);
                rs1 = ps.executeQuery();
                while (rs1.next()) {
                    String address = rs1.getString("address");
                    String storeys = rs1.getString("storeys");
                    String pushing = rs1.getString("pushing");
                    addressTo.add(new String[]{address, storeys, pushing});
                }

                // Get the salesDivs //
                HashMap<String, String[]> salesDivs = new HashMap<String, String[]>();
                ps = con.prepareStatement(GET_LEAD_SALES_DIV);
                ps.setInt(1, leadId);
                rs1 = ps.executeQuery();
                while (rs1.next()) {
                    salesDivs.put(rs1.getString("sales_div"), new String[]{rs1.getString("survey_area"), rs1.getString("survey_area_name")});
                }

                ArrayList<LeadDiv> leadDivs = new ArrayList<LeadDiv>();
                for (Map.Entry<String, String[]> entry : salesDivs.entrySet()) {
                    String salesDiv = entry.getKey();
                    String[] survey = entry.getValue();

                    String[] surveyAreas = survey[0].split("\\|");
                    String[] surveyAreaNames = survey[1].split("\\|");

                    ArrayList<LeadArea> leadAreas = new ArrayList<LeadArea>();
                    for (int j = 0; j < surveyAreas.length; j++) {
                        String leadAreaDiv = surveyAreas[j];
                        String leadName = surveyAreas[j];
                        // Customer Items //
                        ArrayList<Item> customerItems = new ArrayList<Item>();
                        ps = con.prepareStatement(GET_LEAD_CUST_ITEM);
                        ps.setInt(1, leadId);
                        ps.setString(2, salesDiv);
                        ps.setString(3, leadAreaDiv);
                        rs1 = ps.executeQuery();
                        while (rs1.next()) {
                            String itemName = rs1.getString("itemname");
                            String itemRemark = rs1.getString("itemremark");
                            String itemCharge = rs1.getString("itemcharge");
                            double charge;
                            if (itemCharge.trim().isEmpty()) {
                                charge = 0.0;
                            } else {
                                charge = Double.parseDouble(itemCharge);
                            }
                            String itemQty = rs1.getString("itemqty");
                            double qty;
                            if (itemQty.isEmpty()) {
                                qty = 0;
                            } else {
                                qty = Double.parseDouble(itemQty);
                            }
                            String itemUnit = rs1.getString("itemunit");
                            double unit;
                            if (itemUnit.isEmpty()) {
                                unit = 0;
                            } else {
                                unit = Double.parseDouble(itemUnit);
                            }
                            customerItems.add(new Item(itemName, itemRemark, charge, unit, qty));
                        }

                        // Vimbox Items //
                        ArrayList<Item> vimboxItems = new ArrayList<Item>();
                        ps = con.prepareStatement(GET_LEAD_VIMBOX_ITEM);
                        ps.setInt(1, leadId);
                        ps.setString(2, salesDiv);
                        ps.setString(3, leadAreaDiv);
                        rs1 = ps.executeQuery();
                        while (rs1.next()) {
                            String itemName = rs1.getString("itemname");
                            String itemRemark = rs1.getString("itemremark");
                            String itemCharge = rs1.getString("itemcharge");
                            double charge;
                            if (itemCharge.isEmpty()) {
                                charge = 0.0;
                            } else {
                                charge = Double.parseDouble(itemCharge);
                            }
                            String itemQty = rs1.getString("itemqty");
                            double qty;
                            if (itemQty.isEmpty()) {
                                qty = 0;
                            } else {
                                qty = Double.parseDouble(itemQty);
                            }
                            String itemUnit = rs1.getString("itemunit");
                            double unit;
                            if (itemUnit.isEmpty()) {
                                unit = 0;
                            } else {
                                unit = Double.parseDouble(itemUnit);
                            }
                            vimboxItems.add(new Item(itemName, itemRemark, charge, unit, qty));
                        }

                        // Vimbox Materials //
                        ArrayList<Item> materials = new ArrayList<Item>();
                        ps = con.prepareStatement(GET_LEAD_MATERIAL);
                        ps.setInt(1, leadId);
                        ps.setString(2, salesDiv);
                        ps.setString(3, leadAreaDiv);
                        rs1 = ps.executeQuery();
                        while (rs1.next()) {
                            String itemName = rs1.getString("materialname");
                            String itemCharge = rs1.getString("materialcharge");
                            double charge;
                            if (itemCharge.isEmpty()) {
                                charge = 0.0;
                            } else {
                                charge = Double.parseDouble(itemCharge);
                            }
                            String itemQty = rs1.getString("materialqty");
                            double qty;
                            if (itemQty.isEmpty()) {
                                qty = 0;
                            } else {
                                qty = Double.parseDouble(itemQty);
                            }
                            materials.add(new Item(itemName, "", charge, 0, qty));
                        }
                        leadAreas.add(new LeadArea(leadAreaDiv, leadName, customerItems, vimboxItems, materials));
                    }

                    // Services //
                    ArrayList<String[]> services = new ArrayList<String[]>();
                    ps = con.prepareStatement(GET_LEAD_SERVICE);
                    ps.setInt(1, leadId);
                    ps.setString(2, salesDiv);
                    rs1 = ps.executeQuery();
                    while (rs1.next()) {
                        String serviceName = rs1.getString("service");
                        String serviceCharge = rs1.getString("charge");
                        String[] svc = serviceName.split("_");
                        String secSvc = "";
                        for (int i = 1; i < svc.length; i++) {
                            secSvc += (svc[i]);
                            if (i < svc.length - 1) {
                                secSvc += " ";
                            }
                        }
                        String formula = LeadPopulationDAO.getServiceFormula(svc[0], secSvc);
                        String serviceMp = rs1.getString("manpower");
                        String serviceRm = rs1.getString("remarks");
                        services.add(new String[]{serviceName, serviceCharge, formula, serviceMp, serviceRm});
                    }

                    // Other Charges // 
                    HashMap<String, String> otherCharges = new HashMap<String, String>();
                    ps = con.prepareStatement(GET_LEAD_OTHER);
                    ps.setInt(1, leadId);
                    ps.setString(2, salesDiv);
                    rs1 = ps.executeQuery();
                    while (rs1.next()) {
                        String serviceName = rs1.getString("other");
                        String serviceCharge = rs1.getString("charge");
                        otherCharges.put(serviceName, serviceCharge);
                    }

                    // Customer comments //
                    ArrayList<String> comments = new ArrayList<String>();
                    ps = con.prepareStatement(GET_LEAD_COMMENT);
                    ps.setInt(1, leadId);
                    ps.setString(2, salesDiv);
                    rs1 = ps.executeQuery();
                    while (rs1.next()) {
                        String comment = rs1.getString("comment");
                        comments.add(comment);
                    }

                    // Customer Remarks //
                    ArrayList<String> remarks = new ArrayList<String>();
                    ps = con.prepareStatement(GET_LEAD_REMARK);
                    ps.setInt(1, leadId);
                    ps.setString(2, salesDiv);
                    rs1 = ps.executeQuery();
                    while (rs1.next()) {
                        String remark = rs1.getString("remark");
                        remarks.add(remark);
                    }

                    leadDivs.add(new LeadDiv(salesDiv, leadAreas, services, otherCharges, comments, remarks));
                }

                ArrayList<SiteSurvey> siteSurveys = SiteSurveyDAO.getSiteSurveysByLeadId(leadId);
                results.add(new Lead(user, leadId, type, customer, status, reason, source, referral, enquiry, siteSurveys, dt, tom, jobs, addressFrom, addressTo, leadDivs));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
            ConnectionManager.close(null, null, rs1);
        }
        return results;
    }

    public static Lead getLeadById(int leadId) {
        Lead lead = null;
        DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_LEAD_INFO_BY_ID);
            ps.setInt(1, leadId);
            rs = ps.executeQuery();
            if (rs.next()) {
                // Lead Info //
                String nric = rs.getString("owner_user");
                User user = UserDAO.getUserByNRIC(nric);
                String type = rs.getString("type");
                int custId = rs.getInt("customer_id");
                Customer customer = CustomerDAO.getCustomerById(custId);
                String tom = rs.getString("tom");
                ArrayList<Job> jobs = JobDAO.getJobsByLeadId(leadId);
                String tempDateTimeString = rs.getString("datetime_of_creation");
                String datetimeString = tempDateTimeString.substring(0, tempDateTimeString.lastIndexOf("."));
                DateTime dt = formatter.parseDateTime(datetimeString);
                String status = rs.getString("status");
                String reason = rs.getString("reason");
                String source = rs.getString("source");
                String referral = rs.getString("referral");

                String enquiry = "";
                ps = con.prepareStatement(GET_LEAD_ENQUIRY);
                ps.setInt(1, leadId);
                rs = ps.executeQuery();
                if (rs.next()) {
                    enquiry = rs.getString("enquiry");
                }

                ArrayList<String[]> addressFrom = new ArrayList<String[]>();
                ps = con.prepareStatement(GET_LEAD_MOVE_FROM);
                ps.setInt(1, leadId);
                rs = ps.executeQuery();
                while (rs.next()) {
                    String address = rs.getString("address");
                    String storeys = rs.getString("storeys");
                    String pushing = rs.getString("pushing");
                    addressFrom.add(new String[]{address, storeys, pushing});
                }

                ArrayList<String[]> addressTo = new ArrayList<String[]>();
                ps = con.prepareStatement(GET_LEAD_MOVE_TO);
                ps.setInt(1, leadId);
                rs = ps.executeQuery();
                while (rs.next()) {
                    String address = rs.getString("address");
                    String storeys = rs.getString("storeys");
                    String pushing = rs.getString("pushing");
                    addressTo.add(new String[]{address, storeys, pushing});
                }

                // Get the salesDivs //
                HashMap<String, String[]> salesDivs = new HashMap<String, String[]>();
                ps = con.prepareStatement(GET_LEAD_SALES_DIV);
                ps.setInt(1, leadId);
                rs = ps.executeQuery();
                while (rs.next()) {
                    salesDivs.put(rs.getString("sales_div"), new String[]{rs.getString("survey_area"), rs.getString("survey_area_name")});

                }

                ArrayList<LeadDiv> leadDivs = new ArrayList<LeadDiv>();
                for (Map.Entry<String, String[]> entry : salesDivs.entrySet()) {
                    String salesDiv = entry.getKey();
                    String[] survey = entry.getValue();
                    String[] surveyAreas = survey[0].split("\\|");
                    String[] surveyAreaNames = survey[1].split("\\|");
                    ArrayList<LeadArea> leadAreas = new ArrayList<LeadArea>();

                    for (int i = 0; i < surveyAreas.length; i++) {
                        String leadAreaDiv = surveyAreas[i];
                        String leadName = surveyAreaNames[i];
                        // Customer Items //
                        ArrayList<Item> customerItems = new ArrayList<Item>();
                        ps = con.prepareStatement(GET_LEAD_CUST_ITEM);
                        ps.setInt(1, leadId);
                        ps.setString(2, salesDiv);
                        ps.setString(3, leadAreaDiv);
                        rs = ps.executeQuery();
                        while (rs.next()) {
                            String itemName = rs.getString("itemname");
                            String itemRemark = rs.getString("itemremark");
                            String itemCharge = rs.getString("itemcharge");
                            double charge;
                            if (itemCharge.isEmpty()) {
                                charge = 0.0;
                            } else {
                                charge = Double.parseDouble(itemCharge);
                            }
                            String itemQty = rs.getString("itemqty");
                            double qty;
                            if (itemQty.isEmpty()) {
                                qty = 0;
                            } else {
                                qty = Double.parseDouble(itemQty);
                            }
                            String itemUnit = rs.getString("itemunit");
                            double unit;
                            if (itemUnit.isEmpty()) {
                                unit = 0;
                            } else {
                                unit = Double.parseDouble(itemUnit);
                            }
                            customerItems.add(new Item(itemName, itemRemark, charge, unit, qty));
                        }

                        // Vimbox Items //
                        ArrayList<Item> vimboxItems = new ArrayList<Item>();
                        ps = con.prepareStatement(GET_LEAD_VIMBOX_ITEM);
                        ps.setInt(1, leadId);
                        ps.setString(2, salesDiv);
                        ps.setString(3, leadAreaDiv);
                        rs = ps.executeQuery();
                        while (rs.next()) {
                            String itemName = rs.getString("itemname");
                            String itemRemark = rs.getString("itemremark");
                            String itemCharge = rs.getString("itemcharge");
                            double charge;
                            if (itemCharge.isEmpty()) {
                                charge = 0.0;
                            } else {
                                charge = Double.parseDouble(itemCharge);
                            }
                            String itemQty = rs.getString("itemqty");
                            double qty;
                            if (itemQty.isEmpty()) {
                                qty = 0;
                            } else {
                                qty = Double.parseDouble(itemQty);
                            }
                            String itemUnit = rs.getString("itemunit");
                            double unit;
                            if (itemUnit.isEmpty()) {
                                unit = 0;
                            } else {
                                unit = Double.parseDouble(itemUnit);
                            }
                            vimboxItems.add(new Item(itemName, itemRemark, charge, unit, qty));
                        }

                        // Vimbox Materials //
                        ArrayList<Item> materials = new ArrayList<Item>();
                        ps = con.prepareStatement(GET_LEAD_MATERIAL);
                        ps.setInt(1, leadId);
                        ps.setString(2, salesDiv);
                        ps.setString(3, leadAreaDiv);
                        rs = ps.executeQuery();
                        while (rs.next()) {
                            String itemName = rs.getString("materialname");
                            String itemCharge = rs.getString("materialcharge");
                            double charge;
                            if (itemCharge.isEmpty()) {
                                charge = 0.0;
                            } else {
                                charge = Double.parseDouble(itemCharge);
                            }
                            String itemQty = rs.getString("materialqty");
                            double qty;
                            if (itemQty.isEmpty()) {
                                qty = 0;
                            } else {
                                qty = Double.parseDouble(itemQty);
                            }
                            materials.add(new Item(itemName, "", charge, 0, qty));
                        }

                        leadAreas.add(new LeadArea(leadAreaDiv, leadName, customerItems, vimboxItems, materials));
                    }

                    // Services //
                    ArrayList<String[]> services = new ArrayList<String[]>();
                    ps = con.prepareStatement(GET_LEAD_SERVICE);
                    ps.setInt(1, leadId);
                    ps.setString(2, salesDiv);
                    rs = ps.executeQuery();
                    while (rs.next()) {
                        String serviceName = rs.getString("service");
                        String serviceCharge = rs.getString("charge");
                        String[] svc = serviceName.split("_");
                        String secSvc = "";
                        for (int i = 1; i < svc.length; i++) {
                            secSvc += (svc[i]);
                            if (i < svc.length - 1) {
                                secSvc += " ";
                            }
                        }
                        String formula = LeadPopulationDAO.getServiceFormula(svc[0], secSvc);
                        String serviceMp = rs.getString("manpower");
                        String serviceRm = rs.getString("remarks");
                        services.add(new String[]{serviceName, serviceCharge, formula, serviceMp, serviceRm});
                    }

                    // Other Charges // 
                    HashMap<String, String> otherCharges = new HashMap<String, String>();
                    ps = con.prepareStatement(GET_LEAD_OTHER);
                    ps.setInt(1, leadId);
                    ps.setString(2, salesDiv);
                    rs = ps.executeQuery();
                    while (rs.next()) {
                        String serviceName = rs.getString("other");
                        String serviceCharge = rs.getString("charge");
                        otherCharges.put(serviceName, serviceCharge);
                    }

                    // Customer comments //
                    ArrayList<String> comments = new ArrayList<String>();
                    ps = con.prepareStatement(GET_LEAD_COMMENT);
                    ps.setInt(1, leadId);
                    ps.setString(2, salesDiv);
                    rs = ps.executeQuery();
                    while (rs.next()) {
                        String comment = rs.getString("comment");
                        comments.add(comment);
                    }

                    // Customer Remarks //
                    ArrayList<String> remarks = new ArrayList<String>();
                    ps = con.prepareStatement(GET_LEAD_REMARK);
                    ps.setInt(1, leadId);
                    ps.setString(2, salesDiv);
                    rs = ps.executeQuery();
                    while (rs.next()) {
                        String remark = rs.getString("remark");
                        remarks.add(remark);
                    }

                    leadDivs.add(new LeadDiv(salesDiv, leadAreas, services, otherCharges, comments, remarks));
                }

                ArrayList<SiteSurvey> siteSurveys = SiteSurveyDAO.getSiteSurveysByLeadId(leadId);
                lead = new Lead(user, leadId, type, customer, status, reason, source, referral, enquiry, siteSurveys, dt, tom, jobs, addressFrom, addressTo, leadDivs);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return lead;
    }

    public static void createLeadInfo(User owner, int leadId, String type, int custId, String typesOfMove, String dt, String status, String source, String referral) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_LEAD_INFO);
            ps.setString(1, owner.getNric());
            ps.setInt(2, leadId);
            ps.setString(3, type);
            ps.setInt(4, custId);
            ps.setString(5, typesOfMove);
            ps.setString(6, dt);
            ps.setString(7, status);
            ps.setString(8, "");
            ps.setString(9, source);
            ps.setString(10, referral);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createLeadMove(int leadId, ArrayList<String> salesDivs, String type, ArrayList<String> addresses, ArrayList<String> storeys, ArrayList<String> pushings) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_LEAD_MOVE);
            for (int i = 0; i < addresses.size(); i++) {
                String salesDiv = salesDivs.get(i);
                String address = addresses.get(i);
                String storey = storeys.get(i);
                String pushing = pushings.get(i);
                try {
                    ps.setInt(1, leadId);
                    ps.setString(2, salesDiv);
                    ps.setString(3, type);
                    ps.setString(4, address);
                    ps.setString(5, storey);
                    ps.setString(6, pushing);
                    ps.executeUpdate();
                } catch (SQLException se) {
                    se.printStackTrace();
                }
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createLeadEnquiry(int leadId, String enquiry) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_LEAD_ENQUIRY);
            ps.setInt(1, leadId);
            ps.setString(2, enquiry);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createLeadSalesDiv(int leadId, String[] salesDivs) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            for (String salesDiv : salesDivs) {
                ps = con.prepareStatement(CREATE_LEAD_SALES_DIV);
                ps.setInt(1, leadId);
                ps.setString(2, salesDiv);
                ps.setString(3, "");
                ps.setString(4, "");
                ps.executeUpdate();
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createLeadCustItem(int leadId, String salesDiv, String[] custItemNames, String[] custItemRemarks, String[] custItemCharges, String[] custItemQtys, String[] custItemUnits) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_LEAD_CUST_ITEM);
            for (int i = 0; i < custItemNames.length; i++) {
                String itemName = custItemNames[i];
                String itemRemark = custItemRemarks[i];
                String itemCharge = custItemCharges[i];
                String itemQty = custItemQtys[i];
                String itemUnit = custItemUnits[i];
                try {
                    ps.setInt(1, leadId);
                    ps.setString(2, salesDiv);
                    ps.setString(3, "");
                    ps.setString(4, itemName);
                    ps.setString(5, itemRemark);
                    ps.setString(6, itemCharge);
                    ps.setString(7, itemQty);
                    ps.setString(8, itemUnit);
                    ps.executeUpdate();
                } catch (SQLException se) {
                    se.printStackTrace();
                }
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createSiteLeadCustItem(int leadId, String salesDiv, String surveyArea, String[] custItemNames, String[] custItemRemarks, String[] custItemCharges, String[] custItemQtys, String[] custItemUnits) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            System.out.println(surveyArea);
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(DELETE_SITE_LEAD_CUST_ITEM);
            ps.setInt(1, leadId);
            ps.setString(2, salesDiv);
            ps.setString(3, surveyArea);
            ps.executeUpdate();

            ps = con.prepareStatement(CREATE_LEAD_CUST_ITEM);
            for (int i = 0; i < custItemNames.length; i++) {
                String itemName = custItemNames[i];
                String itemRemark = custItemRemarks[i];
                String itemCharge = custItemCharges[i];
                String itemQty = custItemQtys[i];
                String itemUnit = custItemUnits[i];
                ps.setInt(1, leadId);
                ps.setString(2, salesDiv);
                ps.setString(3, surveyArea);
                ps.setString(4, itemName);
                ps.setString(5, itemRemark);
                ps.setString(6, itemCharge);
                ps.setString(7, itemQty);
                ps.setString(8, itemUnit);
                ps.executeUpdate();
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createLeadVimboxItem(int leadId, String salesDiv, String[] vimboxItemNames, String[] vimboxItemRemarks, String[] vimboxItemCharges, String[] vimboxItemQtys, String[] vimboxItemUnits) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_LEAD_VIMBOX_ITEM);
            for (int i = 0; i < vimboxItemNames.length; i++) {
                String itemName = vimboxItemNames[i];
                String itemRemark = vimboxItemRemarks[i];
                String itemCharge = vimboxItemCharges[i];
                String itemQty = vimboxItemQtys[i];
                String itemUnit = vimboxItemUnits[i];
                try {
                    ps.setInt(1, leadId);
                    ps.setString(2, salesDiv);
                    ps.setString(3, "");
                    ps.setString(4, itemName);
                    ps.setString(5, itemRemark);
                    ps.setString(6, itemCharge);
                    ps.setString(7, itemQty);
                    ps.setString(8, itemUnit);
                    ps.executeUpdate();
                } catch (SQLException se) {
                    se.printStackTrace();
                }
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createSiteLeadVimboxItem(int leadId, String salesDiv, String surveyArea, String[] vimboxItemNames, String[] vimboxItemRemarks, String[] vimboxItemCharges, String[] vimboxItemQtys, String[] vimboxItemUnits) {
        Connection con = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;
        try {
            con = ConnectionManager.getConnection();
            ps1 = con.prepareStatement(DELETE_SITE_LEAD_VIMBOX_ITEM);
            ps1.setInt(1, leadId);
            ps1.setString(2, salesDiv);
            ps1.setString(3, surveyArea);
            ps1.executeUpdate();
            ps1 = con.prepareStatement(DELETE_SITE_LEAD_MATERIAL);
            ps1.setInt(1, leadId);
            ps1.setString(2, salesDiv);
            ps1.setString(3, surveyArea);
            ps1.executeUpdate();

            ps1 = con.prepareStatement(CREATE_LEAD_VIMBOX_ITEM);
            ps2 = con.prepareStatement(CREATE_LEAD_MATERIAL);
            for (int i = 0; i < vimboxItemNames.length; i++) {
                System.out.println(vimboxItemNames[i]);
                String itemName = vimboxItemNames[i];
                String itemRemark = vimboxItemRemarks[i];
                String itemCharge = vimboxItemCharges[i];
                String itemQty = vimboxItemQtys[i];
                String itemUnit = vimboxItemUnits[i];
                if (itemName.equals("Boxes")) {
                    try {
                        ps1.setInt(1, leadId);
                        ps1.setString(2, salesDiv);
                        ps1.setString(3, surveyArea);
                        ps1.setString(4, itemName);
                        ps1.setString(5, itemRemark);
                        ps1.setString(6, itemCharge);
                        ps1.setString(7, itemQty);
                        ps1.setString(8, itemUnit);
                        ps1.executeUpdate();
                    } catch (SQLException se) {
                        se.printStackTrace();
                    }
                } else {
                    try {
                        ps2.setInt(1, leadId);
                        ps2.setString(2, salesDiv);
                        ps2.setString(3, surveyArea);
                        ps2.setString(4, itemName);
                        ps2.setString(5, itemQty);
                        ps2.setString(6, itemCharge);
                        ps2.executeUpdate();
                    } catch (SQLException se) {
                        se.printStackTrace();
                    }
                }
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps1, null);
            ConnectionManager.close(null, ps2, null);
        }
    }

    public static void createLeadMaterial(int leadId, String salesDiv, String[] vimboxMaterialNames, String[] vimboxMaterialCharges, String[] vimboxMaterialQtys) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_LEAD_MATERIAL);
            for (int i = 0; i < vimboxMaterialNames.length; i++) {
                String itemName = vimboxMaterialNames[i];
                String itemQty = vimboxMaterialQtys[i];
                String itemCharge = vimboxMaterialCharges[i];
                try {
                    ps.setInt(1, leadId);
                    ps.setString(2, salesDiv);
                    ps.setString(3, "");
                    ps.setString(4, itemName);
                    ps.setString(5, itemQty);
                    ps.setString(6, itemCharge);
                    ps.executeUpdate();
                } catch (SQLException se) {
                    se.printStackTrace();
                }
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createLeadService(String leadServiceInsertString) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement("INSERT INTO leadservice VALUES " + leadServiceInsertString);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createSiteLeadService(String leadServiceInsertString, int leadId) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(DELETE_LEAD_SERVICE);
            ps.setInt(1, leadId);
            ps.executeUpdate();
            ps = con.prepareStatement("INSERT INTO leadservice VALUES " + leadServiceInsertString);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createLeadOther(int leadId, String salesDiv, String[] others, String[] otherCharges) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_LEAD_OTHER);
            for (int i = 0; i < others.length; i++) {
                String otherName = others[i];
                String otherCharge = otherCharges[i];
                try {
                    ps.setInt(1, leadId);
                    ps.setString(2, salesDiv);
                    ps.setString(3, otherName);
                    ps.setString(4, otherCharge);
                    ps.executeUpdate();
                } catch (SQLException se) {
                    se.printStackTrace();
                }
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void updateLeadOther(int leadId, String salesDiv, String[] others, String[] otherCharges) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(UPDATE_LEAD_OTHER);
            for (int i = 0; i < others.length; i++) {
                String otherName = others[i];
                String otherCharge = otherCharges[i];
                try {
                    ps.setString(1, otherCharge);
                    ps.setInt(2, leadId);
                    ps.setString(3, salesDiv);
                    ps.setString(4, otherName);
                    ps.executeUpdate();
                } catch (SQLException se) {
                    se.printStackTrace();
                }
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createLeadComments(int leadId, String salesDiv, String[] comments) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_LEAD_COMMENT);
            for (String comment : comments) {
                try {
                    ps.setInt(1, leadId);
                    ps.setString(2, salesDiv);
                    ps.setString(3, comment);
                    ps.executeUpdate();
                } catch (SQLException se) {
                    se.printStackTrace();
                }
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createSiteLeadComments(int leadId, String salesDiv, String comments) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(DELETE_SITE_LEAD_COMMENT);
            ps.setInt(1, leadId);
            ps.setString(2, salesDiv);
            ps.executeUpdate();

            ps = con.prepareStatement(CREATE_LEAD_COMMENT);
            ps.setInt(1, leadId);
            ps.setString(2, salesDiv);
            ps.setString(3, comments);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createLeadRemarks(int leadId, String salesDiv, String[] remarks) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_LEAD_REMARK);
            for (String remark : remarks) {
                try {
                    ps.setInt(1, leadId);
                    ps.setString(2, salesDiv);
                    ps.setString(3, remark);
                    ps.executeUpdate();
                } catch (SQLException se) {
                    se.printStackTrace();
                }
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createLeadConfirmation(int leadId, double total) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_LEAD_CONFIRMATION);
            ps.setInt(1, leadId);
            rs = ps.executeQuery();
            if (rs.next()) {
                ps = con.prepareStatement(UPDATE_LEAD_CONFIRMATION);
                ps.setDouble(1, total);
                ps.setInt(2, leadId);
                ps.executeUpdate();
            } else {
                ps = con.prepareStatement(CREATE_LEAD_CONFIRMATION);
                ps.setInt(1, leadId);
                ps.setString(2, "");
                ps.setDouble(3, total);
                ps.setInt(4, 0);
                ps.setString(5, "");
                ps.executeUpdate();
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
    }

    public static void confirmLead(String nric, double collectAmount, String path, int leadId) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CONFIRM_LEAD);
            ps.setString(1, nric);
            ps.setDouble(2, collectAmount);
            ps.setString(3, path);
            ps.setInt(4, leadId);
            ps.executeUpdate();

            ps = con.prepareStatement(CONFIRM_LEAD_STATUS);
            ps.setInt(1, leadId);
            ps.executeUpdate();

            JobDAO.confirmSalesJob(leadId);
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static void reopenLead(int leadId){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(REOPEN_LEAD_STATUS);
            ps.setInt(1, leadId);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void addLeadConfirmationCollected(int leadId, double collectAmount) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(UPDATE_LEAD_CONFIRMATION_COLLECTED);
            ps.setDouble(1, collectAmount);
            ps.setInt(2, leadId);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void cancelLead(int leadId, String reason) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CANCEL_LEAD);
            ps.setString(1, "Rejected");
            ps.setString(2, reason);
            ps.setInt(3, leadId);
            ps.executeUpdate();
            SiteSurveyDAO.cancelLeadSiteSurvey(leadId);
            JobDAO.cancelSalesJob(leadId);
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void updateAddress(int leadId, String salesDiv, String storeys, String pushing) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(UPDATE_ADDRESS);
            ps.setString(1, storeys);
            ps.setString(2, pushing);
            ps.setInt(3, leadId);
            ps.setString(4, salesDiv);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void updateLeadSalesDiv(int leadId, String salesDiv, String surveyAreasDBString, String surveyAreasNamesDBString) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(UPDATE_LEAD_SALES_DIV);
            ps.setString(1, surveyAreasDBString);
            ps.setString(2, surveyAreasNamesDBString);
            ps.setInt(3, leadId);
            ps.setString(4, salesDiv);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static ArrayList<String[]> getServicesByLeadId(String leadId) {
        ArrayList<String[]> services = new ArrayList<String[]>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_LEAD_SERVICES_BY_LEADID);
            ps.setString(1, leadId);
            rs = ps.executeQuery();
            while (rs.next()) {
                String serviceName = rs.getString("service");
                String serviceCharge = rs.getString("charge");
                String[] svc = serviceName.split("_");
                String secSvc = "";

                for (int i = 1; i < svc.length; i++) {
                    secSvc += (svc[i]);
                    if (i < svc.length - 1) {
                        secSvc += " ";
                    }
                }
                String serviceMp = rs.getString("manpower");
                String serviceRm = rs.getString("remarks");
                String sName = "";
                for (String name : svc) {
                    sName += name + " ";
                }
                services.add(new String[]{sName, serviceCharge, serviceMp, serviceRm});
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
            return services;
        }
    }

    public static void createQuotation(String refNum, String serviceInclude) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_QUOTATION_REF);
            ps.setString(1, refNum);
            ps.setString(2, serviceInclude);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static String getQuotationService(String refNum) {
        String service = "";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_QUOTATION_SERVICE);
            ps.setString(1, refNum);
            rs = ps.executeQuery();
            if (rs.next()) {
                service = rs.getString("service_include");
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return service;
    }

    public static void updateQuotationService(String refNum, String serviceInclude) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(UPDATE_QUOTATION_SERVICE);
            ps.setString(1, serviceInclude);
            ps.setString(2, refNum);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static ArrayList<String[]> getWeekLeadConfirmation(String date) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ArrayList<String[]> results = new ArrayList<String[]>();
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_WEEK_LEAD_CONFIRMATION);
            ps.setString(1, date);
            rs = ps.executeQuery();
            while (rs.next()) {
                String leadid = rs.getString("lead_id");
                String totalAmt = Double.toString(rs.getDouble("total_amount"));
                String nameOfDay = rs.getString("name_of_day");
                results.add(new String[]{leadid, totalAmt, nameOfDay});
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }

    public static ArrayList<String[]> getMonthLeadConfirmation() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ArrayList<String[]> results = new ArrayList<String[]>();
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_MTH_LEAD_CONFIRMATION);
            rs = ps.executeQuery();
            while (rs.next()) {
                String leadid = rs.getString("lead_id");
                String totalAmt = Double.toString(rs.getDouble("total_amount"));
                String nameOfDay = rs.getString("month_name");
                results.add(new String[]{leadid, totalAmt, nameOfDay});
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }

    public static ArrayList<String[]> getYearLeadConfirmation(String year) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ArrayList<String[]> results = new ArrayList<String[]>();
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_YR_LEAD_CONFIRMATION);
            ps.setString(1, year);
            rs = ps.executeQuery();
            while (rs.next()) {
                String leadid = rs.getString("lead_id");
                String totalAmt = Double.toString(rs.getDouble("total_amount"));
                String nameOfDay = rs.getString("month_name");
                results.add(new String[]{leadid, totalAmt, nameOfDay});
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }

}
