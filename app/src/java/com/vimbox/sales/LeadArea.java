package com.vimbox.sales;

import java.util.ArrayList;

public class LeadArea {
    private String leadAreaDiv;
    private String leadName;
    private ArrayList<Item> customerItems;
    private ArrayList<Item> vimboxItems;
    private ArrayList<Item> materials;

    public LeadArea(String leadAreaDiv, String leadName, ArrayList<Item> customerItems, ArrayList<Item> vimboxItems, ArrayList<Item> materials) {
        this.leadAreaDiv = leadAreaDiv;
        this.leadName = leadName;
        this.customerItems = customerItems;
        this.vimboxItems = vimboxItems;
        this.materials = materials;
    }

    public String getLeadAreaDiv() {
        return leadAreaDiv;
    }

    public String getLeadName() {
        return leadName;
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
}
