var counter = 1;
var moveDiv = 0;
function searchAddressFrom() {
    var googleAPI = "https://maps.googleapis.com/maps/api/geocode/json?";
    var postalcode = document.getElementById("postalfrom").value.trim();
    var newdiv = document.createElement('div');
    var stringDiv = "";
    var address = "";
    var addressLbl = "";
    var latlng = "";

    while (document.getElementById("sales" + counter) != null) {
        counter++;
    }

    if (!postalcode) {
        stringDiv += "<div class='address-box' id='from" + counter + "'>";
        stringDiv += "<input type='hidden' id='tagId' value='sales" + counter + "_lbl'><span class='close' onClick=\"removeAddress('from" + counter + "', '" + counter + "');\">×</span><hr>";
        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Address: </label>";
        stringDiv += " <div class='col-sm-8'><div class='form-group row'>";
        stringDiv += "<div class ='col-sm-4'>";
        stringDiv += "<input type='text' class='addressInput form-control'  name='addressfrom' size='30' value='" + address.substring(0, address.lastIndexOf(",")) + "'>";
        stringDiv += "</div>"; //close col-sm-4
        stringDiv += "<div class ='col-sm-6'>";
        stringDiv += "<div class='input-group'>";
        stringDiv += "<span class='input-group-addon bg-black'>#</span>";
        stringDiv += "<input type='text' class='addressInput form-control' name='addressfrom' size='2'>";
        stringDiv += "<span class='input-group-addon bg-black'>-</span>";
        stringDiv += "<input type='text' class='addressInput form-control' name='addressfrom' size='3'>";
        stringDiv += "<span class='input-group-addon bg-black'>S</span>";
        stringDiv += "<input type='text' class='addressInput form-control' name='addressfrom' size='5' value='" + postalcode + "'>";
        stringDiv += " </div>";// close input group
        stringDiv += "</div>";//close col-sm-6
        stringDiv += "</div>"; //close form-group row
        stringDiv += "</div></div>"; // col-sm-8, form group
        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Storeys: </label>";
        stringDiv += "<div class ='col-sm-4'>";
        stringDiv += "<input type='text' name='storeysfrom' size='5' class='form-control'>";
        stringDiv += "</div>"; //close col-sm-4
        stringDiv += "</div>"; //close form group
        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Pushing Distance: </label>";
        stringDiv += "<div class ='col-sm-4'>";
        stringDiv += "<div class='input-group'>";
        stringDiv += "<input type='text' name='distancefrom' size='5' class='form-control'> ";
        stringDiv += "<span class='input-group-addon bg-black'>M</span>";
        stringDiv += "</div></div>"; //close input group, col-sm-4
        stringDiv += "</div>"; //close form group
        stringDiv += "</div>"; //close div id tag
        newdiv.innerHTML = stringDiv;
        document.getElementById("from").appendChild(newdiv);
        addSalesDiv(counter, addressLbl);
        counter++;
    } else {
        //query the API for latlng
        $.getJSON(googleAPI, {address: postalcode, sensor: "true"})
                .done(function (data) {
                    try {
                        latlng = (data.results[0].geometry.location.lat + "," + data.results[0].geometry.location.lng);
                        $.getJSON(googleAPI, {latlng: latlng, sensor: "true"})
                                .done(function (data) {
                                    var results = data.results;
                                    for (i = 0; i < results.length; i++) {
                                        var street = false;
                                        var route = false;
                                        var postal = false;
                                        var result = results[i];
                                        var components = result.address_components;
                                        for (j = 0; j < components.length; j++) {
                                            var component = components[j];
                                            var string = component.types[0];
                                            switch (string) {
                                                case "street_number":
                                                    street = true;
                                                    break;
                                                case "route":
                                                    route = true;
                                                    break;
                                                case "postal_code":
                                                    postal = true;
                                            }
                                        }
                                        if (street && route && postal) {
                                            address = result.formatted_address;
                                            addressLbl = address.substring(0, address.lastIndexOf(",")) + " # -  S" + postalcode;
                                            break;
                                        }
                                    }
                                    stringDiv += "<div class='address-box' id='from" + counter + "'>";
                                    stringDiv += "<input type='hidden' id='tagId' value='sales" + counter + "_lbl'><span class='close' onClick=\"removeAddress('from" + counter + "', '" + counter + "');\">×</span><hr>";
                                    stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Address: </label>";
                                    stringDiv += " <div class='col-sm-8'><div class='form-group row'>";
                                    stringDiv += "<div class ='col-sm-4'>";
                                    stringDiv += "<input type='text' class='addressInput form-control'  name='addressfrom' size='30' value='" + address.substring(0, address.lastIndexOf(",")) + "'>";
                                    stringDiv += "</div>"; //close col-sm-4
                                    stringDiv += "<div class ='col-sm-6'>";
                                    stringDiv += "<div class='input-group'>";
                                    stringDiv += "<span class='input-group-addon bg-black'>#</span>";
                                    stringDiv += "<input type='text' class='addressInput form-control' name='addressfrom' size='2'>";
                                    stringDiv += "<span class='input-group-addon bg-black'>-</span>";
                                    stringDiv += "<input type='text' class='addressInput form-control' name='addressfrom' size='3'>";
                                    stringDiv += "<span class='input-group-addon bg-black'>S</span>";
                                    stringDiv += "<input type='text' class='addressInput form-control' name='addressfrom' size='5' value='" + postalcode + "'>";
                                    stringDiv += " </div>";// close input group
                                    stringDiv += "</div>";//close col-sm-6
                                    stringDiv += "</div>"; //close form-group row
                                    stringDiv += "</div></div>"; // col-sm-8, form group
                                    stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Storeys: </label>";
                                    stringDiv += "<div class ='col-sm-4'>";
                                    stringDiv += "<input type='text' name='storeysfrom' size='5' class='form-control'>";
                                    stringDiv += "</div>"; //close col-sm-4
                                    stringDiv += "</div>"; //close form group
                                    stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Pushing Distance: </label>";
                                    stringDiv += "<div class ='col-sm-4'>";
                                    stringDiv += "<div class='input-group'>";
                                    stringDiv += "<input type='text' name='distancefrom' size='5' class='form-control'> ";
                                    stringDiv += "<span class='input-group-addon bg-black'>M</span>";
                                    stringDiv += "</div></div>"; //close input group, col-sm-4
                                    stringDiv += "</div>"; //close form group
                                    stringDiv += "</div>"; //close div id tag
                                    newdiv.innerHTML = stringDiv;
                                    document.getElementById("from").appendChild(newdiv);
                                    addSalesDiv(counter, addressLbl);
                                    counter++;
                                })
                                .fail(function (error) {
                                    console.log(error);
                                    document.getElementById("saMessage").innerHTML = "Unable to find address.<br>Please enter the address manually.";
                                    document.getElementById("saStatus").innerHTML = "<b>ERROR</b>";
                                    var modal = document.getElementById("saModal");
                                    modal.style.display = "block";
                                    stringDiv += "<div class='address-box' id='from" + counter + "'>";
                                    stringDiv += "<input type='hidden' id='tagId' value='sales" + counter + "_lbl'><span class='close' onClick=\"removeAddress('from" + counter + "', '" + counter + "');\">×</span><hr>";
                                    stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Address: </label>";
                                    stringDiv += " <div class='col-sm-8'><div class='form-group row'>";
                                    stringDiv += "<div class ='col-sm-4'>";
                                    stringDiv += "<input type='text' class='addressInput form-control'  name='addressfrom' size='30' value='" + address.substring(0, address.lastIndexOf(",")) + "'>";
                                    stringDiv += "</div>"; //close col-sm-4
                                    stringDiv += "<div class ='col-sm-6'>";
                                    stringDiv += "<div class='input-group'>";
                                    stringDiv += "<span class='input-group-addon bg-black'>#</span>";
                                    stringDiv += "<input type='text' class='addressInput form-control' name='addressfrom' size='2'>";
                                    stringDiv += "<span class='input-group-addon bg-black'>-</span>";
                                    stringDiv += "<input type='text' class='addressInput form-control' name='addressfrom' size='3'>";
                                    stringDiv += "<span class='input-group-addon bg-black'>S</span>";
                                    stringDiv += "<input type='text' class='addressInput form-control' name='addressfrom' size='5' value='" + postalcode + "'>";
                                    stringDiv += " </div>";// close input group
                                    stringDiv += "</div>";//close col-sm-6
                                    stringDiv += "</div>"; //close form-group row
                                    stringDiv += "</div></div>"; // col-sm-8, form group
                                    stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Storeys: </label>";
                                    stringDiv += "<div class ='col-sm-4'>";
                                    stringDiv += "<input type='text' name='storeysfrom' size='5' class='form-control'>";
                                    stringDiv += "</div>"; //close col-sm-4
                                    stringDiv += "</div>"; //close form group
                                    stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Pushing Distance: </label>";
                                    stringDiv += "<div class ='col-sm-4'>";
                                    stringDiv += "<div class='input-group'>";
                                    stringDiv += "<input type='text' name='distancefrom' size='5' class='form-control'> ";
                                    stringDiv += "<span class='input-group-addon bg-black'>M</span>";
                                    stringDiv += "</div></div>"; //close input group, col-sm-4
                                    stringDiv += "</div>"; //close form group
                                    stringDiv += "</div>"; //close div id tag
                                    newdiv.innerHTML = stringDiv;
                                    document.getElementById("from").appendChild(newdiv);
                                    addSalesDiv(counter, addressLbl);
                                    counter++;
                                });
                    } catch (err) {
                        console.log(err);
                        document.getElementById("saMessage").innerHTML = "Unable to find address.<br>Please enter the address manually.";
                        document.getElementById("saStatus").innerHTML = "<b>ERROR</b>";
                        var modal = document.getElementById("saModal");
                        modal.style.display = "block";
                        stringDiv += "<div class='address-box' id='from" + counter + "'>";
                        stringDiv += "<input type='hidden' id='tagId' value='sales" + counter + "_lbl'><span class='close' onClick=\"removeAddress('from" + counter + "', '" + counter + "');\">×</span><hr>";
                        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Address: </label>";
                        stringDiv += " <div class='col-sm-8'><div class='form-group row'>";
                        stringDiv += "<div class ='col-sm-4'>";
                        stringDiv += "<input type='text' class='addressInput form-control'  name='addressfrom' size='30' value='" + address.substring(0, address.lastIndexOf(",")) + "'>";
                        stringDiv += "</div>"; //close col-sm-4
                        stringDiv += "<div class ='col-sm-6'>";
                        stringDiv += "<div class='input-group'>";
                        stringDiv += "<span class='input-group-addon bg-black'>#</span>";
                        stringDiv += "<input type='text' class='addressInput form-control' name='addressfrom' size='2'>";
                        stringDiv += "<span class='input-group-addon bg-black'>-</span>";
                        stringDiv += "<input type='text' class='addressInput form-control' name='addressfrom' size='3'>";
                        stringDiv += "<span class='input-group-addon bg-black'>S</span>";
                        stringDiv += "<input type='text' class='addressInput form-control' name='addressfrom' size='5' value='" + postalcode + "'>";
                        stringDiv += " </div>";// close input group
                        stringDiv += "</div>";//close col-sm-6
                        stringDiv += "</div>"; //close form-group row
                        stringDiv += "</div></div>"; // col-sm-8, form group
                        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Storeys: </label>";
                        stringDiv += "<div class ='col-sm-4'>";
                        stringDiv += "<input type='text' name='storeysfrom' size='5' class='form-control'>";
                        stringDiv += "</div>"; //close col-sm-4
                        stringDiv += "</div>"; //close form group
                        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Pushing Distance: </label>";
                        stringDiv += "<div class ='col-sm-4'>";
                        stringDiv += "<div class='input-group'>";
                        stringDiv += "<input type='text' name='distancefrom' size='5' class='form-control'> ";
                        stringDiv += "<span class='input-group-addon bg-black'>M</span>";
                        stringDiv += "</div></div>"; //close input group, col-sm-4
                        stringDiv += "</div>"; //close form group
                        stringDiv += "</div>"; //close div id tag
                        newdiv.innerHTML = stringDiv;
                        document.getElementById("from").appendChild(newdiv);
                        addSalesDiv(counter, addressLbl);
                        counter++;
                    }
                })
                .fail(function (error) {
                    console.log(error);
                    document.getElementById("saMessage").innerHTML = "Unable to find address.<br>Please enter the address manually.";
                    document.getElementById("saStatus").innerHTML = "<b>ERROR</b>";
                    var modal = document.getElementById("saModal");
                    modal.style.display = "block";
                    stringDiv += "<div class='address-box' id='from" + counter + "'>";
                    stringDiv += "<input type='hidden' id='tagId' value='sales" + counter + "_lbl'><span class='close' onClick=\"removeAddress('from" + counter + "', '" + counter + "');\">×</span><hr>";
                    stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Address: </label>";
                    stringDiv += " <div class='col-sm-8'><div class='form-group row'>";
                    stringDiv += "<div class ='col-sm-4'>";
                    stringDiv += "<input type='text' class='addressInput form-control'  name='addressfrom' size='30' value='" + address.substring(0, address.lastIndexOf(",")) + "'>";
                    stringDiv += "</div>"; //close col-sm-4
                    stringDiv += "<div class ='col-sm-6'>";
                    stringDiv += "<div class='input-group'>";
                    stringDiv += "<span class='input-group-addon bg-black'>#</span>";
                    stringDiv += "<input type='text' class='addressInput form-control' name='addressfrom' size='2'>";
                    stringDiv += "<span class='input-group-addon bg-black'>-</span>";
                    stringDiv += "<input type='text' class='addressInput form-control' name='addressfrom' size='3'>";
                    stringDiv += "<span class='input-group-addon bg-black'>S</span>";
                    stringDiv += "<input type='text' class='addressInput form-control' name='addressfrom' size='5' value='" + postalcode + "'>";
                    stringDiv += " </div>";// close input group
                    stringDiv += "</div>";//close col-sm-6
                    stringDiv += "</div>"; //close form-group row
                    stringDiv += "</div></div>"; // col-sm-8, form group
                    stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Storeys: </label>";
                    stringDiv += "<div class ='col-sm-4'>";
                    stringDiv += "<input type='text' name='storeysfrom' size='5' class='form-control'>";
                    stringDiv += "</div>"; //close col-sm-4
                    stringDiv += "</div>"; //close form group
                    stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Pushing Distance: </label>";
                    stringDiv += "<div class ='col-sm-4'>";
                    stringDiv += "<div class='input-group'>";
                    stringDiv += "<input type='text' name='distancefrom' size='5' class='form-control'> ";
                    stringDiv += "<span class='input-group-addon bg-black'>M</span>";
                    stringDiv += "</div></div>"; //close input group, col-sm-4
                    stringDiv += "</div>"; //close form group
                    stringDiv += "</div>"; //close div id tag
                    newdiv.innerHTML = stringDiv;
                    document.getElementById("from").appendChild(newdiv);
                    addSalesDiv(counter, addressLbl);
                    counter++;
                });
    }

    $('#postalfrom').val('');
}

