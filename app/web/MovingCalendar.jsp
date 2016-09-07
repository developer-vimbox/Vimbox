<%@page import="com.vimbox.operations.Truck"%>
<%@page import="com.vimbox.database.TruckDAO"%>
<%@ page  language="java" import="java.util.*,java.text.*"%>
<%!
    public int nullIntconv(String inv) {
        int conv = 0;

        try {
            conv = Integer.parseInt(inv);
        } catch (Exception e) {
        }
        return conv;
    }
%>
<%
    int iYear = nullIntconv(request.getParameter("iYear"));
    int iMonth = nullIntconv(request.getParameter("iMonth"));

    Calendar ca = new GregorianCalendar();
    int iTYear = ca.get(Calendar.YEAR);
    int iTMonth = ca.get(Calendar.MONTH);

    if (iYear == 0) {
        iYear = iTYear;
        iMonth = iTMonth;
    }
    
    ArrayList<Truck> trucks = TruckDAO.getAllTrucks();
%>
<script src="JS/LeadFunctions.js"></script>
<!-- Calendar -->

<script type="text/javascript" src="assets/widgets/interactions-ui/resizable.js"></script>
<script type="text/javascript" src="assets/widgets/interactions-ui/draggable.js"></script>
<script type="text/javascript" src="assets/widgets/interactions-ui/sortable.js"></script>
<script type="text/javascript" src="assets/widgets/interactions-ui/selectable.js"></script>

<link rel="stylesheet" type="text/css" href="assets/widgets/calendar/calendar.css">
<script type="text/javascript" src="assets/widgets/daterangepicker/moment.js"></script>
<script type="text/javascript" src="assets/widgets/calendar/calendar.js"></script>
<script type="text/javascript" src="assets/widgets/calendar/calendar-demo.js"></script>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td width="7%">
                        <select class="form-control" id="iYear" name="iYear" onchange="changeMoveMonthYear()">
                            <%            
                                for (int iy = iTYear - 5; iy <= iTYear + 5; iy++) {
                                    if (iy == iYear) {
                            %>
                            <option value="<%=iy%>" selected="selected"><%=iy%></option>
                            <%
                            } else {
                            %>
                            <option value="<%=iy%>"><%=iy%></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </td>
                    <td width="1%"><label class="control-label"></label></td>
                    <td width="10%">
                        <select class="form-control" id="iMonth" name="iMonth" onchange="changeMoveMonthYear()">
                            <%
                                for (int im = 0; im <= 11; im++) {
                                    if (im == iMonth) {
                            %>
                            <option value="<%=im%>" selected="selected"><%=new SimpleDateFormat("MMMM").format(new Date(2008, im, 01))%></option>
                            <%
                            } else {
                            %>
                            <option value="<%=im%>"><%=new SimpleDateFormat("MMMM").format(new Date(2008, im, 01))%></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </td>
                    <td width="68%" align="center"><h2><label id="dMonth" style="padding-top: 8px;"><%=new SimpleDateFormat("MMMM").format(new Date(2008,iMonth,01))%></label> <label id="dYear"> <%=iYear%></label></h2></td>
                    <td width="15%">
                        <select class="form-control" id="ttSelect" name="ttSelect" onchange="changeMoveMonthYear()">
                            <option value="alltt" selected="selected">-- All Trucks --</option>
                            <%
                                for (Truck truck : trucks) {
                                    String carplate = truck.getCarplateNo();
                            %>
                            <option value="<%=carplate%>"><%=truck%></option>
                            <%
                                }
                            %>
                        </select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
