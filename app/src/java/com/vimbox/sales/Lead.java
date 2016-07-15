package com.vimbox.sales;

import com.vimbox.customer.Customer;
import com.vimbox.sitesurvey.SiteSurvey;
import com.vimbox.user.User;
import java.util.ArrayList;
import java.util.HashMap;
import org.joda.time.DateTime;

public class Lead {
    private User owner;
    private int id;
    private String type;
    private Customer customer;
    private String status;
    private String reason;
    private String source;
    private String referral;
    private String enquiry;
    private ArrayList<SiteSurvey> siteSurveys;
    private DateTime dt;
    
    private String tom;
    private String dom;
    private ArrayList<String[]> addressFrom;
    private ArrayList<String[]> addressTo;
    
    private ArrayList<Item> customerItems;
    private ArrayList<Item> vimboxItems;
    private ArrayList<Item> materials;
    
    private ArrayList<String[]> services;
    private HashMap<String,String> otherCharges;
    
    private ArrayList<String> comments;
    private ArrayList<String> remarks;

    public Lead(User owner, int id, String type, Customer customer, String status, String reason, String source, String referral, String enquiry, DateTime dt, String tom, String dom, ArrayList<String[]> addressFrom, ArrayList<String[]> addressTo, ArrayList<Item> customerItems, ArrayList<Item> vimboxItems, ArrayList<Item> materials, ArrayList<String[]> services, HashMap<String,String> otherCharges, ArrayList<String> comments, ArrayList<String> remarks, ArrayList<SiteSurvey> siteSurveys) {
        this.owner = owner;
        this.id = id;
        this.type = type;
        this.customer = customer;
        this.status = status;
        this.reason = reason;
        this.source = source;
        this.referral = referral;
        this.enquiry = enquiry;
        this.dt = dt;
        this.tom = tom;
        this.dom = dom;
        this.addressFrom = addressFrom;
        this.addressTo = addressTo;
        this.customerItems = customerItems;
        this.vimboxItems = vimboxItems;
        this.materials = materials;
        this.services = services;
        this.otherCharges = otherCharges;
        this.comments = comments;
        this.remarks = remarks;
        this.siteSurveys = siteSurveys;
    }

    public User getOwner(){
        return owner;
    }
    
    public String getType(){
        return type;
    }
    
    public Customer getCustomer() {
        return customer;
    }
    
    public String getEnquiry(){
        return enquiry;
    }

    public String getStatus() {
        return status;
    }

    public String getReason(){
        return reason;
    }
    
    public String getSource(){
        return source;
    }
    
    public String getReferral(){
        return referral;
    }
    
    public DateTime getDt() {
        return dt;
    }

    public String getTom() {
        return tom;
    }

    public String getDom() {
        return dom;
    }

    public ArrayList<String[]> getAddressFrom() {
        return addressFrom;
    }

    public ArrayList<String[]> getAddressTo() {
        return addressTo;
    }

    public ArrayList<Item> getCustomerItems() {
        return customerItems;
    }

    public ArrayList<Item> getVimboxItems() {
        return vimboxItems;
    }

    public ArrayList<Item> getMaterials() {
        return materials;
    }

    public ArrayList<String[]> getServices() {
        return services;
    }

    public HashMap<String,String> getOtherCharges() {
        return otherCharges;
    }
    
    public int getId() {
        return id;
    }

    public ArrayList<String> getComments() {
        return comments;
    }

    public ArrayList<String> getRemarks() {
        return remarks;
    }

    public ArrayList<SiteSurvey> getSiteSurveys() {
        return siteSurveys;
    }
}
