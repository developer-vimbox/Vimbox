package com.vimbox.database;

import com.vimbox.hr.Attendance;
import com.vimbox.hr.LeaveMC;
import com.vimbox.hr.Payslip;
import com.vimbox.user.User;
import com.vimbox.util.Converter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Random;
import org.joda.time.DateTime;

public class PayslipDAO {

    private static final DecimalFormat df = new DecimalFormat("#.00");
    private static final String CHECK_PAYSLIP_EXIST = "SELECT * FROM payslips WHERE nric=? AND MONTH(start_date) = ? AND YEAR(start_date) = ?";
    private static final String CREATE_PAYSLIP = "INSERT INTO payslips VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
    private static final String CREATE_PAYSLIP_ABD = "INSERT INTO payslips_abd VALUES (?,?,?)";
    private static final String CREATE_PAYSLIP_DBD = "INSERT INTO payslips_dbd VALUES (?,?,?)";
    private static final String CREATE_PAYSLIP_APBD = "INSERT INTO payslips_apbd VALUES (?,?,?)";
    private static final String SEARCH_PAYSLIP_BY_NUMBER = "SELECT * FROM payslips WHERE nric like ? OR start_date like ? OR payslip_id like ?";
    private static final String SEARCH_PAYSLIP_BY_NRIC = "SELECT * FROM payslips WHERE nric=?";
    private static final String GET_PAYSLIP_ABD = "SELECT * FROM payslips_abd WHERE payslip_id=?";
    private static final String GET_PAYSLIP_DBD = "SELECT * FROM payslips_dbd WHERE payslip_id=?";
    private static final String GET_PAYSLIP_APBD = "SELECT * FROM payslips_apbd WHERE payslip_id=?";
    private static final String GET_PAYSLIP_BY_ID = "SELECT * FROM payslips WHERE payslip_id=?";
    private static final String GET_PAYSLIP = "SELECT * FROM payslips WHERE nric=? AND start_date=?";
    private static final String DELETE_PAYSLIP = "DELETE FROM payslips WHERE payslip_id=?";
    private static final String DELETE_PAYSLIP_ABD = "DELETE FROM payslips_abd WHERE payslip_id=?";
    private static final String DELETE_PAYSLIP_DBD = "DELETE FROM payslips_dbd WHERE payslip_id=?";
    private static final String DELETE_PAYSLIP_APBD = "DELETE FROM payslips_apbd WHERE payslip_id=?";

    public static void deletePayslip(int payslip_id) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(DELETE_PAYSLIP);
            ps.setInt(1, payslip_id);
            ps.executeUpdate();

            ps = con.prepareStatement(DELETE_PAYSLIP_ABD);
            ps.setInt(1, payslip_id);
            ps.executeUpdate();

            ps = con.prepareStatement(DELETE_PAYSLIP_DBD);
            ps.setInt(1, payslip_id);
            ps.executeUpdate();