function searchAddressTo() {
    var googleAPI = "https://maps.googleapis.com/maps/api/geocode/json?";
    var postalcode = document.getElementById("postalto").value.trim();
    var newdiv = document.createElement('div');
    var stringDiv = "";
    var address = "";
    var addressLbl = "";
    var latlng = "";

    while (document.getElementById("sales" + counter) != null) {
        counter++;
    }

    if (!postalcode) {
        stringDiv += "<div class='address-box' id='to" + counter + "'>";
        stringDiv += "<input type='hidden' id='tagId' value='sales" + counter + "_lbl'><span class='close' onClick=\"removeAddress('to" + counter + "', '" + counter + "');\">×</span><hr>";
        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Address: </label>";
        stringDiv += " <div class='col-sm-8'><div class='form-group row'>";
        stringDiv += "<div class ='col-sm-4'>";
        stringDiv += "<input type='text' class='form-control addressInput' name='addressto' size='30' value='" + address.substring(0, address.lastIndexOf(",")) + "'>";
        stringDiv += "</div>"; //close col-sm-4
        stringDiv += "<div class ='col-sm-6'>";
        stringDiv += "<div class='input-group'>";
        stringDiv += "<span class='input-group-addon bg-black'>#</span>";
        stringDiv += "<input type='text' class='form-control addressInput' name='addressto' size='2'>";
        stringDiv += "<span class='input-group-addon bg-black'>-</span>";
        stringDiv += "<input type='text' class='form-control addressInput' name='addressto' size='3'>";
        stringDiv += "<span class='input-group-addon bg-black'>S</span>";
        stringDiv += "<input type='text' class='form-control addressInput' name='addressto' size='5' value='" + postalcode + "'>";
        stringDiv += " </div>";// close input group
        stringDiv += "</div>";//close col-sm-6
        stringDiv += "</div>"; //close form-group row
        stringDiv += "</div></div>"; // col-sm-8, form group
        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Storeys: </label>";
        stringDiv += "<div class ='col-sm-4'>";
        stringDiv += "<input type='text' name='storeysto' size='5' class='form-control'>";
        stringDiv += "</div>"; //close col-sm-4
        stringDiv += "</div>"; //close form group
        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Pushing Distance: </label>";
        stringDiv += "<div class ='col-sm-4'>";
        stringDiv += "<div class='input-group'>";
        stringDiv += "<input type='text' name='distanceto' size='5' class='form-control'> ";
        stringDiv += "<span class='input-group-addon bg-black'>M</span>";
        stringDiv += "</div></div>"; //close input group, col-sm-4
        stringDiv += "</div>"; //close form group
        stringDiv += "</div>"; //close div id tag
        newdiv.innerHTML = stringDiv;
        document.getElementById("to").appendChild(newdiv);
        counter++;
    } else {
        //query the API for latlng
        $.getJSON(googleAPI, {address: postalcode, sensor: "true"})
                .done(function (data) {
                    try {
                        latlng = (data.results[0].geometry.location.lat + "," + data.results[0].geometry.location.lng);
                        $.getJSON(googleAPI, {latlng: latlng, sensor: "true"})
                                .done(function (data) {
                                    var results = data.results;
                                    for (i = 0; i < results.length; i++) {
                                        var street = false;
                                        var route = false;
                                        var postal = false;
                                        var result = results[i];
                                        var components = result.address_components;
                                        for (j = 0; j < components.length; j++) {
                                            var component = components[j];
                                            var string = component.types[0];
                                            switch (string) {
                                                case "street_number":
                                                    street = true;
                                                    break;
                                                case "route":
                                                    route = true;
                                                    break;
                                                case "postal_code":
                                                    postal = true;
                                            }
                                        }
                                        if (street && route && postal) {
                                            address = result.formatted_address;
                                            addressLbl = address.substring(0, address.lastIndexOf(",")) + " # -  S" + postalcode;
                                            break;
                                        }
                                    }

                                    stringDiv += "<div class='address-box' id='to" + counter + "'>";
                                    stringDiv += "<input type='hidden' id='tagId' value='sales" + counter + "_lbl'><span class='close' onClick=\"removeAddress('to" + counter + "', '" + counter + "');\">×</span><hr>";
                                    stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Address: </label>";
                                    stringDiv += " <div class='col-sm-8'><div class='form-group row'>";
                                    stringDiv += "<div class ='col-sm-4'>";
                                    stringDiv += "<input type='text' class='form-control addressInput' name='addressto' size='30' value='" + address.substring(0, address.lastIndexOf(",")) + "'>";
                                    stringDiv += "</div>"; //close col-sm-4
                                    stringDiv += "<div class ='col-sm-6'>";
                                    stringDiv += "<div class='input-group'>";
                                    stringDiv += "<span class='input-group-addon bg-black'>#</span>";
                                    stringDiv += "<input type='text' class='form-control addressInput' name='addressto' size='2'>";
                                    stringDiv += "<span class='input-group-addon bg-black'>-</span>";
                                    stringDiv += "<input type='text' class='form-control addressInput' name='addressto' size='3'>";
                                    stringDiv += "<span class='input-group-addon bg-black'>S</span>";
                                    stringDiv += "<input type='text' class='form-control addressInput' name='addressto' size='5' value='" + postalcode + "'>";
                                    stringDiv += " </div>";// close input group
                                    stringDiv += "</div>";//close col-sm-6
                                    stringDiv += "</div>"; //close form-group row
                                    stringDiv += "</div></div>"; // col-sm-8, form group
                                    stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Storeys: </label>";
                                    stringDiv += "<div class ='col-sm-4'>";
                                    stringDiv += "<input type='text' name='storeysto' size='5' class='form-control'>";
                                    stringDiv += "</div>"; //close col-sm-4
                                    stringDiv += "</div>"; //close form group
                                    stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Pushing Distance: </label>";
                                    stringDiv += "<div class ='col-sm-4'>";
                                    stringDiv += "<div class='input-group'>";
                                    stringDiv += "<input type='text' name='distanceto' size='5' class='form-control'> ";
                                    stringDiv += "<span class='input-group-addon bg-black'>M</span>";
                                    stringDiv += "</div></div>"; //close input group, col-sm-4
                                    stringDiv += "</div>"; //close form group
                                    stringDiv += "</div>"; //close div id tag
                                    newdiv.innerHTML = stringDiv;
                                    document.getElementById("to").appendChild(newdiv);
                                    addSalesDiv(counter, addressLbl);
                                    counter++;
                                })
                                .fail(function (error) {
                                    console.log(error);
                                    document.getElementById("saMessage").innerHTML = "Unable to find address.<br>Please enter the address manually.";
                                    document.getElementById("saStatus").innerHTML = "<b>ERROR</b>";
                                    var modal = document.getElementById("saModal");
                                    modal.style.display = "block";
                                    stringDiv += "<div class='address-box' id='to" + counter + "'>";
                                    stringDiv += "<input type='hidden' id='tagId' value='sales" + counter + "_lbl'><span class='close' onClick=\"removeAddress('to" + counter + "', '" + counter + "');\">×</span><hr>";
                                    stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Address: </label>";
                                    stringDiv += " <div class='col-sm-8'><div class='form-group row'>";
                                    stringDiv += "<div class ='col-sm-4'>";
                                    stringDiv += "<input type='text' class='form-control addressInput' name='addressto' size='30' value='" + address.substring(0, address.lastIndexOf(",")) + "'>";
                                    stringDiv += "</div>"; //close col-sm-4
                                    stringDiv += "<div class ='col-sm-6'>";
                                    stringDiv += "<div class='input-group'>";
                                    stringDiv += "<span class='input-group-addon bg-black'>#</span>";
                                    stringDiv += "<input type='text' class='form-control addressInput' name='addressto' size='2'>";
                                    stringDiv += "<span class='input-group-addon bg-black'>-</span>";
                                    stringDiv += "<input type='text' class='form-control addressInput' name='addressto' size='3'>";
                                    stringDiv += "<span class='input-group-addon bg-black'>S</span>";
                                    stringDiv += "<input type='text' class='form-control addressInput' name='addressto' size='5' value='" + postalcode + "'>";
                                    stringDiv += " </div>";// close input group
                                    stringDiv += "</div>";//close col-sm-6
                                    stringDiv += "</div>"; //close form-group row
                                    stringDiv += "</div></div>"; // col-sm-8, form group
                                    stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Storeys: </label>";
                                    stringDiv += "<div class ='col-sm-4'>";
                                    stringDiv += "<input type='text' name='storeysto' size='5' class='form-control'>";
                                    stringDiv += "</div>"; //close col-sm-4
                                    stringDiv += "</div>"; //close form group
                                    stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Pushing Distance: </label>";
                                    stringDiv += "<div class ='col-sm-4'>";
                                    stringDiv += "<div class='input-group'>";
                                    stringDiv += "<input type='text' name='distanceto' size='5' class='form-control'> ";
                                    stringDiv += "<span class='input-group-addon bg-black'>M</span>";
                                    stringDiv += "</div></div>"; //close input group, col-sm-4
                                    stringDiv += "</div>"; //close form group
                                    stringDiv += "</div>"; //close div id tag
                                    newdiv.innerHTML = stringDiv;
                                    document.getElementById("to").appendChild(newdiv);
                                    counter++;
                                });
                    } catch (err) {
                        console.log(err);
                        document.getElementById("saMessage").innerHTML = "Unable to find address.<br>Please enter the address manually.";
                        document.getElementById("saStatus").innerHTML = "<b>ERROR</b>";
                        var modal = document.getElementById("saModal");
                        modal.style.display = "block";
                        stringDiv += "<div class='address-box' id='to" + counter + "'>";
                        stringDiv += "<input type='hidden' id='tagId' value='sales" + counter + "_lbl'><span class='close' onClick=\"removeAddress('to" + counter + "', '" + counter + "');\">×</span><hr>";
                        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Address: </label>";
                        stringDiv += " <div class='col-sm-8'><div class='form-group row'>";
                        stringDiv += "<div class ='col-sm-4'>";
                        stringDiv += "<input type='text' class='form-control addressInput' name='addressto' size='30' value='" + address.substring(0, address.lastIndexOf(",")) + "'>";
                        stringDiv += "</div>"; //close col-sm-4
                        stringDiv += "<div class ='col-sm-6'>";
                        stringDiv += "<div class='input-group'>";
                        stringDiv += "<span class='input-group-addon bg-black'>#</span>";
                        stringDiv += "<input type='text' class='form-control addressInput' name='addressto' size='2'>";
                        stringDiv += "<span class='input-group-addon bg-black'>-</span>";
                        stringDiv += "<input type='text' class='form-control addressInput' name='addressto' size='3'>";
                        stringDiv += "<span class='input-group-addon bg-black'>S</span>";
                        stringDiv += "<input type='text' class='form-control addressInput' name='addressto' size='5' value='" + postalcode + "'>";
                        stringDiv += " </div>";// close input group
                        stringDiv += "</div>";//close col-sm-6
                        stringDiv += "</div>"; //close form-group row
                        stringDiv += "</div></div>"; // col-sm-8, form group
                        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Storeys: </label>";
                        stringDiv += "<div class ='col-sm-4'>";
                        stringDiv += "<input type='text' name='storeysto' size='5' class='form-control'>";
                        stringDiv += "</div>"; //close col-sm-4
                        stringDiv += "</div>"; //close form group
                        stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Pushing Distance: </label>";
                        stringDiv += "<div class ='col-sm-4'>";
                        stringDiv += "<div class='input-group'>";
                        stringDiv += "<input type='text' name='distanceto' size='5' class='form-control'> ";
                        stringDiv += "<span class='input-group-addon bg-black'>M</span>";
                        stringDiv += "</div></div>"; //close input group, col-sm-4
                        stringDiv += "</div>"; //close form group
                        stringDiv += "</div>"; //close div id tag
                        newdiv.innerHTML = stringDiv;
                        document.getElementById("to").appendChild(newdiv);
                        counter++;
                    }
                })
                .fail(function (error) {
                    console.log(error);
                    document.getElementById("saMessage").innerHTML = "Unable to find address.<br>Please enter the address manually.";
                    document.getElementById("saStatus").innerHTML = "<b>ERROR</b>";
                    var modal = document.getElementById("saModal");
                    modal.style.display = "block";
                    stringDiv += "<div class='address-box' id='to" + counter + "'>";
                    stringDiv += "<input type='hidden' id='tagId' value='sales" + counter + "_lbl'><span class='close' onClick=\"removeAddress('to" + counter + "', '" + counter + "');\">×</span><hr>";
                    stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Address: </label>";
                    stringDiv += " <div class='col-sm-8'><div class='form-group row'>";
                    stringDiv += "<div class ='col-sm-4'>";
                    stringDiv += "<input type='text' class='form-control addressInput' name='addressto' size='30' value='" + address.substring(0, address.lastIndexOf(",")) + "'>";
                    stringDiv += "</div>"; //close col-sm-4
                    stringDiv += "<div class ='col-sm-6'>";
                    stringDiv += "<div class='input-group'>";
                    stringDiv += "<span class='input-group-addon bg-black'>#</span>";
                    stringDiv += "<input type='text' class='form-control addressInput' name='addressto' size='2'>";
                    stringDiv += "<span class='input-group-addon bg-black'>-</span>";
                    stringDiv += "<input type='text' class='form-control addressInput' name='addressto' size='3'>";
                    stringDiv += "<span class='input-group-addon bg-black'>S</span>";
                    stringDiv += "<input type='text' class='form-control addressInput' name='addressto' size='5' value='" + postalcode + "'>";
                    stringDiv += " </div>";// close input group
                    stringDiv += "</div>";//close col-sm-6
                    stringDiv += "</div>"; //close form-group row
                    stringDiv += "</div></div>"; // col-sm-8, form group
                    stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Storeys: </label>";
                    stringDiv += "<div class ='col-sm-4'>";
                    stringDiv += "<input type='text' name='storeysto' size='5' class='form-control'>";
                    stringDiv += "</div>"; //close col-sm-4
                    stringDiv += "</div>"; //close form group
                    stringDiv += "<div class='form-group'><label class='col-sm-3 control-label'>Pushing Distance: </label>";
                    stringDiv += "<div class ='col-sm-4'>";
                    stringDiv += "<div class='input-group'>";
                    stringDiv += "<input type='text' name='distanceto' size='5' class='form-control'> ";
                    stringDiv += "<span class='input-group-addon bg-black'>M</span>";
                    stringDiv += "</div></div>"; //close input group, col-sm-4
                    stringDiv += "</div>"; //close form group
                    stringDiv += "</div>"; //close div id tag
                    newdiv.innerHTML = stringDiv;
                    document.getElementById("to").appendChild(newdiv);
                    counter++;
                });
    }

    $('#postalto').val('');
}

