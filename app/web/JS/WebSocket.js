var notificationCounter = false;
var wsUrl = 'ws://' + window.location.host + ':8000/serverEndpoint';
console.log('WebSockets Url : ' + wsUrl);
var websocket = new WebSocket(wsUrl);
websocket.onmessage = function processMessage(message) {
    var jsonData = JSON.parse(message.data);
    if (jsonData.message != null) {
        var ul = document.getElementById("notifications-section");
        var append = "<li><span class='bg-blue icon-notification glyph-icon icon-user'></span>";
        append += "<span class='notification-text font-blue'>" + jsonData.message + "</span></li>";
        ul.innerHTML += append;
        if (!notificationCounter) {
            notificationCounter = true;
            var newSpan = document.createElement('span');
            newSpan.class = "small-badge bg-yellow";
            newSpan.id = "notifications-tag";
            document.getElementById("notifications-a").appendChild(newSpan);
        }
    }
}

function sendNotification(message) {
    websocket.send(message);
}

function viewNotifications() {
    notificationCounter = false;
    $.get("ViewNotificationsController", {}, function (data) {
        var element = document.getElementById("notifications-tag");
        if (element != null) {
            element.parentNode.removeChild(element);
        }
    });
}

function clearNotifications() {
    $.get("ClearNotificationsController", {}, function (data) {
        document.getElementById("notifications-section").innerHTML = "";
    });
}


