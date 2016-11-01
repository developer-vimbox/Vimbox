var notificationCounter = false;
var wsUrl = 'ws://' + window.location.host + ':8000/serverEndpoint';
console.log('WebSockets Url : ' + wsUrl);
var websocket = new WebSocket(wsUrl);
websocket.onmessage = function processMessage(message) {
    var jsonData = JSON.parse(message.data);
    if (jsonData.message != null) {
        var ul = document.getElementById("notifications-section");
        var append = "<li onclick=\"redirectNotification('" + jsonData.html + "')\"><span class='bg-blue icon-notification glyph-icon icon-user'></span>";
        append += "<span class='notification-text font-blue'>" + jsonData.message + "</span>";
        append += "<a onclick=\"clearSingleNotification('" + jsonData.message + "', this)\">x</a></li>";
        ul.innerHTML += append;
        if (!notificationCounter) {
            notificationCounter = true;
            var newSpan = document.createElement('span');
            newSpan.className = "small-badge bg-yellow";
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
    document.getElementById("notifications-section").innerHTML = "";
    $.get("ClearNotificationsController", {}, function (data) {
    });
}

function clearSingleNotification(message, e){
    event.stopPropagation();
    var li = e.parentNode;
    li.parentNode.removeChild(li);
    $.get("ClearSingleNotificationController", {message: message}, function (data) {
    });
}

function redirectNotification(html){
    window.location.href = html;
}
