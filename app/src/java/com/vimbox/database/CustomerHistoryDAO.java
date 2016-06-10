package com.vimbox.database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class CustomerHistoryDAO {
    private static final String CREATE_CUSTOMER_HISTORY = "INSERT INTO customershistory (custid,id) values (?,?)";
    private static final String GET_CUSTOMER_TICKETS = "SELECT id FROM customershistory WHERE custid = ? AND CHAR_LENGTH(id) = 8";
    
    public static void updateCustomerHistory(int custId, String id){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_CUSTOMER_HISTORY);
            ps.setInt(1, custId);
            ps.setString(2, id);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static ArrayList<String> getCustomerTicketIds(int custId){
        ArrayList<String> results = new ArrayList<String>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_CUSTOMER_TICKETS);
            ps.setInt(1, custId);
            rs = ps.executeQuery();
            while (rs.next()) {
                String ticketId = rs.getString("id");
                results.add(ticketId);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
}
