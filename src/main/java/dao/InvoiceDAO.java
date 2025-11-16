package dao;

import model.Cinema;
import model.Invoice;
import model.Movie;
import model.Saler;
import model.Seat;
import model.Showtime;
import model.Theater;
import model.Ticket;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;

public class InvoiceDAO extends DAO {

    public InvoiceDAO() {
        super();
    }
    public ArrayList<Invoice> getInvoice(int idCustomer, Date start, Date end) {

        Map<Integer, Invoice> invoiceMap = new LinkedHashMap<>();
        Map<Integer, Float>  sumPriceMap = new LinkedHashMap<>();

        String sql = """
                SELECT
                    -- Invoice
                    i.id              AS invoice_id,
                    i.saleoff         AS saleoff_rate,
                    i.creationTime    AS creation_time,

                    -- Saler
                    u_saler.id        AS saler_id,
                    u_saler.name      AS saler_name,

                    -- Ticket
                    t.id              AS ticket_id,
                    t.price           AS ticket_price,
                    t.methodOfOrder   AS method_of_order,

                    -- Seat
                    se.id             AS seat_id,
                    se.name           AS seat_name,

                    -- Showtime
                    sh.id             AS showtime_id,
                    sh.screeningTime  AS screening_time,

                    -- Movie
                    m.id              AS movie_id,
                    m.name            AS movie_name,

                    -- Theater
                    th.id             AS theater_id,
                    th.name           AS theater_name,

                    -- Cinema
                    ci.id             AS cinema_id,
                    ci.name           AS cinema_name

                FROM tblInvoice i
                JOIN tblCustomer c
                      ON c.tblUserid = i.tblCustomerTblUserid

                JOIN tblSaler s
                      ON s.tblStaffTblUserid = i.tblSalerTblUserid
                JOIN tblStaff st
                      ON st.tblUserid = s.tblStaffTblUserid
                JOIN tblUser u_saler
                      ON u_saler.id = st.tblUserid

                JOIN tblTicket t
                      ON t.tblInvoiceid = i.id

                JOIN tblSeat se
                      ON se.id = t.tblSeatid

                JOIN tblShowtime sh
                      ON sh.id = t.tblShowtimeid

                JOIN tblMovie m
                      ON m.id = sh.tblMovieid

                JOIN tblTheater th
                      ON th.id = sh.tblTheaterid

                JOIN tblCinema ci
                      ON ci.id = th.tblCinemaid

                WHERE c.tblUserid = ?
                  AND i.creationTime >= ?
                  AND i.creationTime < DATE_ADD(?, INTERVAL 1 DAY)

                ORDER BY i.creationTime, i.id, t.id;
                """;

        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idCustomer);
            ps.setDate(2, start);
            ps.setDate(3, end);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {

                int invoiceId = rs.getInt("invoice_id");

                Invoice inv = invoiceMap.get(invoiceId);
                if (inv == null) {
                    inv = new Invoice();
                    inv.setId(invoiceId);

                    inv.setSaleoff(rs.getFloat("saleoff_rate"));

                    Timestamp ct = rs.getTimestamp("creation_time");
                    inv.setCreationTime(ct);

                    Saler saler = new Saler();
                    saler.setId(rs.getInt("saler_id"));
                    saler.setName(rs.getString("saler_name"));
                    inv.setSaler(saler);

                    inv.setTicketList(new ArrayList<>());

                    invoiceMap.put(invoiceId, inv);
                    sumPriceMap.put(invoiceId, 0f);
                }


                Movie movie = new Movie();
                movie.setId(rs.getInt("movie_id"));
                movie.setName(rs.getString("movie_name"));

                Cinema cinema = new Cinema();
                cinema.setId(rs.getInt("cinema_id"));
                cinema.setName(rs.getString("cinema_name"));

                Theater theater = new Theater();
                theater.setId(rs.getInt("theater_id"));
                theater.setName(rs.getString("theater_name"));
                theater.setCinema(cinema);

                Showtime showtime = new Showtime();
                showtime.setId(rs.getInt("showtime_id"));
                showtime.setScreeningTime(rs.getTimestamp("screening_time"));
                showtime.setMovie(movie);
                showtime.setTheater(theater);

                Seat seat = new Seat();
                seat.setId(rs.getInt("seat_id"));
                seat.setName(rs.getString("seat_name"));

                Ticket ticket = new Ticket();
                ticket.setId(rs.getInt("ticket_id"));
                ticket.setPrice(rs.getFloat("ticket_price"));
                ticket.setMethodOfOrder(rs.getString("method_of_order"));
                ticket.setSeat(seat);
                ticket.setShowtime(showtime);

                inv.getTicketList().add(ticket);

                float oldSum = sumPriceMap.get(invoiceId);
                sumPriceMap.put(invoiceId, oldSum + ticket.getPrice());
            }

            for (Map.Entry<Integer, Invoice> entry : invoiceMap.entrySet()) {
                Integer invoiceId = entry.getKey();
                Invoice inv = entry.getValue();

                Float sumTickets = sumPriceMap.get(invoiceId);
                if (sumTickets == null) sumTickets = 0f;

                float totalAfterDiscount = sumTickets * (1 - inv.getSaleoff());
                inv.setTotalPrice(totalAfterDiscount);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return new ArrayList<>(invoiceMap.values());
    }
}