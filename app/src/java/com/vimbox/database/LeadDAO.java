package com.vimbox.database;

import com.vimbox.customer.Customer;
import com.vimbox.sales.Item;
import com.vimbox.sales.Lead;
import com.vimbox.user.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public class LeadDAO {

    private static final String CREATE_LEAD_INFO = "INSERT INTO leadinfo(username,leadid,type,custid,tom,dom,datetiming,status,reason,source,referral) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
    private static final String CREATE_LEAD_ENQUIRY = "INSERT INTO leadenquiry(leadid,enquiry) VALUES (?,?)";
    private static final String CREATE_LEAD_MOVE_FROM = "INSERT INTO leadmovefrom(leadid,addressfrom,storeysfrom,pushingfrom) VALUES (?,?,?,?)";
    private static final String CREATE_LEAD_MOVE_TO = "INSERT INTO leadmoveto(leadid,addressto,storeysto,pushingto) VALUES (?,?,?,?)";
    private static final String CREATE_LEAD_CUST_ITEM = "INSERT INTO leadcustitem(leadid,itemname,itemremark,itemcharge,itemqty,itemunit) VALUES (?,?,?,?,?,?)";
    private static final String CREATE_LEAD_VIMBOX_ITEM = "INSERT INTO leadvimboxitem(leadid,itemname,itemremark,itemcharge,itemqty,itemunit) VALUES (?,?,?,?,?,?)";
    private static final String CREATE_LEAD_MATERIAL = "INSERT INTO leadmaterial(leadid,materialname,materialqty,materialcharge) VALUES (?,?,?,?)";
    private static final String CREATE_LEAD_OTHER = "INSERT INTO leadother(leadid,other,charge) VALUES (?,?,?)";
    private static final String CREATE_LEAD_COMMENT = "INSERT INTO leadcomment(leadid,comment) VALUES (?,?)";
    private static final String CREATE_LEAD_REMARK = "INSERT INTO leadremark(leadid,remark) VALUES (?,?)";
    private static final String GET_LEAD_INFO = "SELECT * FROM leadinfo WHERE username=?";
    private static final String GET_LEAD_ENQUIRY = "SELECT * FROM leadenquiry WHERE leadid=?";
    private static final String GET_LEAD_INFO_BY_ID = "SELECT * FROM leadinfo WHERE leadid=?";
    private static final String GET_LEAD_MOVE_FROM = "SELECT * FROM leadmovefrom WHERE leadid=?";
    private static final String GET_LEAD_MOVE_TO = "SELECT * FROM leadmoveto WHERE leadid=?";
    private static final String GET_LEAD_CUST_ITEM = "SELECT * FROM leadcustitem WHERE leadid=?";
    private static final String GET_LEAD_VIMBOX_ITEM = "SELECT * FROM leadvimboxitem WHERE leadid=?";
    private static final String GET_LEAD_MATERIAL = "SELECT * FROM leadmaterial WHERE leadid=?";
    private static final String GET_LEAD_SERVICE = "SELECT * FROM leadservice WHERE leadid=?";
    private static final String GET_LEAD_OTHER = "SELECT * FROM leadother WHERE leadid=?";
    private static final String GET_LEAD_COMMENT = "SELECT * FROM leadcomment WHERE leadid=?";
    private static final String GET_LEAD_REMARK = "SELECT * FROM leadremark WHERE leadid=?";
    private static final String DELETE_LEAD_INFO = "DELETE FROM leadinfo WHERE leadid=?";
    private static final String DELETE_LEAD_ENQUIRY = "DELETE FROM leadenquiry WHERE leadid=?";
    private static final String DELETE_LEAD_MOVE_FROM = "DELETE FROM leadmovefrom WHERE leadid=?";
    private static final String DELETE_LEAD_MOVE_TO = "DELETE FROM leadmoveto WHERE leadid=?";
    private static final String DELETE_LEAD_CUST_ITEM = "DELETE FROM leadcustitem WHERE leadid=?";
    private static final String DELETE_LEAD_VIMBOX_ITEM = "DELETE FROM leadvimboxitem WHERE leadid=?";
    private static final String DELETE_LEAD_MATERIAL = "DELETE FROM leadmaterial WHERE leadid=?";
    private static final String DELETE_LEAD_SERVICE = "DELETE FROM leadservice WHERE leadid=?";
    private static final String DELETE_LEAD_OTHER = "DELETE FROM leadother WHERE leadid=?";
    private static final String DELETE_LEAD_COMMENT = "DELETE FROM leadcomment WHERE leadid=?";
    private static final String DELETE_LEAD_REMARK = "DELETE FROM leadremark WHERE leadid=?";
    private static final String CANCEL_LEAD = "UPDATE leadinfo SET status=?, reason=? WHERE leadid=?";
    
    public static void deleteLead(String leadId){
        Connection con = null;
        PreparedStatement ps = null;
        try{
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(DELETE_LEAD_INFO);
            ps.setString(1, leadId);
            ps.executeUpdate();
            ps = con.prepareStatement(DELETE_LEAD_ENQUIRY);
            ps.setString(1, leadId);
            ps.executeUpdate();
            ps = con.prepareStatement(DELETE_LEAD_MOVE_FROM);
            ps.setString(1, leadId);
            ps.executeUpdate();
            ps = con.prepareStatement(DELETE_LEAD_MOVE_TO);
            ps.setString(1, leadId);
            ps.executeUpdate();
            ps = con.prepareStatement(DELETE_LEAD_CUST_ITEM);
            ps.setString(1, leadId);
            ps.executeUpdate();
            ps = con.prepareStatement(DELETE_LEAD_VIMBOX_ITEM);
            ps.setString(1, leadId);
            ps.executeUpdate();
            ps = con.prepareStatement(DELETE_LEAD_MATERIAL);
            ps.setString(1, leadId);
            ps.executeUpdate();
            ps = con.prepareStatement(DELETE_LEAD_SERVICE);
            ps.setString(1, leadId);
            ps.executeUpdate();
            ps = con.prepareStatement(DELETE_LEAD_OTHER);
            ps.setString(1, leadId);
            ps.executeUpdate();
            ps = con.prepareStatement(DELETE_LEAD_COMMENT);
            ps.setString(1, leadId);
            ps.executeUpdate();
            ps = con.prepareStatement(DELETE_LEAD_REMARK);
            ps.setString(1, leadId);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static ArrayList<Lead> getLeadsByOwnerUser(User user) {
        ArrayList<Lead> results = new ArrayList<Lead>();
        DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_LEAD_INFO);
            ps.setString(1, user.getUsername());
            rs = ps.executeQuery();
            while (rs.next()) {
                // Lead Info //
                String leadId = rs.getString("leadid");
                String type = rs.getString("type");
                int custId = rs.getInt("custid");
                Customer customer = CustomerDAO.getCustomerById(custId);
                String tom = rs.getString("tom");
                String dom = rs.getString("dom");
                String tempDateTimeString = rs.getString("datetiming");
                String datetimeString = tempDateTimeString.substring(0, tempDateTimeString.lastIndexOf("."));
                DateTime dt = formatter.parseDateTime(datetimeString);
                String status = rs.getString("status");
                String reason = rs.getString("reason");
                String source = rs.getString("source");
                String referral = rs.getString("referral");
                
                String enquiry = "";
                ps = con.prepareStatement(GET_LEAD_ENQUIRY);
                ps.setString(1, leadId);
                ResultSet rs1 = ps.executeQuery();
                if (rs1.next()) {
                    enquiry = rs1.getString("enquiry");
                }
                
                ArrayList<String[]> addressFrom = new ArrayList<String[]>();
                ps = con.prepareStatement(GET_LEAD_MOVE_FROM);
                ps.setString(1, leadId);
                rs1 = ps.executeQuery();
                if (rs1.next()) {
                    String[] addfrom = rs1.getString("addressfrom").split("\\|");
                    String[] stofrom = rs1.getString("storeysfrom").split("\\|");
                    String[] pushfrom = rs1.getString("pushingfrom").split("\\|");
                    for (int i = 0; i < addfrom.length; i++) {
                        String address = addfrom[i];
                        String storeys = stofrom[i];
                        String pushing = pushfrom[i];
                        addressFrom.add(new String[]{address, storeys, pushing});
                    }
                }

                ArrayList<String[]> addressTo = new ArrayList<String[]>();
                ps = con.prepareStatement(GET_LEAD_MOVE_TO);
                ps.setString(1, leadId);
                rs1 = ps.executeQuery();
                if (rs1.next()) {
                    String[] addto = rs1.getString("addressto").split("\\|");
                    String[] stoto = rs1.getString("storeysto").split("\\|");
                    String[] pushto = rs1.getString("pushingto").split("\\|");
                    for (int i = 0; i < addto.length; i++) {
                        String address = addto[i];
                        String storeys = stoto[i];
                        String pushing = pushto[i];
                        addressTo.add(new String[]{address, storeys, pushing});
                    }
                }

                ArrayList<Item> customerItems = new ArrayList<Item>();
                ps = con.prepareStatement(GET_LEAD_CUST_ITEM);
                ps.setString(1, leadId);
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
                    customerItems.add(new Item(itemName, itemRemark, charge, unit, qty));
                }

                ArrayList<Item> vimboxItems = new ArrayList<Item>();
                ps = con.prepareStatement(GET_LEAD_VIMBOX_ITEM);
                ps.setString(1, leadId);
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
                
                ArrayList<Item> materials = new ArrayList<Item>();
                ps = con.prepareStatement(GET_LEAD_MATERIAL);
                ps.setString(1, leadId);
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
                
                ArrayList<String[]> services = new ArrayList<String[]>();
                ps = con.prepareStatement(GET_LEAD_SERVICE);
                ps.setString(1, leadId);
                rs1 = ps.executeQuery();
                while (rs1.next()) {
                    String serviceName = rs1.getString("service");
                    String serviceCharge = rs1.getString("charge");
                    String serviceMp = rs1.getString("manpower");
                    String serviceRm = rs1.getString("remarks");
                    services.add(new String[]{serviceName,serviceCharge,serviceMp,serviceRm});
                }
                
                HashMap<String,String> otherCharges = new HashMap<String,String>();
                ps = con.prepareStatement(GET_LEAD_OTHER);
                ps.setString(1, leadId);
                rs1 = ps.executeQuery();
                while (rs1.next()) {
                    String serviceName = rs1.getString("other");
                    String serviceCharge = rs1.getString("charge");
                    otherCharges.put(serviceName,serviceCharge);
                }
                
                ArrayList<String> comments = new ArrayList<String>();
                ps = con.prepareStatement(GET_LEAD_COMMENT);
                ps.setString(1, leadId);
                rs1 = ps.executeQuery();
                while (rs1.next()) {
                    String comment = rs1.getString("comment");
                    comments.add(comment);
                }
                
                ArrayList<String> remarks = new ArrayList<String>();
                ps = con.prepareStatement(GET_LEAD_REMARK);
                ps.setString(1, leadId);
                rs1 = ps.executeQuery();
                while (rs1.next()) {
                    String remark = rs1.getString("remark");
                    remarks.add(remark);
                }
                results.add(new Lead(user, leadId, type, customer, status, reason, source, referral, enquiry, dt, tom, dom, addressFrom, addressTo, customerItems, vimboxItems, materials, services, otherCharges, comments, remarks));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
        return results;
    }

    public static Lead getLeadById(String leadId) {
        Lead lead = null;
        DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_LEAD_INFO_BY_ID);
            ps.setString(1, leadId);
            rs = ps.executeQuery();
            while (rs.next()) {
                // Lead Info //
                String username = rs.getString("username");
                User user = UserDAO.getUserByUsername(username);
                String type = rs.getString("type");
                int custId = rs.getInt("custid");
                Customer customer = CustomerDAO.getCustomerById(custId);
                String tom = rs.getString("tom");
                String dom = rs.getString("dom");
                String tempDateTimeString = rs.getString("datetiming");
                String datetimeString = tempDateTimeString.substring(0, tempDateTimeString.lastIndexOf("."));
                DateTime dt = formatter.parseDateTime(datetimeString);
                String status = rs.getString("status");
                String reason = rs.getString("reason");
                String source = rs.getString("source");
                String referral = rs.getString("referral");
                
                String enquiry = "";
                ps = con.prepareStatement(GET_LEAD_ENQUIRY);
                ps.setString(1, leadId);
                ResultSet rs1 = ps.executeQuery();
                if (rs1.next()) {
                    enquiry = rs1.getString("enquiry");
                }
                
                ArrayList<String[]> addressFrom = new ArrayList<String[]>();
                ps = con.prepareStatement(GET_LEAD_MOVE_FROM);
                ps.setString(1, leadId);
                rs = ps.executeQuery();
                if (rs.next()) {
                    String[] addfrom = rs.getString("addressfrom").split("\\|");
                    String[] stofrom = rs.getString("storeysfrom").split("\\|");
                    String[] pushfrom = rs.getString("pushingfrom").split("\\|");
                    for (int i = 0; i < addfrom.length; i++) {
                        String address = addfrom[i];
                        String storeys = stofrom[i];
                        String pushing = pushfrom[i];
                        addressFrom.add(new String[]{address, storeys, pushing});
                    }
                }

                ArrayList<String[]> addressTo = new ArrayList<String[]>();
                ps = con.prepareStatement(GET_LEAD_MOVE_TO);
                ps.setString(1, leadId);
                rs = ps.executeQuery();
                if (rs.next()) {
                    String[] addto = rs.getString("addressto").split("\\|");
                    String[] stoto = rs.getString("storeysto").split("\\|");
                    String[] pushto = rs.getString("pushingto").split("\\|");
                    for (int i = 0; i < addto.length; i++) {
                        String address = addto[i];
                        String storeys = stoto[i];
                        String pushing = pushto[i];
                        addressTo.add(new String[]{address, storeys, pushing});
                    }
                }

                ArrayList<Item> customerItems = new ArrayList<Item>();
                ps = con.prepareStatement(GET_LEAD_CUST_ITEM);
                ps.setString(1, leadId);
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

                ArrayList<Item> vimboxItems = new ArrayList<Item>();
                ps = con.prepareStatement(GET_LEAD_VIMBOX_ITEM);
                ps.setString(1, leadId);
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
                
                ArrayList<Item> materials = new ArrayList<Item>();
                ps = con.prepareStatement(GET_LEAD_MATERIAL);
                ps.setString(1, leadId);
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
                
                ArrayList<String[]> services = new ArrayList<String[]>();
                ps = con.prepareStatement(GET_LEAD_SERVICE);
                ps.setString(1, leadId);
                rs = ps.executeQuery();
                while (rs.next()) {
                    String serviceName = rs.getString("service");
                    String serviceCharge = rs.getString("charge");
                    String[] svc = serviceName.split("_");
                    String secSvc = "";
                    for(int i=1; i<svc.length; i++){
                        secSvc += (svc[i]);
                        if(i < svc.length-1){
                            secSvc += " ";
                        }
                    }
                    String formula = LeadPopulationDAO.getServiceFormula(svc[0], secSvc);
                    String serviceMp = rs.getString("manpower");
                    String serviceRm = rs.getString("remarks");
                    services.add(new String[]{serviceName,serviceCharge,formula,serviceMp,serviceRm});
                }
                
                HashMap<String,String> otherCharges = new HashMap<String,String>();
                ps = con.prepareStatement(GET_LEAD_OTHER);
                ps.setString(1, leadId);
                rs = ps.executeQuery();
                while (rs.next()) {
                    String serviceName = rs.getString("other");
                    String serviceCharge = rs.getString("charge");
                    otherCharges.put(serviceName,serviceCharge);
                }
                
                ArrayList<String> comments = new ArrayList<String>();
                ps = con.prepareStatement(GET_LEAD_COMMENT);
                ps.setString(1, leadId);
                rs = ps.executeQuery();
                while (rs.next()) {
                    String comment = rs.getString("comment");
                    comments.add(comment);
                }
                
                ArrayList<String> remarks = new ArrayList<String>();
                ps = con.prepareStatement(GET_LEAD_REMARK);
                ps.setString(1, leadId);
                rs = ps.executeQuery();
                while (rs.next()) {
                    String remark = rs.getString("remark");
                    remarks.add(remark);
                }
                lead = new Lead(user, leadId, type, customer, status, reason, source, referral, enquiry, dt, tom, dom, addressFrom, addressTo, customerItems, vimboxItems, materials, services, otherCharges, comments, remarks);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
        return lead;
    }
    
    public static void createLeadInfo(User owner, String leadId, String type, int custId, String typesOfMove, String datesOfMove, String dt, String status, String source, String referral) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_LEAD_INFO);
            ps.setString(1, owner.getUsername());
            ps.setString(2, leadId);
            ps.setString(3, type);
            ps.setInt(4, custId);
            ps.setString(5, typesOfMove);
            ps.setString(6, datesOfMove);
            ps.setString(7, dt);
            ps.setString(8, status);
            ps.setString(9, "");
            ps.setString(10, source);
            ps.setString(11, referral);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createLeadMoveFrom(String leadId, String addressFrom, String storeysFrom, String pushingFrom) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_LEAD_MOVE_FROM);
            ps.setString(1, leadId);
            ps.setString(2, addressFrom);
            ps.setString(3, storeysFrom);
            ps.setString(4, pushingFrom);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static void createLeadEnquiry(String leadId, String enquiry) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_LEAD_ENQUIRY);
            ps.setString(1, leadId);
            ps.setString(2, enquiry);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createLeadMoveTo(String leadId, String addressTo, String storeysTo, String pushingTo) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_LEAD_MOVE_TO);
            ps.setString(1, leadId);
            ps.setString(2, addressTo);
            ps.setString(3, storeysTo);
            ps.setString(4, pushingTo);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createLeadCustItem(String leadId, String[] custItemNames, String[] custItemRemarks, String[] custItemCharges, String[] custItemQtys, String[] custItemUnits) {
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
                    ps.setString(1, leadId);
                    ps.setString(2, itemName);
                    ps.setString(3, itemRemark);
                    ps.setString(4, itemCharge);
                    ps.setString(5, itemQty);
                    ps.setString(6, itemUnit);
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

    public static void createLeadVimboxItem(String leadId, String[] vimboxItemNames, String[] vimboxItemRemarks, String[] vimboxItemCharges, String[] vimboxItemQtys, String[] vimboxItemUnits) {
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
                    ps.setString(1, leadId);
                    ps.setString(2, itemName);
                    ps.setString(3, itemRemark);
                    ps.setString(4, itemCharge);
                    ps.setString(5, itemQty);
                    ps.setString(6, itemUnit);
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

    public static void createLeadMaterial(String leadId, String[] vimboxMaterialNames, String[] vimboxMaterialCharges, String[] vimboxMaterialQtys) {
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
                    ps.setString(1, leadId);
                    ps.setString(2, itemName);
                    ps.setString(3, itemQty);
                    ps.setString(4, itemCharge);
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
            ps = con.prepareStatement("INSERT INTO leadservice(leadid,service,charge,manpower,remarks) VALUES " + leadServiceInsertString);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createLeadOther(String leadId, String[] others, String[] otherCharges) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_LEAD_OTHER);
            for (int i = 0; i < others.length; i++) {
                String otherName = others[i];
                String otherCharge = otherCharges[i];
                try {
                    ps.setString(1, leadId);
                    ps.setString(2, otherName);
                    ps.setString(3, otherCharge);
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

    public static void createLeadComments(String leadId, String[] comments) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_LEAD_COMMENT);
            for (String comment : comments) {
                try {
                    ps.setString(1, leadId);
                    ps.setString(2, comment);
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

    public static void createLeadRemarks(String leadId, String[] remarks) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_LEAD_REMARK);
            for (String remark : remarks) {
                try {
                    ps.setString(1, leadId);
                    ps.setString(2, remark);
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
    
    public static void cancelLead(String leadId, String reason){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CANCEL_LEAD);
            ps.setString(1, "Rejected");
            ps.setString(2, reason);
            ps.setString(3, leadId);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
}
