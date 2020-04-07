import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {

  final Color primary;
  final Color secondary;

  Loading(this.primary, this.secondary);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondary,
      child: Center(
        child: SpinKitThreeBounce(
          color: primary,
          size: 50,
        ),
      ),
    );
  }
}
