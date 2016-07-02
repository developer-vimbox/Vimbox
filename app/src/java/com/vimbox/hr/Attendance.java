package com.vimbox.hr;

import java.util.HashMap;
import org.joda.time.DateTime;

public class Attendance {
    private DateTime date;
    private HashMap<String, String> attendance_record;
    private HashMap<String, Double> late_record;

    public Attendance(DateTime date, HashMap<String, String> attendance_record, HashMap<String, Double> late_record) {
        this.date = date;
        this.attendance_record = attendance_record;
        this.late_record = late_record;
    }

    public DateTime getDate() {
        return date;
    }

    public HashMap<String, String> getAttendance_record() {
        return attendance_record;
    }

    public HashMap<String, Double> getLate_record() {
        return late_record;
    }
    
    public String getUserAttendance(String nric){
        return attendance_record.get(nric).substring(0,2);
    }
}
