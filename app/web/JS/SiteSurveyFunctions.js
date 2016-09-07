var selectedItemDetail = "";
var selectedItemType = [];
var areaUnits = [];

var formula = [];
var symbols = ["+", "-", "/", "x"];
var additionalCharges = [];
var materialCharges = [];
var totalUnits = [];
var boxes = [];
var manpower = [];



function survey_setup(userId) {
    loadSurveys("", userId, '');

}
function survey_setup_completed(userId) {
    loadSurveys("", userId, 'Completed');
}

function loadSurveys(keyword, userId, type) {
    $.get("LoadSurveys.jsp", {keyword: keyword, userId: userId, type: type}, function (data) {
        if (type !== 'Completed') {
            document.getElementById('nc_surveys_table').innerHTML = data;
        } else {
            document.getElementById('c_surveys_table').innerHTML = data;
        }
    });
}

function initSurvey() {
    var salesDiv = document.getElementsByName("salesDiv");
    for (i = 0; i < salesDiv.length; i++) {
        var divId = (salesDiv[i].value.split("|"))[0];
        formula.push({id: divId, value: {}});
        boxes.push({id: divId, value: 0});
        totalUnits.push({id: divId, value: 0});
        additionalCharges.push({id: divId, value: 0});
        manpower.push({id: divId, value: {}});
        materialCharges.push({id: divId, value: 0});
    }

    $('.tabcontent').each(function () {
        var divId = this.id;

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

        var customerTable = document.getElementById(divId + "_CustomerItemTable");
        var vimboxTable = document.getElementById(divId + "_VimboxItemTable");

        var customerTableAreas = customerTable.getElementsByTagName("table");
        var vimboxTableAreas = vimboxTable.getElementsByTagName("table");

        if (customerTableAreas != null) {
            for (i = 0; i < customerTableAreas.length; i++) {
                var tableArea = customerTableAreas[i];
                var id = tableArea.id;
                var idArr = id.split("_");
                // divId 0 aT 1 areaCounter 2 //
                initSurveyTable("", idArr[1], idArr[2], divId);
                var areaTotal = 0;
                $("#" + id + " > tbody  > tr").each(function () {
                    var inputs = this.getElementsByTagName("input");
                    if (inputs.length > 0) {
                        var name = inputs[0].value;
                        if (name === "Boxes") {
                            box.value += Number(inputs[4].value);
                        }
                        var charges = inputs[2].value;
                        if (!isNaN(charges)) {
                            addCharge.value += Number(charges);
                        }
                        totalUnit.value += Number(inputs[4].value);
                        areaTotal += Number(inputs[4].value);
                    }
                });
                areaUnits.push({id: idArr[1] + "_" + idArr[2] + "_SelectedItemsTable", value: areaTotal});
                selectedItemType.push({id: idArr[1] + "_" + idArr[2], value: "ItemsDiv"});
            }

            for (i = 0; i < vimboxTableAreas.length; i++) {
                var tableArea = vimboxTableAreas[i];
                var id = tableArea.id;
                var idArr = id.split("_");
                var tempVar1 = idArr[1];
                var tempVar2 = idArr[2];
                // divId 0 aT 1 areaCounter 2 //
                var areaTotal = areaUnits.find(function (obj) {
                    return obj.id === tempVar1 + "_" + tempVar2 + "_SelectedItemsTable";
                });

                $("#" + id + " > tbody  > tr").each(function () {
                    var inputs = this.getElementsByTagName("input");
                    if (inputs.length > 0) {
                        var name = inputs[0].value;
                        if (name === "Boxes") {
                            box.value += Number(inputs[4].value);
                            totalUnit.value += Number(inputs[4].value);
                            areaTotal.value += Number(inputs[4].value);
                        }
                        var charges = inputs[2].value;
                        if (!isNaN(charges)) {
                            matCharge.value += Number(charges);
                        }
                    }
                });
                document.getElementById(tempVar1 + "_" + tempVar2 + "_total").innerHTML = areaTotal.value;
            }
        }

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
        //document.getElementById(divId + "_totalUnits").innerHTML = "Total Units : " + totalUnit.value;
        update_services(divId);
    });
}

function startSurvey(leadId, date, timeslot, type) {
    if (type === 'Start') {
        $.get("StartSiteSurveyController", {leadId: leadId, date: date, timeslot: timeslot}, function (data) {
            window.location.href = "StartSurvey.jsp?leadId=" + leadId + "&date=" + date + "&timeslot=" + timeslot;
        });
    } else {
        window.location.href = "StartSurvey.jsp?leadId=" + leadId + "&date=" + date + "&timeslot=" + timeslot + "&type=continue";
    }
}

