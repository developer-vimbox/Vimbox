<%@page import="com.vimbox.admin.Notification"%>
<%@page import="com.vimbox.database.NotificationDAO"%>
<%@page import="com.vimbox.user.User"%>
<%@include file="ValidateLogin.jsp"%>
<script src="JS/WebSocket.js"></script>
<script src="JS/CustomerFunctions.js"></script>
<script src="JS/LeadFunctions.js"></script>
<script src="JS/TicketFunctions.js"></script>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAlr3mj-08qPnSvod0WtYbmE0NrulFq0RE&libraries=places"></script>
<style>
    /* Loading Spinner */
    .spinner{margin:0;width:70px;height:18px;margin:-35px 0 0 -9px;position:absolute;top:50%;left:50%;text-align:center}.spinner > div{width:18px;height:18px;background-color:#333;border-radius:100%;display:inline-block;-webkit-animation:bouncedelay 1.4s infinite ease-in-out;animation:bouncedelay 1.4s infinite ease-in-out;-webkit-animation-fill-mode:both;animation-fill-mode:both}.spinner .bounce1{-webkit-animation-delay:-.32s;animation-delay:-.32s}.spinner .bounce2{-webkit-animation-delay:-.16s;animation-delay:-.16s}@-webkit-keyframes bouncedelay{0%,80%,100%{-webkit-transform:scale(0.0)}40%{-webkit-transform:scale(1.0)}}@keyframes bouncedelay{0%,80%,100%{transform:scale(0.0);-webkit-transform:scale(0.0)}40%{transform:scale(1.0);-webkit-transform:scale(1.0)}}
</style>        
<link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
<style>
    #additionalAssigned{
        display:none;
    }
</style>
<script src="JS/ModalFunctions.js"></script>
<script type="text/javascript">
    /* jQuery UI Tabs */
    $(function () {
        "use strict";
        $(".tabs").tabs();
    });

    $(function () {
        "use strict";
        $(".tabs-hover").tabs({
            event: "mouseover"
        });
    });
</script>

<script type="text/javascript" src="assets/widgets/tabs/tabs-responsive.js"></script>
<script type="text/javascript">

    $(document).ready(function () {
        $(function () {
            "use strict";
            $('.nav-responsive').tabdrop();
        });
    });
</script>
<!-- Favicons -->

<link rel="apple-touch-icon-precomposed" sizes="144x144" href="assets/images/icons/apple-touch-icon-144-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="114x114" href="assets/images/icons/apple-touch-icon-114-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="72x72" href="assets/images/icons/apple-touch-icon-72-precomposed.png">
<link rel="apple-touch-icon-precomposed" href="assets/images/icons/apple-touch-icon-57-precomposed.png">
<link rel="shortcut icon" href="assets/images/icons/favicon.png">


