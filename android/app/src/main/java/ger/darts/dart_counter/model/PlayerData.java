package ger.darts.dart_counter.model;

public class PlayerData {

    private String pointsLeft;
    private String dartsThrown;
    private String checkoutPercentage;
    private String average;
    private String pointsLastThrow;
    private String legsWon;
    private String setsWon;
    private String turn;

    public PlayerData(int pointsLeft, int dartsThrown, double checkoutPercentage, double average, int pointsLastThrow, int legsWon, int setsWon, boolean turn) {
        this.pointsLeft = String.valueOf(pointsLeft);
        this.dartsThrown = String.valueOf(dartsThrown);
        this.checkoutPercentage = String.valueOf(checkoutPercentage); // TODO format
        this.average = String.valueOf(average); // TODO format
        this.pointsLastThrow = String.valueOf(pointsLastThrow);
        this.legsWon = String.valueOf(legsWon);
        this.setsWon = String.valueOf(setsWon);
        this.turn = String.valueOf(turn);
    }

    public String getPointsLeft() {
        return pointsLeft;
    }

    public void setPointsLeft(String pointsLeft) {
        this.pointsLeft = pointsLeft;
    }

    public String getDartsThrown() {
        return dartsThrown;
    }

    public void setDartsThrown(String dartsThrown) {
        this.dartsThrown = dartsThrown;
    }

    public String getCheckoutPercentage() {
        return checkoutPercentage;
    }

    public void setCheckoutPercentage(String checkoutPercentage) {
        this.checkoutPercentage = checkoutPercentage;
    }

    public String getAverage() {
        return average;
    }

    public void setAverage(String average) {
        this.average = average;
    }

    public String getPointsLastThrow() {
        return pointsLastThrow;
    }

    public void setPointsLastThrow(String pointsLastThrow) {
        this.pointsLastThrow = pointsLastThrow;
    }

    public String getLegsWon() {
        return legsWon;
    }

    public void setLegsWon(String legsWon) {
        this.legsWon = legsWon;
    }

    public String getSetsWon() {
        return setsWon;
    }

    public void setSetsWon(String setsWon) {
        this.setsWon = setsWon;
    }

    public String getTurn() {
        return turn;
    }

    public void setTurn(String turn) {
        this.turn = turn;
    }
}
