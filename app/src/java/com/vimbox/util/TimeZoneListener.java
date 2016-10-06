package com.vimbox.util;

import java.util.TimeZone;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import org.joda.time.DateTimeZone;

public class TimeZoneListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        TimeZone.setDefault(TimeZone.getTimeZone("Asia/Kuala_Lumpur"));
        DateTimeZone.setDefault(DateTimeZone.forTimeZone(TimeZone.getTimeZone("Asia/Kuala_Lumpur")));
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }
}
