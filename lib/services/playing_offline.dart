import 'package:dart_counter/artefacts/Snapshot.dart';
import 'package:dart_counter/model/game/Game.dart';
import 'package:dart_counter/model/game/GameConfig.dart';
import 'package:dart_counter/model/game/Player.dart';
import 'package:dart_counter/model/game/Throw.dart';

class PlayingOfflineService {

  final Game _game = new Game();

  void createGame() {
    _game.init();
  }

  void toggleMode() {
    if (_game.config.mode == GameMode.FIRST_TO) {
      _game.config.mode = GameMode.BEST_OF;
    } else {
      _game.config.mode = GameMode.FIRST_TO;
    }
  }

  void setSize(int size) {
    _game.config.size = size;
  }

  void toggleType() {
    if (_game.config.type == GameType.LEGS) {
      _game.config.type = GameType.SETS;
    } else {
      _game.config.type = GameType.LEGS;
    }
  }

  void setStartingPoints(int startingPoints) {
    _game.config.startingPoints = startingPoints;
  }

  bool addPlayer(Player player) {
    return _game.addPlayer(player);
  }

  void removePlayer(int index) {
    _game.removePlayer(index);
  }

  bool addDartBot() {
    return _game.addDartBot();
  }

  void removeDartBot() {
    _game.removeDartBot();
  }

  void startGame() {
    _game.start();
  }

  void performThrow(Throw t) {
    _game.performThrow(t);
  }

  void undoThrow() {
    _game.undoThrow();
  }


  Snapshot get snapshot {
    return _game.snapshot;
  }

}



