<%@page import="com.vimbox.util.Converter"%>
<%@page import="com.vimbox.customer.Customer"%>
<%@page import="com.vimbox.database.LeadDAO"%>
<%@page import="com.vimbox.sales.Lead"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Compose New Message</title>
        <style>
            .email-table tr{
                cursor: pointer;
            }
            #details-table td {
                padding: 10px;
            }
        </style>
    </head>
    <body>
        <%@include file="header.jsp"%>
        <script type="text/javascript" src="assets/widgets/summernote-wysiwyg/summernote-wysiwyg.js"></script>
        <script type="text/javascript">
        /* WYSIWYG editor */

        $(function () {
            "use strict";
            $('.wysiwyg-editor').summernote({
                height: 150
            });
        });
        </script>
        <div id="loading-submit"  style="display:none">
            <div id="loadingsubmit">
                <!--<img src="assets/image-resources/spin.gif">-->
                <div class="spinner">
                    <div class="bounce1"></div>
                    <div class="bounce2"></div>
                    <div class="bounce3"></div>
                </div>
            </div>
        </div>

        <div id="email_error_modal" class="modal">
            <div class="modal-content" style="width: 400px;">
                <div class="modal-header">
                    <span class="close" onclick="closeModal('email_error_modal')">×</span>
                    <center><h2><div id="email_error_status"></div></h2></center>
                </div>
                <div class="modal-body">
                    <div id="email_error_message"></div>
                </div>
            </div>
        </div>
        <div id="page-content-wrapper">
            <div id="page-content">
                <div class="container">
                    <div class="panel">
                        <div class="panel-body">
                            <div class="content-box">
                                <div class="mail-header clearfix">
                                    <div class="float-left">
                                        <span class="mail-title">Compose new message</span>
                                    </div>
                                    
                                </div>

                                <div class="divider"></div>
                                <form class="form-horizontal mrg15T" role="form">
                                    <div class="form-group row">
                                        <label for="inputEmail1" class="col-sm-2 control-label">To:</label>
                                        <div class="col-sm-8">
                                            <input type="email" class="form-control" id="inputEmail1" placeholder="">
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="inputEmail2" class="col-sm-2 control-label">CC:</label>
                                        <div class="col-sm-8">
                                            <input type="email" class="form-control" id="inputEmail2" placeholder="">
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="inputEmail3" class="col-sm-2 control-label">BCC:</label>
                                        <div class="col-sm-8">
                                            <input type="email" class="form-control" id="inputEmail3" placeholder="">
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="inputEmail4" class="col-sm-2 control-label">Subject:</label>
                                        <div class="col-sm-8">
                                            <input type="email" class="form-control" id="inputEmail4" placeholder="">
                                        </div>
                                    </div>
                                </form>

                                <div class="pad15A">
                                    <div class="wysiwyg-editor"></div>
                                </div>

                                <div class="button-pane">
                                    <button class="btn btn-info">Send mail</button>
                                    <button class="btn btn-link font-gray-dark">Cancel</button>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
