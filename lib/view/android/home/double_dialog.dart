import 'package:dart_counter/library/ThrowValidator.dart';
import 'package:dart_counter/shared/ios/CupertinoButtonSmall.dart' as custom;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors, Divider;

class DoubleDialog extends StatefulWidget {

  // TODO add padding-top equal to pre_gameView

  final int pointsScored;
  final int pointsLeft;

  DoubleDialog(this.pointsScored, this.pointsLeft);

  @override
  _DoubleDialogState createState() => _DoubleDialogState(pointsScored, pointsLeft);
}

class _DoubleDialogState extends State<DoubleDialog> {
  int pointsScored;
  int pointsLeft;

  int dartsOnDouble;
  int dartsThrown;

  _DoubleDialogState(this.pointsScored, this.pointsLeft) {
    dartsOnDouble = -1;
    dartsThrown = pointsLeft != pointsScored ? 3 : -1;
  }

  @override
  Widget build(BuildContext context) {
    if (pointsScored == pointsLeft) {
      return CupertinoPageScaffold(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 36.0, 8.0, 8.0),
          child: Column(
            children: <Widget>[
              sectionHeading('Darts on Double:'),
              Row(children: <Widget>[
                button('1', () {
                  dartsOnDouble = 1;
                  // TODO ist das hier schon fertig ?
                }, dartsOnDouble == 1 ? Colors.grey[500] : Colors.grey[300]),
                button('2', () {
                  dartsOnDouble = 2;
                  if (!ThrowValidator.isOneDartFinish(pointsLeft)) {
                    dartsThrown = 3;
                  }
                }, dartsOnDouble == 2 ? Colors.grey[500] : Colors.grey[300]),
                Visibility(
                  child: button('3', () {
                    dartsOnDouble = 3;
                    if (ThrowValidator.isOneDartFinish(pointsLeft)) {
                      dartsThrown = 3;
                    }
                  }, dartsOnDouble == 3 ? Colors.grey[500] : Colors.grey[300]),
                  visible: ThrowValidator.isOneDartFinish(pointsLeft),
                )
              ]),
              Visibility(
                child: sectionHeading('DartsThrown:'),
                visible: dartsOnDouble != -1 && pointsLeft != 2 && !(ThrowValidator.isOneDartFinish(pointsLeft) && dartsOnDouble == 3) && !(!ThrowValidator.isOneDartFinish(pointsLeft) && dartsOnDouble == 2),
              ),
              Row(children: <Widget>[
                Visibility(
                  child: button('1', () => dartsThrown = 1, dartsThrown == 3 ? Colors.grey[500] : Colors.grey[300]),
                  visible: dartsOnDouble != -1 && ThrowValidator.isOneDartFinish(pointsLeft) && pointsLeft != 2 && !(ThrowValidator.isOneDartFinish(pointsLeft) && dartsOnDouble == 3) && !(!ThrowValidator.isOneDartFinish(pointsLeft) && dartsOnDouble == 2),
                ),
                Visibility(
                  child: button('2', () => dartsThrown = 2, dartsThrown == 3 ? Colors.grey[500] : Colors.grey[300]),
                  visible: dartsOnDouble != -1 && pointsLeft != 2 && !(ThrowValidator.isOneDartFinish(pointsLeft) && dartsOnDouble == 3) && !(!ThrowValidator.isOneDartFinish(pointsLeft) && dartsOnDouble == 2),
                ),
                Visibility(
                  child: button('3', () => dartsThrown = 3, dartsThrown == 3 ? Colors.grey[500] : Colors.grey[300]),
                  visible: dartsOnDouble != -1 && pointsLeft != 2 && !(ThrowValidator.isOneDartFinish(pointsLeft) && dartsOnDouble == 3) && !(!ThrowValidator.isOneDartFinish(pointsLeft) && dartsOnDouble == 2),
                ),
              ]),
            ],
          ),
        ),
      );
    } else {
      return CupertinoPageScaffold(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 36.0, 8.0, 8.0),
          child: Column(
            children: <Widget>[
              sectionHeading('Darts on Double:'),
              Row(children: <Widget>[
                Visibility(
                  child: button('0', () => dartsOnDouble = 0, dartsOnDouble == 0 ? Colors.grey[500] : Colors.grey[300]),
                  visible: pointsLeft != 2,
                ),
                button('1', () => dartsOnDouble = 1, dartsOnDouble == 1 ? Colors.grey[500] : Colors.grey[300]),
                Visibility(
                  child: button('2', () => dartsOnDouble = 2, dartsOnDouble == 2 ? Colors.grey[500] : Colors.grey[300]),
                  visible: !ThrowValidator.isThreeDartFinish(pointsLeft),
                ),
                Visibility(
                  child: button('3', () => dartsOnDouble = 3, dartsOnDouble == 3 ? Colors.grey[500] : Colors.grey[300]),
                  visible: ThrowValidator.isOneDartFinish(pointsLeft),
                ),
              ]),
            ],
          ),
        ),
      );
    }
  }

  /// methods to build the widgets of the ios view
  Widget sectionHeading(String title) {
    return Column(
      children: <Widget>[
        Divider(
          color: Colors.grey[400],
        ),
        Align(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title),
            ),
            alignment: Alignment.centerLeft),
        Divider(
          color: Colors.grey[400],
        ),
      ],
    );
  }

  Widget button(String text, Function onPressed, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(4),
        height: 100,
        child: custom.CupertinoButtonSmall(
            color: color,
            child: Text(text),
            onPressed: () {
              setState(() {
                onPressed();
                checkFormCompleted();
              });
            }
        ),
      ),
    );
  }

  /// checks if the form is completed and return to the InGameView if so
  void checkFormCompleted() {
    if (dartsOnDouble != -1 && dartsThrown != -1) {
      Navigator.pop(context, dartsOnDouble.toString() + ' ' + dartsThrown.toString());
    }
  }
}