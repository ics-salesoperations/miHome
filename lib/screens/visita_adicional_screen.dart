import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/models/models.dart';
import 'package:mihome_app/screens/screens.dart';
import 'package:mihome_app/widgets/widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class VisitaAdicionalScreen extends StatefulWidget {
  final OT ot;

  const VisitaAdicionalScreen({
    Key? key,
    required this.ot,
  }) : super(key: key);

  @override
  State<VisitaAdicionalScreen> createState() => _VisitaAdicionalScreenState();
}

class _VisitaAdicionalScreenState extends State<VisitaAdicionalScreen> {
  late AuthBloc authBloc;
  final _controller = PageController();

  late FormularioBloc frmBloc;

  @override
  void initState() {
    frmBloc = BlocProvider.of<FormularioBloc>(context);
    authBloc = BlocProvider.of<AuthBloc>(context);

    frmBloc.cargarFormsVisita(
      ot: widget.ot,
    );
    frmBloc.add(
      const OnChangeBetweenForms(
        frmActualVisita: 0,
      ),
    );
    super.initState();
  }

  Widget buildSkeleton(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: LoadingSkeleton.rounded(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 40,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(blurRadius: 1, color: Colors.grey, spreadRadius: 0)
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                LoadingSkeleton.rounded(
                  width: double.infinity,
                  height: 60,
                ),
                LoadingSkeleton.rounded(
                  width: double.infinity,
                  height: 60,
                ),
                LoadingSkeleton.rounded(
                  width: double.infinity,
                  height: 60,
                ),
                LoadingSkeleton.rounded(
                  width: double.infinity,
                  height: 60,
                ),
                LoadingSkeleton.rounded(
                  width: double.infinity,
                  height: 60,
                ),
                LoadingSkeleton.rounded(
                  width: double.infinity,
                  height: 60,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackground,
      body: CustomPaint(
        painter: HeaderPicoPainter(),
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 20,
            left: 12,
          ),
          child: Stack(
            children: [
              Positioned(
                //top: MediaQuery.of(context).padding.top + 10,
                left: 10,
                child: InkWell(
                  splashColor: kPrimaryColor,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              BlocBuilder<FormularioBloc, FormularioState>(
                builder: (context, state) {
                  if (!state.isFrmVisitaListo || state.formularios.isEmpty) {
                    return buildSkeleton(context);
                  }

                  final lstResumen = state.formularios;

                  print("Cantidad de formularios a dibujar");
                  print(state.lstFormVisita.length);

                  return Column(
                    children: [
                      VisitaPDVHeader(
                        ot: widget.ot,
                        titulo: 'Gestión de Auditoría',
                      ),

                      CircularPercentIndicator(
                        radius: 30,
                        animation: true,
                        percent: lstResumen.isEmpty
                            ? 0
                            : (state.frmActualVisita + 1) / lstResumen.length,
                        circularStrokeCap: CircularStrokeCap.round,
                        lineWidth: 9,
                        backgroundWidth: 7,
                        backgroundColor: Colors.white30,
                        progressColor: kThirdColor,
                        animateFromLastPercent: true,
                        footer: Text(
                          lstResumen.isEmpty
                              ? "0"
                              : "${state.frmActualVisita + 1}/${lstResumen.length}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'CronosLPro',
                          ),
                        ),
                        center: Text(
                          lstResumen.isEmpty
                              ? "0%"
                              : ((state.frmActualVisita + 1) *
                                          100 /
                                          lstResumen.length)
                                      .round()
                                      .toString() +
                                  "%",
                          style: const TextStyle(
                            color: kPrimaryColor,
                            fontFamily: 'CronosSPro',
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: Center(
                                  child: Text(
                                    lstResumen[state.frmActualVisita]
                                        .formName
                                        .toString(),
                                    style: const TextStyle(
                                      color: kSecondaryColor,
                                      fontFamily: 'Cronos-Pro',
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                height: 20,
                                indent: 10,
                                endIndent: 10,
                                color: Colors.grey[300],
                                thickness: 1,
                              ),
                              Expanded(
                                child: PageView(
                                  controller: _controller,
                                  onPageChanged: (index) {
                                    int idx = index;
                                    if (state.frmActualVisita == 1 &&
                                        index == 0) {
                                      idx = 1;
                                      _controller.initialPage == 1;
                                      print("a primera posicion");
                                    }

                                    frmBloc.add(
                                      OnChangeBetweenForms(
                                        frmActualVisita: idx,
                                      ),
                                    );
                                  },
                                  physics: const BouncingScrollPhysics(),
                                  children: [
                                    ReactiveForm(
                                      formGroup: state.formgroupVisita!,
                                      child: ListView(
                                        children: [
                                          ...(frmBloc.contruirCampos(
                                            state.lstFormVisita
                                                .where((element) =>
                                                    element.formId ==
                                                    state
                                                        .formularios[state
                                                            .frmActualVisita]
                                                        .formId)
                                                .toList(),
                                          )),
                                          (state.frmActualVisita + 1 ==
                                                  state.formularios.length)
                                              ? ReactiveFormConsumer(
                                                  builder:
                                                      (context, form, child) {
                                                    return MaterialButton(
                                                      disabledTextColor: Colors
                                                          .white
                                                          .withOpacity(0.7),
                                                      textColor: kPrimaryColor,
                                                      child: const Text(
                                                        'Finalizar visita',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontFamily:
                                                              'CronosLPro',
                                                        ),
                                                      ),
                                                      color: kSecondaryColor,
                                                      disabledColor:
                                                          Colors.grey,
                                                      onPressed: () async {
                                                        if (form.valid) {
                                                          if (state.frmActualVisita +
                                                                  1 ==
                                                              state.formularios
                                                                  .length) {
                                                            await showDialog(
                                                              context: context,
                                                              builder: (ctx) =>
                                                                  ProcessingVisita(
                                                                ot: widget.ot,
                                                                formulariosResumen:
                                                                    state
                                                                        .formularios,
                                                                formulariosDetalle:
                                                                    state
                                                                        .lstFormVisita,
                                                                formulariosDetalleAud:
                                                                    state
                                                                        .lstFormAud,
                                                                formulariosResumenAud:
                                                                    state
                                                                        .formulariosAud,
                                                              ),
                                                            ).then((value) {
                                                              frmBloc.add(
                                                                const OnCargarFormsEvent(
                                                                  formularios: <
                                                                      FormularioResumen>[],
                                                                  lstFormVisita: [],
                                                                  isFrmVisitaListo:
                                                                      false,
                                                                  formgroupVisita:
                                                                      null,
                                                                ),
                                                              );
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          }
                                                        } else {
                                                          form.markAllAsTouched();
                                                          print(form.errors);
                                                          await showDialog(
                                                            context: context,
                                                            builder: (ctx) =>
                                                                const ConfirmationScreen(
                                                              mensaje:
                                                                  "El formulario esta incompleto, ¿estas seguro que deseas continuar?",
                                                            ),
                                                          ).then(
                                                            <bool>(value) async {
                                                              if (value ==
                                                                  true) {
                                                                await showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (ctx) =>
                                                                      ProcessingVisita(
                                                                    ot: widget
                                                                        .ot,
                                                                    formulariosResumen:
                                                                        state
                                                                            .formularios,
                                                                    formulariosDetalle:
                                                                        state
                                                                            .lstFormVisita,
                                                                    formulariosDetalleAud:
                                                                        state
                                                                            .lstFormAud,
                                                                    formulariosResumenAud:
                                                                        state
                                                                            .formulariosAud,
                                                                  ),
                                                                ).then((value) {
                                                                  frmBloc.add(
                                                                    const OnCargarFormsEvent(
                                                                      formularios: <
                                                                          FormularioResumen>[],
                                                                      lstFormVisita: [],
                                                                      isFrmVisitaListo:
                                                                          false,
                                                                      formgroupVisita:
                                                                          null,
                                                                    ),
                                                                  );

                                                                  frmBloc.add(
                                                                    const OnCargarFormsAudEvent(
                                                                      formulariosAud: <
                                                                          FormularioResumen>[],
                                                                      lstFormAud: [],
                                                                      isFrmAudListo:
                                                                          false,
                                                                      formGroupAud:
                                                                          null,
                                                                    ),
                                                                  );
                                                                  Navigator.pop(context);
                                                                });
                                                              }
                                                            },
                                                          );
                                                        }
                                                      },
                                                    );
                                                  },
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                    for (var i = 1;
                                        i < state.formularios.length;
                                        i++)
                                      ReactiveForm(
                                        formGroup: state.formgroupVisita!,
                                        child: ListView(
                                          children: [
                                            ...(frmBloc.contruirCampos(
                                              state.lstFormVisita
                                                  .where((element) =>
                                                      element.formId ==
                                                      state.formularios[i]
                                                          .formId)
                                                  .toList(),
                                            )),
                                            (state.frmActualVisita + 1 ==
                                                    state.formularios.length)
                                                ? ReactiveFormConsumer(
                                                    builder:
                                                        (context, form, child) {
                                                      return MaterialButton(
                                                        disabledTextColor:
                                                            Colors.white
                                                                .withOpacity(
                                                          0.7,
                                                        ),
                                                        textColor:
                                                            kPrimaryColor,
                                                        child: const Text(
                                                          'Finalizar visita',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontFamily:
                                                                'CronosLPro',
                                                          ),
                                                        ),
                                                        color: kSecondaryColor,
                                                        disabledColor:
                                                            Colors.grey,
                                                        onPressed: () async {
                                                          if (form.valid) {
                                                            if (state.frmActualVisita +
                                                                    1 ==
                                                                state
                                                                    .formularios
                                                                    .length) {

                                                              print(state
                                                                  .formularios);
                                                              print(state
                                                                  .lstFormVisita);

                                                              await showDialog(
                                                                context:
                                                                    context,
                                                                builder: (ctx) =>
                                                                    ProcessingVisita(
                                                                  ot: widget.ot,
                                                                  formulariosResumen:
                                                                      state
                                                                          .formularios,
                                                                  formulariosDetalle:
                                                                      state
                                                                          .lstFormVisita,
                                                                  formulariosDetalleAud:
                                                                      state
                                                                          .lstFormAud,
                                                                  formulariosResumenAud:
                                                                      state
                                                                          .formulariosAud,
                                                                ),
                                                              ).then((value) {
                                                                frmBloc.add(
                                                                  const OnCargarFormsEvent(
                                                                    formularios: <
                                                                        FormularioResumen>[],
                                                                    lstFormVisita: [],
                                                                    isFrmVisitaListo:
                                                                        false,
                                                                    formgroupVisita:
                                                                        null,
                                                                  ),
                                                                );
                                                                Navigator.pop(
                                                                    context);
                                                              });
                                                            }
                                                          } else {
                                                            form.markAllAsTouched();
                                                            print(form.errors);
                                                            await showDialog(
                                                              context: context,
                                                              builder: (ctx) =>
                                                                  const ConfirmationScreen(
                                                                mensaje:
                                                                    "El formulario esta incompleto, ¿estas seguro que deseas continuar?",
                                                              ),
                                                            ).then(
                                                              <bool>(value) async {
                                                                if (value ==
                                                                    true) {
                                                                  await showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (ctx) =>
                                                                            ProcessingVisita(
                                                                      ot: widget
                                                                          .ot,
                                                                      formulariosResumen:
                                                                          state
                                                                              .formularios,
                                                                      formulariosDetalle:
                                                                          state
                                                                              .lstFormVisita,
                                                                      formulariosDetalleAud:
                                                                          state
                                                                              .lstFormAud,
                                                                      formulariosResumenAud:
                                                                          state
                                                                              .formulariosAud,
                                                                    ),
                                                                  ).then(
                                                                      (value) {
                                                                    frmBloc.add(
                                                                      const OnCargarFormsEvent(
                                                                        formularios: <
                                                                            FormularioResumen>[],
                                                                        lstFormVisita: [],
                                                                        isFrmVisitaListo:
                                                                            false,
                                                                        formgroupVisita:
                                                                            null,
                                                                      ),
                                                                    );
                                                                    Navigator.pop(
                                                                        context);
                                                                  });
                                                                }
                                                              },
                                                            );
                                                          }
                                                        },
                                                      );
                                                    },
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      // dot indicators
                      SmoothPageIndicator(
                        controller: _controller,
                        count: state.formularios.length,
                        effect: const JumpingDotEffect(
                          activeDotColor: kSecondaryColor,
                          dotColor: kFourColor,
                          dotHeight: 12,
                          dotWidth: 12,
                          spacing: 16,
                          radius: 20,
                          //verticalOffset: 50,
                          jumpScale: 3,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