function expandAddressTab(e) {
    $(e).nextUntil('tr.survey_address_tab').slideToggle();
}

function addArea(address, fullAddr) {
    var divId = (fullAddr.split("|"))[0];
    var areaCounter = 1;
    while (document.getElementById(address + "_area_" + areaCounter) != null) {
        areaCounter++;
    }

    areaUnits.push({id: address + "_" + areaCounter + "_SelectedItemsTable", value: 0});
    selectedItemType.push({id: address + "_" + areaCounter, value: "ItemsDiv"});
    var allDivs = document.getElementsByClassName("survey_area_div");
    for (var i = 0; i < allDivs.length; i++) {
        allDivs.item(i).style.display = "none";
    }

    var allAreas = document.getElementsByClassName("survey_area_tab");
    for (var i = 0; i < allAreas.length; i++) {
        $(allAreas.item(i)).removeClass('selected');
    }

    var tr = "<tr id='" + address + "_area_" + areaCounter + "' onclick=\"displaySiteDiv(this, '" + address + "_div_" + areaCounter + "')\" class='survey_area_tab selected'><td><center><input type='hidden' name='survey_area' value='" + fullAddr + "|" + address + "_" + areaCounter + "'><label id='" + address + "_lbl_" + areaCounter + "'>Area</label></center></td></tr>";
    $("#" + address).append(tr);

    var div = document.createElement('div');
    div.id = address + "_div_" + areaCounter;
    div.className = "survey_area_div";
    $.get("LoadSurvey.jsp", {address: address, areaCounter: areaCounter, fullAddr: fullAddr}, function (data) {
        div.innerHTML = data;
        initSurveyTable("", address, areaCounter, divId);
        addAreaTable(divId, address, areaCounter);
    });

    document.getElementById("content").appendChild(div);
    document.getElementById("siteInfo").style.display = "none";
    $('#siteInfo_tab').removeClass('selected');
    div.style.display = "block";
}

function addAreaTable(divId, address, areaCounter) {
    var col = "<col width='20%'><col width='45%'><col width='10%'><col width='10%'><col width='10%'><col width='5%'>"
    var newCustTable = "<tr><td><table class='table table-bordered'  id='" + divId + "_" + address + "_" + areaCounter + "_CustomerItemTable' width='100%'>" + col + "<tr><th colspan='6'><label id='" + divId + "_" + address + "_CustomerItemTableLbl'>Area</label></tr></table></td></tr>";
    var newVimboxTable = "<tr><td><table class='table table-bordered' id='" + divId + "_" + address + "_" + areaCounter + "_VimboxItemTable' width='100%'>" + col + "<tr><th colspan='6'><label id='" + divId + "_" + address + "_VimboxItemTableLbl'>Area</label></tr></table></td></tr>";

    $("#" + divId + "_CustomerItemTable").append(newCustTable);
    $("#" + divId + "_VimboxItemTable").append(newVimboxTable);
}

function displaySiteInfo() {
    var siteInfo = document.getElementById("siteInfo");
    siteInfo.style.display = "block";
    $('#siteInfo_tab').addClass('selected');

    var allDivs = document.getElementsByClassName("survey_area_div");
    for (var i = 0; i < allDivs.length; i++) {
        allDivs.item(i).style.display = "none";
    }
    var allAreas = document.getElementsByClassName("survey_area_tab");
    for (var i = 0; i < allAreas.length; i++) {
        $(allAreas.item(i)).removeClass('selected');
    }
}

function displaySiteDiv(e, siteId) {
    var siteInfo = document.getElementById("siteInfo");
    siteInfo.style.display = "none";
    $('#siteInfo_tab').removeClass('selected');

    document.getElementById("siteInfo").style.display = "none";
    var allDivs = document.getElementsByClassName("survey_area_div");
    for (var i = 0; i < allDivs.length; i++) {
        allDivs.item(i).style.display = "none";
    }

    var allAreas = document.getElementsByClassName("survey_area_tab");
    for (var i = 0; i < allAreas.length; i++) {
        $(allAreas.item(i)).removeClass('selected');
    }

    var div = document.getElementById(siteId);

    div.style.display = "block";
    $(e).addClass('selected');
}

