var valueEmpty = true;

$('#email-table tbody td').click(function (e) {
    if (!$(this).parent().find(':checkbox').prop("checked"))
        return;
});

function moveTo(destFolder, type) {
    var checkboxes = document.getElementsByName("mail-checkbox");
    var ids = [];
    var checkboxesChecked = "";
    // loop over them all
    for (var i = 0; i < checkboxes.length; i++) {
        // And stick the checked ones onto an array...
        if (checkboxes[i].checked) {
            checkboxesChecked += checkboxes[i].value;
            ids.push(checkboxes[i].value);
            if (i < checkboxes.length - 1) {
                checkboxesChecked += "|";
            }
        }
    }

    if (ids.length > 0) {
        var div = document.getElementById("loading-submit");
        jQuery.ajax({
            url: "MoveMessagesController",
            dataType: "json",
            data: {
                "type": type,
                "dest": destFolder,
                "mail": checkboxesChecked,
            },
            beforeSend: function () {
                div.style.display = "block";
            },
            success: function (data) {
                div.style.display = "none";
                for (var i = 0; i < ids.length; i++) {
                    console.log(ids[i]);
                    $('#' + ids[i]).remove();
                }
                var rowCount = $('#email-content tr').length;
                if (rowCount <= 1) {
                    var tr = "<tr><td colspan='6' style='text-align:center'>You have no " + type.substring(type.indexOf("/") + 1) + ".</td></tr>";
                    $(tr).prependTo("#email-content > tbody");
                }
            },
            error: function (data) {
                div.style.display = "none";
                var modal = document.getElementById("email_error_modal");
                var status = document.getElementById("email_error_status");
                var message = document.getElementById("email_error_message");
                status.innerHTML = "ERROR";
                message.innerHTML = data;
                modal.style.display = "block";
            }
        });
    }
}

function refresh(type) {
    $("#email-content tbody tr:not(#email-loading)").remove();
    $('#email-loading').show();
    loadMessages(type);
}

function deleteMail(type) {
    var checkboxes = document.getElementsByName("mail-checkbox");
    var ids = [];
    var checkboxesChecked = "";
    // loop over them all
    for (var i = 0; i < checkboxes.length; i++) {
        // And stick the checked ones onto an array...
        if (checkboxes[i].checked) {
            checkboxesChecked += checkboxes[i].value;
            ids.push(checkboxes[i].value);
            if (i < checkboxes.length - 1) {
                checkboxesChecked += "|";
            }
        }
    }

    if (ids.length > 0) {
        var div = document.getElementById("loading-submit");
        jQuery.ajax({
            url: "DeleteMessagesController",
            dataType: "json",
            data: {
                "type": type,
                "mail": checkboxesChecked,
            },
            beforeSend: function () {
                div.style.display = "block";
            },
            success: function (data) {
                div.style.display = "none";
                for (var i = 0; i < ids.length; i++) {
                    console.log(ids[i]);
                    $('#' + ids[i]).remove();
                }
                var rowCount = $('#email-content tr').length;
                if (rowCount <= 1) {
                    var tr = "<tr><td colspan='6' style='text-align:center'>You have no " + type.substring(type.indexOf("/") + 1) + ".</td></tr>";
                    $(tr).prependTo("#email-content > tbody");
                }
            },
            error: function (data) {
                div.style.display = "none";
                var modal = document.getElementById("email_error_modal");
                var status = document.getElementById("email_error_status");
                var message = document.getElementById("email_error_message");
                status.innerHTML = "ERROR";
                message.innerHTML = data;
                modal.style.display = "block";
            }
        });
    }
}

