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
    private static final String GET_SITE_SURVEYS_BY_USER_DATE = "SELECT * FROM sitesurvey_assigned WHERE ss_user=? AND start_datetime LIKE ? AND lead_id != ? AND status != 'Cancelled' ORDER BY start_datetime";
    private static final String GET_NC_SITE_SURVEYS_BY_USER_KEYWORD = "SELECT * FROM sitesurvey_assigned WHERE ss_user=? AND (lead_id like ? OR start_datetime LIKE ? OR end_datetime LIKE ? OR timeslot LIKE ?) AND status!='Completed'";
    private static final String GET_C_SITE_SURVEYS_BY_USER_KEYWORD = "SELECT * FROM sitesurvey_assigned WHERE ss_user=? AND (lead_id like ? OR start_datetime LIKE ? OR end_datetime LIKE ? OR timeslot LIKE ?) AND status='Completed'";
    private static final String GET_SITE_SURVEYS_BY_OWNER_KEYWORD = "SELECT * FROM sitesurvey_assigned WHERE ss_owner=? AND (lead_id like ? OR start_datetime LIKE ? OR end_datetime LIKE ? OR timeslot LIKE ?)";
    private static final String CREATE_SITE_SURVEY_ASSIGNMENT = "INSERT INTO sitesurvey_assigned VALUES (?,?,?,?,?,?,?,?,?,?)";
    private static final String GET_SITE_SURVEYS_BY_LEAD_ID = "SELECT * FROM sitesurvey_assigned WHERE lead_id = ?";
    private static final String GET_SITE_SURVEYS_BY_LEAD_DATE_TIMESLOT = "SELECT * FROM sitesurvey_assigned WHERE lead_id = ? AND start_datetime LIKE ? AND timeslot = ?";
    private static final String START_SITE_SURVEY = "UPDATE sitesurvey_assigned SET status='Ongoing' WHERE lead_id = ? AND start_datetime LIKE ? AND timeslot = ?";
    private static final String COMPLETE_SITE_SURVEY = "UPDATE sitesurvey_assigned SET status='Completed' WHERE lead_id = ? AND start_datetime LIKE ? AND timeslot = ?";
    private static final String CANCEL_SITE_SURVEY = "UPDATE sitesurvey_assigned SET status='Cancelled' WHERE lead_id = ? AND start_datetime LIKE ? AND timeslot = ?";
    private static final String DELETE_SITE_SURVEYS_BY_LEAD_ID = "DELETE FROM sitesurvey_assigned WHERE lead_id = ? AND status='Pending'";
    private static final String GET_SITE_SURVEYS_BY_USER_STARTDATE = "SELECT * FROM sitesurvey_assigned where ss_user = ? and date(start_datetime) = ? AND status != 'Cancelled' ORDER BY start_datetime" ;
    private static final String GET_ALL_SITE_SURVEYS = "SELECT * FROM sitesurvey_assigned";
    
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
                User owner = UserDAO.getUserByNRIC(rs.getString("ss_owner"));
                String address = rs.getString("address");
                String addressTag = rs.getString("address_tag");
                String[] addrArray = address.split("\\|");
                String[] tagArray = addressTag.split("\\|");
                
                String tempStartString = rs.getString("start_datetime");
                String datetimeString = tempStartString.substring(0, tempStartString.lastIndexOf("."));
                DateTime start = dtf.parseDateTime(datetimeString);
                
                tempStartString = rs.getString("end_datetime");
                datetimeString = tempStartString.substring(0, tempStartString.lastIndexOf("."));
                DateTime end = dtf.parseDateTime(datetimeString);
                
                String remarks = rs.getString("remarks");
                String timeslot = rs.getString("timeslot");
                String status = rs.getString("status");
                
                for(int i=0; i<addrArray.length; i++){
                    String addr = addrArray[i];
                    String tag = tagArray[i];
                    results.add(new SiteSurvey(leadId, owner, user, addr, tag, start, end, timeslot, remarks, status));
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
                String addressTag = rs.getString("address_tag");
                String[] addrArray = address.split("\\|");
                String[] tagArray = addressTag.split("\\|");
                User owner = UserDAO.getUserByNRIC(rs.getString("ss_owner"));
                User user = UserDAO.getUserByNRIC(rs.getString("ss_user"));
                
                String tempStartString = rs.getString("start_datetime");
                String datetimeString = tempStartString.substring(0, tempStartString.lastIndexOf("."));
                DateTime start = dtf.parseDateTime(datetimeString);
                
                tempStartString = rs.getString("end_datetime");
                datetimeString = tempStartString.substring(0, tempStartString.lastIndexOf("."));
                DateTime end = dtf.parseDateTime(datetimeString);
                
                String remarks = rs.getString("remarks");
                String timeslot = rs.getString("timeslot");
                String status = rs.getString("status");
                
                for(int i=0; i<addrArray.length; i++){
                    String addr = addrArray[i];
                    String tag = tagArray[i];
                    results.add(new SiteSurvey(leadId, owner, user, addr, tag, start, end, timeslot, remarks, status));
                }
                
            }
            
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    public static void createSiteSurveyAssignment(int leadId, String owner, String nric, String date, ArrayList<String> times, ArrayList<String> adds, ArrayList<String> addsTags, String timeslot, String remarks, String status){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            String address = "";
            for(String add : adds){
                address += add + "|";
            }
            String addressTags = "";
            for(String addsTag : addsTags){
                addressTags += addsTag + "|";
            }
            
            for(String time : times){
                String startTime = time.substring(0,time.indexOf(" "));
                String endTime = time.substring(time.lastIndexOf(" ")+1);
                String startDate = date + " " + startTime.substring(0,2) + ":" + startTime.substring(2) + ":00";
                String endDate = date + " " + endTime.substring(0,2) + ":" + endTime.substring(2) + ":00";
                
                ps = con.prepareStatement(CREATE_SITE_SURVEY_ASSIGNMENT);
                ps.setInt(1, leadId);
                ps.setString(2, owner);
                ps.setString(3, nric);
                ps.setString(4, addressTags);
                ps.setString(5, address);
                ps.setString(6, startDate);
                ps.setString(7, endDate);
                ps.setString(8, timeslot);
                ps.setString(9, remarks);
                ps.setString(10, status);
                ps.executeUpdate();
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static ArrayList<SiteSurvey> getSiteSurveysByLeadIdDateTimeslot(int leadId, String date, String timeslot){
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        ArrayList<SiteSurvey> results = new ArrayList<SiteSurvey>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_SITE_SURVEYS_BY_LEAD_DATE_TIMESLOT);
            ps.setInt(1, leadId);
            ps.setString(2, "%" + date + "%");
            ps.setString(3, timeslot);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                User owner = UserDAO.getUserByNRIC(rs.getString("ss_owner"));
                String userId = rs.getString("ss_user");
                User user = UserDAO.getUserByNRIC(userId);
                
                String address = rs.getString("address");
                String addressTag = rs.getString("address_tag");
                String[] addrArray = address.split("\\|");
                String[] tagArray = addressTag.split("\\|");
                
                String tempStartString = rs.getString("start_datetime");
                String datetimeString = tempStartString.substring(0, tempStartString.lastIndexOf("."));
                DateTime start = dtf.parseDateTime(datetimeString);
                
                tempStartString = rs.getString("end_datetime");
                datetimeString = tempStartString.substring(0, tempStartString.lastIndexOf("."));
                DateTime end = dtf.parseDateTime(datetimeString);
                
                String remarks = rs.getString("remarks");
                String status = rs.getString("status");
                
                for(int i=0; i<addrArray.length; i++){
                    String addr = addrArray[i];
                    String tag = tagArray[i];
                    results.add(new SiteSurvey(leadId, owner, user, addr, tag, start, end, timeslot, remarks, status));
                }
                
            }
            
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    public static ArrayList<SiteSurvey> getNonCompletedSiteSurveysByUserKeyword(String nric, String keyword){
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        ArrayList<SiteSurvey> results = new ArrayList<SiteSurvey>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        User user = UserDAO.getUserByNRIC(nric);
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_NC_SITE_SURVEYS_BY_USER_KEYWORD);
            ps.setString(1, nric);
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");
            ps.setString(4, "%" + keyword + "%");
            ps.setString(5, "%" + keyword + "%");
            rs = ps.executeQuery();
            
            while (rs.next()) {
                int leadId = Integer.parseInt(rs.getString("lead_id"));
                User owner = UserDAO.getUserByNRIC(rs.getString("ss_owner"));
                String address = rs.getString("address");
                String addressTag = rs.getString("address_tag");
                String[] addrArray = address.split("\\|");
                String[] tagArray = addressTag.split("\\|");
                
                
                String tempStartString = rs.getString("start_datetime");
                String datetimeString = tempStartString.substring(0, tempStartString.lastIndexOf("."));
                DateTime start = dtf.parseDateTime(datetimeString);
                
                tempStartString = rs.getString("end_datetime");
                datetimeString = tempStartString.substring(0, tempStartString.lastIndexOf("."));
                DateTime end = dtf.parseDateTime(datetimeString);
                
                String remarks = rs.getString("remarks");
                String timeslot = rs.getString("timeslot");
                String status = rs.getString("status");
                
                for(int i=0; i<addrArray.length; i++){
                    String addr = addrArray[i];
                    String tag = tagArray[i];
                    results.add(new SiteSurvey(leadId, owner, user, addr, tag, start, end, timeslot, remarks, status));
                }
                
            }
            
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    public static ArrayList<SiteSurvey> getCompletedSiteSurveysByUserKeyword(String nric, String keyword){
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        ArrayList<SiteSurvey> results = new ArrayList<SiteSurvey>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        User user = UserDAO.getUserByNRIC(nric);
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_C_SITE_SURVEYS_BY_USER_KEYWORD);
            ps.setString(1, nric);
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");
            ps.setString(4, "%" + keyword + "%");
            ps.setString(5, "%" + keyword + "%");
            rs = ps.executeQuery();
            
            while (rs.next()) {
                int leadId = Integer.parseInt(rs.getString("lead_id"));
                User owner = UserDAO.getUserByNRIC(rs.getString("ss_owner"));
                String address = rs.getString("address");
                String addressTag = rs.getString("address_tag");
                String[] addrArray = address.split("\\|");
                String[] tagArray = addressTag.split("\\|");
                
                
                String tempStartString = rs.getString("start_datetime");
                String datetimeString = tempStartString.substring(0, tempStartString.lastIndexOf("."));
                DateTime start = dtf.parseDateTime(datetimeString);
                
                tempStartString = rs.getString("end_datetime");
                datetimeString = tempStartString.substring(0, tempStartString.lastIndexOf("."));
                DateTime end = dtf.parseDateTime(datetimeString);
                
                String remarks = rs.getString("remarks");
                String timeslot = rs.getString("timeslot");
                String status = rs.getString("status");
                
                for(int i=0; i<addrArray.length; i++){
                    String addr = addrArray[i];
                    String tag = tagArray[i];
                    results.add(new SiteSurvey(leadId, owner, user, addr, tag, start, end, timeslot, remarks, status));
                }
                
            }
            
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    public static ArrayList<SiteSurvey> getSiteSurveysByOwnerKeyword(String nric, String keyword){
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        ArrayList<SiteSurvey> results = new ArrayList<SiteSurvey>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        User owner = UserDAO.getUserByNRIC(nric);
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_SITE_SURVEYS_BY_OWNER_KEYWORD);
            ps.setString(1, nric);
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");
            ps.setString(4, "%" + keyword + "%");
            ps.setString(5, "%" + keyword + "%");
            rs = ps.executeQuery();
            
            while (rs.next()) {
                int leadId = Integer.parseInt(rs.getString("lead_id"));
                User user = UserDAO.getUserByNRIC(rs.getString("ss_user"));
                String address = rs.getString("address");
                String addressTag = rs.getString("address_tag");
                String[] addrArray = address.split("\\|");
                String[] tagArray = addressTag.split("\\|");
                
                
                String tempStartString = rs.getString("start_datetime");
                String datetimeString = tempStartString.substring(0, tempStartString.lastIndexOf("."));
                DateTime start = dtf.parseDateTime(datetimeString);
                
                tempStartString = rs.getString("end_datetime");
                datetimeString = tempStartString.substring(0, tempStartString.lastIndexOf("."));
                DateTime end = dtf.parseDateTime(datetimeString);
                
                String remarks = rs.getString("remarks");
                String timeslot = rs.getString("timeslot");
                String status = rs.getString("status");
                
                for(int i=0; i<addrArray.length; i++){
                    String addr = addrArray[i];
                    String tag = tagArray[i];
                    results.add(new SiteSurvey(leadId, owner, user, addr, tag, start, end, timeslot, remarks, status));
                }
                
            }
            
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
            
    public static void startSiteSurvey(int leadId, String date, String timeslot){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(START_SITE_SURVEY);
            ps.setInt(1, leadId);
            ps.setString(2, "%" + date + "%");
            ps.setString(3, timeslot);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static void completeSiteSurvey(int leadId, String date, String timeslot){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(COMPLETE_SITE_SURVEY);
            ps.setInt(1, leadId);
            ps.setString(2, "%" + date + "%");
            ps.setString(3, timeslot);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static void cancelSiteSurvey(int leadId, String date, String timeslot){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CANCEL_SITE_SURVEY);
            ps.setInt(1, leadId);
            ps.setString(2, "%" + date + "%");
            ps.setString(3, timeslot);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static ArrayList<SiteSurvey> getSiteSurveysByUserandSd(String owner, String date){
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        ArrayList<SiteSurvey> results = new ArrayList<SiteSurvey>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            owner = owner.trim();
            User user = UserDAO.getUserByNRIC(owner);
            date = date.trim();
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_SITE_SURVEYS_BY_USER_STARTDATE);
            ps.setString(1, owner);
            ps.setString(2, date);
            rs = ps.executeQuery();
            while (rs.next()) {
                int leadId = rs.getInt("lead_id");
                String address = rs.getString("address");
                String addressTag = rs.getString("address_tag");
                String[] addrArray = address.split("\\|");
                String[] tagArray = addressTag.split("\\|");
                
                String tempStartString = rs.getString("start_datetime");
                String datetimeString = tempStartString.substring(0, tempStartString.lastIndexOf("."));
                DateTime start = dtf.parseDateTime(datetimeString);
                
                tempStartString = rs.getString("end_datetime");
                datetimeString = tempStartString.substring(0, tempStartString.lastIndexOf("."));
                DateTime end = dtf.parseDateTime(datetimeString);
                
                String remarks = rs.getString("remarks");
                String timeslot = rs.getString("timeslot");
                String status = rs.getString("status");
                
                for(int i=0; i<addrArray.length; i++){
                    String addr = addrArray[i];
                    String tag = tagArray[i];
                    results.add(new SiteSurvey(leadId, user, user, addr, tag, start, end, timeslot, remarks, status));
                }
                
            }
            
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    public static ArrayList<SiteSurvey> getAllSiteSurveys(){
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        ArrayList<SiteSurvey> results = new ArrayList<SiteSurvey>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_ALL_SITE_SURVEYS);
            //ps.setString(1, date);
            rs = ps.executeQuery();
            while (rs.next()) {
                int leadId = rs.getInt("lead_id");
                String address = rs.getString("address");
                String addressTag = rs.getString("address_tag");
                
                String tempStartString = rs.getString("start_datetime");
                String datetimeString = tempStartString.substring(0, tempStartString.lastIndexOf("."));
                DateTime start = dtf.parseDateTime(datetimeString);
                
                tempStartString = rs.getString("end_datetime");
                datetimeString = tempStartString.substring(0, tempStartString.lastIndexOf("."));
                DateTime end = dtf.parseDateTime(datetimeString);
                
                String remarks = rs.getString("remarks");
                String timeslot = rs.getString("timeslot");
                String status = rs.getString("status");
                
                String ss_owner = rs.getString("ss_owner");
                User owner = UserDAO.getUserByNRIC(ss_owner);
                String ss_user = rs.getString("ss_user");
                User user = UserDAO.getUserByNRIC(ss_user);

                    results.add(new SiteSurvey(leadId, owner, user, address, addressTag, start, end, timeslot, remarks, status));
                
                
            }
            
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
}