function confirmRemoveArea(salesDiv, address, areaCounter) {
    var modal = document.getElementById("survey_error_modal");
    var status = document.getElementById("survey_error_status");
    var message = document.getElementById("survey_error_message");

    status.innerHTML = "<center><b>Delete Confirmation</b></center>";
    var table = "<table width='100%'>";
    table += "<tr><td colspan='2'>Are you sure that you want to remove this area survey?</td></tr>";
    table += "<tr><td align='center'><button class='btn btn-default' onclick=\"removeArea('" + address + "_area_" + areaCounter + "', '" + address + "_div_" + areaCounter + "', '" + salesDiv + "_" + address + "_" + areaCounter + "'); return false;\">Yes</button></td><td align='center'><button class='btn btn-default' onclick=\"closeModal('survey_error_modal'); return false;\">No</button></td></tr>";
    table += "</table>";
    message.innerHTML = table;
    modal.style.display = "block";
}

function removeArea(tabId, divId, tableId) {
    var tab = document.getElementById(tabId);
    tab.parentNode.removeChild(tab);

    var div = document.getElementById(divId);
    div.parentNode.removeChild(div);

    document.getElementById("siteInfo").style.display = "block";
    $('#siteInfo_tab').addClass('selected');
    document.getElementById("survey_error_modal").style.display = "none";

    var custTable = document.getElementById(tableId + "_CustomerItemTable");
    var vimboxTable = document.getElementById(tableId + "_VimboxItemTable");
    custTable.parentNode.removeChild(custTable);
    vimboxTable.parentNode.removeChild(vimboxTable);
}

$(document).on('change keyup paste', '#siteArea_name', function () {
    var parent = this.parentNode.parentNode.parentNode;
    var lbl = parent.getElementsByClassName("lblId")[0];
    var value = lbl.value;
    // Getting the lbl //
    var lblId = value.split("|")[0];
    document.getElementById(lblId).innerHTML = this.value;
    // Getting the salesDiv and address //
    var address = lblId.split("_")[0];
    var divId = value.split("|")[1];
    document.getElementById(divId + "_" + address + "_CustomerItemTableLbl").innerHTML = this.value;
    document.getElementById(divId + "_" + address + "_VimboxItemTableLbl").innerHTML = this.value;
});

function showTableDiv(e, address, areaCounter, divName) {
    var tr = $(e.parentNode);
    var tds = tr.children('td');
    for (i = 0; i < tds.length; i++) {
        $(tds[i]).removeClass('selected');
    }
    $(e).addClass('selected');
    var itemTypeObject = selectedItemType.find(function (obj) {
        return obj.id === address + "_" + areaCounter;
    });
    itemTypeObject.value = divName;
    var div = document.getElementById(address + "_" + areaCounter + "_" + itemTypeObject.value);
    var td = $(div.parentNode);
    var divs = td.children('div');
    for (i = 0; i < divs.length; i++) {
        (divs[i]).style.display = "none";
    }
    div.style.display = "block";
}

function loadSurveyItemsTable(keyword, address, areaCounter, salesDiv) {
    var itemTypeObject = selectedItemType.find(function (obj) {
        return obj.id === address + "_" + areaCounter;
    });
    var div = document.getElementById(address + "_" + areaCounter + "_" + itemTypeObject.value);

    if (itemTypeObject.value === 'ItemsDiv') {
        $.get("LoadSurveyItemsTable.jsp", {keyword: keyword, address: address, areaCounter: areaCounter, salesDiv: salesDiv}, function (data) {
            div.innerHTML = data;
        });
    } else {
        $.get("LoadSurveyVimboxTable.jsp", {keyword: keyword, address: address, areaCounter: areaCounter, salesDiv: salesDiv}, function (data) {
            div.innerHTML = data;
        });
    }
}

function initSurveyTable(keyword, address, areaCounter, salesDiv) {
    $.get("LoadSurveyItemsTable.jsp", {keyword: keyword, address: address, areaCounter: areaCounter, salesDiv: salesDiv}, function (data) {
        var div = document.getElementById(address + "_" + areaCounter + "_ItemsDiv");
        div.innerHTML = data;
    });
    $.get("LoadSurveyVimboxTable.jsp", {keyword: keyword, address: address, areaCounter: areaCounter, salesDiv: salesDiv}, function (data) {
        var div = document.getElementById(address + "_" + areaCounter + "_VimboxDiv");
        div.innerHTML = data;
    });
}

