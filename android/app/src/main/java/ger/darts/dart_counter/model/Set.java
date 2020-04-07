package ger.darts.dart_counter.model;

import java.io.Serializable;
import java.util.ArrayList;

import ger.darts.dart_counter.model.commons.GameType;

public class Set implements Serializable {

    protected Game game;

    protected int size;

    protected ArrayList<Leg> legs;

    protected Player firstTurn;

    public Set(Game game, int size, Player firstTurn) {
        this.game = game;
        this.size = size;
        legs = new ArrayList<>();
        this.firstTurn = firstTurn;
        startNewLeg(firstTurn);
    }

    // INTERFACE

    public Leg getCurrentLeg() {
        return legs.get(legs.size() - 1);
    }


    // INTERNAL

    protected void startNewLeg(Player firstTurn) {
        legs.add(new Leg(game, firstTurn));
    }

    protected void performThrow(int points, int dartsOnDouble, int dartsThrown) {
        getCurrentLeg().performThrow(points, dartsOnDouble, dartsThrown);
    }

    protected void undoLastThrow() {
        int dartsThrown = 0;
        if(game.getGameType().equals(GameType.LEGS)) {
            for(Player player : game.getPlayers()) {
                dartsThrown += getCurrentLeg().getDartsThrown(player);
            }

            // is new Leg
            if(dartsThrown == 0) {
                if(legs.size() > 1) {
                    legs.remove(getCurrentLeg());
                    getCurrentLeg().undoLastThrow();
                }
            } else {
                getCurrentLeg().undoLastThrow();
            }
        } else if(game.getGameType().equals(GameType.SETS)) {
            for(Player player : game.getPlayers()) {
                dartsThrown += getDartsThrown(player);
            }

            // is new Set
            if(dartsThrown == 0) {
                if(game.getSets().size() > 1) {
                    game.getSets().remove(this);
                    game.getCurrentSet().getCurrentLeg().undoLastThrow();
                }
            } else {
                // is the 2nd or larger Leg in a running Set
                int temp = 0;
                for(Player player : game.getPlayers()) {
                    temp += getCurrentLeg().getDartsThrown(player);
                }

                // is new Leg
                if(temp == 0) {
                    if(legs.size() > 1) {
                        legs.remove(getCurrentLeg());
                        getCurrentLeg().undoLastThrow();
                    }
                } else {
                    getCurrentLeg().undoLastThrow();
                }
            }
        }
    }

    protected int getWonLegs(Player player) {
        int wonLegs = 0;
        for (Leg leg : legs) {
            Player winner = leg.getWinner();
            if (winner != null && winner.equals(player)) {
                wonLegs++;
            }
        }
        return wonLegs;
    }

    protected int getScoredPoints(Player player) {
        int scoredPoints = 0;
        for (Leg leg : legs) {
            scoredPoints += leg.getScoredPoints(player);
        }
        return scoredPoints;
    }

    protected int getDartsThrown(Player player) {
        int dartsThrown = 0;
        for (Leg leg : legs) {
            dartsThrown += leg.getDartsThrown(player);
        }
        return dartsThrown;
    }

    protected int getDartsOnDouble(Player player) {
        int dartsOnDouble = 0;
        for (Leg leg : legs) {
            dartsOnDouble += leg.getDartsOnDouble(player);
        }
        return dartsOnDouble;
    }

    protected Player getWinner() {
        for (Player player : game.players) {
            if (getWonLegs(player) == size) {
                return player;
            }
        }
        return null;
    }


    // STATS

    public double getAverage(Player player) {
        try {
            return (double) (getScoredPoints(player) * 3) / getDartsThrown(player);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    public double getCheckOutPercentage(Player player) {
        try {
            return (double) getWonLegs(player) / getDartsOnDouble(player);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

}
