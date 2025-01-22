import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/models/models.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProcessingVisita extends StatefulWidget {
  final OT ot;
  final List<FormularioResumen> formulariosResumen;
  final List<Formulario> formulariosDetalle;
  final List<FormularioResumen> formulariosResumenAud;
  final List<Formulario> formulariosDetalleAud;
  const ProcessingVisita({
    Key? key,
    required this.ot,
    required this.formulariosResumen,
    required this.formulariosDetalle,
    required this.formulariosResumenAud,
    required this.formulariosDetalleAud,
  }) : super(key: key);

  @override
  State<ProcessingVisita> createState() => _ProcessingVisitaState();
}

class _ProcessingVisitaState extends State<ProcessingVisita> {
  late FormularioBloc frmBloc;
  late VisitaBloc visitaBloc;
  late MapBloc mapBloc;

  @override
  void initState() {
    frmBloc = BlocProvider.of<FormularioBloc>(context);
    visitaBloc = BlocProvider.of<VisitaBloc>(context);

    visitaBloc.finalizarVisita(
      formId: visitaBloc.state.formId,
      instanceId: visitaBloc.state.instanceId,
      fechaCreacion: visitaBloc.state.fechaCreacion,
      respondentId: visitaBloc.state.respondentId,
      ot: widget.ot,
    );

    frmBloc.add(
      OnCurrentFormsSaving(
        currentForm: widget.formulariosDetalle,
        formGroup: frmBloc.state.formgroupVisita,
        currentFormAud: widget.formulariosDetalleAud,
        formGroupAud: frmBloc.state.formGroupAud,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: 250,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: BlocBuilder<FormularioBloc, FormularioState>(
            builder: (context, state) {
              final enviados = state.formularios
                  .where(
                    (element) => element.enviado!,
                  )
                  .toList();

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/lottie/processing.json',
                      width: 150,
                      height: 150,
                      animate: true,
                    ),
                    (state.sinProcesar + state.procesado) <= 0
                        ? Container()
                        : LinearPercentIndicator(
                            width: 250,
                            lineHeight: 16,
                            percent:
                                enviados.length / (state.formularios.length),
                            backgroundColor: kThirdColor,
                            progressColor: kPrimaryColor,
                            alignment: MainAxisAlignment.center,
                            animateFromLastPercent: true,
                            addAutomaticKeepAlive: true,
                            barRadius: const Radius.circular(10),
                            center: Text(
                              "${enviados.length * 100 ~/ (state.formularios.length)}%",
                              style: const TextStyle(
                                fontFamily: 'CronosSPro',
                                fontSize: 14,
                                color: kSecondaryColor,
                              ),
                            ),
                          ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 250,
                          margin: const EdgeInsets.only(top: 15),
                          padding: const EdgeInsets.only(
                            top: 35,
                            left: 15,
                            right: 15,
                            bottom: 15,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xffcccaaa),
                                blurRadius: 5,
                                offset:
                                    Offset(0, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              BlocBuilder<VisitaBloc, VisitaState>(
                                builder: (context, state) {
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Flexible(
                                            child: Text(
                                              "VISITA",
                                              style: TextStyle(
                                                color: kFourColor,
                                                fontFamily: 'CronosLPro',
                                                fontSize: 14,
                                              ),
                                              maxLines: 3,
                                            ),
                                          ),
                                          Container(
                                            width: 107,
                                            height: 30,
                                            padding: const EdgeInsets.all(5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                state.guardado
                                                    ? const Icon(
                                                        Icons.check_circle,
                                                        size: 20,
                                                        color: Colors.green,
                                                      )
                                                    : const Icon(
                                                        Icons
                                                            .radio_button_unchecked,
                                                        size: 20,
                                                        color: Colors.red,
                                                      ),
                                                state.enviado
                                                    ? const Icon(
                                                        Icons.check_circle,
                                                        size: 20,
                                                        color: Colors.green,
                                                      )
                                                    : const Icon(
                                                        Icons.check_circle,
                                                        size: 20,
                                                        color: Colors.green,
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                    ],
                                  );
                                },
                              ),
                              ...state.formularios.map(
                                (frm) => Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            frm.formName.toString(),
                                            style: const TextStyle(
                                              color: kFourColor,
                                              fontFamily: 'CronosLPro',
                                              fontSize: 14,
                                            ),
                                            maxLines: 3,
                                          ),
                                        ),
                                        Container(
                                          width: 107,
                                          height: 30,
                                          padding: const EdgeInsets.all(5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              frm.guardado!
                                                  ? const Icon(
                                                      Icons.check_circle,
                                                      size: 20,
                                                      color: Colors.green,
                                                    )
                                                  : const Icon(
                                                      Icons
                                                          .radio_button_unchecked,
                                                      size: 20,
                                                      color: Colors.red,
                                                    ),
                                              frm.enviado!
                                                  ? const Icon(
                                                      Icons.check_circle,
                                                      size: 20,
                                                      color: Colors.green,
                                                    )
                                                  : const Icon(
                                                      Icons
                                                          .radio_button_unchecked,
                                                      size: 20,
                                                      color: Colors.red,
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 250,
                          margin: const EdgeInsets.only(top: 15),
                          padding: const EdgeInsets.all(15),
                          decoration: const BoxDecoration(
                            color: kSecondaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                        ),
                        Container(
                          width: 250,
                          //margin: const EdgeInsets.only(top: 15),
                          padding: const EdgeInsets.all(15),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Formulario",
                                style: TextStyle(
                                  fontFamily: 'CronosSPro',
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                width: 107,
                                height: 30,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: const [
                                    Text(
                                      "Guardado",
                                      style: TextStyle(
                                        fontFamily: 'CronosSPro',
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Enviado",
                                      style: TextStyle(
                                        fontFamily: 'CronosSPro',
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      elevation: 4,
                      color: Colors.white,
                      onPressed: state.procesando
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                      child: const Text(
                        "Cerrar",
                        style: TextStyle(
                          color: kSecondaryColor,
                          fontFamily: 'CronosLPro',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
