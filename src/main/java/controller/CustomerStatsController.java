package controller;

import dao.CustomerStatsDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CustomerStats;

import java.io.IOException;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

@WebServlet(name = "CustomerStatsController", urlPatterns = {"/customer/*"})
public class CustomerStatsController extends HttpServlet {

    private final SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String action = req.getPathInfo();
        System.out.println("POST action = " + action);

        // ============================
        //       HANDLE /clear
        // ============================
        if ("/clear".equals(action)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.removeAttribute("listCS");
                session.removeAttribute("startDate");
                session.removeAttribute("endDate");
            }
            resp.sendRedirect(req.getContextPath() + "/view/managementStaff/StatsView.jsp");
            return;
        }

        resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String action = req.getPathInfo();
        System.out.println("GET action = " + action);

        // Default behavior: load stats
        if (action == null || "/".equals(action)) {

            HttpSession session = req.getSession();
            String startStr = req.getParameter("start");
            String endStr = req.getParameter("end");

            Date startDate = null;
            Date endDate = null;

            try {
                if (startStr != null && !startStr.trim().isEmpty()) {
                    startDate = new Date(df.parse(startStr).getTime());
                    session.setAttribute("startDate", startDate);
                } else {
                    startDate = (Date) session.getAttribute("startDate");
                }

                if (endStr != null && !endStr.trim().isEmpty()) {
                    endDate = new Date(df.parse(endStr).getTime());
                    session.setAttribute("endDate", endDate);
                } else {
                    endDate = (Date) session.getAttribute("endDate");
                }

            } catch (ParseException e) {
                req.setAttribute("errorMessage", "Invalid date format. Please use dd/MM/yyyy");
                req.getRequestDispatcher("/view/managementStaff/CustomerStatsByRevenueView.jsp")
                        .forward(req, resp);
                return;
            }

            try {
                CustomerStatsDAO dao = new CustomerStatsDAO();
                ArrayList<CustomerStats> list = dao.getCustomerStats(startDate, endDate);
                req.setAttribute("listCS", list);
            } catch (Exception e) {
                req.setAttribute("errorMessage", "Failed to load customer statistics.");
                e.printStackTrace();
            }

            req.getRequestDispatcher("/view/managementStaff/CustomerStatsByRevenueView.jsp")
                    .forward(req, resp);
            return;
        } else {
            String idStr = action.substring(1); // remove leading "/"
            int customerId = Integer.parseInt(idStr);

            HttpSession session = req.getSession(false);
            if (session == null) {
                resp.sendRedirect(req.getContextPath() + "/customer");
                return;
            }

            ArrayList<CustomerStats> list =
                    (ArrayList<CustomerStats>) session.getAttribute("listCS");
            if (list == null) {
                resp.sendRedirect(req.getContextPath() + "/customer");
                return;
            }

            CustomerStats selected = null;
            for (CustomerStats cs : list) {
                if (cs.getId() == customerId) {
                    selected = cs;
                    break;
                }
            }

            if (selected != null) {
                session.setAttribute("selectedCustomer", selected);
                req.getRequestDispatcher("/invoice")
                        .forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/customer");
            }
        }
    }
}
