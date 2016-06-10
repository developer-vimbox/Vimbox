package com.vimbox.ticket;

import org.joda.time.DateTime;

public class TicketComment {
    private String ticketId;
    private String comment;
    private DateTime datetime;

    public TicketComment(String ticketId, String comment, DateTime datetime) {
        this.ticketId = ticketId;
        this.comment = comment;
        this.datetime = datetime;
    }

    public String getTicketId() {
        return ticketId;
    }

    public String getComment() {
        return comment;
    }

    public DateTime getDatetime() {
        return datetime;
    }
}
