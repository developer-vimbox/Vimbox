function admViewCal() {
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
    
    var content = document.getElementById("ssCalTable");
    $.get("SiteSurveyCalendarPopulate.jsp", {getYear: y, getMonth: m, getSS: "allss"}, function (data) {
        content.innerHTML = data;
    });
    modal.style.display = "block";
}

function admViewMovCal(){
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
    
    var content = document.getElementById("ssCalTable");
    $.get("MovingCalendarPopulate.jsp", {getYear: y, getMonth: m, getTT: "alltt"}, function (data) {
        content.innerHTML = data;
    });
    modal.style.display = "block";
}

function admLeads_setup(){
    admLeads_search('');
}

function admLeads_search(keyword){
    $.get("LoadAdminLeads.jsp", {keyword: keyword}, function (data) {
        document.getElementById("admLeadsTable").innerHTML = data;
    });
}



