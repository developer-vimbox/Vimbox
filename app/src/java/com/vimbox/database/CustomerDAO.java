package com.vimbox.database;

import com.vimbox.customer.Customer;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class CustomerDAO {
    private static final String GET_CUSTOMERS_BY_NAME = "SELECT * FROM customers WHERE (first_name like ? OR last_name like ?)";
    private static final String GET_CUSTOMER_BY_ID = "SELECT * FROM customers WHERE customer_id=?";
    private static final String CREATE_CUSTOMER = "INSERT INTO customers (salutation, first_name, last_name, contact, email) VALUES (?,?,?,?,?)";
    private static final String GET_CUSTOMERS_BY_STRING = "SELECT * FROM customers where (first_name like ? OR last_name like ? OR email like ?)";
    private static final String GET_CUSTOMERS_BY_CONTACT = "SELECT * FROM customers where contact like ?";
    private static final String CUSTOMER_EXISIS = "SELECT id FROM customers WHERE salutation=? AND first_name=? AND last_name=? AND contact=? AND email=?";
    private static final String UPDATE_CUSTOMER = "UPDATE customers SET salutation=?, first_name=?, last_name=?, contact=?, email=? WHERE customer_id=?";
    
    private static boolean customerExists(String salutation, String firstName, String lastName, int contact, String email){
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CUSTOMER_EXISIS);
            ps.setString(1,salutation);
            ps.setString(2,firstName);
            ps.setString(3,lastName);
            ps.setInt(4,contact);
            ps.setString(5,email);
            rs = ps.executeQuery();
            if(rs.next()){
                return true;
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
        return false;
    }
    
    public static int createCustomer(String salutation, String firstName, String lastName, int contact, String email){
        int id = -1;
        if(customerExists(salutation, firstName, lastName, contact, email)){
            return id;
        }
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(CREATE_CUSTOMER, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1,salutation);
            ps.setString(2,firstName);
            ps.setString(3,lastName);
            ps.setInt(4,contact);
            ps.setString(5,email);
            ps.executeUpdate();
            
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                id = (int) rs.getInt(1);
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
                int customer_id = rs.getInt("customer_id");
                String salutation = rs.getString("salutation");
                String first_name = rs.getString("first_name");
                String last_name = rs.getString("last_name");
                int contact = rs.getInt("contact");
                String email = rs.getString("email");
                customer = new Customer(customer_id, salutation, first_name, last_name,contact,email);        
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
        return customer;
    }
    
    public static ArrayList<Customer> getCustomersByName(String searchName){
        ArrayList<Customer> customers = new ArrayList<Customer>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_CUSTOMERS_BY_NAME);
            ps.setString(1, "%" + searchName + "%");
            ps.setString(2, "%" + searchName + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                int customer_id = rs.getInt("customer_id");
                String salutation = rs.getString("salutation");
                String first_name = rs.getString("first_name");
                String last_name = rs.getString("last_name");
                int contact = rs.getInt("contact");
                String email = rs.getString("email");
                
                customers.add(new Customer(customer_id, salutation, first_name, last_name,contact,email));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
        return customers;
    }
    
    public static ArrayList<Customer> getCustomersByString(String searchString){
        ArrayList<Customer> customers = new ArrayList<Customer>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_CUSTOMERS_BY_STRING);
            ps.setString(1, "%" + searchString + "%");
            ps.setString(2, "%" + searchString + "%");
            ps.setString(3, "%" + searchString + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                int customer_id = rs.getInt("customer_id");
                String salutation = rs.getString("salutation");
                String first_name = rs.getString("first_name");
                String last_name = rs.getString("last_name");
                int contact = rs.getInt("contact");
                String email = rs.getString("email");
                
                customers.add(new Customer(customer_id, salutation, first_name, last_name,contact,email));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
        return customers;
    } 
    
    public static ArrayList<Customer> getCustomersByContact(int searchContact){
        ArrayList<Customer> customers = new ArrayList<Customer>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(GET_CUSTOMERS_BY_CONTACT);
            ps.setString(1, "%" + searchContact + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                int customer_id = rs.getInt("customer_id");
                String salutation = rs.getString("salutation");
                String first_name = rs.getString("first_name");
                String last_name = rs.getString("last_name");
                int contact = rs.getInt("contact");
                String email = rs.getString("email");
                
                customers.add(new Customer(customer_id, salutation, first_name, last_name,contact,email));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
        return customers;
    } 
    
    public static void updateCustomer(int customer_id, String salutation, String firstName, String lastName, int contact, String email){
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = ConnectionManager.getConnection();
            ps = con.prepareStatement(UPDATE_CUSTOMER);
            ps.setString(1, salutation);
            ps.setString(2, firstName);
            ps.setString(3, lastName);
            ps.setInt(4, contact);
            ps.setString(5, email);
            ps.setInt(6, customer_id);
            ps.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            ConnectionManager.close(con, ps, null);
        }
    } 
}