            ps = con.prepareStatement(DELETE_PAYSLIP_APBD);
            ps.setInt(1, payslip_id);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static boolean checkPayslipMonthExists(String nric, String start_date) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CHECK_PAYSLIP_EXIST);
            ps.setString(1, nric);
            ps.setInt(2, Integer.parseInt(start_date.substring(start_date.indexOf("-") + 1, start_date.lastIndexOf("-"))));
            ps.setInt(3, Integer.parseInt(start_date.substring(0, start_date.indexOf("-"))));
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

    public static void fastCreatePayslips(DateTime p_d) {
        Date pd = p_d.toDate();
        // Getting the total working days //
        Calendar c = Calendar.getInstance();
        c.setTime(pd);
        c.set(Calendar.DAY_OF_MONTH, 1);
        Date firstDayOfMonth = c.getTime();
        c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
        Date lastDayOfMonth = c.getTime();

        java.sql.Date paymentDate = new java.sql.Date(pd.getTime());
        java.sql.Date startDate = new java.sql.Date(firstDayOfMonth.getTime());
        java.sql.Date endDate = new java.sql.Date(lastDayOfMonth.getTime());

        String yearMonth = Converter.convertYearMonthPayslip(p_d);
        ArrayList<Attendance> attendances = UserAttendanceDAO.getAttendancesByYearMonth(yearMonth);

        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ArrayList<User> users = UserDAO.getFullTimeUsers();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            for (User user : users) {
                if (!checkPayslipMonthExists(user.getNric(), sdf.format(firstDayOfMonth))) {
                    int totalWorkingDays = Converter.getWorkingDaysBetweenTwoDates(firstDayOfMonth, lastDayOfMonth, UserPopulationDAO.getUserWorkingDays(user.getDepartment(), user.getDesignation()));
                    int payslip_id = new Random().nextInt(90000000) + 10000000;
                    double deduction = 0;

                    // Employee's CPF //
                    ps = con.prepareStatement(CREATE_PAYSLIP_DBD);
                    ps.setInt(1, payslip_id);
                    ps.setString(2, "Employee's CPF Deduction");
                    ps.setDouble(3, Double.parseDouble(df.format(user.getSalary() * 0.2)));
                    deduction += user.getSalary() * 0.2;
                    ps.executeUpdate();

                    // Absent and Late //
                    int absent = 0;
                    int late = 0;
                    for (Attendance attendance : attendances) {
                        String status = attendance.getUserAttendance(user.getNric());
                        if (status != null) {
                            switch (status) {
                                case "Absent":
                                    absent++;
                                    break;
                                case "Late":
                                    late += attendance.getUserLateDuration(user.getNric());
                            }
                        }
                    }
                    if (absent > 0) {
                        ps = con.prepareStatement(CREATE_PAYSLIP_DBD);
                        ps.setInt(1, payslip_id);
                        ps.setString(2, "Absent - " + absent + " day(s)");
                        ps.setDouble(3, Double.parseDouble(df.format(((double) user.getSalary() / totalWorkingDays) * absent * 1.5)));
                        deduction += ((double) user.getSalary() / totalWorkingDays) * absent;
                        ps.executeUpdate();
                    }

                    if (late > 0) {
                        ps = con.prepareStatement(CREATE_PAYSLIP_DBD);
                        ps.setInt(1, payslip_id);
                        ps.setString(2, "Late - " + (late / 60) + " hours(s) " + (late % 60) + " min(s)");
                        ps.setDouble(3, Double.parseDouble(df.format(((double) user.getSalary() / (totalWorkingDays * 9 * 60)) * late)));
                        deduction += (double) user.getSalary() / (totalWorkingDays * 9 * 60);
                        ps.executeUpdate();
                    }

                    // Leave, MC and Time-Offs //
                    ArrayList<LeaveMC> leaveMcs = UserLeaveDAO.getUnpaidLeaveMCRecordByNricDate(user.getNric(), yearMonth);
                    if (!leaveMcs.isEmpty()) {
                        int mc = 0;
                        int leave = 0;
                        int timeoff = 0;

                        for (LeaveMC leaveMc : leaveMcs) {
                            String leaveName = leaveMc.getLeaveName();
                            switch (leaveName) {
                                case "MC":
                                    mc++;
                                    break;
                                case "Leave":
                                case "Timeoff":
                                    leave += leaveMc.getLeaveDuration();
                            }
                        }

                        if (mc > 0) {
                            ps = con.prepareStatement(CREATE_PAYSLIP_DBD);
                            ps.setInt(1, payslip_id);
                            ps.setString(2, "Unpaid MC - " + mc + " day(s)");
                            ps.setDouble(3, Double.parseDouble(df.format(((double) user.getSalary() / totalWorkingDays) * mc)));
                            deduction += ((double) user.getSalary() / totalWorkingDays) * mc;
                            ps.executeUpdate();
                        }

                        if (timeoff > 0) {
                            ps = con.prepareStatement(CREATE_PAYSLIP_DBD);
                            ps.setInt(1, payslip_id);
                            ps.setString(2, "Unpaid Time Off - " + (timeoff / 9) + " hour(s)");
                            ps.setDouble(3, Double.parseDouble(df.format(((double) user.getSalary() / (totalWorkingDays * 9)) * timeoff)));
                            deduction += ((double) user.getSalary() / (totalWorkingDays * 9)) * timeoff;
                            ps.executeUpdate();
                        }

                        if (leave > 0) {
                            ps = con.prepareStatement(CREATE_PAYSLIP_DBD);
                            ps.setInt(1, payslip_id);
                            String leaveString = "Unpaid Leave - ";
                            int leaveDays = leave / 9;
                            if (leaveDays > 0) {
                                leaveString += leaveDays + " day(s) ";
                            }
                            int leaveHours = leave % 9;
                            if (leaveHours > 0) {
                                leaveString += leaveHours + " hour(s) ";
                            }
                            ps.setString(2, leaveString);
                            ps.setDouble(3, Double.parseDouble(df.format(((double) user.getSalary() / (totalWorkingDays * 9)) * leave)));
                            deduction += ((double) user.getSalary() / (totalWorkingDays * 9)) * leave;
                            ps.executeUpdate();
                        }
                    }

                    ps = con.prepareStatement(CREATE_PAYSLIP);
                    ps.setInt(1, payslip_id);
                    ps.setString(2, user.getNric());
                    ps.setString(3, user.getBank().getPayment_mode());
                    ps.setDate(4, startDate);
                    ps.setDate(5, endDate);
                    ps.setDate(6, paymentDate);
                    ps.setDouble(7, Double.parseDouble(df.format(user.getSalary())));
                    ps.setDouble(8, 0.0);
                    ps.setDouble(9, Double.parseDouble(df.format(deduction)));
                    ps.setDouble(10, 0.0);
                    ps.setDouble(11, 0.0);
                    ps.setDouble(12, 0.0);
                    ps.setDouble(13, Double.parseDouble(df.format(user.getSalary() * 0.17)));
                    ps.executeUpdate();
                }
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createPayslip(int payslip_id, Date start_date, Date end_date, Date payment_date, String nric, String payment_mode, String basic, String allowance, String deduction, String overtimeHr, String overtime, String additional, String employer_cpf) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_PAYSLIP);
            ps.setInt(1, payslip_id);
            ps.setString(2, nric);
            ps.setString(3, payment_mode);
            ps.setDate(4, new java.sql.Date(start_date.getTime()));
            ps.setDate(5, new java.sql.Date(end_date.getTime()));
            ps.setDate(6, new java.sql.Date(payment_date.getTime()));

            try {
                ps.setDouble(7, Double.parseDouble(basic));
            } catch (NumberFormatException nfe) {
                ps.setDouble(7, 0.0);
            }

            try {
                ps.setDouble(8, Double.parseDouble(allowance));
            } catch (NumberFormatException nfe) {
                ps.setDouble(8, 0.0);
            }

            try {
                ps.setDouble(9, Double.parseDouble(deduction));
            } catch (NumberFormatException nfe) {
                ps.setDouble(9, 0.0);
            }

            try {
                ps.setDouble(10, Double.parseDouble(overtimeHr));
            } catch (NumberFormatException nfe) {
                ps.setDouble(10, 0.0);
            }

            try {
                ps.setDouble(11, Double.parseDouble(overtime));
            } catch (NumberFormatException nfe) {
                ps.setDouble(11, 0.0);
            }

            try {
                ps.setDouble(12, Double.parseDouble(additional));
            } catch (NumberFormatException nfe) {
                ps.setDouble(12, 0.0);
            }

            try {
                ps.setDouble(13, Double.parseDouble(employer_cpf));
            } catch (NumberFormatException nfe) {
                ps.setDouble(13, 0.0);
            }

            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createPayslipABD(int payslip_id, ArrayList<String> descriptions, ArrayList<String> amounts) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            for (int i = 0; i < descriptions.size(); i++) {
                String description = descriptions.get(i);
                String amount = amounts.get(i);
                con = ConnectionManager.getConnection();
                ps = con.prepareStatement(CREATE_PAYSLIP_ABD);
                ps.setInt(1, payslip_id);
                ps.setString(2, description);
                try {
                    ps.setDouble(3, Double.parseDouble(amount));
                } catch (NumberFormatException nfe) {
                    ps.setDouble(3, 0.0);
                }
                ps.executeUpdate();
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createPayslipDBD(int payslip_id, ArrayList<String> descriptions, ArrayList<String> amounts) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            for (int i = 0; i < descriptions.size(); i++) {
                String description = descriptions.get(i);
                String amount = amounts.get(i);
                con = ConnectionManager.getConnection();
                ps = con.prepareStatement(CREATE_PAYSLIP_DBD);
                ps.setInt(1, payslip_id);
                ps.setString(2, description);
                try {
                    ps.setDouble(3, Double.parseDouble(amount));
                } catch (NumberFormatException nfe) {
                    ps.setDouble(3, 0.0);
                }
                ps.executeUpdate();
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static void createPayslipAPBD(int payslip_id, ArrayList<String> descriptions, ArrayList<String> amounts) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            for (int i = 0; i < descriptions.size(); i++) {
                String description = descriptions.get(i);
                String amount = amounts.get(i);
                con = ConnectionManager.getConnection();
                ps = con.prepareStatement(CREATE_PAYSLIP_APBD);
                ps.setInt(1, payslip_id);
                ps.setString(2, description);
                try {
                    ps.setDouble(3, Double.parseDouble(amount));
                } catch (NumberFormatException nfe) {
                    ps.setDouble(3, 0.0);
                }
                ps.executeUpdate();
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }

    public static ArrayList<Payslip> getSearchPayslips(String keyword) {
        ArrayList<Payslip> results = new ArrayList<Payslip>();
        ArrayList<User> users = UserDAO.getFullTimeUsersByName(keyword);

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ResultSet rsInner = null;
        try {
            con = ConnectionManager.getConnection();
            if (users.isEmpty()) {
                ps = con.prepareStatement(SEARCH_PAYSLIP_BY_NUMBER);
                ps.setString(1, "%" + keyword + "%");
                ps.setString(2, "%" + keyword + "%");
                ps.setString(3, "%" + keyword + "%");
                rs = ps.executeQuery();
                while (rs.next()) {
                    java.sql.Date sd = rs.getDate("start_date");

                    int payslip_id = rs.getInt("payslip_id");
                    String nric = rs.getString("nric");
                    String paymentMode = rs.getString("payment_mode");
                    DateTime startDate = new DateTime(sd);
                    DateTime endDate = new DateTime(rs.getDate("end_date"));
                    DateTime paymentDate = new DateTime(rs.getDate("payment_date"));
                    double basic = rs.getDouble("basic");
                    double allowance = rs.getDouble("allowance");
                    double deduction = rs.getDouble("deduction");
                    double overtimeHr = rs.getDouble("overtime_hr");
                    double overtime = rs.getDouble("overtime");
                    double additional = rs.getDouble("additional");
                    double employerCpf = rs.getDouble("employer_cpf");

                    HashMap<String, Double> allowanceBreakdown = new HashMap<String, Double>();
                    ps = con.prepareStatement(GET_PAYSLIP_ABD);
                    ps.setInt(1, payslip_id);
                    rsInner = ps.executeQuery();
                    while (rsInner.next()) {
                        allowanceBreakdown.put(rsInner.getString("description"), rsInner.getDouble("breakdown"));
                    }

                    HashMap<String, Double> deductionBreakdown = new HashMap<String, Double>();
                    ps = con.prepareStatement(GET_PAYSLIP_DBD);
                    ps.setInt(1, payslip_id);
                    rsInner = ps.executeQuery();
                    while (rsInner.next()) {
                        deductionBreakdown.put(rsInner.getString("description"), rsInner.getDouble("breakdown"));
                    }

                    HashMap<String, Double> addPaymentBreakdown = new HashMap<String, Double>();
                    ps = con.prepareStatement(GET_PAYSLIP_APBD);
                    ps.setInt(1, payslip_id);
                    rsInner = ps.executeQuery();
                    while (rsInner.next()) {
                        addPaymentBreakdown.put(rsInner.getString("description"), rsInner.getDouble("breakdown"));
                    }
                    results.add(new Payslip(payslip_id, UserDAO.getUserByNRIC(nric), paymentMode, startDate, endDate, paymentDate, basic, allowance, deduction, overtimeHr, overtime, additional, employerCpf, allowanceBreakdown, deductionBreakdown, addPaymentBreakdown));
                }
            } else {
                for (User user : users) {
                    String nric = user.getNric();
                    ps = con.prepareStatement(SEARCH_PAYSLIP_BY_NRIC);
                    ps.setString(1, nric);
                    rs = ps.executeQuery();
                    while (rs.next()) {
                        java.sql.Date sd = rs.getDate("start_date");

                        int payslip_id = rs.getInt("payslip_id");
                        String paymentMode = rs.getString("payment_mode");
                        DateTime startDate = new DateTime(sd);
                        DateTime endDate = new DateTime(rs.getDate("end_date"));
                        DateTime paymentDate = new DateTime(rs.getDate("payment_date"));
                        double basic = rs.getDouble("basic");
                        double allowance = rs.getDouble("allowance");
                        double deduction = rs.getDouble("deduction");
                        double overtimeHr = rs.getDouble("overtime_hr");
                        double overtime = rs.getDouble("overtime");
                        double additional = rs.getDouble("additional");
                        double employerCpf = rs.getDouble("employer_cpf");

                        HashMap<String, Double> allowanceBreakdown = new HashMap<String, Double>();
                        ps = con.prepareStatement(GET_PAYSLIP_ABD);
                        ps.setInt(1, payslip_id);
                        rsInner = ps.executeQuery();
                        while (rsInner.next()) {
                            allowanceBreakdown.put(rsInner.getString("description"), rsInner.getDouble("breakdown"));
                        }

                        HashMap<String, Double> deductionBreakdown = new HashMap<String, Double>();
                        ps = con.prepareStatement(GET_PAYSLIP_DBD);
                        ps.setInt(1, payslip_id);
                        rsInner = ps.executeQuery();
                        while (rsInner.next()) {
                            deductionBreakdown.put(rsInner.getString("description"), rsInner.getDouble("breakdown"));
                        }

                        HashMap<String, Double> addPaymentBreakdown = new HashMap<String, Double>();
                        ps = con.prepareStatement(GET_PAYSLIP_APBD);
                        ps.setInt(1, payslip_id);
                        rsInner = ps.executeQuery();
                        while (rsInner.next()) {
                            addPaymentBreakdown.put(rsInner.getString("description"), rsInner.getDouble("breakdown"));
                        }
                        results.add(new Payslip(payslip_id, user, paymentMode, startDate, endDate, paymentDate, basic, allowance, deduction, overtimeHr, overtime, additional, employerCpf, allowanceBreakdown, deductionBreakdown, addPaymentBreakdown));
                    }
                }
            }

            if (rsInner != null) {
                rsInner.close();
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }

    public static Payslip getPayslip(String nric, Date start_date) {
        Payslip payslip = null;

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_PAYSLIP);
            ps.setString(1, nric);
            ps.setDate(2, new java.sql.Date(start_date.getTime()));
            rs = ps.executeQuery();
            if (rs.next()) {
                User user = UserDAO.getUserByNRIC(nric);
                java.sql.Date sd = rs.getDate("start_date");

                int payslip_id = rs.getInt("payslip_id");
                String paymentMode = rs.getString("payment_mode");
                DateTime startDate = new DateTime(sd);
                DateTime endDate = new DateTime(rs.getDate("end_date"));
                DateTime paymentDate = new DateTime(rs.getDate("payment_date"));
                double basic = rs.getDouble("basic");
                double allowance = rs.getDouble("allowance");
                double deduction = rs.getDouble("deduction");
                double overtimeHr = rs.getDouble("overtime_hr");
                double overtime = rs.getDouble("overtime");
                double additional = rs.getDouble("additional");
                double employerCpf = rs.getDouble("employer_cpf");

                HashMap<String, Double> allowanceBreakdown = new HashMap<String, Double>();
                ps = con.prepareStatement(GET_PAYSLIP_ABD);
                ps.setInt(1, payslip_id);
                rs = ps.executeQuery();
                while (rs.next()) {
                    allowanceBreakdown.put(rs.getString("description"), rs.getDouble("breakdown"));
                }

                HashMap<String, Double> deductionBreakdown = new HashMap<String, Double>();
                ps = con.prepareStatement(GET_PAYSLIP_DBD);
                ps.setInt(1, payslip_id);
                rs = ps.executeQuery();
                while (rs.next()) {
                    deductionBreakdown.put(rs.getString("description"), rs.getDouble("breakdown"));
                }

                HashMap<String, Double> addPaymentBreakdown = new HashMap<String, Double>();
                ps = con.prepareStatement(GET_PAYSLIP_APBD);
                ps.setInt(1, payslip_id);
                rs = ps.executeQuery();
                while (rs.next()) {
                    addPaymentBreakdown.put(rs.getString("description"), rs.getDouble("breakdown"));
                }
                payslip = new Payslip(payslip_id, user, paymentMode, startDate, endDate, paymentDate, basic, allowance, deduction, overtimeHr, overtime, additional, employerCpf, allowanceBreakdown, deductionBreakdown, addPaymentBreakdown);

            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return payslip;
    }
    
    public static Payslip getPayslipById(int payslip_id) {
        Payslip payslip = null;

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_PAYSLIP_BY_ID);
            ps.setInt(1, payslip_id);
            rs = ps.executeQuery();
            if (rs.next()) {
                String nric = rs.getString("nric");
                User user = UserDAO.getUserByNRIC(nric);
                java.sql.Date sd = rs.getDate("start_date");

                String paymentMode = rs.getString("payment_mode");
                DateTime startDate = new DateTime(sd);
                DateTime endDate = new DateTime(rs.getDate("end_date"));
                DateTime paymentDate = new DateTime(rs.getDate("payment_date"));
                double basic = rs.getDouble("basic");
                double allowance = rs.getDouble("allowance");
                double deduction = rs.getDouble("deduction");
                double overtimeHr = rs.getDouble("overtime_hr");
                double overtime = rs.getDouble("overtime");
                double additional = rs.getDouble("additional");
                double employerCpf = rs.getDouble("employer_cpf");

                HashMap<String, Double> allowanceBreakdown = new HashMap<String, Double>();
                ps = con.prepareStatement(GET_PAYSLIP_ABD);
                ps.setInt(1, payslip_id);
                rs = ps.executeQuery();
                while (rs.next()) {
                    allowanceBreakdown.put(rs.getString("description"), rs.getDouble("breakdown"));
                }

                HashMap<String, Double> deductionBreakdown = new HashMap<String, Double>();
                ps = con.prepareStatement(GET_PAYSLIP_DBD);
                ps.setInt(1, payslip_id);
                rs = ps.executeQuery();
                while (rs.next()) {
                    deductionBreakdown.put(rs.getString("description"), rs.getDouble("breakdown"));
                }

                HashMap<String, Double> addPaymentBreakdown = new HashMap<String, Double>();
                ps = con.prepareStatement(GET_PAYSLIP_APBD);
                ps.setInt(1, payslip_id);
                rs = ps.executeQuery();
                while (rs.next()) {
                    addPaymentBreakdown.put(rs.getString("description"), rs.getDouble("breakdown"));
                }
                payslip = new Payslip(payslip_id, user, paymentMode, startDate, endDate, paymentDate, basic, allowance, deduction, overtimeHr, overtime, additional, employerCpf, allowanceBreakdown, deductionBreakdown, addPaymentBreakdown);

            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return payslip;
    }
}
