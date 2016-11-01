package com.vimbox.database;

import com.vimbox.admin.Notification;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class NotificationDAO {

    private static final String CREATE_NOTIFICATION = "INSERT INTO notifications (user_id, message, status, html) VALUES (?,?,'New',?)";
    private static final String VIEW_NOTIFICATION = "UPDATE notifications SET status='Viewed' WHERE user_id=?";
    private static final String CLEAR_NOTIFICATION = "DELETE FROM notifications WHERE user_id=?";
    private static final String CLEAR_SINGLE_NOTIFICATION = "DELETE from notifications WHERE user_id=? AND message=?";
    private static final String GET_NOTIFICATION_BY_USERID = "SELECT * FROM notifications WHERE user_id = ? ORDER BY notification_id DESC";

    public static void storeNotification(ArrayList<String> users, String message, String html) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_NOTIFICATION);
            for (String user : users) {
                ps.setString(1, user);
                ps.setString(2, message);
                ps.setString(3, html);
                ps.executeUpdate();
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static void viewNotification(String nric) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(VIEW_NOTIFICATION);
            ps.setString(1, nric);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static void clearSingleNotification(String nric, String message){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CLEAR_SINGLE_NOTIFICATION);
            ps.setString(1, nric);
            ps.setString(2, message);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static void clearNotification(String nric) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CLEAR_NOTIFICATION);
            ps.setString(1, nric);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static ArrayList<Notification> getUserNotifications(String nric) {
        ArrayList<Notification> results = new ArrayList<Notification>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_NOTIFICATION_BY_USERID);
            ps.setString(1, nric);
            rs = ps.executeQuery();
            while (rs.next()) {
                results.add(new Notification(rs.getString("message"), rs.getString("status"), rs.getString("html")));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
}
