import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/models/models.dart';
import 'package:mihome_app/widgets/widgets.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'screens.dart';

class RealizarVisitaScreen extends StatefulWidget {
  final OT ot;

  const RealizarVisitaScreen({
    Key? key,
    required this.ot,
  }) : super(key: key);

  @override
  State<RealizarVisitaScreen> createState() => _RealizarVisitaScreenState();
}

class _RealizarVisitaScreenState extends State<RealizarVisitaScreen> {
  late AuthBloc authBloc;
  late FormularioBloc frmBloc;

  @override
  void initState() {
    frmBloc = BlocProvider.of<FormularioBloc>(context);
    authBloc = BlocProvider.of<AuthBloc>(context);

    frmBloc.cargarFormAuditoria(
      ot: widget.ot,
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
        Container(
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: kScaffoldBackground,
        body: CustomPaint(
          painter: HeaderPicoPainter(),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 20,
                  left: 12,
                ),
                child: InkWell(
                  splashColor: kPrimaryColor,
                  onTap: () {
                    frmBloc.add(
                      const OnCargarFormsAudEvent(
                        formulariosAud: <FormularioResumen>[],
                        lstFormAud: [],
                        isFrmAudListo: false,
                        formGroupAud: null,
                      ),
                    );

                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<FormularioBloc, FormularioState>(
                  builder: (context, state) {
                    print("LISTA DE FORMULARIOS AUDITORIA");
                    print(state.formulariosAud.length);
                    if (!state.isFrmAudListo) {
                      return buildSkeleton(context);
                    }

                    if (state.formulariosAud.isEmpty) {
                      return const Center(
                        child: Text(
                          "Es necesario actualizar formularios.",
                          style: TextStyle(
                            fontFamily: 'CronosLPro',
                            fontSize: 18,
                            color: kSecondaryColor,
                          ),
                        ),
                      );
                    }

                    final frmAuditoriaResumen = state.formulariosAud.first;
                    return Column(
                      children: [
                        VisitaPDVHeader(
                          ot: widget.ot,
                          titulo: 'Auditoría de Materiales',
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
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(12),
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 18.0),
                                    child: Center(
                                      child: Text(
                                        frmAuditoriaResumen.formName.toString(),
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
                                  SizedBox(
                                    child: ReactiveForm(
                                      formGroup: state.formGroupAud!,
                                      child: Column(
                                        children: [
                                          ...(frmBloc.contruirCampos(
                                            state.lstFormAud,
                                          )),
                                          ReactiveFormConsumer(
                                            builder: (context, form, child) {
                                              return MaterialButton(
                                                disabledTextColor: Colors.white
                                                    .withOpacity(0.7),
                                                textColor: kPrimaryColor,
                                                child: const Text(
                                                  'Continuar',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'CronosLPro',
                                                  ),
                                                ),
                                                color: kSecondaryColor,
                                                disabledColor: Colors.grey,
                                                onPressed: () async {
                                                  if (form.valid) {
                                                    final estado = form
                                                        .control(
                                                            'Estado de Visita')
                                                        .value
                                                        .toString()
                                                        .toUpperCase();
                                                    final estados = [
                                                      'CLIENTE AUDITADO',
                                                    ];
                                                    if (!estados
                                                        .contains(estado)) {
                                                      await showDialog(
                                                        context: context,
                                                        builder: (ctx) =>
                                                            ProcessingAuditoriaScreen(
                                                          ot: widget.ot,
                                                          formulariosResumen:
                                                              state.formularios,
                                                          formulariosDetalle:
                                                              state
                                                                  .lstFormVisita,
                                                          formulariosDetalleAud:
                                                              state.lstFormAud,
                                                          formulariosResumenAud:
                                                              state
                                                                  .formulariosAud,
                                                        ),
                                                      ).then((value) {
                                                        frmBloc.add(
                                                          const OnCargarFormsAudEvent(
                                                            formulariosAud: <
                                                                FormularioResumen>[],
                                                            lstFormAud: [],
                                                            isFrmAudListo:
                                                                false,
                                                            formGroupAud: null,
                                                          ),
                                                        );
                                                        Navigator.pop(context);
                                                      });
                                                    } else {
                                                      form.controls[
                                                              'Motivo Fallo']!
                                                          .setValidators(
                                                        [
                                                          Validators.required,
                                                        ],
                                                        autoValidate: true,
                                                      );

                                                      //limpiamos formularios para volver a llenar en siguiente pantalla
                                                      /*
                                                      frmBloc.add(
                                                        const OnCargarFormsAudEvent(
                                                          formulariosAud: <
                                                              FormularioResumen>[],
                                                          lstFormAud: [],
                                                          isFrmAudListo: false,
                                                          formGroupAud: null,
                                                        ),
                                                      );*/

                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                VisitaAdicionalScreen(
                                                              ot: widget.ot,
                                                            ),
                                                          )).then((value) {
                                                        frmBloc.add(
                                                          const OnCargarFormsAudEvent(
                                                            formulariosAud: <
                                                                FormularioResumen>[],
                                                            lstFormAud: [],
                                                            isFrmAudListo:
                                                                false,
                                                            formGroupAud: null,
                                                          ),
                                                        );

                                                        Navigator.pop(context);
                                                      });
                                                    }
                                                  } else {
                                                    form.markAllAsTouched();
                                                    print(form.errors);
                                                  }
                                                },
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
