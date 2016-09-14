package com.vimbox.user;

import java.util.ArrayList;

public class Module {
    private String module_name;
    private ArrayList<String> permittedPages;

    public Module(String module_name, ArrayList<String> permittedPages) {
        this.module_name = module_name;
        this.permittedPages = permittedPages;
    }

    public String getModule_name() {
        return module_name;
    }
    
    public ArrayList<String> getPermittedPages(){
        return permittedPages;
    }
    
    public String toString(){
        return module_name;
    }
}
