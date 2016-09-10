package com.vimbox.database;

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
import java.util.ArrayList;
import java.util.Date;
import org.joda.time.DateTime;

public class UserDAO {

    private static final String GET_USER_ACCOUNT_BY_USERNAME = "SELECT * FROM users_account WHERE username=?";
    private static final String GET_USER_ACCOUNT_BY_NRIC = "SELECT * FROM users_account WHERE nric=?";
    private static final String GET_USER_BY_NRIC = "SELECT * FROM users WHERE nric=?";
    private static final String GET_USER_CONTACT_BY_NRIC = "SELECT * FROM users_contact WHERE nric=?";
    private static final String GET_USER_EMERGENCY_BY_NRIC = "SELECT * FROM users_emergency WHERE nric=?";
    private static final String GET_USER_BANK_BY_NRIC = "SELECT * FROM users_bank WHERE nric=?";
    private static final String GET_USER_LEAVEMC_BY_NRIC = "SELECT * FROM users_leave WHERE nric=?";
    private static final String UPDATE_USER_PASSWORD = "UPDATE users_account SET password=? WHERE nric=?";
    private static final String GET_USERS = "SELECT * FROM users";
    private static final String GET_FULL_TIME_USERS = "SELECT * FROM users WHERE type='Full'";
    private static final String GET_FULL_TIME_USERS_BY_NAME = "SELECT * FROM users WHERE type='Full' AND (first_name LIKE ? OR last_name LIKE ? OR CONCAT(last_name, ' ', first_name) LIKE ?)";
    private static final String GET_SITE_SURVEYORS_BY_NAME = "SELECT * FROM users WHERE type='Full' AND designation='Surveyor' AND (first_name LIKE ? OR last_name LIKE ? OR CONCAT(last_name, ' ', first_name) LIKE ?)";
    private static final String GET_FT_USERS_BY_KEYWORD = "SELECT * FROM users WHERE (nric like ? OR first_name like ? OR last_name like ? OR CONCAT(last_name, ' ', first_name) LIKE ? OR date_joined like ? OR department like ? OR designation like ?) AND type='Full'";
    private static final String GET_PT_USERS_BY_KEYWORD = "SELECT * FROM users WHERE (nric like ? OR first_name like ? OR last_name like ? OR CONCAT(last_name, ' ', first_name) LIKE ? OR date_joined like ? OR department like ? OR designation like ?) AND type='Part'";
    private static final String CREATE_USER = "INSERT INTO users VALUES (?,?,?,?,?,?,?,?,?,?)";
    private static final String CREATE_USER_CONTACT = "INSERT INTO users_contact VALUES (?,?,?,?)";
    private static final String CREATE_USER_EMERGENCY = "INSERT INTO users_emergency VALUES (?,?,?,?,?)";
    private static final String CREATE_USER_ACCOUNT = "INSERT INTO users_account VALUES (?,?,?)";
    private static final String CREATE_USER_BANK = "INSERT INTO users_bank VALUES (?,?,?,?,?)";
    private static final String CREATE_USER_LEAVE = "INSERT INTO users_leave VALUES (?,?,?,?,?,?)";
    private static final String DELETE_USER = "DELETE FROM users WHERE nric=?";
    private static final String DELETE_USER_CONTACT = "DELETE FROM users_contact WHERE nric=?";
    private static final String DELETE_USER_EMERGENCY = "DELETE FROM users_emergency WHERE nric=?";
    private static final String DELETE_USER_BANK = "DELETE FROM users_bank WHERE nric=?";
    private static final String DELETE_USER_LEAVE = "DELETE FROM users_leave WHERE nric=?";
    private static final String UPDATE_USER_ACCOUNT = "UPDATE users_account SET nric=? WHERE nric=?";
    private static final String UPDATE_USER_LEAVE = "UPDATE users_leave SET used_leave=? WHERE nric=?";
    private static final String UPDATE_USER_MC = "UPDATE users_leave SET used_mc=? WHERE nric=?";
    private static final String GET_ALL_SURVEYORS = "SELECT * FROM users where designation = 'Surveyor'";
    private static final String GET_ALL_FULL_TIME_MOVERS = "SELECT * FROM users where type='Full' AND designation = 'Mover'";
    private static final String GET_MOVERS_BY_TYPE = "SELECT * FROM users WHERE designation = ? AND TYPE = ?";

