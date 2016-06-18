package com.vimbox.util;

import java.util.ArrayList;
import org.joda.time.DateTime;
import org.joda.time.LocalDateTime;

public class Converter {

    public static String convertDateHtml(DateTime datetime) {
        String datetimeString = "";
        LocalDateTime ldt = datetime.toLocalDateTime();
        int day = ldt.getDayOfMonth();
        int month = ldt.getMonthOfYear();
        int year = ldt.getYear();

        int hour = ldt.getHourOfDay();
        int min = ldt.getMinuteOfHour();
        int sec = ldt.getSecondOfMinute();

        datetimeString += (year + "-" + month + "-" + day);
        return datetimeString;
    }

    public static String convertDateDatabase(DateTime datetime) {
        String datetimeString = "";
        LocalDateTime ldt = datetime.toLocalDateTime();
        int day = ldt.getDayOfMonth();
        int month = ldt.getMonthOfYear();
        int year = ldt.getYear();

        int hour = ldt.getHourOfDay();
        int min = ldt.getMinuteOfHour();
        int sec = ldt.getSecondOfMinute();

        datetimeString += (year + "-" + month + "-" + day + " " + hour + ":" + min + ":" + sec);
        return datetimeString;
    }

    public static String convertDate(DateTime datetime) {
        String datetimeString = "";
        LocalDateTime ldt = datetime.toLocalDateTime();
        int day = ldt.getDayOfMonth();
        int month = ldt.getMonthOfYear();
        int year = ldt.getYear();

        int h = ldt.getHourOfDay();
        String hour = h + "";
        if (h < 10) {
            hour = 0 + hour;
        }

        int minute = ldt.getMinuteOfHour();
        String min = minute + "";
        if (minute < 10) {
            min = 0 + min;
        }

        datetimeString += (day + "/" + month + "/" + year + " " + hour + ":" + min);
        return datetimeString;
    }

    public static String convertDatePdf(DateTime datetime) {
        String datetimeString = "";
        LocalDateTime ldt = datetime.toLocalDateTime();
        int d = ldt.getDayOfMonth();
        int m = ldt.getMonthOfYear();
        int year = ldt.getYear();

        String day = d + "";
        if (d < 10) {
            day = 0 + day;
        }

        String month = m + "";
        if (m < 10) {
            month = 0 + month;
        }

        datetimeString = day + "/" + month + "/" + year;
        return datetimeString;
    }
    
    public static String convertDuplicates(String assigned){
        String result = "";
        String[] assignedArray = assigned.split("\\|");
        ArrayList<String> arraylist = new ArrayList<String>();
        for(int i=0; i<assignedArray.length; i++){
            String assignee = assignedArray[i];
            if(!arraylist.contains(assignee)){
                arraylist.add(assignee);
            }
        }
        
        for(int i=0; i<arraylist.size(); i++){
            String assignee = arraylist.get(i);
            result += assignee;
            if(i < arraylist.size()-1){
                result+="|";
            }
        }
        return result;    
    }
}
