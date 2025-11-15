<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login Page</title>
    <style>
        /* Basic styling for the page */
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center; /* Center horizontally */
            align-items: center;   /* Center vertically */
            height: 90vh;          /* Use full viewport height */
            background-color: #f9f9f9;
            margin: 0;
        }

        /* The main container for the login form */
        .login-container {
            width: 350px;
            padding: 20px;
            background-color: #ffffff;
            border: 1px solid #ddd;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        /* Center the title */
        .login-container h2, h1 {
            text-align: center;
            margin-top: 0;
            margin-bottom: 20px;
        }

        /* Use a table for simple label-input alignment */
        .login-form-table {
            width: 100%;
            border-spacing: 10px; /* Add space between cells */
        }

        .login-form-table td {
            vertical-align: middle;
        }

        /* Style for the labels (Username:, Password:) */
        .login-form-table label {
            font-weight: bold;
            display: block; /* Ensures it aligns well */
            text-align: right;
        }

        /* Style for the text and password input boxes */
        .login-form-table input[type="text"],
        .login-form-table input[type="password"] {
            width: 95%;
            padding: 8px;
            border: 1px solid #b0c4de; /* Light steel blue border */
            background-color: #e6f2ff; /* Light blue background like image */
            border-radius: 4px;
        }

        /* The horizontal line */
        hr {
            border: 0;
            border-top: 1px solid #ccc;
            margin: 20px 0;
        }

        /* Center the login button */
        .button-container {
            text-align: center;
        }

        /* Style for the login button */
        .login-button {
            padding: 8px 30px;
            font-size: 1em;
            font-weight: bold;
            color: #333;
            background-color: #e0e8f0; /* Light blue/grey background */
            border: 1px solid #b0c4de;
            border-radius: 4px;
            cursor: pointer;
        }

        .login-button:hover {
            background-color: #d4e0eb;
        }

    </style>
</head>
<body>

<div class="login-container">
    <h1>Cinema System</h1>
    <h2>Login</h2>

    <%
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (errorMessage != null) {
    %>
    <p class="error-message"><%= errorMessage %></p>
    <%
        }
    %>

    <form action="${pageContext.request.contextPath}/login" method="POST">

        <table class="login-form-table">
            <tr>
                <td><label for="username">Username:</label></td>
                <td><input type="text" name="inUsername" id="username" ></td>
            </tr>
            <tr>
                <td><label for="password">Password:</label></td>
                <td><input type="password" name="inPassword" id="password" ></td>
            </tr>
        </table>

        <hr>

        <div class="button-container">
            <input type="submit" name="btnLogin" value="Login" class="login-button" >
        </div>

    </form>
</div>

</body>
</html>