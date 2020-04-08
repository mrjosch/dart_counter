import 'package:dart_counter/networking/artefacts/Snapshot.dart';
import 'package:dart_counter/model/Leg.dart';
import 'package:dart_counter/model/Player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:swipedetector/swipedetector.dart';

class PostGame extends StatelessWidget {

  final Snapshot snapshot;

  final CupertinoTabController tabController = CupertinoTabController();

  PostGame(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: buildTabBar(),
      controller: tabController,
      tabBuilder: (context, i) {
        return CupertinoTabView(
          builder: (context) {
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                leading: (i != 0)
                    ? CupertinoButton(
                    child: Icon(CupertinoIcons.back, color: Colors.black),
                    onPressed: () {
                      tabController.index = 0;
                    })
                    : CupertinoButton(
                    child: Icon(CupertinoIcons.home, color: Colors.black),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => Placeholder(),
                          ));
                    }),
                middle: (i == 0)
                    ? Text('Overview')
                    : Text(snapshot.players[i - 1].name),
              ),
              child: SwipeDetector(
                child: Container(
                  color: Colors.grey[100],
                  child: SafeArea(
                    child: (i == 0)
                        ? Column(children: buildPlayerOverviewItems())
                        : (snapshot.sets.length == 1)
                        ? Column(children: buildLegItems(snapshot.players[i - 1]))
                        : Column(children: buildSetItems(snapshot.players[i - 1])),
                  ),
                ),
                onSwipeRight: () {
                  // swipe right
                  tabController.index = (tabController.index - 1) % (snapshot.players.length + 1);
                },
                onSwipeLeft: () {
                  // swipe left
                  tabController.index = (tabController.index + 1) % (snapshot.players.length + 1);
                },
              ),
            );
          },
        );
      },
    );
  }

  List<OverviewPlayerItem> buildPlayerOverviewItems() {
    return List.generate(
      snapshot.players.length,
          (int index) => OverviewPlayerItem(snapshot.players[index], index, tabController),
    );
  }

  List<DetailLegItem> buildLegItems(Player player) {
    List<Leg> legs = snapshot.sets[0].legs;

    return List.generate(legs.length, (int index) => DetailLegItem(legs[index], index));
  }

  List<DetailSetItem> buildSetItems(Player player) {
    List<Set> sets = snapshot.sets;

    return List.generate(sets.length, (int index) => DetailSetItem(sets[index], index));
  }

  CupertinoTabBar buildTabBar() {
    List<BottomNavigationBarItem> tabs = List.generate(
      snapshot.players.length,
          (int index) => BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.person_solid),
        title: Text(snapshot.players[index].name),
      ),
    );
    tabs.insert(0, BottomNavigationBarItem(icon: Icon(CupertinoIcons.group_solid), title: Text('Overview')));

    return CupertinoTabBar(
      items: tabs,
    );
  }
}

class OverviewPlayerItem extends StatelessWidget {

  final Player player;
  final int index;
  final CupertinoTabController tabController;

  OverviewPlayerItem(this.player, this.index, this.tabController);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: GestureDetector(
            child: SizedBox(
              height: 140,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset('assets/logo.jpg', width: 70, height: 70),
                          ),
                          Text(player.name),
                        ],
                      ),
                      Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        children: <Widget>[
                          Text('Legs: ${player.legs}'),
                          Text('Avrg: ${player.average}'),
                          Text('Checkout: ${player.checkoutPercentage}%'),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(CupertinoIcons.forward, color: Colors.black),
                      )
                    ],
                  ),
                ),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey[200],
                ),
              ),
            ),
            onTap: () {
              tabController.index = index + 1;
            }),
      ),
    );
  }
}

class DetailSetItem extends StatelessWidget {

  final Set set;
  final int index;

  DetailSetItem(this.set, this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: GestureDetector(
            child: SizedBox(
              height: 140,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Set ${index + 1}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        children: <Widget>[
                          Text('High: TODO'),
                          Text('Avrg: TODO'),
                          Text('Darts on Double: TODO'),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(CupertinoIcons.info, color: Colors.black),
                      )
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
              ),
            ),
            onTap: () {
              // TODO
            }),
      ),
    );
  }
}

class DetailLegItem extends StatelessWidget {

  final Leg leg;
  final int index;

  DetailLegItem(this.leg, this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: GestureDetector(
            child: SizedBox(
              height: 140,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Leg ${index + 1}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        children: <Widget>[
                          Text('High: TODO'),
                          Text('Avrg: TODO'),
                          Text('Darts on Double: TODO'),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(CupertinoIcons.info, color: Colors.black),
                      )
                    ],
                  ),
                ),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey[200],
                ),
              ),
            ),
            onTap: () {
              // TODO
            }),
      ),
    );
  }
}




/// BULLSHIT ZUM TESTEN

class GameStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        color: Colors.grey[300],
        child: Center(
          child: Text(
            'Game Stats:',
            style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
          ),
        ),
      ),
    );
  }
}

class ScoringStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        color: Colors.grey[600],
      ),
    );
  }
}

class FinishingStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        color: Colors.grey[800],
      ),
    );
  }
}

class DetailScreen extends StatefulWidget {
  DetailScreen(this.topic);

  final String topic;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool switchValue = false;

  bool vis = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Details'),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Visibility(
                    child: Expanded(
                        child: Image.network(
                          'https://cdn.fupa.net/player/jpeg/512x640/5V0GMmOCKRWnUXNb9OBWDqoDvLpbQFWVEZdFFJhf',
                        )),
                    visible: vis,
                  ),
                  Visibility(
                    child: CupertinoButton(
                      child: Text('Bahhh?'),
                      onPressed: () {
                        showCupertinoModalPopup<int>(
                            context: context,
                            builder: (context) {
                              return CupertinoActionSheet(
                                title: Text(''),
                                actions: <Widget>[
                                  CupertinoActionSheetAction(
                                    child: Text('Pfui deifel'),
                                    onPressed: () {
                                      Navigator.pop(context, 1);
                                      setState(() {
                                        vis = true;
                                      });
                                    },
                                    isDefaultAction: true,
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                    visible: !vis,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
