<!DOCTYPE html> 
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <!--[if IE]><meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'><![endif]-->
        <title> VIMBOX </title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <script src="JS/UserFunctions.js"></script>
        <script src="JS/ModalFunctions.js"></script>
    </head>
    <body>
        <%@include file="header.jsp"%>
        <%            String nric = user.getNric();
        %>
        <div id="messageModal" class="modal">
            <div class="message-modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeModal('messageModal')">×</span>
                    <div id="message-status"></div>
                    <hr>
                    <div id="message-content"></div>
                </div>
            </div>
        </div>
        <input type="hidden" id="user_id" value="<%=nric%>">

        <div id="page-content-wrapper">
            <div id="page-content">

                <div class="container">

                    <!-- Tocify -->

                    <!--<link rel="stylesheet" type="text/css" href="assets/widgets/tocify/tocify.css">-->
                    <script type="text/javascript" src="assets/widgets/sticky/sticky.js"></script>
                    <script type="text/javascript" src="assets/widgets/tocify/tocify.js"></script>

                    <script type="text/javascript">
                        $(function () {
                            var toc = $("#tocify-menu").tocify({context: ".toc-tocify", showEffect: "fadeIn", extendPage: false, selectors: "h2, h3, h4"});
                        });
                        jQuery(document).ready(function ($) {

                            /* Sticky bars */

                            $(function () {
                                "use strict";

                                $('.sticky-nav').hcSticky({
                                    top: 50,
                                    innerTop: 50,
                                    stickTo: 'document'
                                });

                            });

                        });
                    </script>

                    <div id="page-title">
                        <div class="panel">
                            <div class="panel-body">
                                <h3 class="title-hero">
                                    Change Password
                                </h3>

                                <div class="form-horizontal">
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Old Password: </label>
                                        <div class="col-sm-4">
                                            <input class="form-control" type="password" id="old_password">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">New Password: </label>
                                        <div class="col-sm-4">
                                            <input type="password" class="form-control" id="new_password">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">Confirm New Password: </label>
                                        <div class="col-sm-4">
                                            <input type="password" class="form-control" id="confirm_new_password">
                                            <span id="message"></span>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label"></label>
                                        <div class="col-sm-4 text-center">
                                            <button  type="submit" class="btn btn-primary" onclick="changePassword()">Change</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        $('#confirm_new_password').on('keyup', function () {
            if ($(this).val() == $('#new_password').val()) {
                $('#confirm_new_password').css('border-color', 'lime');
                $('#message').html("");
            }
            else {
                $('#confirm_new_password').css('border-color', 'red');
                $('#message').html("Passwords don\'t match");
            }
        });
    </script>


</div>
</body>
</html>