function enterItem(value, address, areaCounter, tableName, salesDiv) {
    var modal = document.getElementById("item_details_modal");
    var valueArr = value.split("|");
    document.getElementById("itemName").innerHTML = valueArr[0];
    document.getElementById("itemDimensions").innerHTML = valueArr[1];
    document.getElementById("itemUnits").innerHTML = valueArr[2];
    $('#itemTableId').val(address + "_" + areaCounter + "_" + tableName);
    $('#itemSalesDiv').val(salesDiv);
    if (valueArr[3] == null) {
        var trs = $('#item_details_table tr');
        var tds = $(trs[2]).children('td');
        $(tds[2]).addClass('disabled');
    } else if (valueArr[3] === 'Material') {
        var trs = $('#item_details_table tr');
        var tds = $(trs[2]).children('td');
        $(tds[0]).addClass('disabled');
    }
    modal.style.display = "block";
}

function addNew(address, areaCounter, type) {
    var itemTypeObject = selectedItemType.find(function (obj) {
        return obj.id === address + "_" + areaCounter;
    });
    var selectedItemT = itemTypeObject.value;

    if (type !== 'Special' || selectedItemT !== 'VimboxDiv') {
        var modal = document.getElementById("item_details_modal");

        if (selectedItemT === 'VimboxDiv') {
            $('#itemTableId').val(address + "_" + areaCounter + "_SelectedVimboxTable");
        } else {
            $('#itemTableId').val(address + "_" + areaCounter + "_SelectedItemsTable");
        }
        if (!type) {
            var trs = $('#item_details_table tr');
            var tds = $(trs[2]).children('td');
            if (selectedItemT === 'VimboxDiv') {
                type = "Material";
                $(tds[0]).addClass('disabled');
            } else {
                $(tds[2]).addClass('disabled');
            }
        }

        document.getElementById("itemName").innerHTML = "<input class='form-control' type='text' id='itemNameText'><input type='hidden' id='itemType' value='" + type + "'>";
        modal.style.display = "block";
    }
}

