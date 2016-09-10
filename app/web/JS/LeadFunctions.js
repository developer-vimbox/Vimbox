var toggleCounter = 0;

var formula = [];
var symbols = ["+", "-", "/", "x"];
var additionalCharges = [];
var materialCharges = [];
var totalUnits = [];
var boxes = [];
var manpower = [];
var domCounter = 2;

var domPass = true;

function initSalesDiv(divId) {
    boxes.push({id: divId, value: 0});
    totalUnits.push({id: divId, value: 0});
    additionalCharges.push({id: divId, value: 0});
    manpower.push({id: divId, value: {}});
    formula.push({id: divId, value: {}});
    materialCharges.push({id: divId, value: 0});
}

function openSales(evt, cityName) {
    // Declare all variables
    var i, tabcontent, tablinks;

    // Get all elements with class="tabcontent" and hide them
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }

    // Get all elements with class="tablinks" and remove the class "active"
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }

    // Show the current tab, and add an "active" class to the link that opened the tab
    document.getElementById(cityName).style.display = "block";
    evt.currentTarget.className += " active";
    $('#' + cityName).scrollView();
}

function addFollowup(leadId) {
    var modal = document.getElementById("commentModal");
    $.get("AddFollowUpComment.jsp", {leadId: leadId}, function (data) {
        document.getElementById('comment-content').innerHTML = data;
    });

    modal.style.display = "block";
}

function followupLead(lead_id) {
    var comment_lead_id = $('#comment_lead_id').val();
    var comment_lead_followup = $('#comment_lead_followup').val();
    var errorModal = document.getElementById("lead_error_modal");
    var errorStatus = document.getElementById("lead_error_status");
    var errorMessage = document.getElementById("lead_error_message");
    $.getJSON("LeadFollowupController", {comment_lead_id: comment_lead_id, comment_lead_followup: comment_lead_followup})
            .done(function (data) {
                if (status === "SUCCESS") {
                    $('#comment_lead_id').val("");
                    document.getElementById("commentModal").style.display = "none";
                }
                var status = data.status;
                var errorMsg = data.message;
                errorStatus.innerHTML = status;
                errorMessage.innerHTML = errorMsg;
                errorModal.style.display = "block";

            })
            .fail(function (error) {
                errorStatus.innerHTML = "ERROR";
                errorMessage.innerHTML = error;
                errorModal.style.display = "block";
            });
}

function viewLead(leadId) {
    var modal = document.getElementById("viewLeadModal");
    var content = document.getElementById("leadContent");
    $.get("RetrieveLeadDetails.jsp", {getLid: leadId}, function (data) {
        content.innerHTML = data;
    });
    modal.style.display = "block";
}

function viewFollowups(leadId) {
    var modal = document.getElementById("viewFollowUpModal");
    var div1 = document.getElementById("followUpContent");
    $.get("RetrieveLeadFollowup.jsp", {getLid: leadId}, function (data) {
        div1.innerHTML = data;
    });
    modal.style.display = "block";
}

function viewLeadsHistory(custId) {
    var modal = document.getElementById("leadsHistoryModal");
    var leadsHistoryContent = document.getElementById("leadsHistoryContent");
    $.get("LeadsHistory.jsp", {getId: custId}, function (data) {
        leadsHistoryContent.innerHTML = data;
    });
    modal.style.display = "block";
}

//------------------------- LeadType Functions---------------------------//

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
    $('.tabcontent').each(function () {
        var divId = this.id;
        initSalesDiv(divId);
        var totalUnit = totalUnits.find(function (obj) {
            return obj.id === divId;
        });
        var box = boxes.find(function (obj) {
            return obj.id === divId;
        });
        var addCharge = additionalCharges.find(function (obj) {
            return obj.id === divId;
        });
        var mp = manpower.find(function (obj) {
            return obj.id === divId;
        });
        var frml = formula.find(function (obj) {
            return obj.id === divId;
        });
        var matCharge = materialCharges.find(function (obj) {
            return obj.id === divId;
        });


        $("#" + divId + "_customerItemsTable > tbody  > tr").each(function () {
            var inputs = this.getElementsByTagName("input");
            var name = inputs[0].value;
            if (name === "Boxes") {
                box.value += Number(inputs[4].value);
            }
            var charges = inputs[2].value;
            if (!isNaN(charges)) {
                addCharge.value += Number(charges);
            }
            totalUnit.value += Number(inputs[4].value);
        });

        $("#" + divId + "_vimboxItemsTable > tbody  > tr").each(function () {
            var inputs = this.getElementsByTagName("input");
            var name = inputs[0].value;
            if (name === "Boxes") {
                box.value += Number(inputs[4].value);
                totalUnit.value += Number(inputs[4].value);
            }
            var charges = inputs[2].value;
            if (!isNaN(charges)) {
                matCharge.value += Number(charges);
            }
        });

        $("#" + divId + "_serviceTable > tbody  > tr > td").each(function () {
            var cellHtml = this.innerHTML.trim();
            var manpowerPresent = cellHtml.match(/manpower/i);
            if (manpowerPresent) {
                var serviceCharge = cellHtml.substring(cellHtml.indexOf("{") + 1, cellHtml.lastIndexOf("}"));
                var serviceArray = serviceCharge.split(",");
                var svcSplit = serviceArray[0].split("|");
                var pri = svcSplit[0];
                var sec = svcSplit[1];
                var id = (pri + "_" + sec).replace(" ", "_");
                (mp.value)[id] = Number(document.getElementById(divId + '_' + id + "manpowerInput").value);
            }
        });

        var svcs = [];
        $("#" + divId + "_servicesTable > tbody  > tr").each(function () {
            var inputs = this.getElementsByTagName("input");
            var id = $(this).attr('id');
            (frml.value)[id] = inputs[2].value;
            var table = this.getElementsByTagName("table");
            $(table).append("<tr>" + generateBreakdown(id, divId) + "</tr>");
            svcs.push(id);
        });

        $("#" + divId + "_serviceTable > tbody  > tr > td").each(function () {
            var cellHtml = this.innerHTML.trim();
            var inputs = this.getElementsByTagName('input');
            if (cellHtml) {
                var serviceCharge = cellHtml.substring(cellHtml.indexOf("{") + 1, cellHtml.lastIndexOf("}"));
                var serviceArray = serviceCharge.split(",");
                var svcSplit = serviceArray[0].split("|");
                var pri = svcSplit[0];
                var sec = svcSplit[1];
                var id = (pri + "_" + sec).replace(" ", "_");
                if (svcs.indexOf(divId + "_" + id) > -1) {
                    $(this).addClass('selected');
                    $(this).data('state', 'selected');
                }
            }
        });
        document.getElementById(divId + "_totalUnits").innerHTML = "Total Units : " + totalUnit.value;
        update_services(divId);
    });
}

function showfield(name, e) {
    if (e.id === 'enquiry') {
        if (name == 'Others') {
            document.getElementById('enquiryOthers').innerHTML = '<label class="col-sm-6 control-label">Others: </label>  <div class="col-sm-4"><input class="form-control" type="text" name="enquiryOthers" style="width: 200px;" /></div>';
        } else {
            document.getElementById('enquiryOthers').innerHTML = '';
        }
    } else {
        if (name == 'Others') {
            document.getElementById('referralOthers').innerHTML = '<label class="col-sm-6 control-label">Others: </label>  <div class="col-sm-4"><input class="form-control" type="text" name="referralOthers" style="width: 200px;" /></div>';
        } else {
            document.getElementById('referralOthers').innerHTML = '';
        }
    }

}

