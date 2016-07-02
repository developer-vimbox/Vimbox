package com.vimbox.database;

import com.vimbox.hr.Attendance;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public class UserAttendanceDAO {

    private static final String GET_ATTENDANCE_BY_DATE = "SELECT * FROM users_attendance_record WHERE date=?";
    private static final String GET_YEARMONTHS= "SELECT date FROM users_attendance_record GROUP BY Month(date);";
    private static final String GET_YEARMONTHS_BY_KEYWORD = "SELECT date FROM users_attendance_record WHERE date LIKE ? GROUP BY Month(date)";
    private static final String GET_ATTENDANCES_BY_YEARMONTH = "SELECT * FROM users_attendance_record WHERE date LIKE ? ORDER BY date";
    private static final String CREATE_ATTENDANCE = "INSERT INTO users_attendance_record VALUES (?,?,?,?)";
    private static final String DELETE_ATTENDANCE_BY_DATE = "DELETE FROM users_attendance_record WHERE date=?";

    public static void deleteAttendanceByDate(DateTime date) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(DELETE_ATTENDANCE_BY_DATE);
            ps.setDate(1, new java.sql.Date(date.toDate().getTime()));
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static ArrayList<String> getYearMonthByKeyword(String keyword){
        ArrayList<String> results = new ArrayList<String>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            if(keyword.isEmpty()){
                ps = con.prepareStatement(GET_YEARMONTHS);
            }else{
                ps = con.prepareStatement(GET_YEARMONTHS_BY_KEYWORD);
                ps.setString(1, "%" + keyword + "%");
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                String date = rs.getString("date");
                results.add(date.substring(0, date.lastIndexOf("-")));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        
        return results;
    }
    
    public static ArrayList<Attendance> getAttendancesByYearMonth(String keyword) {
        ArrayList<Attendance> results = new ArrayList<Attendance>();
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd");
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_ATTENDANCES_BY_YEARMONTH);
            ps.setString(1, "%" + keyword + "%");
            rs = ps.executeQuery();
            if (rs.next()) {
                HashMap<String, String> attendance_record = new HashMap<String, String>();
                HashMap<String, Double> late_record = new HashMap<String, Double>();
                String startDt = rs.getString("date");
                DateTime dateTime = dtf.parseDateTime(startDt);

                String nric = rs.getString("nric");
                String status = rs.getString("status");
                attendance_record.put(nric, status);

                double duration = rs.getDouble("duration");
                if (duration > 0) {
                    late_record.put(nric, duration);
                }

                while (rs.next()) {
                    String nextDt = rs.getString("date");
                    if(!nextDt.equals(startDt)){
                        results.add(new Attendance(dateTime, attendance_record, late_record));
                        attendance_record = new HashMap<String, String>();
                        late_record = new HashMap<String, Double>();
                        dateTime = dtf.parseDateTime(nextDt);
                    }
                    nric = rs.getString("nric");
                    status = rs.getString("status");
                    attendance_record.put(nric, status);

                    duration = rs.getDouble("duration");
                    if (duration > 0) {
                        late_record.put(nric, duration);
                    }
                }
                
                results.add(new Attendance(dateTime, attendance_record, late_record));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    public static Attendance getAttendanceByDate(DateTime date) {
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd");
        Attendance attendance = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_ATTENDANCE_BY_DATE);
            ps.setDate(1, new java.sql.Date(date.toDate().getTime()));
            rs = ps.executeQuery();
            HashMap<String, String> attendance_record = null;
            HashMap<String, Double> late_record = null;
            DateTime dateTime = null;
            if (rs.next()) {
                attendance_record = new HashMap<String, String>();
                late_record = new HashMap<String, Double>();
                dateTime = dtf.parseDateTime(rs.getString("date"));

                String nric = rs.getString("nric");
                String status = rs.getString("status");
                attendance_record.put(nric, status);

                double duration = rs.getDouble("duration");
                if (duration > 0) {
                    late_record.put(nric, duration);
                }

                while (rs.next()) {
                    nric = rs.getString("nric");
                    status = rs.getString("status");
                    attendance_record.put(nric, status);

                    duration = rs.getDouble("duration");
                    if (duration > 0) {
                        late_record.put(nric, duration);
                    }
                }
            }

            if (dateTime != null) {
                attendance = new Attendance(dateTime, attendance_record, late_record);
            }

        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }

        return attendance;
    }

    public static void createAttendance(DateTime date, HashMap<String, String> attendance_record, HashMap<String, Double> late_record) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            for (Map.Entry<String, String> entry : attendance_record.entrySet()) {
                ps = con.prepareStatement(CREATE_ATTENDANCE);
                ps.setString(1, entry.getKey());
                ps.setDate(2, new java.sql.Date(date.toDate().getTime()));
                ps.setString(3, entry.getValue());
                ps.setDouble(4, late_record.get(entry.getKey()));
                ps.executeUpdate();
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
}