function addItem(tableId, salesDiv) {
    var name = document.getElementById("itemName").innerHTML;
    var modal = document.getElementById("survey_error_modal");
    var tableName = tableId.split("_");
    var selectedObject = selectedItemType.find(function (obj) {
        return obj.id === tableName[0] + "_" + tableName[1];
    });
    var error = false;

    if (name === 'Boxes') {
        if (!(document.getElementById("itemUnits").innerHTML) || !(document.getElementById("itemQty").innerHTML)) {
            document.getElementById("survey_error_message").innerHTML = "Units or quantity of item cannot be empty";
            error = true;
        }
    } else {
        if (selectedObject.value === 'VimboxDiv') {
            if (!(document.getElementById("itemAddChrges").innerHTML) || !(document.getElementById("itemQty").innerHTML)) {
                document.getElementById("survey_error_message").innerHTML = "Quantity or charges of item cannot be empty";
                error = true;
            }
        } else {
            if (!(document.getElementById("itemUnits").innerHTML) || !(document.getElementById("itemQty").innerHTML)) {
                document.getElementById("survey_error_message").innerHTML = "Units or quantity of item cannot be empty";
                error = true;
            }
        }
    }

    if (error === false) {
        var unitObject = areaUnits.find(function (obj) {
            return obj.id === tableName[0] + "_" + tableName[1] + "_SelectedItemsTable";
        });

        var totalUnit = totalUnits.find(function (obj) {
            return obj.id === salesDiv;
        });
        var box = boxes.find(function (obj) {
            return obj.id === salesDiv;
        });
        var addCharge = additionalCharges.find(function (obj) {
            return obj.id === salesDiv;
        });
        var matCharge = materialCharges.find(function (obj) {
            return obj.id === salesDiv;
        });

        name = $('#itemNameText').val();
        if (name == null) {
            name = document.getElementById("itemName").innerHTML;
        } else {
            var type = $('#itemType').val();
            if (type === 'Special' || type === 'Material') {
                name = type + " - " + name;
            }
        }
        var remarks = $('#itemRemarks').val();
        var remarksValue = $('#itemRemarks').val();
        if (!remarks) {
            remarks = "&nbsp;";
        }
        var addCharges = document.getElementById("itemAddChrges").innerHTML;
        var addChargesValue = document.getElementById("itemAddChrges").innerHTML;
        if (!addCharges) {
            addCharges = "&nbsp;";
        } else {
            if (selectedObject.value === 'VimboxDiv') {
                matCharge.value += Number(addCharges);
                $("#" + salesDiv + "_materialCharge").val(matCharge.value);
            } else {
                addCharge.value += Number(addCharges);
            }
        }
        var units = (Number(document.getElementById("itemUnits").innerHTML) * Number(document.getElementById("itemQty").innerHTML));
        if (units === 0) {
            units = "";
        } else {
            totalUnit.value += units;
            if (name === 'Boxes') {
                box.value += units;
            }
        }

        var trCounter = 1;
        while (document.getElementById(tableId + "_tr" + trCounter) != null) {
            trCounter++;
        }

        var tr = "<tr id='" + tableId + "_tr" + trCounter + "'>";
        tr += "<td><input type='hidden' value='" + name + "'>" + name + "</td>";
        tr += "<td><input type='hidden' value='" + remarksValue + "'>" + remarks + "</td>";
        tr += "<td align='center'><input type='hidden' value='" + addChargesValue + "'>" + addCharges + "</td>";
        tr += "<td align='center'><input type='hidden' value='" + document.getElementById("itemQty").innerHTML + "'>" + document.getElementById("itemQty").innerHTML + "</td>";
        tr += "<td align='center'><input type='hidden' value='" + units + "'>" + units + "</td>";
        tr += "<td align='center'><input class='btn btn-default' type='button' value='x' onclick=\"deleteSiteItem(this, '" + tableId + "', '" + salesDiv + "')\"/></td>";
        tr += "</tr>"
        $(tr).prependTo("#" + tableId + " > tbody");

        if (selectedObject.value === 'VimboxDiv') {
            tr = "<tr id='" + tableId + "_tr" + trCounter + "'>";
            tr += "<td><input type='hidden' value='" + name + "' name='" + salesDiv + "_" + tableName[0] + "_" + tableName[1] + "_VimboxName'>" + name + "</td>";
            tr += "<td><input type='hidden' value='" + remarksValue + "' name='" + salesDiv + "_" + tableName[0] + "_" + tableName[1] + "_VimboxRemarks'>" + remarks + "</td>";
            tr += "<td align='center'><input type='hidden' value='" + addChargesValue + "' name='" + salesDiv + "_" + tableName[0] + "_" + tableName[1] + "_VimboxAddCharges'>" + addCharges + "</td>";
            tr += "<td align='center'><input type='hidden' value='" + document.getElementById("itemQty").innerHTML + "' name='" + salesDiv + "_" + tableName[0] + "_" + tableName[1] + "_VimboxQuantity'>" + document.getElementById("itemQty").innerHTML + "</td>";
            tr += "<td align='center'><input type='hidden' value='" + units + "' name='" + salesDiv + "_" + tableName[0] + "_" + tableName[1] + "_VimboxUnits'>" + units + "</td>";
            tr += "<td align='center'><input class='btn btn-default' type='button' value='x' onclick=\"deleteSiteItem(this, '" + tableId + "', '" + salesDiv + "')\"/></td>";
            tr += "</tr>"
            $("#" + salesDiv + "_" + tableName[0] + "_" + tableName[1] + "_VimboxItemTable").append(tr);
        } else {
            tr = "<tr id='" + tableId + "_tr" + trCounter + "'>";
            tr += "<td><input type='hidden' value='" + name + "' name='" + salesDiv + "_" + tableName[0] + "_" + tableName[1] + "_CustomerName'>" + name + "</td>";
            tr += "<td><input type='hidden' value='" + remarksValue + "' name='" + salesDiv + "_" + tableName[0] + "_" + tableName[1] + "_CustomerRemarks'>" + remarks + "</td>";
            tr += "<td align='center'><input type='hidden' value='" + addChargesValue + "' name='" + salesDiv + "_" + tableName[0] + "_" + tableName[1] + "_CustomerAddCharges'>" + addCharges + "</td>";
            tr += "<td align='center'><input type='hidden' value='" + document.getElementById("itemQty").innerHTML + "' name='" + salesDiv + "_" + tableName[0] + "_" + tableName[1] + "_CustomerQuantity'>" + document.getElementById("itemQty").innerHTML + "</td>";
            tr += "<td align='center'><input type='hidden' value='" + units + "' name='" + salesDiv + "_" + tableName[0] + "_" + tableName[1] + "_CustomerUnits'>" + units + "</td>";
            tr += "<td align='center'><input class='btn btn-default' type='button' value='x' onclick=\"deleteSiteItem(this, '" + tableId + "', '" + salesDiv + "')\"/></td>";
            tr += "</tr>"
            $("#" + salesDiv + "_" + tableName[0] + "_" + tableName[1] + "_CustomerItemTable").append(tr);
        }

        unitObject.value += (Number(document.getElementById("itemUnits").innerHTML) * Number(document.getElementById("itemQty").innerHTML))
        var arr = tableId.split("_");
        document.getElementById(arr[0] + "_" + arr[1] + "_total").innerHTML = unitObject.value;
        update_services(salesDiv);
        closeItemModal("item_details_modal");
    } else {
        document.getElementById("survey_error_status").innerHTML = "ERROR";
        $('#survey_error_modal').appendTo("body");
        modal.style.display = "block";
    }
}

