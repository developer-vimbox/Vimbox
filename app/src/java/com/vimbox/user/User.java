package com.vimbox.user;

import java.util.ArrayList;
import org.joda.time.DateTime;

public class User {
    private String nric;
    private String first_name;
    private String last_name;
    private double leave;
    private int mc;
    private double used_leave;
    private int used_mc;
    private Account account;
    private String type;
    private DateTime date_joined;
    private String mailing_address;
    private String registered_address;
    private String license;
    private Contact contact;
    private Emergency emergency;
    private String department;
    private String designation;
    private int salary;
    private ArrayList<Module> modules;
    private Bank bank;

    public User(String nric, String first_name, String last_name, double leave, int mc, double used_leave, int used_mc, Account account, String type, DateTime date_joined, String mailing_address, String registered_address, String license, Contact contact, Emergency emergency, String department, String designation, int salary, ArrayList<Module> modules, Bank bank) {
        this.nric = nric;
        this.first_name = first_name;
        this.last_name = last_name;
        this.leave = leave;
        this.mc = mc;
        this.used_leave = used_leave;
        this.used_mc = used_mc;
        this.account = account;
        this.type = type;
        this.date_joined = date_joined;
        this.mailing_address = mailing_address;
        this.registered_address = registered_address;
        this.license = license;
        this.contact = contact;
        this.emergency = emergency;
        this.department = department;
        this.designation = designation;
        this.salary = salary;
        this.modules = modules;
        this.bank = bank;
    }

    public String getNric() {
        return nric;
    }

    public String getFirst_name() {
        return first_name;
    }

    public String getLast_name() {
        return last_name;
    }

    public double getLeave() {
        return leave;
    }
    
    public int getMc() {
        return mc;
    }

    public double getUsed_leave() {
        return used_leave;
    }

    public int getUsed_mc() {
        return used_mc;
    }

    public Account getAccount() {
        return account;
    }

    public String getType() {
        return type;
    }

    public DateTime getDate_joined() {
        return date_joined;
    }

    public String getMailing_address() {
        return mailing_address;
    }

    public String getRegistered_address() {
        return registered_address;
    }

    public String getLicense() {
        return license;
    }

    public Contact getContact() {
        return contact;
    }

    public Emergency getEmergency() {
        return emergency;
    }

    public String getDepartment() {
        return department;
    }

    public String getDesignation() {
        return designation;
    }

    public int getSalary() {
        return salary;
    }

    public ArrayList<Module> getModules() {
        return modules;
    }
    
    public ArrayList<String> getModuleNames(){
        ArrayList<String> list = new ArrayList<String>();
        for(Module mod : modules){
            list.add(mod.getModule_name());
        }
        return list;
    }
    
    public ArrayList<String> getPermittedPages(){
        ArrayList<String> pages = new ArrayList<String>();
        for(Module mod : modules){
            pages.addAll(mod.getPermittedPages());
        }
        return pages;
    }

    public Bank getBank() {
        return bank;
    }
    
    public String toString(){
        return last_name + " " + first_name;
    }
}
