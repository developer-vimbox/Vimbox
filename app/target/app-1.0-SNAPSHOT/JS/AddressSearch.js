var counter = 1;
var moveDiv = 0;
function searchAddressFrom() {
    var googleAPI = "http://maps.googleapis.com/maps/api/geocode/json?";
    var postalcode = document.getElementById("postalfrom").value;
    var newdiv = document.createElement('div');
    var stringDiv = "";
    var address = "";
    var latlng = "";

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
                                break;
                            }
                        }
                        stringDiv += "<div class='address-box' id='from" + counter + "'><span class='close' onClick=\"removeAddress('from" + counter + "');\">×</span><hr><table><col width='100'><tr><td align='right'>";
                        stringDiv += ("<b>Address :</b></td><td><input type='text' name='addressfrom' size='30' value='" + address.substring(0, address.lastIndexOf(",")) + "'>");
                        stringDiv += " #<input type='text' name='addressfrom' size='2'>-<input type='text' name='addressfrom' size='3'>";
                        stringDiv += " S<input type='text' name='addressfrom' size='5' value='" + postalcode + "'></td>";
                        stringDiv += "<tr><td align='right'><b>Storeys :</b></td><td><input type='text' name='storeysfrom' size='5'></td></tr>";
                        stringDiv += "<tr><td align='right'><b>Pushing Distance :</b></td><td><input type='text' name='distancefrom' size='5'> M</td></tr>";
                        stringDiv += "</table></div>";
                        newdiv.innerHTML = stringDiv;
                        document.getElementById("from").appendChild(newdiv);
                        counter++;
                        calculateDetourCharge();
                    })
                    .fail(function (error) {
                        console.log(error);
                        document.getElementById("saMessage").innerHTML = "Unable to find address.<br>Please enter the address manually.";
                        document.getElementById("saStatus").innerHTML = "<b>ERROR</b>";
                        var modal = document.getElementById("saModal");
                        modal.style.display = "block";
                        stringDiv += "<div class='address-box' id='from" + counter + "'><span class='close' onClick=\"removeAddress('from" + counter + "');\">×</span><hr><table><col width='100'><tr><td align='right'>";
                        stringDiv += ("<b>Address :</b></td><td><input type='text' name='addressfrom' size='30'>");
                        stringDiv += " #<input type='text' name='addressfrom' size='2'>-<input type='text' name='addressfrom' size='3'>";
                        stringDiv += " S<input type='text' name='addressfrom' size='5' value='" + postalcode + "'></td>";
                        stringDiv += "<tr><td align='right'><b>Storeys :</b></td><td><input type='text' name='storeysfrom' size='5'></td></tr>";
                        stringDiv += "<tr><td align='right'><b>Pushing Distance :</b></td><td><input type='text' name='distancefrom' size='5'> M</td></tr>";
                        stringDiv += "</table></div>";
                        newdiv.innerHTML = stringDiv;
                        document.getElementById("from").appendChild(newdiv);
                        counter++;
                        calculateDetourCharge();
                    });
        } catch (err) {
            console.log(err);
            document.getElementById("saMessage").innerHTML = "Unable to find address.<br>Please enter the address manually.";
            document.getElementById("saStatus").innerHTML = "<b>ERROR</b>";
            var modal = document.getElementById("saModal");
            modal.style.display = "block";
            stringDiv += "<div class='address-box' id='from" + counter + "'><span class='close' onClick=\"removeAddress('from" + counter + "');\">×</span><hr><table><col width='100'><tr><td align='right'>";
            stringDiv += ("<b>Address :</b></td><td><input type='text' name='addressfrom' size='30'>");
            stringDiv += " #<input type='text' name='addressfrom' size='2'>-<input type='text' name='addressfrom' size='3'>";
            stringDiv += " S<input type='text' name='addressfrom' size='5' value='" + postalcode + "'></td>";
            stringDiv += "<tr><td align='right'><b>Storeys :</b></td><td><input type='text' name='storeysfrom' size='5'></td></tr>";
            stringDiv += "<tr><td align='right'><b>Pushing Distance :</b></td><td><input type='text' name='distancefrom' size='5'> M</td></tr>";
            stringDiv += "</table></div>";
            newdiv.innerHTML = stringDiv;
            document.getElementById("from").appendChild(newdiv);
            counter++;
            calculateDetourCharge();
        }
    })
    .fail(function (error) {
        console.log(error);
        document.getElementById("saMessage").innerHTML = "Unable to find address.<br>Please enter the address manually.";
        document.getElementById("saStatus").innerHTML = "<b>ERROR</b>";
        var modal = document.getElementById("saModal");
        modal.style.display = "block";
        stringDiv += "<div class='address-box' id='from" + counter + "'><span class='close' onClick=\"removeAddress('from" + counter + "');\">×</span><hr><table><col width='100'><tr><td align='right'>";
        stringDiv += ("<b>Address :</b></td><td><input type='text' name='addressfrom' size='30'>");
        stringDiv += " #<input type='text' name='addressfrom' size='2'>-<input type='text' name='addressfrom' size='3'>";
        stringDiv += " S<input type='text' name='addressfrom' size='5' value='" + postalcode + "'></td>";
        stringDiv += "<tr><td align='right'><b>Storeys :</b></td><td><input type='text' name='storeysfrom' size='5'></td></tr>";
        stringDiv += "<tr><td align='right'><b>Pushing Distance :</b></td><td><input type='text' name='distancefrom' size='5'> M</td></tr>";
        stringDiv += "</table></div>";
        newdiv.innerHTML = stringDiv;
        document.getElementById("from").appendChild(newdiv);
        counter++;
        calculateDetourCharge();
    });
}
function searchAddressTo() {
    var googleAPI = "http://maps.googleapis.com/maps/api/geocode/json?";
    var postalcode = document.getElementById("postalto").value;
    var newdiv = document.createElement('div');
    var stringDiv = "";
    var address = "";
    var latlng = "";

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
                                break;
                            }
                        }

                        stringDiv += "<div class='address-box' id='to" + counter + "'><span class='close' onClick=\"removeAddress('to" + counter + "');\">×</span><hr><table><col width='100'><tr><td align='right'>";
                        stringDiv += ("<b>Address :</b></td><td><input type='text' name='addressto' size='30' value='" + address.substring(0, address.lastIndexOf(",")) + "'>");
                        stringDiv += " #<input type='text' name='addressto' size='2'>-<input type='text' name='addressto' size='3'>";
                        stringDiv += " S<input type='text' name='addressto' size='5' value='" + postalcode + "'></td>";
                        stringDiv += "<tr><td align='right'><b>Storeys :</b></td><td><input type='text' name='storeysto' size='5'></td></tr>";
                        stringDiv += "<tr><td align='right'><b>Pushing Distance :</b></td><td><input type='text' name='distanceto' size='5'> M</td></tr>";
                        stringDiv += "</table></div>";
                        newdiv.innerHTML = stringDiv;
                        document.getElementById("to").appendChild(newdiv);
                        counter++;
                        calculateDetourCharge();
                    })
                    .fail(function (error) {
                        console.log(error);
                        document.getElementById("saMessage").innerHTML = "Unable to find address.<br>Please enter the address manually.";
                        document.getElementById("saStatus").innerHTML = "<b>ERROR</b>";
                        var modal = document.getElementById("saModal");
                        modal.style.display = "block";
                        stringDiv += "<div class='address-box' id='to" + counter + "'><span class='close' onClick=\"removeAddress('to" + counter + "');\">×</span><hr><table><col width='100'><tr><td align='right'>";
                        stringDiv += ("<b>Address :</b></td><td><input type='text' name='addressto' size='30'>");
                        stringDiv += " #<input type='text' name='addressto' size='2'>-<input type='text' name='addressto' size='3'>";
                        stringDiv += " S<input type='text' name='addressto' size='5' value='" + postalcode + "'></td>";
                        stringDiv += "<tr><td align='right'><b>Storeys :</b></td><td><input type='text' name='storeysto' size='5'></td></tr>";
                        stringDiv += "<tr><td align='right'><b>Pushing Distance :</b></td><td><input type='text' name='distanceto' size='5'> M</td></tr>";
                        stringDiv += "</table></div>";
                        newdiv.innerHTML = stringDiv;
                        document.getElementById("to").appendChild(newdiv);
                        counter++;
                        calculateDetourCharge();
                    });
        } catch (err) {
            console.log(err);
            document.getElementById("saMessage").innerHTML = "Unable to find address.<br>Please enter the address manually.";
            document.getElementById("saStatus").innerHTML = "<b>ERROR</b>";
            var modal = document.getElementById("saModal");
            modal.style.display = "block";
            stringDiv += "<div class='address-box' id='to" + counter + "'><span class='close' onClick=\"removeAddress('to" + counter + "');\">×</span><hr><table><col width='100'><tr><td align='right'>";
            stringDiv += ("<b>Address :</b></td><td><input type='text' name='addressto' size='30'>");
            stringDiv += " #<input type='text' name='addressto' size='2'>-<input type='text' name='addressto' size='3'>";
            stringDiv += " S<input type='text' name='addressto' size='5' value='" + postalcode + "'></td>";
            stringDiv += "<tr><td align='right'><b>Storeys :</b></td><td><input type='text' name='storeysto' size='5'></td></tr>";
            stringDiv += "<tr><td align='right'><b>Pushing Distance :</b></td><td><input type='text' name='distanceto' size='5'> M</td></tr>";
            stringDiv += "</table></div>";
            newdiv.innerHTML = stringDiv;
            document.getElementById("to").appendChild(newdiv);
            counter++;
            calculateDetourCharge();
        }
    })
    .fail(function (error) {
        console.log(error);
        document.getElementById("saMessage").innerHTML = "Unable to find address.<br>Please enter the address manually.";
        document.getElementById("saStatus").innerHTML = "<b>ERROR</b>";
        var modal = document.getElementById("saModal");
        modal.style.display = "block";
        stringDiv += "<div class='address-box' id='to" + counter + "'><span class='close' onClick=\"removeAddress('to" + counter + "');\">×</span><hr><table><col width='100'><tr><td align='right'>";
        stringDiv += ("<b>Address :</b></td><td><input type='text' name='addressto' size='30'>");
        stringDiv += " #<input type='text' name='addressto' size='2'>-<input type='text' name='addressto' size='3'>";
        stringDiv += " S<input type='text' name='addressto' size='5' value='" + postalcode + "'></td>";
        stringDiv += "<tr><td align='right'><b>Storeys :</b></td><td><input type='text' name='storeysto' size='5'></td></tr>";
        stringDiv += "<tr><td align='right'><b>Pushing Distance :</b></td><td><input type='text' name='distanceto' size='5'> M</td></tr>";
        stringDiv += "</table></div>";
        newdiv.innerHTML = stringDiv;
        document.getElementById("to").appendChild(newdiv);
        counter++;
        calculateDetourCharge();
    });
}

function calculateDetourCharge(){
    moveDiv += 1;
    var add = moveDiv - 2;
    if(add > 0){
        var charges = add * 50;
        $('#detourCharge').val(charges);
    }else{
        $('#detourCharge').val("0.00");
    }
}

function removeAddress(id){
    var elem = document.getElementById(id); 
    elem.parentNode.removeChild(elem);
    moveDiv -= 1;
    var add = moveDiv - 2;
    if(add > 0){
        var charges = add * 50;
        $('#detourCharge').val(charges);
    }else{
        $('#detourCharge').val("0.00");
    }
}

