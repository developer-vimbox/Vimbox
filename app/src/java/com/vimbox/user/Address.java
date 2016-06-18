package com.vimbox.user;

public class Address {
    private String address;
    private String unit;
    private String postal_code;

    public Address(String address, String unit, String postal_code) {
        this.address = address;
        this.unit = unit;
        this.postal_code = postal_code;
    }
    
    public Address(String address) {
        String[] details = address.split("\\|");
        this.address = details[0];
        this.unit = details[1];
        this.postal_code = details[2];
    }

    public String getAddress() {
        return address;
    }

    public String getUnit() {
        return unit;
    }

    public String getPostal_code() {
        return postal_code;
    }
    
    public String toString(){
        return address + " " + unit + " " + postal_code;
    }
}
