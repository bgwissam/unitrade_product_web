import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(children: [
        Container(
          width: 100.0,
          height: 100.0,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SpinKitDoubleBounce(
                color: Colors.yellow,
                size: 300.0,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
