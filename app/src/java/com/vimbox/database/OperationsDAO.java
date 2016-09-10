package com.vimbox.database;

import com.vimbox.operations.MoversAttendance;
import com.vimbox.user.Account;
import com.vimbox.user.Bank;
import com.vimbox.user.Contact;
import com.vimbox.user.Emergency;
import com.vimbox.user.Module;
import com.vimbox.user.User;
import com.vimbox.util.Converter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import org.joda.time.DateTime;

public class OperationsDAO {
    private static final String CHECK_ASSIGNED_MOVERS = "SELECT * FROM operations_attendance WHERE dom = ? AND assigned_mover = ?";
    private static final String ASSIGN_MOVER = "INSERT INTO operations_attendance (supervisor, assigned_mover, dom, status, duration) VALUES (?,?,?,?,?)";
    private static final String GET_MOVERS_BY_SUP_AND_DOM = "SELECT * FROM operations_attendance WHERE dom = ? AND supervisor = ?";
    private static final String REMOVE_MOVER = "DELETE FROM operations_attendance WHERE supervisor = ? AND dom = ? AND assigned_mover = ?";
    
    public static boolean checkAssigned(String dom, String sMover) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean r = false;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CHECK_ASSIGNED_MOVERS);
            ps.setString(1, dom);
            ps.setString(2, sMover);
            rs = ps.executeQuery();
            while (rs.next()) {
                r = true;
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return r;
    }
    
    public static int assignMovers(String supervisor, String mover, String dom){
        String status = "Assigned";
        int duration = 0;
        int i = -1;
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(ASSIGN_MOVER);
            ps.setString(1,supervisor);
            ps.setString(2,mover);
            ps.setString(3,dom);
            ps.setString(4,status);
            ps.setInt(5, duration);
            i = ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
        return i;
    }
    
    public static ArrayList<User> getMoversBySupAndDOM(String supervisor, String dom){
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ArrayList<User> movers = new ArrayList<User>();
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_MOVERS_BY_SUP_AND_DOM);
            ps.setString(1,dom);
            ps.setString(2,supervisor);
            rs = ps.executeQuery();
            while(rs.next()){
                String mover = rs.getString("assigned_mover");
                User u = UserDAO.getUserByNRIC(mover);
                movers.add(u);   
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return movers;
    }
    
    public static void removeMover(String supervisor, String mover, String dom){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(REMOVE_MOVER);
            ps.setString(1, supervisor);
            ps.setString(2, dom);
            ps.setString(3, mover);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static ArrayList<MoversAttendance> getMoverAttendance(String supervisor, String dom){
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ArrayList<MoversAttendance> movers = new ArrayList<MoversAttendance>();
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_MOVERS_BY_SUP_AND_DOM);
            ps.setString(1,dom);
            ps.setString(2,supervisor);
            rs = ps.executeQuery();
            while(rs.next()){
                String mover = rs.getString("assigned_mover");
                User m = UserDAO.getUserByNRIC(mover);
                String sup = rs.getString("supervisor");
                String date = rs.getString("dom");
                String status = rs.getString("status");
                int duration = rs.getInt("duration");
                movers.add(new MoversAttendance(sup, m, date, status, duration));  
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return movers;
    }
}
