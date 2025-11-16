<%@ page import="model.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }

%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Management Staff Home</title>
    <style>
        /* Consistent styling from the Login page */
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center; /* Center horizontally */
            align-items: center;   /* Center vertically */
            height: 90vh;          /* Use full viewport height */
            background-color: #f9f9f9;
            margin: 0;
        }

        /* The main container for the home page */
        .home-container {
            width: 350px;
            padding: 20px;
            background-color: #ffffff;
            border: 1px solid #ddd;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            text-align: center; /* Center all content */
        }

        /* "Customer Home" title */
        .home-container h2 {
            margin-top: 0;
            margin-bottom: 10px;
        }

        /* "User's name" text */
        .welcome-user {
            font-size: 0.9em;
            color: #333;
            margin-top: 0;
            margin-bottom: 30px;
        }

        /* Container for the buttons */
        .button-group {
            display: flex;
            flex-direction: column; /* Stack buttons vertically */
            align-items: center;    /* Center them */
            gap: 15px; /* Space between the buttons */
        }

        /* Style for the buttons (using <a> links) */
        .action-button {
            display: block;
            width: 200px;
            padding: 10px;
            font-size: 1.1em;
            font-weight: bold;
            color: #333;
            background-color: #e0e8f0; /* Light blue/grey background */
            border: 1px solid #b0c4de;
            border-radius: 4px;
            text-decoration: none; /* Remove underline from link */
            cursor: pointer;
        }

        .action-button:hover {
            background-color: #d4e0eb;
        }

        /* The horizontal line */
        hr {
            border: 0;
            border-top: 1px solid #ccc;
            margin-top: 30px; /* Space above the line */
            margin-bottom: 10px; /* Space below the line */
        }

    </style>
</head>
<body>

<div class="home-container">
    <h1>Cinema System</h1>
    <h2>Statistic</h2>

    <div class="button-group">

        <form action="${pageContext.request.contextPath}/view/managementStaff/CustomerStatsByRevenueView.jsp">
            <button type="submit" name="btnViewCustomerStatsByRevenue" class="action-button">
                Customer Statistics
            </button>
        </form>
        <form action="${pageContext.request.contextPath}/view/managementStaff/ManagementStaffHomeView.jsp" method="POST">
            <button type="submit" name="btnBack" class="action-button">
                Back
            </button>
        </form>
    </div>

    <hr>

</div>

</body>
</html>