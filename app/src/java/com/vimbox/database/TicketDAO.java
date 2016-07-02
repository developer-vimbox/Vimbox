package com.vimbox.database;

import com.vimbox.customer.Customer;
import com.vimbox.ticket.Ticket;
import com.vimbox.user.User;
import com.vimbox.util.Converter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public class TicketDAO {
    private static final String CREATE_TICKET = "INSERT INTO tickets (ticket_id, owner_user, assigned_users, customer_id, subject, datetime_of_creation, datetime_of_edit, description, solution, status) values (?,?,?,?,?,?,?,?,?,?)";
    private static final String GET_TICKETS_BY_OWNER_USER = "SELECT * FROM tickets WHERE owner_user=? AND status='Pending' ORDER BY datetime_of_creation DESC";
    private static final String GET_TICKETS_BY_ASSIGNED_USER = "SELECT * FROM tickets WHERE assigned_users LIKE ? AND status='Pending' ORDER BY datetime_of_creation DESC";
    private static final String GET_TICKET_BY_ID = "SELECT * FROM tickets WHERE ticket_id=?";
    private static final String DELETE_TICKET = "DELETE FROM tickets WHERE ticket_id=?";
    private static final String RESOLVE_TICKET = "UPDATE tickets SET solution=?, status=? WHERE ticket_id=?";
    private static final String GET_PENDING_TICKETS = "SELECT * FROM tickets WHERE status='Pending' ORDER BY datetime_of_creation DESC";
    private static final String GET_RESOLVED_TICKETS = "SELECT * FROM tickets WHERE status='Resolved' ORDER BY datetime_of_creation DESC";
    private static final String GET_SEARCH_BY_STRING = "SELECT * FROM tickets,customers WHERE tickets.customer_id = customers.customer_id AND (subject like ? or first_name like ? or last_name like ? or email like ?) AND status=?";
    private static final String GET_SEARCH_BY_NUMBER = "SELECT * FROM tickets,customers WHERE tickets.customer_id = customers.customer_id AND (ticket_id like ? or contact like ?) AND status=?";
    private static final String GET_SEARCH_BY_DATE = "SELECT * FROM tickets WHERE datetime_of_creation like ? and status=?";
    
    public static void createTicket(int ticket_id, String owner_user, String assigned_users, int customer_id, DateTime datetime_of_creation, DateTime datetime_of_edit, String subject, String description, String status){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_TICKET);
            ps.setInt(1, ticket_id);
            ps.setString(2, owner_user);
            ps.setString(3, assigned_users);
            ps.setInt(4, customer_id);
            ps.setString(5, subject);
            ps.setString(6, Converter.convertDateDatabase(datetime_of_creation));
            ps.setString(7, Converter.convertDateDatabase(datetime_of_edit));
            ps.setString(8, description);
            ps.setString(9, "");
            ps.setString(10, status);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static ArrayList<Ticket> getTicketsByOwnerUser(User user){
        DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        ArrayList<Ticket> tickets = new ArrayList<Ticket>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_TICKETS_BY_OWNER_USER);
            ps.setString(1,user.getNric());
            rs = ps.executeQuery();
            while (rs.next()) {
                int ticket_id = rs.getInt("ticket_id");
                
                String assignedString = rs.getString("assigned_users");
                ArrayList<User> assigned_users = new ArrayList<User>();
                String[] assign = assignedString.split("\\|");
                for(String assignName:assign){
                    assigned_users.add(UserDAO.getUserByNRIC(assignName));
                }
                
                int customer_id = rs.getInt("customer_id");
                Customer customer = CustomerDAO.getCustomerById(customer_id);
                
                String tempDateTimeString = rs.getString("datetime_of_creation");
                String datetimeString = tempDateTimeString.substring(0,tempDateTimeString.lastIndexOf("."));
                DateTime dt = formatter.parseDateTime(datetimeString);
                
                String tempEditDateTimeString = rs.getString("datetime_of_edit");
                String editDatetimeString = tempEditDateTimeString.substring(0,tempEditDateTimeString.lastIndexOf("."));
                DateTime edt = formatter.parseDateTime(editDatetimeString);
                
                String subject = rs.getString("subject");
                String description = rs.getString("description");
                String solution = rs.getString("solution");
                String status = rs.getString("status");
                
                tickets.add(new Ticket(ticket_id, user, assigned_users, customer, subject, dt, edt, description, solution, status));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return tickets;
    }
    
    public static ArrayList<Ticket> getTicketsByAssignedUser(User user){
        DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        ArrayList<Ticket> tickets = new ArrayList<Ticket>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_TICKETS_BY_ASSIGNED_USER);
            ps.setString(1, "%" + user.getNric() + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                int ticket_id = rs.getInt("ticket_id");
                
                String ownerString = rs.getString("owner_user");
                User owner_user = UserDAO.getUserByNRIC(ownerString);
                
                String assignedString = rs.getString("assigned_users");
                ArrayList<User> assigned_users = new ArrayList<User>();
                String[] assign = assignedString.split("\\|");
                for(String assignName:assign){
                    assigned_users.add(UserDAO.getUserByNRIC(assignName));
                }
                
                int customer_id = rs.getInt("customer_id");
                Customer customer = CustomerDAO.getCustomerById(customer_id);
                
                String tempDateTimeString = rs.getString("datetime_of_creation");
                String datetimeString = tempDateTimeString.substring(0,tempDateTimeString.lastIndexOf("."));
                DateTime dt = formatter.parseDateTime(datetimeString);
                
                String tempEditDateTimeString = rs.getString("datetime_of_edit");
                String editDatetimeString = tempEditDateTimeString.substring(0,tempEditDateTimeString.lastIndexOf("."));
                DateTime edt = formatter.parseDateTime(editDatetimeString);
                
                String subject = rs.getString("subject");
                String description = rs.getString("description");
                String solution = rs.getString("solution");
                String status = rs.getString("status");
                
                tickets.add(new Ticket(ticket_id, owner_user, assigned_users, customer, subject, dt, edt, description, solution, status));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return tickets;
    }
    
    public static Ticket getTicketById(int ticket_id){
        DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        Ticket ticket = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_TICKET_BY_ID);
            ps.setInt(1, ticket_id);
            rs = ps.executeQuery();
            if(rs.next()) {
                String ownerString = rs.getString("owner_user");
                User owner_user = UserDAO.getUserByNRIC(ownerString);
                
                String assignedString = rs.getString("assigned_users");
                ArrayList<User> assigned_users = new ArrayList<User>();
                String[] assign = assignedString.split("\\|");
                for(String assignName:assign){
                    assigned_users.add(UserDAO.getUserByNRIC(assignName));
                }
                
                int customer_id = rs.getInt("customer_id");
                Customer customer = CustomerDAO.getCustomerById(customer_id);
                
                String tempDateTimeString = rs.getString("datetime_of_creation");
                String datetimeString = tempDateTimeString.substring(0,tempDateTimeString.lastIndexOf("."));
                DateTime dt = formatter.parseDateTime(datetimeString);
                
                String tempEditDateTimeString = rs.getString("datetime_of_edit");
                String editDatetimeString = tempEditDateTimeString.substring(0,tempEditDateTimeString.lastIndexOf("."));
                DateTime edt = formatter.parseDateTime(editDatetimeString);
                
                String subject = rs.getString("subject");
                String description = rs.getString("description");
                String solution = rs.getString("solution");
                String status = rs.getString("status");
                
                ticket = new Ticket(ticket_id, owner_user, assigned_users, customer, subject, dt, edt, description, solution, status);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return ticket;
    }
    
    public static void deleteTicket(int ticket_id){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(DELETE_TICKET);
            ps.setInt(1, ticket_id);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static void resolveTicket(int ticket_id, String solution){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(RESOLVE_TICKET);
            ps.setString(1, solution);
            ps.setString(2, "Resolved");
            ps.setInt(3, ticket_id);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static ArrayList<Ticket> getPendingTickets(){
        DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        ArrayList<Ticket> tickets = new ArrayList<Ticket>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_PENDING_TICKETS);
            rs = ps.executeQuery();
            while (rs.next()) {
                int ticket_id = rs.getInt("ticket_id");
                
                String ownerString = rs.getString("owner_user");
                User owner_user = UserDAO.getUserByNRIC(ownerString);
                
                String assignedString = rs.getString("assigned_users");
                ArrayList<User> assigned_users = new ArrayList<User>();
                String[] assign = assignedString.split("\\|");
                for(String assignName:assign){
                    assigned_users.add(UserDAO.getUserByNRIC(assignName));
                }
                
                int customer_id = rs.getInt("customer_id");
                Customer customer = CustomerDAO.getCustomerById(customer_id);
                
                String tempDateTimeString = rs.getString("datetime_of_creation");
                String datetimeString = tempDateTimeString.substring(0,tempDateTimeString.lastIndexOf("."));
                DateTime dt = formatter.parseDateTime(datetimeString);
                
                String tempEditDateTimeString = rs.getString("datetime_of_edit");
                String editDatetimeString = tempEditDateTimeString.substring(0,tempEditDateTimeString.lastIndexOf("."));
                DateTime edt = formatter.parseDateTime(editDatetimeString);
                
                String subject = rs.getString("subject");
                String description = rs.getString("description");
                String solution = rs.getString("solution");
                String status = rs.getString("status");
                
                tickets.add(new Ticket(ticket_id, owner_user, assigned_users, customer, subject, dt, edt, description, solution, status));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return tickets;
    }
    
    public static ArrayList<Ticket> getResolvedTickets(){
        DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        ArrayList<Ticket> tickets = new ArrayList<Ticket>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_RESOLVED_TICKETS);
            rs = ps.executeQuery();
            while (rs.next()) {
                int ticket_id = rs.getInt("ticket_id");
                
                String ownerString = rs.getString("owner_user");
                User owner_user = UserDAO.getUserByNRIC(ownerString);
                
                String assignedString = rs.getString("assigned_users");
                ArrayList<User> assigned_users = new ArrayList<User>();
                String[] assign = assignedString.split("\\|");
                for(String assignName:assign){
                    assigned_users.add(UserDAO.getUserByNRIC(assignName));
                }
                
                int customer_id = rs.getInt("customer_id");
                Customer customer = CustomerDAO.getCustomerById(customer_id);
                
                String tempDateTimeString = rs.getString("datetime_of_creation");
                String datetimeString = tempDateTimeString.substring(0,tempDateTimeString.lastIndexOf("."));
                DateTime dt = formatter.parseDateTime(datetimeString);
                
                String tempEditDateTimeString = rs.getString("datetime_of_edit");
                String editDatetimeString = tempEditDateTimeString.substring(0,tempEditDateTimeString.lastIndexOf("."));
                DateTime edt = formatter.parseDateTime(editDatetimeString);
                
                String subject = rs.getString("subject");
                String description = rs.getString("description");
                String solution = rs.getString("solution");
                String status = rs.getString("status");
                
                tickets.add(new Ticket(ticket_id, owner_user, assigned_users, customer, subject, dt, edt, description, solution, status));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return tickets;
    }
    
    public static ArrayList<Ticket> getSearchTicketsByDate(String keyword, String keyStatus){
        DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        ArrayList<Ticket> results = new ArrayList<Ticket>();
        keyword = "%" + keyword + "%";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_SEARCH_BY_DATE);
            ps.setString(1, keyword);
            ps.setString(2, keyStatus);
            rs = ps.executeQuery();
            while (rs.next()) {
                int ticket_id = rs.getInt("ticket_id");
                
                String ownerString = rs.getString("owner_user");
                User owner_user = UserDAO.getUserByNRIC(ownerString);
                
                String assignedString = rs.getString("assigned_users");
                ArrayList<User> assigned_users = new ArrayList<User>();
                String[] assign = assignedString.split("\\|");
                for(String assignName:assign){
                    assigned_users.add(UserDAO.getUserByNRIC(assignName));
                }
                
                int customer_id = rs.getInt("customer_id");
                Customer customer = CustomerDAO.getCustomerById(customer_id);
                
                String tempDateTimeString = rs.getString("datetime_of_creation");
                String datetimeString = tempDateTimeString.substring(0,tempDateTimeString.lastIndexOf("."));
                DateTime dt = formatter.parseDateTime(datetimeString);
                
                String tempEditDateTimeString = rs.getString("datetime_of_edit");
                String editDatetimeString = tempEditDateTimeString.substring(0,tempEditDateTimeString.lastIndexOf("."));
                DateTime edt = formatter.parseDateTime(editDatetimeString);
                
                String subject = rs.getString("subject");
                String description = rs.getString("description");
                String solution = rs.getString("solution");
                String status = rs.getString("status");
                
                results.add(new Ticket(ticket_id, owner_user, assigned_users, customer, subject, dt, edt, description, solution, status));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    public static ArrayList<Ticket> getSearchTicketsByString(String keyword, String keyStatus){
        DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        ArrayList<Ticket> results = new ArrayList<Ticket>();
        keyword = "%" + keyword + "%";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_SEARCH_BY_STRING);
            ps.setString(1, keyword);
            ps.setString(2, keyword);
            ps.setString(3, keyword);
            ps.setString(4, keyword);
            ps.setString(5, keyStatus);
            rs = ps.executeQuery();
            while (rs.next()) {
                int ticket_id = rs.getInt("ticket_id");
                
                String ownerString = rs.getString("owner_user");
                User owner_user = UserDAO.getUserByNRIC(ownerString);
                
                String assignedString = rs.getString("assigned_users");
                ArrayList<User> assigned_users = new ArrayList<User>();
                String[] assign = assignedString.split("\\|");
                for(String assignName:assign){
                    assigned_users.add(UserDAO.getUserByNRIC(assignName));
                }
                
                int customer_id = rs.getInt("customer_id");
                Customer customer = CustomerDAO.getCustomerById(customer_id);
                
                String tempDateTimeString = rs.getString("datetime_of_creation");
                String datetimeString = tempDateTimeString.substring(0,tempDateTimeString.lastIndexOf("."));
                DateTime dt = formatter.parseDateTime(datetimeString);
                
                String tempEditDateTimeString = rs.getString("datetime_of_edit");
                String editDatetimeString = tempEditDateTimeString.substring(0,tempEditDateTimeString.lastIndexOf("."));
                DateTime edt = formatter.parseDateTime(editDatetimeString);
                
                String subject = rs.getString("subject");
                String description = rs.getString("description");
                String solution = rs.getString("solution");
                String status = rs.getString("status");
                
                results.add(new Ticket(ticket_id, owner_user, assigned_users, customer, subject, dt, edt, description, solution, status));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    public static ArrayList<Ticket> getSearchTicketsByNumber(String keyword, String keyStatus){
        DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        ArrayList<Ticket> results = new ArrayList<Ticket>();
        keyword = "%" + keyword + "%";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_SEARCH_BY_NUMBER);
            ps.setString(1, keyword);
            ps.setString(2, keyword);
            ps.setString(3, keyStatus);
            rs = ps.executeQuery();
            while (rs.next()) {
                int ticket_id = rs.getInt("ticket_id");
                
                String ownerString = rs.getString("owner_user");
                User owner_user = UserDAO.getUserByNRIC(ownerString);
                
                String assignedString = rs.getString("assigned_users");
                ArrayList<User> assigned_users = new ArrayList<User>();
                String[] assign = assignedString.split("\\|");
                for(String assignName:assign){
                    assigned_users.add(UserDAO.getUserByNRIC(assignName));
                }
                
                int customer_id = rs.getInt("customer_id");
                Customer customer = CustomerDAO.getCustomerById(customer_id);
                
                String tempDateTimeString = rs.getString("datetime_of_creation");
                String datetimeString = tempDateTimeString.substring(0,tempDateTimeString.lastIndexOf("."));
                DateTime dt = formatter.parseDateTime(datetimeString);
                
                String tempEditDateTimeString = rs.getString("datetime_of_edit");
                String editDatetimeString = tempEditDateTimeString.substring(0,tempEditDateTimeString.lastIndexOf("."));
                DateTime edt = formatter.parseDateTime(editDatetimeString);
                
                String subject = rs.getString("subject");
                String description = rs.getString("description");
                String solution = rs.getString("solution");
                String status = rs.getString("status");
                
                results.add(new Ticket(ticket_id, owner_user, assigned_users, customer, subject, dt, edt, description, solution, status));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
}
