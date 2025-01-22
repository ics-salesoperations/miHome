import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../app_styles.dart';

class DecisionScreen extends StatefulWidget {
  final String mensaje;
  const DecisionScreen({
    super.key,
    required this.mensaje,
  });

  @override
  State<DecisionScreen> createState() => _DecisionScreenState();
}

class _DecisionScreenState extends State<DecisionScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        height: size.width * 0.5,
        width: size.width * 0.9,
        child: Neumorphic(
          child: Stack(
            children: [
              Positioned(
                right: 5,
                top: 5,
                child: NeumorphicButton(
                  style: const NeumorphicStyle(
                    color: kThirdColor,
                    boxShape: NeumorphicBoxShape.circle(),
                  ),
                  padding: const EdgeInsets.all(5),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: NeumorphicIcon(
                    Icons.close,
                    size: 22,
                    style: const NeumorphicStyle(
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: NeumorphicText(
                      widget.mensaje,
                      style: const NeumorphicStyle(
                        color: kSecondaryColor,
                      ),
                      textStyle: NeumorphicTextStyle(
                        fontFamily: 'CronosSPro',
                        fontSize: 22,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        NeumorphicButton(
                          style: const NeumorphicStyle(
                            color: kPrimaryColor,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 12,
                          ),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: NeumorphicText(
                            "Si",
                            style: const NeumorphicStyle(
                              color: kSecondaryColor,
                            ),
                            textStyle: NeumorphicTextStyle(
                              fontFamily: 'CronosLPro',
                              fontSize: 18,
                            ),
                          ),
                        ),
                        NeumorphicButton(
                          style: const NeumorphicStyle(
                            color: kPrimaryColor,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 12,
                          ),
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: NeumorphicText(
                            "No",
                            style: const NeumorphicStyle(
                              color: kSecondaryColor,
                            ),
                            textStyle: NeumorphicTextStyle(
                              fontFamily: 'CronosLPro',
                              fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
