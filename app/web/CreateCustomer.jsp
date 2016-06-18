<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Customer</title>
    </head>
    <body>
        <h2>Customer Information</h2><hr>
        <table>
            <tr>
                <td align="right"><b>Salutation :</b></td>
                <td>
                    <select id="create_salutation" autofocus>
                        <option value="Mr">Mr</option>
                        <option value="Ms">Ms</option>
                        <option value="Mrs">Mrs</option>
                        <option value="Mdm">Mdm</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td align="right"><b>First Name :</b></td>
                <td>
                    <input type="text" id="create_first_name">
                </td>
            </tr>
            <tr>
                <td align="right"><b>Last Name :</b></td>
                <td>
                    <input type="text" id="create_last_name">
                </td>
            </tr>
            <tr>
                <td align="right"><b>Contact :</b></td>
                <td>
                    <input type="number" id="create_contact">
                </td>
            </tr>
            <tr>
                <td align="right"><b>Email :</b></td>
                <td>
                    <input type="text" id="create_email">
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <button onclick="createCustomer();return false;">Add</button>
                </td>
            </tr>
        </table>
    </body>
</html>
