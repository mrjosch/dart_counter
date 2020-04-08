

import 'package:dart_counter/library/BotGenerator.dart';
import 'package:dart_counter/library/ThrowValidator.dart';
import 'package:dart_counter/model/GameConfig.dart';
import 'package:dart_counter/model/Leg.dart';
import 'package:dart_counter/model/Player.dart';
import 'package:dart_counter/model/Set.dart';
import 'package:dart_counter/model/Throw.dart';
import 'package:dart_counter/networking/artefacts/Snapshot.dart';
import 'package:flutter/foundation.dart';

import 'DartBot.dart';

enum GameStatus { PENDING, RUNNING, FINISHED }

class Game {

  GameConfig config;
  GameStatus status;

  List players;
  List sets;

  int turnIndex;

  Game() {
    init();
  }

  void init() {
    this.config = new GameConfig();
    this.status = GameStatus.PENDING;
    this.players = new List();
    this.sets = new List();
    this.turnIndex = 0;
    addPlayer(new Player());
  }

  Snapshot get snapshot {
    switch(status) {
      case GameStatus.PENDING:
        return Snapshot(config, description, 'PENDING', players, null);
      case GameStatus.RUNNING:
        return Snapshot(null, description, 'RUNNING', players, null);
      case GameStatus.FINISHED:
        return Snapshot(null, description, 'FINISHED', players, sets);
    }
    return null;
}

  Game.fromJson(Map<String, dynamic> json) {
    config = json['config'] != null ? GameConfig.fromJson(json['config']) : null;
    status = _statusFromString(json['status']);
    players = json['players'] != null ? json['players'].map((value) => Player.fromJson(value)).toList() : null;
  }

  GameStatus _statusFromString(String json) {
    switch(json) {
      case 'PENDING':
        return GameStatus.PENDING;
      case 'RUNNING':
        return GameStatus.RUNNING;
      case 'FINISHED':
        return GameStatus.FINISHED;
      default:
        return null;
    }
  }

  Map<String, dynamic> toJson() => {
    'config': config,
    'status': status.toString().replaceAll('GameStatus.', ''),
    'players': players
  };

  bool addPlayer(Player player) {
    if (players.length < 4) {
      players.add(player);
      return true;
    }
    return false;
  }

  void removePlayer(int index) {
    players.removeAt(index);
  }

  bool addDartBot() {
    if (dartBotIndex == -1) {
      players.add(new DartBot(20));
      return true;
    }
    return false;
  }

  void removeDartBot() {
    if (dartBotIndex != -1) {
      this.players.removeAt(dartBotIndex);
    }
  }

  void start() {
    _createSet();
    _createLeg();
    _initPlayers();
    status = GameStatus.RUNNING;
  }

  bool performThrow(Throw t) {
    if (true) {
      // TODO THROW VALIDATION
      _currentTurn.isNext = false;

      // sets the player who threw
      t.playerIndex = turnIndex;

      // updates the leg data
      _currentLeg.performThrow(t);

      // updates the player data
      _currentTurn.lastThrow = t.points;
      _currentTurn.pointsLeft -= t.points;
      _currentTurn.dartsThrown += t.dartsThrown;
      _currentTurn.average = this._averageCurrentTurn;
      _currentTurn.checkoutPercentage = this._checkoutPercentageCurrentTurn;

      // updates the reference to the Player who has next turn
      // updates the player data and creates next leg and set when needed
      if (_currentLeg.winner != -1) {
        if (_currentSet.winner != -1) {
          int sets = -1;
          if (this.config.type == GameType.SETS) {
            sets = _currentTurn.sets + 1;
          }
          int legs;
          if (this.config.type == GameType.LEGS) {
            legs = _currentTurn.legs + 1;
          } else {
            legs = 0;
          }

          _currentTurn.pointsLeft = 0;
          _currentTurn.sets = sets;
          _currentTurn.legs = legs;
          if (this.winner != null) {
            // GAME FINISHED
            this.status = GameStatus.FINISHED;
          } else {
            // CONTINUE NEW SET
            for (int i = 0; i < this.players.length; i++) {
              Player player = players[i];
              player.pointsLeft = this.config.startingPoints;
              player.dartsThrown = 0;
              player.legs = 0;
            }
            this.turnIndex = (_currentSet.startIndex + 1) % this.players.length;
            _createSet();
            _createLeg();
          }
        } else {
          // CONTINUE NEW LEG
          for (int i = 0; i < this.players.length; i++) {
            Player player = players[i];
            int legs = player.legs;
            if (i == this.turnIndex) {
              legs += 1;
            }
            player.pointsLeft = this.config.startingPoints;
            player.dartsThrown = 0;
            player.legs = legs;
          }
          this.turnIndex = (_currentLeg.startIndex + 1) % this.players.length;
          _createLeg();
        }
      } else {
        // CONTINUE
        this.turnIndex = (this.turnIndex + 1) % this.players.length;
      }

      _currentTurn.isNext = true;

      if (_currentTurn is DartBot && _currentLeg.winner == -1) {
        performDartBotThrow();
      }
      return true;
    }
    return false;
  }