<style>
    /* Style the list */
    ul.tab {
        list-style-type: none;
        margin: 0;
        padding: 0;
        overflow: hidden;
        border: 1px solid #ccc;
        background-color: #f1f1f1;
    }

    /* Float the list items side by side */
    ul.tab li {float: left;}

    /* Style the links inside the list items */
    ul.tab li a {
        display: inline-block;
        color: black;
        text-align: center;
        padding: 14px 16px;
        text-decoration: none;
        transition: 0.3s;
        font-size: 17px;
    }

    /* Change background color of links on hover */
    ul.tab li a:hover {background-color: #ddd;}

    /* Style the tab content */
    .tabcontent {
        display: none;
        padding: 6px 12px;
        border: 1px solid #ccc;
        border-top: none;
    }

    .tabcontent {
        -webkit-animation: fadeEffect 1s;
        animation: fadeEffect 1s; /* Fading effect takes 1 second */
    }

    @-webkit-keyframes fadeEffect {
        from {opacity: 0;}
        to {opacity: 1;}
    }

    @keyframes fadeEffect {
        from {opacity: 0;}
        to {opacity: 1;}
    }
</style>

<link rel="stylesheet" type="text/css" href="assets/bootstrap/css/bootstrap.css">


<!-- HELPERS -->

<link rel="stylesheet" type="text/css" href="assets/helpers/animate.css">
<link rel="stylesheet" type="text/css" href="assets/helpers/backgrounds.css">
<link rel="stylesheet" type="text/css" href="assets/helpers/boilerplate.css">
<link rel="stylesheet" type="text/css" href="assets/helpers/border-radius.css">
<link rel="stylesheet" type="text/css" href="assets/helpers/grid.css">
<link rel="stylesheet" type="text/css" href="assets/helpers/page-transitions.css">
<link rel="stylesheet" type="text/css" href="assets/helpers/spacing.css">
<link rel="stylesheet" type="text/css" href="assets/helpers/typography.css">
<link rel="stylesheet" type="text/css" href="assets/helpers/utils.css">
<link rel="stylesheet" type="text/css" href="assets/helpers/colors.css">

<!-- ELEMENTS -->

<link rel="stylesheet" type="text/css" href="assets/elements/badges.css">
<link rel="stylesheet" type="text/css" href="assets/elements/buttons.css">
<link rel="stylesheet" type="text/css" href="assets/elements/content-box.css">
<link rel="stylesheet" type="text/css" href="assets/elements/dashboard-box.css">
<link rel="stylesheet" type="text/css" href="assets/elements/forms.css">
<link rel="stylesheet" type="text/css" href="assets/elements/images.css">
<link rel="stylesheet" type="text/css" href="assets/elements/info-box.css">
<link rel="stylesheet" type="text/css" href="assets/elements/invoice.css">
<link rel="stylesheet" type="text/css" href="assets/elements/loading-indicators.css">
<link rel="stylesheet" type="text/css" href="assets/elements/menus.css">
<link rel="stylesheet" type="text/css" href="assets/elements/panel-box.css">
<link rel="stylesheet" type="text/css" href="assets/elements/response-messages.css">
<link rel="stylesheet" type="text/css" href="assets/elements/responsive-tables.css">
<link rel="stylesheet" type="text/css" href="assets/elements/ribbon.css">
<link rel="stylesheet" type="text/css" href="assets/elements/social-box.css">
<link rel="stylesheet" type="text/css" href="assets/elements/tables.css">
<link rel="stylesheet" type="text/css" href="assets/elements/tile-box.css">
<link rel="stylesheet" type="text/css" href="assets/elements/timeline.css">



<!-- ICONS -->

<link rel="stylesheet" type="text/css" href="assets/icons/fontawesome/fontawesome.css">
<link rel="stylesheet" type="text/css" href="assets/icons/linecons/linecons.css">
<link rel="stylesheet" type="text/css" href="assets/icons/spinnericon/spinnericon.css">

<!-- Chart.js -->

<script type="text/javascript" src="assets/widgets/charts/chart-js/chart-core.js"></script>

<script type="text/javascript" src="assets/widgets/charts/chart-js/chart-bar.js"></script>
<script type="text/javascript" src="assets/widgets/charts/chart-js/chart-doughnut.js"></script>
<script type="text/javascript" src="assets/widgets/charts/chart-js/chart-line.js"></script>
<script type="text/javascript" src="assets/widgets/charts/chart-js/chart-polar.js"></script>
<script type="text/javascript" src="assets/widgets/charts/chart-js/chart-radar.js"></script>

<script type="text/javascript" src="assets/widgets/charts/chart-js/chart-demo.js"></script>
<!-- WIDGETS -->

<link rel="stylesheet" type="text/css" href="assets/widgets/accordion-ui/accordion.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/calendar/calendar.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/carousel/carousel.css">

<link rel="stylesheet" type="text/css" href="assets/widgets/charts/justgage/justgage.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/charts/morris/morris.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/charts/piegage/piegage.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/charts/xcharts/xcharts.css">

<link rel="stylesheet" type="text/css" href="assets/widgets/chosen/chosen.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/colorpicker/colorpicker.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/datatable/datatable.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/datepicker/datepicker.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/datepicker-ui/datepicker.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/daterangepicker/daterangepicker.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/dialog/dialog.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/dropdown/dropdown.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/dropzone/dropzone.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/file-input/fileinput.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/input-switch/inputswitch.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/input-switch/inputswitch-alt.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/ionrangeslider/ionrangeslider.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/jcrop/jcrop.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/jgrowl-notifications/jgrowl.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/loading-bar/loadingbar.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/maps/vector-maps/vectormaps.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/markdown/markdown.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/modal/modal.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/multi-select/multiselect.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/multi-upload/fileupload.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/nestable/nestable.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/noty-notifications/noty.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/popover/popover.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/pretty-photo/prettyphoto.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/progressbar/progressbar.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/range-slider/rangeslider.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/slidebars/slidebars.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/slider-ui/slider.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/summernote-wysiwyg/summernote-wysiwyg.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/tabs-ui/tabs.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/theme-switcher/themeswitcher.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/timepicker/timepicker.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/tocify/tocify.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/tooltip/tooltip.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/touchspin/touchspin.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/uniform/uniform.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/wizard/wizard.css">
<link rel="stylesheet" type="text/css" href="assets/widgets/xeditable/xeditable.css">

<!-- SNIPPETS -->

<link rel="stylesheet" type="text/css" href="assets/snippets/chat.css">
<link rel="stylesheet" type="text/css" href="assets/snippets/files-box.css">
<link rel="stylesheet" type="text/css" href="assets/snippets/login-box.css">
<link rel="stylesheet" type="text/css" href="assets/snippets/notification-box.css">
<link rel="stylesheet" type="text/css" href="assets/snippets/progress-box.css">
<link rel="stylesheet" type="text/css" href="assets/snippets/todo.css">
<link rel="stylesheet" type="text/css" href="assets/snippets/user-profile.css">
<link rel="stylesheet" type="text/css" href="assets/snippets/mobile-navigation.css">

<!-- APPLICATIONS -->

<link rel="stylesheet" type="text/css" href="assets/applications/mailbox.css">

<!-- Admin theme -->

<link rel="stylesheet" type="text/css" href="assets/themes/admin/layout.css">
<link rel="stylesheet" type="text/css" href="assets/themes/admin/color-schemes/default.css">

<!-- Components theme -->

<link rel="stylesheet" type="text/css" href="assets/themes/components/default.css">
<link rel="stylesheet" type="text/css" href="assets/themes/components/border-radius.css">

<!-- Admin responsive -->

<link rel="stylesheet" type="text/css" href="assets/helpers/responsive-elements.css">
<link rel="stylesheet" type="text/css" href="assets/helpers/admin-responsive.css">

<!-- JS Core -->
<script src="JS/jquery.hotkeys.js"></script>
<script type="text/javascript" src="assets/js-core/jquery-core.js"></script>
<script type="text/javascript" src="assets/js-core/jquery-ui-core.js"></script>
<script type="text/javascript" src="assets/js-core/jquery-ui-widget.js"></script>
<script type="text/javascript" src="assets/js-core/jquery-ui-mouse.js"></script>
<script type="text/javascript" src="assets/js-core/jquery-ui-position.js"></script>
<!--<script type="text/javascript" src="assets/js-core/transition.js"></script>-->
<script type="text/javascript" src="assets/js-core/modernizr.js"></script>
<script type="text/javascript" src="assets/js-core/jquery-cookie.js"></script>
<script type="text/javascript" src="assets/widgets/datatable/datatable.js"></script>
<script type="text/javascript" src="assets/widgets/datatable/datatable-bootstrap.js"></script>
<script type="text/javascript" src="assets/widgets/datatable/datatable-tabletools.js"></script>
<script type="text/javascript">
    $(window).load(function () {
        setTimeout(function () {
            $('#loading').fadeOut(400, "linear");
        }, 300);
    });
</script>

<div id="sb-site">
    <div id="loading">
        <div class="spinner">
            <div class="bounce1"></div>
            <div class="bounce2"></div>
            <div class="bounce3"></div>
        </div>
    </div>
    <%            String name = user.getFirst_name() + " " + user.getLast_name();
        String designation = user.getDesignation();
    %>


    <div id="page-wrapper">
        <div id="page-header" class="bg-gradient-9">
            <div id="mobile-navigation">
                <button id="nav-toggle" class="collapsed" data-toggle="collapse" data-target="#page-sidebar"><span></span></button>
                <a href="HomePage.jsp" class="logo-content-small" title="VIMBOX"></a>
            </div>
            <div id="header-logo" class="logo-bg">
                <a href="HomePage.jsp" class="logo-content-big" title="VIMBOX">
                </a>
                <a href="HomePage.jsp" class="logo-content-small" title="VIMBOX">
                </a>
                <a id="close-sidebar" href="#" title="Close sidebar">
                    <i class="glyph-icon icon-angle-left"></i>
                </a>
            </div>
            <div id="header-nav-left">
                <div class="user-account-btn dropdown">
                    <a href="#" title="My Account" class="user-profile clearfix" data-toggle="dropdown">
                        <span style="width: auto;"><%=name%></span>
                        <span><%=designation%></span>
                        <i class="glyph-icon icon-angle-down"></i>
                    </a>
                    <div class="dropdown-menu float-left" style="left: 97px;">
                        <div class="box-sm" style="width: 250px;">  
                            <div class="pad5A button-pane button-pane-alt text-center">
                                <a href="ChangePassword.jsp" class="btn display-block font-normal btn-primary" style="margin-bottom: 5px">
                                    <i class="glyph-icon icon-unlock-alt"></i>
                                    Change Password
                                </a>
                                <a href="Logout.jsp" class="btn display-block font-normal btn-danger">
                                    <i class="glyph-icon icon-power-off"></i>
                                    Logout
                                </a>
                            </div>
                        </div>
                    </div>
                </div>


            </div>
            <style>                                  
                .searchbar {
                    margin-left: 10px;
                    margin-top: 13px;
                    padding-left: 5px;
                    padding-right: 0;
                    padding-bottom: 3px;
                    box-shadow: none;
                    border: none;
                    border-bottom: 1px solid #f0f0f0;
                    border-radius: 0;
                    background: transparent;
                    color: white;
                } 

                input::-webkit-input-placeholder, textarea::-webkit-input-placeholder { 
                    color: whitesmoke;
                }
                input:-moz-placeholder, textarea:-moz-placeholder { 
                    color: whitesmoke;
                }
                input::-moz-placeholder, textarea::-moz-placeholder { 
                    color: whitesmoke;
                }
                input:-ms-input-placeholder, textarea:-ms-input-placeholder { 
                    color: whitesmoke;
                }
            </style>

            <div id="header-nav-right">
                <script src="JS/AdminFunctions.js"></script>
                <style type="text/css">
                    .htooltip {
                        position: relative;
                        z-index: 999;
                    }

                    .htooltip .htooltiptext {
                        visibility: hidden;
                        width: 180px;
                        background-color: black;
                        color: #fff;
                        text-align: center;
                        border-radius: 6px;
                        padding: 5px 0;
                        position: absolute;
                        z-index: 1;
                        top: 115%;
                        left: -147%;
                    }

                    .htooltip .htooltiptext::after {
                        content: "";
                        position: absolute;
                        bottom: 100%;
                        left: 50%;
                        margin-left: -5px;
                        border-width: 5px;
                        border-style: solid;
                        border-color: transparent transparent black transparent;
                    }

                    .htooltip:hover .htooltiptext {
                        visibility: visible;
                        display: block;
                        z-index: 1;
                    }
                </style>


                <div class="dropdown">
                    <input type="text" id="customer_search_header" class="searchbar" placeholder="Search Customer">
                    <button class="btn btn-round btn-primary" onclick='customerSearchHeader("crm")' data-toggle="modal" data-target=".bs-example-modal-lg" style=" margin-right: 10px">
                        <i class="glyph-icon icon-search"></i>
                    </button>
                </div>
                <div id="customer_modal_header" class="modal">
                    <div class="modal-content" style="width: 60%;">
                        <div class="modal-header">
                            <span class="close" onclick="closeModal('customer_modal_header')">×</span>
                            <center><h2>Customer Search</h2></center>
                        </div>
                        <div class="modal-body">
                            <div class="results">
                                <div class="row">
                                    <div id="customer_modal_header">
                                        <div id="customer_content_header"></div>
                                    </div>

                                    <div id="edit_customer_modal" class="modal">
                                        <div class="modal-content" style="width: 70%;">
                                            <div class="modal-header">
                                                <span class="close" onclick="closeModal('edit_customer_modal')">×</span>
                                                <center><h2>Edit Customer</h2></center>
                                            </div>
                                            <div class="modal-body">
                                                <div id="edit_customer_content"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div id="leadsHistoryModal" class="modal">
                                        <div class="modal-content" style="width: 80%;">
                                            <div class="modal-header">
                                                <span class="close" onclick="closeModal('leadsHistoryModal')">×</span>
                                                <center><h2>Leads History</h2></center>
                                            </div>
                                            <div class="modal-body">
                                                <div id="leadsHistoryContent"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div id="customer_error_modal" class="modal">
                                        <div class="error-modal-content">
                                            <div class="modal-header">
                                                <span class="close" onclick="closeModal('customer_error_modal')">×</span>
                                                <center><h2><div id="customer_error_status"></div></h2></center>
                                            </div>
                                            <div class="modal-body">
                                                <div id="customer_error_message"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div id="ticketsHistoryModal" class="modal">
                                        <div class="modal-content" style="width: 80%;">
                                            <div class="modal-header">
                                                <span class="close" onclick="closeModal('ticketsHistoryModal')">×</span>
                                                <center><h2>Tickets History</h2></center>
                                            </div>
                                            <div class="modal-body">
                                                <div id="ticketsHistoryContent"></div>
                                            </div>
                                        </div>
                                    </div>


                                </div><!--.row-->
                            </div><!--.results-->
                        </div>

                    </div>
                </div>
                <%
                    if (moduleNames.contains("Admin")) {
                %>
                <div class="htooltip dropdown">
                    <a onclick="admViewCal()"><i class="glyph-icon icon-calendar-o"></i></a>
                    <span class='htooltiptext'>
                        View Site Survey Schedule
                    </span>
                </div>
                <div class="htooltip dropdown">
                    <a onclick="admViewMovCal()"><i class="glyph-icon icon-calendar"></i></a>
                    <span class='htooltiptext'>
                        View Operation Schedules
                    </span>
                </div>

                <div id="cal_modal" class="modal">
                    <div class="modal-content" style="width: 90%;">
                        <div class="modal-body">
                            <span class="close" onclick="closeModal('cal_modal')">×</span>
                            <br>
                            <div id="cal_content"></div>
                            <br>
                            <div id="ssCalTable"></div>
                        </div>
                    </div>
                </div>
                <div id="schedule_modal" class="modal">
                    <div class="modal-content" style="width: 95%;">
                        <div class="modal-body">
                            <span class="close" onclick="closeModal('schedule_modal')">×</span>
                            <div id="schedule_content"></div>
                        </div>
                    </div>
                </div>
                <%
                    }
                %>
                
                <%
                    ArrayList<Notification> notifications = NotificationDAO.getUserNotifications(user.getNric());
                    boolean notificationCheck = false;
                    for(Notification notification : notifications){
                        if(notification.getStatus().equals("New")){
                            notificationCheck = true;
                            break;
                        }
                    }
                %>
                <div class="dropdown" id="notifications-btn" onclick="viewNotifications()">
                    <a data-toggle="dropdown" href="#" id="notifications-a">
                        <%
                            if(notificationCheck){
                        %>
                            <span class="small-badge bg-yellow" id="notifications-tag"></span>
                        <%
                            }
                        %>
                        <i class="glyph-icon icon-linecons-megaphone"></i>
                    </a>
                    <div class="dropdown-menu box-md float-right">
                        <div class="popover-title display-block clearfix pad10A">
                            Notifications
                            <button class="text-transform-cap font-primary font-normal btn-link float-right" onclick="clearNotifications()">Clear all</button>
                        </div>
                        <div class="scrollable-content scrollable-slim-box">
                            <ul class="no-border notifications-box" id="notifications-section">
                                <%
                                    for(Notification notification : notifications){
                                %>
                                <li>
                                    <span class="bg-blue icon-notification glyph-icon icon-user"></span>
                                    <span class="notification-text font-blue"><%=notification.getMessage()%></span>
                                </li>
                                <%
                                    }
                                %>
                            </ul>
                        </div>
                    </div>
                </div>
            </div><!-- #header-nav-right -->
        </div>
        <div id="page-sidebar">
            <div class="scroll-sidebar">
                <ul id="sidebar-menu">
                    <%
                        if (moduleNames.contains("Admin") || moduleNames.contains("HR")) {
                    %>
                    <li>
                        <a href="#" title="Human Resource">
                            <i class="glyph-icon icon-group"></i>
                            <span>Human Resource</span>
                        </a>
                        <div class="sidebar-submenu">
                            <ul>
                                <li> <a href="FullTimeEmployees.jsp" title="Full Time Employees"><span>Full Time Employees</span></a></li>
                                <li> <a href="PartTimeEmployees.jsp" title="Part Time Employees"><span>Part Time Employees</span></a></li>
                                <li> <a href="Payslips.jsp" title="Payslips"><span>Payslips</span></a></li>
                                <li> <a href="TakeAttendance.jsp" title="Take Attendance">Take Attendance</a></li>
                                <li> <a href="ViewAttendance.jsp" title="View Attendance">View Attendance</a></li>
                                <li> <a href="LeaveMCs.jsp" title="Leave / MC">Leave / MC</a></li>
                            </ul>
                        </div><!-- .sidebar-submenu -->
                    </li>
                    <%
                        }
                    %>

                    <%
                        if (moduleNames.contains("Admin") || moduleNames.contains("Sales")) {
                    %>
                    <li>
                        <a href="#" title="Sales">
                            <i class="glyph-icon icon-dollar"></i>
                            <span>Sales</span>
                        </a>
                        <div class="sidebar-submenu">
                            <ul>
                                <li> <a href="CreateLead.jsp" title="Create Lead"><span>Create Lead</span></a></li>
                                <li> <a href="AllLeads.jsp" title="All Leads"><span>All Leads</span></a></li>
                                <li> <a href="SalesSites.jsp" title="Sites"><span>Sites Surveys</span></a></li>
                                <li> <a href="SalesOperations.jsp" title="Operations"><span>Operations</span></a></li>
                                <li> <a href="ViewSalesReport.jsp" title="Sales Report"><span>Sales Report</span></a></li>
                            </ul>

                        </div><!-- .sidebar-submenu -->
                    </li>
                    <%
                        }
                    %>

                    <%
                        if (moduleNames.contains("Admin") || moduleNames.contains("SiteSurvey")) {
                    %>
                    <li>
                        <a href="#" title="Site Surveys">
                            <i class="glyph-icon icon-building-o"></i>
                            <span>Site Surveys</span>
                        </a>
                        <div class="sidebar-submenu">
                            <ul>
                                <li><a href="MySites.jsp" title="My Sites"><span>My Sites</span></a></li>
                                <li><a href="MySiteSurveySchedules.jsp" title="My Schedule"><span>My Schedule</span></a></li>
                            </ul>

                        </div><!-- .sidebar-submenu -->
                    </li>
                    <%
                        }
                    %>

                    <%
                        if (moduleNames.contains("Admin") || moduleNames.contains("Supervisor")) {
                    %>
                    <li>
                        <a href="#" title="Operations">
                            <i class="glyph-icon icon-truck"></i>
                            <span>Operations</span>
                        </a>
                        <div class="sidebar-submenu">
                            <ul>
                                <%
                                    if (moduleNames.contains("Admin")) {
                                %>
                                <li><a href="AssignJobs.jsp" title="Assign Jobs"><span>Assign Jobs</span></a></li>
                                    <% } %>
                                <li><a href="SupervisorJobs.jsp" title="Supervisor Jobs"><span>Supervisor Jobs</span></a></li>
                                <li><a href="SupervisorTakeAttendance.jsp" title="Supervisor Take Attendance"><span>Take Attendance</span></a></li>
                            </ul>

                        </div><!-- .sidebar-submenu -->
                    </li>
                    <%
                        }
                    %>

                    <li>
                        <a href="#" title="Tickets">
                            <i class="glyph-icon icon-ticket"></i>
                            <span>Tickets</span>
                        </a>
                        <div class="sidebar-submenu">
                            <ul>
                                <li><a href="CreateTicket.jsp" title="Create Ticket"><span>Create Ticket</span></a></li>
                                <li><a href="MyTickets.jsp" title="My Tickets"><span>My Tickets</span></a></li>
                                <li><a href="TicketForum.jsp" title="TicketForum"><span>Ticket Forum</span></a></li>
                            </ul>

                        </div><!-- .sidebar-submenu -->
                    </li>

                    <%
                        if (moduleNames.contains("Admin")) {
                    %>
                    <li>
                        <a href="#" title="Admin">
                            <i class="glyph-icon icon-user"></i>
                            <span>Admin</span>
                        </a>
                        <div class="sidebar-submenu">
                            <ul>
                                <li><a href="ValueSetup.jsp" title="Value Setup"><span>Value Setup</span></a></li>
                            </ul>
                        </div><!-- .sidebar-submenu -->
                    </li>
                    <%
                        }
                    %>
                </ul><!-- #sidebar-menu -->
            </div>
        </div>
        <!-- WIDGETS -->
        <script type="text/javascript" src="assets/bootstrap/js/bootstrap.js"></script>
        <script type="text/javascript" src="assets/widgets/superclick/superclick.js"></script>

        <!-- Slidebars -->
        <script type="text/javascript" src="assets/widgets/slidebars/slidebars.js"></script>
        <script type="text/javascript" src="assets/widgets/slidebars/slidebars-demo.js"></script>

        <!-- Screenfull -->
        <script type="text/javascript" src="assets/widgets/screenfull/screenfull.js"></script>

        <!-- Content box -->
        <script type="text/javascript" src="assets/widgets/content-box/contentbox.js"></script>

        <!-- Overlay -->
        <script type="text/javascript" src="assets/widgets/overlay/overlay.js"></script>

        <!-- Theme layout -->
        <script type="text/javascript" src="assets/themes/admin/layout.js"></script>