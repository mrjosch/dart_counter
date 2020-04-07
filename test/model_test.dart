import 'package:dart_counter/model/game/Game.dart';
import 'package:dart_counter/model/game/GameConfig.dart';
import 'package:dart_counter/model/game/Leg.dart';
import 'package:dart_counter/model/game/Player.dart';
import 'package:dart_counter/model/game/Set.dart';
import 'package:dart_counter/model/game/Throw.dart';
import 'package:test/test.dart';

void main() {

  group('TestEquals', () {
    test('Game', () {
      Game game = new Game();
      Game game1 = new Game();
      expect(game, game1);
    });

    test('GameConfig', () {
      GameConfig config = new GameConfig();
      GameConfig config1 = new GameConfig();
      expect(config, config1);
    });

    test('Leg', () {
      Leg leg = new Leg(0, 2, 501);
      Leg leg1 = new Leg(0, 2, 501);
      expect(leg, leg1);
    });

    test('Player', () {
      Player player = new Player();
      Player player1 = new Player();
      expect(player, isNot(player1));
    });

    test('Set', () {
      Set set = new Set(0, 7);
      Set set1 = new Set(0, 7);
      expect(set, set1);
    });

    test('Throw', () {
      Throw t = new Throw(180);
      Throw t1 = new Throw(180,0,3);
      expect(t, t1);
    });
  });

  group('TestThrow', () {
    test('TestConstruct', () {
      Throw t = new Throw(180);
      expect(t.points, 180);
      expect(t.dartsOnDouble, 0);
      expect(t.dartsThrown, 3);
      Throw t1 = new Throw(180, 0, 3);
      expect(t1.points, 180);
      expect(t1.dartsOnDouble, 0);
      expect(t1.dartsThrown, 3);
    });
  });

  group('TestPlayer', () {
    test('TestConstruct', () {
      Player p = new Player();
      expect(p.name, "");
      Player p1 = new Player("Jonas");
      expect(p1.name, "Jonas");
    });
  });

  group('TestLeg', () {
    test('TestConstruct', () {
      Leg l = new Leg(0, 2, 501);

      expect(l.startIndex, 0);
      expect(l.pointsLeft, [501, 501]);
      expect(l.dartsThrown, [0, 0]);
      expect(l.dartsOnDouble, [0, 0]);
      expect(l.throws, new List());
    });

    test('TestPerformThrow', () {
      Leg l = new Leg(0, 2, 501);
      Throw t = new Throw(180, 0, 3);
      t.playerIndex = 0;
      l.performThrow(t);

      expect(l.pointsLeft[0], 321);
      expect(l.dartsThrown[0], 3);
      expect(l.dartsOnDouble[0], 0);
      expect(l.throws[0], t);
    });

    test('TestUndoThrow', () {
      Leg l = new Leg(0, 2, 501);
      Throw t = new Throw(180, 0, 3);
      t.playerIndex = 0;
      l.performThrow(t);
      l.undoThrow();
      expect(l, new Leg(0, 2, 501));
    });

    test('TestGetWinner', () {
      Leg l = new Leg(0, 2, 501);
      expect(l.winner, -1);
      Throw t = new Throw(180, 0, 3);
      t.playerIndex = 0;
      l.performThrow(t);
      expect(l.winner, -1);
      t = new Throw(0, 0, 3);
      t.playerIndex = 1;
      l.performThrow(t);
      t = new Throw(180, 0, 3);
      t.playerIndex = 0;
      l.performThrow(t);
      t = new Throw(0, 0, 3);
      t.playerIndex = 1;
      l.performThrow(t);
      t = new Throw(141, 1, 3);
      t.playerIndex = 0;
      l.performThrow(t);
      expect(l.winner, 0);
    });

  });

  group('TestSet', () {
    test('TestConstruct', () {
      Set s = new Set(0, 3);
      expect(s.startIndex, 0);
      expect(s.legsNeededToWin, 3);

      s = new Set(1, 9);
      expect(s.startIndex, 1);
      expect(s.legsNeededToWin, 9);
    });

    test('TestGetWinner', () {
      Set s = new Set(0, 3);
      expect(s.winner, -1);
      Leg leg1 = new Leg(0, 2, 301); // LEG1
      Throw t = new Throw(180);
      t.playerIndex = 0;
      leg1.performThrow(t);
      t = new Throw(0);
      t.playerIndex = 1;
      leg1.performThrow(t);
      t = new Throw(121, 1, 3);
      t.playerIndex = 0;
      leg1.performThrow(t);
      Leg leg2 = new Leg(0, 2, 301); // LEG2
      t = new Throw(0);
      t.playerIndex = 1;
      leg2.performThrow(t);
      t = new Throw(180);
      t.playerIndex = 0;
      leg2.performThrow(t);
      t = new Throw(0);
      t.playerIndex = 1;
      leg2.performThrow(t);
      t = new Throw(121, 1, 3);
      t.playerIndex = 0;
      leg2.performThrow(t);
      Leg leg3 = new Leg(0, 2, 301); // LEG3
      t = new Throw(180);
      t.playerIndex = 0;
      leg3.performThrow(t);
      t = new Throw(0);
      t.playerIndex = 1;
      leg3.performThrow(t);
      t = new Throw(121, 1, 3);
      t.playerIndex = 0;
      leg3.performThrow(t);
      s.legs.add(leg1);
      s.legs.add(leg2);
      s.legs.add(leg3);
      expect(s.winner, 0);
    });

  });

  group('TestGame', () {
    test('TestConstruct', () {
      Game game = new Game();
      expect(game.config, new GameConfig());
      expect(game.status, GameStatus.PENDING);
      expect(game.players, new List());
      expect(game.sets, new List());
      expect(game.turnIndex, 0);
    });

    test('TestAddPlayer', () {
      Game game = new Game();
      Player p = new Player("Jonas");
      Player p1 = new Player("David");
      Player p2 = new Player("Elias");
      Player p3 = new Player("Anna");
      game.addPlayer(p);
      game.addPlayer(p1);
      game.addPlayer(p2);
      game.addPlayer(p3);
      expect(game.addPlayer(new Player()), false);
      expect(game.players.length, 4);
      expect(game.players[0], p);
      expect(game.players[1], p1);
      expect(game.players[2], p2);
      expect(game.players[3], p3);
    });

    test('TestRemovePlayer', () {
      Game game = new Game();
      Player p = new Player("Jonas");
      Player p1 = new Player("David");
      Player p2 = new Player("Elias");
      game.addPlayer(p);
      game.addPlayer(p1);
      game.addPlayer(p2);
      game.removePlayer(1);
      expect(game.players.length, 2);
      expect(game.players[0], p);
      expect(game.players[1], p2);
    });

    test('TestStart', () {
      Game game = new Game();
      game.config.startingPoints = 301;
      Player p = new Player("Jonas");
      Player p1 = new Player("David");
      Player p2 = new Player();
      Player p3 = new Player();
      game.addPlayer(p);
      game.addPlayer(p1);
      game.addPlayer(p2);
      game.addPlayer(p3);
      game.start();

      for(Player player in game.players) {
        expect(player.lastThrow, -1);
        expect(player.pointsLeft, 301);
        expect(player.dartsThrown, 0);
        expect(player.sets, -1);
        expect(player.legs, 0);
        expect(player.average, "0.00");
        expect(player.checkoutPercentage, "0.00");
      }
      expect(game.players[0].name, "Jonas");
      expect(game.players[1].name, "David");
      expect(game.players[2].name, "Player 1");
      expect(game.players[3].name, "Player 2");
      expect(game.status, GameStatus.RUNNING);
      expect(game.sets.length, 1);
      expect(game.sets[0].legs.length, 1);
    });

    test('TestPerformThrow', () {
      // FIRST THROW OF GAME
      Game game = new Game();
      Player p = new Player("Jonas");
      Player p1 = new Player("David");
      game.addPlayer(p);
      game.addPlayer(p1);
      game.start();
      expect(game.players[0].average, "0.00");
      expect(game.players[0].checkoutPercentage, "0.00");
      game.performThrow(new Throw(180, 0 ,3));
      expect(game.turnIndex, 1);
      expect(game.players[0].average, "180.00");
      expect(game.players[0].checkoutPercentage, "0.00");

      // LAST THROW OF LEG
      game = new Game();
      game.config.size = 3;
      p = new Player("Jonas");
      p1 = new Player("David");
      game.addPlayer(p);
      game.addPlayer(p1);
      game.start();
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(141, 1 ,3));
      expect(game.sets[0].legs[0].winner, 0);
      expect(game.turnIndex, 1);
      expect(game.sets[0].legs.length, 2);
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(141, 1 ,3));
      expect(game.players[0].average, "167.00");
      expect(game.players[0].checkoutPercentage, "100.00");
      expect(game.players[1].average, "0.00");
      expect(game.players[1].checkoutPercentage, "0.00");
      expect(game.turnIndex, 0);
      expect(game.sets[0].legs.length, 3);
      // LAST THROW OF SET
      game = new Game();
      game.config.type = GameType.SETS;
      game.config.size = 4;
      p = new Player("Jonas");
      p1 = new Player("David");
      game.addPlayer(p);
      game.addPlayer(p1);
      game.start();
      // LEG 1 SET 1
      expect(game.turnIndex, 0);
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(141, 1 ,3));
      expect(game.turnIndex, 1);
      // LEG 2 SET 1
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(141, 1 ,3));
      expect(game.turnIndex, 0);
      // LEG 3 SET 1
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(141, 1 ,3));
      expect(game.turnIndex, 1);
      expect(game.sets[0].legs.length, 3);
      expect(game.sets.length, 2);
      expect(game.players[0].average, "167.00");
      expect(game.players[0].checkoutPercentage, "100.00");

      // LEG 1 SET 2
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(141, 1 ,3));
      expect(game.turnIndex, 0);
      // LEG 2 SET 2
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(141, 1 ,3));
      expect(game.turnIndex, 1);
      // LEG 3 SET 2
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(141, 1 ,3));
      expect(game.turnIndex, 0);
      expect(game.sets[1].legs.length, 3);
      expect(game.sets.length, 3);
      expect(game.players[0].average, "167.00");
      expect(game.players[0].checkoutPercentage, "100.00");

      // LEG 1 SET 3
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(141, 1 ,3));
      expect(game.turnIndex, 1);
      // LEG 2 SET 3
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(141, 1 ,3));
      expect(game.turnIndex, 0);
      // LEG 3 SET 3
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(141, 1 ,3));
      expect(game.turnIndex, 1);
      expect(game.sets[2].legs.length, 3);
      expect(game.sets.length, 4);
      expect(game.players[0].average, "167.00");
      expect(game.players[0].checkoutPercentage, "100.00");

      // LAST THROW OF GAME
      game = new Game();
      p = new Player("Jonas");
      p1 = new Player("David");
      game.addPlayer(p);
      game.addPlayer(p1);
      game.start();
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(141, 1 ,3));
      expect(game.status, GameStatus.FINISHED);
      expect(game.sets[0].legs.length, 1);
      expect(game.sets.length, 1);
      expect(game.players[0].average, "167.00");
      expect(game.players[0].checkoutPercentage, "100.00");
    });

    test('TestUndoThrow', () {
      // Test UNDO no throw of game
      Game game = new Game();
      Player p = new Player("Jonas");
      Player p1 = new Player("David");
      Player p2 = new Player("Elias");
      game.addPlayer(p);
      game.addPlayer(p1);
      game.addPlayer(p2);
      game.start();
      game.undoThrow();
      Game testGame = new Game();
      testGame.addPlayer(p);
      testGame.addPlayer(p1);
      testGame.addPlayer(p2);
      testGame.start();
      expect(game, testGame);

      // TEST UNDO first throw of game
      game = new Game();
      p = new Player("Jonas");
      p1 = new Player("David");
      p2 = new Player("Elias");
      game.addPlayer(p);
      game.addPlayer(p1);
      game.addPlayer(p2);
      game.start();
      game.performThrow(new Throw(180));
      game.undoThrow();
      testGame = new Game();
      testGame.addPlayer(p);
      testGame.addPlayer(p1);
      testGame.addPlayer(p2);
      testGame.start();
      expect(game, testGame);

      // TEST UNDO last throw of set
      game = new Game();
      game.config.size = 2;
      game.config.type = GameType.SETS;
      p = new Player("Jonas");
      p1 = new Player("David");
      p2 = new Player("Elias");
      game.addPlayer(p);
      game.addPlayer(p1);
      game.addPlayer(p2);
      game.start();
      game.performThrow(new Throw(180));
      game.performThrow(new Throw(0));
      game.performThrow(new Throw(180));
      game.performThrow(new Throw(0));
      game.performThrow(new Throw(141,1,3));

      game.performThrow(new Throw(0));
      game.performThrow(new Throw(180));
      game.performThrow(new Throw(0));
      game.performThrow(new Throw(180));
      game.performThrow(new Throw(0));
      game.performThrow(new Throw(141,1,3));

      game.performThrow(new Throw(180));
      game.performThrow(new Throw(0));
      game.performThrow(new Throw(180));
      game.performThrow(new Throw(0));
      game.performThrow(new Throw(141,1,3));
      game.undoThrow();

      testGame = new Game();
      testGame.config.size = 2;
      testGame.config.type = GameType.SETS;
      testGame.addPlayer(p);
      testGame.addPlayer(p1);
      testGame.addPlayer(p2);
      testGame.start();
      testGame.performThrow(new Throw(180));
      testGame.performThrow(new Throw(0));
      testGame.performThrow(new Throw(180));
      testGame.performThrow(new Throw(0));
      testGame.performThrow(new Throw(141,1,3));

      testGame.performThrow(new Throw(0));
      testGame.performThrow(new Throw(180));
      testGame.performThrow(new Throw(0));
      testGame.performThrow(new Throw(180));
      testGame.performThrow(new Throw(0));
      testGame.performThrow(new Throw(141,1,3));

      testGame.performThrow(new Throw(180));
      testGame.performThrow(new Throw(0));
      testGame.performThrow(new Throw(180));
      testGame.performThrow(new Throw(0));
      expect(game, testGame);

      // TEST UNDO last throw of leg
      game = new Game();
      game.config.size = 2;
      p = new Player("Jonas");
      p1 = new Player("David");
      p2 = new Player("Elias");
      game.addPlayer(p);
      game.addPlayer(p1);
      game.addPlayer(p2);
      game.start();
      game.performThrow(new Throw(180));
      game.performThrow(new Throw(0));
      game.performThrow(new Throw(180));
      game.performThrow(new Throw(0));
      game.performThrow(new Throw(141,1,3));
      game.undoThrow();

      testGame = new Game();
      testGame.config.size = 2;
      testGame.addPlayer(p);
      testGame.addPlayer(p1);
      testGame.addPlayer(p2);
      testGame.start();
      testGame.performThrow(new Throw(180));
      testGame.performThrow(new Throw(0));
      testGame.performThrow(new Throw(180));
      testGame.performThrow(new Throw(0));
      expect(game, testGame);

      // Tes throw in leg
      game = new Game();
      game.config.size = 2;
      p = new Player("Jonas");
      p1 = new Player("David");
      p2 = new Player("Elias");
      game.addPlayer(p);
      game.addPlayer(p1);
      game.addPlayer(p2);
      game.start();
      game.performThrow(new Throw(180));
      game.performThrow(new Throw(88));
      game.performThrow(new Throw(180));
      game.performThrow(new Throw(80));
      game.performThrow(new Throw(141,1,3));
      game.undoThrow();
      game.undoThrow();

      testGame = new Game();
      testGame.config.size = 2;
      testGame.addPlayer(p);
      testGame.addPlayer(p1);
      testGame.addPlayer(p2);
      testGame.start();
      testGame.performThrow(new Throw(180));
      testGame.performThrow(new Throw(88));
      testGame.performThrow(new Throw(180));
      expect(game, testGame);

    });

    test('TestGetWinner', () {
      // FIRST TO 1 LEG
      Game game = new Game();
      Player p = new Player("Jonas");
      Player p1 = new Player("David");
      game.addPlayer(p);
      game.addPlayer(p1);
      game.start();
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(141, 1 ,3));
      expect(game.sets[0].winner, 0);
      expect(game.players[0].legs, 1);
      expect(game.winner, game.players[0]);

      // BEST OF 3 LEGS
      game = new Game();
      game.config.size = 3;
      game.config.mode = GameMode.BEST_OF;
      p = new Player("Jonas");
      p1 = new Player("David");
      game.addPlayer(p);
      game.addPlayer(p1);
      game.start();
      // LEG 1
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(141, 1 ,3));
      // LEG 2
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(141, 1 ,3));
      // LEG 3
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(141, 1 ,3));
      expect(game.winner, game.players[0]);


      // FIRST TO 1 SET
      game = new Game();
      game.config.size = 1;
      game.config.type = GameType.SETS;
      p = new Player("Jonas");
      p1 = new Player("David");
      game.addPlayer(p);
      game.addPlayer(p1);
      game.start();
      // LEG 1 SET 1
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(141, 1 ,3));
      // LEG 2 SET 1
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(141, 1 ,3));
      // LEG 3 SET 1
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(141, 1 ,3));
      expect(game.winner, game.players[0]);


      // BEST OF 3 SETS
      game = new Game();
      game.config.size = 3;
      game.config.mode = GameMode.BEST_OF;
      game.config.type = GameType.SETS;
      p = new Player("Jonas");
      p1 = new Player("David");
      game.addPlayer(p);
      game.addPlayer(p1);
      game.start();
      // LEG 1 SET 1
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(141, 1 ,3));
      // LEG 2 SET 1
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(141, 1 ,3));
      // LEG 3 SET 1
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(141, 1 ,3));
      // LEG 1 SET 2
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(141, 1 ,3));
      // LEG 2 SET 2
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(141, 1 ,3));
      // LEG 3 SET 2
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(180, 0 ,3));
      game.performThrow(new Throw(0, 0 ,3));
      game.performThrow(new Throw(141, 1 ,3));
      expect(game.winner, game.players[0]);
    });

    test('TestRealGame', () {
      // BEST OF 5 LEGS
      Game game = new Game();
      game.config.mode = GameMode.BEST_OF;
      game.config.type = GameType.LEGS;
      game.config.size = 5;
      Player p = new Player("Elias");
      Player p1 = new Player("David");
      game.addPlayer(p);
      game.addPlayer(p1);
      game.start();
      game.performThrow(new Throw(9));
      game.performThrow(new Throw(92));
      game.performThrow(new Throw(64));
      game.performThrow(new Throw(73));
      game.performThrow(new Throw(41));
      game.performThrow(new Throw(50));
      game.performThrow(new Throw(26));
      game.performThrow(new Throw(40));
      game.performThrow(new Throw(39));
      game.performThrow(new Throw(115));
      game.performThrow(new Throw(61));
      game.performThrow(new Throw(32));
      game.performThrow(new Throw(30));
      game.performThrow(new Throw(79,1,3));
      game.performThrow(new Throw(26));
      game.performThrow(new Throw(20,1,1));
      // 2nd Leg
      game.performThrow(new Throw(47));
      game.performThrow(new Throw(60));
      game.performThrow(new Throw(60));
      game.performThrow(new Throw(43));
      game.performThrow(new Throw(39));
      game.performThrow(new Throw(33));
      game.performThrow(new Throw(44));
      game.performThrow(new Throw(49));
      game.performThrow(new Throw(35));
      game.performThrow(new Throw(18));
      game.performThrow(new Throw(24));
      game.performThrow(new Throw(26));
      game.performThrow(new Throw(61));
      game.performThrow(new Throw(125));
      game.performThrow(new Throw(41));
      game.performThrow(new Throw(42));
      game.performThrow(new Throw(52));
      game.performThrow(new Throw(30));
      game.performThrow(new Throw(43));
      game.performThrow(new Throw(24));
      game.performThrow(new Throw(19,1,3));
      game.performThrow(new Throw(25,1,3));
      game.performThrow(new Throw(11,3,3));
      game.performThrow(new Throw(0,0,3));
      game.performThrow(new Throw(0,0,3));
      game.performThrow(new Throw(26,3,3));
      // 3rd Leg
      game.performThrow(new Throw(19));
      game.performThrow(new Throw(30));
      game.performThrow(new Throw(14));
      game.performThrow(new Throw(13));
      game.performThrow(new Throw(42));
      game.performThrow(new Throw(45));
      game.performThrow(new Throw(45));
      game.performThrow(new Throw(6));
      game.performThrow(new Throw(22));
      game.performThrow(new Throw(37));
      game.performThrow(new Throw(50));
      game.performThrow(new Throw(7));
      game.performThrow(new Throw(45));
      game.performThrow(new Throw(100));
      game.performThrow(new Throw(2));
      game.performThrow(new Throw(58));
      game.performThrow(new Throw(40));
      game.performThrow(new Throw(50));
      game.performThrow(new Throw(45));
      game.performThrow(new Throw(51));
      game.performThrow(new Throw(52));
      game.performThrow(new Throw(34));
      game.performThrow(new Throw(60));
      game.performThrow(new Throw(45));
      game.performThrow(new Throw(26,1,3));
      game.performThrow(new Throw(0));
      game.performThrow(new Throw(23,2,3));
      game.performThrow(new Throw(5,2,3));
      game.performThrow(new Throw(16,1,1));
      // 4th leg
      game.performThrow(new Throw(87));
      game.performThrow(new Throw(52));
      game.performThrow(new Throw(15));
      game.performThrow(new Throw(55));
      game.performThrow(new Throw(55));
      game.performThrow(new Throw(22));
      game.performThrow(new Throw(25));
      game.performThrow(new Throw(41));
      game.performThrow(new Throw(28));
      game.performThrow(new Throw(22));
      game.performThrow(new Throw(44));
      game.performThrow(new Throw(25));
      game.performThrow(new Throw(35));
      game.performThrow(new Throw(26));
      game.performThrow(new Throw(15));
      game.performThrow(new Throw(85));
      game.performThrow(new Throw(25));
      game.performThrow(new Throw(72));
      game.performThrow(new Throw(41));
      game.performThrow(new Throw(9));
      game.performThrow(new Throw(41));
      game.performThrow(new Throw(60,1,3));
      game.performThrow(new Throw(23));
      game.performThrow(new Throw(16,3,3));
      game.performThrow(new Throw(39,1,3));
      game.performThrow(new Throw(0,3,3));
      game.performThrow(new Throw(28,2,2));
      // 5th Leg
      game.performThrow(new Throw(60));
      game.performThrow(new Throw(22));
      game.performThrow(new Throw(81));
      game.performThrow(new Throw(62));
      game.performThrow(new Throw(44));
      game.performThrow(new Throw(26));
      game.performThrow(new Throw(60));
      game.performThrow(new Throw(30));
      game.performThrow(new Throw(60));
      game.performThrow(new Throw(44));
      game.performThrow(new Throw(44));
      game.performThrow(new Throw(9));
      game.performThrow(new Throw(42));
      game.performThrow(new Throw(52));
      game.performThrow(new Throw(15));
      game.performThrow(new Throw(68));
      game.performThrow(new Throw(51));
      game.performThrow(new Throw(15));
      game.performThrow(new Throw(28,1,3));
      game.performThrow(new Throw(70));
      game.performThrow(new Throw(16,2,2));
      expect(game.winner, p);

      print(p.average);
      print(p1.average);
      print(p.checkoutPercentage);
      print(p1.checkoutPercentage);


    });
  });
}
