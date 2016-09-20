<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.vimbox.database.LeadDAO"%>
<%@page import="java.util.Date"%>
<%@include file="ValidateLogin.jsp"%> 
<%@page import="com.vimbox.sitesurvey.SiteSurvey"%>
<%@page import="com.vimbox.database.SiteSurveyDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<style>


    body, html {
        height: 100%;
    }

    body {
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        font-family: "fira-sans-2", Verdana, sans-serif;
    }

    #q-graph {
        display: block; /* fixes layout wonkiness in FF1.5 */
        position: relative; 
        width: 600px; 
        height: 300px;
        margin: 1.1em 0 0; 
        padding: 0;
        background: transparent;
        font-size: 11px;
    }

    #q-graph caption {
        caption-side: top; 
        width: 600px;
        text-transform: uppercase;
        letter-spacing: .5px;
        top: -40px;
        position: relative; 
        z-index: 10;
        font-weight: bold;
    }

    #q-graph tr, #q-graph th, #q-graph td { 
        position: absolute;
        bottom: 0; 
        width: 150px; 
        z-index: 2;
        margin: 0; 
        padding: 0;
        text-align: center;
    }

    #q-graph td {
        transition: all .3s ease;

        &:hover {
            background-color: desaturate(#85144b, 100);
            opacity: .9;
            color: white;
        }
    }

    #q-graph thead tr {
        left: 100%; 
        top: 50%; 
        bottom: auto;
        margin: -2.5em 0 0 5em;}
    #q-graph thead th {
        width: 7.5em; 
        height: auto; 
        padding: 0.5em 1em;
    }
    #q-graph thead th.sent {
        top: 0; 
        left: 0; 
        line-height: 2;
    }
    #q-graph thead th.paid {
        top: 2.75em; 
        line-height: 2;
        left: 0; 
    }

    #q-graph tbody tr {
        height: 296px;
        padding-top: 2px;
        border-right: 1px dotted #C4C4C4; 
        color: #AAA;
    }
    #q-graph #Mon {
        left: 0;
    }
    #q-graph #Tues {left: 150px;}
    #q-graph #Weds {left: 300px;}
    #q-graph #Thurs {left: 450px; }
    #q-graph #Fri {left: 600px; }
    #q-graph #Sat {left: 750px;}
    #q-graph #Sun{left: 900px; border-right: none;}
    #q-graph tbody th {bottom: -1.75em; vertical-align: top;
                       font-weight: normal; color: #333;}
    #q-graph .bar {
        width: 60px; 
        border: 1px solid; 
        border-bottom: none; 
        color: #000;
    }
    #q-graph .bar p {
        margin: 5px 0 0; 
        padding: 0;
        opacity: .4;
    }
    #q-graph .sent {
        left: 40px; 
        background-color: #39cccc;
        border-color: transparent;
    }
    #q-graph .paid {
        left: 77px; 
        background-color: #7fdbff;
        border-color: transparent;
    }


    #ticks {
        position: relative; 
        top: -300px; 
        left: 2px;
        width: 1000px; 
        height: 300px; 
        z-index: 1;
        margin-bottom: -300px;
        font-size: 10px;
        font-family: "fira-sans-2", Verdana, sans-serif;
    }

    #ticks .tick {
        position: relative; 
        border-bottom: 1px dotted #C4C4C4; 
        width: 1000px;
    }

    #ticks .tick p {
        position: absolute; 
        left: -5em; 
        top: -0.8em; 
        margin: 0 0 0 0.5em;
    }
