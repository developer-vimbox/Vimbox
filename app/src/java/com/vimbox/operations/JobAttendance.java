package com.vimbox.operations;

import com.vimbox.user.User;
import java.util.ArrayList;

public class JobAttendance {
    private int jobId;
    private User supervisor;
    private ArrayList<User> ftMovers;
    private ArrayList<User> ptMovers;

    public JobAttendance(int jobId, User supervisor, ArrayList<User> ftMovers, ArrayList<User> ptMovers) {
        this.jobId = jobId;
        this.supervisor = supervisor;
        this.ftMovers = ftMovers;
        this.ptMovers = ptMovers;
    }

    public int getJobId() {
        return jobId;
    }

    public User getSupervisor() {
        return supervisor;
    }

    public ArrayList<User> getFtMovers() {
        return ftMovers;
    }

    public ArrayList<User> getPtMovers() {
        return ptMovers;
    }
}
