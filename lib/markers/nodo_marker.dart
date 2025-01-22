import 'package:flutter/material.dart';
import 'package:mihome_app/app_styles.dart';

class NodoMarkerPainter extends CustomPainter {
  final bool visitado;

  NodoMarkerPainter(this.visitado);
  @override
  void paint(Canvas canvas, Size size) {
    final thirdPaint = Paint()..color = kThirdColor; //lapiz para pintar blanco

    const double circleThirdRadius = 40; //10;

    final Paint whitePaint = Paint()..color = Colors.white;

    canvas.drawCircle(
        Offset(circleThirdRadius - 10, size.height - circleThirdRadius / 2),
        circleThirdRadius / 2.0,
        thirdPaint);
    canvas.drawCircle(
        Offset(circleThirdRadius - 10, size.height - circleThirdRadius / 2),
        circleThirdRadius / 2.2,
        whitePaint);
    canvas.drawCircle(
        Offset(circleThirdRadius - 10, size.height - circleThirdRadius / 2),
        circleThirdRadius / 2.8,
        thirdPaint);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    textPainter.text = TextSpan(
      text: "N",
      style: TextStyle(
        letterSpacing: 0.0,
        fontSize: 25, //60,
        fontFamily: 'CronosSPro',
        color: visitado ? kPrimaryColor : kSecondaryColor,
      ),
    );
    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(
        circleThirdRadius - 18,
        size.height - circleThirdRadius + 6,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}
