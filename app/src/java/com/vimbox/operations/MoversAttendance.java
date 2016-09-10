package com.vimbox.operations;

import com.vimbox.user.User;
import java.util.ArrayList;

public class MoversAttendance {
    private String supervisor;
    private User mover;
    private String dom;
    private String status;
    private int duration;
    
    public MoversAttendance(String supervisor, User mover, String dom, String status, int duration) {
        this.supervisor = supervisor;
        this.mover = mover;
        this.dom = dom;
        this.status = status;
        this.duration = duration;
    }
    
    public String getSupervisor() {
        return supervisor;
    }
    
    public User getMover() {
        return mover;
    }
    
    public String getDom() {
        return dom;
    }
    
    public String getStatus() {
        return status;
    }
    
    public int getDuration() {
        return duration;
    }
}
