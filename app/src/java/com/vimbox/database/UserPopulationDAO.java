package com.vimbox.database;

import com.vimbox.user.Module;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class UserPopulationDAO {

    private static final String GET_FULL_USER_DEPARTMENTS = "SELECT department FROM system_modules WHERE type='Full' GROUP BY department";
    private static final String GET_PART_USER_DEPARTMENTS = "SELECT department FROM system_modules WHERE type='Part' GROUP BY department";
    private static final String GET_USER_DESIGNATIONS = "SELECT designation FROM system_modules WHERE department=? AND type=?";
    private static final String GET_USER_MODULES = "SELECT * FROM system_modules WHERE department=? AND designation=?";
    private static final String GET_USER_PAYMENT_MODES = "SELECT * FROM system_payment_modes";
    private static final String GET_USER_WORKING_DAYS = "SELECT working_days FROM system_modules WHERE department=? AND designation=?";
    private static final String GET_ACCESS_CONTROL_BY_MODULE = "SELECT * FROM access_control WHERE modules LIKE ?";

    public static String getUserModules(String department, String designation) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_USER_MODULES);
            ps.setString(1, department);
            ps.setString(2, designation);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("modules");
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return null;
    }

    public static ArrayList<String> getUserPaymentModes() {
        ArrayList<String> results = new ArrayList<String>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_USER_PAYMENT_MODES);
            rs = ps.executeQuery();
            while (rs.next()) {
                results.add(rs.getString("mode"));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }

    public static ArrayList<String> getFullUserDepartments() {
        ArrayList<String> results = new ArrayList<String>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_FULL_USER_DEPARTMENTS);
            rs = ps.executeQuery();
            while (rs.next()) {
                String department = rs.getString("department");
                results.add(department);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }

    public static ArrayList<String> getPartUserDepartments() {
        ArrayList<String> results = new ArrayList<String>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_PART_USER_DEPARTMENTS);
            rs = ps.executeQuery();
            while (rs.next()) {
                String department = rs.getString("department");
                results.add(department);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }

    public static ArrayList<String> getUserDesignations(String type, String department) {
        ArrayList<String> results = new ArrayList<String>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_USER_DESIGNATIONS);
            ps.setString(1, department);
            ps.setString(2, type);
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
    
    public static int getUserWorkingDays(String department, String designation) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_USER_WORKING_DAYS);
            ps.setString(1, department);
            ps.setString(2, designation);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("working_days");
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return -1;
    }
}
