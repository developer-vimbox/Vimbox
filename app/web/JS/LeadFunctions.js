var toggleCounter = 0;

var formula = {};
var symbols = ["+", "-", "/", "x"];
var additionalCharges = 0;
var materialCharges = 0;
var totalUnits = 0;
var boxes = 0;
var manpower = {};
var domCounter = 2;
function addDom(divName) {
    var newdiv = document.createElement('div');
    var stringDiv = "";
    stringDiv += "<div id='" + domCounter + "'><table class='dynamicDomTable'><tr><td><input type='date' name='dom'></td><td><input type='button' value='x' onClick='removeInput(" + domCounter + ");'></td></tr></table></div>";
    newdiv.innerHTML = stringDiv;
    document.getElementById(divName).appendChild(newdiv);
    domCounter++;
}

function addFollowup(leadId) {
    var modal = document.getElementById("commentModal" + leadId);
    modal.style.display = "block";
}

function followupLead(lead_id) {
    var comment_lead_id = $('#comment_lead_id' + lead_id).val();
    var comment_lead_followup = $('#comment_lead_followup' + lead_id).val();
    var errorModal = document.getElementById("lead_error_modal");
    var errorStatus = document.getElementById("lead_error_status");
    var errorMessage = document.getElementById("lead_error_message");
    $.getJSON("LeadFollowupController", {comment_lead_id: comment_lead_id, comment_lead_followup: comment_lead_followup})
            .done(function (data) {
                var status = data.status;
                var errorMsg = data.message;
                errorStatus.innerHTML = status;
                errorMessage.innerHTML = errorMsg;
                errorModal.style.display = "block";
                if (status === "SUCCESS") {
                    $('#comment_lead_id' + lead_id).val("");
                    document.getElementById("commentModal" + lead_id).style.display = "none";
                }
            })
            .fail(function (error) {
                errorStatus.innerHTML = "ERROR";
                errorMessage.innerHTML = error;
                errorModal.style.display = "block";
            });
}

function viewLead(leadId) {
    var modal = document.getElementById("viewLeadModal" + leadId);
    var content = document.getElementById("leadContent" + leadId);
    $.get("RetrieveLeadDetails.jsp", {getLid: leadId}, function (data) {
        content.innerHTML = data;
    });
    modal.style.display = "block";
}

function viewFollowups(leadId) {
    var modal = document.getElementById("viewCommentsModal" + leadId);
    var div1 = document.getElementById("commentsContent" + leadId);
    $.get("RetrieveLeadFollowup.jsp", {getLid: leadId}, function (data) {
        div1.innerHTML = data;
    });
    modal.style.display = "block";
}

function viewLeadsHistory(custId) {
    var modal = document.getElementById("leadsHistoryModel");
    var leadsHistoryContent = document.getElementById("leadsHistoryContent");
    $.get("LeadsHistory.jsp", {getId: custId}, function (data) {
        leadsHistoryContent.innerHTML = data;
    });
    modal.style.display = "block";
}

//------------------------- LeadType Functions---------------------------//
function  checkLeadInformation() {
    var el = document.getElementById('leadInfo');
    var tops = el.getElementsByTagName('input');
    for (var i = 0, len = tops.length; i < len; i++) {
        if (tops[i].type === 'checkbox') {
            tops[i].onclick = showDiv;
            if (tops[i].checked) {
                tops[i].click();
                tops[i].click();
            }
        }
    }
}

function showDiv(e) {
    var divId = this.value.replace(" ", "");
    var div = document.getElementById(divId);
    if (this.checked) {
        div.style.display = "block";
        $('#' + divId).scrollView();
    } else {
        div.style.display = "none";
    }
}

$.fn.scrollView = function () {
    return this.each(function () {
        $('html, body').animate({
            scrollTop: $(this).offset().top
        }, 1000);
    });
}
//--------------------------------End-----------------------------------//             
function edit_leadSetup() {
    $('#customerItemsTable > tbody  > tr').each(function () {
        var inputs = this.getElementsByTagName("input");
        var name = inputs[0].value;
        if (name === "Boxes") {
            boxes += Number(inputs[4].value);
        }
        var charges = inputs[2].value;
        if (!isNaN(charges)) {
            additionalCharges += Number(charges);
        }
        totalUnits += Number(inputs[4].value);
    });
    $('#vimboxItemsTable > tbody  > tr').each(function () {
        var inputs = this.getElementsByTagName("input");
        var name = inputs[0].value;
        if (name === "Boxes") {
            boxes += Number(inputs[4].value);
            totalUnits += Number(inputs[4].value);
        }
        var charges = inputs[2].value;
        if (!isNaN(charges)) {
            materialCharges += Number(charges);
        }
    });
    var svcs = [];
    $('#servicesTable > tbody  > tr').each(function () {
        var inputs = this.getElementsByTagName("input");
        var id = $(this).attr('id');
        formula[id] = inputs[2].value;
        var table = this.getElementsByTagName("table");
        $(table).append("<tr>" + generateBreakdown(id) + "</tr>");
        svcs.push(id);
    });
    $('#serviceTable > tbody  > tr > td').each(function () {
        var cellHtml = this.innerHTML.trim();
        var inputs = this.getElementsByTagName('input');
        if (cellHtml) {
            var serviceCharge = cellHtml.substring(cellHtml.indexOf("{") + 1, cellHtml.lastIndexOf("}"));
            var serviceArray = serviceCharge.split(",");
            var svcSplit = serviceArray[0].split("|");
            var pri = svcSplit[0];
            var sec = svcSplit[1];
            var id = (pri + "_" + sec).replace(" ", "_");
            if (svcs.indexOf(id) > -1) {
                $(this).addClass('selected');
                $(this).data('state', 'selected');
            }

            if (inputs[1] != null) {
                if (!isNaN(inputs[1].value) && Number(inputs[1].value) > 0) {
                    manpower[inputs[0].value] = Number(inputs[1].value);
                }
            }
        }
    });
    document.getElementById('totalUnits').innerHTML = "Total Units : " + totalUnits;
    update_services();
    checkLeadInformation();
}

function create_leadSetup() {
    checkLeadInformation();

}

function showfield(name) {
    if (name == 'Others') {
        document.getElementById('referralOthers').innerHTML = 'Others: <input type="text" name="referralOthers" />';
    } else {
        document.getElementById('referralOthers').innerHTML = '';
    }
}

