<%@page import="com.vimbox.user.User"%>
<%@include file="ValidateLogin.jsp"%>

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

<script type="text/javascript" src="../../assets/widgets/tabs/tabs-responsive.js"></script>
<script type="text/javascript">
    /* Responsive tabs */
    $(function () {
        "use strict";
        $('.nav-responsive').tabdrop();
    });
</script>

<!-- Favicons -->

<link rel="apple-touch-icon-precomposed" sizes="144x144" href="assets/images/icons/apple-touch-icon-144-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="114x114" href="assets/images/icons/apple-touch-icon-114-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="72x72" href="assets/images/icons/apple-touch-icon-72-precomposed.png">
<link rel="apple-touch-icon-precomposed" href="assets/images/icons/apple-touch-icon-57-precomposed.png">
<link rel="shortcut icon" href="assets/images/icons/favicon.png">



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

<script type="text/javascript" src="assets/js-core/jquery-core.js"></script>
<script type="text/javascript" src="assets/js-core/jquery-ui-core.js"></script>
<script type="text/javascript" src="assets/js-core/jquery-ui-widget.js"></script>
<script type="text/javascript" src="assets/js-core/jquery-ui-mouse.js"></script>
<script type="text/javascript" src="assets/js-core/jquery-ui-position.js"></script>
<!--<script type="text/javascript" src="assets/js-core/transition.js"></script>-->
<script type="text/javascript" src="assets/js-core/modernizr.js"></script>
<script type="text/javascript" src="assets/js-core/jquery-cookie.js"></script>

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
                        <span><%=name%></span>
                        <span><%=designation%></span>
                        <i class="glyph-icon icon-angle-down"></i>
                    </a>
                    <div class="dropdown-menu float-left">
                        <div class="box-sm">  
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
                <div class="dropdown">
                    <input type="text" id="customer_search_header" class="searchbar" placeholder="Search Customer">
                    <button class="btn btn-round btn-primary" onclick='customerSearchHeader("crm")' data-toggle="modal" data-target=".bs-example-modal-lg" style=" margin-right: 10px">
                        <i class="glyph-icon icon-search"></i>
                    </button>
                </div>
                <div class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h4 class="modal-title">Search Results</h4>
                        </div>
                        <div class="modal-body">
                            <div class="results">
                                <div class="row">
                                    <div id="customer_modal_header">
                                        <div id="customer_content_header"></div>
                                    </div>

                                    <div id="edit_customer_modal" class="modal">
                                        <div class="modal-content">
                                            <div class="modal-body">
                                                <span class="close" onclick="closeModal('edit_customer_modal')">×</span>
                                                <div id="edit_customer_content"></div>
                                            </div>
                                        </div>
                                    </div>

                                    <div id="customer_error_modal" class="modal">
                                        <div class="error-modal-content">
                                            <div class="modal-body">
                                                <span class="close" onclick="closeModal('customer_error_modal')">×</span>
                                                <div id="customer_error_status"></div>
                                                <hr>
                                                <div id="customer_error_message"></div>
                                            </div>
                                        </div>
                                    </div>

                                    <div id="ticketsHistoryModel" class="modal">
                                        <!-- Modal content -->
                                        <div class="search-modal-content">
                                            <div class="modal-body">
                                                <span class="close" onclick="closeModal('ticketsHistoryModel')">×</span>
                                                <div id="ticketsHistoryContent"></div>
                                            </div>
                                        </div>
                                    </div>

                                    <div id="leadsHistoryModel" class="modal">
                                        <!-- Modal content -->
                                        <div class="search-modal-content">
                                            <div class="modal-body">
                                                <span class="close" onclick="closeModal('leadsHistoryModel')">×</span>
                                                <div id="leadsHistoryContent"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div><!--.row-->
                            </div><!--.results-->
                        </div>

                    </div>
                </div>

                <div class="dropdown" id="notifications-btn">
                    <a data-toggle="dropdown" href="#" title="">
                        <span class="small-badge bg-yellow"></span>
                        <i class="glyph-icon icon-linecons-megaphone"></i>
                    </a>
                    <div class="dropdown-menu box-md float-right">

                        <div class="popover-title display-block clearfix pad10A">
                            Notifications
                            <a class="text-transform-cap font-primary font-normal btn-link float-right" href="#" title="View more options">
                                More options...
                            </a>
                        </div>
                        <div class="scrollable-content scrollable-slim-box">
                            <ul class="no-border notifications-box">
                                <li>
                                    <span class="bg-danger icon-notification glyph-icon icon-bullhorn"></span>
                                    <span class="notification-text">This is an error notification</span>
                                    <div class="notification-time">
                                        a few seconds ago
                                        <span class="glyph-icon icon-clock-o"></span>
                                    </div>
                                </li>
                                <li>
                                    <span class="bg-warning icon-notification glyph-icon icon-users"></span>
                                    <span class="notification-text font-blue">This is a warning notification</span>
                                    <div class="notification-time">
                                        <b>15</b> minutes ago
                                        <span class="glyph-icon icon-clock-o"></span>
                                    </div>
                                </li>
                                <li>
                                    <span class="bg-green icon-notification glyph-icon icon-sitemap"></span>
                                    <span class="notification-text font-green">A success message example.</span>
                                    <div class="notification-time">
                                        <b>2 hours</b> ago
                                        <span class="glyph-icon icon-clock-o"></span>
                                    </div>
                                </li>
                                <li>
                                    <span class="bg-azure icon-notification glyph-icon icon-random"></span>
                                    <span class="notification-text">This is an error notification</span>
                                    <div class="notification-time">
                                        a few seconds ago
                                        <span class="glyph-icon icon-clock-o"></span>
                                    </div>
                                </li>
                                <li>
                                    <span class="bg-warning icon-notification glyph-icon icon-ticket"></span>
                                    <span class="notification-text">This is a warning notification</span>
                                    <div class="notification-time">
                                        <b>15</b> minutes ago
                                        <span class="glyph-icon icon-clock-o"></span>
                                    </div>
                                </li>
                                <li>
                                    <span class="bg-blue icon-notification glyph-icon icon-user"></span>
                                    <span class="notification-text font-blue">Alternate notification styling.</span>
                                    <div class="notification-time">
                                        <b>2 hours</b> ago
                                        <span class="glyph-icon icon-clock-o"></span>
                                    </div>
                                </li>
                                <li>
                                    <span class="bg-purple icon-notification glyph-icon icon-user"></span>
                                    <span class="notification-text">This is an error notification</span>
                                    <div class="notification-time">
                                        a few seconds ago
                                        <span class="glyph-icon icon-clock-o"></span>
                                    </div>
                                </li>
                                <li>
                                    <span class="bg-warning icon-notification glyph-icon icon-user"></span>
                                    <span class="notification-text">This is a warning notification</span>
                                    <div class="notification-time">
                                        <b>15</b> minutes ago
                                        <span class="glyph-icon icon-clock-o"></span>
                                    </div>
                                </li>
                                <li>
                                    <span class="bg-green icon-notification glyph-icon icon-user"></span>
                                    <span class="notification-text font-green">A success message example.</span>
                                    <div class="notification-time">
                                        <b>2 hours</b> ago
                                        <span class="glyph-icon icon-clock-o"></span>
                                    </div>
                                </li>
                                <li>
                                    <span class="bg-purple icon-notification glyph-icon icon-user"></span>
                                    <span class="notification-text">This is an error notification</span>
                                    <div class="notification-time">
                                        a few seconds ago
                                        <span class="glyph-icon icon-clock-o"></span>
                                    </div>
                                </li>
                                <li>
                                    <span class="bg-warning icon-notification glyph-icon icon-user"></span>
                                    <span class="notification-text">This is a warning notification</span>
                                    <div class="notification-time">
                                        <b>15</b> minutes ago
                                        <span class="glyph-icon icon-clock-o"></span>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="pad10A button-pane button-pane-alt text-center">
                            <a href="#" class="btn btn-primary" title="View all notifications">
                                View all notifications
                            </a>
                        </div>
                    </div>
                </div>
            </div><!-- #header-nav-right -->
        </div>
        <div id="page-sidebar">
            <div class="scroll-sidebar">
                <ul id="sidebar-menu">
                    <li>
                        <a href="#" title="Human Resource">
                            <i class="glyph-icon icon-linecons-diamond"></i>
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
                    <li>
                        <a href="#" title="Sales">
                            <i class="glyph-icon icon-linecons-diamond"></i>
                            <span>Sales</span>
                        </a>
                        <div class="sidebar-submenu">
                            <ul>
                                <li> <a href="CreateLead.jsp" title="Create Lead"><span>Create Lead</span></a></li>
                                <li> <a href="MyLeads.jsp" title="My Leads"><span>My Leads</span></a></li>
                            </ul>

                        </div><!-- .sidebar-submenu -->
                    </li>
                    <li>
                        <a href="#" title="Tickets">
                            <i class="glyph-icon icon-linecons-diamond"></i>
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