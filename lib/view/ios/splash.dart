import 'dart:async';

import 'package:flutter/cupertino.dart';

class LogoScreen extends StatefulWidget {
  @override
  _LogoScreenState createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100), child: Image.asset('assets/logo.jpg', width: 200, height: 200)
        )
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1500), openPreGame);
  }

  void openPreGame() {
    Navigator.pushReplacementNamed(context, 'PRE_GAME');
  }
}