  // TODO test
  void performDartBotThrow() {
    int randomScore = BotGenerator.getScore(_currentTurn as DartBot);
    Throw t;

    if (randomScore == _currentTurn.pointsLeft) {
      if (ThrowValidator.isOneDartFinish(randomScore)) {
        t = new Throw(randomScore, 1, 1);
      } else if (ThrowValidator.isThreeDartFinish(randomScore)) {
        t = new Throw(randomScore, 1, 3);
      } else {
        t = new Throw(randomScore, 1, 2);
      }
    } else {
      t = new Throw(randomScore);
    }
    performThrow(t);
  }

  void undoThrow() {
    if (sets.length == 1 &&
        sets[0].legs.length == 1 &&
        _currentLeg.throws.length == 0) {
      // NO THROW PERFORMED YET -> do nothing
      return;
    }

    _currentTurn.isNext = false;

    if (sets.length == 1 &&
        sets[0].legs.length == 1 &&
        _currentLeg.throws.length == 1) {
      // UNDO FIRST THROW OF GAME
      Throw last = _currentLeg.undoThrow();
      this.turnIndex = last.playerIndex;
      _currentTurn.lastThrow = -1;
      _currentTurn.pointsLeft = this.config.startingPoints;
      _currentTurn.dartsThrown = 0;
      _currentTurn.average = "0.00";
      _currentTurn.checkoutPercentage = "0.00";
    } else if (this.sets.length >= 2 &&
        _currentSet.legs.length == 1 &&
        _currentLeg.throws.length == 0) {
      // UNDO LAST THROW OF SET
      this.sets.removeLast();
      Throw last = _currentLeg.undoThrow();
      this.turnIndex = last.playerIndex;

      // restore player data
      for (int i = 0; i < this.players.length; i++) {
        Player player = this.players[i];

        if (this.turnIndex == i) {
          player.lastThrow = _currentLeg
              .throws[_currentLeg.throws.length - this.players.length].points;
          player.average = _averageCurrentTurn;
          player.checkoutPercentage = _checkoutPercentageCurrentTurn;
        }

        player.pointsLeft = _currentLeg.pointsLeft[i];
        player.dartsThrown = _currentLeg.dartsThrown[i];

        int s = 0;
        int l = 0;
        for (Set set in this.sets) {
          if (this.config.type == GameType.SETS) {
            if (set.winner == i) {
              s += 1;
            }
          } else {
            s = -1;
          }
        }

        for (Leg leg in _currentSet.legs) {
          if (leg.winner == i) {
            l += 1;
          }
        }

        player.sets = s;
        player.legs = l;
      }
    } else if (_currentSet.legs.length >= 2 && _currentLeg.throws.length == 0) {
      // UNDO LAST THROW OF LEG
      _currentSet.legs.removeLast();
      Throw last = _currentLeg.undoThrow();
      this.turnIndex = last.playerIndex;

      // restore player data
      for (int i = 0; i < this.players.length; i++) {
        Player player = this.players[i];

        if (this.turnIndex == i) {
          player.lastThrow = _currentLeg
              .throws[_currentLeg.throws.length - this.players.length].points;
          player.average = _averageCurrentTurn;
          player.checkoutPercentage = _checkoutPercentageCurrentTurn;
        }

        player.pointsLeft = _currentLeg.pointsLeft[i];
        player.dartsThrown = _currentLeg.dartsThrown[i];

        int l = 0;
        for (Leg leg in _currentSet.legs) {
          if (leg.winner == i) {
            l += 1;
          }
        }

        player.legs = l;
      }
    } else {
      // UNDO STANDARD THROW
      Throw last = _currentLeg.undoThrow();
      this.turnIndex = last.playerIndex;
      _currentTurn.lastThrow = _currentLeg
          .throws[_currentLeg.throws.length - this.players.length].points;
      _currentTurn.pointsLeft += last.points;
      _currentTurn.dartsThrown -= last.dartsThrown;
    }

    _currentTurn.isNext = true;
    _currentTurn.average = _averageCurrentTurn;
    _currentTurn.checkoutPercentage = _checkoutPercentageCurrentTurn;
  }

