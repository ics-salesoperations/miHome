import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/widgets/boton_azul.dart';
import 'package:mihome_app/widgets/widgets.dart';

class ActualizarPage extends StatefulWidget {
  const ActualizarPage({Key? key}) : super(key: key);

  @override
  _ActualizarPageState createState() => _ActualizarPageState();
}

class _ActualizarPageState extends State<ActualizarPage>
    with TickerProviderStateMixin {
  late AnimationController btnController;
  late Animation<double> girar;

  late ActualizarBloc _actualizarBloc;

  @override
  void dispose() {
    btnController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _actualizarBloc = BlocProvider.of<ActualizarBloc>(context);

    btnController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1000,
      ),
    );

    girar = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: btnController,
        curve: Curves.easeOut,
      ),
    );

    //Agregamos un listener
    btnController.addListener(() {
      if (btnController.status == AnimationStatus.completed) {
        btnController.repeat();
      }
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        body: SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(ctx).padding.top + 15,
          left: 15,
          right: 15,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_outlined,
                  color: kFourColor,
                ),
              ),
            ),
            Center(
              child: Text(
                "Actualización",
                style: TextStyle(
                  color: kSecondaryColor.withOpacity(0.6),
                  fontFamily: 'CronosSPro',
                  fontSize: 28,
                ),
              ),
            ),
            NeumorphicIcon(
              FontAwesomeIcons.cloudArrowDown,
              size: 100,
              style: const NeumorphicStyle(
                shape: NeumorphicShape.concave,
                depth: 12,
                lightSource: LightSource.topLeft,
                intensity: 1,
                surfaceIntensity: 1,
                color: kSecondaryColor,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: BlocBuilder<ActualizarBloc, ActualizarState>(
                    builder: (context, state) {
                      if (state.mensaje.isNotEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: SOHorizontalCard(
                                title: "¡Actualizando!",
                                content: state.mensaje.toString(),
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
                          );
                        });
                      }

                      if (state.actualizandoModelos ||
                          state.actualizandoForms ||
                          state.actualizandoAgenda ||
                          state.actualizandoTangible ||
                          state.actualizandoGeo ||
                          state.actualizandoOts) {
                        btnController.forward();
                      } else {
                        btnController.stop();
                      }

                      if (state.tablas.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _actualizarBloc.actualizarAgenda(
                                currentTablas: state.tablas,
                              );
                            },
                            child: _CustomUpdateItem(
                              actualizando: state.actualizandoAgenda,
                              fecha: state.tablas
                                          .where((element) =>
                                              element.tabla == 'agenda')
                                          .first
                                          .fechaActualizacion !=
                                      null
                                  ? DateFormat('dd/MM/yyyy hh:mm:ss')
                                      .format(state.tablas
                                          .where((element) =>
                                              element.tabla == 'agenda')
                                          .first
                                          .fechaActualizacion!)
                                      .toString()
                                  : "Sin actualizar",
                              label: 'Agenda',
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _actualizarBloc.actualizarFormularios(
                                currentTablas: state.tablas,
                              );
                            },
                            child: _CustomUpdateItem(
                              actualizando: state.actualizandoForms,
                              fecha: state.tablas
                                          .where((element) =>
                                              element.tabla == 'formulario')
                                          .first
                                          .fechaActualizacion !=
                                      null
                                  ? DateFormat('dd/MM/yyyy hh:mm:ss')
                                      .format(state.tablas
                                          .where((element) =>
                                              element.tabla == 'formulario')
                                          .first
                                          .fechaActualizacion!)
                                      .toString()
                                  : "Sin actualizar",
                              label: 'Formularios',
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _actualizarBloc.actualizarOts(
                                currentTablas: state.tablas,
                              );
                            },
                            child: _CustomUpdateItem(
                              actualizando: state.actualizandoOts,
                              fecha: state.tablas
                                          .where((element) =>
                                              element.tabla == 'ot')
                                          .first
                                          .fechaActualizacion !=
                                      null
                                  ? DateFormat('dd/MM/yyyy HH:mm:ss')
                                      .format(state.tablas
                                          .where((element) =>
                                              element.tabla == 'ot')
                                          .first
                                          .fechaActualizacion!)
                                      .toString()
                                  : "Sin actualizar",
                              label: 'Auditoría',
                            ),
                          ),

                          /* habilitar luego
                          GestureDetector(
                            onTap: () {
                              _actualizarBloc.actualizarModelos(
                                currentTablas: state.tablas,
                              );
                            },
                            child: _CustomUpdateItem(
                              actualizando: state.actualizandoModelos,
                              fecha: state.tablas
                                          .where((element) =>
                                              element.tabla == 'modelo')
                                          .first
                                          .fechaActualizacion !=
                                      null
                                  ? DateFormat('dd/MM/yyyy hh:mm:ss')
                                      .format(state.tablas
                                          .where((element) =>
                                              element.tabla == 'modelo')
                                          .first
                                          .fechaActualizacion!)
                                      .toString()
                                  : "Sin actualizar",
                              label: 'Modelos',
                            ),
                          ),
                          */
                          GestureDetector(
                            onTap: () async {
                              String departamento = "";
                              departamento = await showDialog(
                                context: context,
                                builder: (ctx) => _DepartamentoDialog(),
                              );

                              _actualizarBloc.actualizarGeo(
                                currentTablas: state.tablas,
                                departamento: departamento,
                              );
                            },
                            child: _CustomUpdateItem(
                              actualizando: state.actualizandoGeo,
                              fecha: state.tablas
                                          .where((element) =>
                                              element.tabla == 'georreferencia')
                                          .first
                                          .fechaActualizacion !=
                                      null
                                  ? DateFormat('dd/MM/yyyy hh:mm:ss')
                                      .format(state.tablas
                                          .where((element) =>
                                              element.tabla == 'georreferencia')
                                          .first
                                          .fechaActualizacion!)
                                      .toString()
                                  : "Sin actualizar",
                              label: 'Georreferencia',
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Container _CustomUpdateItem({
    bool actualizando = false,
    required String label,
    required String fecha,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 80,
      child: Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(
              90,
            ),
          ),
          depth: actualizando ? 0 : 7,
          lightSource: LightSource.topLeft,
          intensity: 1,
          surfaceIntensity: 1,
          color: Colors.white12,
        ),
        child: Row(
          children: [
            AnimatedBuilder(
                animation: girar,
                builder: (context, child) {
                  return NeumorphicRadio(
                    style: NeumorphicRadioStyle(
                      shape: NeumorphicShape.concave,
                      boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.circular(
                          90,
                        ),
                      ),
                      lightSource: LightSource.topLeft,
                      intensity: 0.8,
                      disableDepth: true,
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Transform.rotate(
                      angle: actualizando ? 2 * pi * girar.value : 0,
                      child: Icon(
                        Icons.update_rounded,
                        color: kThirdColor.withOpacity(
                          0.8,
                        ),
                      ),
                    ),
                  );
                }),
            const SizedBox(
              width: 30,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'CronosLPro',
                    fontSize: 16,
                    color: kSecondaryColor,
                  ),
                ),
                Text(
                  fecha,
                  style: const TextStyle(
                    fontFamily: 'CronosLPro',
                    fontSize: 14,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DepartamentoDialog extends StatefulWidget {
  _DepartamentoDialog({
    super.key,
  });

  @override
  State<_DepartamentoDialog> createState() => _DepartamentoDialogState();
}

class _DepartamentoDialogState extends State<_DepartamentoDialog> {
  List<String> departamentos = [
    'ATLANTIDA',
    'CHOLUTECA',
    'COLON',
    'COMAYAGUA',
    'COPAN',
    'CORTES',
    'EL PARAISO',
    'FRANCISCO MORAZAN',
    'GRACIAS A DIOS',
    'INTIBUCA',
    'ISLAS DE LA BAHIA',
    'LA PAZ',
    'LEMPIRA',
    'OCOTEPEQUE',
    'OLANCHO',
    'SANTA BARBARA',
    'VALLE',
    'YORO',
  ];

  String departamento = "";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Neumorphic(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 20,
          ),
          child: SizedBox(
            width: size.width * 0.8,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Seleccione un departamento:",
                    style: TextStyle(
                      fontFamily: 'CronosSPro',
                      fontSize: 18,
                      color: kFourColor,
                    ),
                  ),
                  DropdownButton<String>(
                      value: departamento,
                      focusColor: Colors.red,
                      style: const TextStyle(
                        color: kSecondaryColor,
                        fontFamily: 'CronosLPro',
                        fontSize: 16,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      items: [
                        const DropdownMenuItem(
                          child: Text("Seleccione"),
                          value: "",
                        ),
                        ...departamentos
                            .map(
                              (e) => DropdownMenuItem<String>(
                                child: Text(
                                  e.toString(),
                                  style: const TextStyle(
                                    color: kSecondaryColor,
                                    fontFamily: 'CronosLPro',
                                    fontSize: 16,
                                  ),
                                ),
                                value: e.toString(),
                              ),
                            )
                            .toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          departamento = value.toString();
                        });
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BotonAzul(
                        text: "Confirmar",
                        onPressed: () {
                          Navigator.pop(
                            context,
                            departamento,
                          );
                        },
                      ),
                      BotonAzul(
                        text: "Cerrar",
                        onPressed: () {
                          Navigator.pop(context, "");
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
