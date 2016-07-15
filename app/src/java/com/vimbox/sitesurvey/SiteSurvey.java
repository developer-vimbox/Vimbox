package com.vimbox.sitesurvey;

import com.vimbox.user.User;
import com.vimbox.util.Converter;
import org.joda.time.DateTime;
import org.joda.time.LocalDateTime;

public class SiteSurvey {
    private int lead;
    private User siteSurveyor;
    private String address;
    private DateTime start;
    private DateTime end;
    private String remarks;
    private String timeslot;

    public SiteSurvey(int lead, User siteSurveyor, String address, DateTime start, DateTime end, String timeslot, String remarks) {
        this.lead = lead;
        this.siteSurveyor = siteSurveyor;
        this.address = address;
        this.start = start;
        this.end = end;
        this.timeslot = timeslot;
        this.remarks = remarks;
    }
    
    public String getRemarks(){
        return remarks;
    }

    public int getLead() {
        return lead;
    }

    public User getSiteSurveyor() {
        return siteSurveyor;
    }

    public String getAddress() {
        return address;
    }

    public DateTime getStart() {
        return start;
    }

    public DateTime getEnd() {
        return end;
    }
    
    public String getDate(){
        return Converter.convertDateHtml(start);
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
    
    public String getTimeSlots(){
        return timeslot;
    }
}