$(document).on('change keyup paste', '.servicesTable tbody tr', function (event) {
    var id = this.id;
    var divId = id.substring(0, id.indexOf("_"));
    update_total(divId);
});

$(document).on('change keyup paste', '.markup', function () {
    var id = this.id;
    var divId = id.substring(0, id.indexOf("_"));
    update_total(divId);
});
$(document).on('change keyup paste', '.pushCharge', function () {
    var id = this.id;
    var divId = id.substring(0, id.indexOf("_"));
    update_total(divId);
});
$(document).on('change keyup paste', '.materialCharge', function () {
    var id = this.id;
    var divId = id.substring(0, id.indexOf("_"));
    update_total(divId);
});
$(document).on('change keyup paste', '.storeyCharge', function () {
    var id = this.id;
    var divId = id.substring(0, id.indexOf("_"));
    update_total(divId);
});
$(document).on('change keyup paste', '.detourCharge', function () {
    var id = this.id;
    var divId = id.substring(0, id.indexOf("_"));
    update_total(divId);
});
$(document).on('change keyup paste', '.discount', function () {
    var id = this.id;
    var divId = id.substring(0, id.indexOf("_"));
    update_total(divId);
});

$(document).on('input', '.itemName', function () {
    var id = this.id;
    var divId = id.substring(0, id.indexOf("_"));
    var value = $("#" + divId + "_itemName").val();
    var item = $("#" + divId + "_items [value='" + value + "']").data('value');
    if (typeof item !== "undefined") {
        var itemArray = item.split("|");
        $("#" + divId + "_itemdimensions").val(itemArray[1]);
        $("#" + divId + "_itemUnit").val(itemArray[2]);
        $("#" + divId + "_itemQty").val("");
    }
});

function update_services(divId) {
    var entered = false;
    $("#" + divId + "_servicesTable > tbody  > tr").each(function () {
        update_service(this, divId);
        entered = true;
    });
    if (entered === false) {
        update_total(divId);
    }
}

