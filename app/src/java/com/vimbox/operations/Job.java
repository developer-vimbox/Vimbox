package com.vimbox.operations;

import com.vimbox.user.User;
import java.util.HashMap;
import org.joda.time.DateTime;

public class Job {
    private int leadId;
    private User owner;
    private HashMap<String, String> addresses;
    private DateTime start;
    private DateTime end;
    private String remarks;
    private String timeslot;
    private String status;
    
}