$("#servicesTable tbody").on("change keyup paste", "tr", function (event) {
    update_total();
});
$(document).on('change keyup paste', '#markup', function () {
    update_total();
});
$(document).on('change keyup paste', '#pushCharge', function () {
    update_total();
});
$(document).on('change keyup paste', '#materialCharge', function () {
    update_total();
});
$(document).on('change keyup paste', '#storeyCharge', function () {
    update_total();
});
$(document).on('change keyup paste', '#detourCharge', function () {
    update_total();
});
$(document).on('change keyup paste', '#discount', function () {
    update_total();
});

function update_services() {
    $('#servicesTable > tbody  > tr').each(function () {
        update_service(this);
    });
    //just update the total to sum    
}

function calculate(sum, symbol, variable) {
    switch (symbol) {
        case "x":
            sum = sum * variable;
            break;
        case "/":
            sum = Math.ceil(sum / variable);
            break;
        case "+":
            sum += variable;
            break;
        case "-":
            sum -= variable;
            break;
    }
    return sum;
}
function update_service(element) {
    var id = $(element).attr("id");
    var fml = formula[id].split(" ");
    var symbol;
    var sum;
    for (i = 0; i < fml.length; i++) {
        var action = fml[i];
        if (i === 0) {
            if (isNaN(action)) {
                switch (action) {
                    case "U":
                        sum = totalUnits;
                        break;
                    case "B":
                        sum = boxes;
                        break;
                    case "AC":
                        sum = additionalCharges;
                        break;
                    case "MP":
                        sum = manpower[id];
                        break;
                }
            } else {
                sum = action;
            }
        } else {
            if (symbols.indexOf(action) !== -1) {
                symbol = action;
            } else {
                if (isNaN(action)) {
                    switch (action) {
                        case "U":
                            sum = calculate(sum, symbol, totalUnits);
                            break;
                        case "B":
                            sum = calculate(sum, symbol, boxes);
                            break;
                        case "AC":
                            sum = calculate(sum, symbol, additionalCharges);
                            break;
                        case "MP":
                            sum = calculate(sum, symbol, manpower[id]);
                            break;
                    }
                } else {
                    sum = calculate(sum, symbol, action);
                }
            }
        }
    }

    var input = $(element).find("input")[1];
    $(input).val(Number(sum).toFixed(2));
    for (i = 0; i < fml.length; i++) {
        var action = fml[i];
        switch (action) {
            case "U":
                var label = id + "unitsLbl";
                $('#' + label).html(totalUnits);
                break;
            case "B":
                var label = id + "boxesLbl";
                $('#' + label).html(boxes);
                break;
            case "AC":
                var label = id + "acLbl";
                $('#' + label).html(additionalCharges);
                break;
            case "MP":
                var label = id + "mpLbl";
                $('#' + label).html(manpower[id]);
                break;
        }
    }

    update_total();
}

function update_total() {
    var sum = 0;
    $('#servicesTable > tbody  > tr').each(function () {
        sum += Number(this.getElementsByTagName("input")[1].value);
    });
    sum += (Number($('#markup').val()) + Number($('#materialCharge').val()) + Number($('#pushCharge').val()) + Number($('#storeyCharge').val()) + Number($('#detourCharge').val()) - Number($('#discount').val()));
    $('#totalPrice').val(Number(sum).toFixed(2));
}

function addUnits(unit) {
    totalUnits = totalUnits + unit;
    document.getElementById('totalUnits').innerHTML = "Total Units : " + totalUnits;
}

function subtractUnits(unit) {
    totalUnits = totalUnits - unit;
    document.getElementById('totalUnits').innerHTML = "Total Units : " + totalUnits;
}
//----------------------Customer Item Functions-------------------------//
function addCustomerBox() {
    var boxUnit = $('#customerBoxUnit').val();
    var errorMsg = "";
    var add = true;
    if (!boxUnit) {
        add = false;
        errorMsg += "Please enter a quantity<br>";
    }
    if (add) {
        var tr = "<tr><td>Boxes<input type='hidden' name='customerItemName' value='Boxes'></td>";
        tr += "<td>&nbsp;<input type='hidden' name='customerItemRemark' value=''></td>";
        tr += "<td align='center'>&nbsp;&nbsp;&nbsp;&nbsp;<input type='hidden' name='customerItemCharge' value=''></td>";
        tr += "<td align='center'>" + boxUnit + "<input type='hidden' name='customerItemQty' value='" + boxUnit + "'></td>";
        tr += "<td align='center'>" + boxUnit + "<input type='hidden' name='customerItemUnit' value='" + boxUnit + "'></td>";
        tr += "<td align='right'><input type='button' value='x' onclick='deleteBox(this)'/></td></tr>";
        $(tr).prependTo("#customerItemsTable > tbody");
        addUnits(Number(boxUnit));
        boxes += (Number(boxUnit));
        $('#customerBoxUnit').val("");
        update_services();
    } else {
        var modal = document.getElementById("salesModal");
        var salesStatus = document.getElementById("salesStatus");
        var salesMessage = document.getElementById("salesMessage");
        salesStatus.innerHTML = "<b>ERROR</b>";
        salesMessage.innerHTML = errorMsg;
        modal.style.display = "block";
    }
}

