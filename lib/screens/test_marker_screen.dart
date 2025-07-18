import 'package:flutter/material.dart';
import 'package:mihome_app/markers/markers.dart';

class TestMarkerScreen extends StatelessWidget {
  const TestMarkerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        color: Colors.red,
        width: 350,
        height: 150,
        child: CustomPaint(
          painter: EndMarkerPainter(
            destination: 'Mi Casa 2',
            kilometers: 100,
          ),
        ),
      ),
    ));
  }
}
