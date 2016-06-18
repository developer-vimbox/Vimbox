package com.vimbox.user;

import java.util.ArrayList;
import org.joda.time.DateTime;

public class User {
    private String nric;
    private String username;
    private String password;
    private String first_name;
    private String last_name;
    private String gender;
    private DateTime date_of_birth;
    private DateTime date_joined;
    private Address address;
    private int contact;
    private String designation;
    private ArrayList<Module> modules;

    // Used for full-time //
    public User(String nric, String username, String password, String first_name, String last_name, String gender, DateTime date_of_birth, DateTime date_joined, Address address, int contact, String designation, ArrayList<Module> modules) {
        this.nric = nric;
        this.username = username;
        this.password = password;
        this.first_name = first_name;
        this.last_name = last_name;
        this.gender = gender;
        this.date_of_birth = date_of_birth;
        this.date_joined = date_joined;
        this.address = address;
        this.contact = contact;
        this.designation = designation;
        this.modules = modules;
    }
    
    // Used for part-time //
    public User(String nric, String first_name, String last_name, DateTime date_joined, int contact, String designation) {
        this.nric = nric;
        this.first_name = first_name;
        this.last_name = last_name;
        this.date_joined = date_joined;
        this.contact = contact;
        this.designation = designation;
    }
    
    public String getNric() {
        return nric;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public String getFirst_name() {
        return first_name;
    }

    public String getLast_name() {
        return last_name;
    }

    public String getGender() {
        return gender;
    }

    public DateTime getDate_of_birth() {
        return date_of_birth;
    }

    public DateTime getDate_joined() {
        return date_joined;
    }

    public Address getAddress() {
        return address;
    }

    public int getContact() {
        return contact;
    }

    public String getDesignation(){
        return designation;
    }
    
    public ArrayList<Module> getModules() {
        return modules;
    }

    public void setPassword(String password) {
        this.password = password;
    }
    
    public String toString(){
        return last_name + " " + first_name;
    }
}
