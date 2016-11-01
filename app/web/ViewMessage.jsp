<div id="message-subject"></div> 
<hr>
<table width="100%" id="message-table">
    <tr>
        <td>
            <div id="message-from"></div>
        </td>
        <td align="right">
            <div id="message-date"></div>
        </td>
    </tr>
    <tr>
        <td>
            <div id="message-recipients"></div>
        </td>
        <td></td>
    </tr>
    <tr>
        <td>
            <div id="message-attachments"></div>
            <input type="hidden" id="message-files">
        </td>
        <td></td>
    </tr>
</table>
<br>
<div id="message-content"></div>
<div class="divider"></div>
<style>
    .email-box{
        height: 39px;
        font-size: 16px;
        display:inline-block;
        float:left;
        padding: 6px 10px;
        border: #dfe8f1 solid 1px;
        border-radius: 2px;
        box-shadow: inset 1px 1px 3px #f6f6f6;
    }

    .email-box a{
        cursor: pointer;
    }

    .email-text {
        height: 39px;
        width: 100%;
        padding: 4px 16px;
        font-size: 16px;
        line-height: 1.618;
        color: #555555;
        border: none;
        outline: none;
        box-shadow: none;
    }

    #action-btn {
        display:inline-block;
        color:#444;
        border:1px solid #CCC;
        background:#DDD;
        box-shadow: 0 0 5px -1px rgba(0,0,0,0.2);
        cursor:pointer;
        vertical-align:middle;
        width: 70px;
        height: 40px;
        padding: 5px;
        text-align: center;
    }
    #action-btn:active {
        color:red;
        box-shadow: 0 0 5px -1px rgba(0,0,0,0.6);
    }

</style>
<div>
    <input type="hidden" id="message-id">
    <input type="hidden" id="message-folder">
    <input type="hidden" id="send-action">
    <div class="dropdown">
        <span data-toggle="dropdown" id="action-btn">
            <div style="display:inline-block">
                <div id="action-img" style="float:left">
                    <!--<img src='Images/reply.png' height='30' width='30' style='padding: 0 0 3px 0;'>-->
                </div>
                <div style="float:right;padding-top:5px;">
                    <img src='Images/arrow.png' height='12' width='12' style='padding: 0 0 1px 0;'>
                </div>
            </div>
        </span>
        <div class="dropdown-menu box-md float-left" style="width:200px;">
            <ul class="no-border notifications-box">
                <li onclick="selectEmailAction('r')" style="cursor:pointer;">
                    <img src='Images/reply.png' height='30' width='30' style='padding: 0 0 3px 0;'>
                    Reply
                </li>
                <li onclick="selectEmailAction('ra')" style="cursor:pointer;">
                    <img src='Images/replyall.png' height='30' width='30' style='padding: 0 0 3px 0;'>
                    Reply All
                </li>
                <li onclick="selectEmailAction('f')" style="cursor:pointer;">
                    <img src='Images/forward.png' height='30' width='30' style='padding: 0 0 3px 0;'>
                    Forward
                </li>
            </ul>
        </div>
    </div>
</div>

<div id="forward-content" style="display:none">
    <form class="form-horizontal mrg15T" role="form">
        <div class="form-group row">
            <label class="col-sm-2 control-label">To:</label>
            <div class="col-sm-8" id="to_div" style="display:inline-block;border: 1px solid #cccccc;border-radius: 2px;box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);">
                <div style="float:right;width:100%;">
                    <input type="text" id="to" class="email-text" onkeyup="validateEmail(this, 'to')">
                </div>
            </div>
        </div>
        <div class="form-group row">
            <label class="col-sm-2 control-label">CC:</label>
            <div class="col-sm-8" id="to_div" style="display:inline-block;border: 1px solid #cccccc;border-radius: 2px;box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);">
                <div style="float:right;width:100%;">
                    <input type="text" id="cc" class="email-text" onkeyup="validateEmail(this, 'cc')">
                </div>
            </div>
        </div>
        <div class="form-group row">
            <label class="col-sm-2 control-label">BCC:</label>
            <div class="col-sm-8" id="to_div" style="display:inline-block;border: 1px solid #cccccc;border-radius: 2px;box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);">
                <div style="float:right;width:100%;">
                    <input type="text" id="bcc" class="email-text" onkeyup="validateEmail(this, 'bcc')">
                </div>
            </div>
        </div>
        <div class="form-group row">
            <label for="inputEmail4" class="col-sm-2 control-label">Subject:</label>
            <div class="col-sm-8" id="to_div" style="display:inline-block;border: 1px solid #cccccc;border-radius: 2px;box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);">
                <div style="float:right;width:100%;">
                    <input type="text" id="subject" class="email-text">
                </div>
            </div>
        </div>
        <div class="form-group row">
            <label for="inputEmail5" class="col-sm-2 control-label">Attachment(s):</label>
            <div class="col-sm-8" id="to_div" style="display:inline-block;border: 1px solid #cccccc;border-radius: 2px;box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);">
                <div style="float:right;width:100%;" id="files-div">
                    <input type="file" id="attachments" class="email-text" multiple>
                </div>
            </div>
        </div>
    </form>
</div>


