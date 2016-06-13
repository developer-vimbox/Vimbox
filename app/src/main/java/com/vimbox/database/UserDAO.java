package com.vimbox.database;

import com.vimbox.user.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class UserDAO {
    
    private static final String GET_USERS = "SELECT * FROM users";
    private static final String GET_USERS_FULL_NAMES = "SELECT fullname FROM users ORDER BY fullname ASC";
    private static final String GET_USER_BY_USERNAME = "SELECT * FROM users WHERE username=?";
    private static final String GET_USER_BY_FULLNAME = "SELECT * FROM users WHERE fullname=?";
    private static final String UPDATE_USER_PASSWORD = "UPDATE users SET password=? WHERE username=?";
    
    public static ArrayList<User> getUsers() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ArrayList<User> users = new ArrayList<User>();
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_USERS);
            rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User(
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("fullname"),
                        rs.getString("modules")
                );
                users.add(user);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return users;
    }
    
    public static ArrayList<String> getUsersFullnames(){
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ArrayList<String> fullnames = new ArrayList<String>();
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_USERS_FULL_NAMES);
            rs = ps.executeQuery();
            while (rs.next()) {
                String fullname = rs.getString("fullname");
                fullnames.add(fullname);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return fullnames;
    }
    
    public static User getUserByUsername(String username){
        User user = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
         try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_USER_BY_USERNAME);
            ps.setString(1, username);
            rs = ps.executeQuery();
            if(rs.next()){
                user = new User(
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("fullname"),
                        rs.getString("modules")
                );
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return user;
    }
    
    public static User getUserByFullname(String fullname){
        User user = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
         try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_USER_BY_FULLNAME);
            ps.setString(1, fullname);
            rs = ps.executeQuery();
            if(rs.next()){
                user = new User(
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("fullname"),
                        rs.getString("modules")
                );
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return user;
    }
    
    public static void updateUserPassword(String password, String username){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(UPDATE_USER_PASSWORD);
            ps.setString(1, password);
            ps.setString(2, username);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
}
