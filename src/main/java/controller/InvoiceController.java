package controller;

import dao.InvoiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CustomerStats;
import model.Invoice;
import model.User;

import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;

@WebServlet(name = "InvoiceController", urlPatterns = {"/invoice/*"})
public class InvoiceController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getPathInfo(); // may be null, "/clear", etc.

        if ("/clear".equals(action)) {
            // Clear data related to this transaction view
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.removeAttribute("selectedCustomer");
                // startDate / endDate you can keep or clear depending on your design
                 session.removeAttribute("startDate");
                 session.removeAttribute("endDate");
            }

            // Go back to management staff home
            resp.sendRedirect(req.getContextPath() + "/view/managementStaff/ManagementStaffHomeView.jsp");
        } else {
            // For now, no other POST actions
            resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getPathInfo(); // null or "/"

        // We only support listing invoices at /invoice or /invoice/
        if (action != null && !"/".equals(action)) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        // Check login
        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        // Selected customer, set when you clicked "Next" on CustomerStatsByRevenueView
        CustomerStats customer = (CustomerStats) session.getAttribute("selectedCustomer");
        if (customer == null) {
            resp.sendRedirect(req.getContextPath() + "/customer");
            return;
        }

        // Date range used for statistics
        Date start = (Date) session.getAttribute("startDate");
        Date end   = (Date) session.getAttribute("endDate");
        if (start == null || end == null) {
            resp.sendRedirect(req.getContextPath() + "/customer");
            return;
        }

        try {
            InvoiceDAO dao = new InvoiceDAO();
            ArrayList<Invoice> listInvoice =
                    dao.getInvoice(customer.getId(), start, end);

            req.setAttribute("listInvoice", listInvoice);

            req.getRequestDispatcher("/view/managementStaff/TransactionView.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Cannot load transactions for this customer.");
            req.getRequestDispatcher("/view/managementStaff/TransactionView.jsp")
                    .forward(req, resp);
        }
    }
}
