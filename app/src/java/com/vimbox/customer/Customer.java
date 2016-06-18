package com.vimbox.customer;

public class Customer {
    private int customer_id;
    private String salutation;
    private String first_name;
    private String last_name;
    private int contact;
    private String email;

    public Customer(int customer_id, String salutation, String first_name, String last_name, int contact, String email) {
        this.customer_id = customer_id;
        this.salutation = salutation;
        this.first_name = first_name;
        this.last_name = last_name;
        this.contact = contact;
        this.email = email;
    }

    public int getCustomer_id() {
        return customer_id;
    }

    public String getSalutation() {
        return salutation;
    }

    public String getFirst_name() {
        return first_name;
    }

    public String getLast_name() {
        return last_name;
    }

    public int getContact() {
        return contact;
    }

    public String getEmail() {
        return email;
    }
    
    public String toString(){
        return salutation + " " + last_name + " " + first_name;
    }
}
