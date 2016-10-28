$('#email-table tbody td').click(function (e) {
    if (!$(this).parent().find(':checkbox').prop("checked"))
        return;

    alert("td clicked");
});

function moveTo(destFolder, type){
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
                if(rowCount <= 1){
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
                if(rowCount <= 1){
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
            recipientsTableHTML += "<tr><td style='text-align:right;vertical-align:top;'>From:</td><td style='vertical-align:top;'><b>" + data.from + "</b> <span><</span>" + data.fromAddress + "<span>></span></td></tr>";

            var toArray = data.to;
            if (toArray != null) {
                recipientsTableHTML += "<tr><td style='text-align:right;vertical-align:top;'>To:</td><td style='vertical-align:top;'>";
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
                recipientsTableHTML += "<tr><td style='text-align:right;vertical-align:top;'>Cc:</td><td style='vertical-align:top;'>";
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

            recipientsTableHTML += "<tr><td style='text-align:right;vertical-align:top;'>Date:</td><td style='vertical-align:top;'>" + data.fulldate + "</td></tr>";
            recipientsTableHTML += "<tr><td style='text-align:right;vertical-align:top;'>Subject:</td><td style='vertical-align:top;'>" + data.subject + "</td></tr>";

            recipientsTableHTML = "<div class='dropdown'><a data-toggle='dropdown' href='#'><img src='Images/arrow.png' height='12' width='12' style='padding: 0 0 1px 0;'></a><div class='dropdown-menu' style='width:500px; padding: 8px 16px 12px 16px;'>" + recipientsTableHTML + "</div></div>";


            document.getElementById("message-recipients").innerHTML = recipientsHTML + " " + recipientsTableHTML;
            document.getElementById("message-content").innerHTML = "<b>" + data.text + "</b>";
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
}