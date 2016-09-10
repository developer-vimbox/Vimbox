<%@page import="com.vimbox.operations.Job"%>
<%@page import="com.vimbox.database.JobDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page  language="java" import="java.util.*,java.text.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Supervisor Jobs Assigned</title>
        <script src="JS/OperationFunctions.js"></script>
    </head>
    <body onload="loadSupervisorCal()">
        <%@include file="header.jsp"%>
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
            int iYear = nullIntconv(request.getParameter("sYear"));
            int iMonth = nullIntconv(request.getParameter("sMonth"));

            Calendar ca = new GregorianCalendar();
            int iTYear = ca.get(Calendar.YEAR);
            int iTMonth = ca.get(Calendar.MONTH);

            if (iYear == 0) {
                iYear = iTYear;
                iMonth = iTMonth;
            }

            //ArrayList<Job> jobs = JobDAO.getJobsBySupervisor(user.getNric());
        %>

        <div id="page-content-wrapper">
            <div id="page-content">
                <div class="container">
                    <div id="page-title">
                        <h2>Supervisor Jobs Assigned</h2> <br>
                        <div class="panel">
                            <div class="panel-body">
                                
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
                                        <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td width="7%">
                                                        <select class="form-control" id="sYear" name="sYear" onchange="changeSupervisorMonthYear()">
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
                                                        <select class="form-control" id="sMonth" name="sMonth" onchange="changeSupervisorMonthYear()">
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
                                                    <td width="50%" align="center"><h2><label id="dMonth" style="padding-top: 8px;"><%=new SimpleDateFormat("MMMM").format(new Date(2008, iMonth, 01))%></label> <label id="dYear"> <%=iYear%></label></h2></td>
                                                    <td width="20%"> </td>
                                                </tr>
                                            </table></td>
                                    </tr>
                                </table>
                                <br>
                                <div id="supervisorCalendar"></div>
                               
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
