var formulaCount;

function admViewCal() {
    var modal = document.getElementById("cal_modal");
    $.get("SiteSurveyCalendar.jsp", {type: "Admin"}, function (data) {
        document.getElementById("cal_content").innerHTML = data;
    });
    var d = new Date();
    utc = d.getTime() + (d.getTimezoneOffset() * 60000),
            d = new Date(utc + (3600000 * 8));

    var m = d.getMonth();
    var y = d.getFullYear();
    var m_names = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    var n = m_names[d.getMonth()];
    $("#dMonth").html(n);
    $("#dYear").html(y);

    var content = document.getElementById("ssCalTable");
    $.get("SiteSurveyCalendarPopulate.jsp", {getYear: y, getMonth: m, getSS: "allss", type: "Admin"}, function (data) {
        content.innerHTML = data;
    });
    modal.style.display = "block";
}

function admViewMovCal() {
    var modal = document.getElementById("cal_modal");
    $.get("MovingCalendar.jsp", {type: 'Admin'}, function (data) {
        document.getElementById("cal_content").innerHTML = data;
    });
    var d = new Date();
    utc = d.getTime() + (d.getTimezoneOffset() * 60000),
            d = new Date(utc + (3600000 * 8));

    var m = d.getMonth();
    var y = d.getFullYear();
    var m_names = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    var n = m_names[d.getMonth()];
    $("#dMonth").html(n);
    $("#dYear").html(y);

    var content = document.getElementById("ssCalTable");
    $.get("MovingCalendarPopulate.jsp", {getYear: y, getMonth: m, getTT: "alltt", type: 'Admin'}, function (data) {
        content.innerHTML = data;
    });
    modal.style.display = "block";
}

function admLeads_setup() {
    admLeads_search('');
}

function admLeads_search(keyword) {
    $.get("LoadAdminLeads.jsp", {keyword: keyword}, function (data) {
        document.getElementById("admLeadsTable").innerHTML = data;
        $('.javascript').each(function () {
            eval($(this).text());
        });
    });
}

function viewMoveType() {
    $.get("LoadMoveType.jsp", function (data) {
        document.getElementById('moveType_table').innerHTML = data;
        $('.javascriptMove').each(function () {
            eval($(this).text());
        });
    });
}

function viewRefType() {
    $.get("LoadRefType.jsp", function (data) {
        document.getElementById('refType_table').innerHTML = data;
        $('.javascriptRef').each(function () {
            eval($(this).text());
        });
    });
}

function viewSvcType() {
    $.get("LoadSvcType.jsp", function (data) {
        document.getElementById('svcType_table').innerHTML = data;
        $('.javascriptSvc').each(function () {
            eval($(this).text());
        });
    });
}

function viewAdmItems() {
    $.get("LoadAdminCustomerItems.jsp", function (data) {
        document.getElementById('customer_table').innerHTML = data;
    });
    $.get("LoadAdminVimboxItems.jsp", function (data) {
        document.getElementById('vimbox_table').innerHTML = data;
    });
}

function addMoveType() {
    var modal = document.getElementById("errorModal");
    var msgStatus = document.getElementById("error-status");
    var msgContent = document.getElementById("error-content");
    var moveType = $('#moveType').val();
    var abb = $('#abb').val();

    $.getJSON("AddMoveTypeServlet", {moveType: moveType, abb: abb})
            .done(function (data) {
                var status = data.status;
                var errorMsg = data.errorMsg;
                msgStatus.innerHTML = status;
                msgContent.innerHTML = errorMsg;
                modal.style.display = "block";
                setTimeout(function () {
                    modal.style.display = "none";
                }, 800);
                viewMoveType();
                if (status === "SUCCESS") {
                    document.getElementById("moveType").value = "";
                    document.getElementById("abb").value = "";
                }
            })
            .fail(function (error) {
                msgStatus.innerHTML = "ERROR";
                msgContent.innerHTML = error;
                modal.style.display = "block";
                setTimeout(function () {
                    modal.style.display = "none";
                }, 800);
                document.getElementById("moveType").value = "";
                document.getElementById("abb").value = "";
            });
}

