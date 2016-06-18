package com.vimbox.database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class CustomerHistoryDAO {
    private static final String CREATE_CUSTOMER_HISTORY = "INSERT INTO customers_history (customer_id, id) values (?,?)";
    private static final String DELETE_CUSTOMER_HISTORY = "DELETE FROM customers_history WHERE id=?";
    private static final String GET_CUSTOMER_TICKETS = "SELECT id FROM customers_history WHERE customer_id = ? AND CHAR_LENGTH(id) = 8";
    private static final String GET_CUSTOMER_LEADS = "SELECT id FROM customers_history WHERE customer_id = ? AND CHAR_LENGTH(id) = 9";
    
    public static void updateCustomerHistory(int customer_id, int id){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_CUSTOMER_HISTORY);
            ps.setInt(1, customer_id);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static void deleteCustomerHistory(int id){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(DELETE_CUSTOMER_HISTORY);
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static ArrayList<Integer> getCustomerTicketIds(int custId){
        ArrayList<Integer> results = new ArrayList<Integer>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_CUSTOMER_TICKETS);
            ps.setInt(1, custId);
            rs = ps.executeQuery();
            while (rs.next()) {
                int ticketId = rs.getInt("id");
                results.add(ticketId);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    public static ArrayList<Integer> getCustomerLeadIds(int custId){
        ArrayList<Integer> results = new ArrayList<Integer>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_CUSTOMER_LEADS);
            ps.setInt(1, custId);
            rs = ps.executeQuery();
            while (rs.next()) {
                int leadId = rs.getInt("id");
                results.add(leadId);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
}
