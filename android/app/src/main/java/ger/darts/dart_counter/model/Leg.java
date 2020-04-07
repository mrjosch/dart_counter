package ger.darts.dart_counter.model;

import java.io.Serializable;
import java.util.ArrayList;

import ger.darts.dart_counter.model.commons.GameType;

public class Leg implements Serializable {

    protected Game game;

    protected ArrayList<Integer> pointsLeft;
    protected ArrayList<Integer> dartsThrown;
    protected ArrayList<Integer> dartsOnDouble;

    protected Player firstTurn;
    protected Player currentTurn;

    public Leg(Game game, Player firstTurn) {
        this.game = game;

        pointsLeft = new ArrayList<>();
        dartsThrown = new ArrayList<>();
        dartsOnDouble = new ArrayList<>();

        for (int i = 0; i < game.players.size(); i++) {
            pointsLeft.add(game.startingPoints);
            dartsThrown.add(0);
            dartsOnDouble.add(0);
        }

        this.firstTurn = firstTurn;
        currentTurn = firstTurn;
    }

    // INTERFACE

    public Player getCurrentTurn() {
        return currentTurn;
    }


    // INTERNAL

    protected void performThrow(int points, int dartsOnDouble, int dartsThrown) {
        int index = game.indexOf(currentTurn);
        int ptsLeft = pointsLeft.get(index);
        pointsLeft.set(index, ptsLeft - points);
        this.dartsOnDouble.set(index, this.dartsOnDouble.get(index) + dartsOnDouble);
        this.dartsThrown.set(index, this.dartsThrown.get(index) + dartsThrown);
        getCurrentTurn().setLastThrow(points);
        nextTurn();
    }

    protected void undoLastThrow() {
        Throw last = game.getThrowHistory().pop();
        currentTurn = last.getPlayer();
        int index = game.indexOf(currentTurn);
        int ptsLeft = getPointsLeft(currentTurn) + last.getPoints();
        pointsLeft.set(index, ptsLeft);
        this.dartsOnDouble.set(index, this.dartsOnDouble.get(index) - last.getDartsOnDouble());
        this.dartsThrown.set(index, this.dartsThrown.get(index) - last.getDartsThrown());
        int throwIndex = game.getThrowHistory().size() - game.getPlayers().size();
        if(throwIndex >= 0) {
            getCurrentTurn().setLastThrow(game.getThrowHistory().get(throwIndex).getPoints());
        } else {
            getCurrentTurn().setLastThrow(-1);
        }

    }//X O O X O O

    protected void nextTurn() {
        if (getWinner() == null) {
            // LEG continues
            int nextIndex = (game.indexOf(currentTurn) + 1) % game.players.size();
            currentTurn = game.players.get(nextIndex);
        } else {
            // LEG finished
            if (game.gameType.equals(GameType.LEGS)) {
                if (game.getWinner() == null) {
                    // GAME continues  -> new LEG
                    int indexNextLegFirstTurn = (game.indexOf(firstTurn) + 1) % game.players.size();
                    game.getCurrentSet().startNewLeg(game.players.get(indexNextLegFirstTurn));
                }
            } else if (game.gameType.equals(GameType.SETS)) {
                if (game.getCurrentSet().getWinner() == null) {
                    // SET continues -> new LEG
                    int indexNextLegFirstTurn = (game.indexOf(firstTurn) + 1) % game.players.size();
                    game.getCurrentSet().startNewLeg(game.players.get(indexNextLegFirstTurn));
                } else {
                    // SET finished
                    if (game.getWinner() == null) {
                        // GAME continues -> new SET
                        int indexNextSetFirstTurn = (game.indexOf(game.getCurrentSet().firstTurn) + 1) % game.players.size();
                        game.startNewSet(game.players.get(indexNextSetFirstTurn));
                    }
                }
            }
        }
    }

    protected int getPointsLeft(Player player) {
        return pointsLeft.get(game.indexOf(player));
    }

    protected int getScoredPoints(Player player) {
        return game.startingPoints - getPointsLeft(player);
    }

    protected int getDartsThrown(Player player) {
        return dartsThrown.get(game.indexOf(player));
    }

    protected int getDartsOnDouble(Player player) {
        return dartsOnDouble.get(game.indexOf(player));
    }

    protected Player getWinner() {
        for (int i = 0; i < pointsLeft.size(); i++) {
            if (pointsLeft.get(i) == 0) {
                return game.players.get(i);
            }
        }
        return null;
    }


    // STATS

    public double getAverage(Player player) {
        try {
            return (double) (getScoredPoints(player) * 3) / dartsThrown.get(game.indexOf(player));
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    public double getCheckOutPercentage(Player player) {
        try {
            return (double) 1 / getDartsOnDouble(player);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

}