function loadMessages(type) {
    $.get("LoadMessagesController", {type: type}, function (data) {
        document.getElementById("email-loading").style.display = "none";
        var size = data.size;
        var counter = 0;
        var messages = data.messages;

        if (size === 0) {
            var tr = "<tr><td colspan='6' style='text-align:center'>You have no " + type.substring(type.indexOf("/") + 1) + ".</td></tr>";
            $(tr).prependTo("#email-content > tbody");
        } else {
            for (var i = 0; i < messages.length; i++) {
                var message = messages[i];
                var tr = "";
                var uid = message.uid;
                if (message.seen != null) {
                    tr += "<tr style='background-color:#e6e6e6' ";
                } else {
                    tr += "<tr ";
                }
                tr += "id='" + uid + "' onclick=\"viewMessage('" + uid + "', '" + type + "', this)\">";
                tr += "<td><input type='checkbox' name='mail-checkbox' value='" + uid + "' class='custom-checkbox' onclick='event.stopPropagation();'></td>";

                if (message.seen != null) {
                    tr += "<td class='email-title'>" + message.from + "</td>";
                    tr += "<td class='email-body' style='white-space: nowrap; text-overflow:ellipsis; overflow: hidden; max-width:1000px;'>" + message.subject + " - " + message.text + "</td>";
                } else {
                    tr += "<td class='email-title'><b>" + message.from + "</b></td>";
                    tr += "<td class='email-body' style='white-space: nowrap; text-overflow:ellipsis; overflow: hidden; max-width:1000px;'><b>" + message.subject + "</b> - " + message.text + "</td>";
                }
                if (message.attachment != null) {
                    tr += "<td><i class='glyph-icon icon-paperclip'></i></td>";
                } else {
                    tr += "<td></td>";
                }
                if (message.seen != null) {
                    tr += "<td>" + message.sentdate + "</td></tr>";
                } else {
                    tr += "<td><b>" + message.sentdate + "</b></td></tr>";
                }
                $(tr).prependTo("#email-content > tbody");
                counter++;
            }
        }
    });
}

