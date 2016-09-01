package com.vimbox.operations;

import com.vimbox.user.User;
import com.vimbox.util.Converter;
import java.util.Date;
import java.util.HashMap;
import org.joda.time.DateTime;
import org.joda.time.LocalDateTime;

public class Job {
    private int leadId;
    private User owner;
    private User assigned;
    private Date dom;
    // address, address tag //
    private HashMap<String, String> addresses;
    private DateTime start;
    private DateTime end;
    private String remarks;
    private String timeslot;
    private String status;

    public Job(int leadId, User owner, User assigned, Date dom, HashMap<String, String> addresses, DateTime start, DateTime end, String remarks, String timeslot, String status) {
        this.leadId = leadId;
        this.owner = owner;
        this.assigned = assigned;
        this.dom = dom;
        this.addresses = addresses;
        this.start = start;
        this.end = end;
        this.remarks = remarks;
        this.timeslot = timeslot;
        this.status = status;
    }

    public int getLeadId() {
        return leadId;
    }

    public User getOwner() {
        return owner;
    }

    public User getAssigned() {
        return assigned;
    }

    public Date getDom() {
        return dom;
    }

    public HashMap<String, String> getAddresses() {
        return addresses;
    }

    public DateTime getStart() {
        return start;
    }

    public DateTime getEnd() {
        return end;
    }

    public String getRemarks() {
        return remarks;
    }

    public String getTimeslots() {
        return timeslot;
    }

    public String getStatus() {
        return status;
    }

    public String getDate(){
        return Converter.convertDateHtml(start);
    }
    
    public String getTimeSlot(){
        String timeslot = "";
        LocalDateTime startLdt = start.toLocalDateTime();
        int h = startLdt.getHourOfDay();
        String startHour = h + "";
        if (h < 10) {
            startHour = 0 + startHour;
        }

        int m = startLdt.getMinuteOfHour();
        String startMinute = m + "";
        if (m < 10) {
            startMinute = 0 + startMinute;
        }

        LocalDateTime endLdt = end.toLocalDateTime();
        h = endLdt.getHourOfDay();
        String endHour = h + "";
        if (h < 10) {
            endHour = 0 + endHour;
        }

        m = endLdt.getMinuteOfHour();
        String endMinute = m + "";
        if (m < 10) {
            endMinute = 0 + endMinute;
        }

        timeslot = startHour + startMinute + " - " + endHour + endMinute;
        return timeslot;
    }
    
    public boolean checkTaken(String timing) {
        LocalDateTime startLdt = start.toLocalDateTime();
        int h = startLdt.getHourOfDay();
        String startHour = h + "";
        if (h < 10) {
            startHour = 0 + startHour;
        }

        int m = startLdt.getMinuteOfHour();
        String startMinute = m + "";
        if (m < 10) {
            startMinute = 0 + startMinute;
        }

        LocalDateTime endLdt = end.toLocalDateTime();
        h = endLdt.getHourOfDay();
        String endHour = h + "";
        if (h < 10) {
            endHour = 0 + endHour;
        }

        m = endLdt.getMinuteOfHour();
        String endMinute = m + "";
        if (m < 10) {
            endMinute = 0 + endMinute;
        }

        String time = startHour + startMinute + " - " + endHour + endMinute;
        if (time.equals(timing)) {
            return true;
        } else {
            return false;
        }
    }
}
