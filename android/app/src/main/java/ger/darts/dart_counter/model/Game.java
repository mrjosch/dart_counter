package ger.darts.dart_counter.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Stack;

import ger.darts.dart_counter.model.commons.GameMode;
import ger.darts.dart_counter.model.commons.GameType;


public class Game implements Serializable {

    /**
     * How to use the model
     * <p>
     * 1. performThrow();
     * 2. validateThrow
     * 3. check if in finishZone
     * 4. check for Winner of game
     */

    protected GameMode gameMode;
    protected GameType gameType;

    protected int size;

    protected int startingPoints;
    protected ArrayList<Player> players;

    protected ArrayList<Set> sets;


    private Throw preparedThrow;
    private Stack<Throw> throwHistory;      // Contains all performed Throws but no prepared Throw

    public Game() {
        gameMode = GameMode.FIRST_TO;
        gameType = GameType.LEGS;
        startingPoints = 501;
        size = 1;

        players = new ArrayList<>();
        throwHistory = new Stack<>();
    }

    // INTERNAL

    protected void startNewSet(Player firstTurn) {
        switch (gameType) {
            case LEGS:
                sets.add(new Set(this, size, firstTurn));
                break;
            case SETS:
                sets.add(new Set(this, 3, firstTurn));
                break;
        }
    }

    protected int getScoredPoints(Player player) {
        int scoredPoints = 0;
        for (Set set : sets) {
            scoredPoints += set.getScoredPoints(player);
        }
        return scoredPoints;
    }

    protected int getWonLegs(Player player) {
        int wonLegs = 0;
        for (Set set : sets) {
            wonLegs += set.getWonLegs(player);
        }
        return wonLegs;
    }

    protected int getWonSets(Player player) {
        int wonSets = 0;
        // TODO remove if view of sets gets added if set game only
        if (gameType.equals(GameType.LEGS)) {
            return -1;
        }

        for (Set set : sets) {
            Player winner = set.getWinner();
            if (winner != null && winner.equals(player)) {
                wonSets++;
            }
        }
        return wonSets;
    }

    protected int getDartsThrown(Player player) {
        int dartsThrown = 0;
        for (Set set : sets) {
            dartsThrown += set.getDartsThrown(player);
        }
        return dartsThrown;
    }

    protected int getDartsOnDouble(Player player) {
        int dartsOnDouble = 0;
        for (Set set : sets) {
            dartsOnDouble += set.getDartsOnDouble(player);
        }
        return dartsOnDouble;
    }

    protected double getAverage(Player player) {
        try {
            double avg = (double) (getScoredPoints(player) * 3) / getDartsThrown(player);
            if (Double.isNaN(avg)) {
                return 0;
            } else {
                return avg;
            }
        } catch (ArithmeticException e) {
            return 0;
        }
    }

    protected double getCheckOutPercentage(Player player) {
        try {
            double prct = (double) getWonLegs(player) / getDartsOnDouble(player);
            if (Double.isNaN(prct)) {
                return 0;
            } else {
                return prct;
            }

        } catch (ArithmeticException e) {
            return 0;
        }
    }

    protected int indexOf(Player player) {
        for (int i = 0; i < players.size(); i++) {
            if (player.equals(players.get(i))) {
                return i;
            }
        }
        return -1;
    }

    // INTERFACE

    public void start() {
        sets = new ArrayList<>();
        for (Player player : players) {
            player.setGame(this);
        }
        startNewSet(players.get(0));
    }

    public void performThrow() {
        getCurrentSet().performThrow(preparedThrow.getPoints(), preparedThrow.getDartsOnDouble(), preparedThrow.getDartsThrown());
        throwHistory.push(preparedThrow);
        preparedThrow = null;
    }

    public void prepareThrow(Throw t) {
        preparedThrow = t;
       /* if(preparedThrow.getPlayer() == null) {
            preparedThrow.setPlayer(getCurrentTurn());
        }*/
    }

    public void undoLastThrow() {
        getCurrentSet().undoLastThrow();
    }

    public Set getCurrentSet() {
        return sets.get(sets.size() - 1);
    }

    public String getDescription() {
        return gameMode.toString().replace("_", " ") + " " + size + " " + gameType.toString().replace("_", " ");
    }

    public Player getCurrentTurn() {
        return getCurrentSet().getCurrentLeg().getCurrentTurn();
    }

