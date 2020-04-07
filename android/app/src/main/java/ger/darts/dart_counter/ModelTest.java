package ger.darts.dart_counter;

import junit.framework.TestCase;

import org.junit.Test;

import java.util.Stack;

import ger.darts.dart_counter.model.Game;
import ger.darts.dart_counter.model.Player;
import ger.darts.dart_counter.model.Throw;
import ger.darts.dart_counter.model.commons.GameMode;
import ger.darts.dart_counter.model.commons.GameType;

public class ModelTest extends TestCase {


    public Game createGame(GameMode mode, GameType type, int size, int startingPoints, int playerAmount) {
        Game game = new Game();

        game.setGameMode(mode);
        game.setGameType(type);
        game.setStartingPoints(startingPoints);
        game.setSize(size);

        for (int i = 1; i <= playerAmount ; i++) {
            game.addPlayer("Player " + i);
        }

        game.start();
        return game;
    }

    /**
     * Tests some basic game init
     */

    @Test
    public void testGameInit() {
        Game game = createGame(GameMode.FIRST_TO, GameType.LEGS, 1, 301, 1);
        assertEquals(GameMode.FIRST_TO, game.getGameMode());
        assertEquals(GameType.LEGS, game.getGameType());
        assertEquals(1, game.getSize());
        assertEquals(301, game.getStartingPoints());
        assertEquals(1, game.getPlayers().size());
        assertTrue(game.getCurrentTurn().getName().equals("Player 1"));

        game = createGame(GameMode.BEST_OF, GameType.SETS, 99, 501, 4);
        assertEquals(GameMode.BEST_OF, game.getGameMode());
        assertEquals(GameType.SETS, game.getGameType());
        assertEquals(99, game.getSize());
        assertEquals(501, game.getStartingPoints());
        assertEquals(4, game.getPlayers().size());
        assertTrue(game.getCurrentTurn().getName().equals("Player 1"));

        game = createGame(GameMode.BEST_OF, GameType.LEGS, 34, 701, 2);
        assertEquals(GameMode.BEST_OF, game.getGameMode());
        assertEquals(GameType.LEGS, game.getGameType());
        assertEquals(34, game.getSize());
        assertEquals(701, game.getStartingPoints());
        assertEquals(2, game.getPlayers().size());
        assertTrue(game.getCurrentTurn().getName().equals("Player 1"));

    }


    /**
     * Test if the points get updated correctly
     */
    @Test
    public void testSingleLeg() {
        Game game = createGame(GameMode.FIRST_TO, GameType.LEGS, 3, 501, 2);
        for (int i = 0; i < 10; i++) {
            Throw t = new Throw(100, game.getCurrentTurn());
            game.prepareThrow(t);
            game.performThrow();
        }
        assertEquals(1, game.getPlayers().get(0).getPointsLeft());
        assertEquals(1, game.getPlayers().get(1).getPointsLeft());


        game = createGame(GameMode.FIRST_TO, GameType.LEGS, 3, 501, 3);
        for (int i = 0; i < 15; i++) {
            Throw t = new Throw(100, game.getCurrentTurn());
            game.prepareThrow(t);
            game.performThrow();
        }
        assertEquals(1, game.getPlayers().get(0).getPointsLeft());
        assertEquals(1, game.getPlayers().get(1).getPointsLeft());
        assertEquals(1, game.getPlayers().get(2).getPointsLeft());


        game = createGame(GameMode.FIRST_TO, GameType.LEGS, 3, 701, 3);
        for (int i = 0; i < 21; i++) {
            Throw t = new Throw(100, game.getCurrentTurn());
            game.prepareThrow(t);
            game.performThrow();
        }

        assertEquals(1, game.getPlayers().get(0).getPointsLeft());
        assertEquals(1, game.getPlayers().get(1).getPointsLeft());
        assertEquals(1, game.getPlayers().get(2).getPointsLeft());
    }


