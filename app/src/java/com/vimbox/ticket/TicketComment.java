package com.vimbox.ticket;

import org.joda.time.DateTime;

public class TicketComment {
    private int ticket_id;
    private String comment;
    private DateTime datetime;

    public TicketComment(int ticket_id, String comment, DateTime datetime) {
        this.ticket_id = ticket_id;
        this.comment = comment;
        this.datetime = datetime;
    }

    public int getTicket_id() {
        return ticket_id;
    }
    
    public String getComment() {
        return comment;
    }

    public DateTime getDatetime() {
        return datetime;
    }
}
