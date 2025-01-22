import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class BuildKpiInfoDisplay extends StatelessWidget {
  final String mesAct;
  final String mesAnt;
  final String mom;
  final String title;
  final String icono;
  final double screenWidth;

  const BuildKpiInfoDisplay(
      {Key? key,
      required this.mesAct,
      required this.mesAnt,
      required this.mom,
      required this.title,
      required this.icono,
      required this.screenWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    return SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              child: Container(
                padding: const EdgeInsets.all(10),
                width: screenWidth * 0.8,
                height: 140,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: kScaffoldBackground,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffcccaaa),
                      blurRadius: 5,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: SvgPicture.asset(icono,
                              height: 50,
                              width: screenWidth * 0.2,
                              semanticsLabel: 'Label'),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          height: 120,
                          width: screenWidth * 0.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(title,
                                        style: const TextStyle(
                                            fontFamily: 'CronosLPro',
                                            color: kSecondaryColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: Text(mesAct,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style: const TextStyle(
                                            fontFamily: 'CronosSPro',
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.bold,
                                          )))
                                ],
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    child: Text("Mes Anterior",
                                        style: TextStyle(
                                          fontFamily: 'CronosLPro',
                                          color: kSecondaryColor,
                                        )),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: Text(mesAnt,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style: const TextStyle(
                                            fontFamily: 'CronosSPro',
                                            color: kThirdColor,
                                            fontWeight: FontWeight.bold,
                                          )))
                                ],
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    child: Text("MoM",
                                        style: TextStyle(
                                          fontFamily: 'CronosLPro',
                                          color: kSecondaryColor,
                                        )),
                                  ),
                                  const SizedBox(width: 40),
                                  Expanded(
                                    child: Text(mom,
                                        style: const TextStyle(
                                          fontFamily: 'CronosLPro',
                                          color: kSecondaryColor,
                                        )),
                                  ),
                                  if (mom.contains('-'))
                                    const Icon(
                                      Icons.trending_down,
                                      size: 26.0,
                                      color: Color(0xFFEF9A9A),
                                    )
                                  else if (mom.contains('L. 0.00') |
                                      (mom == '0'))
                                    const Icon(
                                      Icons.remove,
                                      size: 26.0,
                                      color: kFourColor,
                                    )
                                  else
                                    const Icon(
                                      Icons.trending_up,
                                      size: 26.0,
                                      color: Colors.green,
                                    ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
