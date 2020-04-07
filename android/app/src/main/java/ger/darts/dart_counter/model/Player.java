package ger.darts.dart_counter.model;

import java.io.Serializable;

public class Player implements Serializable {

    private long id;

    private String name;

    private int lastThrow;

    private Game game;

    public Player() {
        id = System.nanoTime();
        name = "";
        lastThrow = -1;
    }

    public Player(String name) {
        id = System.nanoTime();
        this.name = name;
        lastThrow = -1;
    }


    public int getPointsLeft() {
        return game.getCurrentSet().getCurrentLeg().getPointsLeft(this);
    }

    public double getAverage() {
        double avg = game.getAverage(this);
        avg = (double) Math.round(avg*100) / 100;
        return avg;

    }

    public int getDartsThrown() {
        return game.getCurrentSet().getCurrentLeg().getDartsThrown(this);
    }

    public double getCheckOutPercentage() {
        double prct = game.getCheckOutPercentage(this);
        prct = (double) Math.round(prct*100) / 100;
        return prct;
    }

    public int getWonSets() {
        return game.getWonSets(this);
    }

    public int getWonLegs() {
        return game.getCurrentSet().getWonLegs(this);
    }


    // GETTER AND SETTER

    public void setGame(Game game) {
        this.game = game;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getLastThrow() {
        return lastThrow;
    }

    public void setLastThrow(int lastThrow) {
        this.lastThrow = lastThrow;
    }

    @Override
    public boolean equals(Object obj) {
        Player player = (Player) obj;
        return this.id == player.id;
    }
}
