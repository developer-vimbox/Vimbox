package com.vimbox.database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class LeadPopulationDAO {

    private static final String GET_MOVE_TYPES = "SELECT * FROM system_move_types";
    private static final String GET_LEAD_TYPES = "SELECT * FROM system_lead_types";
    private static final String GET_SOURCES = "SELECT * FROM system_sources";
    private static final String GET_REFERRALS = "SELECT * FROM system_referrals";
    private static final String GET_EXISTING_ITEMS = "SELECT * FROM system_items";
    private static final String GET_EXISTING_ITEMS_SITE_SURVEY = "SELECT * FROM system_items WHERE name LIKE ? OR description LIKE ?";
    private static final String GET_EXISTING_SPECIAL_ITEMS_SITE_SURVEY = "SELECT * FROM system_special_items WHERE name LIKE ?";
    private static final String GET_EXISTING_VIMBOX_MATERIALS_SITE_SURVEY = "SELECT * FROM system_vimbox_materials WHERE name LIKE ?";
    private static final String GET_EXISTING_SPECIAL_ITEMS = "SELECT * FROM system_special_items";
    private static final String GET_PRIMARY_SERVICES = "SELECT DISTINCT primary_service FROM system_services";
    private static final String GET_SECONDARY_SERVICES = "SELECT secondary_service FROM system_services where primary_service=?";
    private static final String GET_SECONDARY_SERVICE_FORMULA = "SELECT formula FROM system_services WHERE primary_service=? AND secondary_service=?";
    private static final String GET_SECONDARY_SERVICE_DESCRIPTION = "SELECT system_services FROM services WHERE primary_service=? AND secondary_service=?";

    public static ArrayList<String> getLeadTypes() {
        ArrayList<String> results = new ArrayList<String>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_LEAD_TYPES);
            rs = ps.executeQuery();
            while (rs.next()) {
                String type = rs.getString("type");
                results.add(type);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
            
    public static ArrayList<String> getReferrals() {
        ArrayList<String> results = new ArrayList<String>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_REFERRALS);
            rs = ps.executeQuery();
            while (rs.next()) {
                String source = rs.getString("source");
                results.add(source);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    public static ArrayList<String> getSources() {
        ArrayList<String> results = new ArrayList<String>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_SOURCES);
            rs = ps.executeQuery();
            while (rs.next()) {
                String source = rs.getString("source");
                results.add(source);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    public static ArrayList<String> getMoveTypes() {
        ArrayList<String> results = new ArrayList<String>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_MOVE_TYPES);
            rs = ps.executeQuery();
            while (rs.next()) {
                String type = rs.getString("type");
                results.add(type);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }

    public static ArrayList<String[]> getExistingItems() {
        ArrayList<String[]> results = new ArrayList<String[]>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_EXISTING_ITEMS);
            rs = ps.executeQuery();
            while (rs.next()) {
                String[] data = new String[]{rs.getString("name"), rs.getString("description"), rs.getString("dimensions"), rs.getString("units")};
                results.add(data);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }

    public static ArrayList<String> getExistingSpecialItems() {
        ArrayList<String> results = new ArrayList<String>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_EXISTING_SPECIAL_ITEMS);
            rs = ps.executeQuery();
            while (rs.next()) {
                String data = rs.getString("name");
                results.add(data);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }

    public static ArrayList<String> getPrimaryServices() {
        ArrayList<String> results = new ArrayList<String>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_PRIMARY_SERVICES);
            rs = ps.executeQuery();
            while (rs.next()) {
                String data = rs.getString("primary_service");
                results.add(data);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }

    public static ArrayList<String> getSecondaryServices(String primaryService) {
        ArrayList<String> results = new ArrayList<String>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_SECONDARY_SERVICES);
            ps.setString(1,primaryService);
            rs = ps.executeQuery();
            while (rs.next()) {
                String data = rs.getString("secondary_service");
                results.add(data);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    public static String getServiceFormula(String primaryService, String secondaryService) {
        String formula = "";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_SECONDARY_SERVICE_FORMULA);
            ps.setString(1, primaryService);
            ps.setString(2, secondaryService);
            rs = ps.executeQuery();
            if(rs.next()) {
                formula = rs.getString("formula");
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return formula;
    }
    
    public static String getServiceDescription(String primaryService, String secondaryService) {
        String description = "";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_SECONDARY_SERVICE_DESCRIPTION);
            ps.setString(1, primaryService);
            ps.setString(2, secondaryService);
            rs = ps.executeQuery();
            if(rs.next()) {
                description = rs.getString("description");
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return description;
    }
    
    public static ArrayList<String[]> getExistingItemsSiteSurvey(String keyword) {
        ArrayList<String[]> results = new ArrayList<String[]>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_EXISTING_ITEMS_SITE_SURVEY);
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                String[] data = new String[]{rs.getString("name"), rs.getString("description"), rs.getString("dimensions"), rs.getString("units"), rs.getString("img")};
                results.add(data);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    public static ArrayList<String[]> getExistingSpecialItemsSiteSurvey(String keyword) {
        ArrayList<String[]> results = new ArrayList<String[]>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_EXISTING_SPECIAL_ITEMS_SITE_SURVEY);
            ps.setString(1, "%" + keyword + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                String[] data = new String[]{"Special - " + rs.getString("name"), "", "", "", rs.getString("img"), "Special"};
                results.add(data);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    public static ArrayList<String[]> getExistingVimboxMaterials(String keyword) {
        ArrayList<String[]> results = new ArrayList<String[]>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_EXISTING_VIMBOX_MATERIALS_SITE_SURVEY);
            ps.setString(1, "%" + keyword + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                String[] data = new String[]{"Material - " + rs.getString("name"), "", "", "", rs.getString("img"), "Material"};
                results.add(data);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
}
