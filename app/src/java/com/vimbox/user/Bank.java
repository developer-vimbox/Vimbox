package com.vimbox.user;

public class Bank {
    private String payment_mode;
    private String bank_name;
    private String account_name; 
    private String account_no;

    public Bank(String payment_mode, String bank_name, String account_name, String account_no) {
        this.payment_mode = payment_mode;
        this.bank_name = bank_name;
        this.account_name = account_name;
        this.account_no = account_no;
    }

    public String getPayment_mode() {
        return payment_mode;
    }

    public String getBank_name() {
        return bank_name;
    }

    public String getAccount_name() {
        return account_name;
    }

    public String getAccount_no() {
        return account_no;
    }
}
