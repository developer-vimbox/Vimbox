var counter = 2;
function addInput(divName) {
    var original = document.getElementById('additionalAssigned');
    var clone = original.cloneNode(true);
    while (document.getElementById("additionalAssigned" + counter) != null) {
        counter++;
    }
    clone.id = "additionalAssigned" + counter;
    document.getElementById(divName).appendChild(clone);
}

function removeAdditional(e) {
    var elem = e.closest('div');
    elem.parentNode.removeChild(elem);
}

function submitTicket() {
    var customer_id = $('#customer_id').val();
    var assigned_users = "";
    $(document.getElementsByName("assigned")).each(function () {
        var activeElement = this;
        var tagname = activeElement.tagName;
        var divId = activeElement.id;
        while (tagname !== 'DIV' || (divId !== "additionalAssigned" && divId !== "dynamicInput")) {
            activeElement = activeElement.parentNode;
            tagname = activeElement.tagName;
            divId = activeElement.id;
        }
        
        if (divId !== "additionalAssigned") {
            assigned_users += ($(this).val() + "|");
        }
    });
    var subject = $('#subject').val();
    var description = $('#description').val();

    var errorModal = document.getElementById("ticket_error_modal");
    var errorStatus = document.getElementById("ticket_error_status");
    var errorMessage = document.getElementById("ticket_error_message");
    $.getJSON("CreateTicketController", {customer_id: customer_id, assigned_users: assigned_users, subject: subject, description: description})
            .done(function (data) {
                var status = data.status;
                var errorMsg = data.message;
                errorStatus.innerHTML = status;
                errorMessage.innerHTML = errorMsg;
                errorModal.style.display = "block";
                if (status === "SUCCESS") {
                    setTimeout(function () {
                        window.location = "MyTickets.jsp"
                    }, 500);
                    sendNotification(data.notification);
                }
            })
            .fail(function (error) {
                errorStatus.innerHTML = "ERROR";
                errorMessage.innerHTML = error;
                errorModal.style.display = "block";
            });
}

function editTicket(ticket_id) {
    var modal = document.getElementById("edit_ticket_modal");
    var content = document.getElementById("edit_ticket_content");
    $.post("EditTicket.jsp", {ticket_id: ticket_id}, function (data) {
        content.innerHTML = data;
    });
    modal.style.display = "block";
}

function updateTicket() {
    var ticket_id = $('#ticket_id').val();
    var customer_id = $('#customer_id').val();
    var assigned_users = "";
    $(document.getElementsByName("assigned")).each(function () {
        if (this.closest('div').id !== "additionalAssigned") {
            assigned_users += ($(this).val() + "|");
        }
    });
    var subject = $('#subject').val();
    var description = $('#description').val();
    var datetime_of_creation = $('#datetime_of_creation').val();

    var errorModal = document.getElementById("ticket_error_modal");
    var errorStatus = document.getElementById("ticket_error_status");
    var errorMessage = document.getElementById("ticket_error_message");
    $.getJSON("EditTicketController", {ticket_id: ticket_id, customer_id: customer_id, assigned_users: assigned_users, subject: subject, description: description, datetime_of_creation: datetime_of_creation})
            .done(function (data) {
                var status = data.status;
                var errorMsg = data.message;
                errorStatus.innerHTML = status;
                errorMessage.innerHTML = errorMsg;
                errorModal.style.display = "block";
                if (status === "SUCCESS") {
                    setTimeout(function () {
                        location.reload()
                    }, 500);
                    sendNotification(data.notification);
                }
            })
            .fail(function (error) {
                errorStatus.innerHTML = "ERROR";
                errorMessage.innerHTML = error;
                errorModal.style.display = "block";
            });
}

function viewTicket(ticket_id) {
    var modal = document.getElementById("viewTicketModal");
    var content = document.getElementById("viewTicketModalContent");
    $.get("RetrieveTicket.jsp", {getTid: ticket_id}, function (data) {
        content.innerHTML = data;
    });
    modal.style.display = "block";
}