    public static boolean checkNric(String nric){
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_USER_BY_NRIC);
            ps.setString(1, nric);
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
    
    public static boolean checkUsername(String username){
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_USER_ACCOUNT_BY_USERNAME);
            ps.setString(1, username);
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
    
    public static void deleteUser(String nric) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(DELETE_USER);
            ps.setString(1, nric);
            ps.executeUpdate();
            ps = con.prepareStatement(DELETE_USER_CONTACT);
            ps.setString(1, nric);
            ps.executeUpdate();
            ps = con.prepareStatement(DELETE_USER_EMERGENCY);
            ps.setString(1, nric);
            ps.executeUpdate();
            ps = con.prepareStatement(DELETE_USER_BANK);
            ps.setString(1, nric);
            ps.executeUpdate();
            ps = con.prepareStatement(DELETE_USER_LEAVE);
            ps.setString(1, nric);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void updateUserAccount(String old_nric, String new_nric) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(UPDATE_USER_ACCOUNT);
            ps.setString(1, new_nric);
            ps.setString(2, old_nric);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static User getUserByUsername(String login_username) {
        User user = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_USER_ACCOUNT_BY_USERNAME);
            ps.setString(1, login_username);
            rs = ps.executeQuery();
            if (rs.next()) {
                String nric = rs.getString("nric");
                Account account = new Account(rs.getString("username"), rs.getString("password"));

                ps = con.prepareStatement(GET_USER_BY_NRIC);
                ps.setString(1, nric);
                rs = ps.executeQuery();
                if (rs.next()) {
                    String first_name = rs.getString("first_name");
                    String last_name = rs.getString("last_name");
                    DateTime date_joined = new DateTime(rs.getDate("date_joined"));
                    String mailing_address = rs.getString("mailing_address");
                    String registered_address = rs.getString("registered_address");
                    String department = rs.getString("department");
                    String designation = rs.getString("designation");
                    int salary = rs.getInt("salary");
                    String type = rs.getString("type");
                    ArrayList<Module> modules = UserPopulationDAO.getUserModules(department, designation);

                    double leave = 0;
                    double used_leave = 0;
                    int mc = 0;
                    int used_mc = 0;
                    ps = con.prepareStatement(GET_USER_LEAVEMC_BY_NRIC);
                    ps.setString(1, nric);
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        leave = rs.getDouble("leave");
                        mc = rs.getInt("mc");
                        used_leave = rs.getDouble("used_leave");
                        used_mc = rs.getInt("used_mc");
                    }

                    Contact contact = null;
                    ps = con.prepareStatement(GET_USER_CONTACT_BY_NRIC);
                    ps.setString(1, nric);
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        contact = new Contact(rs.getInt("phone_no"), rs.getInt("fax_no"), rs.getInt("home_no"));
                    }

