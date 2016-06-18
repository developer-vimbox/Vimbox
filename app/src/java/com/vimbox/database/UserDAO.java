package com.vimbox.database;

import com.vimbox.user.Address;
import com.vimbox.user.Module;
import com.vimbox.user.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import org.joda.time.DateTime;

public class UserDAO {
    
    private static final String GET_USERS = "SELECT * FROM users";
    private static final String GET_USERS_BY_KEYWORD = "SELECT * FROM users WHERE nric like ? OR first_name like ? OR last_name like ? OR contact like ? OR designation like ?";
    private static final String GET_PT_USERS_BY_KEYWORD = "SELECT * FROM users_part_time WHERE nric like ? OR first_name like ? OR last_name like ? OR contact like ? OR designation like ?";
    private static final String GET_USER_BY_USERNAME = "SELECT * FROM users WHERE username=?";
    private static final String GET_USER_BY_NRIC = "SELECT * FROM users WHERE nric=?";
    private static final String UPDATE_USER_PASSWORD = "UPDATE users SET password=? WHERE nric=?";
    private static final String CREATE_USER = "INSERT INTO users VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
    private static final String CREATE_PART_TIME_USER = "INSERT INTO users_part_time VALUES (?,?,?,?,?,?)";
    
    public static void createUser(String nric, String username, String password, String first_name, String last_name, String gender, Date dob, String address, Date dj, int contact, String designation, String modules){
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_USER);
            ps.setString(1, nric);
            ps.setString(2, username);
            ps.setString(3, password);
            ps.setString(4, first_name);
            ps.setString(5, last_name);
            ps.setString(6, gender);
            ps.setDate(7, new java.sql.Date(dob.getTime()));
            ps.setString(8, address);
            ps.setDate(9, new java.sql.Date(dj.getTime()));
            ps.setInt(10, contact);
            ps.setString(11, designation);
            ps.setString(12, modules);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
    }
    
    public static void createPartTimeUser(String nric, String first_name, String last_name, Date dj, int contact, String designation){
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_PART_TIME_USER);
            ps.setString(1, nric);
            ps.setString(2, first_name);
            ps.setString(3, last_name);
            ps.setDate(4, new java.sql.Date(dj.getTime()));
            ps.setInt(5, contact);
            ps.setString(6, designation);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
    }
    
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
                String nric = rs.getString("nric");
                String username = rs.getString("username");
                String password = rs.getString("password");
                String first_name = rs.getString("first_name");
                String last_name = rs.getString("last_name");
                String gender = rs.getString("gender");
                DateTime date_of_birth = new DateTime(rs.getDate("date_of_birth"));
                DateTime date_joined = new DateTime(rs.getDate("date_joined"));
                Address address = new Address(rs.getString("address"));
                int contact = rs.getInt("contact");
                String designation = rs.getString("designation");
                String[] mods = rs.getString("modules").split("\\|");
                ArrayList<Module> modules = new ArrayList<Module>();
                for(String mod:mods){
                    modules.add(new Module(mod));
                }
                User user = new User(nric, username, password, first_name, last_name, gender, date_of_birth, date_joined, address, contact, designation, modules);
                users.add(user);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return users;
    }
    
    public static ArrayList<User> getUsersByKeyword(String keyword) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ArrayList<User> users = new ArrayList<User>();
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_USERS_BY_KEYWORD);
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");
            ps.setString(4, "%" + keyword + "%");
            ps.setString(5, "%" + keyword + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                String nric = rs.getString("nric");
                String username = rs.getString("username");
                String password = rs.getString("password");
                String first_name = rs.getString("first_name");
                String last_name = rs.getString("last_name");
                String gender = rs.getString("gender");
                DateTime date_of_birth = new DateTime(rs.getDate("date_of_birth"));
                DateTime date_joined = new DateTime(rs.getDate("date_joined"));
                Address address = new Address(rs.getString("address"));
                int contact = rs.getInt("contact");
                String designation = rs.getString("designation");
                String[] mods = rs.getString("modules").split("\\|");
                ArrayList<Module> modules = new ArrayList<Module>();
                for(String mod:mods){
                    modules.add(new Module(mod));
                }
                User user = new User(nric, username, password, first_name, last_name, gender, date_of_birth, date_joined, address, contact, designation, modules);
                users.add(user);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return users;
    }
    
    public static ArrayList<User> getPartTimeUsersByKeyword(String keyword) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ArrayList<User> users = new ArrayList<User>();
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_PT_USERS_BY_KEYWORD);
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");
            ps.setString(4, "%" + keyword + "%");
            ps.setString(5, "%" + keyword + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                String nric = rs.getString("nric");
                String first_name = rs.getString("first_name");
                String last_name = rs.getString("last_name");
                DateTime date_joined = new DateTime(rs.getDate("date_joined"));
                int contact = rs.getInt("contact");
                String designation = rs.getString("designation");
                User user = new User(nric, first_name, last_name, date_joined, contact, designation);
                users.add(user);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return users;
    }
    
    public static User getUserByUsername(String login_username){
        User user = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
         try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_USER_BY_USERNAME);
            ps.setString(1, login_username);
            rs = ps.executeQuery();
            if(rs.next()){
                String nric = rs.getString("nric");
                String username = rs.getString("username");
                String password = rs.getString("password");
                String first_name = rs.getString("first_name");
                String last_name = rs.getString("last_name");
                String gender = rs.getString("gender");
                DateTime date_of_birth = new DateTime(rs.getDate("date_of_birth"));
                DateTime date_joined = new DateTime(rs.getDate("date_joined"));
                Address address = new Address(rs.getString("address"));
                int contact = rs.getInt("contact");
                String designation = rs.getString("designation");
                String[] mods = rs.getString("modules").split("\\|");
                ArrayList<Module> modules = new ArrayList<Module>();
                for(String mod:mods){
                    modules.add(new Module(mod));
                }
                user = new User(nric, username, password, first_name, last_name, gender, date_of_birth, date_joined, address, contact, designation, modules);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return user;
    }
    
    public static User getUserByNRIC(String nric){
        User user = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
         try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_USER_BY_NRIC);
            ps.setString(1, nric);
            rs = ps.executeQuery();
            if(rs.next()){
                String username = rs.getString("username");
                String password = rs.getString("password");
                String first_name = rs.getString("first_name");
                String last_name = rs.getString("last_name");
                String gender = rs.getString("gender");
                DateTime date_of_birth = new DateTime(rs.getDate("date_of_birth"));
                DateTime date_joined = new DateTime(rs.getDate("date_joined"));
                Address address = new Address(rs.getString("address"));
                int contact = rs.getInt("contact");
                String designation = rs.getString("designation");
                String[] mods = rs.getString("modules").split("\\|");
                ArrayList<Module> modules = new ArrayList<Module>();
                for(String mod:mods){
                    modules.add(new Module(mod));
                }
                user = new User(nric, username, password, first_name, last_name, gender, date_of_birth, date_joined, address, contact, designation, modules);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return user;
    }
    
    public static void updateUserPassword(String password, String nric){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(UPDATE_USER_PASSWORD);
            ps.setString(1, password);
            ps.setString(2, nric);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
}