function removeAddress(id, divId) {
    var elem = document.getElementById(id);
    elem.parentNode.removeChild(elem);
    moveDiv -= 1;
    var add = moveDiv - 2;
    if (add > 0) {
        var charges = add * 50;
        $('#detourCharge').val(charges);
    } else {
        $('#detourCharge').val("0.00");
    }

    if (divId !== '') {
        $("#sales" + divId).remove();
        var elem = document.getElementById("li_" + divId);
        elem.parentNode.removeChild(elem);
    }
}

function addSalesDiv(counter, addressLbl) {
    var li = document.createElement("li");
    li.id = "li_" + counter;
    li.style = " background: none";
    li.innerHTML = "<a data-toggle='tab' href='#' class='tablinks' onclick=\"openSales(event, 'sales" + counter + "')\"><label id='sales" + counter + "_lbl'>" + addressLbl + "</label></a>";
    document.getElementById("sales_list").appendChild(li);
    var newdiv = document.createElement('div');
    newdiv.id = "sales" + counter;
    newdiv.className = "tabcontent";
    $.get("LoadSales.jsp", {counter: "sales" + counter}, function (data) {
        newdiv.innerHTML = data;
        var input = newdiv.getElementsByClassName("divId")[0];
        input.value = "sales" + counter + "|" + addressLbl;
    });

    document.getElementById("sales_container").appendChild(newdiv);
    initSalesDiv("sales" + counter);
}

$(document).on('change keyup paste', '.addressInput', function (event) {
    var activeElement = this.parentNode;
    var tagname = activeElement.tagName;
    var classname = activeElement.className;
    while (tagname !== 'DIV' || classname == null || classname !== "address-box") {
        activeElement = activeElement.parentNode;
        tagname = activeElement.tagName;
        classname = activeElement.className;
    }

    var divId;
    var elms = activeElement.getElementsByTagName("input");
    for (var i = 0; i < elms.length; i++) {
        if (elms[i].id === 'tagId') {
            divId = elms[i].value;
            break;
        }
    }

    var lbl = document.getElementById(divId);
    var addresses = activeElement.getElementsByClassName("addressInput");
    var input = document.getElementById(divId.split("_")[0] + "_" + "divId");
    input.value = divId.split("_")[0] + "|" + addresses[0].value + " #" + addresses[1].value + "-" + addresses[2].value + " S" + addresses[3].value;
    lbl.innerHTML = addresses[0].value + " #" + addresses[1].value + "-" + addresses[2].value + " S" + addresses[3].value;
});