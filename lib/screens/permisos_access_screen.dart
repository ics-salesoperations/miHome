import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';

class PermisosAccessScreen extends StatefulWidget {
  const PermisosAccessScreen({Key? key}) : super(key: key);

  @override
  State<PermisosAccessScreen> createState() => _PermisosAccessScreenState();
}

class _PermisosAccessScreenState extends State<PermisosAccessScreen> {
  @override
  Widget build(BuildContext context2) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: Center(
        child: BlocBuilder<PermissionBloc, PermissionState>(
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "Permisos necesarios para utilizar esta aplicación",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _textColor(context),
                            fontSize: 24,
                            fontFamily: 'CronosSPro',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        spacing: 20,
                        clipBehavior: Clip.none,
                        runSpacing: 40,
                        children: [
                          _EnableGps(
                            habilitado: state.isGpsEnabled,
                          ),
                          _AccesoAlGPS(
                            habilitado: state.isGpsPermissionGranted,
                          ),
                          _AccessLocBackgroundButton(
                            habilitado: state.isBackgroundLocationEnabled,
                          ),
                          _AccessPhoneStateButton(
                            habilitado: state.isPhonePermissionGranted,
                          ),
                          _AccessCameraButton(
                            habilitado: state.isCameraPermissionGranted,
                          ),
                          _AccessNotificationButton(
                            habilitado: state.isNotificationPermissionGranted,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AccesoAlGPS extends StatelessWidget {
  final bool habilitado;
  const _AccesoAlGPS({
    Key? key,
    this.habilitado = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      style: NeumorphicStyle(
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(
            22,
          ),
        ),
        depth: habilitado ? -5 : 10,
      ),
      padding: const EdgeInsets.all(12),
      onPressed: !habilitado
          ? () {
              final permissionBloc = BlocProvider.of<PermissionBloc>(context);
              permissionBloc.askGpsAccess();
            }
          : () {},
      child: SizedBox(
        height: 100,
        width: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NeumorphicIcon(
              FontAwesomeIcons.locationPinLock,
              size: 30,
              style: NeumorphicStyle(
                color: kPrimaryColor.withOpacity(0.5),
              ),
            ),
            Flexible(
              child: NeumorphicText(
                "Acceso al GPS",
                style: NeumorphicStyle(
                  depth: 4,
                  color: _textColor(context), //customize color here
                ),
                textStyle: NeumorphicTextStyle(
                  fontSize: 16,
                  fontFamily: 'CronosLPro',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EnableGps extends StatelessWidget {
  final bool habilitado;
  const _EnableGps({
    Key? key,
    this.habilitado = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(
            22,
          ),
        ),
        depth: habilitado ? -5 : 10,
      ),
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        height: 100,
        width: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NeumorphicIcon(
              FontAwesomeIcons.locationArrow,
              size: 30,
              style: NeumorphicStyle(
                color: kPrimaryColor.withOpacity(0.5),
                depth: 4,
              ),
            ),
            NeumorphicText(
              "GPS Habilitado",
              style: const NeumorphicStyle(
                depth: 0,
                color: kFourColor, //customize color here
              ),
              textStyle: NeumorphicTextStyle(
                fontSize: 16,
                fontFamily: 'CronosLPro',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccessPhoneStateButton extends StatelessWidget {
  final bool habilitado;
  const _AccessPhoneStateButton({
    Key? key,
    this.habilitado = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      style: NeumorphicStyle(
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(
            22,
          ),
        ),
        depth: habilitado ? -5 : 12,
      ),
      padding: const EdgeInsets.all(12),
      onPressed: !habilitado
          ? () {
              final permissionBloc = BlocProvider.of<PermissionBloc>(context);
              permissionBloc.askPhoneAccess();
            }
          : () {},
      child: SizedBox(
        height: 100,
        width: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NeumorphicIcon(
              FontAwesomeIcons.phone,
              size: 30,
              style: NeumorphicStyle(
                color: kPrimaryColor.withOpacity(0.5),
                depth: 4,
              ),
            ),
            Flexible(
              child: NeumorphicText(
                "Información del Teléfono",
                style: NeumorphicStyle(
                  depth: 4,
                  color: _textColor(context), //customize color here
                ),
                textStyle: NeumorphicTextStyle(
                  fontSize: 16,
                  fontFamily: 'CronosLPro', //customize size here
                  // AND others usual text style properties (fontFamily, fontWeight, ...)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccessCameraButton extends StatelessWidget {
  final bool habilitado;
  const _AccessCameraButton({
    Key? key,
    this.habilitado = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      style: NeumorphicStyle(
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(
            22,
          ),
        ),
        depth: habilitado ? -5 : 10,
      ),
      padding: const EdgeInsets.all(12),
      onPressed: !habilitado
          ? () {
              final permissionBloc = BlocProvider.of<PermissionBloc>(context);
              permissionBloc.askCameraAccess();
            }
          : () {},
      child: SizedBox(
        height: 100,
        width: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NeumorphicIcon(
              FontAwesomeIcons.camera,
              size: 30,
              style: NeumorphicStyle(
                color: kPrimaryColor.withOpacity(0.5),
                depth: 4,
              ),
            ),
            Flexible(
              child: NeumorphicText(
                "Cámara",
                style: NeumorphicStyle(
                  depth: 4,
                  color: _textColor(context), //customize color here
                ),
                textStyle: NeumorphicTextStyle(
                  fontSize: 16,
                  fontFamily: 'CronosLPro', //customize size here
                  // AND others usual text style properties (fontFamily, fontWeight, ...)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccessLocBackgroundButton extends StatelessWidget {
  final bool habilitado;
  const _AccessLocBackgroundButton({
    Key? key,
    this.habilitado = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      style: NeumorphicStyle(
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(
            22,
          ),
        ),
        depth: habilitado ? -5 : 10,
      ),
      padding: const EdgeInsets.all(12),
      onPressed: !habilitado
          ? () {
              showDialog(
                context: context,
                builder: (context) => const BackgroundPolicy(),
              );
            }
          : () {},
      child: SizedBox(
        height: 100,
        width: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NeumorphicIcon(
              FontAwesomeIcons.locationCrosshairs,
              size: 30,
              style: NeumorphicStyle(
                color: kPrimaryColor.withOpacity(0.5),
              ),
            ),
            Flexible(
              child: NeumorphicText(
                "GPS en Background",
                style: NeumorphicStyle(
                  depth: 4,
                  color: _textColor(context), //customize color here
                ),
                textStyle: NeumorphicTextStyle(
                  fontSize: 16,
                  fontFamily: 'CronosLPro',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _textColor(BuildContext context) {
  if (NeumorphicTheme.isUsingDark(context)) {
    return kPrimaryColor;
  } else {
    return kSecondaryColor;
  }
}

class BackgroundPolicy extends StatelessWidget {
  const BackgroundPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    final permissionBloc = BlocProvider.of<PermissionBloc>(context);

    return AlertDialog(
      title: const Text(
        "Localización en Background",
        style: TextStyle(
          fontFamily: 'CronosSPro',
          fontSize: 18,
          color: kSecondaryColor,
        ),
      ),
      content: const Text(
        "Esta aplicación utiliza la localización en background para poder capturar la localización de cada una de las tomas del Nivel de Señal incluso cuando no estes usando la aplicación.",
        style: TextStyle(
          fontFamily: 'CronosLPro',
          fontSize: 16,
          color: kSecondaryColor,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Cancelar",
            style: TextStyle(
              fontFamily: 'CronosLPro',
              fontSize: 16,
              color: kPrimaryColor,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            permissionBloc.askBackgroundLocation();
            Navigator.pop(context);
          },
          child: const Text(
            "Aceptar",
            style: TextStyle(
              fontFamily: 'CronosLPro',
              fontSize: 16,
              color: kPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _AccessNotificationButton extends StatelessWidget {
  final bool habilitado;
  const _AccessNotificationButton({
    Key? key,
    required this.habilitado,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      style: NeumorphicStyle(
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(
            22,
          ),
        ),
        depth: habilitado ? -5 : 10,
      ),
      padding: const EdgeInsets.all(12),
      onPressed: !habilitado
          ? () {
              final permissionBloc = BlocProvider.of<PermissionBloc>(context);
              permissionBloc.askNotificationPermission();
            }
          : () {},
      child: SizedBox(
        height: 100,
        width: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NeumorphicIcon(
              FontAwesomeIcons.ring,
              size: 30,
              style: NeumorphicStyle(
                color: kPrimaryColor.withOpacity(0.5),
                depth: 4,
              ),
            ),
            Flexible(
              child: NeumorphicText(
                "Notificaciones",
                style: NeumorphicStyle(
                  depth: 4,
                  color: _textColor(context), //customize color here
                ),
                textStyle: NeumorphicTextStyle(
                  fontSize: 16,
                  fontFamily: 'CronosLPro', //customize size here
                  // AND others usual text style properties (fontFamily, fontWeight, ...)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
