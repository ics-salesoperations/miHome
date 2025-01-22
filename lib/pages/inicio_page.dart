import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  late NavigationBloc navBloc;
  late MapBloc mapBloc;
  late AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
    navBloc = BlocProvider.of<NavigationBloc>(context);
    authBloc = BlocProvider.of<AuthBloc>(context);
    mapBloc = BlocProvider.of<MapBloc>(context);
    mapBloc.getPDVs();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.01,
        right: MediaQuery.of(context).size.width * 0.01,
        top: MediaQuery.of(context).padding.top + 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Neumorphic(
                padding: const EdgeInsets.all(12.0),
                style: const NeumorphicStyle(
                  color: Colors.white12,
                  depth: 0,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 100,
                        color: kSecondaryColor.withOpacity(0.8),
                      ),
                    ),
                    Row(
                      children: [
                        NeumorphicText(
                          "Mi",
                          textStyle: NeumorphicTextStyle(
                            fontFamily: 'CronosSPro',
                            fontSize: 18,
                          ),
                          style: const NeumorphicStyle(
                            color: kPrimaryColor,
                          ),
                        ),
                        NeumorphicText(
                          " Home",
                          textStyle: NeumorphicTextStyle(
                              fontFamily: 'CronosSPro', fontSize: 18),
                          style: const NeumorphicStyle(
                            color: kSecondaryColor,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'perfil');
                },
                child: SizedBox(
                  width: 120,
                  child: Center(
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(
                            45,
                          ),
                        ),
                        depth: 10,
                        lightSource: LightSource.topLeft,
                        intensity: 0.8,
                        surfaceIntensity: 1,
                        color: kPrimaryColor.withOpacity(0.2),
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: authBloc.state.usuario.foto == "null"
                            ? const AssetImage(
                                "assets/user_icon_cyan.png",
                              )
                            : Image.memory(
                                base64.decode(
                                  authBloc.state.usuario.foto!,
                                ),
                              ).image,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              clipBehavior: Clip.none,
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  _HomeMenuCard(
                    icono: FontAwesomeIcons.download,
                    label: 'Actualizar',
                    onTap: () {
                      Navigator.pushNamed(context, 'actualizar');
                    },
                  ),
                  _HomeMenuCard(
                    icono: FontAwesomeIcons.calendar,
                    label: 'Mi Agenda',
                    iconSize: const Size(45, 45),
                    onTap: () {
                      Navigator.pushNamed(context, 'planificacion');
                    },
                  ),
                  _HomeMenuCard(
                    icono: FontAwesomeIcons.mapLocation,
                    label: 'Georreferenciar',
                    onTap: () {
                      Navigator.pushNamed(context, 'georreferenciar');
                    },
                  ),
                  _HomeMenuCard(
                    icono: FontAwesomeIcons.clipboardCheck,
                    label: 'Auditoria',
                    onTap: () {
                      Navigator.pushNamed(context, 'busqueda');
                    },
                  ),

                  /* habilitar despues
                  _HomeMenuCard(
                    icono: FontAwesomeIcons.chartColumn,
                    label: 'Reportes',
                    onTap: () {
                      Navigator.pushNamed(context, 'modificaciones');
                    },
                  ),
                  */
                  _HomeMenuCard(
                    icono: FontAwesomeIcons.upload,
                    label: 'Sincronizar',
                    onTap: () {
                      Navigator.pushNamed(context, 'sincronizar');
                    },
                  ),
                  _HomeMenuCard(
                    icono: FontAwesomeIcons.magnifyingGlass,
                    label: 'FTTH',
                    onTap: () {
                      Navigator.pushNamed(context, 'ftth');
                    },
                  ),
                  _HomeMenuCardImg(
                    url: 'assets/images/sophia.png',
                    label: 'SOphia',
                    onTap: () {
                      Navigator.pushNamed(context, 'sophia');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeMenuCard extends StatelessWidget {
  final IconData icono;
  final String label;
  final Color labelColor;
  final Color itemColor;
  final VoidCallback onTap;
  final Size iconSize;

  const _HomeMenuCard({
    required this.icono,
    required this.label,
    required this.onTap,
    this.labelColor = kSecondaryColor,
    this.itemColor = Colors.white,
    this.iconSize = const Size(70, 70),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: NeumorphicButton(
        onPressed: onTap,
        style: NeumorphicStyle(
          shape: NeumorphicShape.convex,
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(
              36,
            ),
          ),
          depth: 10,
          lightSource: LightSource.topLeft,
          intensity: 1,
          color: Colors.white12,
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NeumorphicIcon(
              icono,
              size: 25,
              style: NeumorphicStyle(
                depth: 5,
                color: kPrimaryColor.withOpacity(0.9),
              ),
            ),
            Center(
              child: NeumorphicText(
                label,
                style: NeumorphicStyle(color: labelColor, depth: 3),
                textStyle: NeumorphicTextStyle(
                  fontFamily: 'CronosLPro',
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeMenuCardImg extends StatelessWidget {
  final String url;
  final String label;
  final Color labelColor;
  final VoidCallback onTap;

  const _HomeMenuCardImg({
    required this.url,
    required this.label,
    required this.onTap,
    this.labelColor = kSecondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: NeumorphicButton(
        onPressed: onTap,
        style: NeumorphicStyle(
          shape: NeumorphicShape.convex,
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(
              36,
            ),
          ),
          depth: 10,
          lightSource: LightSource.topLeft,
          intensity: 1,
          color: Colors.white12,
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              url,
              height: 60,
            ),
            Center(
              child: NeumorphicText(
                label,
                style: NeumorphicStyle(
                  color: labelColor,
                  depth: 3,
                ),
                textStyle: NeumorphicTextStyle(
                  fontFamily: 'CronosLPro',
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
