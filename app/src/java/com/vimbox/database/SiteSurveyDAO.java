package com.vimbox.database;

import com.vimbox.sitesurvey.SiteSurvey;
import com.vimbox.user.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public class SiteSurveyDAO {
    private static final String GET_SITE_SURVEYS_BY_USER_DATE = "SELECT * FROM sitesurvey_assigned WHERE ss_user=? AND start_datetime LIKE ? AND lead_id != ? ORDER BY start_datetime";
    private static final String GET_SITE_SURVEYS_BY_USER_KEYWORD = "SELECT * FROM sitesurvey_assigned WHERE ss_user=? AND (lead_id like ? OR start_datetime LIKE ? OR end_datetime LIKE ? OR timeslot LIKE ?)";
    private static final String CREATE_SITE_SURVEY_ASSIGNMENT = "INSERT INTO sitesurvey_assigned VALUES (?,?,?,?,?,?,?)";
    private static final String GET_SITE_SURVEYS_BY_LEAD_ID = "SELECT * FROM sitesurvey_assigned WHERE lead_id = ?";
    private static final String DELETE_SITE_SURVEYS_BY_LEAD_ID = "DELETE FROM sitesurvey_assigned WHERE lead_id = ?";
    
    public static void deleteSiteSurveysByLeadId(int leadId){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(DELETE_SITE_SURVEYS_BY_LEAD_ID);
            ps.setInt(1, leadId);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static ArrayList<SiteSurvey> getSiteSurveysByUserDate(String nric, String date, int currentLeadId){
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        ArrayList<SiteSurvey> results = new ArrayList<SiteSurvey>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        User user = UserDAO.getUserByNRIC(nric);
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_SITE_SURVEYS_BY_USER_DATE);
            ps.setString(1, nric);
            ps.setString(2, "%" + date + "%");
            ps.setInt(3, currentLeadId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                int leadId = rs.getInt("lead_id");
                String address = rs.getString("address");
                String[] addrArray = address.split("\\|");
                
                String tempStartString = rs.getString("start_datetime");
                String datetimeString = tempStartString.substring(0, tempStartString.lastIndexOf("."));
                DateTime start = dtf.parseDateTime(datetimeString);
                
                tempStartString = rs.getString("end_datetime");
                datetimeString = tempStartString.substring(0, tempStartString.lastIndexOf("."));
                DateTime end = dtf.parseDateTime(datetimeString);
                
                String remarks = rs.getString("remarks");
                String timeslot = rs.getString("timeslot");
                
                for(String addr : addrArray){
                    results.add(new SiteSurvey(leadId, user, addr, start, end, timeslot, remarks));
                }
                
            }
            
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    public static ArrayList<SiteSurvey> getSiteSurveysByLeadId(int leadId){
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        ArrayList<SiteSurvey> results = new ArrayList<SiteSurvey>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_SITE_SURVEYS_BY_LEAD_ID);
            ps.setInt(1, leadId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                String address = rs.getString("address");
                String[] addrArray = address.split("\\|");
                User user = UserDAO.getUserByNRIC(rs.getString("ss_user"));
                
                String tempStartString = rs.getString("start_datetime");
                String datetimeString = tempStartString.substring(0, tempStartString.lastIndexOf("."));
                DateTime start = dtf.parseDateTime(datetimeString);
                
                tempStartString = rs.getString("end_datetime");
                datetimeString = tempStartString.substring(0, tempStartString.lastIndexOf("."));
                DateTime end = dtf.parseDateTime(datetimeString);
                
                String remarks = rs.getString("remarks");
                String timeslot = rs.getString("timeslot");
                
                for(String addr : addrArray){
                    results.add(new SiteSurvey(leadId, user, addr, start, end, timeslot, remarks));
                }
                
            }
            
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    public static void createSiteSurveyAssignment(int leadId, String nric, String date, ArrayList<String> times, ArrayList<String> adds, String timeslot, String remarks){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            String address = "";
            for(String add : adds){
                address += add + "|";
            }
            for(String time : times){
                String startTime = time.substring(0,time.indexOf(" "));
                String endTime = time.substring(time.lastIndexOf(" ")+1);
                String startDate = date + " " + startTime.substring(0,2) + ":" + startTime.substring(2) + ":00";
                String endDate = date + " " + endTime.substring(0,2) + ":" + endTime.substring(2) + ":00";
                
                ps = con.prepareStatement(CREATE_SITE_SURVEY_ASSIGNMENT);
                ps.setInt(1, leadId);
                ps.setString(2, nric);
                ps.setString(3, address);
                ps.setString(4, startDate);
                ps.setString(5, endDate);
                ps.setString(6, timeslot);
                ps.setString(7, remarks);
                ps.executeUpdate();
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static ArrayList<SiteSurvey> getSiteSurveysByUserKeyword(String nric, String keyword){
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        ArrayList<SiteSurvey> results = new ArrayList<SiteSurvey>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        User user = UserDAO.getUserByNRIC(nric);
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_SITE_SURVEYS_BY_USER_KEYWORD);
            ps.setString(1, nric);
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");
            ps.setString(4, "%" + keyword + "%");
            ps.setString(5, "%" + keyword + "%");
            rs = ps.executeQuery();
            
            while (rs.next()) {
                int leadId = Integer.parseInt(rs.getString("lead_id"));
                String address = rs.getString("address");
                String[] addrArray = address.split("\\|");
                
                
                String tempStartString = rs.getString("start_datetime");
                String datetimeString = tempStartString.substring(0, tempStartString.lastIndexOf("."));
                DateTime start = dtf.parseDateTime(datetimeString);
                
                tempStartString = rs.getString("end_datetime");
                datetimeString = tempStartString.substring(0, tempStartString.lastIndexOf("."));
                DateTime end = dtf.parseDateTime(datetimeString);
                
                String remarks = rs.getString("remarks");
                String timeslot = rs.getString("timeslot");
                
                for(String addr : addrArray){
                    results.add(new SiteSurvey(leadId, user, addr, start, end, timeslot, remarks));
                }
                
            }
            
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
}
