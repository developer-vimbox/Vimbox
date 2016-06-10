package com.vimbox.sales;

import org.joda.time.DateTime;

public class LeadFollowup {
    private String leadId;
    private String followup;
    private DateTime datetime;

    public LeadFollowup(String leadId, String followup, DateTime datetime) {
        this.leadId = leadId;
        this.followup = followup;
        this.datetime = datetime;
    }

    public String getLeadId() {
        return leadId;
    }

    public String getFollowup() {
        return followup;
    }

    public DateTime getDatetime() {
        return datetime;
    }
}
