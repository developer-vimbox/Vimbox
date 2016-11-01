package com.vimbox.admin;

public class Notification {
    private String message;
    private String status;
    private String html;

    public Notification(String message, String status, String html) {
        this.message = message;
        this.status = status;
        this.html = html;
    }

    public String getMessage() {
        return message;
    }

    public String getStatus() {
        return status;
    }
    
    public String getHtml(){
        return html;
    }
}
