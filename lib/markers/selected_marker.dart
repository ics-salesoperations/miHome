import 'package:flutter/material.dart';
import 'package:mihome_app/app_styles.dart';

class SelectedMarkerPainter extends CustomPainter {
  final bool visitado;

  SelectedMarkerPainter(this.visitado);
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    //lapiz para pintar blanco

    final secondPaint = Paint()
      ..color = kPrimaryColor; //lapiz para pintar blanco

    const double circleThirdRadius = 40; //10;

    final Paint whitePaint = Paint()..color = kSecondaryColor;

    canvas.drawCircle(
        Offset(circleThirdRadius + 25, size.height - circleThirdRadius),
        circleThirdRadius / 2.0,
        secondPaint);
    canvas.drawCircle(
        Offset(circleThirdRadius + 25, size.height - circleThirdRadius),
        circleThirdRadius / 2.2,
        whitePaint);
    canvas.drawCircle(
        Offset(circleThirdRadius + 25, size.height - circleThirdRadius),
        circleThirdRadius / 2.8,
        secondPaint);
    /*NUEVO AGREGADO */
    /*const iconData = Icons.call_split;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    final iconStr = String.fromCharCode(iconData.codePoint);

    textPainter.text = TextSpan(
      text: iconStr,
      style: TextStyle(
        letterSpacing: 0.0,
        fontSize: 40, //60,
        fontFamily: iconData.fontFamily,
        color: visitado ? kPrimaryColor : kSecondaryColor,
      ),
    );
    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(
        0.0,
        size.height - 40,
      ),
    );*/
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}