function deleteSiteItem(btn, tableId, salesDiv) {
    var totalUnit = totalUnits.find(function (obj) {
        return obj.id === salesDiv;
    });
    var box = boxes.find(function (obj) {
        return obj.id === salesDiv;
    });
    var addCharge = additionalCharges.find(function (obj) {
        return obj.id === salesDiv;
    });
    var matCharge = materialCharges.find(function (obj) {
        return obj.id === salesDiv;
    });

    var arr = tableId.split("_");
    var row = btn.parentNode.parentNode;
    var id = row.id;
    var tds = $(row).children('td');
    var itemName = ($(tds[0]).find("input")[0]).value;
    var itemChrge = ($(tds[2]).find("input")[0]).value;
    var itemUnits = ($(tds[4]).find("input")[0]).value;
    totalUnit.value -= Number(itemUnits);
    if (itemName === 'Boxes') {
        box.value -= Number(itemUnits);
    }
    if (itemChrge) {
        if (arr[2] === 'SelectedItemsTable') {
            addCharge.value -= Number(itemChrge);
        } else {
            matCharge.value -= Number(itemChrge);
            $("#" + salesDiv + "_materialCharge").val(matCharge.value);
        }
    }


    var tableTrs = $("#" + tableId + " > tbody").children('tr');

    for (i = 0; i < tableTrs.length; i++) {
        if (tableTrs[i].id === id) {
            tableTrs[i].parentNode.removeChild(tableTrs[i]);
        }
    }

    if (arr[2] === 'SelectedItemsTable') {
        tableTrs = $("#" + salesDiv + "_" + arr[0] + "_" + arr[1] + "_CustomerItemTable > tbody").children('tr');
    } else {
        tableTrs = $("#" + salesDiv + "_" + arr[0] + "_" + arr[1] + "_VimboxItemTable > tbody").children('tr');
    }
    for (i = 0; i < tableTrs.length; i++) {
        if (tableTrs[i].id === id) {
            tableTrs[i].parentNode.removeChild(tableTrs[i]);
        }
    }

    var unitObject = areaUnits.find(function (obj) {
        return obj.id === arr[0] + "_" + arr[1] + "_SelectedItemsTable";
    });
    unitObject.value -= itemUnits;

    document.getElementById(arr[0] + "_" + arr[1] + "_total").innerHTML = unitObject.value;
    update_services(salesDiv);
}

function selectItemDetail(e, itemDetail) {
    if (e.className !== "disabled") {
        var tr = $(e.parentNode);
        var tds = tr.children('td');
        for (i = 0; i < tds.length; i++) {
            $(tds[i]).removeClass('selected');
        }
        selectedItemDetail = itemDetail;
        $(e).addClass('selected');
    }
}

function addNum(num) {
    var label = document.getElementById(selectedItemDetail);
    if (label != null) {
        if (isNaN(num)) {
            label.innerHTML = label.innerHTML.substring(0, label.innerHTML.length - 1);
        } else {
            label.innerHTML += num;
        }
    }
}

function closeItemModal(modalName) {
    var trs = $('#item_details_table tr');
    var tds = $(trs[2]).children('td');
    for (i = 0; i < tds.length; i++) {
        $(tds[i]).removeClass('selected');
        $(tds[i]).removeClass('disabled');
    }
    selectedItemDetail = "";
    $('#itemRemarks').val('');
    document.getElementById("itemQty").innerHTML = "";
    document.getElementById("itemAddChrges").innerHTML = "";
    document.getElementById("itemUnits").innerHTML = "";
    document.getElementById("itemDimensions").innerHTML = "";

    var modal = document.getElementById(modalName);
    modal.style.display = "none";
}

