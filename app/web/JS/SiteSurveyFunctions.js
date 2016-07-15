function survey_setup(userId) {
    loadSurveys("", userId);
}

function loadSurveys(keyword, userId) {
    $.get("LoadSurveys.jsp", {keyword: keyword, userId: userId}, function (data) {
        document.getElementById('surveys_table').innerHTML = data;
    });
}

