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
        /*border-right: 1px dotted #C4C4C4;*/ 
        color: #AAA;
    }
    #q-graph #jan {
        left: 0;
    }
    #q-graph #feb {left: 80px;}
    #q-graph #mar {left: 160px;}
    #q-graph #apr {left: 240px; }
    #q-graph #may {left: 320px; }
    #q-graph #jun {left: 400px;}
    #q-graph #jul{left: 480px;}
    #q-graph #aug {left: 560px;}
    #q-graph #sep{left: 640px; }
    #q-graph #oct {left: 720px;}
    #q-graph #nov{left: 800px; }
    #q-graph #dec{left: 880px; border-right: none;}
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
<%   String year = request.getParameter("year");

//    ArrayList<String[]> yearLeadConfirmation = LeadDAO.getYearLeadConfirmation(year);
    ArrayList<String[]> yearLeadConfirmation = LeadDAO.getMonthLeadConfirmation();
   
    int jan = 0;
    int feb = 0;
    int mar = 0;
    int apr = 0;
    int may = 0;
    int june = 0;
    int jul = 0;
    int aug = 0;
    int sep = 0;
    int oct = 0;
    int nov = 0;
    int dec = 0;
    double total = 0;
    double jantotal = 0;
    double febtotal = 0;
    double martotal = 0;
    double aprtotal = 0;
    double maytotal = 0;
    double juntotal = 0;
    double jultotal = 0;
    double augtotal = 0;
    double septotal = 0;
    double octtotal = 0;
    double novtotal = 0;
    double dectotal = 0;
    DecimalFormat df = new DecimalFormat("##.00");
    for (String[] rec : yearLeadConfirmation) {
        String leadId = rec[0];
        double totalAmt = Double.parseDouble(rec[1]);
        total += totalAmt;
        String mthName = rec[2];
        switch (mthName) {
            case "January":
                jan++;
                jantotal += totalAmt;
                break;
            case "February":
                feb++;
                febtotal += totalAmt;
                break;
            case "March":
                mar++;
                martotal += totalAmt;
                break;
            case "April":
                apr++;
                aprtotal += totalAmt;
                break;
            case "May":
                may++;
                maytotal += totalAmt;
                break;
            case "June":
                juntotal += totalAmt;
                break;
            case "July":
                jul++;
                jultotal += totalAmt;
                break;
            case "August":
                aug++;
                augtotal += totalAmt;
                break;
            case "September":
                sep++;
                septotal += totalAmt;
                break;
            case "October":
                oct++;
                octtotal += totalAmt;
                break;
            case "November":
                nov++;
                novtotal += totalAmt;
                break;
            case "December":
                dec++;
                dectotal += totalAmt;
                break;
        }

    }
%>
<table>
    <tr>
    <span style="margin-left: 70%;font-size: 15px;" class="bs-label label-primary">Total sales $ <%=df.format(total)%></span></tr>
</table>

<table id="q-graph" style="
       margin-left: 10%;
       margin-top: 5%;
       padding-bottom: 5%;
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
            int tempJan = 0;
            if (jan > 0) {
                tempJan = jan + 10;
            }
            int tempFeb = 0;
            if (feb > 0) {
                tempFeb = feb + 10;
            }
            int tempMar = 0;
            if (mar > 0) {
                tempMar = mar + 10;
            }
            int tempApr = 0;
            if (apr > 0) {
                tempApr = apr + 10;
            }
            int tempMay = 0;
            if (may > 0) {
                tempMay = may + 10;
            }
            int tempJun = 0;
            if (june > 0) {
                tempJun = june + 10;
            }
            int tempJul = 0;
            if (jul > 0) {
                tempJul = jul + 10;
            }
            int tempAug = 0;
            if (aug > 0) {
                tempAug = aug + 10;
            }
            int tempSep = 0;
            if (sep > 0) {
                tempSep = sep + 10;
            }
            int tempOct = 0;
            if (oct > 0) {
                tempOct = oct + 10;
            }
            int tempNov = 0;
            if (nov > 0) {
                tempNov = nov + 10;
            }
            int tempDec = 0;
            if (jul > 0) {
                tempDec = nov + 10;
            }
        %>
        <tr class="qtr" id="jan" style="margin-bottom: 1%;">
            <th scope="row">January</th>
            <td class="sent bar" style="height:<%=tempJan%>px;"><p><%=jan%></p></td>
        </tr>
        <tr class="qtr" id="feb" style="margin-bottom: 1%;">
            <th scope="row">February</th>
            <td class="sent bar" style="height: <%=tempFeb%>px;"><p><%=feb%></p></td>
        </tr>
        <tr class="qtr" id="mar" style="margin-bottom: 1%;">
            <th scope="row">March</th>
            <td class="sent bar" style="height: <%=tempMar%>px;"><p><%=mar%></p></td>
        </tr>
        <tr class="qtr" id="apr" style="margin-bottom: 1%;">
            <th scope="row">April</th>
            <td class="sent bar" style="height: <%=tempApr%>px;"><p><%=apr%></p></td>
        </tr>
        <tr class="qtr" id="may" style="margin-bottom: 1%;">
            <th scope="row">May</th>
            <td class="sent bar" style="height: <%=tempMay%>px;"><p><%=may%></p></td>
        </tr>
        <tr class="qtr" id="jun" style="margin-bottom: 1%;">
            <th scope="row">June</th>
            <td class="sent bar" style="height: <%=tempJun%>px;"><p><%=june%></p></td>
        </tr>
        <tr class="qtr" id="jul" style="margin-bottom: 1%;">
            <th scope="row">July</th>
            <td class="sent bar" style="height: <%=tempJul%>px;"><p><%=jul%></p></td>
        </tr>
        <tr class="qtr" id="aug" style="margin-bottom: 1%;">
            <th scope="row">August</th>
            <td class="sent bar" style="height: <%=tempAug%>px;"><p><%=aug%></p></td>
        </tr>
        <tr class="qtr" id="sep" style="margin-bottom: 1%;">
            <th scope="row">September</th>
            <td class="sent bar" style="height: <%=tempSep%>px;"><p><%=sep%></p></td>
        </tr>
        <tr class="qtr" id="oct" style="margin-bottom: 1%;">
            <th scope="row">October</th>
            <td class="sent bar" style="height: <%=tempOct%>px;"><p><%=oct%></p></td>
        </tr>
        <tr class="qtr" id="nov" style="margin-bottom: 1%;">
            <th scope="row">November</th>
            <td class="sent bar" style="height: <%=tempNov%>px;"><p><%=nov%></p></td>
        </tr>
        <tr class="qtr" id="dec" style="margin-bottom: 1%;">
            <th scope="row">December</th>
            <td class="sent bar" style="height: <%=tempDec%>px;"><p><%=dec%></p></td>
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
        