function addRefType() {
    var modal = document.getElementById("errorModal");
    var msgStatus = document.getElementById("error-status");
    var msgContent = document.getElementById("error-content");
    var refType = $('#refType').val();

    $.getJSON("AddRefTypeServlet", {refType: refType})
            .done(function (data) {
                var status = data.status;
                var errorMsg = data.errorMsg;
                msgStatus.innerHTML = status;
                msgContent.innerHTML = errorMsg;
                modal.style.display = "block";
                setTimeout(function () {
                    modal.style.display = "none";
                }, 800);
                viewRefType();
                if (status === "SUCCESS") {
                    document.getElementById("refType").value = "";
                }
            })
            .fail(function (error) {
                msgStatus.innerHTML = "ERROR";
                msgContent.innerHTML = error;
                modal.style.display = "block";
                setTimeout(function () {
                    modal.style.display = "none";
                }, 800);
                document.getElementById("refType").value = "";
            });
}

function addSvcType() {
    var modal = document.getElementById("errorModal");
    var msgStatus = document.getElementById("error-status");
    var msgContent = document.getElementById("error-content");
    var svcType_primary = $('#svcType_primary').val();
    var svcType_secondary = $('#svcType_secondary').val();
    var svcType_formula = document.getElementById('svcType_formula').innerHTML;
    var svcType_description = $('#svcType_description').val();

    $.getJSON("AddSvcTypeServlet", {svcType_primary: svcType_primary, svcType_secondary: svcType_secondary, svcType_formula: svcType_formula, svcType_description: svcType_description})
            .done(function (data) {
                var status = data.status;
                var errorMsg = data.errorMsg;
                msgStatus.innerHTML = status;
                msgContent.innerHTML = errorMsg;
                modal.style.display = "block";
                setTimeout(function () {
                    modal.style.display = "none";
                    document.getElementById("messageModal3").style.display = "none";
                }, 800);
                viewSvcType();
                if (status === "SUCCESS") {
                    document.getElementById("svcType_primary").value = "";
                    document.getElementById("svcType_secondary").value = "";
                    document.getElementById("svcType_formula").innerHTML = "";
                    document.getElementById("svcType_description").value = "";
                    document.getElementById("formula-btn").innerHTML = "Formula";
                }
            })
            .fail(function (error) {
                msgStatus.innerHTML = "ERROR";
                msgContent.innerHTML = error;
                modal.style.display = "block";
                setTimeout(function () {
                    modal.style.display = "none";
                }, 800);
                document.getElementById("svcType_primary").value = "";
                document.getElementById("svcType_secondary").value = "";
                document.getElementById("svcType_formula").innerHTML = "";
                document.getElementById("svcType_description").value = "";
                document.getElementById("formula-btn").innerHTML = "Formula";
            });
}

function deleteMoveType(del_moveType) {
    var modal = document.getElementById("delModal");
    var msgStatus = document.getElementById("del-status");
    var msgContent = document.getElementById("del-content");
    //var del_moveType = $('#del_moveType').val();


    $.getJSON("DelMoveTypeServlet", {moveType: del_moveType})
            .done(function (data) {
                var status = data.status;
                var errorMsg = data.errorMsg;
                msgStatus.innerHTML = status;
                msgContent.innerHTML = errorMsg;
                modal.style.display = "block";
                if (status === "SUCCESS") {
                    setTimeout(function () {
                        modal.style.display = "none";
                        document.getElementById("delModal").style.display = "none";
                    }, 500);
                }
                viewMoveType();
            })
}

