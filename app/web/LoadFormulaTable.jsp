<%
    String formula = request.getParameter("formula");
    if (formula == null) {
        formula = "";
    }else{
        formula.replaceAll(" ", "");
    }
%>
<div class="form-horizontal">
    <input type="hidden" id="hidFormula" value="<%=formula%>">
    <div class="form-group">
        <label class="col-sm-4 control-label">Formula: </label>
        
        <div class="col-sm-4" style="padding-top: 7px;">
          <label class="col-sm-7" id="formulaLbl"><%=formula%></label>
            <button class="btn btn-danger" onclick="formulaRemove()" style="left: 40%;"><</button>
        </div>
    </div>
    <div class="example-box-wrapper">
        <ul class="nav-responsive nav nav-tabs">
            <li class="active"><a href="#number" data-toggle="tab">Number</a></li>
            <li><a href="#operator" data-toggle="tab">Operators</a></li>
            <li><a href="#variable" data-toggle="tab">Variables</a></li>
        </ul>
        <div class="tab-content">
            <div id="number" class="tab-pane active">
                <div class="input-group">
                    <input class='form-control' type="number" min="0" step="0.01" id="number_entry">
                                      
                                        <span class="input-group-btn">
                                          <button onclick="formulaNumber()" class="btn btn-primary">+</button>
                                        </span>
                                    </div>
                <!--<input class='form-control' type="number" min="0" step="0.01" id="number_entry">-->
                <!--<button onclick="formulaNumber()" class="btn btn-primary">+</button>-->
            </div>
            <div id="operator" class="tab-pane">
                <button class="btn btn-blue" onclick="formulaOperator('+')">+</button>
                <button class="btn btn-blue" onclick="formulaOperator('-')">-</button>
                <button class="btn btn-blue" onclick="formulaOperator('x')">x</button>
                <button class="btn btn-blue" onclick="formulaOperator('/')">/</button>
            </div>
            <div id="variable" class="tab-pane">
                <button class="btn btn-blue" onclick="formulaVariable('AC')">AC</button>
                <button class="btn btn-blue" onclick="formulaVariable('B')">B</button>
                <button class="btn btn-blue" onclick="formulaVariable('MP')">MP</button>
                <button class="btn btn-blue" onclick="formulaVariable('U')">U</button>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-4 control-label"> </label>
            <div class="col-sm-4 text-center">
                <button class="btn btn-primary" onclick="enterFormula()">Enter Formula</button>
            </div>
        </div>
    </div>
</div>