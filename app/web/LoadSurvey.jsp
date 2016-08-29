<%
    String address = request.getParameter("address");
    String areaCounter = request.getParameter("areaCounter");
    String salesDiv = request.getParameter("fullAddr");
%>
<table style='width:100%;height:100%;border-color: #dfe8f1;' border="1">
    <col width="33%">
    <col width="33%">
    <tr height="20">
        <td colspan="2">
            &nbsp;
            <input type="hidden" class="lblId" value="<%=address%>_lbl_<%=areaCounter%>|<%=salesDiv%>">
            <div class="form-group">
                <label class="col-sm-3 control-label">Area Name: </label>
                <div class="col-sm-5">
                    <input class='form-control' type="text" id="siteArea_name" name="<%=salesDiv%>+<%=address%>_<%=areaCounter%>+siteAreaName" value="Area">
                </div>
            </div>
        </td>
        <td>
            Total Units : <label id="<%=address%>_<%=areaCounter%>_total">0</label>
            <span class='close' onClick="confirmRemoveArea('<%=salesDiv%>', '<%=address%>', '<%=areaCounter%>');">×</span>
        </td>
    </tr>
    <tr height="100">
        <!-- Item Menu -->
        <td colspan="2">
            <table width="100%">
                <tr>
                    <td colspan="3">
                        <div class="form-group" style='margin-left:10%!important'>
                            <div class="col-sm-3">
                                <div style="width: 300%;" class="input-group bootstrap-touchspin"><span class="input-group-addon bootstrap-touchspin-prefix" style="display: none;"></span>
                                    <input type="text" id="<%=address%>_<%=areaCounter%>_search"  placeholder="Search Item Name" class="form-control" style="color:black;">
                                    <span class="input-group-btn">
                                   <button class="btn btn-default  bootstrap-touchspin-up" onclick="loadSurveyItemsTable($('#<%=address%>_<%=areaCounter%>_search').val(), '<%=address%>', '<%=areaCounter%>', '<%=salesDiv%>');
                                return false;">Search</button>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="height: 30px;" colspan="2" width="50%" align="center" class="selected" onclick="showTableDiv(this, '<%=address%>', '<%=areaCounter%>', 'ItemsDiv');
                            return false;"><b>CUSTOMER</b></td>
                    <td style="height: 30px;" align="center" onclick="showTableDiv(this, '<%=address%>', '<%=areaCounter%>', 'VimboxDiv');
                            return false;"><b>VIMBOX</b></td>
                </tr>
                <tr>
                    <td colspan="3" height="690">
                        <div style="overflow:auto;height:100%;" id="<%=address%>_<%=areaCounter%>_ItemsDiv">

                        </div>
                        <div style="overflow:auto;height:100%;display:none;" id="<%=address%>_<%=areaCounter%>_VimboxDiv">

                        </div>
                    </td>
                </tr>
            </table>
        </td>
        <!-- Item List -->
        <td>
            <div style="overflow:auto;height:100%;">
                <table class='table' width="100%">
                    <col width="20%">
                    <col width="45%">
                    <col width="10%">
                    <col width="10%">
                    <col width="10%">
                    <col width="5%">
                    <tr style="background-color:DarkOrange" height="10%">
                        <td align="center" colspan="6"><center><b><u style="color: white;">Customer Item List</u></b></center></td>
                    </tr>
                    <tr height="10%">
                        <td align="center"><b>Item</b></td>
                        <td align="center"><b>Remarks</b></td>
                        <td align="center"><b>Additional Charges</b></td>
                        <td align="center"><b>Qty</b></td>
                        <td align="center"><b>Units</b></td>
                        <td align="center"></td>
                    </tr>
                    <tr height="300">
                        <td colspan="6" valign="top">
                            <table width="100%" id="<%=address%>_<%=areaCounter%>_SelectedItemsTable">
                                <col width="20%">
                                <col width="45%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="5%">
                                <tbody></tbody>
                            </table>
                        </td>
                    </tr>
                    <tr style="background-color:CornflowerBlue" height="10%">
                        <td align="center" colspan="6"><center><b><u style="color: white;">Vimbox Item List</u></b></center></td>
                    </tr>
                    <tr height="10%">
                        <td align="center"><b>Item</b></td>
                        <td align="center"><b>Remarks</b></td>
                        <td align="center"><b>Additional Charges</b></td>
                        <td align="center"><b>Qty</b></td>
                        <td align="center"><b>Units</b></td>
                        <td align="center"></td>
                    </tr>
                    <tr height="300">
                        <td colspan="6" valign="top">
                            <table width="100%" id="<%=address%>_<%=areaCounter%>_SelectedVimboxTable">
                                <col width="20%">
                                <col width="45%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="5%">
                                <tbody></tbody>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </td>
    </tr>
    <tr height="20">
        <td align="center" onclick="addNew('<%=address%>', '<%=areaCounter%>', '');
                return false;">New</td>
        <td align="center" onclick="addNew('<%=address%>', '<%=areaCounter%>', 'Special');
                return false;">Special</td>
        <td>
            <input class='btn btn-primary' type="submit" style="width:100%;" value="SAVE">
        </td>
    </tr>
</table>