function deleteRefType(del_refType) {
    var modal = document.getElementById("delModal");
    var msgStatus = document.getElementById("del-status");
    var msgContent = document.getElementById("del-content");
    //var del_moveType = $('#del_moveType').val();


    $.getJSON("DelRefTypeServlet", {refType: del_refType})
            .done(function (data) {
                var status = data.status;
                var errorMsg = data.errorMsg;
                msgStatus.innerHTML = status;
                msgContent.innerHTML = errorMsg;
                modal.style.display = "block";
                if (status === "SUCCESS") {
                    setTimeout(function () {
                        modal.style.display = "none";
                    }, 500);
                    viewRefType();
                }
            })
}

function deleteSvcType(del_svcType) {
    var modal = document.getElementById("delModal");
    var msgStatus = document.getElementById("del-status");
    var msgContent = document.getElementById("del-content");
    //var del_moveType = $('#del_moveType').val();


    $.getJSON("DelSvcTypeServlet", {svcType: del_svcType})
            .done(function (data) {
                var status = data.status;
                var errorMsg = data.errorMsg;
                msgStatus.innerHTML = status;
                msgContent.innerHTML = errorMsg;
                modal.style.display = "block";
                if (status === "SUCCESS") {
                    setTimeout(function () {
                        modal.style.display = "none";
                        document.getElementById("delModal3").style.display = "none";
                    }, 500);
                    viewSvcType();
                }
            })
}

function serviceFormula() {
    var svcType_formula = document.getElementById('svcType_formula').innerHTML;
    if (!svcType_formula) {
        formulaCount = "";
    } else {
        var last = svcType_formula.substring(svcType_formula.lastIndexOf(" ") + 1);
        if (isNaN(last)) {
            formulaCount = "V";
        } else {
            formulaCount = "N";
        }
    }
    $.get("LoadFormulaTable.jsp", {formula: svcType_formula}, function (data) {
        document.getElementById("formula-content").innerHTML = data;
        document.getElementById("formulaModal").style.display = "block";
    });
}

function formulaRemove() {
    var fmlLbl = document.getElementById("formulaLbl").innerHTML;
    fmlLbl = fmlLbl.substring(0, fmlLbl.lastIndexOf(" "));
    $('#hidFormula').val(fmlLbl);
    document.getElementById("formulaLbl").innerHTML = fmlLbl;
    var last = fmlLbl.substring(fmlLbl.lastIndexOf(" ") + 1);
    if (isNaN(last)) {
        if (last.match(/^(B|MP|AC|U)$/)) {
            formulaCount = "V";
        } else {
            formulaCount = "O";
        }
    } else {
        formulaCount = "N";
    }
}

function formulaNumber() {
    var number = $('#number_entry').val();
    var fmlLbl = document.getElementById("formulaLbl").innerHTML;
    if (!fmlLbl) {
        formulaCount = "N";
        document.getElementById("formulaLbl").innerHTML = number;
        $('#hidFormula').val(number);
    } else {
        if (formulaCount === "N" || formulaCount === "V") {
            var modal = document.getElementById("errorModal");
            var msgStatus = document.getElementById("error-status");
            var msgContent = document.getElementById("error-content");
            msgStatus.innerHTML = "ERROR";
            msgContent.innerHTML = "Please enter an operator after a number or variable";
            modal.style.display = "block";
        } else {
            document.getElementById("formulaLbl").innerHTML = fmlLbl + " " + number;
            $('#hidFormula').val(fmlLbl + " " + number);
            formulaCount = "N";
        }
    }
    $('#number_entry').val('');
}

function formulaOperator(operator) {
    var fmlLbl = document.getElementById("formulaLbl").innerHTML;
    var modal = document.getElementById("errorModal");
    var msgStatus = document.getElementById("error-status");
    var msgContent = document.getElementById("error-content");
    if (!fmlLbl) {
        msgStatus.innerHTML = "ERROR";
        msgContent.innerHTML = "Please enter a number or variable before an operator";
        modal.style.display = "block";
    } else {
        if (formulaCount === "O") {
            msgStatus.innerHTML = "ERROR";
            msgContent.innerHTML = "Please enter a number or variable after an operator";
            modal.style.display = "block";
        } else {
            document.getElementById("formulaLbl").innerHTML = fmlLbl + " " + operator;
            $('#hidFormula').val(fmlLbl + " " + operator);
            formulaCount = "O";
        }
    }
}

