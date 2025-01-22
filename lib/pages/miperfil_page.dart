import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/auth/auth_bloc.dart';
import 'package:mihome_app/screens/cambiar_foto_screen.dart';

import '../widgets/boton_azul.dart';

class MiPerfilPage extends StatefulWidget {
  const MiPerfilPage({super.key});

  @override
  State<MiPerfilPage> createState() => _MiPerfilPageState();
}

class _MiPerfilPageState extends State<MiPerfilPage> {
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(245, 245, 245, 252),
      appBar: NeumorphicAppBar(
        title: NeumorphicText(
          "Mi Perfil",
          style: const NeumorphicStyle(
            color: kPrimaryColor,
            shape: NeumorphicShape.convex,
            boxShape: NeumorphicBoxShape.circle(),
          ),
          textStyle: NeumorphicTextStyle(
            fontSize: 22,
            fontFamily: 'CronosSPro',
          ),
        ),
        leading: NeumorphicBackButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: const NeumorphicStyle(
            boxShape: NeumorphicBoxShape.circle(),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return Stack(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: const Color(0xff1BB5FD),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 50,
                            backgroundImage: state.usuario.foto == "null"
                                ? const AssetImage("assets/user_icon_cyan.png")
                                : Image.memory(
                                    base64.decode(
                                      state.usuario.foto!,
                                    ),
                                  ).image,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: NeumorphicButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => CambiarFotoScreen(),
                              );
                            },
                            padding: EdgeInsets.zero,
                            style: const NeumorphicStyle(
                              boxShape: NeumorphicBoxShape.circle(),
                              depth: 12,
                              shape: NeumorphicShape.convex,
                            ),
                            child: const SizedBox(
                              height: 30,
                              width: 30,
                              child: CircleAvatar(
                                backgroundColor: Color.fromARGB(
                                  218,
                                  252,
                                  252,
                                  251,
                                ),
                                radius: 10,
                                child: Center(
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          authBloc.state.usuario.nombre!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: kSecondaryColor,
                            fontFamily: 'Cronos-Pro',
                          ),
                        ),
                        const Text(
                          "Versión 2.0.1",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: kFourColor,
                            fontFamily: 'Cronos-Pro',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Neumorphic(
                padding:
                    const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
                margin: const EdgeInsets.only(
                  left: 18,
                  right: 18,
                  bottom: 18,
                ),
                style: NeumorphicStyle(
                  shape: NeumorphicShape.flat,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(
                      22,
                    ),
                  ),
                  depth: 10,
                  lightSource: LightSource.topLeft,
                  intensity: 1,
                  color: Colors.white12,
                ),
                child: ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: <Widget>[
                    NeumorphicIcon(
                      FontAwesomeIcons.circleInfo,
                      size: 60,
                      style: const NeumorphicStyle(
                        color: kThirdColor,
                        boxShape: NeumorphicBoxShape.circle(),
                        depth: 12,
                        lightSource: LightSource.topLeft,
                        shape: NeumorphicShape.concave,
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    buildUserInfoDisplay(
                      authBloc.state.usuario.usuario!.toLowerCase(),
                      "Usuario",
                      screenSize.width,
                    ),
                    buildUserInfoDisplay(
                      authBloc.state.usuario.correo!.toLowerCase(),
                      "Correo",
                      screenSize.width,
                    ),
                    buildUserInfoDisplay(
                      authBloc.state.usuario.perfil.toString(),
                      "Perfil",
                      screenSize.width,
                    ),
                    buildUserInfoDisplay(
                      authBloc.state.usuario.idDms.toString(),
                      "Id DMS",
                      screenSize.width,
                    ),
                    buildUserInfoDisplay(
                      authBloc.state.usuario.telefono.toString(),
                      "Telefono",
                      screenSize.width,
                    ),
                    buildUserInfoDisplay(
                      authBloc.state.usuario.identidad.toString(),
                      "Identidad",
                      screenSize.width,
                    ),
                    buildUserInfoDisplay(
                      authBloc.state.usuario.territorio.toString(),
                      "Territorio",
                      screenSize.width,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BotonAzul(
                      text: "Cerrar sesión",
                      onPressed: () {
                        authBloc.add(OnLogoutEvent());
                        Navigator.pushReplacementNamed(context, 'login');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUserInfoDisplay(
    String getValue,
    String title,
    double screenWidth,
  ) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Neumorphic(
          style: const NeumorphicStyle(
            depth: 0,
          ),
          child: Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor.withOpacity(0.6),
                      fontFamily: 'CronosLPro'),
                ),
                Text(
                  getValue,
                  style: TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      color: Colors.grey.shade900,
                      fontFamily: 'CronosLPro'),
                ),
              ],
            ),
          ),
        ),
      );
}
