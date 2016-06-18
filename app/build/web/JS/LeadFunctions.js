function addFollowup(leadId) {
    var modal = document.getElementById("commentModal" + leadId);
    modal.style.display = "block";
}

function followupLead(lead_id){
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

