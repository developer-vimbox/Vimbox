<html lang="en" class="js flexbox flexboxlegacy canvas canvastext webgl no-touch geolocation postmessage websqldatabase indexeddb hashchange history draganddrop websockets rgba hsla multiplebgs backgroundsize borderimage borderradius boxshadow textshadow opacity cssanimations csscolumns cssgradients cssreflections csstransforms csstransforms3d csstransitions fontface generatedcontent video audio localstorage sessionstorage webworkers applicationcache svg inlinesvg smil svgclippaths sb-init"><head>
        <style>
            /* Loading Spinner */
            .spinner{margin:0;width:70px;height:18px;margin:-35px 0 0 -9px;position:absolute;top:50%;left:50%;text-align:center}.spinner > div{width:18px;height:18px;background-color:#333;border-radius:100%;display:inline-block;-webkit-animation:bouncedelay 1.4s infinite ease-in-out;animation:bouncedelay 1.4s infinite ease-in-out;-webkit-animation-fill-mode:both;animation-fill-mode:both}.spinner .bounce1{-webkit-animation-delay:-.32s;animation-delay:-.32s}.spinner .bounce2{-webkit-animation-delay:-.16s;animation-delay:-.16s}@-webkit-keyframes bouncedelay{0%,80%,100%{-webkit-transform:scale(0.0)}40%{-webkit-transform:scale(1.0)}}@keyframes bouncedelay{0%,80%,100%{transform:scale(0.0);-webkit-transform:scale(0.0)}40%{transform:scale(1.0);-webkit-transform:scale(1.0)}}
        </style>
        <meta charset="UTF-8">
        <title> VIMBOX - Login </title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.js"></script> 
        <script src="http://malsup.github.com/jquery.form.js"></script> 
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <script src="JS/ModalFunctions.js"></script>
        <script src="JS/UserFunctions.js"></script>
        <link rel="stylesheet" type="text/css" href="assets/custom/css/admin1.css">
        <link rel="stylesheet" type="text/css" href="assets/custom/css/custom.css">
        <script src="assets/custom/js/modernizr.min.js"></script>
        <link rel="stylesheet" type="text/css" href="assets/custom/css/custommodalcss.css">
        <script type="text/javascript">
            $(window).load(function () {
                setTimeout(function () {
                    $('#loading').fadeOut(400, "linear");
                }, 300);
            });
        </script>
    </head>
    <body class="bg-login printable" data-gr-c-s-loaded="true">
        <div id="messageModal" class="modal">
            <!-- Modal content -->
            <div class="message-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('messageModal')">×</span>
                    <div id="message-status"></div>
                    <hr>
                    <div id="message-content"></div>
                </div>
            </div>
        </div>
        <div id="loading" style="display: none;">
            <div class="spinner">
                <div class="bounce1"></div>
                <div class="bounce2"></div>
                <div class="bounce3"></div>
            </div>
        </div>

        <script type="text/css">

            html,body {
                height: 100%;
                background: #fff;
                overflow: hidden;
            }

        </script>
        <script type="text/javascript" src="assets/widgets/wow/wow.js"></script>
        <script type="text/javascript">
                        /* WOW animations */

                        wow = new WOW({
                            animateClass: 'animated',
                            offset: 100
                        });
                        wow.init();
        </script>
        <div class="login-screen">
            <div class="panel-login blur-content">
                <div class="panel-heading"><b>VIMBOX</b></div><!--.panel-heading-->
                <div id="pane-login" class="panel-body active">
                    <h2>Login to Vimbox</h2>
                    <form action="LoginController" method="POST" id="login_form">
                        <div class="form-body">
                            <div class="form-group">
                                <div class="inputer">
                                    <div class="input-wrapper">
                                        <input type="text" class="form-control" name="username" placeholder="Enter your username" required>
                                    </div>
                                </div>
                            </div><!--.form-group-->
                            <div class="form-group">
                                <div class="inputer">
                                    <div class="input-wrapper">
                                        <input type="password" name="password" class="form-control" placeholder="Enter your password" required>
                                    </div>
                                </div>
                            </div><!--.form-group-->
                        </div>
                        <div class="form-buttons clearfix">
                            <label class="pull-left"><input type="checkbox" name="remember" value="1"> Remember me</label>
                            <input type="submit" class="btn btn-success pull-right" value="Login">
                        </div><!--.form-buttons-->
                    </form>
                </div><!--#login.panel-body-->

            </div><!--.blur-content-->
        </div><!--.login-screen-->

        <div class="bg-blur dark active">
            <div class="overlay"></div><!--.overlay-->
        </div><!--.bg-blur-->

        <svg version="1.1" xmlns="http://www.w3.org/2000/svg">
    <filter id="blur">
        <feGaussianBlur stdDeviation="7"></feGaussianBlur>
    </filter>
    </svg>

    <!-- PLUGINS INITIALIZATION AND SETTINGS -->
    <script src="assets/custom/js/user-pages.js"></script>
    <!-- END PLUGINS INITIALIZATION AND SETTINGS -->

    <!-- PLEASURE Initializer -->
    <script src="assets/custom/js/pleasure.js"></script>
    <!-- ADMIN 1 Layout Functions -->
    <script src="assets/custom/js/customlayout.js"></script>

</body>
</html>