function calculate(sum, symbol, variable) {
    switch (symbol) {
        case "x":
            sum *= variable;
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

function update_service(element, divId) {
    var totalUnit = totalUnits.find(function (obj) {
        return obj.id === divId;
    });
    var box = boxes.find(function (obj) {
        return obj.id === divId;
    });
    var addCharge = additionalCharges.find(function (obj) {
        return obj.id === divId;
    });
    var mp = manpower.find(function (obj) {
        return obj.id === divId;
    });
    var frml = formula.find(function (obj) {
        return obj.id === divId;
    });

    var id = $(element).attr("id");
    var fml = (frml.value)[id].split(" ");
    var symbol;
    var sum;
    for (i = 0; i < fml.length; i++) {
        var action = fml[i];
        if (i === 0) {
            if (isNaN(action)) {
                switch (action) {
                    case "U":
                        sum = totalUnit.value;
                        break;
                    case "B":
                        sum = box.value;
                        break;
                    case "AC":
                        sum = addCharge.value;
                        break;
                    case "MP":
                        sum = (mp.value)[id.substring(id.indexOf("_") + 1)];

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
                            sum = calculate(sum, symbol, totalUnit.value);
                            break;
                        case "B":
                            sum = calculate(sum, symbol, box.value);
                            break;
                        case "AC":
                            sum = calculate(sum, symbol, addCharge.value);
                            break;
                        case "MP":
                            sum = calculate(sum, symbol, (mp.value)[id.substring(id.indexOf("_") + 1)]);
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
                var label = divId + "_" + id + "unitsLbl";
                $('#' + label).html(totalUnit.value);
                break;
            case "B":
                var label = divId + "_" + id + "boxesLbl";
                $('#' + label).html(box.value);
                break;
            case "AC":
                var label = divId + "_" + id + "acLbl";
                $('#' + label).html(addCharge.value);
                break;
            case "MP":
                var label = divId + "_" + id + "mpLbl";
                $('#' + label).html((mp.value)[id.substring(id.indexOf("_") + 1)]);
                break;
        }
    }

    update_total(divId);
}

function update_total(divId) {
    var sum = 0;
    $("#" + divId + "_servicesTable > tbody  > tr").each(function () {
        sum += Number(this.getElementsByTagName("input")[1].value);
    });
    sum += (Number($("#" + divId + "_markup").val()) + Number($("#" + divId + "_materialCharge").val()) + Number($("#" + divId + "_pushCharge").val()) + Number($("#" + divId + "_storeyCharge").val()) + Number($("#" + divId + "_detourCharge").val()) - Number($("#" + divId + "_discount").val()));
    $("#" + divId + "_totalPrice").val(Number(sum).toFixed(2));
}

function addUnits(unit, divId) {
    var tuObject = totalUnits.find(function (obj) {
        return obj.id === divId;
    });
    tuObject.value += unit;
    document.getElementById(divId + '_totalUnits').innerHTML = "Total Units : " + tuObject.value;
}

function subtractUnits(unit, divId) {
    var tuObject = totalUnits.find(function (obj) {
        return obj.id === divId;
    });
    tuObject.value -= unit;
    document.getElementById(divId + '_totalUnits').innerHTML = "Total Units : " + tuObject.value;
}
//----------------------Customer Item Functions-------------------------//
function addCustomerBox(divId) {
    var boxUnit = $("#" + divId + "_customerBoxUnit").val();
    var boxObject = boxes.find(function (obj) {
        return obj.id === divId;
    });
    var errorMsg = "";
    var add = true;
    if (!boxUnit) {
        add = false;
        errorMsg += "Please enter a quantity<br>";
    }
    if (add) {
        var tr = "<tr><td>Boxes<input type='hidden' name='" + divId + "_customerItemName' value='Boxes'></td>";
        tr += "<td>&nbsp;<input type='hidden' name='" + divId + "_customerItemRemark' value=''></td>";
        tr += "<td align='center'>&nbsp;&nbsp;&nbsp;&nbsp;<input type='hidden' name='" + divId + "_customerItemCharge' value=''></td>";
        tr += "<td align='center'>" + boxUnit + "<input type='hidden' name='" + divId + "_customerItemQty' value='" + boxUnit + "'></td>";
        tr += "<td align='center'>" + boxUnit + "<input type='hidden' name='" + divId + "_customerItemUnit' value='" + boxUnit + "'></td>";
        tr += "<td align='right'><input class='btn btn-default' type='button' value='x' onclick=\"deleteBox(this,'" + divId + "')\"/></td></tr>";
        $(tr).prependTo("#" + divId + "_customerItemsTable > tbody");
        addUnits(Number(boxUnit), divId);
        boxObject.value += (Number(boxUnit));
        $("#" + divId + "_customerBoxUnit").val("");
        update_services(divId);
    } else {
        var modal = document.getElementById("salesModal");
        var salesStatus = document.getElementById("salesStatus");
        var salesMessage = document.getElementById("salesMessage");
        salesStatus.innerHTML = "<b>ERROR</b>";
        salesMessage.innerHTML = errorMsg;
        modal.style.display = "block";
    }
}

function addItem(divId) {
    var itemName = $("#" + divId + "_itemName").val();
    var itemUnit = $("#" + divId + "_itemUnit").val();
    var itemQty = $("#" + divId + "_itemQty").val();
    var itemRemark = $("#" + divId + "_itemRemark").val();
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
        var tr = "<tr><td>" + itemName + "<input type='hidden' name='" + divId + "_customerItemName' value='" + itemName + "'></td>";
        tr += "<td>" + itemRemark + "<input type='hidden' name='" + divId + "_customerItemRemark' value='" + itemRemark + "'></td>";
        tr += "<td align='center'>&nbsp;&nbsp;&nbsp;&nbsp;<input type='hidden' name='" + divId + "_customerItemCharge' value=''></td>";
        tr += "<td align='center'>" + itemQty + "<input type='hidden' name='" + divId + "_customerItemQty' value='" + itemQty + "'></td>";
        tr += "<td align='center'>" + itemUnit + "<input type='hidden' name='" + divId + "_customerItemUnit' value='" + itemUnit + "'></td>";
        tr += "<td align='right'><input class='form-control' type='button' value='x' onclick=\"deleteItem(this,'" + divId + "')\"/></td></tr>";
        $(tr).prependTo("#" + divId + "_customerItemsTable > tbody");
        addUnits(Number(itemUnit), divId);
        $("#" + divId + "_itemName").val("");
        $("#" + divId + "_itemUnit").val("");
        $("#" + divId + "_itemQty").val("");
        $("#" + divId + "_itemRemark").val("");
        $("#" + divId + "_itemdimensions").val("");
        $("#" + divId + "_itemName").focus();
        update_services(divId);
    } else {
        var modal = document.getElementById("salesModal");
        var salesStatus = document.getElementById("salesStatus");
        var salesMessage = document.getElementById("salesMessage");
        salesStatus.innerHTML = "<b>ERROR</b>";
        salesMessage.innerHTML = errorMsg;
        modal.style.display = "block";
    }
}
function addSpecialItem(divId) {
    var itemName = $("#" + divId + "_specialItemName").val();
    var itemCharges = $("#" + divId + "_specialItemCharges").val();
    var itemUnit = $("#" + divId + "_specialItemUnit").val();
    var itemQty = $("#" + divId + "_specialItemQty").val();
    var itemRemark = $("#" + divId + "_specialItemRemark").val();

    var addCharge = additionalCharges.find(function (obj) {
        return obj.id === divId;
    });
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
        var tr = "<tr><td>" + itemName + "<input type='hidden' name='" + divId + "_customerItemName' value='" + itemName + "'></td>";
        tr += "<td>" + itemRemark + "<input type='hidden' name='" + divId + "_customerItemRemark' value='" + itemRemark + "'></td>";
        tr += "<td align='center'>" + itemCharges + "<input type='hidden' name='" + divId + "_customerItemCharge' value='" + itemCharges + "'></td>";
        tr += "<td align='center'>" + itemQty + "<input type='hidden' name='" + divId + "_customerItemQty' value='" + itemQty + "'></td>";
        tr += "<td align='center'>" + itemUnit + "<input type='hidden' name='" + divId + "_customerItemUnit' value='" + itemUnit + "'></td>";
        tr += "<td align='right'><input class='form-control' type='button' value='x' onclick=\"deleteItem(this,'" + divId + "')\"/></td></tr>";
        $(tr).prependTo("#" + divId + "_customerItemsTable > tbody");
        addCharge.value += (Number(itemCharges));
        addUnits(Number(itemUnit), divId);
        $("#" + divId + "_specialItemName").val("");
        $("#" + divId + "_specialItemCharges").val("");
        $("#" + divId + "_specialItemUnit").val("");
        $("#" + divId + "_specialItemQty").val("");
        $("#" + divId + "_specialItemRemark").val("");
        $("#" + divId + "_specialItemName").focus();
        update_services(divId);
    } else {
        var modal = document.getElementById("salesModal");
        var salesStatus = document.getElementById("salesStatus");
        var salesMessage = document.getElementById("salesMessage");
        salesStatus.innerHTML = "<b>ERROR</b>";
        salesMessage.innerHTML = errorMsg;
        modal.style.display = "block";
    }
}
function deleteItem(btn, divId) {
    var row = btn.parentNode.parentNode;
    var nodes = row.childNodes;
    var unit = nodes[4].innerHTML.substring(0, nodes[4].innerHTML.indexOf("<"));
    subtractUnits(Number(unit), divId);
    var charge = nodes[2].innerHTML.substring(0, nodes[2].innerHTML.indexOf("<"));
    if (!isNaN(charge)) {
        var tuObject = additionalCharges.find(function (obj) {
            return obj.id === divId;
        });
        tuObject.value -= Number(charge);
    }
    row.parentNode.removeChild(row);
    update_services(divId);
}
//--------------------------------End-----------------------------------//

//-----------------------Vimbox Item Functions--------------------------//
function addVimboxBox(divId) {
    var boxUnit = $("#" + divId + "_vimboxBoxUnit").val();
    var boxObject = boxes.find(function (obj) {
        return obj.id === divId;
    });
    var errorMsg = "";
    var add = true;
    if (!boxUnit) {
        add = false;
        errorMsg += "Please enter an unit<br>";
    }

    if (add) {
        var tr = "<tr><td>Boxes<input type='hidden' name='" + divId + "_vimboxItemName' value='Boxes'></td>";
        tr += "<td>&nbsp;<input type='hidden' name='" + divId + "_vimboxItemRemark' value=''></td>";
        tr += "<td align='center'>&nbsp;&nbsp;&nbsp;&nbsp;<input type='hidden' name='" + divId + "_vimboxItemCharge' value=''></td>";
        tr += "<td align='center'>" + boxUnit + "<input type='hidden' name='" + divId + "_vimboxItemQty' value='" + boxUnit + "'></td>";
        tr += "<td align='center'>" + boxUnit + "<input type='hidden' name='" + divId + "_vimboxItemUnit' value='" + boxUnit + "'></td>";
        tr += "<td align='right'><input class='form-control' type='button' value='x' onclick=\"deleteBox(this, '" + divId + "')\"/></td></tr>";
        $(tr).prependTo("#" + divId + "_vimboxItemsTable > tbody");
        addUnits(Number(boxUnit), divId);
        boxObject.value += (Number(boxUnit));
        $("#" + divId + "_vimboxBoxUnit").val("");
        update_services(divId);
    } else {
        var modal = document.getElementById("salesModal");
        var salesStatus = document.getElementById("salesStatus");
        var salesMessage = document.getElementById("salesMessage");
        salesStatus.innerHTML = "<b>ERROR</b>";
        salesMessage.innerHTML = errorMsg;
        modal.style.display = "block";
    }
}

function addVimboxMaterial(divId) {
    var itemName = $("#" + divId + "_vimboxMaterial").val();
    var itemUnit = $("#" + divId + "_vimboxMaterialUnit").val();
    var itemCharge = $("#" + divId + "_vimboxMaterialCharge").val();
    var matObject = materialCharges.find(function (obj) {
        return obj.id === divId;
    });
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
        var tr = "<tr><td>" + itemName + "<input type='hidden' name='" + divId + "_vimboxMaterialName' value='" + itemName + "'></td>";
        tr += "<td>&nbsp;</td>";
        tr += "<td align='center'>" + itemCharge + "<input type='hidden' name='" + divId + "_vimboxMaterialCharge' value='" + itemCharge + "'></td>";
        tr += "<td align='center'>" + itemUnit + "<input type='hidden' name='" + divId + "_vimboxMaterialQty' value='" + itemUnit + "'></td>";
        tr += "<td align='center'>&nbsp;</td>";
        tr += "<td align='right'><input class='form-control' type='button' value='x' onclick='deleteMaterial(this)'/></td></tr>";
        $(tr).prependTo("#" + divId + "_vimboxItemsTable > tbody");
        matObject.value += (Number(itemCharge));
        $("#" + divId + "_vimboxMaterial").val("");
        $("#" + divId + "_vimboxMaterialUnit").val("");
        $("#" + divId + "_vimboxMaterialCharge").val("");
        $("#" + divId + "_materialCharge").val(Number(matObject.value).toFixed(2));
        $("#" + divId + "_vimboxMaterial").focus();
        update_total(divId);
    } else {
        var modal = document.getElementById("salesModal");
        var salesStatus = document.getElementById("salesStatus");
        var salesMessage = document.getElementById("salesMessage");
        salesStatus.innerHTML = "<b>ERROR</b>";
        salesMessage.innerHTML = errorMsg;
        modal.style.display = "block";
    }
}

function deleteMaterial(btn, divId) {
    var row = btn.parentNode.parentNode;
    var nodes = row.childNodes;
    var charge = nodes[2].innerHTML.substring(0, nodes[2].innerHTML.indexOf("<"));
    var matObject = materialCharges.find(function (obj) {
        return obj.id === divId;
    });
    if (!isNaN(charge)) {
        matObject.value -= Number(charge);
    }
    row.parentNode.removeChild(row);
    $("#" + divId + "_materialCharge").val(matObject.value);
}

function deleteBox(btn, divId) {
    var row = btn.parentNode.parentNode;
    var nodes = row.childNodes;
    var unit = nodes[4].innerHTML.substring(0, nodes[4].innerHTML.indexOf("<"));
    subtractUnits(Number(unit), divId);
    var tuObject = boxes.find(function (obj) {
        return obj.id === divId;
    });
    tuObject.value -= Number(unit);
    row.parentNode.removeChild(row);
    update_services(divId);
}
//--------------------------------End-----------------------------------//

//-----------------------Customer C&R Functions-------------------------//
function addCustomerComment(divId) {
    var comment = $("#" + divId + "_customerComment").val();
    if (comment) {
        var tr = "<tr><td>" + comment + "<input type='hidden' name='" + divId + "_comments' value='" + comment + "'></td><td align='right'><input type='button' value='x' onclick='deleteRow(this)'/></td></tr>";
        $(tr).prependTo("#" + divId + "_commentsTable > tbody");
        $("#" + divId + "_customerComment").val("");
    } else {
        var modal = document.getElementById("salesModal");
        var salesStatus = document.getElementById("salesStatus");
        var salesMessage = document.getElementById("salesMessage");
        salesStatus.innerHTML = "<b>ERROR</b>";
        salesMessage.innerHTML = "Please enter a comment";
        modal.style.display = "block";
    }
}

function addCustomerRemark(divId) {
    var remark = $("#" + divId + "_customerRemark").val();
    if (remark) {
        var tr = "<tr><td>" + remark + "<input type='hidden' name='" + divId + "_remarks' value='" + remark + "'></td><td align='right'><input type='button' value='x' onclick='deleteRow(this)'/></td></tr>";
        $(tr).prependTo("#" + divId + "_remarksTable > tbody");
        $("#" + divId + "_customerRemark").val("");
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
function selectServiceSlot(e, divId) {
    var frml = formula.find(function (obj) {
        return obj.id === divId;
    });

    var cell = $(e);
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
                    $("#" + divId + "_manpowerId").val(id);
                    var modal = document.getElementById(divId + "_manpowerModal");
                    modal.style.display = "block";
                }
                (frml.value)[divId + "_" + id] = serviceArray[1];
                var tr = "<tr id='" + divId + "_" + id + "'><td>";
                tr += "<table class='table serviceTable'>"
                tr += "<tr height='10%'><td>" + pri + " - " + sec + "<input type='hidden' name='" + divId + "_serviceName' value='" + id + "'></td><td align='right'>\n\
<div class='input-group'><span class='input-group-addon'>$</span><input class='form-control' type='number' step='0.01' min='0' name='" + divId + "_serviceCharge'></div></td></tr>";
                tr += "<tr>" + generateBreakdown(divId + "_" + id, divId) + "</tr></table></td></tr>";
                $("#" + divId + "_servicesTable").append(tr);
                cell.addClass('selected');
                cell.data('state', 'selected');
                break;
            case 'selected':
                if (pri === "Manpower") {
                    removeManpower(divId + "_" + id, divId);
                }
                cell.removeClass('selected');
                cell.data('state', '');
                delete (frml.value)[divId + "_" + id];
                $("#" + divId + "_" + id).remove();
                break;
            default:
                break;
        }
        update_services(divId);
    }
}

