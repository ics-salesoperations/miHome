import 'package:flutter/material.dart';
import 'package:mihome_app/app_styles.dart';

class ColillaMarkerPainter extends CustomPainter {
  final bool visitado;

  ColillaMarkerPainter(this.visitado);
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    //lapiz para pintar blanco

    final secondPaint = Paint()
      ..color = kSecondaryColor.withOpacity(0.9); //lapiz para pintar blanco

    const double circleThirdRadius = 40; //10;

    final Paint whitePaint = Paint()..color = Colors.white;

    canvas.drawCircle(
        Offset(circleThirdRadius - 10, size.height - circleThirdRadius / 2),
        circleThirdRadius / 2.0,
        whitePaint);
    canvas.drawCircle(
        Offset(circleThirdRadius - 10, size.height - circleThirdRadius / 2),
        circleThirdRadius / 2.2,
        secondPaint);

    const iconData = Icons.house;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    final iconStr = String.fromCharCode(iconData.codePoint);

    textPainter.text = TextSpan(
        text: iconStr,
        style: TextStyle(
          letterSpacing: 0.0,
          fontSize: 30,
          fontFamily: iconData.fontFamily,
          color: Colors.white,
        ));
    textPainter.layout();

    textPainter.paint(
        canvas,
        Offset(
          circleThirdRadius - 25,
          size.height - circleThirdRadius + 5,
        ));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}
