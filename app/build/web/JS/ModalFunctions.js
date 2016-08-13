function removeInput(id) {
    var elem = document.getElementById(id);
    elem.parentNode.removeChild(elem);
}

function closeModal(modalName) {
    var modal = document.getElementById(modalName);
    modal.style.display = "none";
}
function removeDom(id) {
    var elem = document.getElementById(id);
    var siblings = elem.previousSibling;
    elem.parentNode.removeChild(siblings);
    elem.parentNode.removeChild(elem);
}


