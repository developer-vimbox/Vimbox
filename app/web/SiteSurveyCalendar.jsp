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
                    <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td width="3%"><label class="control-label" style="padding-top: 7px;">Year:</label></td>
                                <td width="7%">
                                    <select class="form-control" id="iYear" name="iYear" onchange="changeMonthYear()">
                                        <%            // start year and end year in combo box to change year in calendar
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
                                    </select></td>
                                <td width="73%" align="center"><h3><label id="dMonth" style="padding-top: 8px;"><%=new SimpleDateFormat("MMMM").format(new Date(2008,iMonth,01))%></label> <label id="dYear"> <%=iYear%></label></h3></td>
                                <td width="4%"><label class="control-label">Month:</label></td>
                                <td width="9%">
                                    <select class="form-control" id="iMonth" name="iMonth" onchange="changeMonthYear()">
                                        <%
                                            // print month in combo box to change month in calendar
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
                                    </select></td>
                            </tr>
                        </table></td>
                </tr>
            </table>

