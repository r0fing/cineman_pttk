<%@ page import="model.User" %>
<%@ page import="model.CustomerStats" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.Date" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }

    Date startDate = (Date) session.getAttribute("startDate");
    Date endDate   = (Date) session.getAttribute("endDate");
    SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
    String startStr = (startDate != null) ? df.format(startDate) : "";
    String endStr   = (endDate != null)   ? df.format(endDate)   : "";

    ArrayList<CustomerStats> statsList =
            (ArrayList<CustomerStats>) request.getAttribute("listCS");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Statistics by Revenue</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 90vh;
            background-color: #f9f9f9;
            margin: 0;
            padding: 20px 0;
        }
        .stats-container {
            width: 800px;
            padding: 20px;
            background-color: #ffffff;
            border: 1px solid #ddd;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        h1, h2 {
            text-align: center;
            margin: 0;
        }
        h1 { margin-bottom: 5px; }
        h2 { margin-bottom: 20px; }

        .filter-form {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
        }
        .filter-form label {
            font-weight: bold;
        }
        .filter-form input[type="text"] {
            width: 120px;
            padding: 5px;
            border: 1px solid #b0c4de;
            background-color: #e6f2ff;
            border-radius: 4px;
        }

        .styled-button {
            padding: 6px 18px;
            font-size: 0.95em;
            font-weight: bold;
            color: #333;
            background-color: #e0e8f0;
            border: 1px solid #b0c4de;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        .styled-button:hover {
            background-color: #d4e0eb;
        }

        hr {
            border: 0;
            border-top: 1px solid #ccc;
            margin: 15px 0;
        }

        .error-message {
            color: red;
            text-align: center;
            margin-bottom: 10px;
        }

        .results-table {
            width: 100%;
            border-collapse: collapse;
        }
        .results-table th,
        .results-table td {
            border: 1px solid #b0c4de;
            padding: 8px;
            text-align: left;
        }
        .results-table thead th {
            background-color: #e0e8f0;
            font-weight: bold;
        }

        /* clickable row styles */
        .selectable-row {
            cursor: pointer;
            background-color: #e6f2ff;
        }
        .selectable-row:hover {
            background-color: #d4e0eb;
        }
        .row-selected {
            background-color: #b0c4de;
            font-weight: bold;
        }

        .bottom-buttons {
            margin-top: 15px;
            display: flex;
            justify-content: space-between; /* Back left, Next right */
            align-items: center;
        }
    </style>
</head>
<body>

<div class="stats-container">
    <h1>Cinema System</h1>
    <h2>Customer Statistics by Revenue</h2>

    <% if (errorMessage != null) { %>
    <p class="error-message"><%= errorMessage %></p>
    <% } %>

    <form action="${pageContext.request.contextPath}/customer" method="get"
          class="filter-form">
        <label for="start">From:</label>
        <input type="text" id="start" name="start" placeholder="dd/MM/yyyy"
               value="<%= startStr %>">

        <label for="end">To:</label>
        <input type="text" id="end" name="end" placeholder="dd/MM/yyyy"
               value="<%= endStr %>">

        <input type="submit" value="View" class="styled-button">
    </form>

    <hr>

    <table class="results-table">
        <thead>
        <tr>
            <th>Customer Code</th>
            <th>Customer name</th>
            <th>Tickets purchased</th>
            <th>Total revenue (in VND)</th>
        </tr>
        </thead>
        <tbody>
        <%
            if (statsList != null && !statsList.isEmpty()) {
                for (CustomerStats cs : statsList) {
        %>
        <tr class="selectable-row" data-id="<%= cs.getId() %>">
            <td><%= cs.getId() %></td>
            <td><%= cs.getName() %></td>
            <td><%= cs.getTicketCount() %></td>
            <td><%= Math.round(cs.getRevenue()) %></td>
        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <td colspan="4" style="text-align:center;">No data for this period.</td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>

    <%
        int totalTickets = 0;
        float totalRevenue = 0;

        if (statsList != null) {
            for (CustomerStats cs : statsList) {
                totalTickets += cs.getTicketCount();
                totalRevenue += cs.getRevenue();
            }
        }
    %>

    <hr>

    <div style="display:flex; justify-content:space-between; padding: 0 5px;">
        <div><strong>Total tickets purchased:</strong> <%= totalTickets %></div>
        <div><strong>Total revenue:</strong> <%= Math.round(totalRevenue) %> VND</div>
    </div>

    <hr>

    <div class="bottom-buttons">
        <form action="${pageContext.request.contextPath}/customer/clear"
              method="POST"
              style="display:inline;">
            <button type="submit" class="styled-button">Back</button>
        </form>

        <form id="customerForm"
              action="${pageContext.request.contextPath}/customer"
              method="GET"
              style="display:inline;"
              onsubmit="return validateSelection();">
            <input type="hidden" id="selectedCustomerId" name="customerId">
            <input type="submit" value="Next" class="styled-button">
        </form>
    </div>
</div>

<script>
    const baseUrl = '<%= request.getContextPath() %>/customer/';

    const rows = document.querySelectorAll('.selectable-row');
    const hiddenInput = document.getElementById('selectedCustomerId');
    const customerForm = document.getElementById('customerForm');

    rows.forEach(row => {
        row.addEventListener('click', function () {
            const id = this.dataset.id;

            hiddenInput.value = id;

            rows.forEach(r => r.classList.remove('row-selected'));
            this.classList.add('row-selected');
        });
    });

    function validateSelection() {
        if (!hiddenInput.value) {
            alert('Please select a customer first.');
            return false;
        }
        customerForm.action = baseUrl + hiddenInput.value;
        return true;
    }
</script>

</body>
</html>
