package com.vimbox.database;

import com.vimbox.operations.Truck;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class TruckDAO {
    private static final String GET_ALL_TRUCKS = "SELECT * FROM trucks";
    private static final String GET_TRUCK_BY_CARPLATE = "SELECT * FROM trucks WHERE carplate_no=?";
    
    public static ArrayList<Truck> getAllTrucks(){
        ArrayList<Truck> results = new ArrayList<Truck>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_ALL_TRUCKS);
            rs = ps.executeQuery();

            while (rs.next()) {
                results.add(new Truck(rs.getString("carplate_no"), rs.getString("name")));
            }

        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return results;
    }
    
    public static Truck getTruckByCarplate(String carplate){
        Truck truck = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_TRUCK_BY_CARPLATE);
            ps.setString(1, carplate);
            rs = ps.executeQuery();
            if (rs.next()) {
                truck = new Truck(rs.getString("carplate_no"), rs.getString("name"));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, rs);
        }
        return truck;
    }
}
