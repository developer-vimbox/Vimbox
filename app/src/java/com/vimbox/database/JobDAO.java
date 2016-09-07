package com.vimbox.database;

import com.vimbox.operations.Job;
import com.vimbox.operations.Truck;
import com.vimbox.user.User;
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

public class JobDAO {
    
    private static final String CHECK_JOB_EXIST = "SELECT * FROM operations_assigned WHERE start_datetime LIKE ? AND carplate_no = ?";
    private static final String GET_JOBS_BY_DATE = "SELECT * FROM operations_assigned WHERE start_datetime LIKE ?";
    private static final String CREATE_OPERATION_ASSIGNMENT = "INSERT INTO operations_assigned VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
    private static final String GET_JOBS_BY_LEAD_ID = "SELECT * FROM operations_assigned WHERE lead_id=?";
    private static final String GET_JOBS_BY_KEYWORD = "SELECT * FROM operations_assigned WHERE (lead_id like ? OR start_datetime LIKE ? OR end_datetime LIKE ? OR timeslot LIKE ?) ORDER BY start_datetime";
    private static final String GET_CONFIRMED_JOBS_BY_KEYWORD = "SELECT * FROM operations_assigned WHERE (lead_id like ? OR start_datetime LIKE ? OR end_datetime LIKE ? OR timeslot LIKE ?) AND status = 'Confirmed' ORDER BY DATE(start_datetime) DESC, carplate_no";
    private static final String GET_JOBS_BY_TRUCK_DATE = "SELECT * FROM operations_assigned WHERE carplate_no=? AND start_datetime LIKE ? AND status != 'Cancelled' ORDER BY start_datetime";
    private static final String CANCEL_JOB = "UPDATE operations_assigned SET status='Cancelled' WHERE lead_id = ? AND start_datetime LIKE ? AND timeslot = ?";
    private static final String GET_ALL_NON_CANCELLED_JOBS = "SELECT * FROM operations_assigned where status != 'Cancelled' group by lead_id, SUBSTRING(start_datetime, 1, 10);";
    private static final String GET_NON_CANCELLED_JOBS_BY_TRUCK = "SELECT * FROM operations_assigned where carplate_no = ? AND status != 'Cancelled' group by lead_id, SUBSTRING(start_datetime, 1, 10);";
    private static final String UPDATE_JOB_SUPERVISOR = "UPDATE operations_assigned SET supervisor=? WHERE lead_id=?";
    
