import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lottie/lottie.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blocs/blocs.dart';
import '../models/models.dart';
import '../screens/screens.dart';

class DetalleOtPage extends StatefulWidget {
  const DetalleOtPage({
    Key? key,
  }) : super(key: key);

  @override
  _DetalleOtPageState createState() => _DetalleOtPageState();
}

class _DetalleOtPageState extends State<DetalleOtPage> {
  int activeStep = 2;
  int reachedStep = 1;
  int upperBound = 5;
  double progress = 1;
  late OTStepBloc _stepBloc;
  Agenda ot = Agenda();

  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void initState() {
    initializeDateFormatting('es_Es', null);
    _stepBloc = BlocProvider.of<OTStepBloc>(context);
    if (_stepBloc.state.ot.isNotEmpty) {
      ot = _stepBloc.state.ot.first;

      _stepBloc.actualizarOTSteps(
        ot: ot.ot.toString(),
      );
      _stepBloc.colillaActualizada(
        ot.cliente.toString(),
      );
      _stepBloc.actualizarInfoOt(ot);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeumorphicAppBar(
        centerTitle: true,
        title: NeumorphicText(
          "Detalle OT",
          style: const NeumorphicStyle(
            color: kSecondaryColor,
            depth: 0,
          ),
          textStyle: NeumorphicTextStyle(
            fontFamily: 'CronosSPro',
            fontSize: 26,
          ),
        ),
        leading: NeumorphicButton(
          onPressed: () {
            Navigator.pop(context);
          },
          padding: const EdgeInsets.all(12),
          style: const NeumorphicStyle(
            depth: 0,
            color: Colors.transparent,
          ),
          child: NeumorphicIcon(
            Icons.arrow_back,
            size: 26,
            style: const NeumorphicStyle(
              color: kPrimaryColor,
              depth: 0,
            ),
          ),
        ),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        controller: _refreshController,
        onRefresh: () async {
          if (_stepBloc.state.ot.isNotEmpty) {
            ot = _stepBloc.state.ot.first;

            await _stepBloc.actualizarOTSteps(
              ot: ot.ot.toString(),
            );
            await _stepBloc.colillaActualizada(
              ot.cliente.toString(),
            );
          }

          _refreshController.refreshCompleted();
        },
        physics: const BouncingScrollPhysics(),
        child: BlocBuilder<OTStepBloc, OTStepState>(builder: (context, state) {
          if (state.ot.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          ot = state.ot.first;

          return Column(
            children: [
              HeaderOT(
                ot: ot,
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Stack(
                  children: [
                    DetalleOt(
                      ot: ot,
                    ),
                    Positioned(
                      right: 20,
                      top: 0,
                      child: NeumorphicButton(
                        style: const NeumorphicStyle(
                          color: kPrimaryColor,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ActualizarColillaScreen(
                                ot: ot,
                              ),
                            ),
                          ).then((value) async {
                            await _stepBloc.colillaActualizada(
                              ot.cliente.toString(),
                            );
                          });
                        },
                        child: NeumorphicText(
                          "Actualizar Colilla",
                          style: const NeumorphicStyle(
                            color: kSecondaryColor,
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontFamily: 'CronosLPro',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      top: 50,
                      child: NeumorphicButton(
                        style: const NeumorphicStyle(
                          color: kPrimaryColor,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalleConsultasScreen(
                                ot: ot,
                              ),
                            ),
                          );
                        },
                        child: NeumorphicText(
                          "Consultas",
                          style: const NeumorphicStyle(
                            color: kSecondaryColor,
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontFamily: 'CronosLPro',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _steps(
                state,
                ot,
              ),
            ],
          );
        }),
      ),
    );
  }

  _steps(OTStepState state, Agenda ot) {
    if (state.actualizandoSteps) {
      return const CircularProgressIndicator();
    }

    final bool localizarFinalizado = localizarCompletado(
        estados: state.steps
            .where((element) =>
                element.step.toString().toUpperCase() == 'LOCALIZAR')
            .toList());

    return EasyStepper(
      activeStep: state.currentStep,
      lineLength: 70,
      lineSpace: 3,
      lineType: LineType.dotted,
      defaultLineColor: Colors.white,
      finishedLineColor: kPrimaryColor,
      activeStepTextColor: kPrimaryColor,
      finishedStepTextColor: Colors.black87,
      internalPadding: 0,
      showLoadingAnimation: false,
      stepRadius: 12,
      showStepBorder: false,
      onStepReached: (index) {
        if (estados[index].nombre.toUpperCase() == 'LOCALIZAR') {
          showDialog(
            context: context,
            builder: (context) => LocalizarScreen(
              steps: state.steps
                  .where((element) =>
                      element.step.toString().toUpperCase() ==
                      estados[index].nombre.toUpperCase())
                  .toList(),
              ot: ot,
            ),
          );
        } else if (estados[index].nombre.toUpperCase() == 'ACTIVAR') {
          showDialog(
            context: context,
            builder: (context) => ActivarScreen(
              steps: state.steps
                  .where((element) =>
                      element.step.toString().toUpperCase() ==
                      estados[index].nombre.toUpperCase())
                  .toList(),
              ot: ot,
              localizarFinalizado: localizarFinalizado,
              colillaActualizada: state.colillaActualizada,
            ),
          );
        } else if (estados[index].nombre.toUpperCase() == 'CERTIFICAR') {
          showDialog(
            context: context,
            builder: (context) => CertificarScreen(
              steps: state.steps
                  .where((element) =>
                      element.step.toString().toUpperCase() ==
                      estados[index].nombre.toUpperCase())
                  .toList(),
              ot: ot,
              localizarFinalizado: localizarFinalizado,
              colillaActualizada: state.colillaActualizada,
            ),
          );
        } else if (estados[index].nombre.toUpperCase() == 'LIQUIDAR') {
          showDialog(
            context: context,
            builder: (context) => LiquidarScreen(
              steps: state.steps
                  .where((element) =>
                      element.step.toString().toUpperCase() ==
                      estados[index].nombre.toUpperCase())
                  .toList(),
              ot: ot,
              localizarFinalizado: localizarFinalizado,
              colillaActualizada: state.colillaActualizada,
            ),
          );
        }
      },
      steps: [
        ...estados.map(
          (e) {
            bool completado = false;
            bool habilitado = false;

            final estadoTEP = state.steps
                .where((element) =>
                    element.step.toString().toUpperCase() ==
                    e.nombre.toString().toUpperCase())
                .toList();

            completado = estadoTEP.isEmpty
                ? false
                : estadoTEP.last.estadoNuevo == 'FINALIZADA'
                    ? true
                    : false;

            habilitado = estadoTEP.isEmpty
                ? false
                : estadoTEP.last.estadoNuevo == 'PENDIENTE'
                    ? true
                    : false;

            return EasyStep(
              customStep: CircleAvatar(
                radius: 12,
                backgroundColor: habilitado ? kPrimaryColor : Colors.white,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: completado && estadoTEP.isNotEmpty
                      ? kPrimaryColor
                      : kSecondaryColor,
                ),
              ),
              title: e.nombre.toString(),
              customTitle: Text(
                e.nombre.toString(),
                style: TextStyle(
                  fontFamily: 'CronosLPro',
                  fontSize: 16,
                  color: state.currentStep == e.orden
                      ? kPrimaryColor
                      : kSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ],
    );
  }

  bool localizarCompletado({
    required List<OTSteps> estados,
  }) {
    bool respuesta = false;

    if (estados.isNotEmpty) {
      respuesta = estados.last.estadoNuevo == 'FINALIZADA';
    }

    return respuesta;
  }
}

class DetalleOt extends StatelessWidget {
  final Agenda ot;
  const DetalleOt({
    super.key,
    required this.ot,
  });

  static void navigateTo(double lat, double lng) async {
    var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    if (await canLaunchUrl(Uri.parse(uri.toString()))) {
      await launchUrl(Uri.parse(uri.toString()));
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
        left: 15,
        right: 15,
      ),
      child: ListView(
        shrinkWrap: true,
        clipBehavior: Clip.none,
        physics: const BouncingScrollPhysics(),
        children: [
          CaracteristicaOt(
            label: "Producto: ",
            valor:
                ot.producto.toString() == 'null' ? "" : ot.producto.toString(),
          ),
          CaracteristicaOt(
            label: "Tipo: ",
            valor: ot.tipo.toString() == 'null' ? "" : ot.tipo.toString(),
          ),
          CaracteristicaOt(
            label: "Cliente: ",
            valor: ot.cliente.toString() == 'null' ? "" : ot.cliente.toString(),
          ),
          CaracteristicaOt(
            label: "Nombre: ",
            valor: ot.nombreCliente.toString() == 'null'
                ? "Sin Datos"
                : ot.nombreCliente.toString(),
          ),
          Row(
            children: [
              Expanded(
                child: CaracteristicaOt(
                  label: "Nodo: ",
                  valor: ot.nodo.toString() == 'null'
                      ? "Sin Datos"
                      : ot.nodo.toString(),
                ),
              ),
              ot.nodoNuevo.toString() != ot.nodo.toString() &&
                      ot.nodoNuevo.toString().isNotEmpty
                  ? NeumorphicIcon(
                      FontAwesomeIcons.arrowRight,
                      size: 14,
                      style: const NeumorphicStyle(
                        color: kSecondaryColor,
                      ),
                    )
                  : Container(),
              ot.nodoNuevo.toString() != ot.nodo.toString() &&
                      ot.nodoNuevo.toString().isNotEmpty
                  ? NeumorphicText(
                      ' ' + ot.nodoNuevo.toString(),
                      style: NeumorphicStyle(
                        color: kPrimaryColor.withOpacity(0.7),
                      ),
                      textStyle: NeumorphicTextStyle(
                          fontSize: 14, fontFamily: 'CronosSPro'),
                    )
                  : Container(),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CaracteristicaOt(
                  label: "TAP: ",
                  valor: ot.tap.toString() == 'null'
                      ? "Sin Datos"
                      : ot.tap.toString(),
                ),
              ),
              ot.tap.toString() != ot.tapNuevo.toString() &&
                      ot.tapNuevo.toString().isNotEmpty
                  ? NeumorphicIcon(
                      FontAwesomeIcons.arrowRight,
                      size: 14,
                      style: const NeumorphicStyle(
                        color: kSecondaryColor,
                      ),
                    )
                  : Container(),
              ot.tap.toString() != ot.tapNuevo.toString() &&
                      ot.tapNuevo.toString().isNotEmpty
                  ? NeumorphicText(
                      ' ' + ot.tapNuevo.toString(),
                      style: NeumorphicStyle(
                        color: kPrimaryColor.withOpacity(0.7),
                      ),
                      textStyle: NeumorphicTextStyle(
                          fontSize: 14, fontFamily: 'CronosSPro'),
                    )
                  : Container(),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CaracteristicaOt(
                  label: "Colilla: ",
                  valor: ot.colilla.toString() == 'null'
                      ? "Sin Datos"
                      : ot.colilla.toString(),
                ),
              ),
              ot.colilla.toString() != ot.colillaNueva.toString() &&
                      ot.colillaNueva.toString().isNotEmpty
                  ? NeumorphicIcon(
                      FontAwesomeIcons.arrowRight,
                      size: 14,
                      style: const NeumorphicStyle(
                        color: kSecondaryColor,
                      ),
                    )
                  : Container(),
              ot.colilla.toString() != ot.colillaNueva.toString() &&
                      ot.colillaNueva.toString().isNotEmpty
                  ? NeumorphicText(
                      ' ' + ot.colillaNueva.toString(),
                      style: NeumorphicStyle(
                        color: kPrimaryColor.withOpacity(0.7),
                      ),
                      textStyle: NeumorphicTextStyle(
                          fontSize: 14, fontFamily: 'CronosSPro'),
                    )
                  : Container(),
            ],
          ),
          CaracteristicaOt(
            label: "Estado Nodo: ",
            valor: ot.estadoNodo.toString() == 'null'
                ? "Sin Datos"
                : ot.estadoNodo.toString(),
          ),
          CaracteristicaOt(
            label: "Servicios: ",
            valor: ot.servicios.toString() == 'null'
                ? "Sin Datos"
                : ot.servicios.toString(),
          ),
          CaracteristicaOt(
            label: "Comentarios: ",
            valor: ot.comentario.toString() == 'null'
                ? "Sin Datos"
                : ot.comentario.toString(),
          ),
          CaracteristicaOt(
            label: "Dirección: ",
            valor: ot.direccion.toString() == 'null'
                ? "Sin Datos"
                : ot.direccion.toString(),
          ),
          Row(
            children: [
              Expanded(
                child: CaracteristicaOt(
                  label: "Localización: ",
                  valor: ot.latitud.toString() == 'null' ||
                          ot.latitud.toString() == '0.0'
                      ? "Sin Datos"
                      : ot.latitud.toString() + "," + ot.longitud.toString(),
                ),
              ),
              NeumorphicButton(
                onPressed: ot.latitud.toString() == 'null' ||
                        ot.latitud.toString() == '0.0'
                    ? null
                    : () {
                        navigateTo(
                          ot.latitud!,
                          ot.longitud!,
                        );
                      },
                style: const NeumorphicStyle(
                  color: Colors.transparent,
                ),
                child: const Icon(
                  Icons.location_pin,
                  color: kPrimaryColor,
                  size: 18,
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CaracteristicaOt(
                  label: "QR: ",
                  valor: ot.qr.toString() == 'null'
                      ? "Sin Datos"
                      : ot.qr.toString(),
                ),
              ),
              ot.qr.toString() != ot.qrNuevo.toString() &&
                      ot.qrNuevo.toString().isNotEmpty
                  ? NeumorphicIcon(
                      FontAwesomeIcons.arrowRight,
                      size: 14,
                      style: const NeumorphicStyle(
                        color: kSecondaryColor,
                      ),
                    )
                  : Container(),
              ot.qr.toString() != ot.qrNuevo.toString() &&
                      ot.qrNuevo.toString().isNotEmpty
                  ? NeumorphicText(
                      ' ' + ot.qrNuevo.toString(),
                      style: NeumorphicStyle(
                        color: kPrimaryColor.withOpacity(0.7),
                      ),
                      textStyle: NeumorphicTextStyle(
                        fontSize: 14,
                        fontFamily: 'CronosSPro',
                      ),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}

class CaracteristicaOt extends StatelessWidget {
  final String label;
  final String valor;

  const CaracteristicaOt({
    super.key,
    required this.label,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        Clipboard.setData(
          ClipboardData(
            text: valor.toString(),
          ),
        ).then((value) {
          //only if ->
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: kThirdColor,
              duration: const Duration(
                seconds: 1,
              ),
              content: Text(
                "Texto copiado: " + valor.toString(),
                style: const TextStyle(
                  fontFamily: 'CronosLPro',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          );
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NeumorphicText(
              label,
              style: const NeumorphicStyle(
                color: kFourColor,
              ),
              textStyle: NeumorphicTextStyle(
                fontFamily: 'CronosLPro',
                fontSize: 16,
              ),
            ),
            Expanded(
              child: NeumorphicText(
                valor,
                style: const NeumorphicStyle(
                  color: kSecondaryColor,
                ),
                textAlign: TextAlign.left,
                textStyle: NeumorphicTextStyle(
                  fontFamily: 'CronosLPro',
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HeaderOT extends StatelessWidget {
  final Agenda ot;
  const HeaderOT({
    super.key,
    required this.ot,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onLongPress: () async {
                Clipboard.setData(
                  ClipboardData(
                    text: ot.ot.toString(),
                  ),
                ).then((value) {
                  //only if ->
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: kThirdColor,
                      duration: const Duration(
                        seconds: 1,
                      ),
                      content: Text(
                        "Texto copiado: " + ot.ot.toString(),
                        style: const TextStyle(
                          fontFamily: 'CronosLPro',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                });
              },
              child: Neumorphic(
                style: const NeumorphicStyle(
                  shape: NeumorphicShape.flat,
                  depth: 12,
                ),
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NeumorphicText(
                      "OT:  ",
                      style: const NeumorphicStyle(
                        color: kPrimaryColor,
                      ),
                      textStyle: NeumorphicTextStyle(
                        fontFamily: 'CronosLPro',
                        fontSize: 16,
                      ),
                    ),
                    NeumorphicText(
                      ot.ot.toString() == 'null' ? "" : ot.ot.toString(),
                      style: const NeumorphicStyle(
                        color: kPrimaryColor,
                      ),
                      textStyle: NeumorphicTextStyle(
                        fontFamily: 'CronosSPro',
                        fontSize: 22,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          NeumorphicButton(
            style: const NeumorphicStyle(
              shape: NeumorphicShape.convex,
              depth: 12,
            ),
            padding: const EdgeInsets.all(0),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AgregarQrScreen(
                  detalle: ot,
                ),
              );
            },
            child: Lottie.asset(
              'assets/lottie/qr.json',
              height: 50,
              width: 50,
            ),
          ),
        ],
      ),
    );
  }
}