function selectService(divId) {
    var modal = document.getElementById(divId + "_serviceModal");
     $(divId + "_serviceModal").appendTo("body");
    modal.style.display = "block";
}

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
                    $(divId + "_manpowerModal").appendTo("body");
                    modal.style.display = "block";
                }
                (frml.value)[divId + "_" + id] = serviceArray[1];
                var tr = "<tr id='" + divId + "_" + id + "'><td>";
                tr += "<table class='table table-bordered serviceTable' width='100%'>"
                tr += "<tr height='10%'><td>" + pri + " - " + sec + "<input type='hidden' name='" + divId + "_serviceName' value='" + id + "'></td><td align='right'>$ <input type='number' step='0.01' min='0' name='" + divId + "_serviceCharge'></td></tr>";
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
        var modal = document.getElementById("survey_error_modal");
        var status = document.getElementById("survey_error_status");
        var message = document.getElementById("survey_error_message");
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

function update_services(divId) {
    $("#" + divId + "_servicesTable > tbody  > tr").each(function () {
        update_service(this, divId);
    });
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
}

function confirmComplete() {
    var modal = document.getElementById("survey_error_modal");
    var status = document.getElementById("survey_error_status");
    var message = document.getElementById("survey_error_message");

    status.innerHTML = "<center><b>Complete Confirmation</b></center>";
    var table = "<table width='100%'>";
    table += "<tr><td colspan='2'>Are you sure that you want to complete this site survey?</td></tr>";
    table += "<tr><td align='center'><button class='btn btn-default' onclick='complete()'>YES</button></td><td align='center'><button class='btn btn-default' onclick=\"closeModal('survey_error_modal'); return false;\">No</button></td></tr>";
    table += "</table>";
    message.innerHTML = table;
    modal.style.display = "block";
}

function complete() {
    $('#complete_status').val("yes");
    $.ajax({
        datatype: 'json',
        type: 'GET',
        url: "SaveSiteSurveyController",
        data: $('#siteSurvey_form').serialize(),
        success: function (response) {
            var modal = document.getElementById("survey_error_modal");
            var status = document.getElementById("survey_error_status");
            var message = document.getElementById("survey_error_message");
            status.innerHTML = response.status;
            message.innerHTML = response.message;
            modal.style.display = "block";

            if (response.completed === "YES") {
                setTimeout(function () {
                    window.location.href = "MySites.jsp";
                }, 500);
            }
        },
        error: function (response) {
            var modal = document.getElementById("survey_error_modal");
            var status = document.getElementById("survey_error_status");
            var message = document.getElementById("survey_error_message");
            status.innerHTML = "ERROR";
            message.innerHTML = response;
            modal.style.display = "block";
        }
    });
}

function sales_survey_setup() {
    loadSalesSurveys('','Pending');
    loadSalesSurveys('','Ongoing');
    loadSalesSurveys('','Completed');
    loadSalesSurveys('','Cancelled');
}

function loadSalesSurveys(keyword, type) {
    $.get("LoadSalesSurveys.jsp", {keyword: keyword, type: type}, function (data) {
        document.getElementById(type).innerHTML = data;
    });
}

function confirmCancel(leadId, date, timeslot) {
    var modal = document.getElementById("survey_error_modal");
    var status = document.getElementById("survey_error_status");
    var message = document.getElementById("survey_error_message");

    status.innerHTML = "Cancel Confirmation";
    var table = "<table width='100%'>";
    table += "<tr><td colspan='2'>Are you sure that you want to cancel this site survey?</td></tr>";
    table += "<tr><td align='center'><button onclick=\"cancel('" + leadId + "','" + date + "','" + timeslot + "')\">YES</button></td><td align='center'><button onclick=\"closeModal('survey_error_modal'); return false;\">No</button></td></tr>";
    table += "</table>";
    message.innerHTML = table;
    modal.style.display = "block";
}

