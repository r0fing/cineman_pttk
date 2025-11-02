package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

import java.io.IOException;

@WebServlet("/UserController")
public class UserController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("[CustomerController] doPost triggered");
        System.out.println("Available drivers: " + java.sql.DriverManager.getDrivers().hasMoreElements());

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        System.out.println("[CustomerController] Data received: " + username + ", " + password);

        User user = new User();
        user.setUsername(username);
        user.setPassword(password);

        UserDAO dao = new UserDAO();
        boolean success = dao.checkLogin(user);

        if (success) {
            System.out.println("[CustomerController] successfully logged in");
            response.sendRedirect(request.getContextPath() + "/view/customer/CustomerHomeView.jsp");
        } else {
            System.out.println("[CustomerController] unsuccessfully logged in");
            response.sendRedirect(request.getContextPath() + "/view/user/LoginView.jsp");
        }
    }
}
