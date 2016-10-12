package com.vimbox.admin;

public class Notification {
    private String message;
    private String status;

    public Notification(String message, String status) {
        this.message = message;
        this.status = status;
    }

    public String getMessage() {
        return message;
    }

    public String getStatus() {
        return status;
    }
}
