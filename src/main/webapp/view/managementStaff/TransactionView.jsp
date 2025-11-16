<%@ page import="model.User" %>
<%@ page import="model.CustomerStats" %>
<%@ page import="model.Invoice" %>
<%@ page import="model.Ticket" %>
<%@ page import="model.Showtime" %>
<%@ page import="model.Movie" %>
<%@ page import="model.Theater" %>
<%@ page import="model.Cinema" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // ---- Security check ----
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }

    // Selected customer statistics (set in CustomerStatsController)
    CustomerStats customer = (CustomerStats) session.getAttribute("selectedCustomer");
    if (customer == null) {
        response.sendRedirect(request.getContextPath() + "/customerStats");
        return;
    }

    // List of invoices for this customer in the period (set in InvoiceController)
    ArrayList<Invoice> listInvoice =
            (ArrayList<Invoice>) request.getAttribute("listInvoice");

    SimpleDateFormat dtf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Transactions</title>
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
        .txn-container {
            width: 950px;
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

        .customer-info {
            margin-bottom: 15px;
            line-height: 1.6;
        }
        .customer-info span.label {
            font-weight: bold;
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

        .txn-table {
            width: 100%;
            border-collapse: collapse;
        }
        .txn-table th,
        .txn-table td {
            border: 1px solid #b0c4de;
            padding: 8px;
            text-align: left;
            vertical-align: top;
        }
        .txn-table thead th {
            background-color: #e0e8f0;
            font-weight: bold;
        }

        .bottom-buttons {
            margin-top: 15px;
            display: flex;
            justify-content: space-between; /* Back left, Home right */
            align-items: center;
        }
    </style>
</head>
<body>

<div class="txn-container">
    <h1>Cinema System</h1>
    <h2>Customer Transactions</h2>

    <!-- Customer information -->
    <div class="customer-info">
        <div><span class="label">Customer code:</span> <%= customer.getId() %></div>
        <div><span class="label">Customer name:</span> <%= customer.getName() %></div>
        <div><span class="label">Customer date of birth:</span>
            <%= (customer.getDateOfBirth() != null ? customer.getDateOfBirth() : "") %>
        </div>
        <div><span class="label">Customer phone:</span>
            <%= (customer.getPhoneNumber() != null ? customer.getPhoneNumber() : "") %>
        </div>
        <div><span class="label">Customer email:</span>
            <%= (customer.getEmail() != null ? customer.getEmail() : "") %>
        </div>
        <div><span class="label">Customer address:</span>
            <%= (customer.getAddress() != null ? customer.getAddress() : "") %>
        </div>
    </div>

    <hr>

    <!-- Transactions table -->
    <table class="txn-table">
        <thead>
        <tr>
            <th>ID</th>
            <th>Movie</th>
            <th>Cinema</th>
            <th>Theater</th>
            <th>Seats</th>
            <th>Watch time</th>
            <th>Total price (in VND)</th>
            <th>Saleoff</th>
            <th>Method of order</th>
            <th>Creation time</th>
            <th>Saler</th>
        </tr>
        </thead>
        <tbody>
        <%
            if (listInvoice != null && !listInvoice.isEmpty()) {
                for (Invoice inv : listInvoice) {

                    List<Ticket> tickets = inv.getTicketList();
                    Ticket firstTicket = null;
                    Showtime showtime = null;
                    Movie movie = null;
                    Theater theater = null;
                    Cinema cinema = null;
                    String seats = "";
                    String methodOfOrder = "";
                    String watchTimeStr = "";

                    if (tickets != null && !tickets.isEmpty()) {
                        firstTicket = tickets.get(0);
                        showtime = firstTicket.getShowtime();
                        if (showtime != null) {
                            movie = showtime.getMovie();
                            theater = showtime.getTheater();
                            if (theater != null) {
                                cinema = theater.getCinema();
                            }
                            if (showtime.getScreeningTime() != null) {
                                watchTimeStr = dtf.format(showtime.getScreeningTime());
                            }
                        }
                        methodOfOrder = firstTicket.getMethodOfOrder();

                        StringBuilder sb = new StringBuilder();
                        for (int i = 0; i < tickets.size(); i++) {
                            if (i > 0) sb.append(", ");
                            if (tickets.get(i).getSeat() != null) {
                                sb.append(tickets.get(i).getSeat().getName());
                            }
                        }
                        seats = sb.toString();
                    }
        %>
        <tr>
            <td><%= inv.getId() %></td>
            <td><%= (movie != null ? movie.getName() : "") %></td>
            <td><%= (cinema != null ? cinema.getName() : "") %></td>
            <td><%= (theater != null ? theater.getName() : "") %></td>
            <td><%= seats %></td>
            <td><%= watchTimeStr %></td>
            <td><%= Math.round(inv.getTotalPrice()) %></td>
            <td><%= Math.round(inv.getSaleoff() * 100) %>%</td>
            <td><%= methodOfOrder %></td>
            <td><%= (inv.getCreationTime() != null ? dtf.format(inv.getCreationTime()) : "") %></td>
            <td><%= (inv.getSaler() != null ? inv.getSaler().getName() : "") %></td>
        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <td colspan="11" style="text-align:center;">No transactions found in this period.</td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>

    <div class="bottom-buttons">
        <!-- Back: go back to CustomerStatsByRevenueView.jsp -->
        <a href="${pageContext.request.contextPath}/customer" class="styled-button">Back</a>

        <!-- Home: clear invoice context and go to management staff home -->
        <form action="${pageContext.request.contextPath}/invoice/clear"
              method="POST"
              style="display:inline;">
            <button type="submit" class="styled-button">Home</button>
        </form>
    </div>
</div>

</body>
</html>
