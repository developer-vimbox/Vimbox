package com.vimbox.customer;

public class Customer {
    private int id;
    private String name;
    private String contact;
    private String email;

    public Customer(int id, String name, String contact, String email) {
        this.id = id;
        this.name = name;
        this.contact = contact;
        this.email = email;
    }

    public String getName() {
        return name;
    }

    public String getContact() {
        return contact;
    }

    public String getEmail() {
        return email;
    }    
    
    public int getId(){
        return id;
    }
}
