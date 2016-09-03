package com.vimbox.database;

import com.vimbox.operations.JobAttendance;
import com.vimbox.user.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class JobsAttendanceDAO {
    private static final String GET_JOB_ATTENDANCE_BY_ID = "SELECT * FROM operations_attendance WHERE job_id=?";
    private static final String CREATE_JOB_ATTENDANCE = "INSERT INTO operations_attendance VALUES (?,?,?,?)";
    private static final String UPDATE_JOB_ATTENDANCE = "UPDATE operations_attendance SET supervisor=?, assigned=? WHERE job_id=?";
    
    public static boolean checkJobAttendanceExist(int jobId){
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_JOB_ATTENDANCE_BY_ID);
            ps.setInt(1, jobId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return true;
            }

        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return false;
    }
    
    public static void assignJobAttendance(int jobId, String supervisor, String assigned){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            if(checkJobAttendanceExist(jobId)){
                ps = con.prepareStatement(UPDATE_JOB_ATTENDANCE);
                ps.setString(1, supervisor);
                ps.setString(2, assigned);
                ps.setInt(3, jobId);
            }else{
                ps = con.prepareStatement(CREATE_JOB_ATTENDANCE);
                ps.setInt(1, jobId);
                ps.setString(2, supervisor);
                ps.setString(3, assigned);
                ps.setString(4, "");
            }
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static JobAttendance getJobAttendanceByJobId(int jobId){
        JobAttendance ja = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_JOB_ATTENDANCE_BY_ID);
            ps.setInt(1, jobId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                User supervisor = UserDAO.getUserByNRIC(rs.getString("supervisor"));
                String ftMoversStr = rs.getString("assigned");
                String[] ftMoversArr = ftMoversStr.split("\\|");
                ArrayList<User> ftMovers = new ArrayList<User>();
                for(String mover : ftMoversArr){
                    ftMovers.add(UserDAO.getUserByNRIC(mover));
                }
                
                String ptMoversStr = rs.getString("pt_movers");
                String[] ptMoversArr = ptMoversStr.split("\\|");
                ArrayList<User> ptMovers = new ArrayList<User>();
                for(String mover : ptMoversArr){
                    ptMovers.add(UserDAO.getUserByNRIC(mover));
                }
                
                ja = new JobAttendance(jobId, supervisor, ftMovers, ptMovers);
            }

        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return ja;
    }
}