function viewMessage(uId, type, tr) {
    $.get("ViewMessage.jsp", {}, function (data) {
        document.getElementById("message").innerHTML = data;
        var div = document.getElementById("loading-submit");
        jQuery.ajax({
            url: "ViewMessageController",
            dataType: "json",
            data: {
                "uid": uId,
                "type": type,
            },
            beforeSend: function () {
                div.style.display = "block";
            },
            success: function (data) {
                div.style.display = "none";
                tr.style.backgroundColor = "#e6e6e6";
                var tds = tr.getElementsByTagName("td");
                for (var i = 1; i < tds.length; i++) {
                    var td = tds[i];
                    var innerHTML = td.innerHTML;
                    var newHTML = innerHTML.substring(3, innerHTML.indexOf("</b>")) + innerHTML.substring(innerHTML.indexOf("</b>") + 4);
                    td.innerHTML = newHTML;
                }
                document.getElementById("message-subject").innerHTML = "<b>" + data.subject + "</b>";
                document.getElementById("message-from").innerHTML = "<b>" + data.from + "</b> <span><</span>" + data.fromAddress + "<span>></span>";
                document.getElementById("message-date").innerHTML = "<b>" + data.sentdate + "</b>";
                var recipientsHTML = "to ";
                var recipientsTableHTML = "<table width=100% id='details-table'><col width='10%'>";
                recipientsTableHTML += "<tr><td style='text-align:right;vertical-align:top;'>From:</td><td style='vertical-align:top;' id='from-table'><b>" + data.from + "</b> <span><</span>" + data.fromAddress + "<span>></span></td></tr>";

                var toArray = data.to;
                if (toArray != null) {
                    recipientsTableHTML += "<tr><td style='text-align:right;vertical-align:top;'>To:</td><td style='vertical-align:top;' id='to-table'>";
                    for (var i = 0; i < toArray.length; i++) {
                        var to = toArray[i].email;
                        if (i !== 0) {
                            recipientsHTML += ", ";
                        }
                        if (to.includes('"')) {
                            recipientsHTML += "me"
                        } else {
                            var index = to.indexOf(" ");
                            if (index < 0) {
                                recipientsHTML += to;
                            } else {
                                recipientsHTML += to.substring(0, to.indexOf(" "));
                            }
                        }

                        if (to.indexOf("<") >= 0) {
                            to = to.substring(0, to.indexOf("<")) + "<span><</span>" + to.substring(to.indexOf("<") + 1, to.indexOf(">")) + "<span>></span>";
                        }
                        recipientsTableHTML += to;
                        if (i < toArray.length - 1) {
                            recipientsTableHTML += ", ";
                        }
                    }
                    recipientsTableHTML += "</td></tr>";
                }


                var ccArray = data.cc;
                if (ccArray != null) {
                    recipientsTableHTML += "<tr><td style='text-align:right;vertical-align:top;'>Cc:</td><td style='vertical-align:top;' id='cc-table'>";
                    for (var i = 0; i < ccArray.length; i++) {
                        var cc = ccArray[i].email;
                        recipientsHTML += ", ";
                        if (cc.includes('"')) {
                            recipientsHTML += "me"
                        } else {
                            var index = cc.indexOf(" ");
                            if (index < 0) {
                                recipientsHTML += cc;
                            } else {
                                recipientsHTML += cc.substring(0, cc.indexOf(" "));
                            }
                        }

                        if (cc.indexOf("<") >= 0) {
                            cc = cc.substring(0, cc.indexOf("<")) + "<span><</span>" + cc.substring(cc.indexOf("<") + 1, cc.indexOf(">")) + "<span>></span>";
                        }

                        recipientsTableHTML += cc;
                        if (i < ccArray.length - 1) {
                            recipientsTableHTML += ", ";
                        }
                    }
                    recipientsTableHTML += "</td></tr>";
                }

                recipientsTableHTML += "<tr><td style='text-align:right;vertical-align:top;'>Date:</td><td style='vertical-align:top;' id='date-table'>" + data.fulldate + "</td></tr>";
                recipientsTableHTML += "<tr><td style='text-align:right;vertical-align:top;'>Subject:</td><td style='vertical-align:top;' id='subject-table'>" + data.subject + "</td></tr>";

                recipientsTableHTML = "<div class='dropdown'><a data-toggle='dropdown' href='#'><img src='Images/arrow.png' height='12' width='12' style='padding: 0 0 1px 0;'></a><div class='dropdown-menu' style='width:500px; padding: 8px 16px 12px 16px;'>" + recipientsTableHTML + "</div></div>";

                if (data.files != null) {
                    $('#message-files').val(data.files);
                    var files = data.files.split("|");
                    if (files.length > 0) {
                        var include = "";
                        for (var i = 0; i < files.length; i++) {
                            var fileName = files[i];
                            if (fileName) {
                                include += "<a href='" + fileName.substr(fileName.indexOf("attachments")) + "' download>" + fileName.substr(fileName.lastIndexOf("/") + 1) + "</a>";
                            }
                        }
                        document.getElementById("message-attachments").innerHTML = include;
                    }
                }

                document.getElementById("message-recipients").innerHTML = recipientsHTML + " " + recipientsTableHTML;
                document.getElementById("message-content").innerHTML = "<b>" + data.text + "</b>";
                document.getElementById("message-id").value = uId;
                document.getElementById("message-folder").value = type;
                document.getElementById("viewMessageModal").style.display = "block";
            },
            error: function (data) {
                div.style.display = "none";
                var modal = document.getElementById("email_error_modal");
                var status = document.getElementById("email_error_status");
                var message = document.getElementById("email_error_message");
                status.innerHTML = "ERROR";
                message.innerHTML = data;
                modal.style.display = "block";
            }
        });
    });
}