    /**
     * Test if the points sets and legs get updated correctly after performing multiple throws on a new Game
     */
    @Test
    public void testMultiLeg() {

        Game game = createGame(GameMode.FIRST_TO, GameType.LEGS, 1, 501, 2);
        for (int i = 0; i < 5; i++) {
            Throw t = new Throw(167, game.getCurrentTurn());
            game.prepareThrow(t);
            game.performThrow();
        }
        assertEquals("Player 1",game.getWinner().getName());

        game = createGame(GameMode.FIRST_TO, GameType.LEGS, 1, 501, 3);
        for (int i = 0; i < 7; i++) {
            Throw t = new Throw(167, game.getCurrentTurn());
            game.prepareThrow(t);
            game.performThrow();
        }
        assertEquals("Player 1",game.getWinner().getName());

        game = createGame(GameMode.FIRST_TO, GameType.LEGS, 2, 501, 2);
        for (int i = 0; i < 15; i++) {
            Throw t = new Throw(167, game.getCurrentTurn());
            game.prepareThrow(t);
            game.performThrow();
        }
        assertEquals("Player 1",game.getWinner().getName());

        game = createGame(GameMode.FIRST_TO, GameType.LEGS, 2, 501, 1);
        for (int i = 0; i < 6; i++) {
            Throw t = new Throw(167, game.getCurrentTurn());
            game.prepareThrow(t);
            game.performThrow();
        }
        assertEquals("Player 1",game.getWinner().getName());

        game = createGame(GameMode.BEST_OF, GameType.LEGS, 3, 501, 2);
        for (int i = 0; i < 15; i++) {
            Throw t = new Throw(167, game.getCurrentTurn());
            game.prepareThrow(t);
            game.performThrow();
        }

        assertEquals("Player 1",game.getWinner().getName());

        game = createGame(GameMode.BEST_OF, GameType.SETS, 3, 501, 2);
        for (int i = 0; i < 75; i++) {
            Throw t = new Throw(167, game.getCurrentTurn());
            game.prepareThrow(t);
            game.performThrow();
        }
        assertEquals("Player 1",game.getWinner().getName());

        game = createGame(GameMode.BEST_OF, GameType.SETS, 3, 501, 1);
        for (int i = 0; i < 18; i++) {
            Throw t = new Throw(167, game.getCurrentTurn());
            game.prepareThrow(t);
            game.performThrow();
        }
        assertEquals("Player 1",game.getWinner().getName());

    }


    /**
     * Test if the throws get saved on the history-Stack correctly
     */
    @Test
    public void testThrowHistory() {

        Game game = createGame(GameMode.FIRST_TO, GameType.LEGS, 1, 501, 2);
        Stack<Throw> history = new Stack<>();
        for (int i = 0; i < 5; i++) {
            Throw t = new Throw(i, game.getCurrentTurn());
            history.push(t);
            game.prepareThrow(t);
            game.performThrow();
        }

        assertEquals(history,game.getThrowHistory());

        game = createGame(GameMode.FIRST_TO, GameType.LEGS, 1, 501, 3);
        history = new Stack<>();
        for (int i = 0; i < 7; i++) {
            Throw t = new Throw(i, game.getCurrentTurn());
            history.push(t);
            game.prepareThrow(t);
            game.performThrow();
        }
        assertEquals(history,game.getThrowHistory());

        game = createGame(GameMode.FIRST_TO, GameType.LEGS, 2, 501, 2);
        history = new Stack<>();
        for (int i = 0; i < 15; i++) {
            Throw t = new Throw(i, game.getCurrentTurn());
            history.push(t);
            game.prepareThrow(t);
            game.performThrow();
        }
        assertEquals(history,game.getThrowHistory());

        game = createGame(GameMode.FIRST_TO, GameType.LEGS, 2, 501, 1);
        history = new Stack<>();
        for (int i = 0; i < 6; i++) {
            Throw t = new Throw(i, game.getCurrentTurn());
            history.push(t);
            game.prepareThrow(t);
            game.performThrow();
        }
        assertEquals(history,game.getThrowHistory());

        game = createGame(GameMode.BEST_OF, GameType.LEGS, 3, 501, 2);
        history = new Stack<>();
        for (int i = 0; i < 15; i++) {
            Throw t = new Throw(i, game.getCurrentTurn());
            history.push(t);
            game.prepareThrow(t);
            game.performThrow();
        }

        assertEquals(history,game.getThrowHistory());

        game = createGame(GameMode.BEST_OF, GameType.SETS, 3, 501, 2);
        history = new Stack<>();
        for (int i = 0; i < 75; i++) {
            Throw t = new Throw(i, game.getCurrentTurn());
            history.push(t);
            game.prepareThrow(t);
            game.performThrow();
        }
        assertEquals(history,game.getThrowHistory());

        game = createGame(GameMode.BEST_OF, GameType.SETS, 3, 501, 1);
        history = new Stack<>();
        for (int i = 0; i < 18; i++) {
            Throw t = new Throw(i, game.getCurrentTurn());
            history.push(t);
            game.prepareThrow(t);
            game.performThrow();
        }
        assertEquals(history,game.getThrowHistory());

    }