function formulaVariable(variable) {
    var fmlLbl = document.getElementById("formulaLbl").innerHTML;
    var modal = document.getElementById("errorModal");
    var msgStatus = document.getElementById("error-status");
    var msgContent = document.getElementById("error-content");
    if (!fmlLbl) {
        formulaCount = "V";
        document.getElementById("formulaLbl").innerHTML = variable;
        $('#hidFormula').val(variable);
    } else {
        if (formulaCount === "V" || formulaCount === "N") {
            msgStatus.innerHTML = "ERROR";
            msgContent.innerHTML = "Please enter an operator after a number or variable";
            modal.style.display = "block";
        } else {
            document.getElementById("formulaLbl").innerHTML = fmlLbl + " " + variable;
            $('#hidFormula').val(fmlLbl + " " + variable);
            formulaCount = "V";
        }
    }
}

function enterFormula() {
    if (formulaCount === "O") {
        var modal = document.getElementById("errorModal");
        var msgStatus = document.getElementById("error-status");
        var msgContent = document.getElementById("error-content");
        msgStatus.innerHTML = "ERROR";
        msgContent.innerHTML = "Formula cannot end with an operator";
        modal.style.display = "block";
    } else {
        var fml = $('#hidFormula').val();
        document.getElementById("svcType_formula").innerHTML = fml;
        if (!fml) {
            document.getElementById("formula-btn").innerHTML = "Formula";
        } else {
            document.getElementById("formula-btn").innerHTML = "Edit";
        }
        document.getElementById("formulaModal").style.display = "none";
    }
}

function loadValueSetupTables() {
    viewMoveType();
    viewRefType();
    viewSvcType();
    viewAdmItems();
}

function editItem(value, type) {
    var errmodal = document.getElementById("errorModal");
    var status = document.getElementById("error-status");
    var message = document.getElementById("error-content");

    $('#itemValues').val(value);
    var valueArr = value.split("|");
    $('#itemName').val(valueArr[0]);
    if(type === "item"){
        document.getElementById("itemDescription").disabled = false;
        document.getElementById("itemDimensions").disabled = false;
        document.getElementById("itemUnits").disabled = false;
        $('#itemDescription').val(valueArr[1]);
        $('#itemDimensions').val(valueArr[2]);
        $('#itemUnits').val(valueArr[3]);
    }else{
        document.getElementById("itemDescription").disabled = true;
        document.getElementById("itemDimensions").disabled = true;
        document.getElementById("itemUnits").disabled = true;
    }
    
    document.getElementById("imageLbl").innerHTML = valueArr[4];
    $('#edit_item_form').ajaxForm({
        dataType: 'json',
        success: function (data) {
            status.innerHTML = data.status;
            message.innerHTML = data.message;
            errmodal.style.display = "block";

            if (data.status === "SUCCESS") {
                setTimeout(function () {
                    document.getElementById("itemModal").style.display = "none";
                    errmodal.style.display = "none";
                }, 500);
                viewAdmItems();
            }
        },
        error: function (data) {
            status.innerHTML = "ERROR";
            message.innerHTML = data;
            errmodal.style.display = "block";
        }
    });
    document.getElementById("itemModal").style.display = "block";
}

function changeItemType(){
    var e = document.getElementById("entry_itemType");
    var selected = e.options[e.selectedIndex].value;
    if(selected === "material"){
        document.getElementById("entry_itemDescription").style.display = "none";
        document.getElementById("entry_itemDimensions").style.display = "none";
        document.getElementById("entry_itemUnits").style.display = "none";
    }else{
        document.getElementById("entry_itemDescription").style.display = "block";
        document.getElementById("entry_itemDimensions").style.display = "block";
        document.getElementById("entry_itemUnits").style.display = "block";
    }
}