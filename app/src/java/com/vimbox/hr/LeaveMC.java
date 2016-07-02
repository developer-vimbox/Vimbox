package com.vimbox.hr;

import org.joda.time.DateTime;

public class LeaveMC {
    private String leaveType;
    private String leaveName;
    private double leaveDuration;
    private DateTime date;
    private String timeString;
    private String imgPath;

    public LeaveMC(String leaveType, String leaveName, double leaveDuration, DateTime date, String timeString, String imgPath) {
        this.leaveType = leaveType;
        this.leaveName = leaveName;
        this.leaveDuration = leaveDuration;
        this.date = date;
        this.timeString = timeString;
        this.imgPath = imgPath;
    }

    public String getLeaveType() {
        return leaveType;
    }

    public String getLeaveName() {
        return leaveName;
    }

    public double getLeaveDuration() {
        return leaveDuration;
    }

    public DateTime getDate() {
        return date;
    }

    public String getTimeString() {
        return timeString;
    }

    public String getImgPath() {
        return imgPath;
    }
}
