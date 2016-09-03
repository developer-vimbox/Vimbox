<%@page import="com.vimbox.sales.LeadArea"%>
<%@page import="com.vimbox.user.User"%>
<%@page import="com.vimbox.database.SiteSurveyDAO"%>
<%@page import="com.vimbox.operations.Job"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.vimbox.sitesurvey.SiteSurvey"%>
<%@page import="com.vimbox.sales.LeadDiv"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.vimbox.sales.Item"%>
<%@page import="com.vimbox.customer.Customer"%>
<%@page import="com.vimbox.sales.Lead"%>
<%@page import="com.vimbox.database.LeadDAO"%>
<%@page import="com.vimbox.util.Converter"%>
<%@page import="java.util.ArrayList"%>
<%
    String leadId = request.getParameter("getLid");
    String startTime = request.getParameter("getStartTime");
    String timeSlot = request.getParameter("getTimeSlot");
    SiteSurvey siteSurvey = SiteSurveyDAO.getSiteSurveysByLeadIdStartDateTimeslot(Integer.parseInt(leadId), startTime, timeSlot);
    Lead lead = LeadDAO.getLeadById(Integer.parseInt(leadId));
    DecimalFormat df = new DecimalFormat("#,##0.00");
    if (siteSurvey != null) {
%>

<center><h2>Survey Details</h2></center>
<hr>
<div class="form-horizontal" style="font-size: 14px;">
    <div class="form-group">
        <div class="col-sm-6">
            <h3 class="mrg10A">Customer Information </h3>
        </div>
        <div class="col-sm-5">
            <h3 class="mrg10A"></h3>
        </div>
    </div>
    <%
        Customer customer = lead.getCustomer();
        if (customer != null) {%>
    <div class="form-group">
        <label class ="col-sm-3 control-label">Name: </label>
        <div class ="col-sm-8" style="padding-top: 7px;">
            <%=customer.toString()%>
        </div>
    </div>
    <div class="form-group">
        <label class ="col-sm-3 control-label">Contact: </label>
        <div class ="col-sm-8" style="padding-top: 7px;">
            <%=customer.getContact()%>
        </div>

    </div>
    <div class="form-group">
        <label class ="col-sm-3 control-label">Email: </label>
        <div class ="col-sm-8" style="padding-top: 7px;">
            <%=customer.getEmail()%>
        </div>

    </div>
    <%}%>
</div>
<hr>
<div class="form-horizontal" style="font-size: 14px;">
    <div class="form-group">
        <div class="col-sm-6">
            <h4 class="mrg10A">Site Survey Details</h4>
        </div>
    </div>
    <%
        ArrayList<SiteSurvey> surveys = lead.getSiteSurveys();
        String ss = "";
        String sId = "";
        String sName = "";
        String sRem = "";
        String sTimeslot = "";
        String sAddresses = siteSurvey.getAddress();
        String[] addresses = sAddresses.split("\\|");

        String s = siteSurvey.getDate();

        sId = siteSurvey.getSiteSurveyor().getNric();
        sName = siteSurvey.getSiteSurveyor().toString();
        sRem = siteSurvey.getRemarks();
        sTimeslot = siteSurvey.getTimeSlots();


    %>
    <div class="form-group">
        <label class ="col-sm-3 control-label">Date: </label>
        <div class ="col-sm-8" style="padding-top: 7px;">
            <%=s%>
        </div>
    </div>
    <div class="form-group">
        <label class ="col-sm-3 control-label">Timeslot: </label>
        <div class ="col-sm-8" style="padding-top: 7px;">
            <%=sTimeslot%>
        </div>
    </div>
    <div class="form-group">
        <label class ="col-sm-3 control-label">Location: </label>
        <div class ="col-sm-8" style="padding-top: 7px;">
            <%
                for (int j = 0; j < addresses.length; j++) {
                    out.println("<li>");
                    out.println("Address " + (j + 1) + " : " + addresses[j]);
                    out.println("</li>");
                }
            %>
        </div>
    </div>
    <div class="form-group">
        <label class ="col-sm-3 control-label">Surveyor: </label>
        <div class ="col-sm-8" style="padding-top: 7px;">
            <%=sName%>
        </div>
    </div>
    <div class="form-group">
        <label class ="col-sm-3 control-label">Remarks: </label>
        <div class ="col-sm-8" style="padding-top: 7px;">
            <%=sRem%>
        </div>
    </div>


</div>

<table width='100%'>
    <hr>
    <div class="form-horizontal" style="font-size: 14px;">
        <div class="form-group">
            <div class="col-sm-6">
                <h3 class="mrg10A">Sales Information</h3>
            </div>
        </div>
    </div>

    <hr>
    <div class="form-horizontal" style="font-size: 14px;">
        <div class="form-group">
            <div class="col-sm-6">
                <h4 class="mrg10A">Sales Details</h4>
            </div>
        </div>
    </div>
    <table width='100%'>
        <tr>
            <td colspan="2">
                <fieldset>
                    <table width="100%">
                        <tr>
                            <td>
                                <%
                                    ArrayList<LeadDiv> leadDivs = lead.getSalesDivs();
                                    out.println(" <ul class='nav-responsive nav nav-tabs'>");
                                    for (LeadDiv leadDiv : leadDivs) {
                                        String leadDivStr = leadDiv.getSalesDiv();
                                        String leadDivId = leadDivStr.substring(0, leadDivStr.indexOf("|"));
                                        String leadDivAddr = leadDivStr.substring(leadDivStr.indexOf("|") + 1);
                                        for (String add : addresses) {
                                            if (add.trim().equals(leadDivAddr.trim())) {
                                                out.println("<li><a data-toggle='tab' href='#' class='tablinks' onclick=\"openSurvey(event, '" + leadDivId + "')\"><label>" + leadDivAddr + "</label></a></li>");

                                            }
                                        }
                                    }
                                    out.println("</ul>");
                                %>

                                <%
                                    double overall = 0;
                                    for (LeadDiv leadDiv : leadDivs) {
                                        String leadDivStr = leadDiv.getSalesDiv();
                                        String leadDivId = leadDivStr.substring(0, leadDivStr.indexOf("|"));
                                        ArrayList<LeadArea> surveyArea = leadDiv.getLeadAreas();
                                        double sum = 0;
                                        ArrayList<Item> customerItems = leadDiv.getCustomerItems();
                                %>
                                <div id="<%=leadDivId%>" class="tabcontent">
                                    <table width="100%"  bordercolor="#ddd" border="1px;">
                                        <tr height="95%">
                                            <td style="width:60%">
                                                <table width="100%" border="1" style="height:500px"  bordercolor="#ddd">
                                                    <tr style="background-color:#F5BCA9" height="10%">
                                                        <td align="center"><b><u>Customer Item List</u></b></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <div style="overflow:auto;height:100%;">
                                                                <table style="width:100%;">
                                                                    <col width="30%">
                                                                    <col width="40%">
                                                                    <col width="10%">
                                                                    <col width="10%">
                                                                    <col width="10%">
                                                                    <%
                                                                        if (surveyArea != null && surveyArea.size() > 0) {
                                                                            for (LeadArea leadarea : surveyArea) {
                                                                                String leadname = leadarea.getLeadName();%>
                                                                    <tr>
                                                                        <th colspan="5"><center><b><%=leadname%></b></center></th>
                                                                    </tr>
                                                                    <tr>
                                                                        <th>Item</th>
                                                                        <th>Remarks</th>
                                                                        <th>Charges</th>
                                                                        <th>Qty</th>
                                                                        <th>Units</th>
                                                                    </tr> 
                                                                    <%
                                                                        ArrayList<Item> areaCustItems = leadarea.getCustomerItems();
                                                                        for (Item item : areaCustItems) {
                                                                            String tr = "<tr><td>" + item.getName() + "</td>";
                                                                            tr += "<td>" + item.getRemark() + "</td>";
                                                                            if (item.getCharges() > 0) {
                                                                                tr += "<td align='center'>" + item.getCharges() + "</td>";
                                                                            } else {
                                                                                tr += "<td align='center'>&nbsp;&nbsp;&nbsp;&nbsp;</td>";
                                                                            }

                                                                            tr += "<td align='center'>" + item.getQty() + "</td>";
                                                                            tr += "<td align='center'>" + item.getUnits() + "</td>";
                                                                            out.println(tr);
                                                                        }
                                                                    %>
                                                                    <%}
                                                                    } else {%>
                                                                    <tr>
                                                                        <th>Item</th>
                                                                        <th>Remarks</th>
                                                                        <th>Charges</th>
                                                                        <th>Qty</th>
                                                                        <th>Units</th>
                                                                    </tr> 
                                                                    <%
                                                                            for (Item item : customerItems) {
                                                                                String tr = "<tr><td>" + item.getName() + "</td>";
                                                                                tr += "<td>" + item.getRemark() + "</td>";
                                                                                if (item.getCharges() > 0) {
                                                                                    tr += "<td align='center'>" + item.getCharges() + "</td>";
                                                                                } else {
                                                                                    tr += "<td align='center'>&nbsp;&nbsp;&nbsp;&nbsp;</td>";
                                                                                }

                                                                                tr += "<td align='center'>" + item.getQty() + "</td>";
                                                                                tr += "<td align='center'>" + item.getUnits() + "</td>";
                                                                                out.println(tr);
                                                                            }
                                                                        }
                                                                    %>

                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr style="background-color:#CEE3F6" height="10%">
                                                        <td align="center"><b><u>Vimbox Item List</u></b></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <div style="overflow:auto;height:100%;">
                                                                <table style="width:100%;">
                                                                    <col width="30%">
                                                                    <col width="40%">
                                                                    <col width="10%">
                                                                    <col width="10%">
                                                                    <col width="10%">
                                                                    <%
                                                                                       if (surveyArea != null && surveyArea.size() > 0) {
                                                                                           for (LeadArea leadarea : surveyArea) {
                                                                                               String leadname = leadarea.getLeadName();%>
                                                                    <tr>
                                                                        <th colspan="5"><center><b><%=leadname%></b></center></th>
                                                                    </tr>
                                                                    <tr>
                                                                        <th>Item</th>
                                                                        <th>Remarks</th>
                                                                        <th>Charges</th>
                                                                        <th>Qty</th>
                                                                        <th>Units</th>
                                                                    </tr> 
                                                                    <%
                                                                        ArrayList<Item> areaVMItems = leadarea.getVimboxItems();
                                                                        for (Item item : areaVMItems) {
                                                                            String tr = "<tr><td>" + item.getName() + "</td>";
                                                                            tr += "<td>" + item.getRemark() + "</td>";
                                                                            if (item.getCharges() > 0) {
                                                                                tr += "<td align='center'>" + item.getCharges() + "</td>";
                                                                            } else {
                                                                                tr += "<td align='center'>&nbsp;&nbsp;&nbsp;&nbsp;</td>";
                                                                            }

                                                                            tr += "<td align='center'>" + item.getQty() + "</td>";
                                                                            tr += "<td align='center'>" + item.getUnits() + "</td>";
                                                                            out.println(tr);
                                                                        }
                                                                    %>
                                                                    <%}
                                                                    } else {%>
                                                                    <tr>
                                                                        <th>Item</th>
                                                                        <th>Remarks</th>
                                                                        <th>Charges</th>
                                                                        <th>Qty</th>
                                                                        <th>Units</th>
                                                                    </tr> 
                                                                    <%
                                                                            ArrayList<Item> vimboxItems = leadDiv.getVimboxItems();
                                                                            for (Item item : vimboxItems) {
                                                                                String tr = "<tr><td>" + item.getName() + "</td>";
                                                                                tr += "<td>&nbsp;</td>";
                                                                                tr += "<td align='center'>&nbsp;&nbsp;&nbsp;&nbsp;</td>";
                                                                                tr += "<td align='center'>" + item.getUnits() + "</td>";
                                                                                tr += "<td align='center'>" + item.getUnits() + "</td>";
                                                                                out.println(tr);
                                                                            }

                                                                            ArrayList<Item> materials = leadDiv.getMaterials();
                                                                            for (Item item : materials) {
                                                                                String tr = "<tr><td>" + item.getName() + "</td>";
                                                                                tr += "<td>&nbsp;</td>";
                                                                                tr += "<td align='center'>" + item.getCharges() + "</td>";
                                                                                tr += "<td align='center'>" + item.getUnits() + "</td>";
                                                                                tr += "<td align='center'>&nbsp;</td>";
                                                                                out.println(tr);
                                                                            }
                                                                        }
                                                                    %>

                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td>
                                                <table width="100%" border="1" style="height:500px"  bordercolor="#ddd">
                                                    <tr style="height:5%;background-color:#F6CEE3;">
                                                        <td align="center"><b><u>Customer Comments</u></b></td>
                                                    </tr>
                                                    <tr style="height:15%">
                                                        <td>
                                                            <div style="overflow:auto;height:100%;">
                                                                <table valign="top">
                                                                    <tbody>
                                                                        <%
                                                                            ArrayList<String> comments = leadDiv.getComments();
                                                                            for (String comment : comments) {
                                                                                out.println("<tr><td>" + comment + "</td></tr>");
                                                                            }
                                                                        %>    
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr style="height:5%;background-color:#F6CEE3;">
                                                        <td align="center"><b><u>Customer Remarks</u></b></td>
                                                    </tr>
                                                    <tr style="height:15%">
                                                        <td>
                                                            <div style="overflow:auto;height:100%;">
                                                                <table  valign="top">
                                                                    <tbody>
                                                                        <%
                                                                            ArrayList<String> remarks = leadDiv.getRemarks();
                                                                            for (String remark : remarks) {
                                                                                out.println("<tr><td>" + remark + "</td></tr>");
                                                                            }
                                                                        %>  
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr style="height:5%;background-color:#A9F5D0;">
                                                        <td align="center"><b><u>Services</u></b></td>
                                                    </tr>
                                                    <tr style="height:30%">
                                                        <td>
                                                            <div style="overflow:auto;height:100%;">
                                                                <table valign="top" width="100%">
                                                                    <tbody>
                                                                        <%
                                                                            ArrayList<String[]> services = leadDiv.getServices();
                                                                            for (String[] service : services) {
                                                                                String[] svc = service[0].split("_");
                                                                                String tr = "<tr id='" + leadDivId + "_" + service[0] + "'><td>";
                                                                                tr += "<table width='100%'>";
                                                                                String secSvc = "";
                                                                                for (int i = 1; i < svc.length; i++) {
                                                                                    secSvc += (svc[i]);
                                                                                    if (i < svc.length - 1) {
                                                                                        secSvc += " ";
                                                                                    }
                                                                                }

                                                                                tr += "<tr height='10%'><td>" + svc[0] + " - " + secSvc + "</td><td align='right'>S$" + service[1] + "</td></tr>";
                                                                                tr += "</table></td></tr>";
                                                                                sum += Double.parseDouble(service[1]);
                                                                                out.println(tr);
                                                                            }
                                                                        %>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <%
                                                        HashMap<String, String> others = leadDiv.getOtherCharges();
                                                    %>
                                                    <tr style='height:5%'>
                                                        <td>
                                                            <table width='100%'>
                                                                <col width='50%'>
                                                                <tr>
                                                                    <td>Storey Charges</td>
                                                                    <td align='right'>$ 
                                                                        <%
                                                                            String storey = others.get("storeyCharge");
                                                                            out.println(storey);
                                                                            sum += Double.parseDouble(storey);
                                                                        %>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr style='height:5%'>
                                                        <td>
                                                            <table width='100%'>
                                                                <col width='50%'>
                                                                <tr>
                                                                    <td>Pushing Charges</td>
                                                                    <td align='right'>$
                                                                        <%
                                                                            String push = others.get("pushCharge");
                                                                            out.println(push);
                                                                            sum += Double.parseDouble(push);
                                                                        %>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr style='height:5%'>
                                                        <td>
                                                            <table width='100%'>
                                                                <col width='50%'>
                                                                <tr>
                                                                    <td>Detour Charges</td>
                                                                    <td align='right'>$ 
                                                                        <%
                                                                            String detour = others.get("detourCharge");
                                                                            out.println(detour);
                                                                            sum += Double.parseDouble(detour);
                                                                        %>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr style='height:5%'>
                                                        <td>
                                                            <table width='100%'>
                                                                <col width='50%'>
                                                                <tr>
                                                                    <td>Material Charges</td>
                                                                    <td align='right'>$ 
                                                                        <%
                                                                            String material = others.get("materialCharge");
                                                                            out.println(material);
                                                                            sum += Double.parseDouble(material);
                                                                        %>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr style='height:5%'>
                                                        <td>
                                                            <table width='100%'>
                                                                <col width='50%'>
                                                                <tr>
                                                                    <td>Markup</td>
                                                                    <td align='right'>$ 
                                                                        <%
                                                                            String markup = others.get("markup");
                                                                            out.println(markup);
                                                                            sum += Double.parseDouble(markup);
                                                                        %>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr style='height:5%'>
                                                        <td>
                                                            <table width='100%'>
                                                                <col width='50%'>
                                                                <tr>
                                                                    <td>Discount</td>
                                                                    <td align='right'>$ 
                                                                        <%
                                                                            String discount = others.get("discount");
                                                                            out.println(discount);
                                                                            sum -= Double.parseDouble(discount);
                                                                        %>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="right">
                                                            Total : <b>S$ 
                                                                <%
                                                                    out.println(df.format(sum));
                                                                    overall += sum;
                                                                %>
                                                            </b>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>  
                                </div>
                                <%
                                    }
                                %>
                            </td>
                        </tr>
                    </table>
                    <hr>
                    <div class="form-horizontal" style="font-size: 14px;">
                        <div class="form-group">
                            <div class="col-sm-6">
                                <h3 class="mrg10A">Grand Total</h3>
                            </div>
                        </div>
                    </div>
                    <table width="100%">
                        <tr>
                            <td align="center">
                                <h2><b>S$<%out.println(df.format(overall));%></b></h2>
                            </td>
                        </tr>
                    </table>
                </fieldset>
            </td>
        </tr>
    </table>
    <%

        }
    %>
