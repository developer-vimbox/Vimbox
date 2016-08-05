
package com.vimbox.sales;

import java.util.ArrayList;
import java.util.HashMap;

public class LeadDiv {
    private String salesDiv;
    private ArrayList<LeadArea> leadAreas;
    
    private ArrayList<String[]> services;
    private HashMap<String,String> otherCharges;
    
    private ArrayList<String> comments;
    private ArrayList<String> remarks;

    public LeadDiv(String salesDiv, ArrayList<LeadArea> leadAreas, ArrayList<String[]> services, HashMap<String, String> otherCharges, ArrayList<String> comments, ArrayList<String> remarks) {
        this.salesDiv = salesDiv;
        this.leadAreas = leadAreas;
        this.services = services;
        this.otherCharges = otherCharges;
        this.comments = comments;
        this.remarks = remarks;
    }

    public String getSalesDiv() {
        return salesDiv;
    }

    public ArrayList<LeadArea> getLeadAreas() {
        return leadAreas;
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
    
    public ArrayList<Item> getCustomerItems(){
        ArrayList<Item> items = new ArrayList<Item>();
        for(LeadArea leadArea: leadAreas){
            items.addAll(leadArea.getCustomerItems());
        }
        return items;
    }
    
    public ArrayList<Item> getVimboxItems(){
        ArrayList<Item> items = new ArrayList<Item>();
        for(LeadArea leadArea: leadAreas){
            items.addAll(leadArea.getVimboxItems());
        }
        return items;
    }
    
    public ArrayList<Item> getMaterials(){
        ArrayList<Item> items = new ArrayList<Item>();
        for(LeadArea leadArea: leadAreas){
            items.addAll(leadArea.getMaterials());
        }
        return items;
    }
}
