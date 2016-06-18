package com.vimbox.database;

import com.vimbox.ticket.TicketComment;
import com.vimbox.util.Converter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public class TicketCommentDAO {
    private static final String CREATE_TICKET_COMMENT = "INSERT INTO ticket_comments (ticket_id, comment, datetime_of_creation) values (?,?,?)";
    private static final String GET_TICKET_COMMENT_BY_ID = "SELECT * FROM ticket_comments where ticket_id=? ORDER BY datetime_of_creation DESC";
    
    public static void createTicketComment(int ticket_id, String comment, DateTime dt){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_TICKET_COMMENT);
            ps.setInt(1, ticket_id);
            ps.setString(2, comment);
            ps.setString(3, Converter.convertDateDatabase(dt));
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static ArrayList<TicketComment> getTicketCommentsById(int ticket_id){
        DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        ArrayList<TicketComment> ticketComments = new ArrayList<TicketComment>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_TICKET_COMMENT_BY_ID);
            ps.setInt(1, ticket_id);
            rs = ps.executeQuery();
            while (rs.next()) {
                String comment = rs.getString("comment");
                
                String tempDateTimeString = rs.getString("datetime_of_creation");
                String datetimeString = tempDateTimeString.substring(0,tempDateTimeString.lastIndexOf("."));
                DateTime dt = formatter.parseDateTime(datetimeString);
                
                ticketComments.add(new TicketComment(ticket_id,comment,dt));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
        return ticketComments;
    }
}
