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
        <title>Spam</title>
        <style>
            .email-table tr{
                cursor: pointer;
            }
            #details-table td {
                padding: 10px;
            }
        </style>
    </head>
    <body onload="loadMessages('[Gmail]/Spam')">
        <%@include file="header.jsp"%>
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
        <div id="viewMessageModal" class="modal">
            <!-- Modal content -->
            <div class="modal-content">
                <div class="modal-body">
                    <span class="close" onclick="closeMessageModal('viewMessageModal', $('#message-files').val())">×</span>
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
                    <div id="message">
                    </div>
                    <div style="width:100%;padding:10px 0px">
                        <div class="wysiwyg-editor"></div>
                    </div>
                    <div class="bg-default text-center">
                        <button class="btn loading-button btn-primary" disabled id="send-btn" onclick="replyEmail()">Send</button>
                    </div>
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
                                <div class="mail-header clearfix row">
                                    <div class="col-md-8">
                                        <span class="mail-title">Spam</span>
                                    </div>
                                    <div class="float-right col-md-4 pad0A">
                                        <div class="input-group">
                                            <input type="text" class="form-control">
                                            <div class="input-group-btn">
                                                <button type="button" class="btn btn-default" tabindex="-1">
                                                    <i class="glyph-icon icon-search"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="mail-toolbar clearfix">
                                    <div class="float-left">
                                        <a class="btn btn-default mrg5R" onclick="refresh('[Gmail]/Spam')">
                                            <i class="glyph-icon font-size-11 icon-refresh"></i>
                                        </a>
                                        <a class="btn btn-default mrg5R" onclick="deleteMail('[Gmail]/Spam')">
                                            <i class="glyphicon glyphicon-trash"></i>
                                        </a>
                                        <div class="dropdown">
                                            <a class="btn btn-default" data-toggle="dropdown">
                                                <i class="glyphicon glyphicon-folder-close"></i>
                                                <i class="glyph-icon icon-chevron-down"></i>
                                            </a>
                                            <ul class="dropdown-menu float-right">
                                                <%
                                                    String[] folders = new String[]{"Inbox", "[Gmail]/Sent Mail", "[Gmail]/Drafts"};
                                                    for(String folder : folders){
                                                %>
                                                    <li>
                                                        <a onclick="moveTo('<%=folder%>', '[Gmail]/Spam')">
                                                            <%=folder.substring(folder.indexOf("/") + 1)%>
                                                        </a>
                                                    </li>
                                                <%
                                                    }
                                                %>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="float-right">
                                        <div class="btn-toolbar">
                                            <div class="btn-group">
                                                <div class="size-md mrg10R">
                                                    1 to 11 of 21 entries
                                                </div>
                                            </div>
                                            <div class="btn-group">
                                                <a href="#" class="btn btn-default">
                                                    <i class="glyph-icon icon-angle-left"></i>
                                                </a>
                                                <a href="#" class="btn btn-default">
                                                    <i class="glyph-icon icon-angle-right"></i>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <table class="table table-hover text-center email-table" id="email-content">
                                    <tbody>
                                        <tr id="email-loading" height="300">
                                            <td colspan="6" style="text-align:center;vertical-align:middle;">
                                                <img src="Images/loadingGears.gif" height="100" width="100">
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
