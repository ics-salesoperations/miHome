import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:mihome_app/app_styles.dart';

class BotonAzul extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool procesando;

  const BotonAzul({
    Key? key,
    required this.text,
    required this.onPressed,
    this.procesando = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      style: NeumorphicStyle(
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(
            12,
          ),
        ),
        depth: procesando ? -5 : 5,
        lightSource: LightSource.topLeft,
        intensity: 0.8,
        surfaceIntensity: 1,
        color: Colors.white12,
      ),
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: procesando
            ? const CircularProgressIndicator()
            : NeumorphicText(
                text,
                style: const NeumorphicStyle(
                  color: kPrimaryColor,
                  depth: 4,
                ),
                textStyle: NeumorphicTextStyle(
                  fontSize: 16,
                  fontFamily: 'CronosLPro',
                ),
              ),
      ),
      onPressed: onPressed,
    );
  }
}
