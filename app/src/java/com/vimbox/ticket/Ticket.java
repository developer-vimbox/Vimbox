package com.vimbox.ticket;

import com.vimbox.user.User;
import java.util.ArrayList;
import org.joda.time.DateTime;

public class Ticket {
    private User owner;
    private String ticketid;
    private String customerName;
    private String contactNumber;
    private String email;
    private DateTime datetime;
    private String subject;
    private ArrayList<User> assigned;
    private String description;
    private String solution;
    private String status;

    // Constructor used for ticket generation //
    public Ticket(User owner, String ticketid, String customerName, String contactNumber, String email, DateTime datetime, String subject, ArrayList<User> assigned, String description, String status) {
        this.owner = owner;
        this.ticketid = ticketid;
        this.customerName = customerName;
        this.contactNumber = contactNumber;
        this.email = email;
        this.datetime = datetime;
        this.subject = subject;
        this.assigned = assigned;
        this.description = description;
        this.status = status;
        this.solution = "";
    }

    // Constructor used for ticket forum //
    public Ticket(User owner, String ticketid, String customerName, String contactNumber, String email, DateTime datetime, String subject, ArrayList<User> assigned, String description, String solution, String status) {
        this.owner = owner;
        this.ticketid = ticketid;
        this.customerName = customerName;
        this.contactNumber = contactNumber;
        this.email = email;
        this.datetime = datetime;
        this.subject = subject;
        this.assigned = assigned;
        this.description = description;
        this.solution = solution;
        this.status = status;
    }

    public User getOwner() {
        return owner;
    }

    public String getTicketid() {
        return ticketid;
    }

    public String getCustomerName() {
        return customerName;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public DateTime getDatetime() {
        return datetime;
    }

    public String getSubject() {
        return subject;
    }

    public ArrayList<User> getAssigned() {
        return assigned;
    }

    public String getDescription() {
        return description;
    }

    public String getSolution() {
        return solution;
    }

    public String getStatus() {
        return status;
    }

    public String getEmail() {
        return email;
    }
}