  String get description {
    return config.mode
            .toString()
            .replaceAll("GameMode.", " ")
            .replaceAll("_", " ") +
        " " +
        config.size.toString() +
        " " +
        config.type.toString().replaceAll("GameType.", " ");
  }

  Set get _currentSet {
    return this.sets.last;
  }

  Leg get _currentLeg {
    return this._currentSet.legs.last;
  }

  Player get _currentTurn {
    return this.players[turnIndex];
  }

  String get _averageCurrentTurn {
    int totalDartsThrown = 0;
    int totalPointsScored = 0;
    for (Set set in this.sets) {
      for (Leg leg in set.legs) {
        totalDartsThrown += leg.dartsThrown[turnIndex];
        totalPointsScored +=
            (this.config.startingPoints - leg.pointsLeft[turnIndex]);
      }
    }
    if (totalDartsThrown == 0) {
      return "0.00";
    }
    return ((3 * totalPointsScored) / totalDartsThrown).toStringAsFixed(2);
  }

  String get _checkoutPercentageCurrentTurn {
    int totalLegsWon = 0;
    int totalDartsOnDouble = 0;
    for (Set set in this.sets) {
      for (Leg leg in set.legs) {
        if (leg.winner == this.turnIndex) {
          totalLegsWon += 1;
        }
        totalDartsOnDouble += leg.dartsOnDouble[turnIndex];
      }
    }

    if (totalDartsOnDouble == 0) {
      return "0.00";
    }
    return ((totalLegsWon / totalDartsOnDouble) * 100).toStringAsFixed(2);
  }

  int get dartBotIndex {
    for (int i = 0; i < this.players.length; i++) {
      Player player = this.players[i];
      if (player is DartBot) {
        return i;
      }
    }
    return -1;
  }

  Player get winner {
    switch (this.config.type) {
      case GameType.LEGS:
        int legsNeededToWin;
        switch (this.config.mode) {
          case GameMode.FIRST_TO:
            legsNeededToWin = this.config.size;
            for (Player player in this.players) {
              if (player.legs == legsNeededToWin) {
                return player;
              }
            }
            break;
          case GameMode.BEST_OF:
            legsNeededToWin = (this.config.size / 2).round();
            for (Player player in this.players) {
              if (player.legs == legsNeededToWin) {
                return player;
              }
            }
            break;
        }
        break;
      case GameType.SETS:
        int setsNeededToWin;
        switch (this.config.mode) {
          case GameMode.FIRST_TO:
            setsNeededToWin = this.config.size;
            for (Player player in this.players) {
              if (player.sets == setsNeededToWin) {
                return player;
              }
            }
            break;
          case GameMode.BEST_OF:
            setsNeededToWin = (this.config.size / 2).round();
            for (Player player in this.players) {
              if (player.sets == setsNeededToWin) {
                return player;
              }
            }
            break;
        }
        break;
    }
    return null;
  }

  void _createSet() {
    if (this.config.mode == GameMode.FIRST_TO) {
      if (this.config.type == GameType.LEGS) {
        this.sets.add(new Set(turnIndex, this.config.size));
      } else {
        this.sets.add(new Set(turnIndex, 3));
      }
    } else {
      if (config.type == GameType.LEGS) {
        this.sets.add(new Set(turnIndex, (this.config.size / 2).round()));
      } else {
        this.sets.add(new Set(turnIndex, 3));
      }
    }
  }

  void _createLeg() {
    this._currentSet.legs.add(new Leg(
        this.turnIndex, this.players.length, this.config.startingPoints));
  }

  void _initPlayers() {
    int index = 1;
    for (Player player in this.players) {
      if (player.name == "") {
        player.name = "Player ${index}";
        index++;
      }
      player.isNext = false;
      player.lastThrow = -1;
      player.pointsLeft = this.config.startingPoints;
      player.dartsThrown = 0;
      if (this.config.type == GameType.SETS) {
        player.sets = 0;
      } else {
        player.sets = -1;
      }
      player.legs = 0;
      player.average = "0.00";
      player.checkoutPercentage = "0.00";
    }
    this.players[turnIndex].isNext = true;
  }

  @override
  String toString() {
    return 'Game{config: $config, status: $status, players: $players, sets: $sets, turnIndex: $turnIndex}';
  }

  @override
  bool operator ==(other) {
    Game o = other as Game;
    return this.config == o.config &&
        listEquals(this.players, o.players) &&
        listEquals(this.sets, o.sets) &&
        this.turnIndex == o.turnIndex;
  }
}