function generateBreakdown(id, divId) {
    var totalUnit = totalUnits.find(function (obj) {
        return obj.id === divId;
    });
    var box = boxes.find(function (obj) {
        return obj.id === divId;
    });
    var addCharge = additionalCharges.find(function (obj) {
        return obj.id === divId;
    });
    var mp = manpower.find(function (obj) {
        return obj.id === divId;
    });
    var frml = formula.find(function (obj) {
        return obj.id === divId;
    });

    var fml = (frml.value)[id].split(" ");
    var breakdown = "<td colspan='2'><table width='100%' cellpadding=0 cellspacing=0 style='border-collapse: collapse;'><col width='50%'><col width='50%'>";
    for (i = 0; i < fml.length; i++) {
        var action = fml[i];
        switch (action) {
            case "U":
                breakdown += "<tr><td align='left'>&nbsp;&nbsp;&nbsp;Total Units</td>";
                breakdown += "<td align='right'><label id='" + divId + "_" + id + "unitsLbl'>" + totalUnit.value + "</label></td></tr>";
                break;
            case "B":
                breakdown += "<tr><td align='left'>&nbsp;&nbsp;&nbsp;Boxes</td>";
                breakdown += "<td align='right'><label id='" + divId + "_" + id + "boxesLbl'>" + box.value + "</label></td></tr>";
                break;
            case "MP":
                var man = (mp.value)[id];
                if (man == null) {
                    man = 0;
                }
                breakdown += "<tr><td align='left'>&nbsp;&nbsp;&nbsp;Manpower</td>";
                breakdown += "<td align='right'><label id='" + divId + "_" + id + "mpLbl'>" + man + "</label></td></tr>";
                break;
            case "AC":
                breakdown += "<tr><td align='left'>&nbsp;&nbsp;&nbsp;Additional Charges</td>";
                breakdown += "<td align='right'><label id='" + divId + "_" + id + "acLbl'>" + addCharge.value + "</label></td></tr>";
                break;
            default:
                break;
        }
    }
    breakdown += "</table></td>";
    return breakdown;
}

