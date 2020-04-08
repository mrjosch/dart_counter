import 'dart:io';

import 'package:dart_counter/model/User.dart';
import 'package:dart_counter/services/auth.dart';
import 'package:dart_counter/services/playing_online.dart';
import 'package:dart_counter/view/android/authenticate/wrapper.dart' as android;
import 'package:dart_counter/view/ios/authenticate/wrapper.dart' as ios;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  await PlayingOnlineService().connect();
  runApp(App());
}

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    if(Platform.isIOS) {
      return StreamProvider<User>.value(
          value: AuthService().user,
          child: CupertinoApp(
            debugShowCheckedModeBanner: true,
            home: ios.Wrapper(Colors.white, Colors.grey[400]),
          )
      );
    } else if(Platform.isAndroid) {
      return StreamProvider<User>.value(
          value: AuthService().user,
          child: MaterialApp(
            debugShowCheckedModeBanner: true,
            home: android.Wrapper(Colors.white, Colors.grey[400]),
          )
      );
    } else {
      return Center(
        child: Text('Platform not supported'),
      );
    }
  }

}