<!DOCTYPE html> 
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title> VIMBOX </title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <script src="JS/CustomerFunctions.js"></script>
        <script src="JS/TicketFunctions.js"></script>
        <script src="JS/ModalFunctions.js"></script>
    </head>
    <body>
        <%@include file="header.jsp"%>
        <div id="page-content-wrapper">
            <div id="page-content" style="min-height: 545px;">

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
                        <h2 class="mrg20B">Hi, Welcome!</h2>
                        <p class="mrg15B">--</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>