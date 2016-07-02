package com.vimbox.user;

public class Contact {
    private int phone;
    private int fax;
    private int home;

    public Contact(int phone, int fax, int home) {
        this.phone = phone;
        this.fax = fax;
        this.home = home;
    }

    public int getPhone() {
        return phone;
    }

    public int getFax() {
        return fax;
    }

    public int getHome() {
        return home;
    }
}