function addItem() {
    var itemName = $('#itemName').val();
    var itemUnit = $('#itemUnit').val();
    var itemQty = $('#itemQty').val();
    var itemRemark = $('#itemRemark').val();
    var errorMsg = "";
    var add = true;
    if (!itemName) {
        add = false;
        errorMsg += "Please enter an item<br>";
    }
    if (!itemUnit) {
        add = false;
        errorMsg += "Please enter an unit<br>";
    }
    if (!itemQty) {
        add = false;
        errorMsg += "Please enter an quantity<br>";
    }

    if (add) {
        itemUnit = itemUnit * itemQty;
        var tr = "<tr><td>" + itemName + "<input type='hidden' name='customerItemName' value='" + itemName + "'></td>";
        tr += "<td>" + itemRemark + "<input type='hidden' name='customerItemRemark' value='" + itemRemark + "'></td>";
        tr += "<td align='center'>&nbsp;&nbsp;&nbsp;&nbsp;<input type='hidden' name='customerItemCharge' value=''></td>";
        tr += "<td align='center'>" + itemQty + "<input type='hidden' name='customerItemQty' value='" + itemQty + "'></td>";
        tr += "<td align='center'>" + itemUnit + "<input type='hidden' name='customerItemUnit' value='" + itemUnit + "'></td>";
        tr += "<td align='right'><input type='button' value='x' onclick='deleteItem(this)'/></td></tr>";
        $(tr).prependTo("#customerItemsTable > tbody");
        addUnits(Number(itemUnit));
        $('#itemName').val("");
        $('#itemUnit').val("");
        $('#itemQty').val("");
        $('#itemRemark').val("");
        $('#itemName').focus();
        update_services();
    } else {
        var modal = document.getElementById("salesModal");
        var salesStatus = document.getElementById("salesStatus");
        var salesMessage = document.getElementById("salesMessage");
        salesStatus.innerHTML = "<b>ERROR</b>";
        salesMessage.innerHTML = errorMsg;
        modal.style.display = "block";
    }
}
function addSpecialItem() {
    var itemName = $('#specialItemName').val();
    var itemCharges = $('#specialItemCharges').val();
    var itemUnit = $('#specialItemUnit').val();
    var itemQty = $('#specialItemQty').val();
    var itemRemark = $('#specialItemRemark').val();
    var add = true;
    var errorMsg = "";
    if (!itemName) {
        add = false;
        errorMsg += "Please enter a special item<br>";
    }
    if (!itemUnit) {
        add = false;
        errorMsg += "Please enter an unit<br>";
    }
    if (!itemQty) {
        add = false;
        errorMsg += "Please enter an quantity<br>";
    }

    if (add) {
        itemUnit = itemUnit * itemQty;
        itemName = "Special - " + itemName;
        var tr = "<tr><td>" + itemName + "<input type='hidden' name='customerItemName' value='" + itemName + "'></td>";
        tr += "<td>" + itemRemark + "<input type='hidden' name='customerItemRemark' value='" + itemRemark + "'></td>";
        tr += "<td align='center'>" + itemCharges + "<input type='hidden' name='customerItemCharge' value='" + itemCharges + "'></td>";
        tr += "<td align='center'>" + itemQty + "<input type='hidden' name='customerItemQty' value='" + itemQty + "'></td>";
        tr += "<td align='center'>" + itemUnit + "<input type='hidden' name='customerItemUnit' value='" + itemUnit + "'></td>";
        tr += "<td align='right'><input type='button' value='x' onclick='deleteItem(this)'/></td></tr>";
        $(tr).prependTo("#customerItemsTable > tbody");
        additionalCharges += (Number(itemCharges));
        addUnits(Number(itemUnit));
        $('#specialItemName').val("");
        $('#specialItemCharges').val("");
        $('#specialItemUnit').val("");
        $('#specialItemQty').val("");
        $('#specialItemRemark').val("");
        $('#specialItemName').focus();
        update_services();
    } else {
        var modal = document.getElementById("salesModal");
        var salesStatus = document.getElementById("salesStatus");
        var salesMessage = document.getElementById("salesMessage");
        salesStatus.innerHTML = "<b>ERROR</b>";
        salesMessage.innerHTML = errorMsg;
        modal.style.display = "block";
    }
}
function deleteItem(btn) {
    var row = btn.parentNode.parentNode;
    var nodes = row.childNodes;
    var unit = nodes[4].innerHTML.substring(0, nodes[4].innerHTML.indexOf("<"));
    subtractUnits(Number(unit));
    var charge = nodes[2].innerHTML.substring(0, nodes[2].innerHTML.indexOf("<"));
    if (!isNaN(charge)) {
        additionalCharges -= Number(charge);
    }
    row.parentNode.removeChild(row);
    update_services();
}
//--------------------------------End-----------------------------------//

//-----------------------Vimbox Item Functions--------------------------//
function addVimboxBox() {
    var boxUnit = $('#vimboxBoxUnit').val();
    var errorMsg = "";
    var add = true;
    if (!boxUnit) {
        add = false;
        errorMsg += "Please enter an unit<br>";
    }

    if (add) {
        var tr = "<tr><td>Boxes<input type='hidden' name='vimboxItemName' value='Boxes'></td>";
        tr += "<td>&nbsp;<input type='hidden' name='vimboxItemRemark' value=''></td>";
        tr += "<td align='center'>&nbsp;&nbsp;&nbsp;&nbsp;<input type='hidden' name='vimboxItemCharge' value=''></td>";
        tr += "<td align='center'>" + boxUnit + "<input type='hidden' name='vimboxItemQty' value='" + boxUnit + "'></td>";
        tr += "<td align='center'>" + boxUnit + "<input type='hidden' name='vimboxItemUnit' value='" + boxUnit + "'></td>";
        tr += "<td align='right'><input type='button' value='x' onclick='deleteBox(this)'/></td></tr>";
        $(tr).prependTo("#vimboxItemsTable > tbody");
        addUnits(Number(boxUnit));
        boxes += (Number(boxUnit));
        $('#vimboxBoxUnit').val("");
        update_services();
    } else {
        var modal = document.getElementById("salesModal");
        var salesStatus = document.getElementById("salesStatus");
        var salesMessage = document.getElementById("salesMessage");
        salesStatus.innerHTML = "<b>ERROR</b>";
        salesMessage.innerHTML = errorMsg;
        modal.style.display = "block";
    }
}

function addVimboxMaterial() {
    var itemName = $('#vimboxMaterial').val();
    var itemUnit = $('#vimboxMaterialUnit').val();
    var itemCharge = $('#vimboxMaterialCharge').val();
    var errorMsg = "";
    var add = true;
    if (!itemName) {
        add = false;
        errorMsg += "Please enter an item<br>";
    }
    if (!itemUnit) {
        add = false;
        errorMsg += "Please enter an unit<br>";
    }
    if (!itemCharge) {
        add = false;
        errorMsg += "Please enter a charge<br>";
    }

    if (add) {
        var tr = "<tr><td>" + itemName + "<input type='hidden' name='vimboxMaterialName' value='" + itemName + "'></td>";
        tr += "<td>&nbsp;</td>";
        tr += "<td align='center'>" + itemCharge + "<input type='hidden' name='vimboxMaterialCharge' value='" + itemCharge + "'></td>";
        tr += "<td align='center'>" + itemUnit + "<input type='hidden' name='vimboxMaterialQty' value='" + itemUnit + "'></td>";
        tr += "<td align='center'>&nbsp;</td>";
        tr += "<td align='right'><input type='button' value='x' onclick='deleteMaterial(this)'/></td></tr>";
        $(tr).prependTo("#vimboxItemsTable > tbody");
        materialCharges += (Number(itemCharge));
        $('#vimboxMaterial').val("");
        $('#vimboxMaterialUnit').val("");
        $('#vimboxMaterialCharge').val("");
        $('#materialCharge').val(Number(materialCharges).toFixed(2));
        $('#vimboxMaterial').focus();
        update_total();
    } else {
        var modal = document.getElementById("salesModal");
        var salesStatus = document.getElementById("salesStatus");
        var salesMessage = document.getElementById("salesMessage");
        salesStatus.innerHTML = "<b>ERROR</b>";
        salesMessage.innerHTML = errorMsg;
        modal.style.display = "block";
    }
}

