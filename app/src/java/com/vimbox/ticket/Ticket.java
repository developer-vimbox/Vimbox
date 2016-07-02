package com.vimbox.ticket;

import com.vimbox.customer.Customer;
import com.vimbox.user.User;
import java.util.ArrayList;
import org.joda.time.DateTime;

public class Ticket {
    private int ticket_id;
    private User owner_user;
    private ArrayList<User> assigned_users;
    private Customer customer;
    private String subject;
    private DateTime datetime_of_creation;
    private DateTime datetime_of_edit;
    private String description;
    private String solution;
    private String status;

    public Ticket(int ticket_id, User owner_user, ArrayList<User> assigned_users, Customer customer, String subject, DateTime datetime_of_creation, DateTime datetime_of_edit, String description, String solution, String status) {
        this.ticket_id = ticket_id;
        this.owner_user = owner_user;
        this.assigned_users = assigned_users;
        this.customer = customer;
        this.subject = subject;
        this.datetime_of_creation = datetime_of_creation;
        this.datetime_of_edit = datetime_of_edit;
        this.description = description;
        this.solution = solution;
        this.status = status;
    }

    public int getTicket_id() {
        return ticket_id;
    }

    public User getOwner_user() {
        return owner_user;
    }

    public ArrayList<User> getAssigned_users() {
        return assigned_users;
    }

    public Customer getCustomer() {
        return customer;
    }

    public String getSubject() {
        return subject;
    }

    public DateTime getDatetime_of_creation() {
        return datetime_of_creation;
    }

    public DateTime getDatetime_of_edit() {
        return datetime_of_edit;
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
}