<table id="q-graph" style="
       margin-left: 10%;
       margin-top: 5%;
       padding-bottom: 5%;
       ">
    <caption style="
             text-align: center;
             margin-left: 23%;
             ">Total Amount($). Of Sales</caption>
    <thead>
        <tr>
            <th></th>
            <!--            <th class="sent">Invoiced</th>
                        <th class="paid">Collected</th>-->
        </tr>
    </thead>
    <tbody>
        <tr class="qtr" id="jan" style="margin-bottom: 1%;">
            <th scope="row">January</th>
            <td class="sent bar" style="height:<%=tempJan%>px;"><p>$<%=df.format(jantotal)%></p></td>
        </tr>
        <tr class="qtr" id="feb" style="margin-bottom: 1%;">
            <th scope="row">February</th>
            <td class="sent bar" style="height: <%=tempFeb%>px;"><p>$<%=df.format(febtotal)%></p></td>
        </tr>
        <tr class="qtr" id="mar" style="margin-bottom: 1%;">
            <th scope="row">March</th>
            <td class="sent bar" style="height: <%=tempMar%>px;"><p>$<%=df.format(martotal)%></p></td>
        </tr>
        <tr class="qtr" id="apr" style="margin-bottom: 1%;">
            <th scope="row">April</th>
            <td class="sent bar" style="height: <%=tempApr%>px;"><p>$<%=df.format(aprtotal)%></p></td>
        </tr>
        <tr class="qtr" id="may" style="margin-bottom: 1%;">
            <th scope="row">May</th>
            <td class="sent bar" style="height: <%=tempMay%>px;"><p>$<%=df.format(maytotal)%></p></td>
        </tr>
        <tr class="qtr" id="jun" style="margin-bottom: 1%;">
            <th scope="row">June</th>
            <td class="sent bar" style="height: <%=tempJun%>px;"><p>$<%=df.format(juntotal)%></p></td>
        </tr>
        <tr class="qtr" id="jul" style="margin-bottom: 1%;">
            <th scope="row">July</th>
            <td class="sent bar" style="height: <%=tempJul%>px;"><p>$<%=df.format(jultotal)%></p></td>
        </tr>
        <tr class="qtr" id="aug" style="margin-bottom: 1%;">
            <th scope="row">August</th>
            <td class="sent bar" style="height: <%=tempAug%>px;"><p>$<%=df.format(augtotal)%></p></td>
        </tr>
        <tr class="qtr" id="sep" style="margin-bottom: 1%;">
            <th scope="row">September</th>
            <td class="sent bar" style="height: <%=tempSep%>px;"><p>$<%=df.format(septotal)%></p></td>
        </tr>
        <tr class="qtr" id="oct" style="margin-bottom: 1%;">
            <th scope="row">October</th>
            <td class="sent bar" style="height: <%=tempOct%>px;"><p>$<%=df.format(octtotal)%></p></td>
        </tr>
        <tr class="qtr" id="nov" style="margin-bottom: 1%;">
            <th scope="row">November</th>
            <td class="sent bar" style="height: <%=tempNov%>px;"><p>$<%=df.format(novtotal)%></p></td>
        </tr>
        <tr class="qtr" id="dec" style="margin-bottom: 1%;">
            <th scope="row">December</th>
            <td class="sent bar" style="height: <%=tempDec%>px;"><p>$<%=df.format(dectotal)%></p></td>
        </tr>
    </tbody>
</table>

<div id="ticks" style="margin-left: 10%;">
    <div class="tick" style="height: 59px;"><p>10000</p></div>
    <div class="tick" style="height: 59px;"><p>8000</p></div>
    <div class="tick" style="height: 59px;"><p>6000</p></div>
    <div class="tick" style="height: 59px;"><p>4000</p></div>
    <div class="tick" style="height: 59px;"><p>2000</p></div>
</div>