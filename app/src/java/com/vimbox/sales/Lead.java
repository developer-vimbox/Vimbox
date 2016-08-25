package com.vimbox.sales;

import com.vimbox.customer.Customer;
import com.vimbox.operations.Job;
import com.vimbox.sitesurvey.SiteSurvey;
import com.vimbox.user.User;
import java.util.ArrayList;
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
    private ArrayList<Job> jobs;
    private ArrayList<String[]> addressFrom;
    private ArrayList<String[]> addressTo;
    
    private ArrayList<LeadDiv> leadDivs;

    public Lead(User owner, int id, String type, Customer customer, String status, String reason, String source, String referral, String enquiry, ArrayList<SiteSurvey> siteSurveys, DateTime dt, String tom, ArrayList<Job> jobs, ArrayList<String[]> addressFrom, ArrayList<String[]> addressTo, ArrayList<LeadDiv> leadDivs) {
        this.owner = owner;
        this.id = id;
        this.type = type;
        this.customer = customer;
        this.status = status;
        this.reason = reason;
        this.source = source;
        this.referral = referral;
        this.enquiry = enquiry;
        this.siteSurveys = siteSurveys;
        this.dt = dt;
        this.tom = tom;
        this.jobs = jobs;
        this.addressFrom = addressFrom;
        this.addressTo = addressTo;
        this.leadDivs = leadDivs;
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

    public ArrayList<Job> getJobs() {
        return jobs;
    }

    public ArrayList<String[]> getAddressFrom() {
        return addressFrom;
    }

    public ArrayList<String[]> getAddressTo() {
        return addressTo;
    }
    
    public int getId() {
        return id;
    }

    public ArrayList<SiteSurvey> getSiteSurveys() {
        return siteSurveys;
    }

    public ArrayList<LeadDiv> getSalesDivs() {
        return leadDivs;
    }
    
    public String getSalesDivIdByAddress(String address){
        for(LeadDiv leadDiv : leadDivs){
            String leadDivId = leadDiv.getSalesDiv();
            if(leadDivId.contains(address)){
                return leadDivId.substring(0, leadDivId.indexOf("|"));
            }
        }
        return null;
    }
    
    public LeadDiv getSalesDivByAddress(String address){
        for(LeadDiv leadDiv : leadDivs){
            String leadDivId = leadDiv.getSalesDiv();
            if(leadDivId.contains(address)){
                return leadDiv;
            }
        }
        return null;
    }
    
    public String[] getStoreysPushingDFrom(String address){
        String[] storeysPushingD = null;
        for(String [] addFrom : addressFrom){
            String[] addrArray = addFrom[0].split("_");
            String addrString = addrArray[0] + " #" + addrArray[1] + "-" + addrArray[2] + " S" + addrArray[3];
            if(addrString.equals(address)){
                storeysPushingD = new String[]{addFrom[1], addFrom[2]};
                break;
            }
        }
        return storeysPushingD;
    }
}