function deleteMaterial(btn) {
    var row = btn.parentNode.parentNode;
    var nodes = row.childNodes;
    var charge = nodes[2].innerHTML.substring(0, nodes[2].innerHTML.indexOf("<"));
    if (!isNaN(charge)) {
        materialCharges -= Number(charge);
    }
    row.parentNode.removeChild(row);
    $('#materialCharge').val(materialCharges);
}

function deleteBox(btn) {
    var row = btn.parentNode.parentNode;
    var nodes = row.childNodes;
    var unit = nodes[4].innerHTML.substring(0, nodes[4].innerHTML.indexOf("<"));
    subtractUnits(Number(unit));
    boxes -= Number(unit);
    row.parentNode.removeChild(row);
    update_services();
}
//--------------------------------End-----------------------------------//

//-----------------------Customer C&R Functions-------------------------//
function addCustomerComment() {
    var comment = $('#customerComment').val();
    if (comment) {
        var tr = "<tr><td>" + comment + "<input type='hidden' name='comments' value='" + comment + "'></td><td align='right'><input type='button' value='x' onclick='deleteRow(this)'/></td></tr>";
        $(tr).prependTo("#commentsTable > tbody");
        $('#customerComment').val("");
    } else {
        var modal = document.getElementById("salesModal");
        var salesStatus = document.getElementById("salesStatus");
        var salesMessage = document.getElementById("salesMessage");
        salesStatus.innerHTML = "<b>ERROR</b>";
        salesMessage.innerHTML = "Please enter a comment";
        modal.style.display = "block";
    }
}

function addCustomerRemark() {
    var remark = $('#customerRemark').val();
    if (remark) {
        var tr = "<tr><td>" + remark + "<input type='hidden' name='remarks' value='" + remark + "'></td><td align='right'><input type='button' value='x' onclick='deleteRow(this)'/></td></tr>";
        $(tr).prependTo("#remarksTable > tbody");
        $('#customerRemark').val("");
    } else {
        var modal = document.getElementById("salesModal");
        var salesStatus = document.getElementById("salesStatus");
        var salesMessage = document.getElementById("salesMessage");
        salesStatus.innerHTML = "<b>ERROR</b>";
        salesMessage.innerHTML = "Please enter a remark";
        modal.style.display = "block";
    }
}

function deleteRow(btn) {
    var row = btn.parentNode.parentNode;
    row.parentNode.removeChild(row);
}
//--------------------------------End-----------------------------------//

//-------------------------Service Functions----------------------------// 
$('#serviceTable td').click(function () {
    var cell = $(this);
    var state = cell.data('state') || '';
    var cellHtml = cell.html().trim();
    if (cellHtml) {
        var serviceCharge = cellHtml.substring(cellHtml.indexOf("{") + 1, cellHtml.lastIndexOf("}"));
        var serviceArray = serviceCharge.split(",");
        var svcSplit = serviceArray[0].split("|");
        var pri = svcSplit[0];
        var sec = svcSplit[1];
        var id = (pri + "_" + sec).replace(" ", "_");
        switch (state) {
            case '':
                if (pri === "Manpower") {
                    $('#manpowerId').val(id);
                    var modal = document.getElementById("manpowerModal");
                    modal.style.display = "block";
                }
                formula[id] = serviceArray[1];
                var tr = "<tr id='" + id + "'><td>";
                tr += "<table class='serviceTable'>"
                tr += "<tr height='10%'><td>" + pri + " - " + sec + "<input type='hidden' name='serviceName' value='" + id + "'></td><td align='right'>$ <input type='number' step='0.01' min='0' name='serviceCharge'></td></tr>";
                tr += "<tr>" + generateBreakdown(id) + "</tr></table></td></tr>";
                $('#servicesTable').append(tr);
                cell.addClass('selected');
                cell.data('state', 'selected');
                break;
            case 'selected':
                if (pri === "Manpower") {
                    removeManpower(id);
                }
                cell.removeClass('selected');
                cell.data('state', '');
                delete formula[id];
                $("#" + id).remove();
                break;
            default:
                break;
        }
    }
});

function generateBreakdown(id) {
    var fml = formula[id].split(" ");
    var breakdown = "<td colspan='2'><table width='100%' cellpadding=0 cellspacing=0 style='border-collapse: collapse;'><col width='50%'><col width='50%'>";
    for (i = 0; i < fml.length; i++) {
        var action = fml[i];
        switch (action) {
            case "U":
                breakdown += "<tr><td align='left'>&nbsp;&nbsp;&nbsp;Total Units</td>";
                breakdown += "<td align='right'><label id='" + id + "unitsLbl'>" + totalUnits + "</label></td></tr>";
                break;
            case "B":
                breakdown += "<tr><td align='left'>&nbsp;&nbsp;&nbsp;Boxes</td>";
                breakdown += "<td align='right'><label id='" + id + "boxesLbl'>" + boxes + "</label></td></tr>";
                break;
            case "MP":
                var man = manpower[id];
                if (man == null) {
                    man = 0;
                }
                breakdown += "<tr><td align='left'>&nbsp;&nbsp;&nbsp;Manpower</td>";
                breakdown += "<td align='right'><label id='" + id + "mpLbl'>" + man + "</label></td></tr>";
                break;
            case "AC":
                breakdown += "<tr><td align='left'>&nbsp;&nbsp;&nbsp;Additional Charges</td>";
                breakdown += "<td align='right'><label id='" + id + "acLbl'>" + additionalCharges + "</label></td></tr>";
                break;
            default:
                break;
        }
    }
    breakdown += "</table></td>";
    return breakdown;
}

function removeManpower(id) {
    var mpLbl = id + "manpowerLabel";
    var mprLbl = id + "manpowerReasonLabel";
    var mpIpt = id + "manpowerInput";
    var rIpt = id + "reasonInput";
    document.getElementById(mpIpt).value = "";
    document.getElementById(rIpt).value = "";
    delete manpower[id];
    document.getElementById(mpLbl).innerHTML = "";
    document.getElementById(mprLbl).innerHTML = "";
}

function submitManpower() {
    var id = $('#manpowerId').val();
    var addManpower = $('#additionalManpower').val();
    var manReason = $('#manpowerReason').val();
    manpower[id] = Number(addManpower);
    var mpLbl = id + "manpowerLabel";
    var mprLbl = id + "manpowerReasonLabel";
    document.getElementById(mpLbl).innerHTML = addManpower;
    document.getElementById(mprLbl).innerHTML = manReason;
    var mpIpt = id + "manpowerInput";
    var rIpt = id + "reasonInput";
    document.getElementById(mpIpt).value = addManpower;
    document.getElementById(rIpt).value = manReason;
    var modal = document.getElementById("manpowerModal");
    modal.style.display = "none";
    update_services();
}

