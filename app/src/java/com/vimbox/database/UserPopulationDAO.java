package com.vimbox.database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class UserPopulationDAO {
    
    private static final String GET_USER_DESIGNATIONS = "SELECT * FROM system_designations";
    private static final String GET_USER_DESIGNATIONS_PARTTIME = "SELECT * FROM system_designations_part_time";
    private static final String GET_USER_MODULES = "SELECT * FROM system_modules";
    
    public static ArrayList<String> getUserModules() {
        ArrayList<String> results = new ArrayList<String>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_USER_MODULES);
            rs = ps.executeQuery();
            while (rs.next()) {
                String module = rs.getString("module");
                results.add(module);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    public static ArrayList<String> getUserDesignations() {
        ArrayList<String> results = new ArrayList<String>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_USER_DESIGNATIONS);
            rs = ps.executeQuery();
            while (rs.next()) {
                String designation = rs.getString("designation");
                results.add(designation);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    public static ArrayList<String> getPartTimeUserDesignations() {
        ArrayList<String> results = new ArrayList<String>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_USER_DESIGNATIONS_PARTTIME);
            rs = ps.executeQuery();
            while (rs.next()) {
                String designation = rs.getString("designation");
                results.add(designation);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
}
