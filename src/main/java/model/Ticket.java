package model;

public class Ticket {
    private int id;
    private Theater theater;
    private ShowtimeSeat seat;
    private float price;
    private String methodOfOrder;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Theater getTheater() {
        return theater;
    }

    public void setTheater(Theater theater) {
        this.theater = theater;
    }

    public ShowtimeSeat getSeat() {
        return seat;
    }

    public void setSeat(ShowtimeSeat seat) {
        this.seat = seat;
    }

    public float getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    public String getMethodOfOrder() {
        return methodOfOrder;
    }

    public void setMethodOfOrder(String methodOfOrder) {
        this.methodOfOrder = methodOfOrder;
    }
}
