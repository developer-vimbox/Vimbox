package com.vimbox.user;

public class Module {
    private String module_name;

    public Module(String module_name) {
        this.module_name = module_name;
    }

    public String getModule_name() {
        return module_name;
    }
    
    public String toString(){
        return module_name;
    }
}