function removeManpower(id, divId) {
    var mp = manpower.find(function (obj) {
        return obj.id === divId;
    });

    var mpLbl = id + "manpowerLabel";
    var mprLbl = id + "manpowerReasonLabel";
    var mpIpt = id + "manpowerInput";
    var rIpt = id + "reasonInput";
    document.getElementById(mpIpt).value = "";
    document.getElementById(rIpt).value = "";
    delete (mp.value)[id];
    document.getElementById(mpLbl).innerHTML = "";
    document.getElementById(mprLbl).innerHTML = "";
}

function submitManpower(divId) {
    var mpObject = manpower.find(function (obj) {
        return obj.id === divId;
    });
    var mp = mpObject.value;

    var id = $("#" + divId + "_manpowerId").val();
    var addManpower = $("#" + divId + "_additionalManpower").val();
    var manReason = $("#" + divId + "_manpowerReason").val();

    if (!addManpower || !manReason) {
        var modal = document.getElementById("salesModal");
        var status = document.getElementById("salesStatus");
        var message = document.getElementById("salesMessage");
        status.innerHTML = "ERROR";
        message.innerHTML = "Please enter both the required manpower and reason";
        modal.style.display = "block";
    } else {
        mp[id] = Number(addManpower);
        var mpLbl = divId + "_" + id + "manpowerLabel";
        var mprLbl = divId + "_" + id + "manpowerReasonLabel";
        document.getElementById(mpLbl).innerHTML = addManpower;
        document.getElementById(mprLbl).innerHTML = manReason;
        var mpIpt = divId + "_" + id + "manpowerInput";
        var rIpt = divId + "_" + id + "reasonInput";
        document.getElementById(mpIpt).value = addManpower;
        document.getElementById(rIpt).value = manReason;
        var modal = document.getElementById(divId + "_manpowerModal");
        $("#" + divId + "_additionalManpower").val('');
        $("#" + divId + "_manpowerReason").val('');
        modal.style.display = "none";
        update_services(divId);
    }
}

function closeManpowerModal(divId) {
    var frml = formula.find(function (obj) {
        return obj.id === divId;
    });
    var modal = document.getElementById(divId + "_manpowerModal");
    var id = $("#" + divId + "_manpowerId").val();
    var cellId = divId + $("#" + divId + "_manpowerId").val() + "_service";
    var cell = document.getElementById(cellId);
    removeManpower(divId + "_" + id, divId);
    $(cell).removeClass('selected');
    $(cell).data('state', '');
    delete (frml.value)[divId + "_" + id];
    $("#" + divId + "_" + id).remove();
    modal.style.display = "none";
    update_services(divId);
}

function selectService(divId) {
    var modal = document.getElementById(divId + "_serviceModal");
//    $.getJSON("LoadServices", {leadDivStr: leadDivStr})
//            .done(function (data) {
//                document.getElementById('service-body').innerHTML = data;
//                modal.style.display = "block";
//            })
    modal.style.display = "block";
}
//--------------------------------End-----------------------------------//

function confirmCancel() {
    var modal = document.getElementById("lead_error_modal");
    var status = document.getElementById("lead_error_status");
    var message = document.getElementById("lead_error_message");
    status.innerHTML = "<b>Cancel Confirmation</b>";
    message.innerHTML = "<table width='100%'><tr><td colspan='2'>Cancel this lead record? All pending site surveys of this lead will be cancelled as well. Changes cannot be reverted.</td></tr><tr><td align='center'><button onclick=\"cancelLeadForm()\">Yes</button></td><td align='center'><button onclick=\"closeModal('lead_error_modal')\">No</button></td></tr></table>";
    modal.style.display = "block";
}

function viewCal() {
    var errorModal = document.getElementById("salesModal");
    var errorStatus = document.getElementById("salesStatus");
    var errorMessage = document.getElementById("salesMessage");
    
    var modal = document.getElementById("cal_modal");
    $.get("SiteSurveyCalendar.jsp",{}, function (data) {
        document.getElementById("cal_content").innerHTML = data;
    });
    var d = new Date();
    var m = d.getMonth();
    var y = d.getFullYear();
    var m_names = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    var n = m_names[d.getMonth()];
    $("#dMonth").html(n);
    $("#dYear").html(y);
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
    
    $.getJSON("ValidateSiteSurveyDates", {addressFrom: addressFrom, addressTo: addressTo})
    .done(function (data) {
        if (data.status !== "SUCCESS") {
            errorStatus.innerHTML = "WARNING";
            errorMessage.innerHTML = data.message + "In order to select site survey timeslots<br>";
            errorModal.style.display = "block";
            domPass = false;
        }else{
            domPass = true;
        } 
    })
    .fail(function (error) {
        errorStatus.innerHTML = "ERROR";
        errorMessage.innerHTML = error;
        errorModal.style.display = "block";
    });
    
    var content = document.getElementById("ssCalTable");
    $.get("SiteSurveyCalendarPopulate.jsp", {getYear: y, getMonth: m, getSS: "allss"}, function (data) {
        content.innerHTML = data;
    });
    modal.style.display = "block";
}

function viewMovCal(){
    var errorModal = document.getElementById("salesModal");
    var errorStatus = document.getElementById("salesStatus");
    var errorMessage = document.getElementById("salesMessage");
    
    var modal = document.getElementById("cal_modal");
    $.get("MovingCalendar.jsp",{}, function (data) {
        document.getElementById("cal_content").innerHTML = data;
    });
    var d = new Date();
    var m = d.getMonth();
    var y = d.getFullYear();
    var m_names = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    var n = m_names[d.getMonth()];
    $("#dMonth").html(n);
    $("#dYear").html(y); 
    
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
    
    $.getJSON("ValidateMovingDates", {addressFrom: addressFrom, addressTo: addressTo})
    .done(function (data) {
        if (data.status !== "SUCCESS") {
            errorStatus.innerHTML = "WARNING";
            errorMessage.innerHTML = data.message + "In order to select dom timeslots<br>";
            errorModal.style.display = "block";
            domPass = false;
        }else{
            domPass = true;
        } 
    })
    .fail(function (error) {
        errorStatus.innerHTML = "ERROR";
        errorMessage.innerHTML = error;
        errorModal.style.display = "block";
    });
    
    var content = document.getElementById("ssCalTable");
    $.get("MovingCalendarPopulate.jsp", {getYear: y, getMonth: m, getTT: "alltt"}, function (data) {
        content.innerHTML = data;
    });
    modal.style.display = "block";
}

function changeMonthYear() {
    var content = document.getElementById("ssCalTable");
    var iYear = document.getElementById('iYear').value;
    var iMonth = document.getElementById('iMonth').value;
    var ss = document.getElementById('ssSelect').value;
    var m_names = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    var n = m_names[iMonth];
    $("#dMonth").html(n);
    $("#dYear").html(iYear);
    $.get("SiteSurveyCalendarPopulate.jsp", {getYear: iYear, getMonth: iMonth, getSS: ss}, function (data) {
        content.innerHTML = data;
    });
}