function cancel(leadId, date, timeslot) {
    var modal = document.getElementById("survey_error_modal");
    var status = document.getElementById("survey_error_status");
    var message = document.getElementById("survey_error_message");
    $.get("CancelSiteSurveyController", {leadId: leadId, date: date, timeslot: timeslot}, function (data) {
        status.innerHTML = data.status;
        message.innerHTML = data.message;
        loadSalesSurveys('');
        setTimeout(function () {
            modal.style.display = "none";
        }, 500);
    });
}
function showSch(tdydate) {
    $(document).ready(function () {
        var schtable = document.getElementById("shwschedules");
        $.ajax({
            url: 'LoadMySurveySchedule.jsp',
            type: 'POST',
            data: {date: tdydate},
            success: function (response) {
                $(schtable).html(response);
            }
        });
    });

}
function viewSch(seldate) {
    var date = seldate.value;
    $(document).ready(function () {
        var schtable = document.getElementById("shwschedules");
        $.ajax({
            url: 'LoadMySurveySchedule.jsp',
            type: 'POST',
            data: {date: date},
            success: function (response) {
                $(schtable).html(response);
            }
        });
    });
}
function showWeeklySch(selopt) {
    var opt = selopt.value;
    if (opt == 'week') {
        var chdate = document.getElementById("seldate");
        chdate.style.visibility = 'hidden';
        var chdatelbl = document.getElementById("seldatelbl");
        chdatelbl.style.visibility = 'hidden';
        $(document).ready(function () {
            var schtable = document.getElementById("shwschedules");
            $.ajax({
                url: 'LoadMySurveyWeeklySchedule.jsp',
                type: 'POST',
                success: function (response) {
                    $(schtable).html(response);
                }
            });
        });
    } else if (opt == 'month') {
        var modal = document.getElementById("cal_modal");
        $("#cal_content").load("MyScheduleCalendar.jsp");
        var d = new Date();
        var m = d.getMonth();
        var y = d.getFullYear();
        var m_names = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
        var n = m_names[d.getMonth()];
        $("#dMonth").html(n);
        $("#dYear").html(y);
        var content = document.getElementById("ssCalTable");
        $.get("LoadMySurveyMonthlySchedule.jsp", {getYear: y, getMonth: m}, function (data) {
            content.innerHTML = data;
        });
        modal.style.display = "block";
    } else {
        var chdate = document.getElementById("seldate");
        var chdatelbl = document.getElementById("seldatelbl");
        chdate.style.visibility = 'visible';
        chdatelbl.style.visibility = 'visible';
        chdate.value
        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!
        var yyyy = today.getFullYear();
        if (mm < 10) {
            mm = "0" + mm;
        }
        chdate.value = yyyy + "-" + mm + "-" + dd;
        showSch(yyyy + "-" + mm + "-" + dd);
    }
}
function changeMonthAndYear() {
    var content = document.getElementById("ssCalTable");
    var iYear = document.getElementById('iYear').value;
    var iMonth = document.getElementById('iMonth').value;
    var m_names = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    var n = m_names[iMonth];
    $("#dMonth").html(n);
    $("#dYear").html(iYear);
    $.get("LoadMySurveyMonthlySchedule.jsp", {getYear: iYear, getMonth: iMonth}, function (data) {
        content.innerHTML = data;
    });
}
function viewSurvey(leadId, date, timeslot) {
    var modal = document.getElementById("view_survey_modal");
    var content = document.getElementById("view_survey_message");
    $.get("RetrieveSurveyDetails.jsp", {getLid: leadId, getStartTime: date, getTimeSlot: timeslot}, function (data) {
        content.innerHTML = data;
    });
    modal.style.display = "block";
}

function openSurvey(evt, cityName) {
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
function showSiteInfoTable(id, divId) {
    var field = document.getElementById(id);
    var parent = field.parentNode;
    var fieldSet = parent.getElementsByTagName("fieldset");
    if (fieldSet !== null) {
        for (var i = 0; i < fieldSet.length; i++) {
            if (id === fieldSet[i].id) {
                var tempfield = document.getElementById(fieldSet[i].id).firstElementChild.firstElementChild;
                if (tempfield != null) {
                    tempfield.style.visibility = 'visible';
                }
            } else {
                var tempfield = document.getElementById(fieldSet[i].id).firstElementChild.firstElementChild;
                if (tempfield != null) {
                    tempfield.style.visibility = 'hidden';
                }
            }
        }
    }
}
function showSiteInfoTables(id, divId, address, leadId, fromto) {
    var content = "";
    if(fromto == 'from'){
        content = document.getElementById("fromContent");
        content.style.display = 'block';
        var to = document.getElementById("toContent");
        to.style.display = 'none';
    }else if(fromto == 'to'){
        content = document.getElementById("toContent");
        content.style.display = 'block';
        var from = document.getElementById("fromContent");
        from.style.display = 'none';
    } 
    $.get("LoadSiteInfoTable.jsp", {getField: id, getDivId: divId, getAdd: address, leadId: leadId}, function (data) {
        content.innerHTML = data;
    });

}
function displaytodefault(){
     $("#toonload").trigger('click');
}
function displayfromdefault(){
     $("#fromonload").trigger('click');
}