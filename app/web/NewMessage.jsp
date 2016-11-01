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
            .email-box{
                height: 39px;
                font-size: 16px;
                display:inline-block;
                float:left;
                padding: 6px 10px;
                border: #dfe8f1 solid 1px;
                border-radius: 2px;
                box-shadow: inset 1px 1px 3px #f6f6f6;
            }
            
            .email-box a{
                cursor: pointer;
            }

            .email-text {
                height: 39px;
                width: 100%;
                padding: 4px 16px;
                font-size: 16px;
                line-height: 1.618;
                color: #555555;
                border: none;
                outline: none;
                box-shadow: none;
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
                                        <label class="col-sm-2 control-label">To:</label>
                                        <div class="col-sm-8" id="to_div" style="display:inline-block;border: 1px solid #cccccc;border-radius: 2px;box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);">
                                            <div style="float:right;width:100%;">
                                                <input type="text" id="to" class="email-text" onkeyup="validateEmail(this, 'to')">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label class="col-sm-2 control-label">CC:</label>
                                        <div class="col-sm-8" id="to_div" style="display:inline-block;border: 1px solid #cccccc;border-radius: 2px;box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);">
                                            <div style="float:right;width:100%;">
                                                <input type="text" id="cc" class="email-text" onkeyup="validateEmail(this, 'cc')">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label class="col-sm-2 control-label">BCC:</label>
                                        <div class="col-sm-8" id="to_div" style="display:inline-block;border: 1px solid #cccccc;border-radius: 2px;box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);">
                                            <div style="float:right;width:100%;">
                                                <input type="text" id="bcc" class="email-text" onkeyup="validateEmail(this, 'bcc')">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="inputEmail4" class="col-sm-2 control-label">Subject:</label>
                                        <div class="col-sm-8" id="to_div" style="display:inline-block;border: 1px solid #cccccc;border-radius: 2px;box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);">
                                            <div style="float:right;width:100%;">
                                                <input type="text" id="subject" class="email-text">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="inputEmail5" class="col-sm-2 control-label">Attachment(s):</label>
                                        <div class="col-sm-8" id="to_div" style="display:inline-block;border: 1px solid #cccccc;border-radius: 2px;box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);">
                                            <div style="float:right;width:100%;">
                                                <input type="file" id="attachments" class="email-text" multiple>
                                            </div>
                                        </div>
                                    </div>
                                </form>

                                <div class="pad15A">
                                    <div class="wysiwyg-editor"></div>
                                </div>

                                <div class="button-pane">
                                    <button class="btn btn-info" onclick="sendEmail()">Send mail</button>
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
