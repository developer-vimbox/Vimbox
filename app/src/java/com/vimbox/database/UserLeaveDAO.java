package com.vimbox.database;

import com.vimbox.hr.LeaveMC;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public class UserLeaveDAO {

    private static final String CREATE_USER_LEAVE = "INSERT INTO users_leave_record VALUES (?,?,?,?,?,?,?)";
    private static final String GET_USER_LEAVE_MC_BY_NRIC = "SELECT * FROM users_leave_record WHERE nric=? ORDER BY date DESC";
    private static final String GET_UNPAID_USER_LEAVE_MC_BY_NRIC_DATE = "SELECT * FROM users_leave_record WHERE nric=? AND date LIKE ? AND leave_type = 'Unpaid' ORDER BY date";
    private static final String GET_LEAVE_MC_BY_DATE = "SELECT * FROM users_leave_record WHERE date=?";
    private static final String DELETE_USER_LEAVE_MC = "DELETE FROM users_leave_record WHRER nric=? AND date=?";

    public static void createLeaveRecord(String leaveType, String leaveName, String nric, HashMap<Date, Double> used, HashMap<Date, String> usedString, String path) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;
        int count = 0;
        try {
            con = ConnectionManager.getConnection();
            double hours = 0;
            for (Map.Entry<Date, Double> entry : used.entrySet()) {
                ps = con.prepareStatement(CREATE_USER_LEAVE);
                ps.setString(1, leaveType);
                ps.setString(2, leaveName);
                ps.setString(3, nric);
                double hour = entry.getValue();
                hours += hour;
                ps.setDate(4, new java.sql.Date(entry.getKey().getTime()));
                ps.setString(5, usedString.get(entry.getKey()));
                ps.setDouble(6, hour);
                ps.setString(7, path);
                ps.executeUpdate();
                count++;
            }
            
            if (leaveType.equals("Paid")) {
                if (leaveName.equals("MC")) {
                    UserDAO.updateUserUsedLeaveMC(nric, leaveName, used.size());
                } else {
                    UserDAO.updateUserUsedLeaveMC(nric, leaveName, hours);
                }
            }
        } catch (SQLException se){
            con = ConnectionManager.getConnection();
            int match = 0;
            for (Map.Entry<Date, Double> entry : used.entrySet()) {
                if(match == count){
                    break;
                }
                ps = con.prepareStatement(DELETE_USER_LEAVE_MC);
                ps.setString(1, nric);
                ps.setDate(2, new java.sql.Date(entry.getKey().getTime()));
                ps.executeUpdate();
                match++;
            }
            throw se;
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static ArrayList<LeaveMC> getLeaveMCRecordByNric(String nric) {
        ArrayList<LeaveMC> results = new ArrayList<LeaveMC>();
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd");
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_USER_LEAVE_MC_BY_NRIC);
            ps.setString(1, nric);
            rs = ps.executeQuery();
            
            while(rs.next()){
                String leaveType = rs.getString("leave_type");
                String leaveName = rs.getString("leave_name");
                double leaveDuration = rs.getDouble("leave_duration");
                String imgPath = rs.getString("img");
                String timeString = rs.getString("time_string");
                DateTime date = null;
                try{
                    date = dtf.parseDateTime(rs.getString("date"));
                }catch (Exception e){
                    e.printStackTrace();
                }
                results.add(new LeaveMC(leaveType, leaveName, leaveDuration, date, timeString, imgPath));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        
        return results;
    }
    
    public static ArrayList<LeaveMC> getUnpaidLeaveMCRecordByNricDate(String nric, String yearMonth) {
        ArrayList<LeaveMC> results = new ArrayList<LeaveMC>();
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd");
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_UNPAID_USER_LEAVE_MC_BY_NRIC_DATE);
            ps.setString(1, nric);
            ps.setString(2, "%" + yearMonth + "%");
            rs = ps.executeQuery();
            
            while(rs.next()){
                String leaveType = rs.getString("leave_type");
                String leaveName = rs.getString("leave_name");
                double leaveDuration = rs.getDouble("leave_duration");
                String imgPath = rs.getString("img");
                String timeString = rs.getString("time_string");
                DateTime date = null;
                try{
                    date = dtf.parseDateTime(rs.getString("date"));
                }catch (Exception e){
                    e.printStackTrace();
                }
                results.add(new LeaveMC(leaveType, leaveName, leaveDuration, date, timeString, imgPath));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        
        return results;
    }
    
    public static HashMap<String, LeaveMC> getLeaveMCRecordByDate(DateTime date) {
        HashMap<String, LeaveMC> results = new HashMap<String, LeaveMC>();
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_LEAVE_MC_BY_DATE);
            ps.setDate(1, new java.sql.Date(date.toDate().getTime()));
            rs = ps.executeQuery();
            
            while(rs.next()){
                String nric = rs.getString("nric");
                
                String leaveType = rs.getString("leave_type");
                String leaveName = rs.getString("leave_name");
                double leaveDuration = rs.getDouble("leave_duration");
                String imgPath = rs.getString("img");
                String timeString = rs.getString("time_string");
                
                results.put(nric, new LeaveMC(leaveType, leaveName, leaveDuration, date, timeString, imgPath));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        
        return results;
    }
}