    public static void assignJobAttendance(ArrayList<Integer> leadIds, String supervisor){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(UPDATE_JOB_SUPERVISOR);
            for(int leadId : leadIds){
                ps.setString(1, supervisor);
                ps.setInt(2, leadId);
                ps.executeUpdate();
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static void createOperationAssignment(int leadId, String owner, ArrayList<String> adds, ArrayList<String> addsTags, String date, HashMap<String,ArrayList<String>> times, HashMap<String,String> timeslot, String remarks, String status){
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
            for (Map.Entry<String, ArrayList<String>> entry : times.entrySet()) {
                String cp = entry.getKey();
                ArrayList<String> list = entry.getValue();
                for (String time : list) {
                    String startTime = time.substring(0, time.indexOf(" "));
                    String endTime = time.substring(time.lastIndexOf(" ") + 1);
                    String startDate = date + " " + startTime.substring(0, 2) + ":" + startTime.substring(2) + ":00";
                    String endDate = date + " " + endTime.substring(0, 2) + ":" + endTime.substring(2) + ":00";

                    ps = con.prepareStatement(CREATE_OPERATION_ASSIGNMENT);
                    ps.setInt(1, leadId);
                    ps.setString(2, owner);
                    ps.setString(3, "");
                    ps.setString(4, cp);
                    ps.setString(5, addressTags);
                    ps.setString(6, address);
                    ps.setDate(7, java.sql.Date.valueOf(date));
                    ps.setString(8, startDate);
                    ps.setString(9, endDate);
                    ps.setString(10, timeslot.get(cp));
                    ps.setString(11, remarks);
                    ps.setString(12, status);
                    ps.executeUpdate();
                }
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static boolean checkJobTimeslot(String date, String carplate, String time){
        String startTime = time.substring(0, time.indexOf(" "));
        String startDate = date + " " + startTime.substring(0, 2) + ":" + startTime.substring(2) + ":00";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CHECK_JOB_EXIST);
            ps.setString(1, "%" + startDate + "%");
            ps.setString(2, carplate);
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
    
    public static ArrayList<Job> getJobsByTruck(String carplate){
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        ArrayList<Job> results = new ArrayList<Job>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Truck assignedTruck = TruckDAO.getTruckByCarplate(carplate);
        try {
            con = ConnectionManager.getConnection();
            if(carplate.equals("alltt")) {
                ps = con.prepareStatement(GET_ALL_NON_CANCELLED_JOBS);
                rs = ps.executeQuery();
            } else {
                ps = con.prepareStatement(GET_NON_CANCELLED_JOBS_BY_TRUCK);
                ps.setString(1, carplate);
                rs = ps.executeQuery();
            }
            
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
                String cp = rs.getString("carplate_no");
                
                User supervisor = UserDAO.getUserByNRIC(rs.getString("supervisor"));
                
                results.add(new Job(leadId, owner, supervisor, assignedTruck, date_dom, addressMap, start, end, remarks, timeslot, status));
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
                String carplate = rs.getString("carplate_no");
                Truck assignedTruck = TruckDAO.getTruckByCarplate(carplate);
                User supervisor = UserDAO.getUserByNRIC(rs.getString("supervisor"));
                
                results.add(new Job(leadId, owner, supervisor, assignedTruck, date_dom, addressMap, start, end, remarks, timeslot, status));
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

                String carplate = rs.getString("carplate_no");
                Truck assignedTruck = TruckDAO.getTruckByCarplate(carplate);
                
                User supervisor = UserDAO.getUserByNRIC(rs.getString("supervisor"));
                
                results.add(new Job(leadId, owner, supervisor, assignedTruck, date_dom, addressMap, start, end, remarks, timeslot, status));
            }

        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
            
    public static ArrayList<Job> getConfirmedJobsByKeyword(String keyword) {
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        ArrayList<Job> results = new ArrayList<Job>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_CONFIRMED_JOBS_BY_KEYWORD);
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");
            ps.setString(4, "%" + keyword + "%");
            rs = ps.executeQuery();

            while (rs.next()) {
                int leadId = rs.getInt("lead_id");
                java.sql.Date dom = rs.getDate("dom");
                Date date_dom = new Date(dom.getTime());
                User owner = UserDAO.getUserByNRIC(rs.getString("ss_owner"));
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

                String carplate = rs.getString("carplate_no");
                Truck assignedTruck = TruckDAO.getTruckByCarplate(carplate);
                
                User supervisor = UserDAO.getUserByNRIC(rs.getString("supervisor"));
                
                results.add(new Job(leadId, owner, supervisor, assignedTruck, date_dom, addressMap, start, end, remarks, timeslot, status));
            }

        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
            
    public static ArrayList<Job> getJobsByKeyword(String keyword) {
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        ArrayList<Job> results = new ArrayList<Job>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_JOBS_BY_KEYWORD);
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");
            ps.setString(4, "%" + keyword + "%");
            rs = ps.executeQuery();

            while (rs.next()) {
                int leadId = rs.getInt("lead_id");
                java.sql.Date dom = rs.getDate("dom");
                Date date_dom = new Date(dom.getTime());
                User owner = UserDAO.getUserByNRIC(rs.getString("ss_owner"));
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

                String carplate = rs.getString("carplate_no");
                Truck assignedTruck = TruckDAO.getTruckByCarplate(carplate);
                User supervisor = UserDAO.getUserByNRIC(rs.getString("supervisor"));
                
                results.add(new Job(leadId, owner, supervisor, assignedTruck, date_dom, addressMap, start, end, remarks, timeslot, status));
            }

        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    public static ArrayList<Job> getJobsByTruckDate(String carplate, String date) {
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        ArrayList<Job> results = new ArrayList<Job>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Truck assignedTruck = TruckDAO.getTruckByCarplate(carplate);
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_JOBS_BY_TRUCK_DATE);
            ps.setString(1, carplate);
            ps.setString(2, "%" + date + "%");
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
                User supervisor = UserDAO.getUserByNRIC(rs.getString("supervisor"));
                
                results.add(new Job(leadId, owner, supervisor, assignedTruck, date_dom, addressMap, start, end, remarks, timeslot, status));
            }

        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    public static void cancelJob(int leadId, String date, String timeslot) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CANCEL_JOB);
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
}
