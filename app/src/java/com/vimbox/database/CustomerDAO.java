package com.vimbox.database;

import com.vimbox.customer.Customer;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class CustomerDAO {
    private static final String GET_CUSTOMERS_BY_NAME = "SELECT * FROM customers WHERE name LIKE ?";
    private static final String GET_CUSTOMER_BY_ID = "SELECT * FROM customers WHERE id=?";
    private static final String CREATE_CUSTOMER = "INSERT INTO customers (name,contact,email) VALUES (?,?,?)";
    private static final String GET_CUSTOMERS_BY_STRING = "SELECT * FROM customers where (name like ? OR email like ?)";
    private static final String GET_CUSTOMERS_BY_NUMBER = "SELECT * FROM customers where contact like ?";
    private static final String GET_CUSTOMERS_BY_NCE = "SELECT id FROM customers WHERE name=? AND contact=? AND email=?";
    private static final String UPDATE_CUSTOMER = "UPDATE customers SET name=?, contact=?, email=? WHERE id=?";
    
    public static int createCustomer(String name, String contact, String email){
        int id = -1;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_CUSTOMERS_BY_NCE);
            ps.setString(1,name);
            ps.setString(2,contact);
            ps.setString(3,email);
            rs = ps.executeQuery();
            if(rs.next()){
                return id;
            }
            
            ps = con.prepareStatement(CREATE_CUSTOMER);
            ps.setString(1,name);
            ps.setString(2,contact);
            ps.setString(3,email);
            ps.executeUpdate();
            
            ps = con.prepareStatement(GET_CUSTOMERS_BY_NCE);
            ps.setString(1,name);
            ps.setString(2,contact);
            ps.setString(3,email);
            rs = ps.executeQuery();
            if(rs.next()){
                id = rs.getInt("id");
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
        return id;
    }
    
    public static Customer getCustomerById(int id){
        Customer customer = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_CUSTOMER_BY_ID);
            ps.setInt(1,id);
            rs = ps.executeQuery();
            if(rs.next()){
                int custId = rs.getInt("id");
                String name = rs.getString("name");
                String contact = rs.getString("contact");
                String email = rs.getString("email");
                customer = new Customer(custId, name, contact, email);        
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
        return customer;
    }
    
    public static int getCustomerIdByNCE(String name, String contact, String email){
        int id = -1;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_CUSTOMERS_BY_NCE);
            ps.setString(1,name);
            ps.setString(2,contact);
            ps.setString(3,email);
            rs = ps.executeQuery();
            if(rs.next()){
                id = rs.getInt("id");
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
        return id;
    }
    
    public static ArrayList<Customer> getCustomersByName(String custname){
        ArrayList<Customer> customers = new ArrayList<Customer>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_CUSTOMERS_BY_NAME);
            ps.setString(1, "%" + custname + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String contact = rs.getString("contact");
                String email = rs.getString("email");
                
                customers.add(new Customer(id,name,contact,email));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
        return customers;
    }
    
    public static ArrayList<Customer> getCustomersByString(String string){
        ArrayList<Customer> customers = new ArrayList<Customer>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_CUSTOMERS_BY_STRING);
            ps.setString(1, "%" + string + "%");
            ps.setString(2, "%" + string + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String contact = rs.getString("contact");
                String email = rs.getString("email");
                
                customers.add(new Customer(id,name,contact,email));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
        return customers;
    } 
    
    public static ArrayList<Customer> getCustomersByNumber(int number){
        ArrayList<Customer> customers = new ArrayList<Customer>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_CUSTOMERS_BY_NUMBER);
            ps.setString(1, "%" + number + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String contact = rs.getString("contact");
                String email = rs.getString("email");
                
                customers.add(new Customer(id,name,contact,email));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
        return customers;
    } 
    
    public static void updateCustomer(String name, String newContact, String email, int custId){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(UPDATE_CUSTOMER);
            ps.setString(1, name);
            ps.setString(2, newContact);
            ps.setString(3, email);
            ps.setInt(4, custId);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    } 
}
