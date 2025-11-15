package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
// ▼▼▼ ADD THIS IMPORT ▼▼▼
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;

@WebServlet(name = "UserController", urlPatterns = {"/login", "/", "/logout"})
public class UserController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("[UserController] doPost triggered");
        System.out.println("Available drivers: " + java.sql.DriverManager.getDrivers().hasMoreElements());

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String path = request.getServletPath();

        if ("/login".equals(path)) {
            String username = request.getParameter("inUsername");
            String password = request.getParameter("inPassword");

            System.out.println("[UserController] Data received: " + username + ", " + password);

            try {
                User user = new User();
                user.setUsername(username);
                user.setPassword(password);

                UserDAO dao = new UserDAO();
                boolean success = dao.checkLogin(user);

                if (success) {
                    System.out.println("[UserController] successfully logged in");

                    // ▼▼▼ ADD THESE TWO LINES ▼▼▼
                    // 1. Get the current session (or create one if it doesn't exist)
                    HttpSession session = request.getSession();
                    // 2. Store the user's name in the session.
                    session.setAttribute("user", user);

                    if (user.getRole().equals("customer")) {
                        response.sendRedirect(request.getContextPath() + "/view/customer/CustomerHomeView.jsp");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/view/managementStaff/ManagementStaffHomeView.jsp");
                    }
                } else {
                    System.out.println("[UserController] unsuccessfully logged in");
                    request.setAttribute("errorMessage", "Invalid username or password");
                    request.getRequestDispatcher("/view/user/LoginView.jsp").forward(request, response);
                }
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Encounter error logging in");
                request.getRequestDispatcher("/view/user/LoginView.jsp").forward(request, response);
            }

        } else {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/".equals(path)) {
            request.getRequestDispatcher("/view/user/LoginView.jsp").forward(request, response);
        }
    }
}