    @Test
    public void test1() {
        Game game = createGame(GameMode.FIRST_TO, GameType.LEGS, 2, 501, 2);
        for (int i = 0; i < 5; i++) {
            Throw t = new Throw(167, game.getCurrentTurn());
            game.prepareThrow(t);
            game.performThrow();
        }
        assertEquals("Player 2",game.getCurrentTurn().getName());
        assertEquals(1,game.getPlayers().get(0).getWonLegs());
        assertEquals(0,game.getPlayers().get(1).getWonLegs());
        assertEquals(501,game.getPlayers().get(0).getPointsLeft());
        assertEquals(501,game.getPlayers().get(1).getPointsLeft());
    }

    @Test
    public void testUndoThrow() {
        Game game = createGame(GameMode.FIRST_TO, GameType.LEGS, 2, 501, 2);
        for (int i = 0; i < 5; i++) {
            Throw t = new Throw(167, game.getCurrentTurn());
            game.prepareThrow(t);
            game.performThrow();
        }

        Player player1 = game.getPlayers().get(0);
        Player player2 = game.getPlayers().get(1);

        assertEquals("Player 2",game.getCurrentTurn().getName());
        assertEquals(501,player1.getPointsLeft());
        assertEquals(501,player2.getPointsLeft());
        assertEquals(1,player1.getWonLegs());
        assertEquals(0,player2.getWonLegs());
        assertEquals(0,player1.getDartsThrown());
        assertEquals(0,player2.getDartsThrown());

        game.undoLastThrow();

        assertEquals("Player 1",game.getCurrentTurn().getName());
        assertEquals(167,player1.getPointsLeft());
        assertEquals(167,player2.getPointsLeft());
        assertEquals(0,player1.getWonLegs());
        assertEquals(0,player2.getWonLegs());
        assertEquals(6,player1.getDartsThrown());
        assertEquals(6,player2.getDartsThrown());

        game = createGame(GameMode.FIRST_TO, GameType.SETS, 2, 501, 2);
        for (int i = 0; i < 25; i++) {
            Throw t = new Throw(167, game.getCurrentTurn());
            game.prepareThrow(t);
            game.performThrow();
        }

        player1 = game.getPlayers().get(0);
        player2 = game.getPlayers().get(1);

        assertEquals("Player 2",game.getCurrentTurn().getName());
        assertEquals(501,player1.getPointsLeft());
        assertEquals(501,player2.getPointsLeft());
        assertEquals(1,player1.getWonSets());
        assertEquals(0,player2.getWonSets());
        assertEquals(0,player1.getDartsThrown());
        assertEquals(0,player2.getDartsThrown());

        game.undoLastThrow();

        assertEquals("Player 1",game.getCurrentTurn().getName());
        assertEquals(167,player1.getPointsLeft());
        assertEquals(167,player2.getPointsLeft());
        assertEquals(0,player1.getWonSets());
        assertEquals(0,player2.getWonSets());
        assertEquals(6,player1.getDartsThrown());
        assertEquals(6,player2.getDartsThrown());

    }


}

