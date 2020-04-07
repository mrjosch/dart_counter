import 'package:dart_counter/artefacts/Packet.dart';
import 'package:dart_counter/artefacts/Snapshot.dart';
import 'package:dart_counter/services/playing_offline.dart';
import 'package:dart_counter/view/android/home/in_game.dart';
import 'package:dart_counter/view/android/home/post_game.dart';
import 'package:dart_counter/view/android/home/pre_game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    Packet packet = Provider.of<Packet>(context);

    if(packet is Snapshot) {
      // online game
      Snapshot snapshot = packet;
      switch(snapshot.status) {
        case 'PENDING':
          return PreGameWidget(snapshot, true);
        case 'RUNNING':
          return InGameWidget(snapshot, true);
        case 'FINISHED':
          return PostGame(snapshot);
        default:
          return Center(child: Text('Error in home/wrapper'));
      }
    } else {
      if(packet == null) {
        // offline game
        Snapshot snapshot = PlayingOfflineService().snapshot;
        switch(snapshot.status) {
          case 'PENDING':
            return PreGameWidget(snapshot, false);
          case 'RUNNING':
            return InGameWidget(snapshot, false);
          case 'FINISHED':
            return PostGame(snapshot);
          default:
            return Center(child: Text('Error in home/wrapper'));
        }
      } else {
        // unknown package
        return Center(child: Text('Error in home/wrapper'));
      }
    }
  }

}