function selectService() {
    var modal = document.getElementById("serviceModal");
    modal.style.display = "block";
}
//--------------------------------End-----------------------------------//

jQuery('#itemName').on('input', function () {
    var value = $('#itemName').val();
    var item = $('#items [value="' + value + '"]').data('value');
    if (typeof item !== "undefined") {
        var itemArray = item.split("|");
        $('#itemdimensions').val(itemArray[1]);
        $('#itemUnit').val(itemArray[2]);
        $('#itemQty').val("");
    }
});

function confirmCancel() {
    var modal = document.getElementById("lead_error_modal");
    var status = document.getElementById("lead_error_status");
    var message = document.getElementById("lead_error_message");
    status.innerHTML = "<b>Cancel Confirmation</b>";
    message.innerHTML = "<table width='100%'><tr><td colspan='2'>Cancel this lead record? Changes cannot be reverted.</td></tr><tr><td align='center'><button onclick=\"cancelLeadForm()\">Yes</button></td><td align='center'><button onclick=\"closeModal('lead_error_modal')\">No</button></td></tr></table>";
    modal.style.display = "block";
}

function cancelLeadForm() {
    var modal = document.getElementById("lead_error_modal");
    var status = document.getElementById("lead_error_status");
    var message = document.getElementById("lead_error_message");
    var id = $('#lId').val();
    var reason = $('#reason').val();
    $.getJSON("CancelLeadController", {lId: id, reason: reason})
            .done(function (data) {
                status.innerHTML = data.status;
                message.innerHTML = data.message;
                modal.style.display = "block";

                if (data.status === "SUCCESS") {
                    setTimeout(function () {
                        window.location.href = "MyLeads.jsp";
                    }, 500);
                }

            })
            .fail(function (error) {
                status.innerHTML = "ERROR";
                message.innerHTML = error;
                modal.style.display = "block";
            });
}

function cancelLead(leadId) {
    var modal = document.getElementById("cancelLeadModal");
    $('#lId').val(leadId);
    document.getElementById('leadIdLbl').innerHTML = leadId;
    modal.style.display = "block";
}

function viewSchedule() {

    var errorModal = document.getElementById("salesModal");
    var errorStatus = document.getElementById("salesStatus");
    var errorMessage = document.getElementById("salesMessage");
    var date = $('#sitesurvey_date').val();
    var siteSurveyor = $('#employee_search').val();
    var fromArray = document.getElementsByName("addressfrom");
    var addressFrom = "";
    for (i = 0; i < fromArray.length; i++) {
        addressFrom += fromArray[i].value + "|";
    }
    var toArray = document.getElementsByName("addressto");
    var addressTo = "";
    for (i = 0; i < toArray.length; i++) {
        addressTo += toArray[i].value + "|";
    }

    $.getJSON("ValidateSiteSurveyorDetails", {date: date, siteSurveyor: siteSurveyor, addressFrom: addressFrom, addressTo: addressTo})
            .done(function (data) {
                if (data.status === "SUCCESS") {
                    var div = document.getElementById(date);
                    var nric = "";
                    var timeslots = "";
                    var addresses = "";
                    if (div != null) {
                        nric = ($("#" + date + " input[name=siteSurvey_surveyor]").val().split("|"))[1];
                        var timeArray = $("#" + date + " input[name=siteSurvey_timeslot]");
                        for (var i = 0; i < timeArray.length; i++) {
                            if (timeArray[i].value.includes(date)) {
                                timeslots += (timeArray[i].value.split("|"))[1] + "|";
                            }
                        }

                        var addressArray = $("#" + date + " input[name=siteSurvey_address]");
                        for (var i = 0; i < addressArray.length; i++) {
                            if (addressArray[i].value.includes(date)) {
                                addresses += (addressArray[i].value.split("|"))[1] + "|";
                            }
                        }

                        var remarksArray = $("#" + date + " input[name=siteSurvey_remarks]");
                        var remarks = "";
                        for (var i = 0; i < remarksArray.length; i++) {
                            if (remarksArray[i].value.includes(date)) {
                                remarks = (remarksArray[i].value.split("|"))[1];
                                break;
                            }
                        }
                    }
                    toggleCounter = 0;
                    $.get("RetrieveSiteSurveyorSchedule.jsp", {leadId: $('#leadId').val(), date: date, siteSurveyor: siteSurveyor, addressFrom: addressFrom, addressTo: addressTo, nric: nric, timeslots: timeslots, addresses: addresses, remarks: remarks}, function (results) {
                        document.getElementById("schedule_content").innerHTML = results;
                        document.getElementById("schedule_modal").style.display = "block";
                    });
                } else {
                    errorStatus.innerHTML = data.status;
                    errorMessage.innerHTML = data.message;
                    errorModal.style.display = "block";
                }
            })
            .fail(function (error) {
                errorStatus.innerHTML = "ERROR";
                errorMessage.innerHTML = error;
                errorModal.style.display = "block";
            });
}

