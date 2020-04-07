package ger.darts.dart_counter.model;

import java.io.Serializable;

public class Throw implements Serializable {

    private int points;
    private int dartsOnDouble;
    private int dartsThrown;
    private Player player;


    public Throw(int points, Player player) {
        this.points = points;
        this.player = player;
        this.dartsOnDouble = 0;
        this.dartsThrown = 3;
    }

    public Throw(int points, int dartsThrown, int dartsOnDouble, Player player) {
        this.points = points;
        this.player = player;
        this.dartsOnDouble = dartsOnDouble;
        this.dartsThrown = dartsThrown;
    }


    public int getPoints() {
        return points;
    }

    public int getDartsOnDouble() {
        return dartsOnDouble;
    }

    public int getDartsThrown() {
        return dartsThrown;
    }

    public Player getPlayer() {
        return player;
    }

    public void setPoints(int points) {
        this.points = points;
    }

    public void setDartsOnDouble(int dartsOnDouble) {
        this.dartsOnDouble = dartsOnDouble;
    }

    public void setDartsThrown(int dartsThrown) {
        this.dartsThrown = dartsThrown;
    }

    public void setPlayer(Player player) {
        this.player = player;
    }


    @Override
    public String toString() {
        return player.getName() + " - " + points + " - " + dartsThrown + " - " + dartsOnDouble;
    }
}