function changeMoveMonthYear(){
    var content = document.getElementById("ssCalTable");
    var iYear = document.getElementById('iYear').value;
    var iMonth = document.getElementById('iMonth').value;
    var tt = document.getElementById('ttSelect').value;
    var m_names = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    var n = m_names[iMonth];
    $("#dMonth").html(n);
    $("#dYear").html(iYear);
    $.get("MovingCalendarPopulate.jsp", {getYear: iYear, getMonth: iMonth, getTT: tt}, function (data) {
        content.innerHTML = data;
    });
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
                        my_leads_setup($('#uId').val());
                        document.getElementById("cancelLeadModal").style.display = "none";
                        modal.style.display = "none";
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

function viewCancelReason(){
    document.getElementById("viewReasonModal").style.display = "block";
}

function viewDaySchedule(date) {
    var errorModal = document.getElementById("salesModal");
    var errorStatus = document.getElementById("salesStatus");
    var errorMessage = document.getElementById("salesMessage");
    //var date = $('#selectedDate').val();
    var elem = document.getElementById(date);
    var pending = true;
    if (elem != null) {
        var input = elem.getElementsByTagName('input')[0];
        if (input.value === 'no') {
            pending = false;
            errorStatus.innerHTML = "ERROR";
            errorMessage.innerHTML = "A site survey is ongoing/completed on this date";
            errorModal.style.display = "block";
        }
    }
    if (pending) {
        var siteSurveyor = $('#ssSelect').val();
        var addressFrom = "";
        var addressTo = "";
        
        if(domPass){
            var fromArray = document.getElementsByName("addressfrom");
            for (i = 0; i < fromArray.length; i++) {
                addressFrom += fromArray[i].value + "|";
            }
            var toArray = document.getElementsByName("addressto");
            for (i = 0; i < toArray.length; i++) {
                addressTo += toArray[i].value + "|";
            }
        }
        
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
        var leadId = $('#leadId').val();
        if(leadId == null){
            leadId = 0;
        }
        $.get("RetrieveSiteSurveyorSchedule.jsp", {leadId: leadId, date: date, siteSurveyor: siteSurveyor, addressFrom: addressFrom, addressTo: addressTo, nric: nric, timeslots: timeslots, addresses: addresses, remarks: remarks}, function (results) {
            document.getElementById("schedule_content").innerHTML = results;
            document.getElementById("schedule_modal").style.display = "block";
        });
    }
}

function assignDOM() {
    var date = $('#move_date').val();
    var addressesFr = document.getElementsByName("move_addressFrom");
    var addressesTo = document.getElementsByName("move_addressTot");
    var carplates = document.getElementsByName("move_carplates");
    var trucks = document.getElementsByName("move_truck_name");
    var timeslots = [];
    
    var remarks = $('#move_remarks').val();

    var errorMsg = "";
    if (carplates.length === 0) {
        errorMsg += "Please choose at least a truck<br>";
    }else{
        for (i = 0; i < carplates.length; i++) {
            var ts = document.getElementsByName(carplates[i].value + "_move_timeslot");
            var times = [];
            for(j = 0; j < ts.length; j++){
                times.push(ts[j].value);
            }
            timeslots.push({id: carplates[i].value, value: times});
        }
        
    }
    if (addressesFr.length === 0) {
        errorMsg += "Please choose an moving from address<br>";
    }
    if (addressesTo.length === 0) {
        errorMsg += "Please choose an moving to address<br>";
    }
    
    
    var modal = document.getElementById("salesModal");
    var status = document.getElementById("salesStatus");
    var message = document.getElementById("salesMessage");
    
    if(!errorMsg){                           
        var elem = document.getElementById("dom_" + date);
        if (elem != null) {
            elem.parentNode.removeChild(elem);
        }

        var newdiv = document.createElement('div');
        var stringDiv = "";
        stringDiv += "<div id='dom_" + date + "'>";
        stringDiv += "<span class='close' onClick=\"removeSiteSurvey('dom_" + date + "')\">x</span>";
        stringDiv += "<hr><div class='form-horizontal'>";
        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Date of Move: </label><div class='col-sm-4' style='padding-top: 7px;'>";
        stringDiv += "<input type='hidden' name='move_date' value='" + date + "'>" + date + "</div></div>";
        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Truck(s): </label><div class='col-sm-3' style='padding-top: 7px;'>"; 
        for (i = 0; i < carplates.length; i++) {
            stringDiv += "<div><div class='col-sm-7' style='padding-left: 0px;'><input type='hidden' name='move_truck' value='" + date + "|" + carplates[i].value + "'>" + trucks[i].value + "</div>";
            var timeslot = timeslots.find(function (obj) {
                return obj.id === carplates[i].value;
            });
            stringDiv += "<div class='col-sm-5'>"
            for(j = 0; j < timeslot.value.length; j++){
                stringDiv += "<input type='hidden' name='" + carplates[i].value + "_move_timeslots' value='" + (timeslot.value)[j] + "'>" + (timeslot.value)[j] + "<br>";
            }
            stringDiv += "</div></div><br>";
        }
        stringDiv += "</div></div>";
        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>From: </label><div class='col-sm-5' style='padding-top: 7px;'>";
        for (i = 0; i < addressesFr.length; i++) {
            stringDiv += "<input type='hidden' name='move_addressFr' value='" + date + "|" + addressesFr[i].value + "'>" + addressesFr[i].value + "<br>";
        }
        stringDiv += "</div></div>";
        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>To: </label><div class='col-sm-5' style='padding-top: 7px;'>";
        for (i = 0; i < addressesTo.length; i++) {
            stringDiv += "<input type='hidden' name='move_addressTo' value='" + date + "|" + addressesTo[i].value + "'>" + addressesTo[i].value + "<br>";
        }
        stringDiv += "</div></div>";
        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Remarks: </label><div class='col-sm-4' style='padding-top: 7px;'>";
        stringDiv += "<input type='hidden' name='move_remarks' value='" + date + "|" + remarks + "'><input type='hidden' name='move_status' value='" + date + "|Booking'>" + remarks + "</div></div>";
        stringDiv += "</div></div>";
        newdiv.innerHTML = stringDiv;
        document.getElementById("operation").appendChild(newdiv);

        status.innerHTML = "SUCCESS";
        message.innerHTML = "Date of Move selected!";
        modal.style.display = "block";
        document.getElementById("schedule_modal").style.display = "none";
        setTimeout(function () {
            modal.style.display = "none";
        }, 1000);
    }else{
        status.innerHTML = "ERROR";
        message.innerHTML = errorMsg;
        modal.style.display = "block";
    }
}

function viewMoveDaySchedule(date) {
    var errorModal = document.getElementById("salesModal");
    var errorStatus = document.getElementById("salesStatus");
    var errorMessage = document.getElementById("salesMessage");
    var div = document.getElementById("dom_" + date);
    var truck = $('#ttSelect').val();
    var errorMsg = "";
    var timeslots = "";
    var addressesFr = "";
    var addressesTo = "";
    var carplates = "";
    
    if (div != null) {
        var carplateArray = $("#dom_" + date + " input[name=move_truck]");
        if(carplateArray.length > 1 && truck !== "alltt"){
            errorMsg += "Unable to view day schedule for selected truck.<br>Please de-select truck to view schedule."
        }
        for (var i = 0; i < carplateArray.length; i++) {
            if (carplateArray[i].value.includes(date)) {
                var cp = (carplateArray[i].value.split("|"))[1];
                carplates += cp + "|";
                var timeArray = $("#dom_" + date + " input[name=" + cp + "_move_timeslots]");
                for (var j = 0; j < timeArray.length; j++) {
                    timeslots += cp + "_" + timeArray[j].value + "|";
                }
            }
        }

        var addressFrArray = $("#dom_" + date + " input[name=move_addressFr]");
        for (var i = 0; i < addressFrArray.length; i++) {
            if (addressFrArray[i].value.includes(date)) {
                addressesFr += (addressFrArray[i].value.split("|"))[1] + "|";
            }
        }

        var addressToArray = $("#dom_" + date + " input[name=move_addressTo]");
        for (var i = 0; i < addressToArray.length; i++) {
            if (addressToArray[i].value.includes(date)) {
                addressesTo += (addressToArray[i].value.split("|"))[1] + "|";
            }
        }

        var remarksArray = $("#dom_" + date + " input[name=move_remarks]");
        var remarks = "";
        for (var i = 0; i < remarksArray.length; i++) {
            if (remarksArray[i].value.includes(date)) {
                remarks = (remarksArray[i].value.split("|"))[1];
                break;
            }
        }
    }
    
    if(!errorMsg){
        var addressFrom = "";
        var addressTo = "";
        if(domPass){
            var fromArray = document.getElementsByName("addressfrom");
            for (i = 0; i < fromArray.length; i++) {
                addressFrom += fromArray[i].value + "|";
            }
            var toArray = document.getElementsByName("addressto");
            for (i = 0; i < toArray.length; i++) {
                addressTo += toArray[i].value + "|";
            }
        }

        var leadId = $('#leadId').val();
        if(leadId == null){
            leadId = 0;
        }
        
        $.get("RetrieveMovingSchedule.jsp", {leadId: leadId, date: date, truck: truck, carplate: carplates, addressFrom: addressFrom, addressTo: addressTo, timeslots: timeslots, addressesFr: addressesFr, addressesTo: addressesTo, remarks: remarks}, function (results) {
            document.getElementById("schedule_content").innerHTML = results;
            document.getElementById("schedule_modal").style.display = "block";
        });
    }else{
        errorStatus.innerHTML = "ERROR";
        errorMessage.innerHTML = errorMsg;
        errorModal.style.display = "block";
    }          
}

function viewSchedule() {
    var errorModal = document.getElementById("salesModal");
    var errorStatus = document.getElementById("salesStatus");
    var errorMessage = document.getElementById("salesMessage");
    var date = $('#sitesurvey_date').val();
    var elem = document.getElementById(date);
    var pending = true;
    if (elem != null) {
        var input = elem.getElementsByTagName('input')[0];
        if (input.value === 'no') {
            pending = false;
            errorStatus.innerHTML = "ERROR";
            errorMessage.innerHTML = "A site survey is ongoing/completed on this date";
            errorModal.style.display = "block";
        }
    }
    if (pending) {
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
}

function selectDOMSlot(e){
    var cell = $(e);
    var state = cell.data('state') || '';
    var cellHtml = cell.html().trim();

    if (cellHtml) {
        var cellDetails = cellHtml.substring(cellHtml.indexOf("{") + 1, cellHtml.lastIndexOf("}"));
        var cellArray = cellDetails.split("|");
        var carplate = cellArray[0];
        var truck = cellArray[1]
        var cellTiming = cellArray[2];
        switch (state) {
            case '':
                var tr = "<tr data-value='{" + carplate + "|" + truck + "|" + cellTiming + "}'><td><input type='hidden' name='" + carplate + "_move_timeslot' value='" + cellTiming + "'>";
                tr += "<div class='input-group' style='padding-bottom: 4px;'><span class='form-control'>" + cellTiming + "</span><span class='input-group-btn'><input type='button' class='btn btn-round btn-warning' value='x' onclick='deleteMoveTimeRow(this)'/></span></div></td></tr>";
                var after = true;
                var timetable = document.getElementById(carplate + "_timeslot_table");
                if(timetable == null){
                    var tableTr = "<tr style='border-bottom: 1pt solid #dfe8f1;' id='" + carplate + "'>";   
                    tableTr += "<td><input type='hidden' name='move_carplates' value='" + carplate + "'><input type='hidden' name='move_truck_name' value='" + truck + "'><label name='truck_label'>" + truck + "</label></td>";
                    tableTr += "<td><table id='" + carplate + "_timeslot_table'><tbody></tbody></table></td>";
                    tableTr += "</tr>";
                    $("#truck_assigned_table").append(tableTr);
                    $("#" + carplate + "_timeslot_table > tbody").append(tr);
                }else{
                    loop1:
                    for (var i = 0, timerow; timerow = timetable.rows[i]; i++) {
                        var tableCell = $(timerow).data('value');
                        var tableCellDetails = tableCell.substring(tableCell.indexOf("{") + 1, tableCell.lastIndexOf("}"));
                        var tableCellArray = tableCellDetails.split("|");
                        var tableTimeSlot = tableCellArray[2];
                        var num = cellTiming.localeCompare(tableTimeSlot);
                        if (num === -1) {
                            after = false;
                        }

                        if (i === 0 && after === false) {
                            $(tr).prependTo("#" + carplate + "_timeslot_table > tbody");
                            break loop1;
                        } else if (after === false) {
                            $("#" + carplate + "_timeslot_table > tbody > tr").eq(i - 1).after(tr);
                            break loop1;
                        }
                    }


                    if (after) {
                        $("#" + carplate + "_timeslot_table > tbody").append(tr);
                    }
                }
                
                cell.addClass('selected');
                cell.data('state', 'selected');
                break;
            case 'selected':
                var table = document.getElementById("move_timeslot_table");
                for (var i = 0, row; row = table.rows[i]; i++) {
                    if ($(row).data('value').includes(carplate + "|" + truck + "|" + cellTiming)) {
                        row.parentNode.removeChild(row);
                        break;
                    }
                }
                cell.removeClass('selected');
                cell.data('state', '');
                var empty = true;
                var table = document.getElementById("moving_table");
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
                    $('#truck_carplate').val('');
                    $('#truck').val('');
                    document.getElementById("truck_label").innerHTML = "";
                }
                break;
            default:
                break;
        }
    }
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

                var tr = "<tr data-value='{" + nric + "|" + employee + "|" + timeslot + "}'><input type='hidden' name='timeslot' value='" + timeslot + "'>";
                tr += "<td><div class='input-group' style='padding-bottom: 4px;'><span class='form-control'>" + timeslot + "</span><span class='input-group-btn'><input type='button' class='btn btn-round btn-warning' value='x' onclick='deleteSurveyRow(this)'/></span></div></td></tr>";
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

function deleteMoveTimeRow(btn){
    var row = btn.parentNode.parentNode;
    var value = $(row).data('value');
    row.parentNode.removeChild(row);
    
    var table = document.getElementById("moving_table");
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
    
    var valueDetails = value.substring(value.indexOf("{") + 1, value.lastIndexOf("}"));
    var valueArray = valueDetails.split("|");
    var carplate = valueArray[0];
    var childNodes = document.getElementById(carplate + "_timeslot_table").childNodes;
    var node;
    for(i=0; i < childNodes.length; i++){
        if(childNodes[i].nodeName === "TBODY"){
            node = childNodes[i];
        }
    }
    childNodes = node.childNodes;
    var count = 0;
    for(i=0; i < childNodes.length; i++){
        if(childNodes[i].nodeName === "TR"){
            count++;
        }
    }
    if(count === 0){
        $("#" + carplate).remove();
    }
}

function deleteAddressRow(btn) {
    var row = btn.parentNode.parentNode;
    row.parentNode.removeChild(row);
}

function addAddress() {
    var address = $('#address_select').val();
    if (address !== '') {
        var tr = "<tr><input type='hidden' name='site_address' value='" + address + "'>";
        tr += "<td><div class='input-group' style='padding-bottom: 4px;'><span class='form-control'>" + address + "</span><span class='input-group-btn'><input type='button' class='btn btn-round btn-warning' value='x' onclick='deleteAddressRow(this)'/></span></div></td></tr>";
        
        
        $(tr).prependTo("#address_table > tbody");
    }
    $('#address_select').val('');
}

function addMoveFrAddress(){
    var address = $('#move_addressFrom_select').val();
    if (address !== '') {
        var tr = "<tr><td><input type='hidden' name='move_addressFrom' value='" + address + "'>";
        tr += "<div class='input-group' style='padding-bottom: 4px;'><span class='form-control'>" + address + "</span><span class='input-group-btn'><input type='button' class='btn btn-round btn-warning' value='x' onclick='deleteAddressRow(this)'/></span></div></td></tr>";
        $(tr).prependTo("#move_addressFrom_table > tbody");
    }
    $('#move_addressFrom_select').val('');
}

function addMoveToAddress(){
    var address = $('#move_addressTo_select').val();
    if (address !== '') {
        var tr = "<tr><td><input type='hidden' name='move_addressTot' value='" + address + "'>";
        tr += "<div class='input-group' style='padding-bottom: 4px;'><span class='form-control'>" + address + "</span><span class='input-group-btn'><input type='button' class='btn btn-round btn-warning' value='x' onclick='deleteAddressRow(this)'/></span></div></td></tr>";
        $(tr).prependTo("#move_addressTo_table > tbody");
    }
    $('#move_addressTo_select').val('');
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
        stringDiv += "<span class='close' onClick=\"removeSiteSurvey('" + date + "')\">x</span>";
        stringDiv += "<hr><div class='form-horizontal'>";
        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Date: </label><div class='col-sm-4' style='padding-top: 7px;'>";
        stringDiv += "<input type='hidden' name='siteSurvey_date' value='" + date + "'>" + date + "</div></div>";
        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Time Slot: </label><div class='col-sm-4' style='padding-top: 7px;'>";
        for (i = 0; i < timeslots.length; i++) {
            stringDiv += "<input type='hidden' name='siteSurvey_timeslot' value='" + date + "|" + timeslots[i].value + "'>" + timeslots[i].value + "<br>";
        }
        stringDiv += "</div></div>";
        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Address: </label><div class='col-sm-4' style='padding-top: 7px;'>";
        for (i = 0; i < addresses.length; i++) {
            stringDiv += "<input type='hidden' name='siteSurvey_address' value='" + date + "|" + addresses[i].value + "'>" + addresses[i].value + "<br>";
        }
        stringDiv += "</div></div>";
        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Surveyor: </label><div class='col-sm-4' style='padding-top: 7px;'>";
        stringDiv += "<input type='hidden' name='siteSurvey_surveyor' value='" + date + "|" + surveyorId + "'>" + surveyorName + "</div></div>";
        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Remarks: </label><div class='col-sm-4' style='padding-top: 7px;'>";
        stringDiv += "<input type='hidden' name='siteSurvey_remarks' value='" + date + "|" + remarks + "'>" + remarks + "</div></div>";
        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Status: </label><div class='col-sm-4' style='padding-top: 7px;'>";
        stringDiv += "<input type='hidden' name='siteSurvey_status' value='" + date + "|Pending'>Pending</div></div>";
        stringDiv += "</div></div>";
        newdiv.innerHTML = stringDiv;
        document.getElementById("survey").appendChild(newdiv);

        status.innerHTML = "SUCCESS";
        message.innerHTML = "Site survey assigned!";
        modal.style.display = "block";
        document.getElementById("schedule_modal").style.display = "none";
        setTimeout(function () {
            modal.style.display = "none";
        }, 1000);
    } else {

        status.innerHTML = "ERROR";
        message.innerHTML = errorMsg;
        modal.style.display = "block";
        setTimeout(function () {
            modal.style.display = "none";
        }, 1000);
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
            legendArray.push({name: surveyor_name, color: colors[colorCounter].strokeColor});
            setDirection(colors[colorCounter], map, polyline, function (result) {
                console.log(result);
            });
            surveyor_name = name;
            polyline = [];
            colorCounter += 1;
        }

        for (p = 0; p < address.length; p++) {
            var url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + address[p].substring(address[p].lastIndexOf("S") + 1) + "&key=AIzaSyAlr3mj-08qPnSvod0WtYbmE0NrulFq0RE"
            $.getJSON(url)
                    .done(function (data) {
                        if (data.status == google.maps.GeocoderStatus.OK) {
                            var latitude = data.results[0].geometry.location.lat;
                            var longitude = data.results[0].geometry.location.lng;
                            var latlng = new google.maps.LatLng(latitude, longitude);

                            var exist = false;
                            for (h = 0; h < polyline.length; h++) {
                                var polyLatLng = polyline[h];
                                if (polyLatLng.lat() === latitude && polyLatLng.lng() === longitude) {
                                    exist = true;
                                }
                            }

                            if (!exist) {
                                polyline.push(latlng);
                                createMarker(latlng, addressArray[3], addressArray[0], address[p], addressArray[2], map, infowindow);
                            }

                        } else {
                            console.log(data.status);
                        }
                    })
                    .fail(function (error) {
                        console.log(error)
                    });
        }

        if (j === addresses.length - 1) {
            legendArray.push({name: surveyor_name, color: colors[colorCounter].strokeColor});
            setDirection(colors[colorCounter], map, polyline, function (result) {
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

function setDirection(polyLineOption, map, polyline, callback) {
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
        map: map
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
                        var tr = "<tr data-value='{" + employeeSelected + "|" + timeslot + "}'><input type='hidden' name='timeslot' value='" + timeslot + "'>";
                        tr += "<td><div class='input-group' style='padding-bottom: 4px;'><span class='form-control'>" + timeslot + "</span><span class='input-group-btn'><input type='button' class='btn btn-round btn-warning' value='x' onclick='deleteSurveyRow(this)'/></span></div></td></tr>";
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

function invalidDate() {
    var modal = document.getElementById("salesModal");
    var salesStatus = document.getElementById("salesStatus");
    var salesMessage = document.getElementById("salesMessage");
    salesStatus.innerHTML = "Invalid Date";
    salesMessage.innerHTML = "Unable to assign past dates.";
    modal.style.display = "block";
    setTimeout(function () {
        modal.style.display = "none";
    }, 1300);
}

function my_leads_setup(nric){
    load_leads('', nric, "Pending");
    load_leads('', nric, "Confirmed");
    load_leads('', nric, "Rejected");
}

function load_leads(keyword, nric, type){
    $.get("LoadMyLeads.jsp", {keyword: keyword, nric: nric, type: type}, function (data) {
        document.getElementById(type).innerHTML = data;
    });
}

function viewSalesPortion(leadId) {
    var modal = document.getElementById("viewLeadModal");
    var content = document.getElementById("leadContent");
    $.get("RetrieveSalesPortion.jsp", {getLid: leadId}, function (data) {
        content.innerHTML = data;
    });
    modal.style.display = "block";
}