function selectSlot(e) {
    var cell = $(e);
    var state = cell.data('state') || '';
    var cellHtml = cell.html().trim();

    if (cellHtml) {
        var cellDetails = cellHtml.substring(cellHtml.indexOf("{") + 1, cellHtml.lastIndexOf("}"));
        var cellArray = cellDetails.split("|");
        var nric = cellArray[0];
        var employee = cellArray[1]
        var timeslot = cellArray[2];
        switch (state) {
            case '':
                var surveyorChanged = false;
                var table = document.getElementById("sitesurveyor_table");
                var timetable = document.getElementById("timeslot_table");
                for (var i = 0, row; row = table.rows[i]; i++) {
                    for (var j = 0, col; col = row.cells[j]; j++) {
                        //iterate through columns
                        //columns would be accessed using the "col" variable assigned in the for loop
                        var tableCell = $(col);
                        var cellState = tableCell.data('state') || '';

                        var tableCellHtml = tableCell.html().trim();
                        var tableCellDetails = tableCellHtml.substring(tableCellHtml.indexOf("{") + 1, tableCellHtml.lastIndexOf("}"));
                        var tableCellArray = tableCellDetails.split("|");
                        var tableNric = tableCellArray[0];
                        if (cellState === 'selected') {
                            if (tableNric !== nric) {
                                for (var i = 0, timerow; timerow = timetable.rows[i]; i++) {
                                    if ($(timerow).data('value').includes(tableCellDetails)) {
                                        timerow.parentNode.removeChild(timerow);
                                        break;
                                    }
                                }
                                surveyorChanged = true;
                                tableCell.removeClass('selected');
                                tableCell.data('state', '');
                            }
                        }
                    }
                }

                var tr = "<tr data-value='{" + nric + "|" + employee + "|" + timeslot + "}'><td>" + timeslot + "<input type='hidden' name='timeslot' value='" + timeslot + "'></td>";
                tr += "<td><input type='button' value='x' onclick='deleteSurveyRow(this)'/></td></tr>";
                var after = true;

                loop1:
                        for (var i = 0, timerow; timerow = timetable.rows[i]; i++) {
                    var tableCell = $(timerow).data('value');
                    var tableCellDetails = tableCell.substring(tableCell.indexOf("{") + 1, tableCell.lastIndexOf("}"));
                    var tableCellArray = tableCellDetails.split("|");
                    var tableTimeSlot = tableCellArray[2];
                    var num = timeslot.localeCompare(tableTimeSlot);
                    if (num === -1) {
                        after = false;
                    }

                    if (i === 0 && after === false) {
                        $(tr).prependTo("#timeslot_table > tbody");
                        break loop1;
                    } else if (after === false) {
                        $('#timeslot_table > tbody > tr').eq(i - 1).after(tr);
                        break loop1;
                    }
                }


                if (after) {
                    $('#timeslot_table').append(tr);
                }

                var surveyor = $('#surveyor').val();
                document.getElementById('surveyor_select').value = nric + "|" + employee;

                if (surveyor === '' || surveyorChanged) {
                    $('#surveyor').val(nric);
                    $('#surveyor_name').val(employee);
                    document.getElementById("surveyor_label").innerHTML = employee;
                }

                cell.addClass('selected');
                cell.data('state', 'selected');
                break;
            case 'selected':
                var table = document.getElementById("timeslot_table");
                for (var i = 0, row; row = table.rows[i]; i++) {
                    if ($(row).data('value').includes(nric + "|" + employee + "|" + timeslot)) {
                        row.parentNode.removeChild(row);
                        break;
                    }
                }
                cell.removeClass('selected');
                cell.data('state', '');
                var empty = true;
                var table = document.getElementById("sitesurveyor_table");
                for (var i = 0, row; row = table.rows[i]; i++) {
                    for (var j = 0, col; col = row.cells[j]; j++) {
                        var tableCell = $(col);
                        var cellState = tableCell.data('state') || '';
                        if (cellState === 'selected') {
                            empty = false;
                            break;
                        }
                    }
                }

                if (empty) {
                    document.getElementById('surveyor_select').value = "";
                    $('#surveyor').val('');
                    $('#surveyor_name').val('');
                    document.getElementById("surveyor_label").innerHTML = "";
                }
                break;
            default:
                break;
        }
    }
}

function deleteSurveyRow(btn) {
    var row = btn.parentNode.parentNode;
    var value = $(row).data('value');
    row.parentNode.removeChild(row);
    var table = document.getElementById("sitesurveyor_table");
    for (var i = 0, row; row = table.rows[i]; i++) {
        for (var j = 0, col; col = row.cells[j]; j++) {
            //iterate through columns
            //columns would be accessed using the "col" variable assigned in the for loop
            var tableCell = $(col);
            var tableCellHtml = tableCell.html().trim();
            if (tableCellHtml.includes(value)) {
                tableCell.removeClass('selected');
                tableCell.data('state', '');
            }
        }
    }
}

function deleteAddressRow(btn) {
    var row = btn.parentNode.parentNode;
    row.parentNode.removeChild(row);
}

function addAddress() {
    var address = $('#address_select').val();
    if (address !== '') {
        var tr = "<tr><td>" + address + "<input type='hidden' name='site_address' value='" + address + "'></td>";
        tr += "<td><input type='button' value='x' onclick='deleteAddressRow(this)'/></td></tr>";
        $(tr).prependTo("#address_table > tbody");
    }
    $('#address_select').val('');
}

function assignSiteSurveyor() {
    var surveyorId = $('#surveyor').val();
    var surveyorName = $('#surveyor_name').val();
    var date = $('#survey_date').val();
    var timeslots = document.getElementsByName("timeslot");
    var addresses = document.getElementsByName("site_address");
    var remarks = $('#site_remarks').val();

    var errorMsg = "";
    if (!surveyorId) {
        errorMsg += "Please choose a site surveyor<br>";
    }
    if (timeslots.length === 0) {
        errorMsg += "Please choose a time slot<br>";
    }
    if (addresses.length === 0) {
        errorMsg += "Please choose an address<br>";
    }

    var modal = document.getElementById("salesModal");
    var status = document.getElementById("salesStatus");
    var message = document.getElementById("salesMessage");
    if (!errorMsg) {
        var elem = document.getElementById(date);
        if (elem != null) {
            elem.parentNode.removeChild(elem);
        }

        var newdiv = document.createElement('div');
        var stringDiv = "";
        stringDiv += "<div id='" + date + "'>";
        stringDiv += "<span class='close' onClick=\"removeSiteSurvey('" + date + "');\">×</span>";
        stringDiv += "<hr><table><col width='100'>";
        stringDiv += "<tr><td align='right'><b>Date :</b></td><td><input type='hidden' name='siteSurvey_date' value='" + date + "'>" + date + "</td></tr>";
        stringDiv += "<tr><td align='right'><b>Timeslot :</b></td><td><table>";
        for (i = 0; i < timeslots.length; i++) {
            stringDiv += "<tr><td><input type='hidden' name='siteSurvey_timeslot' value='" + date + "|" + timeslots[i].value + "'>" + timeslots[i].value + "</td></tr>";
        }
        stringDiv += "</table></td></tr>";
        stringDiv += "<tr><td align='right'><b>Address :</b></td><td><table>";
        for (i = 0; i < addresses.length; i++) {
            stringDiv += "<tr><td><input type='hidden' name='siteSurvey_address' value='" + date + "|" + addresses[i].value + "'>" + addresses[i].value + "</td></tr>";
        }
        stringDiv += "</table></td></tr>";
        stringDiv += "<tr><td align='right'><b>Surveyor :</b></td><td><input type='hidden' name='siteSurvey_surveyor' value='" + date + "|" + surveyorId + "'>" + surveyorName + "</td></tr>";
        stringDiv += "<tr><td align='right'><b>Remarks :</b></td><td><input type='hidden' name='siteSurvey_remarks' value='" + date + "|" + remarks + "'>" + remarks + "</td></tr>";
        stringDiv += "</table></div>";
        newdiv.innerHTML = stringDiv;
        document.getElementById("survey").appendChild(newdiv);

        status.innerHTML = "SUCCESS";
        message.innerHTML = "Site survey assigned!";
        modal.style.display = "block";
        document.getElementById("schedule_modal").style.display = "none";
    } else {

        status.innerHTML = "ERROR";
        message.innerHTML = errorMsg;
        modal.style.display = "block";
    }
}

