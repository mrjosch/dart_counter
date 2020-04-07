import 'package:dart_counter/model/game/Player.dart';

class DartBot extends Player {
  int targetAverage;

  DartBot(this.targetAverage) : super("Dartbot");
}
