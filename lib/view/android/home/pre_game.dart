import 'dart:ui';

import 'package:dart_counter/artefacts/Snapshot.dart';
import 'package:dart_counter/model/game/DartBot.dart';
import 'package:dart_counter/model/game/Player.dart';
import 'package:dart_counter/services/auth.dart';
import 'package:dart_counter/services/playing_offline.dart';
import 'package:dart_counter/services/playing_online.dart';
import 'package:dart_counter/shared/ios/CupertinoButtonSmall.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors, Icons, Divider;

class PreGameWidget extends StatefulWidget {

  final Snapshot snapshot;
  final bool online;

  PreGameWidget(this.snapshot, this.online);

  @override
  State createState() {
    return _PreGameWidgetState();
  }

}

class _PreGameWidgetState extends State<PreGameWidget> {

  final List<Widget> pickerContent = new List();
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    for (int i = 1; i <= 100; i++) {
      pickerContent.add(Text(i.toString()));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
            child: Icon(Icons.exit_to_app, color: Colors.black),
            onPressed: () async {
              await AuthService().signOut();
            }),
        middle: Text('DartCounter'),
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                controller: controller,
                child: Column(
                  children: <Widget>[
                    sectionHeading('Game'),
                    button(widget.snapshot.config.mode.toString().replaceAll('GameMode.', ' ').replaceAll('_', ' '), () => setState(() => toggleMode())),
                    sizePicker(),
                    button(widget.snapshot.config.type.toString().replaceAll('GameType.', ' '), () => setState(() => toggleType())),
                    startingPointsChooser(),
                    sectionHeading('Players'),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CupertinoButtonSmall(
                              onPressed: () {
                                addPlayer();
                              },
                              color: Colors.green,
                              child: Icon(CupertinoIcons.person_add),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CupertinoButtonSmall(
                              onPressed: () {
                                addDartBot();
                              },
                              color: Colors.grey[400],
                              child: Text('Bot'),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CupertinoButtonSmall(
                              onPressed: () {
                                setState(() {
                                  joinGame();
                                });
                              },
                              color: Colors.blue[400],
                              child: Icon(Icons.wifi),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ],
                    ),
                    playerArea(),
                    sectionHeading('Advanced'),
                    advancedOption('Show Checkout %:', widget.snapshot.config.showCheckout, (val) => setState(() => widget.snapshot.config.showCheckout = val)),
                    advancedOption('Speech:', widget.snapshot.config.speechActivated, (val) => setState(() => widget.snapshot.config.speechActivated = val))
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: button('START GAME', () => setState(() => startGame())),
            ),
          ],
        ),
      ),
    );
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

  Widget button(String text, Function onPressed) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: CupertinoButton(
              onPressed: onPressed,
              color: Colors.grey[400],
              child: Text(text),
            ),
          ),
        ),
      ],
    );
  }

  Widget sizePicker() {
    return SizedBox(
      height: 60,
      child: Center(
        child: SizedBox(
          width: 100,
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(initialItem: 0),
            magnification: 1,
            backgroundColor: Colors.white,
            children: pickerContent,
            itemExtent: 40,
            //height of each item
            looping: false,
            onSelectedItemChanged: (index) => setState(() => widget.snapshot.config.size = index + 1),
          ),
        ),
      ),
    );
  }

  Widget startingPointsChooser() {
    final Map<int, Widget> children = const <int, Widget>{
      1: Text('301'),
      2: Text('501'),
      3: Text('701'),
    };

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: CupertinoSegmentedControl(
                borderColor: Colors.grey[400],
                pressedColor: Colors.grey[200],
                selectedColor: Colors.grey[400],
                unselectedColor: Colors.white,
                children: children,
                onValueChanged: (val) => (val == 1)
                    ? setStartingPoints(301)
                    : (val == 2)
                    ? setStartingPoints(501)
                    : setStartingPoints(701)
            ),
          ),
        ],
      ),
    );
  }

  Widget playerArea() {
    return Column(
        children: List.generate(widget.snapshot.players.length, (int index) {
          if (widget.snapshot.players[index] is DartBot) {
            return dartBotDismissibleItem(index);
          } else {
            if ((widget.snapshot.players.length == 1) || (widget.snapshot.dartBot != null && widget.snapshot.players.length == 2)) {
              return playerItem(index);
            } else {
              return playerDismissibleItem(index);
            }
          }
        })
    );
  }

  Widget playerItem(int index) {
    final controller = TextEditingController();
    return Item(
      child: Row(
        children: <Widget>[
          Text('Name: '),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: CupertinoTextField(
                cursorColor: Colors.grey[400],
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius:
                  BorderRadius.all(Radius.circular(5)),
                ),
                placeholder: 'Player ${index + 1}',
                controller: controller,
                showCursor: true,
                onChanged: (text) {
                  widget.snapshot.players[index].name = text;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dartBotDismissibleItem(int index) {
    return DismissibleItem(
      key: Key(widget.snapshot.players[index].id),
      child:  Row(
        children: <Widget>[
          Text('Dartbot: '),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: SizedBox(
              width: 190,
              child: CupertinoSlider(
                value: widget.snapshot.dartBot.targetAverage.toDouble(),
                onChanged: (newValue) {
                  setState(() {
                    widget.snapshot.dartBot.targetAverage = newValue.toInt();
                  });
                },
                min: 20,
                max: 150,
              ),
            ),
          ),
          Container(
            child: Text(widget.snapshot.dartBot.targetAverage.toString()),
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          ),
        ],
      ),
      onDismissed: (direction) {
        removePlayer(index);
      },
    );
  }

  Widget playerDismissibleItem(int index) {
    final controller = TextEditingController();
    return DismissibleItem(
      key: Key(widget.snapshot.players[index].id),
      child: Row(
        children: <Widget>[
          Text('Name: '),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: CupertinoTextField(
                cursorColor: Colors.grey[400],
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius:
                  BorderRadius.all(Radius.circular(5)),
                ),
                placeholder: 'Player ${index + 1}',
                controller: controller,
                showCursor: true,
                onChanged: (text) {
                  widget.snapshot.players[index].name = text;
                },
              ),
            ),
          ),
        ],
      ),
      onDismissed: (direction) {
        removePlayer(index);
      },
    );
  }

  Widget advancedOption(String title, bool value, Function onChanged) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CupertinoSwitch(
              value: value,
              onChanged: onChanged
          ),
        )
      ],
    );
  }

  /// methods to update the model

  void addPlayer() {
    setState(() {
     if(widget.online) {
       if (PlayingOnlineService().addPlayer(new Player())) {
         controller.jumpTo(controller.position.maxScrollExtent + 100);
       }
     } else {
       if (PlayingOfflineService().addPlayer(new Player())) {
         controller.jumpTo(controller.position.maxScrollExtent + 100);
       }
     }
    });
  }

  void removePlayer(int index) {
    setState(() {
      if(widget.online) {
        PlayingOnlineService().removePlayer(index);
      } else {
        PlayingOfflineService().removePlayer(index);
      }
    });
  }

  void addDartBot() {
    setState(() {
      if(widget.online) {
        // TODO cant add dartbot in online game
      } else {
        if (PlayingOfflineService().addDartBot()) {
          controller.jumpTo(controller.position.maxScrollExtent + 100);
        }
      }
    });
  }

  void removeDartBot() {
    setState(() {
      if(widget.online) {
        // TODO cant remove dartbot in online game
      } else {
        PlayingOfflineService().removeDartBot();
      }
    });
  }

  void toggleMode() {
    setState(() {
      if(widget.online) {
        PlayingOnlineService().toggleMode();
      } else {
        PlayingOfflineService().toggleMode();
      }
    });
  }

  void setSize(int size) {
    setState(() {
      if(widget.online) {
        PlayingOnlineService().setSize(size);
      } else {
        PlayingOfflineService().setSize(size);
      }
    });
  }

  void toggleType() {
    setState(() {
      if(widget.online) {
        PlayingOnlineService().toggleType();
      } else {
        PlayingOfflineService().toggleType();
      }
    });
  }

  void setStartingPoints(int startingPoints) {
    setState(() {
      if(widget.online) {
        PlayingOnlineService().setStartingPoints(startingPoints);
      } else {
        PlayingOfflineService().setStartingPoints(startingPoints);
      }
    });
  }

  void startGame() {
    setState(() {
      if(widget.online) {
        PlayingOnlineService().startGame();
      } else {
        PlayingOfflineService().startGame();
      }
    });
  }

  void joinGame() {
    setState(() {
      if(widget.online) {
        // TODO NOTHING alrdy joined
      } else {
        PlayingOnlineService().joinGame('testGame'); // TODO id of invite
      }
    });
  }

}

/// Header widgets containing basic style and behavior of items
class Item extends StatelessWidget {

  final Widget child;

  Item({this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Container(
        child: SizedBox(
          height: 75,
          child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey),
                color: Colors.grey[200],
              ),
              child: child
          ),
        ),
      ),
    );
  }
}
class DismissibleItem extends StatelessWidget {

  final Key key;
  final Widget child;
  final Function onDismissed;

  DismissibleItem({this.key, this.child, this.onDismissed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Dismissible(
        key: key,
        child: SizedBox(
          height: 75,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey),
              color: Colors.grey[200],
            ),
            child: child,
          ),
        ),
        onDismissed: onDismissed,
        background: Container(
          child: Icon(CupertinoIcons.clear_circled_solid, color: Colors.white),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.red),
        ),
        direction: DismissDirection.endToStart,
      ),
    );
  }
}