    public Player getWinner() {
        switch (gameType) {
            case LEGS:
                int legsNeededToWin;
                switch (gameMode) {
                    case FIRST_TO:
                        legsNeededToWin = size;
                        for (Player player : players) {
                            if (getWonLegs(player) == legsNeededToWin) {
                                return player;
                            }
                        }
                        break;
                    case BEST_OF:
                        legsNeededToWin = Math.round(size / 2)+1;
                        for (Player player : players) {
                            if (getWonLegs(player) == legsNeededToWin) {
                                return player;
                            }
                        }
                        break;
                }
            case SETS:
                int setsNeededToWin;
                switch (gameMode) {
                    case FIRST_TO:
                        setsNeededToWin = size;
                        for (Player player : players) {
                            if (getWonSets(player) == setsNeededToWin) {
                                return player;
                            }
                        }
                        break;
                    case BEST_OF:
                        setsNeededToWin = Math.round(size / 2)+1;
                        for (Player player : players) {
                            if (getWonSets(player) == setsNeededToWin) {
                                return player;
                            }
                        }
                        break;
                }
        }
        return null;
    }

    public ArrayList<Player> getPlayers() {
        return players;
    }

    public GameMode getGameMode() {
        return gameMode;
    }

    public void setGameMode(GameMode gameMode) {
        this.gameMode = gameMode;
    }

    public GameType getGameType() {
        return gameType;
    }

    public void setGameType(GameType gameType) {
        this.gameType = gameType;
    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }

    public int getStartingPoints() {
        return startingPoints;
    }

    public void setStartingPoints(int startingPoints) {
        this.startingPoints = startingPoints;
    }

    public void setPlayers(ArrayList<Player> players) {
        this.players = players;
    }

    public ArrayList<Set> getSets() {
        return sets;
    }

    public void setSets(ArrayList<Set> sets) {
        this.sets = sets;
    }

    public void addPlayer() {
        players.add(new Player());
    }

    public void addPlayer(String name) {
        players.add(new Player(name));
    }

    void removePlayer(int pos) {
        players.remove(pos);
    }

    public Stack<Throw> getThrowHistory() {
        return throwHistory;
    }

    public void setThrowHistory(Stack<Throw> throwHistory) {
        this.throwHistory = throwHistory;
    }

    public Throw getPreparedThrow() {
        return preparedThrow;
    }

    public String getFinalStats() {
        String result = getDescription() + "\r\n\r\n";
        String data;

        for (Player player : players) {
            data = "Name: " + player.getName() + "\r\n" +
                    "Average : " + player.getAverage() + "\r\n" +
                    "CheckOut: " + player.getCheckOutPercentage() + "\r\n";
            if (player.getWonSets() != -1) {
                data += "Sets: " + player.getWonSets() + "\r\n";
            }
            data += "Legs: " + player.getWonLegs() + "\r\n" +
                    "---------------------------------------------------\r\n";
            result += data;
        }

        return result;
    }

    public List<PlayerData> getPlayerData() {
        List<PlayerData> data = new ArrayList<>();

        for (Player player : players) {
            data.add(new PlayerData(player.getPointsLeft(), player.getDartsThrown(), player.getCheckOutPercentage(), player.getAverage(), player.getLastThrow(), player.getWonLegs(), player.getWonSets(), getCurrentTurn().equals(player)));
        }
        return data;
    }

    public ArrayList<HashMap<String,String>> getPlayerDataMap() {
        ArrayList<HashMap<String,String>> data = new ArrayList<>();

        for(Player player : players) {
            HashMap<String, String> map = new HashMap<>();
            map.put("name", player.getName());
            map.put("pointsLeft", String.valueOf(player.getPointsLeft()));
            map.put("dartsThrown", String.valueOf(player.getDartsThrown()));
            map.put("checkoutPercentage", String.valueOf(player.getCheckOutPercentage()));
            map.put("average", String.valueOf(player.getAverage()));
            map.put("lastThrow", String.valueOf(player.getLastThrow()));
            map.put("wonLegs", String.valueOf(player.getWonLegs()));
            map.put("wonSets", String.valueOf(player.getWonSets()));
            map.put("turn", String.valueOf(getCurrentTurn().equals(player)));
            data.add(map);
        }

        return data;
    }

    public HashMap<String, String> getGameConfig() {
        HashMap<String, String> config = new HashMap<>();

        config.put("mode", gameMode.toString());
        config.put("type", gameType.toString());
        config.put("startingPoints", String.valueOf(startingPoints));
        config.put("size", String.valueOf(size));
        config.put("description", getDescription());

        return config;
    }
}