function removeSiteSurvey(id) {
    var elem = document.getElementById(id);
    elem.parentNode.removeChild(elem);
}

function initMap() {
    var colors = [{strokeColor: 'red', strokeOpacity: 1.0, strokeWeight: 2}, {strokeColor: 'blue', strokeOpacity: 1.0, strokeWeight: 2}, {strokeColor: 'black', strokeOpacity: 1.0, strokeWeight: 2}, {strokeColor: 'lime', strokeOpacity: 1.0, strokeWeight: 2}, {strokeColor: 'purple', strokeOpacity: 1.0, strokeWeight: 2}];

    var colorCounter = 0;
    document.getElementById('map').setAttribute("style", "width:100%");
    document.getElementById('map').setAttribute("style", "height:300px");
    var map = new google.maps.Map(document.getElementById("map"), {
        zoom: 11,
        center: {lat: 1.355878, lng: 103.822324},
        mapTypeId: google.maps.MapTypeId.TERRAIN
    });

    var infowindow = new google.maps.InfoWindow({
        size: new google.maps.Size(150, 50)
    });
    google.maps.event.addListener(map, 'click', function () {
        infowindow.close();
    });

    // Create the search box and link it to the UI element.
    var input = document.getElementById('pac-input');
    var searchBox = new google.maps.places.SearchBox(input);
    map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);

    // Bias the SearchBox results towards current map's viewport.
    map.addListener('bounds_changed', function () {
        searchBox.setBounds(map.getBounds());
    });

    var markers = [];
    // Listen for the event fired when the user selects a prediction and retrieve
    // more details for that place.
    searchBox.addListener('places_changed', function () {
        var places = searchBox.getPlaces();

        if (places.length == 0) {
            return;
        }

        // Clear out the old markers.
        markers.forEach(function (marker) {
            marker.setMap(null);
        });
        markers = [];

        // For each place, get the icon, name and location.
        var bounds = new google.maps.LatLngBounds();
        places.forEach(function (place) {
            var icon = {
                url: place.icon,
                size: new google.maps.Size(71, 71),
                origin: new google.maps.Point(0, 0),
                anchor: new google.maps.Point(17, 34),
                scaledSize: new google.maps.Size(25, 25)
            };

            // Create a marker for each place.
            markers.push(new google.maps.Marker({
                map: map,
                icon: icon,
                title: place.name,
                position: place.geometry.location
            }));

            if (place.geometry.viewport) {
                // Only geocodes have viewport.
                bounds.union(place.geometry.viewport);
            } else {
                bounds.extend(place.geometry.location);
            }
        });
        map.fitBounds(bounds);
    });

    $.ajaxSetup({
        async: false
    });

    var legendArray = [];
    var addresses = $("#tableForm input[name=surveyors_addresses]");
    var surveyor_name = "";
    var polyline = [];
    for (var j = 0; j < addresses.length; j++) {
        var addressArray = addresses[j].value.split("|");
        var name = addressArray[0];
        var address = addressArray[1].split("<br>");
        if (j === 0) {
            surveyor_name = name;
        }

        if (surveyor_name !== name) {
            var waypts = [];
            for (n = 1; n < polyline.length - 1; n++) {
                waypts.push({location: polyline[n],
                    stopover: true});
            }
            var request = {
                origin: polyline[0],
                destination: polyline[polyline.length - 1],
                waypoints: waypts,
                travelMode: google.maps.TravelMode.DRIVING
            };
            legendArray.push({name: surveyor_name, color: colors[colorCounter].strokeColor});
            setDirection(colors[colorCounter], map, request, function (result) {
                console.log(result);
            });

            surveyor_name = name;
            polyline = [];
            colorCounter += 1;
        }

        for (p = 0; p < address.length; p++) {
            var url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + address[p] + "&key=AIzaSyAlr3mj-08qPnSvod0WtYbmE0NrulFq0RE"
            $.getJSON(url)
                    .done(function (data) {
                        if (data.status == google.maps.GeocoderStatus.OK) {
                            var latitude = data.results[0].geometry.location.lat;
                            var longitude = data.results[0].geometry.location.lng;
                            var latlng = new google.maps.LatLng(latitude, longitude)
                            polyline.push(latlng);
                            createMarker(latlng, addressArray[3], addressArray[0], address[p], addressArray[2], map, infowindow);
                        } else {
                            console.log(data.status);
                        }
                    })
                    .fail(function (error) {
                        console.log(error)
                    });
        }

        if (j === addresses.length - 1) {
            var waypts = [];
            for (n = 1; n < polyline.length - 1; n++) {
                waypts.push({location: polyline[n],
                    stopover: true});
            }
            var request = {
                origin: polyline[0],
                destination: polyline[polyline.length - 1],
                waypoints: waypts,
                travelMode: google.maps.TravelMode.DRIVING
            };
            legendArray.push({name: surveyor_name, color: colors[colorCounter].strokeColor});
            setDirection(colors[colorCounter], map, request, function (result) {
                console.log(result);
            });
        }

        if (colorCounter > colors.length) {
            colorCounter = 0;
        }
    }

    var legendHTML = "<hr><b><u>Map Legends</u></b><table width='100%'>";
    for (i = 0; i < legendArray.length; i += 3) {
        legendHTML += "<tr>";
        legendHTML += "<td><img style='width: 10px;height: 10px;background: " + legendArray[i].color + "'></img> : " + legendArray[i].name + "</td>";
        if (legendArray[i + 1] != null) {
            legendHTML += "<td><img style='width: 10px;height: 10px;background: " + legendArray[i + 1].color + "'></img> : " + legendArray[i + 1].name + "</td>";
        }
        if (legendArray[i + 2] != null) {
            legendHTML += "<td><img style='width: 10px;height: 10px;background: " + legendArray[i + 2].color + "'></img> : " + legendArray[i + 2].name + "</td>";
        }
        legendHTML += "</tr>";
    }
    legendHTML += "</table>";
    document.getElementById("map-legends").innerHTML = legendHTML;
    $.ajaxSetup({
        async: true
    });
}