function sendEmail() {
    var data = new FormData();
    var files = $('#attachments').get(0).files;

    $.each(files, function (i, file) {
        data.append("file-" + i, file);
    });

    var to = $('#to').val();
    var tos = document.getElementsByName("to");
    var toAddr = "";
    for (var i = 0; i < tos.length; i++) {
        toAddr += tos[i].value;
        if (i < tos.length - 1) {
            toAddr += ",";
        }
    }
    if (to) {
        if (tos.length == 0) {
            toAddr += to;
        } else {
            toAddr += "," + to;
        }

    }

    var cc = $('#cc').val();
    var ccs = document.getElementsByName("cc");
    var ccAddr = "";
    for (var i = 0; i < ccs.length; i++) {
        ccAddr += ccs[i].value;
        if (i < ccs.length - 1) {
            ccAddr += ",";
        }
    }
    if (cc) {
        if (ccs.length == 0) {
            ccAddr += cc;
        } else {
            ccAddr += "," + to;
        }

    }

    var bcc = $('#bcc').val();
    var bccs = document.getElementsByName("bcc");
    var bccAddr = "";
    for (var i = 0; i < bccs.length; i++) {
        bccAddr += bccs[i].value;
        if (i < bccs.length - 1) {
            bccAddr += ",";
        }
    }
    if (bcc) {
        if (bccs.length == 0) {
            bccAddr += bcc;
        } else {
            bccAddr += "," + bcc;
        }

    }

    var subject = $('#subject').val();
    var content = document.getElementById("email-message").innerHTML;

    data.append('to', toAddr);
    data.append('cc', ccAddr);
    data.append('bcc', bccAddr);
    data.append('subject', subject);
    data.append('content', content);

    var div = document.getElementById("loading-submit");
    $.ajax({
        url: 'SendMessageController',
        type: 'POST',
        data: data,
        cache: false,
        dataType: 'json',
        processData: false, // Don't process the files
        contentType: false, // Set content type to false as jQuery will tell the server its a query string request
        beforeSend: function () {
            div.style.display = "block";
        },
        success: function (data, textStatus, jqXHR) {
            div.style.display = "none";
            var modal = document.getElementById("email_error_modal");
            var status = document.getElementById("email_error_status");
            var message = document.getElementById("email_error_message");
            status.innerHTML = data.status;
            message.innerHTML = data.message;
            modal.style.display = "block";

            if (data.status === "SUCCESS") {
                if (data.files != null) {
                    $.get("ClearFolderController", {files: data.files}, function (data) {
                    });
                }
                setTimeout(function () {
                    modal.style.display = "none";
                    location.reload();
                }, 800);
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            div.style.display = "none";
            var modal = document.getElementById("email_error_modal");
            var status = document.getElementById("email_error_status");
            var message = document.getElementById("email_error_message");
            status.innerHTML = "ERROR";
            message.innerHTML = textStatus;
            modal.style.display = "block";
        }
    });
}

function replyEmail() {
    var data = new FormData();
    var files = $('#attachments').get(0).files;

    $.each(files, function (i, file) {
        data.append("file-" + i, file);
    });

    var files = document.getElementsByName("files");
    var filesAddr = "";
    for (var i = 0; i < files.length; i++) {
        filesAddr += files[i].value;
        if (i < files.length - 1) {
            filesAddr += ",";
        }
    }

    var to = $('#to').val();
    var tos = document.getElementsByName("to");
    var toAddr = "";
    for (var i = 0; i < tos.length; i++) {
        toAddr += tos[i].value;
        if (i < tos.length - 1) {
            toAddr += ",";
        }
    }
    if (to) {
        if (tos.length == 0) {
            toAddr += to;
        } else {
            toAddr += "," + to;
        }

    }

    var cc = $('#cc').val();
    var ccs = document.getElementsByName("cc");
    var ccAddr = "";
    for (var i = 0; i < ccs.length; i++) {
        ccAddr += ccs[i].value;
        if (i < ccs.length - 1) {
            ccAddr += ",";
        }
    }
    if (cc) {
        if (ccs.length == 0) {
            ccAddr += cc;
        } else {
            ccAddr += "," + to;
        }

    }

    var bcc = $('#bcc').val();
    var bccs = document.getElementsByName("bcc");
    var bccAddr = "";
    for (var i = 0; i < bccs.length; i++) {
        bccAddr += bccs[i].value;
        if (i < bccs.length - 1) {
            bccAddr += ",";
        }
    }
    if (bcc) {
        if (bccs.length == 0) {
            bccAddr += bcc;
        } else {
            bccAddr += "," + bcc;
        }

    }

    var subject = $('#subject').val();
    var content = document.getElementById("email-message").innerHTML;
    var mId = $('#message-id').val();
    var folder = $('#message-folder').val();
    var action = $('#send-action').val();
    var filePaths = $('#message-files').val();

    data.append('files', filesAddr);
    data.append('to', toAddr);
    data.append('cc', ccAddr);
    data.append('bcc', bccAddr);
    data.append('subject', subject);
    data.append('content', content);
    data.append('mId', mId);
    data.append('folder', folder);
    data.append('action', action);
    data.append('filePaths', filePaths);

    var div = document.getElementById("loading-submit");
    $.ajax({
        url: 'ReplyMessageController',
        type: 'POST',
        data: data,
        cache: false,
        dataType: 'json',
        processData: false, // Don't process the files
        contentType: false, // Set content type to false as jQuery will tell the server its a query string request
        beforeSend: function () {
            div.style.display = "block";
        },
        success: function (data, textStatus, jqXHR) {
            div.style.display = "none";
            var modal = document.getElementById("email_error_modal");
            var status = document.getElementById("email_error_status");
            var message = document.getElementById("email_error_message");
            status.innerHTML = data.status;
            message.innerHTML = data.message;
            modal.style.display = "block";

            if (data.status === "SUCCESS") {
                var files = "";
                if (data.files != null) {
                    files = data.files;
                }
                closeMessageModal("viewMessageModal", files);
                setTimeout(function () {
                    location.reload();
                }, 800);
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            div.style.display = "none";
            var modal = document.getElementById("email_error_modal");
            var status = document.getElementById("email_error_status");
            var message = document.getElementById("email_error_message");
            status.innerHTML = "ERROR";
            message.innerHTML = textStatus;
            modal.style.display = "block";
        }
    });
}

function validateEmail(e, name) {
    var email = e.value;
    if (!email) {
        if (!valueEmpty) {
            valueEmpty = true;
        } else {
            var divs = document.getElementsByClassName("email-box " + name);
            var nameDiv = divs[divs.length - 1];
            if (nameDiv != null) {
                removeEmailBox(nameDiv.getElementsByTagName("A")[0], name);
            }
        }
    } else {
        valueEmpty = false;
    }
    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    var lastSpCh = email.lastIndexOf(" ");
    var lastCoCh = email.lastIndexOf(",");

    var lastSpTrue = (lastSpCh > 0 && lastSpCh == email.length - 1);
    var lastCoTrue = (lastCoCh > 0 && lastCoCh == email.length - 1);
    if (lastSpTrue || lastCoTrue) {
        if (lastSpTrue) {
            email = email.substr(0, lastSpCh);
        } else {
            email = email.substr(0, lastCoCh);
        }

        if (re.test(email)) {
            var div = "<div class='email-box " + name + "'><label>" + email + "</label><input type='hidden' name='" + name + "' value='" + email + "'/>&nbsp;&nbsp;&nbsp;<a onclick=\"removeEmailBox(this, '" + name + "')\">x</a></div>";
            $(e.parentNode).before(div);
            $(e).val('');
            var orgWidth = $(e.parentNode).outerWidth();
            var divs = document.getElementsByClassName("email-box " + name);
            var nameDiv = divs[divs.length - 1];

            if (orgWidth - ($(nameDiv).outerWidth() + 1) < 300) {
                var toDivWidth = $('#to_div').innerWidth();
                if (orgWidth - ($(nameDiv).outerWidth() + 1) < 0) {
                    var totalDivWidth = 0;
                    var divCount = 0;
                    var premature = false;
                    for (var i = 0; i < divs.length; i++) {
                        var emailBoxDiv = divs[i];
                        totalDivWidth += $(emailBoxDiv).outerWidth() + 1;

                        if (totalDivWidth > toDivWidth) {
                            divCount = i;
                            totalDivWidth = 0;
                            // same row //
                            if (totalDivWidth > toDivWidth - 300) {
                                premature = true;
                            } else { // next row //
                                totalDivWidth += $(emailBoxDiv).outerWidth() + 1;
                                premature = false;
                            }

                        }
                    }
                    orgWidth = toDivWidth - 20;
                    if (!premature) {
                        for (var i = divCount; i < divs.length; i++) {
                            var emailBoxDiv = divs[i];
                            orgWidth -= $(emailBoxDiv).outerWidth() + 1;
                        }
                    }
                } else {
                    orgWidth = toDivWidth - 20;
                }
            } else {
                orgWidth -= $(nameDiv).outerWidth() + 1;
            }

            $(e.parentNode).outerWidth(orgWidth);
        }
    }
}

function removeBox(e) {
    e.parentNode.parentNode.removeChild(e.parentNode);
}

function removeEmailBox(e, name) {
    var emailBoxDiv = e.parentNode;
    var inputDiv = document.getElementById(name).parentNode;
    var orgWidth = $(inputDiv).outerWidth();
    var resultingWidth = orgWidth + $(emailBoxDiv).outerWidth() + 1;
    emailBoxDiv.parentNode.removeChild(e.parentNode);

    var toDivWidth = $('#to_div').innerWidth();
    if (resultingWidth > toDivWidth - 20) {
        var divs = document.getElementsByClassName("email-box " + name);
        var totalDivWidth = 0;
        var divCount = 0;
        var premature = false;
        for (var i = 0; i < divs.length; i++) {
            var emailBoxDiv = divs[i];
            totalDivWidth += $(emailBoxDiv).outerWidth() + 1;

            if (totalDivWidth > toDivWidth) {
                divCount = i;
                totalDivWidth = 0;
                // same row //
                if (totalDivWidth > toDivWidth - 300) {
                    premature = true;
                } else { // next row //
                    totalDivWidth += $(emailBoxDiv).outerWidth() + 1;
                    premature = false;
                }

            }
        }
        orgWidth = toDivWidth - 20;
        if (!premature) {
            for (var i = divCount; i < divs.length; i++) {
                var emailBoxDiv = divs[i];
                orgWidth -= $(emailBoxDiv).outerWidth() + 1;
            }
        }
    } else {
        orgWidth = resultingWidth;
    }
    $(inputDiv).outerWidth(orgWidth);

}

function selectEmailAction(type) {
    var action = document.getElementById("send-action");
    var actionImg = document.getElementById("action-img");
    var subject = document.getElementById("message-subject").innerHTML;
    var rawSubject = subject.substring(3, subject.length - 4);
    switch (type) {
        case "r":
            action.value = "reply";
            actionImg.innerHTML = "<img src='Images/reply.png' height='30' width='30' style='padding: 0 0 3px 0;'>";
            document.getElementById("forward-content").style.display = "none";
            document.getElementById("email-message").innerHTML = "";
            break;
        case "ra":
            action.value = "replyall";
            actionImg.innerHTML = "<img src='Images/replyall.png' height='30' width='30' style='padding: 0 0 3px 0;'>";
            document.getElementById("forward-content").style.display = "none";
            document.getElementById("email-message").innerHTML = "";
            break;
        case "f":
            action.value = "forward";
            var files = $('#message-files').val().split("|");
            var div = "";
            for (var i = 0; i < files.length; i++) {
                if (files[i]) {
                    div += "<div class='email-box'><label>" + files[i].substr(files[i].lastIndexOf("/") + 1) + "</label><input type='hidden' name='files' value='" + files[i] + "'/>&nbsp;&nbsp;&nbsp;<a onclick=\"removeBox(this)\">x</a></div>"
                }
            }
            var fwdMessage = "<br><br>---------- Forwarded message ----------<br>";
            fwdMessage += "From: " + document.getElementById("from-table").innerHTML + "<br>";
            fwdMessage += "Date: " + document.getElementById("date-table").innerHTML + "<br>";
            fwdMessage += "Subject: " + document.getElementById("subject-table").innerHTML + "<br>";
            fwdMessage += "To: " + document.getElementById("to-table").innerHTML + "<br>";
            if (document.getElementById("cc-table") != null) {
                fwdMessage += "Cc: " + document.getElementById("cc-table").innerHTML + "<br>";
            }
            fwdMessage += "<br>" + document.getElementById("message-content").innerHTML;
            document.getElementById("email-message").innerHTML = fwdMessage;

            document.getElementById("files-div").innerHTML = div + document.getElementById("files-div").innerHTML;
            actionImg.innerHTML = "<img src='Images/forward.png' height='25' width='30' style='padding: 3px 2px 0 0;'>";
            if (rawSubject.includes("Re:")) {
                rawSubject = "Fwd" + rawSubject.substring(rawSubject.indexOf(":"));
            } else if (!rawSubject.includes("Fwd:")) {
                rawSubject = "Fwd: " + rawSubject;
            }
            $('#subject').val(rawSubject);
            document.getElementById("forward-content").style.display = "block";
            break;
    }
    document.getElementById("send-btn").disabled = false;
}

function closeMessageModal(name, files) {
    if (files) {
        $.get("ClearFolderController", {files: files}, function (data) {
        });
    }

    document.getElementById(name).style.display = "none";
}