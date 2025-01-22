import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mihome_app/app_styles.dart';

import '../../size_configs.dart';

class ComencemosButtom extends StatelessWidget {
  const ComencemosButtom({
    Key? key,
    required this.buttonName,
    required this.onPressed,
    required this.bgColor,
  }) : super(key: key);
  final String buttonName;
  final VoidCallback onPressed;
  final Color bgColor;

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
        depth: 10,
        lightSource: LightSource.topLeft,
        intensity: 0.8,
        surfaceIntensity: 1,
        color: Colors.white12,
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: SizedBox(
          width: SizeConfig.blockSizeH! * 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NeumorphicText(
                "COMENCEMOS",
                style: const NeumorphicStyle(
                  depth: 0,
                  color: Colors.grey,
                  //customize color here
                ),
                textStyle: NeumorphicTextStyle(
                  fontSize: 18,
                  fontFamily: 'CronossPro', //customize size here
                  // AND others usual text style properties (fontFamily, fontWeight, ...)
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              NeumorphicIcon(
                FontAwesomeIcons.arrowRight,
                size: 18,
                style: NeumorphicStyle(
                  color: kPrimaryColor.withOpacity(0.6),
                ),
              ),
            ],
          ), /*TextButton(
            onPressed: onPressed,
            child: Text(
              buttonName,
              style: kBodyText2,
            ),
            style: TextButton.styleFrom(
              backgroundColor: bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          )*/
        ),
      ),
    );
  }
}
