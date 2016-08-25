package com.vimbox.database;

import com.vimbox.operations.Job;
import com.vimbox.sitesurvey.SiteSurvey;
import com.vimbox.user.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public class JobsDAO {
    
    private static final String GET_ALL_JOBS = "SELECT * FROM operations_assigned group by lead_id";
    private static final String GET_JOBS_BY_DATE = "SELECT * FROM operations_assigned WHERE start_datetime LIKE ?";
    private static final String CREATE_OPERATION_ASSIGNMENT = "INSERT INTO operations_assigned VALUES (?,?,?,?,?,?,?,?,?,?)";
    private static final String GET_JOBS_BY_LEAD_ID = "SELECT * FROM operations_assigned WHERE lead_id=?";
    
    public static void createOperationAssignment(int leadId, String owner, ArrayList<String> adds, ArrayList<String> addsTags, String date, ArrayList<String> times, String timeslot, String remarks, String status){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            String address = "";
            for (String add : adds) {
                address += add + "|";
            }
            String addressTags = "";
            for (String addsTag : addsTags) {
                addressTags += addsTag + "|";
            }

            for (String time : times) {
                String startTime = time.substring(0, time.indexOf(" "));
                String endTime = time.substring(time.lastIndexOf(" ") + 1);
                String startDate = date + " " + startTime.substring(0, 2) + ":" + startTime.substring(2) + ":00";
                String endDate = date + " " + endTime.substring(0, 2) + ":" + endTime.substring(2) + ":00";

                ps = con.prepareStatement(CREATE_OPERATION_ASSIGNMENT);
                ps.setInt(1, leadId);
                ps.setString(2, owner);
                ps.setString(3, addressTags);
                ps.setString(4, address);
                ps.setDate(5, java.sql.Date.valueOf(date));
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
    
    public static boolean checkJobTimeslot(String date, String time){
        String startTime = time.substring(0, time.indexOf(" "));
        String startDate = date + " " + startTime.substring(0, 2) + ":" + startTime.substring(2) + ":00";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_JOBS_BY_DATE);
            ps.setString(1, "%" + startDate + "%");
            rs = ps.executeQuery();
            if(rs.next()){
                return true;
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return false;
    }
    
    public static ArrayList<Job> getAllJobs(){
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        ArrayList<Job> results = new ArrayList<Job>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_ALL_JOBS);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                int leadId = rs.getInt("lead_id");
                java.sql.Date dom = rs.getDate("dom");
                Date date_dom = new Date(dom.getTime());
                
                String address = rs.getString("address");
                String addressTag = rs.getString("address_tag");
                String[] addressArr = address.split("\\|");
                String[] addressTagArr = addressTag.split("\\|");
                HashMap<String, String> addressMap = new HashMap<String, String>();
                for(int i=0; i<addressArr.length; i++){
                    String addr = addressArr[i];
                    String tag = addressTagArr[i];
                    addressMap.put(addr, tag);
                }

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

                results.add(new Job(leadId, owner, date_dom, addressMap, start, end, timeslot, remarks, status));
            }

        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    
    public static ArrayList<Job> getJobsByDate(String date){
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        ArrayList<Job> results = new ArrayList<Job>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_JOBS_BY_DATE);
            ps.setString(1, "%" + date + "%");
            rs = ps.executeQuery();
            
            while (rs.next()) {
                int leadId = rs.getInt("lead_id");
                java.sql.Date dom = rs.getDate("dom");
                Date date_dom = new Date(dom.getTime());
                
                String address = rs.getString("address");
                String addressTag = rs.getString("address_tag");
                String[] addressArr = address.split("\\|");
                String[] addressTagArr = addressTag.split("\\|");
                HashMap<String, String> addressMap = new HashMap<String, String>();
                for(int i=0; i<addressArr.length; i++){
                    String addr = addressArr[i];
                    String tag = addressTagArr[i];
                    addressMap.put(addr, tag);
                }

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

                results.add(new Job(leadId, owner, date_dom, addressMap, start, end, timeslot, remarks, status));
            }

        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    public static ArrayList<Job> getJobsByLeadId(int leadId){
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        ArrayList<Job> results = new ArrayList<Job>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_JOBS_BY_LEAD_ID);
            ps.setInt(1, leadId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                java.sql.Date dom = rs.getDate("dom");
                Date date_dom = new Date(dom.getTime());
                
                String address = rs.getString("address");
                String addressTag = rs.getString("address_tag");
                String[] addressArr = address.split("\\|");
                String[] addressTagArr = addressTag.split("\\|");
                HashMap<String, String> addressMap = new HashMap<String, String>();
                for(int i=0; i<addressArr.length; i++){
                    String addr = addressArr[i];
                    String tag = addressTagArr[i];
                    addressMap.put(addr, tag);
                }

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

                results.add(new Job(leadId, owner, date_dom, addressMap, start, end, timeslot, remarks, status));
            }

        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
}
