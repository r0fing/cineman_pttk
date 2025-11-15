<%@ page import="model.User" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Movie" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // --- Security Check ---
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/view/user/LoginView.jsp");
        return;
    }
    String keyword = (String) request.getAttribute("keyword");
    if (keyword == null) {
        keyword = (String) session.getAttribute("keyword");
    }


    ArrayList<Movie> movieList = (ArrayList<Movie>) request.getAttribute("movieList");

    SimpleDateFormat yearFormat = new SimpleDateFormat("yyyy");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Movie Search</title>
    <style>
        /* (All the CSS styles from the previous example go here) */
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
        .search-container {
            width: 500px;
            padding: 20px;
            background-color: #ffffff;
            border: 1px solid #ddd;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            text-align: center;
        }
        .search-container h2 {
            margin-top: 0;
            margin-bottom: 25px;
        }
        .search-form {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
        }
        .search-form label {
            font-weight: bold;
        }
        .search-form input[type="text"] {
            width: 200px;
            padding: 8px;
            border: 1px solid #b0c4de;
            background-color: #e6f2ff;
            border-radius: 4px;
        }
        .styled-button {
            padding: 8px 20px;
            font-size: 1em;
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
            margin: 20px 0;
        }
        .results-table {
            width: 100%;
            border-collapse: collapse;
        }
        .results-table th, .results-table td {
            border: 1px solid #b0c4de;
            padding: 10px;
            text-align: left;
        }
        .results-table thead th {
            background-color: #e0e8f0;
            font-weight: bold;
        }

        /* -- NEW: Styles for the selectable rows -- */
        .selectable-row {
            cursor: pointer; /* Show a hand cursor on hover */
            background-color: #e6f2ff; /* Original row color */
        }
        .selectable-row:hover {
            background-color: #d4e0eb; /* Darker blue on hover */
        }
        .row-selected {
            background-color: #b0c4de; /* Steel blue when selected */
            font-weight: bold;
            color: #000;
        }

        .pagination-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<div class="search-container">
    <h1>Cinema System</h1>
    <h2>Movie Search</h2>

    <form action="${pageContext.request.contextPath}/movie" method="get" class="search-form">
        <label for="keyword">Please enter the keyword:</label>
        <input type="text" name="inMovieName" id="keyword"
               value="<%= (keyword != null ? keyword : "") %>">
        <input type="submit" name="btnSearch" value="Search" class="styled-button">
    </form>

    <hr>

    <form id="movieForm" action="${pageContext.request.contextPath}/movie" method="get" onsubmit="return validateSelection()">

        <input type="hidden" id="selectedMovieId" name="movieId">

        <% if (movieList != null && !movieList.isEmpty()) { %>

        <table class="results-table">
            <thead>
            <tr>
                <th>Movie name</th>
                <th>Release year</th>
            </tr>
            </thead>
            <tbody>
            <% for (Movie movie : movieList) { %>
            <tr class="selectable-row" data-id="<%= movie.getId() %>">
                <td><%= movie.getName() %></td> <td><%= yearFormat.format(movie.getReleaseDate()) %></td> </tr>
            <% } %>
            </tbody>
        </table>

        <% } %>
    </form>
        <hr>

        <div class="pagination-buttons">
            <form action="${pageContext.request.contextPath}/movie/clear" method="POST" style="display:inline;">
                <button type="submit" name="btnBack" class="styled-button">Back</button>
            </form>

            <input type="submit" name="btnNext" form="movieForm" value="Next" class="styled-button">
        </div>
</div>

<script>
    // Get all the rows that can be clicked
    const rows = document.querySelectorAll('.selectable-row');

    // Get the hidden input field
    const hiddenInput = document.getElementById('selectedMovieId');

    const movieForm = document.getElementById('movieForm');

    // Add a click listener to each row
    rows.forEach(row => {
        row.addEventListener('click', function() {

            // 1. Get the ID from the 'data-id' attribute
            const movieId = this.dataset.id;

            // 2. Set the hidden input's value
            hiddenInput.value = movieId;

            // 3. Remove highlight from all *other* rows
            rows.forEach(r => r.classList.remove('row-selected'));

            // 4. Add highlight to *this* row
            this.classList.add('row-selected');
        });
    });

    // This function runs when you click "Next"
    function validateSelection() {
        if (hiddenInput.value === "") {
            alert('Please select a movie first.');
            return false; // This stops the form from submitting
        }
        const movieId = hiddenInput.value;
        movieForm.action = '${pageContext.request.contextPath}/movie/' + movieId;
        return true; // Allows the form to submit
    }
</script>

</body>
</html>