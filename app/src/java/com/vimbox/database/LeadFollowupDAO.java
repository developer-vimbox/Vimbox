package com.vimbox.database;

import com.vimbox.sales.LeadFollowup;
import com.vimbox.util.Converter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public class LeadFollowupDAO {
    private static final String CREATE_LEAD_FOLLOWUP = "INSERT INTO lead_followups (lead_id, followup, datetime_of_creation) values (?,?,?)";
    private static final String GET_LEAD_FOLLOWUPS_BY_ID = "SELECT * FROM lead_followups where lead_id=? ORDER BY datetime_of_creation DESC";
    
    public static void createLeadFollowup(int lead_id, String followup, DateTime dt){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_LEAD_FOLLOWUP);
            ps.setInt(1, lead_id);
            ps.setString(2, followup);
            ps.setString(3, Converter.convertDateDatabase(dt));
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    }
    
    public static ArrayList<LeadFollowup> getLeadFollowupsById(int lead_id){
        DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        ArrayList<LeadFollowup> leadFollowups = new ArrayList<LeadFollowup>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_LEAD_FOLLOWUPS_BY_ID);
            ps.setInt(1, lead_id);
            rs = ps.executeQuery();
            while (rs.next()) {
                String followup = rs.getString("followup");
                
                String tempDateTimeString = rs.getString("datetime_of_creation");
                String datetimeString = tempDateTimeString.substring(0,tempDateTimeString.lastIndexOf("."));
                DateTime dt = formatter.parseDateTime(datetimeString);
                
                leadFollowups.add(new LeadFollowup(lead_id,followup,dt));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
        return leadFollowups;
    }
}
