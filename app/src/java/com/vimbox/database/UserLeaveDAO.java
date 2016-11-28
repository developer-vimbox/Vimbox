package com.vimbox.database;

import com.vimbox.hr.LeaveMC;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import org.joda.time.DateTime;
import org.joda.time.Days;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public class UserLeaveDAO {

    private static final String GET_ALL_USER_LEAVE = "SELECT * FROM users_leave";
    private static final String UPDATE_USER_LEAVE = "UPDATE users_leave SET leave=? WHERE nric=?";
    private static final String CREATE_USER_LEAVE = "INSERT INTO users_leave_record VALUES (?,?,?,?,?,?,?)";
    private static final String GET_USER_LEAVE_MC_BY_NRIC = "SELECT * FROM users_leave_record WHERE nric=? ORDER BY date DESC";
    private static final String GET_UNPAID_USER_LEAVE_MC_BY_NRIC_DATE = "SELECT * FROM users_leave_record WHERE nric=? AND date LIKE ? AND leave_type = 'Unpaid' ORDER BY date";
    private static final String GET_UNPAID_USER_LEAVE_MC_BY_NRIC_BETWEEN_TWO_DATES = "SELECT * FROM users_leave_record WHERE nric=? AND (date BETWEEN ? AND ?) AND leave_type = 'Unpaid' ORDER BY date";
    private static final String GET_USER_LEAVE_MC_BY_NRIC_DATE = "SELECT * FROM users_leave_record WHERE nric=? AND date LIKE ?";
    private static final String GET_LEAVE_MC_BY_DATE = "SELECT * FROM users_leave_record WHERE date=?";
    private static final String GET_LEAVE_MC_BY_KEYWORD = "SELECT * FROM users_leave_record WHERE nric LIKE ? OR date LIKE ? OR leave_type LIKE ? OR leave_name LIKE ? OR time_string LIKE ? OR leave_duration LIKE ? ORDER BY nric, date DESC";
    private static final String DELETE_USER_LEAVE_MC = "DELETE FROM users_leave_record WHERE nric=? AND date=?";

    public static void updateLeaveMC() {
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd");
        DateTime now = new DateTime();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        HashMap<String, Double> listToBeUpdated = new HashMap<String, Double>();
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_ALL_USER_LEAVE);
            rs = ps.executeQuery();
            while (rs.next()) {
                String nric = rs.getString("nric");
                DateTime dateJoined = dtf.parseDateTime(rs.getString("date_joined"));
                double days = Days.daysBetween(now, dateJoined).getDays();

                double currentLeave = rs.getDouble("leave");
                double newLeave = ((days / 365) + 14) * 8;
                if (newLeave > 144) {
                    newLeave = 144;
                }

                if (currentLeave != newLeave) {
                    listToBeUpdated.put(nric, newLeave);
                }
            }

            if (!listToBeUpdated.isEmpty()) {
                for (Map.Entry<String, Double> entry : listToBeUpdated.entrySet()) {
                    String nric = entry.getKey();
                    double leave = entry.getValue();
                    ps = con.prepareStatement(UPDATE_USER_LEAVE);
                    ps.setDouble(1, leave);
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

    public static void deleteLeaveMC(String nric, String date) {
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd");
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_USER_LEAVE_MC_BY_NRIC_DATE);
            ps.setString(1, nric);
            ps.setString(2, date);
            rs = ps.executeQuery();

            String type = "";
            String name = "";
            double duration = 0;
            if (rs.next()) {
                type = rs.getString("leave_type");
                name = rs.getString("leave_name");
                duration = rs.getDouble("leave_duration");
            }

            ps = con.prepareStatement(DELETE_USER_LEAVE_MC);
            ps.setString(1, nric);
            ps.setDate(2, new java.sql.Date(dtf.parseDateTime(date).toDate().getTime()));
            ps.executeUpdate();

            if (type.equals("Paid")) {
                if (name.equals("MC")) {
                    UserDAO.restoreUserUsedLeaveMC(nric, name, 1);
                } else {
                    UserDAO.restoreUserUsedLeaveMC(nric, name, duration);
                }
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createLeaveRecord(String leaveType, String leaveName, String nric, HashMap<Date, Double> used, HashMap<Date, String> usedString, String path) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;
        int count = 0;
        try {
            con = ConnectionManager.getConnection();
            double hours = 0;
            for (Map.Entry<Date, Double> entry : used.entrySet()) {
                ps = con.prepareStatement(CREATE_USER_LEAVE);
                ps.setString(1, leaveType);
                ps.setString(2, leaveName);
                ps.setString(3, nric);
                double hour = entry.getValue();
                hours += hour;
                ps.setDate(4, new java.sql.Date(entry.getKey().getTime()));
                ps.setString(5, usedString.get(entry.getKey()));
                ps.setDouble(6, hour);
                ps.setString(7, path);
                ps.executeUpdate();
                count++;
            }

            if (leaveType.equals("Paid")) {
                if (leaveName.equals("MC")) {
                    UserDAO.updateUserUsedLeaveMC(nric, leaveName, used.size());
                } else {
                    UserDAO.updateUserUsedLeaveMC(nric, leaveName, hours);
                }
            }
        } catch (SQLException se) {
            con = ConnectionManager.getConnection();
            int match = 0;
            for (Map.Entry<Date, Double> entry : used.entrySet()) {
                if (match == count) {
                    break;
                }
                ps = con.prepareStatement(DELETE_USER_LEAVE_MC);
                ps.setString(1, nric);
                ps.setDate(2, new java.sql.Date(entry.getKey().getTime()));
                ps.executeUpdate();
                match++;
            }
            throw se;
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static HashMap<String, ArrayList<LeaveMC>> getLeaveMCRecordsByKeyword(String keyword) {
        HashMap<String, ArrayList<LeaveMC>> results = new HashMap<String, ArrayList<LeaveMC>>();
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_LEAVE_MC_BY_KEYWORD);
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");
            ps.setString(4, "%" + keyword + "%");
            ps.setString(5, "%" + keyword + "%");
            ps.setString(6, "%" + keyword + "%");
            rs = ps.executeQuery();

            if (rs.next()) {
                ArrayList<LeaveMC> leaveMcs = new ArrayList<LeaveMC>();
                String nric = rs.getString("nric");
                String leaveType = rs.getString("leave_type");
                String leaveName = rs.getString("leave_name");
                double leaveDuration = rs.getDouble("leave_duration");
                String imgPath = rs.getString("img");
                String timeString = rs.getString("time_string");
                DateTime date = null;
                try {
                    date = dtf.parseDateTime(rs.getString("date"));
                } catch (Exception e) {
                    e.printStackTrace();
                }
                leaveMcs.add(new LeaveMC(leaveType, leaveName, leaveDuration, date, timeString, imgPath));

                while (rs.next()) {
                    String nextNric = rs.getString("nric");
                    if (!nextNric.equals(nric)) {
                        results.put(nric, leaveMcs);
                        leaveMcs = new ArrayList<LeaveMC>();
                        nric = nextNric;
                    }
                    leaveType = rs.getString("leave_type");
                    leaveName = rs.getString("leave_name");
                    leaveDuration = rs.getDouble("leave_duration");
                    imgPath = rs.getString("img");
                    timeString = rs.getString("time_string");
                    date = null;
                    try {
                        date = dtf.parseDateTime(rs.getString("date"));
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    leaveMcs.add(new LeaveMC(leaveType, leaveName, leaveDuration, date, timeString, imgPath));
                }
                results.put(nric, leaveMcs);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }

        return results;
    }

    public static ArrayList<LeaveMC> getLeaveMCRecordByNric(String nric) {
        ArrayList<LeaveMC> results = new ArrayList<LeaveMC>();
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_USER_LEAVE_MC_BY_NRIC);
            ps.setString(1, nric);
            rs = ps.executeQuery();

            while (rs.next()) {
                String leaveType = rs.getString("leave_type");
                String leaveName = rs.getString("leave_name");
                double leaveDuration = rs.getDouble("leave_duration");
                String imgPath = rs.getString("img");
                String timeString = rs.getString("time_string");
                DateTime date = null;
                try {
                    date = dtf.parseDateTime(rs.getString("date"));
                } catch (Exception e) {
                    e.printStackTrace();
                }
                results.add(new LeaveMC(leaveType, leaveName, leaveDuration, date, timeString, imgPath));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }

        return results;
    }

    public static ArrayList<LeaveMC> getUnpaidLeaveMCRecordByNricDate(String nric, String yearMonth) {
        ArrayList<LeaveMC> results = new ArrayList<LeaveMC>();
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_UNPAID_USER_LEAVE_MC_BY_NRIC_DATE);
            ps.setString(1, nric);
            ps.setString(2, "%" + yearMonth + "%");
            rs = ps.executeQuery();

            while (rs.next()) {
                String leaveType = rs.getString("leave_type");
                String leaveName = rs.getString("leave_name");
                double leaveDuration = rs.getDouble("leave_duration");
                String imgPath = rs.getString("img");
                String timeString = rs.getString("time_string");
                DateTime date = null;
                try {
                    date = dtf.parseDateTime(rs.getString("date"));
                } catch (Exception e) {
                    e.printStackTrace();
                }
                results.add(new LeaveMC(leaveType, leaveName, leaveDuration, date, timeString, imgPath));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }

        return results;
    }

    public static ArrayList<LeaveMC> getUnpaidLeaveMCRecordByNricBetweenTwoDates(String nric, DateTime sd, DateTime ed) {
        ArrayList<LeaveMC> results = new ArrayList<LeaveMC>();
        DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_UNPAID_USER_LEAVE_MC_BY_NRIC_BETWEEN_TWO_DATES);
            ps.setString(1, nric);
            ps.setDate(2, new java.sql.Date(sd.toDate().getTime()));
            ps.setDate(3, new java.sql.Date(ed.toDate().getTime()));
            rs = ps.executeQuery();

            while (rs.next()) {
                String leaveType = rs.getString("leave_type");
                String leaveName = rs.getString("leave_name");
                double leaveDuration = rs.getDouble("leave_duration");
                String imgPath = rs.getString("img");
                String timeString = rs.getString("time_string");
                DateTime date = null;
                try {
                    date = dtf.parseDateTime(rs.getString("date"));
                } catch (Exception e) {
                    e.printStackTrace();
                }
                results.add(new LeaveMC(leaveType, leaveName, leaveDuration, date, timeString, imgPath));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }

        return results;
    }

    public static HashMap<String, LeaveMC> getLeaveMCRecordByDate(DateTime date) {
        HashMap<String, LeaveMC> results = new HashMap<String, LeaveMC>();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_LEAVE_MC_BY_DATE);
            ps.setDate(1, new java.sql.Date(date.toDate().getTime()));
            rs = ps.executeQuery();

            while (rs.next()) {
                String nric = rs.getString("nric");

                String leaveType = rs.getString("leave_type");
                String leaveName = rs.getString("leave_name");
                double leaveDuration = rs.getDouble("leave_duration");
                String imgPath = rs.getString("img");
                String timeString = rs.getString("time_string");

                results.put(nric, new LeaveMC(leaveType, leaveName, leaveDuration, date, timeString, imgPath));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }

        return results;
    }
}
