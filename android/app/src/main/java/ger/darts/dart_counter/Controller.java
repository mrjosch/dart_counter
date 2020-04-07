package ger.darts.dart_counter;

import java.util.ArrayList;
import java.util.HashMap;

import ger.darts.dart_counter.model.Game;
import ger.darts.dart_counter.model.commons.GameMode;
import ger.darts.dart_counter.model.commons.GameType;

public class Controller {

    public static Game game;

    public static String route;

    public static void createGame(HashMap<String, String> config, ArrayList<String> players) {
        GameMode mode = GameMode.valueOf(config.get("mode"));
        GameType type = GameType.valueOf(config.get("type"));
        int startingPoints = Integer.valueOf(config.get("startingPoints"));
        int size = Integer.valueOf(config.get("size"));

        game = new Game();
        game.setGameMode(mode);
        game.setGameType(type);
        game.setStartingPoints(startingPoints);
        game.setSize(size);

        for(String name : players) {
            game.addPlayer(name);
        }
        game.start();
    }
}