function setDirection(polyLineOption, map, request, callback) {
    var directionsSvc = new google.maps.DirectionsService();
    directionsSvc.route(request, function (response, status) {
        if (status == google.maps.DirectionsStatus.OK) {
            var directionsDisplay = new google.maps.DirectionsRenderer({
                polylineOptions: polyLineOption,
                preserveViewport: true
            });
            directionsDisplay.setOptions({suppressMarkers: true});
            directionsDisplay.setMap(map);
            directionsDisplay.setDirections(response);
            callback(true);
        }
    });
}

function createMarker(latlng, leadId, surveyor, address, timeslot, map, infowindow) {
    var contentString = "<table><tr><td>Lead ID :</td><td>" + leadId + "</td></tr><tr><td>Surveyor :</td><td>" + surveyor + "</td></tr><tr><td>Address :</td><td>" + address + "</td></tr><tr><td>Time Slot :</td><td>" + timeslot + "</td></tr></table>";
    var marker = new google.maps.Marker({
        position: latlng,
        map: map,
    });

    google.maps.event.addListener(marker, 'click', function () {
        infowindow.setContent(contentString);
        infowindow.open(map, marker);
    });
}


function toggleView() {
    switch (toggleCounter) {
        case 0:
            document.getElementById("tableForm").style.display = "none";
            document.getElementById("mapForm").style.visibility = "visible";
            document.getElementById("pac-input").style.display = "block";
            document.getElementById("map-legends").style.display = "block";
            initMap();
            document.getElementById("mapInput").style.display = "block";
            toggleCounter = 1;
            break;
        case 1:
            document.getElementById("tableForm").style.display = "block";
            document.getElementById("mapForm").style.visibility = "hidden";
            document.getElementById('map').style.visibility = "hidden";
            document.getElementById("pac-input").style.display = "none";
            document.getElementById("map-legends").style.display = "none";
            document.getElementById("mapInput").style.display = "none";
            document.getElementById('mapForm').setAttribute("style", "width:0px");
            document.getElementById('mapForm').setAttribute("style", "height:0px");
            toggleCounter = 2;
            break;
        case 2:
            document.getElementById("tableForm").style.display = "none";
            document.getElementById("mapForm").style.visibility = "visible";
            document.getElementById('map').style.visibility = "visible";
            document.getElementById("map-legends").style.display = "block";
            document.getElementById("mapInput").style.display = "block";
            document.getElementById("pac-input").style.display = "block";
            document.getElementById('mapForm').setAttribute("style", "width:100%");
            document.getElementById('mapForm').setAttribute("style", "height:auto");
            toggleCounter = 1;
            break;
    }
}

function selectTimeSlot() {
    var errorModal = document.getElementById("salesModal");
    var errorStatus = document.getElementById("salesStatus");
    var errorMessage = document.getElementById("salesMessage");

    var timeslot = document.getElementById("timeslot").value;
    var employeeSelected = document.getElementById("surveyor").value + "|" + document.getElementById("surveyor_name").value;
    if (employeeSelected === '|') {
        errorStatus.innerHTML = "ERROR"
        errorMessage.innerHTML = "Please select a surveyor";
        errorModal.style.display = "block";
    } else if (timeslot !== '') {
        var table = document.getElementById("sitesurveyor_table");
        for (var i = 0, row; row = table.rows[i]; i++) {
            for (var j = 0, col; col = row.cells[j]; j++) {
                var tableCell = $(col);
                var cellState = tableCell.data('state') || '';

                var tableCellHtml = tableCell.html().trim();
                if (tableCellHtml.includes(employeeSelected + "|" + timeslot)) {
                    if (cellState !== 'selected' && cellState !== 'occupied') {
                        tableCell.addClass('selected');
                        tableCell.data('state', 'selected');
                        var tr = "<tr data-value='{" + employeeSelected + "|" + timeslot + "}'><td>" + timeslot + "<input type='hidden' name='timeslot' value='" + timeslot + "'></td>";
                        tr += "<td><input type='button' value='x' onclick='deleteSurveyRow(this)'/></td></tr>";
                        var after = true;
                        var timetable = document.getElementById("timeslot_table");
                        loop1:
                        for (var i = 0, timerow; timerow = timetable.rows[i]; i++) {
                            var tableCell = $(timerow).data('value');
                            var tableCellDetails = tableCell.substring(tableCell.indexOf("{") + 1, tableCell.lastIndexOf("}"));
                            var tableCellArray = tableCellDetails.split("|");
                            var tableTimeSlot = tableCellArray[2];
                            var num = timeslot.localeCompare(tableTimeSlot);
                            if (num === -1) {
                                after = false;
                            }

                            if (i === 0 && after === false) {
                                $(tr).prependTo("#timeslot_table > tbody");
                                break loop1;
                            } else if (after === false) {
                                $('#timeslot_table > tbody > tr').eq(i - 1).after(tr);
                                break loop1;
                            }
                        }


                        if (after) {
                            $('#timeslot_table').append(tr);
                        }
                    } else if (cellState === 'occupied') {
                        errorStatus.innerHTML = "ERROR"
                        errorMessage.innerHTML = "Surveyor has an appointment at that timing";
                        errorModal.style.display = "block";
                    }
                }
            }
        }
    } else {
        errorStatus.innerHTML = "ERROR"
        errorMessage.innerHTML = "Please select a timeslot";
        errorModal.style.display = "block";
    }
    document.getElementById("timeslot").value = "";
}

function selectSurveyor() {
    var employee = document.getElementById("surveyor").value + "|" + document.getElementById("surveyor_name").value;
    var selected = document.getElementById("surveyor_select").value;
    if (employee !== selected) {
        var selectedArr = selected.split("|");
        document.getElementById("surveyor").value = selectedArr[0];
        document.getElementById("surveyor_name").value = selectedArr[1];
        document.getElementById("surveyor_label").innerHTML = selectedArr[1];

        var timetable = document.getElementById("timeslot_table");
        var table = document.getElementById("sitesurveyor_table");
        for (var i = 0, timerow; timerow = timetable.rows[i]; i++) {
            var details = $(timerow).data('value');
            timerow.parentNode.removeChild(timerow);
            for (var i = 0, row; row = table.rows[i]; i++) {
                for (var j = 0, col; col = row.cells[j]; j++) {
                    var tableCell = $(col);

                    var tableCellHtml = tableCell.html().trim();
                    if (tableCellHtml.includes(details)) {
                        tableCell.removeClass('selected');
                        tableCell.data('state', '');
                    }
                }
            }

        }
    }
}