                    Emergency emergency = null;
                    ps = con.prepareStatement(GET_USER_EMERGENCY_BY_NRIC);
                    ps.setString(1, nric);
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        emergency = new Emergency(rs.getString("name"), rs.getString("relationship"), rs.getInt("contact_no"), rs.getInt("office_no"));
                    }

                    Bank bank = null;
                    ps = con.prepareStatement(GET_USER_BANK_BY_NRIC);
                    ps.setString(1, nric);
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        bank = new Bank(rs.getString("payment_mode"), rs.getString("bank_name"), rs.getString("account_name"), rs.getString("account_no"));
                    }

                    user = new User(nric, first_name, last_name, leave, mc, used_leave, used_mc, account, type, date_joined, mailing_address, registered_address, contact, emergency, department, designation, salary, modules, bank);
                }
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return user;
    }

    public static User getUserByNRIC(String nric) {
        User user = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_USER_ACCOUNT_BY_NRIC);
            ps.setString(1, nric);
            rs = ps.executeQuery();
            if (rs.next()) {
                Account account = new Account(rs.getString("username"), rs.getString("password"));
                ps = con.prepareStatement(GET_USER_BY_NRIC);
                ps.setString(1, nric);
                rs = ps.executeQuery();
                if (rs.next()) {
                    String first_name = rs.getString("first_name");
                    String last_name = rs.getString("last_name");
                    DateTime date_joined = new DateTime(rs.getDate("date_joined"));
                    String mailing_address = rs.getString("mailing_address");
                    String registered_address = rs.getString("registered_address");
                    String department = rs.getString("department");
                    String designation = rs.getString("designation");
                    int salary = rs.getInt("salary");
                    String type = rs.getString("type");
                    ArrayList<Module> modules = UserPopulationDAO.getUserModules(department, designation);

                    double leave = 0;
                    double used_leave = 0;
                    int mc = 0;
                    int used_mc = 0;
                    ps = con.prepareStatement(GET_USER_LEAVEMC_BY_NRIC);
                    ps.setString(1, nric);
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        leave = rs.getDouble("leave");
                        mc = rs.getInt("mc");
                        used_leave = rs.getDouble("used_leave");
                        used_mc = rs.getInt("used_mc");
                    }

                    Contact contact = null;
                    ps = con.prepareStatement(GET_USER_CONTACT_BY_NRIC);
                    ps.setString(1, nric);
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        contact = new Contact(rs.getInt("phone_no"), rs.getInt("fax_no"), rs.getInt("home_no"));
                    }

                    Emergency emergency = null;
                    ps = con.prepareStatement(GET_USER_EMERGENCY_BY_NRIC);
                    ps.setString(1, nric);
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        emergency = new Emergency(rs.getString("name"), rs.getString("relationship"), rs.getInt("contact_no"), rs.getInt("office_no"));
                    }

                    Bank bank = null;
                    ps = con.prepareStatement(GET_USER_BANK_BY_NRIC);
                    ps.setString(1, nric);
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        bank = new Bank(rs.getString("payment_mode"), rs.getString("bank_name"), rs.getString("account_name"), rs.getString("account_no"));
                    }

                    user = new User(nric, first_name, last_name, leave, mc, used_leave, used_mc, account, type, date_joined, mailing_address, registered_address, contact, emergency, department, designation, salary, modules, bank);
                }
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return user;
    }

    public static void updateUserPassword(String password, String nric) {
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

    public static ArrayList<User> getFullTimeUsersByName(String keyword) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ResultSet rsInner = null;
        ArrayList<User> users = new ArrayList<User>();
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_FULL_TIME_USERS_BY_NAME);
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                String nric = rs.getString("nric");
                String first_name = rs.getString("first_name");
                String last_name = rs.getString("last_name");
                DateTime date_joined = new DateTime(rs.getDate("date_joined"));
                String mailing_address = rs.getString("mailing_address");
                String registered_address = rs.getString("registered_address");
                String department = rs.getString("department");
                String designation = rs.getString("designation");
                int salary = rs.getInt("salary");
                String type = rs.getString("type");
                ArrayList<Module> modules = UserPopulationDAO.getUserModules(department, designation);

                double leave = 0;
                double used_leave = 0;
                int mc = 0;
                int used_mc = 0;
                ps = con.prepareStatement(GET_USER_LEAVEMC_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    leave = rsInner.getDouble("leave");
                    mc = rsInner.getInt("mc");
                    used_leave = rsInner.getDouble("used_leave");
                    used_mc = rsInner.getInt("used_mc");
                }

                Account account = null;
                ps = con.prepareStatement(GET_USER_ACCOUNT_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    account = new Account(rsInner.getString("username"), rsInner.getString("password"));
                }

                Contact contact = null;
                ps = con.prepareStatement(GET_USER_CONTACT_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    contact = new Contact(rsInner.getInt("phone_no"), rsInner.getInt("fax_no"), rsInner.getInt("home_no"));
                }

                Emergency emergency = null;
                ps = con.prepareStatement(GET_USER_EMERGENCY_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    emergency = new Emergency(rsInner.getString("name"), rsInner.getString("relationship"), rsInner.getInt("contact_no"), rsInner.getInt("office_no"));
                }

                Bank bank = null;
                ps = con.prepareStatement(GET_USER_BANK_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    bank = new Bank(rsInner.getString("payment_mode"), rsInner.getString("bank_name"), rsInner.getString("account_name"), rsInner.getString("account_no"));
                }

                users.add(new User(nric, first_name, last_name, leave, mc, used_leave, used_mc, account, type, date_joined, mailing_address, registered_address, contact, emergency, department, designation, salary, modules, bank));
            }

            if (rsInner != null) {
                rsInner.close();
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return users;
    }

    public static ArrayList<User> getSiteSurveyorsByName(String keyword) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ResultSet rsInner = null;
        ArrayList<User> users = new ArrayList<User>();
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_SITE_SURVEYORS_BY_NAME);
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                String nric = rs.getString("nric");
                String first_name = rs.getString("first_name");
                String last_name = rs.getString("last_name");
                DateTime date_joined = new DateTime(rs.getDate("date_joined"));
                String mailing_address = rs.getString("mailing_address");
                String registered_address = rs.getString("registered_address");
                String department = rs.getString("department");
                String designation = rs.getString("designation");
                int salary = rs.getInt("salary");
                String type = rs.getString("type");
                ArrayList<Module> modules = UserPopulationDAO.getUserModules(department, designation);

                double leave = 0;
                double used_leave = 0;
                int mc = 0;
                int used_mc = 0;
                ps = con.prepareStatement(GET_USER_LEAVEMC_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    leave = rsInner.getDouble("leave");
                    mc = rsInner.getInt("mc");
                    used_leave = rsInner.getDouble("used_leave");
                    used_mc = rsInner.getInt("used_mc");
                }

                Account account = null;
                ps = con.prepareStatement(GET_USER_ACCOUNT_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    account = new Account(rsInner.getString("username"), rsInner.getString("password"));
                }

                Contact contact = null;
                ps = con.prepareStatement(GET_USER_CONTACT_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    contact = new Contact(rsInner.getInt("phone_no"), rsInner.getInt("fax_no"), rsInner.getInt("home_no"));
                }

                Emergency emergency = null;
                ps = con.prepareStatement(GET_USER_EMERGENCY_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    emergency = new Emergency(rsInner.getString("name"), rsInner.getString("relationship"), rsInner.getInt("contact_no"), rsInner.getInt("office_no"));
                }

                Bank bank = null;
                ps = con.prepareStatement(GET_USER_BANK_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    bank = new Bank(rsInner.getString("payment_mode"), rsInner.getString("bank_name"), rsInner.getString("account_name"), rsInner.getString("account_no"));
                }

                users.add(new User(nric, first_name, last_name, leave, mc, used_leave, used_mc, account, type, date_joined, mailing_address, registered_address, contact, emergency, department, designation, salary, modules, bank));
            }

            if (rsInner != null) {
                rsInner.close();
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return users;
    }
    
    public static ArrayList<User> getFullTimeUsers() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ResultSet rsInner = null;
        ArrayList<User> users = new ArrayList<User>();
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_FULL_TIME_USERS);
            rs = ps.executeQuery();
            while (rs.next()) {
                String nric = rs.getString("nric");
                String first_name = rs.getString("first_name");
                String last_name = rs.getString("last_name");
                DateTime date_joined = new DateTime(rs.getDate("date_joined"));
                String mailing_address = rs.getString("mailing_address");
                String registered_address = rs.getString("registered_address");
                String department = rs.getString("department");
                String designation = rs.getString("designation");
                int salary = rs.getInt("salary");
                String type = rs.getString("type");
                ArrayList<Module> modules = UserPopulationDAO.getUserModules(department, designation);

                double leave = 0;
                double used_leave = 0;
                int mc = 0;
                int used_mc = 0;
                ps = con.prepareStatement(GET_USER_LEAVEMC_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    leave = rsInner.getDouble("leave");
                    mc = rsInner.getInt("mc");
                    used_leave = rsInner.getDouble("used_leave");
                    used_mc = rsInner.getInt("used_mc");
                }

                Account account = null;
                ps = con.prepareStatement(GET_USER_ACCOUNT_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    account = new Account(rsInner.getString("username"), rsInner.getString("password"));
                }

                Contact contact = null;
                ps = con.prepareStatement(GET_USER_CONTACT_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    contact = new Contact(rsInner.getInt("phone_no"), rsInner.getInt("fax_no"), rsInner.getInt("home_no"));
                }

                Emergency emergency = null;
                ps = con.prepareStatement(GET_USER_EMERGENCY_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    emergency = new Emergency(rsInner.getString("name"), rsInner.getString("relationship"), rsInner.getInt("contact_no"), rsInner.getInt("office_no"));
                }

                Bank bank = null;
                ps = con.prepareStatement(GET_USER_BANK_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    bank = new Bank(rsInner.getString("payment_mode"), rsInner.getString("bank_name"), rsInner.getString("account_name"), rsInner.getString("account_no"));
                }

                users.add(new User(nric, first_name, last_name, leave, mc, used_leave, used_mc, account, type, date_joined, mailing_address, registered_address, contact, emergency, department, designation, salary, modules, bank));
            }

            if (rsInner != null) {
                rsInner.close();
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return users;
    }

    public static void createUser(String nric, String first_name, String last_name, Date dj, String mailing_address, String registered_address, String department, String designation, int salary, String employeeType) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_USER);
            ps.setString(1, nric);
            ps.setString(2, first_name);
            ps.setString(3, last_name);
            ps.setDate(4, new java.sql.Date(dj.getTime()));
            ps.setString(5, mailing_address);
            ps.setString(6, registered_address);
            ps.setString(7, department);
            ps.setString(8, designation);
            ps.setInt(9, salary);
            ps.setString(10, employeeType);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createUserContact(String nric, int user_phone, int user_fax, int user_home) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_USER_CONTACT);
            ps.setString(1, nric);
            ps.setInt(2, user_phone);
            ps.setInt(3, user_fax);
            ps.setInt(4, user_home);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createUserEmergency(String nric, String emergency_name, String emergency_relationship, int emergency_contact, int emergency_office) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_USER_EMERGENCY);
            ps.setString(1, nric);
            ps.setString(2, emergency_name);
            ps.setString(3, emergency_relationship);
            ps.setInt(4, emergency_contact);
            ps.setInt(5, emergency_office);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
    }

    public static void createUserAccount(String nric, String user_username, String user_password) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_USER_ACCOUNT);
            ps.setString(1, nric);
            ps.setString(2, user_username);
            ps.setString(3, user_password);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createUserBank(String nric, String payment_mode, String bank_name, String account_name, String account_no) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_USER_BANK);
            ps.setString(1, nric);
            ps.setString(2, payment_mode);
            ps.setString(3, bank_name);
            ps.setString(4, account_name);
            ps.setString(5, account_no);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createUserLeave(String nric, Date dj) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_USER_LEAVE);
            ps.setString(1, nric);
            ps.setDate(2, new java.sql.Date(dj.getTime()));
            int days = Converter.getTotalDaysBetweenTwoDates(dj, new Date());
            int leave = ((days / 365) + 7) * 8;
            if (leave > (14*8)) {
                leave = (14*8);
            }
            ps.setDouble(3, leave);
            ps.setInt(4, 14);
            ps.setDouble(5, 0);
            ps.setInt(6, 0);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createUserLeave(String nric, Date dj, double leave, int mc, double used_leave, int used_mc) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_USER_LEAVE);
            ps.setString(1, nric);
            ps.setDate(2, new java.sql.Date(dj.getTime()));
            ps.setDouble(3, leave);
            ps.setInt(4, mc);
            ps.setDouble(5, used_leave);
            ps.setInt(6, used_mc);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static ArrayList<User> getFullTimeUsersByKeyword(String keyword) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ResultSet rsInner = null;
        ArrayList<User> users = new ArrayList<User>();
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_FT_USERS_BY_KEYWORD);
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");
            ps.setString(4, "%" + keyword + "%");
            ps.setString(5, "%" + keyword + "%");
            ps.setString(6, "%" + keyword + "%");
            ps.setString(7, "%" + keyword + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                String nric = rs.getString("nric");
                String first_name = rs.getString("first_name");
                String last_name = rs.getString("last_name");
                DateTime date_joined = new DateTime(rs.getDate("date_joined"));
                String mailing_address = rs.getString("mailing_address");
                String registered_address = rs.getString("registered_address");
                String department = rs.getString("department");
                String designation = rs.getString("designation");
                int salary = rs.getInt("salary");
                String type = rs.getString("type");
                ArrayList<Module> modules = UserPopulationDAO.getUserModules(department, designation);

                double leave = 0;
                double used_leave = 0;
                int mc = 0;
                int used_mc = 0;
                ps = con.prepareStatement(GET_USER_LEAVEMC_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    leave = rsInner.getDouble("leave");
                    mc = rsInner.getInt("mc");
                    used_leave = rsInner.getDouble("used_leave");
                    used_mc = rsInner.getInt("used_mc");
                }

                Account account = null;
                ps = con.prepareStatement(GET_USER_ACCOUNT_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    account = new Account(rsInner.getString("username"), rsInner.getString("password"));
                }

                Contact contact = null;
                ps = con.prepareStatement(GET_USER_CONTACT_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    contact = new Contact(rsInner.getInt("phone_no"), rsInner.getInt("fax_no"), rsInner.getInt("home_no"));
                }

                Emergency emergency = null;
                ps = con.prepareStatement(GET_USER_EMERGENCY_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    emergency = new Emergency(rsInner.getString("name"), rsInner.getString("relationship"), rsInner.getInt("contact_no"), rsInner.getInt("office_no"));
                }

                Bank bank = null;
                ps = con.prepareStatement(GET_USER_BANK_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    bank = new Bank(rsInner.getString("payment_mode"), rsInner.getString("bank_name"), rsInner.getString("account_name"), rsInner.getString("account_no"));
                }

                users.add(new User(nric, first_name, last_name, leave, mc, used_leave, used_mc, account, type, date_joined, mailing_address, registered_address, contact, emergency, department, designation, salary, modules, bank));
            }

            if (rsInner != null) {
                rsInner.close();
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
        ResultSet rsInner = null;
        ArrayList<User> users = new ArrayList<User>();
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_PT_USERS_BY_KEYWORD);
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");
            ps.setString(4, "%" + keyword + "%");
            ps.setString(5, "%" + keyword + "%");
            ps.setString(6, "%" + keyword + "%");
            ps.setString(7, "%" + keyword + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                String nric = rs.getString("nric");
                String first_name = rs.getString("first_name");
                String last_name = rs.getString("last_name");
                DateTime date_joined = new DateTime(rs.getDate("date_joined"));
                String mailing_address = rs.getString("mailing_address");
                String registered_address = rs.getString("registered_address");
                String department = rs.getString("department");
                String designation = rs.getString("designation");
                int salary = rs.getInt("salary");
                String type = rs.getString("type");
                ArrayList<Module> modules = UserPopulationDAO.getUserModules(department, designation);

                Account account = null;

                Contact contact = null;
                ps = con.prepareStatement(GET_USER_CONTACT_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    contact = new Contact(rsInner.getInt("phone_no"), rsInner.getInt("fax_no"), rsInner.getInt("home_no"));
                }

                Emergency emergency = null;
                ps = con.prepareStatement(GET_USER_EMERGENCY_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    emergency = new Emergency(rsInner.getString("name"), rsInner.getString("relationship"), rsInner.getInt("contact_no"), rsInner.getInt("office_no"));
                }

                Bank bank = null;
                ps = con.prepareStatement(GET_USER_BANK_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    bank = new Bank(rsInner.getString("payment_mode"), rsInner.getString("bank_name"), rsInner.getString("account_name"), rsInner.getString("account_no"));
                }

                users.add(new User(nric, first_name, last_name, 0, 0, 0, 0, account, type, date_joined, mailing_address, registered_address, contact, emergency, department, designation, salary, modules, bank));
            }

            if (rsInner != null) {
                rsInner.close();
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return users;
    }

    public static double[] getUserRemainingLeaveMC(String nric) {
        double[] toReturn = new double[2];
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_USER_LEAVEMC_BY_NRIC);
            ps.setString(1, nric);
            rs = ps.executeQuery();
            if (rs.next()) {
                double leave = rs.getDouble("leave");
                double used_leave = rs.getDouble("used_leave");
                toReturn[0] = leave - used_leave;
                int mc = rs.getInt("mc");
                int used_mc = rs.getInt("used_mc");
                toReturn[1] = mc - used_mc;
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return toReturn;
    }

    public static void updateUserUsedLeaveMC(String nric, String leaveName, double number) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_USER_LEAVEMC_BY_NRIC);
            ps.setString(1, nric);
            rs = ps.executeQuery();

            if (rs.next()) {

                switch (leaveName) {
                    case "MC":
                        double used_mc = rs.getInt("used_mc");
                        ps = con.prepareStatement(UPDATE_USER_MC);
                        ps.setInt(1, (int) (used_mc + number));
                        ps.setString(2, nric);
                        ps.executeUpdate();
                        break;
                    default:
                        double used_leave = rs.getDouble("used_leave");
                        ps = con.prepareStatement(UPDATE_USER_LEAVE);
                        ps.setDouble(1, used_leave + number);
                        ps.setString(2, nric);
                        ps.executeUpdate();
                }

            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
    }
    
    public static void restoreUserUsedLeaveMC(String nric, String leaveName, double number) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_USER_LEAVEMC_BY_NRIC);
            ps.setString(1, nric);
            rs = ps.executeQuery();

            if (rs.next()) {

                switch (leaveName) {
                    case "MC":
                        double used_mc = rs.getInt("used_mc");
                        ps = con.prepareStatement(UPDATE_USER_MC);
                        ps.setInt(1, (int) (used_mc - number));
                        ps.setString(2, nric);
                        ps.executeUpdate();
                        break;
                    default:
                        double used_leave = rs.getDouble("used_leave");
                        ps = con.prepareStatement(UPDATE_USER_LEAVE);
                        ps.setDouble(1, used_leave - number);
                        ps.setString(2, nric);
                        ps.executeUpdate();
                }

            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
    }
    
    public static ArrayList<User> getAllSurveyors() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ResultSet rsInner = null;
        ArrayList<User> users = new ArrayList<User>();
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_ALL_SURVEYORS);
            rs = ps.executeQuery();
            while (rs.next()) {
                String nric = rs.getString("nric");
                String first_name = rs.getString("first_name");
                String last_name = rs.getString("last_name");
                DateTime date_joined = new DateTime(rs.getDate("date_joined"));
                String mailing_address = rs.getString("mailing_address");
                String registered_address = rs.getString("registered_address");
                String department = rs.getString("department");
                String designation = rs.getString("designation");
                int salary = rs.getInt("salary");
                String type = rs.getString("type");
                ArrayList<Module> modules = UserPopulationDAO.getUserModules(department, designation);

                double leave = 0;
                double used_leave = 0;
                int mc = 0;
                int used_mc = 0;
                ps = con.prepareStatement(GET_USER_LEAVEMC_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    leave = rsInner.getDouble("leave");
                    mc = rsInner.getInt("mc");
                    used_leave = rsInner.getDouble("used_leave");
                    used_mc = rsInner.getInt("used_mc");
                }

                Account account = null;
                ps = con.prepareStatement(GET_USER_ACCOUNT_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    account = new Account(rsInner.getString("username"), rsInner.getString("password"));
                }

                Contact contact = null;
                ps = con.prepareStatement(GET_USER_CONTACT_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    contact = new Contact(rsInner.getInt("phone_no"), rsInner.getInt("fax_no"), rsInner.getInt("home_no"));
                }

                Emergency emergency = null;
                ps = con.prepareStatement(GET_USER_EMERGENCY_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    emergency = new Emergency(rsInner.getString("name"), rsInner.getString("relationship"), rsInner.getInt("contact_no"), rsInner.getInt("office_no"));
                }

                Bank bank = null;
                ps = con.prepareStatement(GET_USER_BANK_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    bank = new Bank(rsInner.getString("payment_mode"), rsInner.getString("bank_name"), rsInner.getString("account_name"), rsInner.getString("account_no"));
                }

                users.add(new User(nric, first_name, last_name, leave, mc, used_leave, used_mc, account, type, date_joined, mailing_address, registered_address, contact, emergency, department, designation, salary, modules, bank));
            }

            if (rsInner != null) {
                rsInner.close();
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return users;
    }
    
    public static ArrayList<User> getAllFullTimeMovers() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ResultSet rsInner = null;
        ArrayList<User> users = new ArrayList<User>();
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_ALL_FULL_TIME_MOVERS);
            rs = ps.executeQuery();
            while (rs.next()) {
                String nric = rs.getString("nric");
                String first_name = rs.getString("first_name");
                String last_name = rs.getString("last_name");
                DateTime date_joined = new DateTime(rs.getDate("date_joined"));
                String mailing_address = rs.getString("mailing_address");
                String registered_address = rs.getString("registered_address");
                String department = rs.getString("department");
                String designation = rs.getString("designation");
                int salary = rs.getInt("salary");
                String type = rs.getString("type");
                ArrayList<Module> modules = UserPopulationDAO.getUserModules(department, designation);

                double leave = 0;
                double used_leave = 0;
                int mc = 0;
                int used_mc = 0;
                ps = con.prepareStatement(GET_USER_LEAVEMC_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    leave = rsInner.getDouble("leave");
                    mc = rsInner.getInt("mc");
                    used_leave = rsInner.getDouble("used_leave");
                    used_mc = rsInner.getInt("used_mc");
                }

                Account account = null;
                ps = con.prepareStatement(GET_USER_ACCOUNT_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    account = new Account(rsInner.getString("username"), rsInner.getString("password"));
                }

                Contact contact = null;
                ps = con.prepareStatement(GET_USER_CONTACT_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    contact = new Contact(rsInner.getInt("phone_no"), rsInner.getInt("fax_no"), rsInner.getInt("home_no"));
                }

                Emergency emergency = null;
                ps = con.prepareStatement(GET_USER_EMERGENCY_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    emergency = new Emergency(rsInner.getString("name"), rsInner.getString("relationship"), rsInner.getInt("contact_no"), rsInner.getInt("office_no"));
                }

                Bank bank = null;
                ps = con.prepareStatement(GET_USER_BANK_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    bank = new Bank(rsInner.getString("payment_mode"), rsInner.getString("bank_name"), rsInner.getString("account_name"), rsInner.getString("account_no"));
                }

                users.add(new User(nric, first_name, last_name, leave, mc, used_leave, used_mc, account, type, date_joined, mailing_address, registered_address, contact, emergency, department, designation, salary, modules, bank));
            }

            if (rsInner != null) {
                rsInner.close();
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return users;
    }
    
    public static ArrayList<User> getMoversByType(String mType) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ResultSet rsInner = null;
        ArrayList<User> users = new ArrayList<User>();
        String des = "Part-Time Mover";
        if(mType.equals("Full")) {
            des = "Mover";
        }
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_MOVERS_BY_TYPE);
            ps.setString(1, des);
            ps.setString(2, mType);
            rs = ps.executeQuery();
            while (rs.next()) {
                String nric = rs.getString("nric");
                String first_name = rs.getString("first_name");
                String last_name = rs.getString("last_name");
                DateTime date_joined = new DateTime(rs.getDate("date_joined"));
                String mailing_address = rs.getString("mailing_address");
                String registered_address = rs.getString("registered_address");
                String department = rs.getString("department");
                String designation = rs.getString("designation");
                int salary = rs.getInt("salary");
                String type = rs.getString("type");
                ArrayList<Module> modules = UserPopulationDAO.getUserModules(department, designation);

                double leave = 0;
                double used_leave = 0;
                int mc = 0;
                int used_mc = 0;
                ps = con.prepareStatement(GET_USER_LEAVEMC_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    leave = rsInner.getDouble("leave");
                    mc = rsInner.getInt("mc");
                    used_leave = rsInner.getDouble("used_leave");
                    used_mc = rsInner.getInt("used_mc");
                }

                Account account = null;
                ps = con.prepareStatement(GET_USER_ACCOUNT_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    account = new Account(rsInner.getString("username"), rsInner.getString("password"));
                }

                Contact contact = null;
                ps = con.prepareStatement(GET_USER_CONTACT_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    contact = new Contact(rsInner.getInt("phone_no"), rsInner.getInt("fax_no"), rsInner.getInt("home_no"));
                }

                Emergency emergency = null;
                ps = con.prepareStatement(GET_USER_EMERGENCY_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    emergency = new Emergency(rsInner.getString("name"), rsInner.getString("relationship"), rsInner.getInt("contact_no"), rsInner.getInt("office_no"));
                }

                Bank bank = null;
                ps = con.prepareStatement(GET_USER_BANK_BY_NRIC);
                ps.setString(1, nric);
                rsInner = ps.executeQuery();
                if (rsInner.next()) {
                    bank = new Bank(rsInner.getString("payment_mode"), rsInner.getString("bank_name"), rsInner.getString("account_name"), rsInner.getString("account_no"));
                }

                users.add(new User(nric, first_name, last_name, leave, mc, used_leave, used_mc, account, type, date_joined, mailing_address, registered_address, contact, emergency, department, designation, salary, modules, bank));
            }

            if (rsInner != null) {
                rsInner.close();
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return users;
    }
}
