package dao;

import model.CustomerStats;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.util.ArrayList;

public class CustomerStatsDAO extends DAO {

    public CustomerStatsDAO() {
        super();
    }

    public ArrayList<CustomerStats> getCustomerStats(Date start, Date end) {

        ArrayList<CustomerStats> list = new ArrayList<>();

        String sql = """

    SELECT
        u.id           AS customer_id,
        u.name         AS customer_name,
        u.dateOfBirth  AS dateOfBirth,
        u.phoneNumber  AS phoneNumber,
        u.email        AS email,
        u.address      AS address,

        COALESCE(COUNT(t.id), 0) AS tickets_purchased,

        -- Total revenue AFTER the saleoff stored in the INVOICE
        ROUND(
            COALESCE(SUM(t.price * (1 - COALESCE(i.saleoff, 0))), 0)
        ) AS total_revenue

    FROM tblCustomer c
    JOIN tblUser u
          ON u.id = c.tblUserid

    LEFT JOIN tblInvoice i
          ON i.tblCustomerTblUserid = c.tblUserid
         AND i.creationTime >= ?
         AND i.creationTime < DATE_ADD(?, INTERVAL 1 DAY)

    LEFT JOIN tblTicket t
          ON t.tblInvoiceid = i.id

    GROUP BY
        u.id,
        u.name,
        u.dateOfBirth,
        u.phoneNumber,
        u.email,
        u.address

    ORDER BY total_revenue DESC;
    """;


        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setDate(1, start);
            ps.setDate(2, end);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CustomerStats cs = new CustomerStats();

                cs.setId(rs.getInt("customer_id"));
                cs.setName(rs.getString("customer_name"));

                cs.setDateOfBirth(rs.getDate("dateOfBirth"));
                cs.setPhoneNumber(rs.getString("phoneNumber"));
                cs.setEmail(rs.getString("email"));
                cs.setAddress(rs.getString("address"));

                cs.setTicketCount(rs.getInt("tickets_purchased"));
                cs.setRevenue(rs.getFloat("total_revenue"));

                list.add(cs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
