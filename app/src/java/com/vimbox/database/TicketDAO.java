package com.vimbox.database;

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
    private static final String CREATE_TICKET = "INSERT INTO tickets (id,owneruser,subject,datetiming,assigned,custname,custcontact,description,solution,status,custemail) values (?,?,?,?,?,?,?,?,?,?,?)";
    private static final String GET_TICKETS = "SELECT * FROM tickets";
    private static final String GET_PENDING_TICKETS = "SELECT * FROM tickets WHERE status='Pending'";
    private static final String GET_RESOLVED_TICKETS = "SELECT * FROM tickets WHERE status='Resolved'";
    private static final String GET_SEARCH_BY_STRING = "SELECT * FROM tickets WHERE (subject like ? or custname like ? or custemail like ?) and status=?";
    private static final String GET_SEARCH_BY_NUMBER = "SELECT * FROM tickets WHERE (id like ? or custcontact like ?) and status=?";
    private static final String GET_SEARCH_BY_DATE = "SELECT * FROM tickets WHERE datetiming like ? and status=?";
    private static final String GET_TICKETS_BY_ASSIGNED_USER = "SELECT * FROM tickets WHERE assigned LIKE ? AND status='Pending' ORDER BY datetiming DESC";
    private static final String GET_TICKETS_BY_OWNER_USER = "SELECT * FROM tickets WHERE owneruser=? AND status='Pending' ORDER BY datetiming DESC";
    private static final String GET_TICKET_BY_ID = "SELECT * FROM tickets WHERE id=?";
    private static final String UPDATE_TICKET = "UPDATE tickets SET subject=?, assigned=?, custname=?, custcontact=?, custemail=?, description=? WHERE id=?";
    private static final String RESOLVE_TICKET = "UPDATE tickets SET solution=?, status=? WHERE id=?";
    
    public static Ticket createTicket(User owner, String ticketId, String customerName, String contactNumber, DateTime dt, String subject, ArrayList<User> assignedUsers, String description, String status, String email){
        Ticket ticket = null;
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_TICKET);
            ps.setString(1, ticketId);
            ps.setString(2, owner.getUsername());
            ps.setString(3, subject);
            ps.setString(4, Converter.convertDateDatabase(dt));
            
            String assigned = "";
            for(User user:assignedUsers){
                assigned+=(user.getFullname()+",");
            }
            ps.setString(5, assigned.substring(0,assigned.length()-1));
            
            ps.setString(6, customerName);
            ps.setString(7, contactNumber);
            ps.setString(8, description);
            ps.setString(9, "");
            ps.setString(10, status);
            ps.setString(11, email);
            ps.executeUpdate();
            ticket = new Ticket(owner, ticketId, customerName, contactNumber, email, dt, subject, assignedUsers, description, status);
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
        return ticket;
    }
    
    public static ArrayList<Ticket> getTickets(){
        DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
       
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ArrayList<Ticket> tickets = new ArrayList<Ticket>();
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_TICKETS);
            rs = ps.executeQuery();
            while (rs.next()) {
                User owner = UserDAO.getUserByUsername(rs.getString("owneruser"));
                String ticketId = rs.getString("id");
                String customerName = rs.getString("custname");
                String contactNumber = rs.getString("custcontact");
                String email = rs.getString("custemail");
                
                String tempDateTimeString = rs.getString("datetiming");
                String datetimeString = tempDateTimeString.substring(0,tempDateTimeString.lastIndexOf("."));
                DateTime dt = formatter.parseDateTime(datetimeString);
                
                String subject = rs.getString("subject");
                
                String assignedString = rs.getString("assigned");
                ArrayList<User> assigned = new ArrayList<User>();
                String[] assign = assignedString.split(",");
                for(String assignName:assign){
                    assigned.add(UserDAO.getUserByUsername(assignName));
                }
                
                String description = rs.getString("description");
                String solution = rs.getString("solution");
                String status = rs.getString("status");
                tickets.add(new Ticket(owner,ticketId,customerName,contactNumber,email,dt,subject,assigned,description,solution,status));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return tickets;
    }
    
    public static ArrayList<Ticket> getSearchTicketsByString(String keyword, String action){
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
            ps.setString(4, action);
            rs = ps.executeQuery();
            while (rs.next()) {
                User owner = UserDAO.getUserByUsername(rs.getString("owneruser"));
                String ticketId = rs.getString("id");
                String customerName = rs.getString("custname");
                String contactNumber = rs.getString("custcontact");
                String email = rs.getString("custemail");
                
                String tempDateTimeString = rs.getString("datetiming");
                String datetimeString = tempDateTimeString.substring(0,tempDateTimeString.lastIndexOf("."));
                DateTime dt = formatter.parseDateTime(datetimeString);
                
                String subject = rs.getString("subject");
                
                String assignedString = rs.getString("assigned");
                ArrayList<User> assigned = new ArrayList<User>();
                String[] assign = assignedString.split(",");
                for(String assignName:assign){
                    assigned.add(UserDAO.getUserByUsername(assignName));
                }
                
                String description = rs.getString("description");
                String solution = rs.getString("solution");
                String status = rs.getString("status");
                results.add(new Ticket(owner,ticketId,customerName,contactNumber,email,dt,subject,assigned,description,solution,status));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    public static ArrayList<Ticket> getSearchTicketsByNumber(String keyword, String action){
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
            ps.setString(3, action);
            rs = ps.executeQuery();
            while (rs.next()) {
                User owner = UserDAO.getUserByUsername(rs.getString("owneruser"));
                String ticketId = rs.getString("id");
                String customerName = rs.getString("custname");
                String contactNumber = rs.getString("custcontact");
                String email = rs.getString("custemail");
                
                String tempDateTimeString = rs.getString("datetiming");
                String datetimeString = tempDateTimeString.substring(0,tempDateTimeString.lastIndexOf("."));
                DateTime dt = formatter.parseDateTime(datetimeString);
                
                String subject = rs.getString("subject");
                
                String assignedString = rs.getString("assigned");
                ArrayList<User> assigned = new ArrayList<User>();
                String[] assign = assignedString.split(",");
                for(String assignName:assign){
                    assigned.add(UserDAO.getUserByUsername(assignName));
                }
                
                String description = rs.getString("description");
                String solution = rs.getString("solution");
                String status = rs.getString("status");
                results.add(new Ticket(owner,ticketId,customerName,contactNumber,email,dt,subject,assigned,description,solution,status));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    public static ArrayList<Ticket> getSearchTicketsByDate(String keyword, String action){
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
            ps.setString(2, action);
            rs = ps.executeQuery();
            while (rs.next()) {
                User owner = UserDAO.getUserByUsername(rs.getString("owneruser"));
                String ticketId = rs.getString("id");
                String customerName = rs.getString("custname");
                String contactNumber = rs.getString("custcontact");
                String email = rs.getString("custemail");
                
                String tempDateTimeString = rs.getString("datetiming");
                String datetimeString = tempDateTimeString.substring(0,tempDateTimeString.lastIndexOf("."));
                DateTime dt = formatter.parseDateTime(datetimeString);
                
                String subject = rs.getString("subject");
                
                String assignedString = rs.getString("assigned");
                ArrayList<User> assigned = new ArrayList<User>();
                String[] assign = assignedString.split(",");
                for(String assignName:assign){
                    assigned.add(UserDAO.getUserByUsername(assignName));
                }
                
                String description = rs.getString("description");
                String solution = rs.getString("solution");
                String status = rs.getString("status");
                results.add(new Ticket(owner,ticketId,customerName,contactNumber,email,dt,subject,assigned,description,solution,status));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
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
                User owner = UserDAO.getUserByUsername(rs.getString("owneruser"));
                String ticketId = rs.getString("id");
                String customerName = rs.getString("custname");
                String contactNumber = rs.getString("custcontact");
                String email = rs.getString("custemail");
                
                String tempDateTimeString = rs.getString("datetiming");
                String datetimeString = tempDateTimeString.substring(0,tempDateTimeString.lastIndexOf("."));
                DateTime dt = formatter.parseDateTime(datetimeString);
                
                String subject = rs.getString("subject");
                
                String assignedString = rs.getString("assigned");
                ArrayList<User> assigned = new ArrayList<User>();
                String[] assign = assignedString.split(",");
                for(String assignName:assign){
                    assigned.add(UserDAO.getUserByFullname(assignName));
                }
                
                String description = rs.getString("description");
                String solution = rs.getString("solution");
                String status = rs.getString("status");
                tickets.add(new Ticket(owner,ticketId,customerName,contactNumber,email,dt,subject,assigned,description,solution,status));
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
                User owner = UserDAO.getUserByUsername(rs.getString("owneruser"));
                String ticketId = rs.getString("id");
                String customerName = rs.getString("custname");
                String contactNumber = rs.getString("custcontact");
                String email = rs.getString("custemail");
                
                String tempDateTimeString = rs.getString("datetiming");
                String datetimeString = tempDateTimeString.substring(0,tempDateTimeString.lastIndexOf("."));
                DateTime dt = formatter.parseDateTime(datetimeString);
                
                String subject = rs.getString("subject");
                
                String assignedString = rs.getString("assigned");
                ArrayList<User> assigned = new ArrayList<User>();
                String[] assign = assignedString.split(",");
                for(String assignName:assign){
                    assigned.add(UserDAO.getUserByFullname(assignName));
                }
                
                String description = rs.getString("description");
                String solution = rs.getString("solution");
                String status = rs.getString("status");
                tickets.add(new Ticket(owner,ticketId,customerName,contactNumber,email,dt,subject,assigned,description,solution,status));
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
            ps.setString(1, "%"+user.getFullname()+"%");
            rs = ps.executeQuery();
            while (rs.next()) {
                User owner = UserDAO.getUserByUsername(rs.getString("owneruser"));
                String ticketId = rs.getString("id");
                String customerName = rs.getString("custname");
                String contactNumber = rs.getString("custcontact");
                String email = rs.getString("custemail");
                
                String tempDateTimeString = rs.getString("datetiming");
                String datetimeString = tempDateTimeString.substring(0,tempDateTimeString.lastIndexOf("."));
                DateTime dt = formatter.parseDateTime(datetimeString);
                
                String subject = rs.getString("subject");
                
                String assignedString = rs.getString("assigned");
                ArrayList<User> assigned = new ArrayList<User>();
                String[] assign = assignedString.split(",");
                for(String assignName:assign){
                    if(!assignName.equals(user.getFullname())){
                        assigned.add(UserDAO.getUserByFullname(assignName));
                    }else{
                        assigned.add(user);
                    }
                }
                
                String description = rs.getString("description");
                String solution = rs.getString("solution");
                String status = rs.getString("status");
                tickets.add(new Ticket(owner,ticketId,customerName,contactNumber,email,dt,subject,assigned,description,solution,status));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return tickets;
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
            ps.setString(1,user.getUsername());
            rs = ps.executeQuery();
            while (rs.next()) {
                String ticketId = rs.getString("id");
                String customerName = rs.getString("custname");
                String contactNumber = rs.getString("custcontact");
                String email = rs.getString("custemail");
                
                String tempDateTimeString = rs.getString("datetiming");
                String datetimeString = tempDateTimeString.substring(0,tempDateTimeString.lastIndexOf("."));
                DateTime dt = formatter.parseDateTime(datetimeString);
                
                String subject = rs.getString("subject");
                
                String assignedString = rs.getString("assigned");
                ArrayList<User> assigned = new ArrayList<User>();
                String[] assign = assignedString.split(",");
                for(String assignName:assign){
                    assigned.add(UserDAO.getUserByUsername(assignName));
                }
                
                String description = rs.getString("description");
                String solution = rs.getString("solution");
                String status = rs.getString("status");
                tickets.add(new Ticket(user,ticketId,customerName,contactNumber,email,dt,subject,assigned,description,solution,status));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return tickets;
    }
    
    public static Ticket getTicketById(String id){
        DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        Ticket ticket = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_TICKET_BY_ID);
            ps.setString(1, id);
            rs = ps.executeQuery();
            if(rs.next()) {
                User owner = UserDAO.getUserByUsername(rs.getString("owneruser"));
                String ticketId = rs.getString("id");
                String customerName = rs.getString("custname");
                String contactNumber = rs.getString("custcontact");
                String email = rs.getString("custemail");
                
                String tempDateTimeString = rs.getString("datetiming");
                String datetimeString = tempDateTimeString.substring(0,tempDateTimeString.lastIndexOf("."));
                DateTime dt = formatter.parseDateTime(datetimeString);
                
                String subject = rs.getString("subject");
                
                String assignedString = rs.getString("assigned");
                ArrayList<User> assigned = new ArrayList<User>();
                String[] assign = assignedString.split(",");
                for(String assignName:assign){
                    assigned.add(UserDAO.getUserByFullname(assignName));
                }
                
                String description = rs.getString("description");
                String solution = rs.getString("solution");
                String status = rs.getString("status");
                ticket = new Ticket(owner,ticketId,customerName,contactNumber,email,dt,subject,assigned,description,solution,status);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return ticket;
    }
    
    public static void resolveTicket(String ticketId, String solution){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(RESOLVE_TICKET);
            ps.setString(1, solution);
            ps.setString(2, "Resolved");
            ps.setString(3, ticketId);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static void updateTicket(String subject, String assigned, String custname, String custcontact, String custemail, String description, String id){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(UPDATE_TICKET);
            ps.setString(1, subject);
            ps.setString(2, assigned);
            ps.setString(3, custname);
            ps.setString(4, custcontact);
            ps.setString(5, custemail);
            ps.setString(6, description);
            ps.setString(7, id);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
}
