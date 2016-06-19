<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Vimbox</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="JS/ModalFunctions.js"></script>
        <script src="JS/UserFunctions.js"></script>
        <link rel="stylesheet" type="text/css" href="CSS/modalcss.css">
        <link rel="stylesheet" href="assets/admin1/css/admin1.css">
        <link rel="stylesheet" href="assets/globals/css/elements.css">
        <link rel="stylesheet" href="assets/globals/css/plugins.css">

        <script src="assets/globals/plugins/modernizr/modernizr.min.js"></script>
    </head>
    <body class="bg-login printable">
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

        <div class="login-screen">
            <div class="panel-login blur-content">
                <div class="panel-heading"><b>VIMBOX</b></div><!--.panel-heading-->

                <div id="pane-login" class="panel-body active">
                    <h2>Login to Vimbox</h2>
                    
                        <div class="form-body">
                            <div class="form-group">
                                <div class="inputer">
                                    <div class="input-wrapper">
                                        <input type="text" class="form-control" id="username" placeholder="Enter your username" required>
                                    </div>
                                </div>
                            </div><!--.form-group-->
                            <div class="form-group">
                                <div class="inputer">
                                    <div class="input-wrapper">
                                        <input type="password" id="password" class="form-control" placeholder="Enter your password" required>
                                    </div>
                                </div>
                            </div><!--.form-group-->
                        </div>
                        <div class="form-buttons clearfix">
                            <label class="pull-left"><input type="checkbox" name="remember" value="1"> Remember me</label>
                            <button onclick="login()" class="btn btn-success pull-right">Login</button>
                        </div><!--.form-buttons-->
                   
                </div><!--#login.panel-body-->

            </div><!--.blur-content-->
        </div><!--.login-screen-->
        
        <div class="bg-blur dark active">
		<div class="overlay"></div><!--.overlay-->
	</div><!--.bg-blur-->

        <svg version="1.1" xmlns='http://www.w3.org/2000/svg'>
    <filter id='blur'>
        <feGaussianBlur stdDeviation='7' />
    </filter>
    </svg>

    <!-- PLUGINS INITIALIZATION AND SETTINGS -->
    <script src="assets/globals/scripts/user-pages.js"></script>
    <!-- END PLUGINS INITIALIZATION AND SETTINGS -->

    <!-- PLEASURE Initializer -->
    <script src="assets/globals/js/pleasure.js"></script>
    <!-- ADMIN 1 Layout Functions -->
    <script src="assets/admin1/js/layout.js"></script>

    <!-- BEGIN INITIALIZATION-->
    <script>
        $(document).ready(function () {
            Pleasure.init();
            Layout.init();
            UserPages.login();
        });
    </script>
    <!-- END INITIALIZATION-->
</body>
</html>
