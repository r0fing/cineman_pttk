package dao;

import model.Movie;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class MovieDAO extends DAO {
    public MovieDAO() {
        super();
    }

    public ArrayList<Movie> getMovie(String movieName) {
        ArrayList<Movie> MovieList = new ArrayList<>();
        String sql = "SELECT * FROM tblMovie WHERE name = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, movieName);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                Movie m = new Movie();
                m.setId(rs.getInt("id"));
                m.setName(rs.getString("name"));
                m.setReleaseDate(rs.getDate("releaseDate"));
                m.setGenre(rs.getString("genre"));
                m.setLength(rs.getFloat("length"));
                m.setDescription(rs.getString("description"));
                MovieList.add(m);
            }
        }catch(Exception e) {
            e.printStackTrace();
        }
        return MovieList;
    }
}
