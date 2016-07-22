
package com.vimbox.sales;

import java.util.ArrayList;
import java.util.HashMap;

public class LeadDiv {
    private String salesDiv;
    private ArrayList<Item> customerItems;
    private ArrayList<Item> vimboxItems;
    private ArrayList<Item> materials;
    
    private ArrayList<String[]> services;
    private HashMap<String,String> otherCharges;
    
    private ArrayList<String> comments;
    private ArrayList<String> remarks;

    public LeadDiv(String salesDiv, ArrayList<Item> customerItems, ArrayList<Item> vimboxItems, ArrayList<Item> materials, ArrayList<String[]> services, HashMap<String, String> otherCharges, ArrayList<String> comments, ArrayList<String> remarks) {
        this.salesDiv = salesDiv;
        this.customerItems = customerItems;
        this.vimboxItems = vimboxItems;
        this.materials = materials;
        this.services = services;
        this.otherCharges = otherCharges;
        this.comments = comments;
        this.remarks = remarks;
    }

    public String getSalesDiv() {
        return salesDiv;
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

    public HashMap<String, String> getOtherCharges() {
        return otherCharges;
    }

    public ArrayList<String> getComments() {
        return comments;
    }

    public ArrayList<String> getRemarks() {
        return remarks;
    }   
}
