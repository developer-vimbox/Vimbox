package com.vimbox.sales;

import org.joda.time.DateTime;

public class LeadFollowup {
    private int lead_id;
    private String followup;
    private DateTime datetime;

    public LeadFollowup(int lead_id, String followup, DateTime datetime) {
        this.lead_id = lead_id;
        this.followup = followup;
        this.datetime = datetime;
    }

    public int getLead_id() {
        return lead_id;
    }
    
    public String getFollowup() {
        return followup;
    }

    public DateTime getDatetime() {
        return datetime;
    }
}