</style>
<%   String date = request.getParameter("seldate");
//    DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//    Date startDate = (Date)df.parse(date);
//    Calendar cal = Calendar.getInstance();
//    cal.setTime(startDate);
//    int month = cal.get(Calendar.MONTH); //0-> Jan, 1-> Feb..
//    int day = cal.get(Calendar.DAY_OF_WEEK); //1 -> Sun, 2-> Mon
//
//    Date actual = new Date();
//    if (day != 2) {
//        switch (day) {
//            case '3':
//                cal = Calendar.getInstance();
//                cal.setTime(startDate);
//                cal.add(Calendar.DATE, -1);
//                actual = cal.getTime();
//                break;
//            case '4':
//                cal = Calendar.getInstance();
//                cal.setTime(startDate);
//                cal.add(Calendar.DATE, -2);
//                actual = cal.getTime();
//                break;
//            case '5':
//                cal = Calendar.getInstance();
//                cal.setTime(startDate);
//                cal.add(Calendar.DATE, -3);
//                actual = cal.getTime();
//                break;
//            case '6':
//                cal = Calendar.getInstance();
//                cal.setTime(startDate);
//                cal.add(Calendar.DATE, -4);
//                actual = cal.getTime();
//                break;
//            case '7':
//                cal = Calendar.getInstance();
//                cal.setTime(startDate);
//                cal.add(Calendar.DATE, -5);
//                actual = cal.getTime();
//                break;
//            case '8':
//                cal = Calendar.getInstance();
//                cal.setTime(startDate);
//                cal.add(Calendar.DATE, -6);
//                actual = cal.getTime();
//                break;
//        }
//    }
//    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//    String currentTime = sdf.format(startDate);
    ArrayList<String[]> weekLeadConfirmation = LeadDAO.getWeekLeadConfirmation(date);
    int[] sales = new int[7];
    int mon = 0;
    int tues = 0;
    int weds = 0;
    int thurs = 0;
    int fri = 0;
    int sat = 0;
    int sun = 0;
    double total = 0;
    DecimalFormat df = new DecimalFormat("##.00");
    for (String[] rec : weekLeadConfirmation) {
        String leadId = rec[0];
        double totalAmt = Double.parseDouble(rec[1]);
        total+= totalAmt;
        String nameOfDay = rec[2];
        switch (nameOfDay) {
            case "Monday":
                mon++;
                break;
            case "Tuesday":
                tues++;
                break;
            case "Wednesday":
                weds++;
                break;
            case "Thursday":
                thurs++;
                break;
            case "Friday":
                fri++;
                break;
            case "Saturday":
                sat++;
                break;
            case "Sunday":
                sun++;
                break;
        }

    }
%>
<span style="margin-left: 62%;font-size: 15px;" class="bs-label label-primary">Total sales of the Week: $ <%=df.format(total)%></span>

<table id="q-graph" style="
       margin-left: 10%;
       ">
    <caption style="
             text-align: center;
             margin-left: 23%;
             ">No. Of Sales</caption>
    <thead>
        <tr>
            <th></th>
            <!--            <th class="sent">Invoiced</th>
                        <th class="paid">Collected</th>-->
        </tr>
    </thead>
    <tbody>
        <%
            int tempMon = 0;
            if (mon > 0) {
                tempMon = mon + 10;
            }
            int tempTues = 0;
            if (tues > 0) {
                tempTues = tues + 10;
            }
            int tempWeds = 0;
            if (weds > 0) {
                tempWeds = weds + 10;
            }
            int tempThurs = 0;
            if (thurs > 0) {
                tempThurs = thurs + 10;
            }
            int tempFri = 0;
            if (fri > 0) {
                tempFri = fri + 10;
            }
            int tempSat = 0;
            if (sat > 0) {
                tempSat = sat + 10;
            }
            int tempSun = 0;
            if (sun > 0) {
                tempSun = sun + 10;
            }
        %>
        <tr class="qtr" id="Mon" style="margin-bottom: 1%;">
            <th scope="row">Monday</th>
            <td class="sent bar" style="height:<%=tempMon%>px;"><p><%=mon%></p></td>
        </tr>
        <tr class="qtr" id="Tues" style="margin-bottom: 1%;">
            <th scope="row">Tuesday</th>
            <td class="sent bar" style="height: <%=tempTues%>px;"><p><%=tues%></p></td>
        </tr>
        <tr class="qtr" id="Weds" style="margin-bottom: 1%;">
            <th scope="row">Wednesday</th>
            <td class="sent bar" style="height: <%=tempWeds%>px;"><p><%=weds%></p></td>
        </tr>
        <tr class="qtr" id="Thurs" style="margin-bottom: 1%;">
            <th scope="row">Thursday</th>
            <td class="sent bar" style="height: <%=tempThurs%>px;"><p><%=thurs%></p></td>
        </tr>
        <tr class="qtr" id="Fri" style="margin-bottom: 1%;">
            <th scope="row">Friday</th>
            <td class="sent bar" style="height: <%=tempFri%>px;"><p><%=fri%></p></td>
        </tr>
        <tr class="qtr" id="Sat" style="margin-bottom: 1%;">
            <th scope="row">Saturday</th>
            <td class="sent bar" style="height: <%=tempSat%>px;"><p><%=sat%></p></td>
        </tr>
        <tr class="qtr" id="Sun" style="margin-bottom: 1%;">
            <th scope="row">Sunday</th>
            <td class="sent bar" style="height: <%=tempSun%>px;"><p><%=sun%></p></td>
        </tr>
    </tbody>
</table>

<div id="ticks" style="margin-left: 10%;">
    <div class="tick" style="height: 59px;"><p>450</p></div>
    <div class="tick" style="height: 59px;"><p>350</p></div>
    <div class="tick" style="height: 59px;"><p>250</p></div>
    <div class="tick" style="height: 59px;"><p>150</p></div>
    <div class="tick" style="height: 59px;"><p>50</p></div>
</div>