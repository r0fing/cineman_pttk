<%@ page import="model.User" %>
<%@ page import="model.Movie" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }
    Movie movie = (Movie) session.getAttribute("movie");
    if (movie == null) {
        response.sendRedirect(request.getContextPath() + "/movie");
        return;
    }
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Movie Information</title>
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
        .info-container {
            width: 500px;
            padding: 20px;
            background-color: #ffffff;
            border: 1px solid #ddd;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            text-align: left;
        }
        .info-header {
            text-align: center;
        }
        .info-header h1 {
            margin-top: 0;
            margin-bottom: 5px;
        }
        .info-header h2 {
            margin-top: 0;
            margin-bottom: 15px;
        }
        .welcome-user {
            font-size: 0.9em;
            color: #333;
            margin-top: 0;
            margin-bottom: 20px;
            text-align: center;
        }
        .movie-detail {
            margin: 8px 0;
        }
        .movie-detail span.label {
            font-weight: bold;
            display: inline-block;
            width: 130px;
        }
        .movie-description {
            margin-top: 15px;
            padding: 10px;
            border: 1px solid #b0c4de;
            background-color: #e6f2ff;
            border-radius: 4px;
            min-height: 60px;
            white-space: pre-wrap;
        }
        hr {
            border: 0;
            border-top: 1px solid #ccc;
            margin: 20px 0;
        }
        .button-row {
            display: flex;
            justify-content: space-between;
            gap: 10px;
            margin-bottom: 10px;
        }
        .styled-button, .logout-button {
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
        .styled-button:hover,
        .logout-button:hover {
            background-color: #d4e0eb;
        }
        .logout-form {
            text-align: right;
        }
    </style>
</head>
<body>

<div class="info-container">
    <div class="info-header">
        <h1>Cinema System</h1>
        <h2>Movie Information</h2>
    </div>

    <div class="movie-detail">
        <span class="label">Name:</span>
        <span><%= movie.getName() %></span>
    </div>
    <div class="movie-detail">
        <span class="label">Release date:</span>
        <span><%= sdf.format(movie.getReleaseDate()) %></span>
    </div>
    <div class="movie-detail">
        <span class="label">Genre:</span>
        <span><%= movie.getGenre() %></span>
    </div>
    <div class="movie-detail">
        <span class="label">Length:</span>
        <span><%= movie.getLength() %> minutes</span>
    </div>

    <div class="movie-detail">
        <span class="label">Description:</span>
    </div>
    <div class="movie-description">
        <%= movie.getDescription() != null ? movie.getDescription() : "No description available." %>
    </div>

    <hr>

    <div class="button-row">
        <form action="${pageContext.request.contextPath}/movie" method="GET" style="display:inline;">
            <button type="submit" name="btnBack" class="styled-button">Back</button>
        </form>

        <form action="${pageContext.request.contextPath}/movie/clear" method="post" style="display:inline;">
            <button type="submit" class="styled-button">Home</button>
        </form>
    </div>
</div>

</body>
</html>
