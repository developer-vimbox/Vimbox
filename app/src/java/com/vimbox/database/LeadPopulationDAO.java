package com.vimbox.database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class LeadPopulationDAO {

    private static final String GET_MOVE_TYPES = "SELECT * FROM system_move_types";
    private static final String GET_MOVE_TYPE_ABB = "SELECT * FROM system_move_types WHERE type=?";
    private static final String GET_ENQUIRIES = "SELECT * FROM system_enquiries";
    private static final String GET_SOURCES = "SELECT * FROM system_sources";
    private static final String GET_REFERRALS = "SELECT * FROM system_referrals";
    private static final String GET_EXISTING_ITEMS = "SELECT * FROM system_items WHERE item_type='Normal' ORDER BY name";
    private static final String GET_EXISTING_ITEMS_SITE_SURVEY = "SELECT * FROM system_items WHERE item_type='Normal' AND (name LIKE ? OR description LIKE ?) ORDER BY name";
    private static final String GET_EXISTING_SPECIAL_ITEMS_SITE_SURVEY = "SELECT * FROM system_items WHERE item_type='Special' AND name LIKE ? ORDER BY name";
    private static final String GET_EXISTING_VIMBOX_MATERIALS_SITE_SURVEY = "SELECT * FROM system_vimbox_materials WHERE name LIKE ? ORDER BY name";
    private static final String GET_EXISTING_SPECIAL_ITEMS = "SELECT * FROM system_items WHERE item_type='Special' ORDER BY name";
    private static final String GET_ALL_SERVICES = "SELECT * FROM system_services";
    private static final String GET_PRIMARY_SERVICES = "SELECT DISTINCT primary_service FROM system_services";
    private static final String GET_SECONDARY_SERVICES = "SELECT secondary_service FROM system_services where primary_service=?";
    private static final String GET_SECONDARY_SERVICE_FORMULA = "SELECT formula FROM system_services WHERE primary_service=? AND secondary_service=?";
    private static final String GET_SECONDARY_SERVICE_DESCRIPTION = "SELECT system_services FROM services WHERE primary_service=? AND secondary_service=?";
    private static final String ADD_MOVE_TYPE = "INSERT INTO system_move_types VALUES (?,?)";
    private static final String ADD_REF_TYPE = "INSERT INTO system_referrals VALUES (?)";
    private static final String ADD_SVC_TYPE = "INSERT INTO system_services VALUES (?,?,?,?)";
    private static final String DEL_MOVE_TYPE = "DELETE FROM system_move_types WHERE type=?";
    private static final String DEL_REF_TYPE = "DELETE FROM system_referrals WHERE source=?";
    private static final String DEL_SVC_TYPE = "DELETE FROM system_services WHERE primary_service=? AND secondary_service=?";
    private static final String GET_DEPOSIT_PERCENTAGE = "SELECT * FROM system_percentage WHERE name='Deposit'";
    private static final String GET_SELECTED_SERVICE_DESCRIPTION = "SELECT description FROM system_services WHERE primary_service=? AND secondary_service=?";
    private static final String UPDATE_ITEM = "UPDATE system_items SET name=?, description=?, dimensions=?, units=?, img=? WHERE item_id=?";
    private static final String CREATE_NORMAL_ITEM = "INSERT INTO system_items(name, description, dimensions, units, img, item_type) VALUES (?,?,?,?,?,'Normal')";
    private static final String CREATE_SPECIAL_ITEM = "INSERT INTO system_items(name, description, dimensions, units, img, item_type) VALUES (?,?,?,?,?,'Special')";
    private static final String CREATE_MATERIAL = "INSERT INTO system_vimbox_materials(name, img) VALUES (?,?)";
    
    public static ArrayList<String> getAllServices() {
        ArrayList<String> results = new ArrayList<String>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_ALL_SERVICES);
            rs = ps.executeQuery();
            while (rs.next()) {
                String primary = rs.getString("primary_service");
                results.add(primary);
                String secondary = rs.getString("secondary_service");
                results.add(secondary);
                String formula = rs.getString("formula");
                results.add(formula);
                String description = rs.getString("description");
                results.add(description);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }

    public static double getDepositPercentage() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_DEPOSIT_PERCENTAGE);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("percentage");
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return 0;
    }

    public static ArrayList<String> getEnquiries() {
        ArrayList<String> results = new ArrayList<String>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_ENQUIRIES);
            rs = ps.executeQuery();
            while (rs.next()) {
                String enquiry = rs.getString("enquiry");
                results.add(enquiry);
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

    public static ArrayList<String[]> getMoveTypes() {
        ArrayList<String[]> results = new ArrayList<String[]>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_MOVE_TYPES);
            rs = ps.executeQuery();
            while (rs.next()) {
                String type = rs.getString("type");
                String abb = rs.getString("abbreviation");
                String[] types = {type, abb};
                results.add(types);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    public static String getMoveTypeAbb(String mtype) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String abb = "";
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_MOVE_TYPE_ABB);
            ps.setString(1, mtype);
            rs = ps.executeQuery();
            if (rs.next()) {
                abb = rs.getString("abbreviation");
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return abb;
    }

    public static void addMoveType(String moveType, String abb) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(ADD_MOVE_TYPE);
            ps.setString(1, moveType);
            ps.setString(2, abb);
            ps.executeUpdate();
            ps.close();
            con.close();

        } catch (SQLException se) {
            se.printStackTrace();
        }
    }

    public static void addRefType(String refType) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(ADD_REF_TYPE);
            ps.setString(1, refType);
            ps.executeUpdate();
            ps.close();
            con.close();

        } catch (SQLException se) {
            se.printStackTrace();
        }
    }

    public static void addSvcType(String primary, String secondary, String formula, String description) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(ADD_SVC_TYPE);
            ps.setString(1, primary);
            ps.setString(2, secondary);
            ps.setString(3, formula);
            ps.setString(4, description);
            ps.executeUpdate();
            ps.close();
            con.close();

        } catch (SQLException se) {
            se.printStackTrace();
        }
    }

    public static void delMoveType(String moveType) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(DEL_MOVE_TYPE);
            ps.setString(1, moveType);
            ps.executeUpdate();
            ps.close();
            con.close();
        } catch (SQLException se) {
            se.printStackTrace();
        }
    }

    public static void delRefType(String refType) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(DEL_REF_TYPE);
            ps.setString(1, refType);
            ps.executeUpdate();
            ps.close();
            con.close();
        } catch (SQLException se) {
            se.printStackTrace();
        }
    }

    public static void delSvcType(String primary, String secondary) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(DEL_SVC_TYPE);
            ps.setString(1, primary);
            ps.setString(2, secondary);
            ps.executeUpdate();
            ps.close();
            con.close();
        } catch (SQLException se) {
            se.printStackTrace();
        }
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
            ps.setString(1, primaryService);
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
            if (rs.next()) {
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
            if (rs.next()) {
                description = rs.getString("description");
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return description;
    }
    
      public static String getSelectedServiceDesc(String primaryService, String secondaryService) {
        String description = "";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_SELECTED_SERVICE_DESCRIPTION);
            ps.setString(1, primaryService);
            ps.setString(2, secondaryService);
            rs = ps.executeQuery();
            if (rs.next()) {
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
                String[] data = new String[]{rs.getString("name"), rs.getString("description"), rs.getString("dimensions"), rs.getString("units"), rs.getString("img"), rs.getInt("item_id") + ""};
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
                String[] data = new String[]{rs.getString("name"), rs.getString("description"), rs.getString("dimensions"), rs.getString("units"), rs.getString("img"), rs.getInt("item_id") + "", "Special"};
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
                String[] data = new String[]{rs.getString("name"), rs.getString("img"), rs.getInt("material_id") + "", "Material"};
                results.add(data);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    public static void editItem(String itemValues, String itemName, String itemDescription, String itemDimensions, String itemUnits, String img){
        Connection con = null;
        PreparedStatement ps = null;
        String[] valuesArr = itemValues.split("\\|");
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(UPDATE_ITEM);
            ps.setString(1, itemName);
            ps.setString(2, itemDescription);
            ps.setString(3, itemDimensions);
            ps.setString(4, itemUnits);
            ps.setString(5, img);
            ps.setInt(6, Integer.parseInt(valuesArr[5]));
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static void createNormalItem(String itemName, String itemDescription, String itemDimensions, String itemUnits, String fileName){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_NORMAL_ITEM);
            ps.setString(1, itemName);
            ps.setString(2, itemDescription);
            ps.setString(3, itemDimensions);
            ps.setString(4, itemUnits);
            ps.setString(5, fileName);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static void createSpecialItem(String itemName, String itemDescription, String itemDimensions, String itemUnits, String fileName){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_SPECIAL_ITEM);
            ps.setString(1, itemName);
            ps.setString(2, itemDescription);
            ps.setString(3, itemDimensions);
            ps.setString(4, itemUnits);
            ps.setString(5, fileName);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static void createMaterial(String itemName, String fileName){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_MATERIAL);
            ps.setString(1, itemName);
            ps.setString(2, fileName);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
}
