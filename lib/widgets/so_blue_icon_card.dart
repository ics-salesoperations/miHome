import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:mihome_app/app_styles.dart';

class SOBlueIconCard extends StatelessWidget {
  const SOBlueIconCard({
    required this.content,
    required this.title,
    required this.icon,
  });

  final Widget content;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.path(
          MyShapePathProvider(),
        ),
        depth: 10,
        lightSource: LightSource.topLeft,
        intensity: 0.8,
        surfaceIntensity: 1,
        color: Colors.white12,
      ),
      child: SizedBox(
        height: 260,
        width: MediaQuery.of(context).size.width * 0.4,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 10,
              right: 30,
              child: NeumorphicRadio(
                padding: const EdgeInsets.all(12),
                isEnabled: false,
                style: NeumorphicRadioStyle(
                  shape: NeumorphicShape.flat,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(
                      90,
                    ),
                  ),
                  lightSource: LightSource.topLeft,
                ),
                child: NeumorphicIcon(
                  icon,
                  size: 22,
                  style: const NeumorphicStyle(
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    child: NeumorphicText(
                      title,
                      textAlign: TextAlign.left,
                      textStyle: NeumorphicTextStyle(
                        fontSize: 20,
                        fontFamily: 'CronosSPro',
                      ),
                      style: const NeumorphicStyle(
                        color: kFourColor,
                        depth: 10,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: content,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyShapePathProvider extends NeumorphicPathProvider {
  @override
  bool shouldReclip(NeumorphicPathProvider oldClipper) {
    return true;
  }

  @override
  Path getPath(Size size) {
    return Path()
      ..moveTo(0, 14)
      ..quadraticBezierTo(
        0,
        4,
        14,
        0,
      )
      ..lineTo(size.width - 80, 0)
      ..quadraticBezierTo(
        size.width,
        0,
        size.width,
        80,
      )
      ..lineTo(size.width, size.height - 14)
      ..quadraticBezierTo(
        size.width,
        size.height - 6,
        size.width - 16,
        size.height - 2,
      )
      ..lineTo(5, size.height - 2)
      ..quadraticBezierTo(
        0,
        size.height - 4,
        0,
        size.height - 14,
      )
      ..lineTo(0, 0);
  }

  @override
  bool get oneGradientPerPath => false;
}
