function admViewCal() {
    var modal = document.getElementById("cal_modal");
    $.get("SiteSurveyCalendar.jsp",{type:"Admin"}, function (data) {
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
    $.get("SiteSurveyCalendarPopulate.jsp", {getYear: y, getMonth: m, getSS: "allss", type:"Admin"}, function (data) {
        content.innerHTML = data;
    });
    modal.style.display = "block";
}

function admViewMovCal() {
    var modal = document.getElementById("cal_modal");
    $.get("MovingCalendar.jsp", {}, function (data) {
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
    $.get("MovingCalendarPopulate.jsp", {getYear: y, getMonth: m, getTT: "alltt", type:'Admin'}, function (data) {
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
        $('.javascript').each(function() {
      eval($(this).text());
    });
    });
}

function viewMoveType() {
    $.get("LoadMoveType.jsp", function (data) {
        document.getElementById('moveType_table').innerHTML = data;
        $('.javascriptMove').each(function() {
      eval($(this).text());
    });
    });
}

function viewRefType() {
   $.get("LoadRefType.jsp", function (data) {
        document.getElementById('refType_table').innerHTML = data;
        $('.javascriptRef').each(function() {
      eval($(this).text());
    });
    });
}

function viewSvcType() {
    $.get("LoadSvcType.jsp", function (data) {
        document.getElementById('svcType_table').innerHTML = data;
        $('.javascriptSvc').each(function() {
      eval($(this).text());
    });
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
    var svcType_formula = $('#svcType_formula').val();
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
                if(status === "SUCCESS") {
                    document.getElementById("svcType_primary").value = "";
                    document.getElementById("svcType_secondary").value = "";
                    document.getElementById("svcType_formula").value = "";
                    document.getElementById("svcType_description").value = "";
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
                document.getElementById("svcType_formula").value = "";
                document.getElementById("svcType_description").value = "";
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

function loadValueSetupTables() {
     viewMoveType();
     viewRefType();
     viewSvcType();
}
