import 'package:dart_counter/networking/artefacts/Packet.dart';
import 'package:dart_counter/sessioning/User.dart';
import 'package:dart_counter/services/playing_online.dart';
import 'package:dart_counter/view/ios/authenticate/home.dart';
import 'package:dart_counter/view/ios/authenticate/sign_in.dart';
import 'package:dart_counter/view/ios/authenticate/sign_up.dart';
import 'package:dart_counter/view/ios/home/wrapper.dart' as home;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {

  final Color primary;
  final Color secondary;

  Wrapper(this.primary, this.secondary);

  @override
  WrapperState createState() => WrapperState();
}

class WrapperState extends State<Wrapper> {

  final PageController _controller = new PageController(initialPage: 1, viewportFraction: 1.0);


  bool connectedToPlayingService = false;
  final packetProvider = StreamProvider<Packet>.value(value: PlayingOnlineService().packets);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if(user == null) {
      return Provider<WrapperState>.value(
        value: this,
        child: MaterialApp(
          home: Container(
              height: MediaQuery.of(context).size.height,
              child: PageView(
                controller: _controller,
                physics: new AlwaysScrollableScrollPhysics(),
                children: <Widget>[SignIn(widget.primary, widget.secondary), Home(widget.primary, widget.secondary), SignUp(widget.primary, widget.secondary)],
                scrollDirection: Axis.horizontal,
              )),
        ),
      );
    } else {
      if(!connectedToPlayingService) {
        PlayingOnlineService().joinServer(user.uid);
        connectedToPlayingService = true;
      }

      return MultiProvider(
        providers: [
          Provider<WrapperState>.value(value: this),
          packetProvider,
        ],
        child: home.Wrapper(),
      );
    }
  }

  gotoSignIn() {
    _controller.animateToPage(
      0,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  gotoSignUp() {
    _controller.animateToPage(
      2,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

}