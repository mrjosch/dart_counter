import 'dart:ui';

import 'package:dart_counter/artefacts/Snapshot.dart';
import 'package:dart_counter/library/Finishes.dart';
import 'package:dart_counter/library/ThrowValidator.dart';
import 'package:dart_counter/model/game/Player.dart';
import 'package:dart_counter/model/game/Throw.dart';
import 'package:dart_counter/services/playing_offline.dart';
import 'package:dart_counter/services/playing_online.dart';
import 'package:dart_counter/view/android/home/double_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors, Icons, RawMaterialButton; // TODO ios style


/// Widget tree
class InGameWidget extends StatefulWidget {

  final Snapshot snapshot;
  final bool online;

  InGameWidget(this.snapshot, this.online);

  @override
  _InGameWidgetState createState() => _InGameWidgetState();

}

class _InGameWidgetState extends State<InGameWidget> {

  String inputPoints = '0';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.snapshot.description),
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 3,
              child: OutputArea(widget.snapshot.players),
            ),
            Expanded(
              flex: 5,
              child: InputArea(this),
            )
          ],
        ),
      ),
    );
  }

  void onKey(String keyType) {
    switch (keyType) {
      case 'check':
        if (ThrowValidator.isValidFinish(widget.snapshot.currentTurn.pointsLeft)) {
          setState(() {
            inputPoints = widget.snapshot.currentTurn.pointsLeft.toString();
          });
          onCommit();
        }
        break;
      case 'delete':
        if (inputPoints.length == 1) {
          setState(() {
            inputPoints = '0';
          });
        } else {
          setState(() {
            inputPoints = inputPoints.substring(0, inputPoints.length - 1);
          });
        }
        break;
      default:
        String p;
        if (inputPoints == '0') {
          p = keyType;
        } else {
          p = inputPoints + keyType;
        }
        int pointsScored = int.parse(p);

        if (ThrowValidator.isValidThrow(pointsScored, widget.snapshot.currentTurn.pointsLeft)) {
          setState(() {
            inputPoints = p;
          });
        }
        break;
    }
  }

  void onCommit() {
    int points = int.parse(inputPoints);
    Throw t;

    if (widget.snapshot.currentTurn.pointsLeft <= 170) {
      if (ThrowValidator.isValidFinish(points)) {
        if (points == widget.snapshot.currentTurn.pointsLeft && ThrowValidator.isThreeDartFinish(points)) {
          t = new Throw(points, 1, 3);
          performThrow(t);
        } else if (widget.snapshot.currentTurn.pointsLeft - points >= 50) {
          t = new Throw(points, 0, 3);
          performThrow(t);
        } else {
          showDoubleDialog(points, context).then((String s) {
            int dartsOnDouble = int.parse(s.split(' ')[0]);
            int dartsThrown = int.parse(s.split(' ')[1]);
            t = new Throw(points, dartsOnDouble, dartsThrown);
            performThrow(t);
          });
        }
      } else if (points == 0) {
        showDoubleDialog(points, context).then((String s) {
          int dartsOnDouble = int.parse(s.split(' ')[0]);
          int dartsThrown = int.parse(s.split(' ')[1]);
          t = new Throw(points, dartsOnDouble, dartsThrown);
          performThrow(t);
        });
      }
    } else {
      t = new Throw(points, 0, 3);
      performThrow(t);
    }

    inputPoints = '0';
  }

  void onUndo() {
    setState(() {
      if(widget.online) {
        PlayingOnlineService().undoThrow();
      } else {
        PlayingOfflineService().undoThrow();
      }

    });
  }

  void performThrow(Throw t) {
    setState(() {
      if(widget.online) {
        PlayingOnlineService().performThrow(t);
      } else {
        PlayingOfflineService().performThrow(t);
      }
    });
  }

  Future<String> showDoubleDialog(int pointsScored, BuildContext context) async {
    String value = await Navigator.push(context, CupertinoPageRoute(builder: (context) => DoubleDialog(pointsScored, widget.snapshot.currentTurn.pointsLeft)));
    return value;
  }
}

class OutputArea extends StatelessWidget {

  final List players;

  OutputArea(this.players);

  @override
  Widget build(BuildContext context) {
    if (players.length == 1) {
      return onePlayerWidgets(players);
    } else if (players.length == 2) {
      return twoPlayerWidgets(players);
    } else if (players.length == 3) {
      return threePlayerWidgets(players);
    } else if (players.length == 4) {
      return fourPlayerWidgets(players);
    }
    return null;
  }

