package com.vimbox.user;

import java.util.ArrayList;

public class User {
    private String username;
    private String password;
    private String fullname;
    private ArrayList<String> modules;

    public User(String username, String password, String fullname, String modules) {
        this.username = username;
        this.password = password;
        this.fullname = fullname;
        String[] modulesArr = modules.split(";");
        this.modules = new ArrayList<String>();
        for(String module:modulesArr){
            this.modules.add(module);
        }
    }

    public String getFullname() {
        return fullname;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public ArrayList<String> getModules() {
        return modules;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
