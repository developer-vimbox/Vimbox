package com.vimbox.util;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import org.joda.time.DateTime;
import org.joda.time.Days;
import org.joda.time.Hours;
import org.joda.time.LocalDateTime;
import org.joda.time.Minutes;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public class Converter {
    
    public static String convertDateHtml(DateTime datetime) {
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

    public static String convertDatePayslip(DateTime datetime) {
        String datetimeString = "";
        datetimeString += datetime.dayOfWeek().getAsText() + ", ";
        LocalDateTime ldt = datetime.toLocalDateTime();
        int day = ldt.getDayOfMonth();
        int year = ldt.getYear();

        datetimeString += (day + " " + datetime.toString("MMMM") + ", " + year);
        return datetimeString;
    }

    public static String convertYearMonthPayslip(DateTime datetime) {
        String datetimeString = "";
        LocalDateTime ldt = datetime.toLocalDateTime();
        int m = ldt.getMonthOfYear();
        int year = ldt.getYear();

        String month = m + "";
        if (m < 10) {
            month = 0 + month;
        }

        datetimeString += (year + "-" + month);
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
    
    public static String convertDateImg(DateTime datetime) {
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

        datetimeString = day + "" + month + "" + year;
        return datetimeString;
    }

    public static String convertDuplicates(String assigned) {
        String result = "";
        String[] assignedArray = assigned.split("\\|");
        ArrayList<String> arraylist = new ArrayList<String>();
        for (int i = 0; i < assignedArray.length; i++) {
            String assignee = assignedArray[i];
            if (!arraylist.contains(assignee)) {
                arraylist.add(assignee);
            }
        }

        for (int i = 0; i < arraylist.size(); i++) {
            String assignee = arraylist.get(i);
            result += assignee;
            if (i < arraylist.size() - 1) {
                result += "|";
            }
        }
        return result;
    }

    public static int getWorkingDaysBetweenTwoDates(Date startDate, Date endDate, int working_days) {
        Calendar startCal;
        Calendar endCal;
        startCal = Calendar.getInstance();
        startCal.setTime(startDate);
        endCal = Calendar.getInstance();
        endCal.setTime(endDate);
        int workDays = 1;

        //Return 0 if start and end are the same
        if (startCal.getTimeInMillis() == endCal.getTimeInMillis()) {
            return workDays;
        }

        if (startCal.getTimeInMillis() > endCal.getTimeInMillis()) {
            startCal.setTime(endDate);
            endCal.setTime(startDate);
        }

        do {
            startCal.add(Calendar.DAY_OF_MONTH, 1);
            if (working_days == 6) {
                if (startCal.get(Calendar.DAY_OF_WEEK) != Calendar.SATURDAY) {
                    ++workDays;
                }
            } else {
                if (startCal.get(Calendar.DAY_OF_WEEK) != Calendar.SATURDAY
                        && startCal.get(Calendar.DAY_OF_WEEK) != Calendar.SUNDAY) {
                    ++workDays;
                }
            }
        } while (startCal.getTimeInMillis() < endCal.getTimeInMillis());

        return workDays;
    }

    public static int getTotalDaysBetweenTwoDates(Date startDate, Date endDate) {
        Calendar startCal;
        Calendar endCal;
        startCal = Calendar.getInstance();
        startCal.setTime(startDate);
        endCal = Calendar.getInstance();
        endCal.setTime(endDate);
        int days = 1;

        //Return 0 if start and end are the same
        if (startCal.getTimeInMillis() == endCal.getTimeInMillis()) {
            return days;
        }

        if (startCal.getTimeInMillis() > endCal.getTimeInMillis()) {
            startCal.setTime(endDate);
            endCal.setTime(startDate);
        }

        do {
            startCal.add(Calendar.DAY_OF_MONTH, 1);
            ++days;
        } while (startCal.getTimeInMillis() < endCal.getTimeInMillis());
        return days;
    }

    public static HashMap<Date, Double> getLeaveHoursBetweenTwoDateTimes(DateTime startDate, DateTime endDate, int workingDays) throws Exception {
        HashMap<Date, Double> toReturn = new HashMap<Date, Double>();
        int days = Days.daysBetween(startDate, endDate).getDays();
        int hours = Hours.hoursBetween(startDate, endDate).getHours() % 24;
        int minute = Minutes.minutesBetween(startDate, endDate).getMinutes() % 60;
        LocalDateTime sd = startDate.toLocalDateTime();
        LocalDateTime ed = endDate.toLocalDateTime();

        if (minute > 0) {
            throw new Exception("Please enter hourly timings<br>");
        }

        int sInt = sd.getHourOfDay() * 100 + sd.getMinuteOfHour();
        int eInt = ed.getHourOfDay() * 100 + ed.getMinuteOfHour();
        double sDouble, eDouble;
        if (workingDays == 5) {
            sDouble = 9.0;
            eDouble = 18.0;
            if (sInt < 900 || sInt > 1800) {
                throw new Exception("Please enter a start time within 0900 and 1800<br>");
            } else if (eInt < 900 || eInt > 1800) {
                throw new Exception("Please enter an end time within 0900 and 1800<br>");
            }
        } else {
            sDouble = 8.0;
            eDouble = 17.0;
            if (sInt < 830 || sInt > 1730) {
                throw new Exception("Please enter a start time within 0830 and 1730<br>");
            } else if (eInt < 830 || eInt > 1730) {
                throw new Exception("Please enter an end time within 0830 and 1730<br>");
            }
        }

        
        if ((days * 24 + hours) < 9) {
            toReturn.put(startDate.toDate(), (double)(ed.getHourOfDay() - sd.getHourOfDay()));
        } else {
            // Settle first day //
            toReturn.put(startDate.toDate(), eDouble - sd.getHourOfDay());
            sd = sd.plusDays(1);

            // Settle days //
            if (sd.getHourOfDay() <= ed.getHourOfDay()) {
                days -= 1;
            }
            for (int i = 0; i < days; i++) {
                toReturn.put(sd.toDate(), 9.0);
                sd = sd.plusDays(1);
            }

            // Settle last day //
            if (ed.getHourOfDay() - sDouble > 0) {
                toReturn.put(sd.toDate(), ed.getHourOfDay() - sDouble);
            }
        }
        return toReturn;
    }
    
    public static HashMap<Date, String> getLeaveStringsBetweenTwoDateTimes(DateTime startDate, DateTime endDate, int workingDays) {
        HashMap<Date, String> toReturn = new HashMap<Date, String>();
        int days = Days.daysBetween(startDate, endDate).getDays();
        int hours = Hours.hoursBetween(startDate, endDate).getHours() % 24;
        int minute = Minutes.minutesBetween(startDate, endDate).getMinutes() % 60;
        LocalDateTime sd = startDate.toLocalDateTime();
        LocalDateTime ed = endDate.toLocalDateTime();

        int sInt = sd.getHourOfDay() * 100 + sd.getMinuteOfHour();
        int eInt = ed.getHourOfDay() * 100 + ed.getMinuteOfHour();
        
        String startTime, endTime;
        double sDouble;
        if (workingDays == 5) {
            sDouble = 9.0;
            startTime = "0900";
            endTime = "1800";
        } else {
            sDouble = 8.0;
            startTime = "0830";
            endTime = "1730";
        }

        String sTime = "";
        if(sd.getHourOfDay() < 10){
            sTime += "0" + sd.getHourOfDay();
        }else{
            sTime += sd.getHourOfDay();
        }
        if(sd.getMinuteOfHour() < 10){
            sTime += "0" + sd.getMinuteOfHour();
        }else{
            sTime += sd.getMinuteOfHour();
        }
        
        String eTime = "";
        if(ed.getHourOfDay() < 10){
            eTime += "0" + ed.getHourOfDay();
        }else{
            eTime += ed.getHourOfDay();
        }
        if(ed.getMinuteOfHour() < 10){
            eTime += "0" + ed.getMinuteOfHour();
        }else{
            eTime += ed.getMinuteOfHour();
        }
        
        if ((days * 24 + hours) < 9) {
            toReturn.put(startDate.toDate(), sTime + " - " + eTime);
        } else {
            // Settle first day //
            toReturn.put(startDate.toDate(), sTime + " - " + endTime);
            sd = sd.plusDays(1);

            // Settle days //
            if (sd.getHourOfDay() <= ed.getHourOfDay()) {
                days -= 1;
            }
            for (int i = 0; i < days; i++) {
                toReturn.put(sd.toDate(), startTime + " - " + endTime);
                sd = sd.plusDays(1);
            }

            // Settle last day //
            if (ed.getHourOfDay() - sDouble > 0) {
                toReturn.put(sd.toDate(), startTime + " - " + eTime);
            }
        }
        return toReturn;
    }
    
    public static String convertDateQuotationPdf(DateTime datetime) {
        DateTimeFormatter fmt = DateTimeFormat.forPattern("dd MMMM yyyy");
        String str = fmt.print(datetime);
        return str;
    }
}