  /// methods to build the widgets of the ios view
  Widget onePlayerWidgets(List players) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
      child: Row(
        children: <Widget>[
          Spacer(),
          playerWidget1(players[0]),
          Spacer()
        ],
      ),
    );
  }

  Widget playerWidget1(Player player) {
    final TextStyle small = TextStyle(fontSize: 13, fontWeight: FontWeight.bold);
    final TextStyle medium = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    final TextStyle big = TextStyle(fontSize: 70, fontWeight: FontWeight.bold);

    return PlayerWidget(player, small, medium, big);
  }

  Widget twoPlayerWidgets(List players) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
      child: Row(
        children: <Widget>[
          playerWidget2(players[0]),
          playerWidget2(players[1])
        ],
      ),
    );
  }

  Widget playerWidget2(Player player) {
    final TextStyle small = TextStyle(fontSize: 13, fontWeight: FontWeight.bold);
    final TextStyle medium = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    final TextStyle big = TextStyle(fontSize: 70, fontWeight: FontWeight.bold);

    return PlayerWidget(player, small, medium, big);
  }

  Widget threePlayerWidgets(List players) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
      child: Row(
        children: <Widget>[
          playerWidget3(players[0]),
          playerWidget3(players[1]),
          playerWidget3(players[2])
        ],
      ),
    );
  }

  Widget playerWidget3(Player player) {
    final TextStyle small = TextStyle(fontSize: 8, fontWeight: FontWeight.bold);
    final TextStyle medium = TextStyle(fontSize: 11, fontWeight: FontWeight.bold);
    final TextStyle big = TextStyle(fontSize: 50, fontWeight: FontWeight.bold);

    return PlayerWidget(player, small, medium, big);
  }

  Widget fourPlayerWidgets(List players) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                playerWidget4(players[0]),
                playerWidget4(players[1]),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                playerWidget4(players[2]),
                playerWidget4(players[3]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget playerWidget4(Player player) {
    final TextStyle small = TextStyle(fontSize: 6, fontWeight: FontWeight.bold);
    final TextStyle medium = TextStyle(fontSize: 11, fontWeight: FontWeight.bold);
    final TextStyle big = TextStyle(fontSize: 40, fontWeight: FontWeight.bold);

    return PlayerWidget(player, small, medium, big);
  }
}

class InputArea extends StatelessWidget {

  final _InGameWidgetState state;

  InputArea(this.state);

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        children: <Widget>[
          Flexible(
            child: Row(
              children: <Widget>[
                buttonWithIcon(Icons.undo, () => state.onUndo(), Colors.red[400], Colors.red[500]),
                Expanded(
                    child: Center(
                        child: Text(state.inputPoints,
                            style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold))
                    )
                ),
                buttonWithIcon(Icons.keyboard_arrow_right, () => state.onCommit(), Colors.green[400], Colors.green[500]),
              ],
            ),
          ),
          buttonRow(button('1', () => state.onKey('1')), button('2', () => state.onKey('2')), button('3', () => state.onKey('3'))),
          buttonRow(button('4', () => state.onKey('4')), button('5', () => state.onKey('5')), button('6', () => state.onKey('6'))),
          buttonRow(button('7', () => state.onKey('7')), button('8', () => state.onKey('8')), button('9', () => state.onKey('9'))),
          buttonRow(button('Check', () => state.onKey('check')), button('0', () => state.onKey('0')), buttonWithIcon(Icons.chevron_left, () => state.onKey('delete')),
          ),
        ],
      ),
    );
  }

  Widget buttonRow(btn1,btn2,btn3) {
    return new Flexible(child: Row(
      children: <Widget>[
        btn1,
        btn2,
        btn3
      ],
    ));
  }

  Widget button(String text, Function onPressed) {
    return Button(Center(child: Text(text, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold))), onPressed);
  }

  Widget buttonWithIcon(IconData icon, Function onPressed, [fillColor, splashColor]) {
    return Button(Center(child: Icon(icon, color: Colors.black)), onPressed, fillColor, splashColor);
  }

}

/// Header widgets containing basic style of buttons and playerWidgets
class Button extends StatelessWidget {

  final Widget child;
  final Function onPressed;
  final fillColor;
  final splashColor;

  Button(this.child, this.onPressed, [this.fillColor, this.splashColor]);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: RawMaterialButton(
          fillColor: fillColor == null ? Colors.grey[400] : fillColor,
          splashColor: splashColor == null ? Colors.grey[500] : splashColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          child: child,
          onPressed: onPressed
      ),
    );
  }
}

class PlayerWidget extends StatelessWidget {

  final Player player;

  final TextStyle small;
  final TextStyle medium;
  final TextStyle big;

  PlayerWidget(this.player, this.small, this.medium, this.big);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 2,
      child: Container(
        color: player.isNext ? Colors.grey[500] : Colors.grey[300],
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Flexible(
              child: Center(
                child: Text(player.name, style: medium),
              ),
            ),
            Flexible(
              child: Center(
                child: Text(player.lastThrow == -1 ? '-' : player.lastThrow.toString(), style: small),
              ),
            ),
            Flexible(
              flex: 4,
              child: Center(
                  child: Text(player.pointsLeft.toString(), style: big)
              ),
            ),
            Visibility(
              child: Flexible(
                child: Center(
                  child: Text(Finishes.getStringRepresentation(player.pointsLeft), style: small),
                ),
              ),
              visible: ThrowValidator.isValidFinish(player.pointsLeft),
            ),
            Flexible(
              child: Row(
                children: <Widget>[
                  miniBox(player.average),
                  miniBox(player.checkoutPercentage + ' %')
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Flexible(
              child: Row(
                children: <Widget>[
                  miniBox('Sets: ' + player.sets.toString()),
                  miniBox('Legs: ' + player.legs.toString())
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget miniBox(String text) {
    return Flexible(
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: Colors.blue,
              child: Center(
                child: Text(text, style: TextStyle(fontSize: small.fontSize, fontWeight: small.fontWeight, color: Colors.white)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
