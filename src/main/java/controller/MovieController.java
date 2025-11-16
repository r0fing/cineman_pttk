package controller;

import dao.MovieDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Movie;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "MovieController", urlPatterns = {"/movie/*"})
public class MovieController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();

        if ("/clear".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.removeAttribute("movieList");
                session.removeAttribute("keyword");
                session.removeAttribute("movie");
            }
            response.sendRedirect(request.getContextPath() + "/view/customer/CustomerHomeView.jsp");
        } else {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        System.out.println(action);

        if (action == null || "/".equals(action)) {
            HttpSession session = request.getSession();
            String keyword = request.getParameter("inMovieName");
            ArrayList<Movie> movieList;

            try {
                if (keyword == null || keyword.trim().isEmpty()) {
                    keyword = (String) session.getAttribute("keyword");
                    movieList = (ArrayList<Movie>) session.getAttribute("movieList");
                } else {
                    MovieDAO movieDAO = new MovieDAO();
                    movieList = movieDAO.getMovie(keyword);

                    session.setAttribute("movieList", movieList);
                    session.setAttribute("keyword", keyword);
                }

                request.setAttribute("movieList", movieList);
                request.setAttribute("keyword", keyword);

                request.getRequestDispatcher("/view/customer/SearchMovieView.jsp")
                        .forward(request, response);
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Failed to load list of movies");
                request.getRequestDispatcher("/view/customer/SearchMovieView.jsp")
                        .forward(request, response);
                e.printStackTrace();
            }
        } else {
            int movieId;
            try {
                movieId = Integer.parseInt(action.split("/")[1]);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid movie ID");
                return;
            }
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.sendRedirect(request.getContextPath() + "/movie");
                return;
            }
            ArrayList<Movie> movieList = (ArrayList<Movie>) session.getAttribute("movieList");
            if (movieList == null || movieList.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/movie");
                return;
            }
            Movie selectedMovie = null;
            for (Movie movie : movieList) {
                if (movie.getId() == movieId) {
                    selectedMovie = movie;
                    break;
                }
            }
            if (selectedMovie != null) {
                session.setAttribute("movie", selectedMovie);
                request.getRequestDispatcher("/view/customer/MovieInfoView.jsp").forward(request, response);
            }
        }
    }
}