function closeTicket(ticket_id) {
    var modal = document.getElementById("resolveModal" + ticket_id);
    modal.style.display = "block";
}

function resolveTicket(ticket_id) {
    var resolve_ticket_id = $('#resolve_ticket_id' + ticket_id).val();
    var resolve_ticket_solution = $('#resolve_ticket_solution' + ticket_id).val();

    var errorModal = document.getElementById("ticket_error_modal");
    var errorStatus = document.getElementById("ticket_error_status");
    var errorMessage = document.getElementById("ticket_error_message");
    $.getJSON("ResolveTicketController", {resolve_ticket_id: resolve_ticket_id, resolve_ticket_solution: resolve_ticket_solution})
            .done(function (data) {
                var status = data.status;
                var errorMsg = data.message;
                errorStatus.innerHTML = status;
                errorMessage.innerHTML = errorMsg;
                errorModal.style.display = "block";
                if (status === "SUCCESS") {
                    setTimeout(function () {
                        location.reload()
                    }, 500);
                    sendNotification(data.notification);
                }
            })
            .fail(function (error) {
                errorStatus.innerHTML = "ERROR";
                errorMessage.innerHTML = error;
                errorModal.style.display = "block";
            });
}

function commentTicket(ticketId) {
    var modal = document.getElementById("commentModal" + ticketId);
    modal.style.display = "block";
}

function followupTicket(ticket_id) {
    var comment_ticket_id = $('#comment_ticket_id' + ticket_id).val();
    var ticket_comment = $('#ticket_comment' + ticket_id).val();

    var errorModal = document.getElementById("ticket_error_modal");
    var errorStatus = document.getElementById("ticket_error_status");
    var errorMessage = document.getElementById("ticket_error_message");
    $.getJSON("TicketCommentController", {comment_ticket_id: comment_ticket_id, ticket_comment: ticket_comment})
            .done(function (data) {
                var status = data.status;
                var errorMsg = data.message;
                errorStatus.innerHTML = status;
                errorMessage.innerHTML = errorMsg;
                errorModal.style.display = "block";
                if (status === "SUCCESS") {
                    $('#ticket_comment' + ticket_id).val("");
                    document.getElementById("commentModal" + ticket_id).style.display = "none";
                }
            })
            .fail(function (error) {
                errorStatus.innerHTML = "ERROR";
                errorMessage.innerHTML = error;
                errorModal.style.display = "block";
            });
}

function viewComments(ticketId) {
    var modal = document.getElementById("viewCommentsModal");
    var content = document.getElementById("commentsContent");
    $.get("RetrieveTicketComment.jsp", {getTid: ticketId}, function (data) {
        content.innerHTML = data;
    });
    modal.style.display = "block";
}

function initForum(){
    searchPending('');
    searchResolved('');
}

function searchPending(kw) {
    var pkwDiv = document.getElementById("pending");
    $.get("SearchTickets.jsp", {getKeyword: kw, getStatus: "pending"}, function (data) {
        pkwDiv.innerHTML = data;
        $('.javascript').each(function() {
      eval($(this).text());
    });
    });
}

function searchResolved(kw) {
    var rkwDiv = document.getElementById("resolved");
    $.get("SearchTickets.jsp", {getKeyword: kw, getStatus: "resolved"}, function (data) {
        rkwDiv.innerHTML = data;
        $('.javascript').each(function() {
      eval($(this).text());
    });
    });
}

function viewTicketsHistory(custId) {
    var modal = document.getElementById("ticketsHistoryModal");
    var ticketsHistoryContent = document.getElementById("ticketsHistoryContent");
    $.get("TicketsHistory.jsp", {getId: custId}, function (data) {
        ticketsHistoryContent.innerHTML = data;
        $('.javascript').each(function() {
      eval($(this).text());
    });
    });
    modal.style.display = "block";
}

