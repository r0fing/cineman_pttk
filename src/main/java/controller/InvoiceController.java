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

        String action = req.getPathInfo();

        if ("/clear".equals(action)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.removeAttribute("selectedCustomer");
                 session.removeAttribute("startDate");
                 session.removeAttribute("endDate");
            }

            resp.sendRedirect(req.getContextPath() + "/view/managementStaff/ManagementStaffHomeView.jsp");
        } else {
            resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getPathInfo();

        if (action != null && !"/".equals(action)) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        CustomerStats customer = (CustomerStats) session.getAttribute("selectedCustomer");
        if (customer == null) {
            resp.sendRedirect(req.getContextPath() + "/customer");
            return;
        }

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
