import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/models/models.dart';
import 'package:mihome_app/screens/processing_screen.dart';
import 'package:mihome_app/widgets/widgets.dart';
import 'package:reactive_forms/reactive_forms.dart';

class OTFormScreen extends StatefulWidget {
  final OT ot;
  final String idForm;

  const OTFormScreen({
    super.key,
    required this.ot,
    required this.idForm,
  });

  @override
  State<OTFormScreen> createState() => _OTFormScreenState();
}

class _OTFormScreenState extends State<OTFormScreen> {
  late FormularioBloc formBloc;

  @override
  void initState() {
    print("FORMULARIO RECIBIOD");
    print(widget.idForm);
    formBloc = BlocProvider.of<FormularioBloc>(context);
    formBloc.getFormularioOT(
      idForm: widget.idForm,
      ot: widget.ot,
    );
    super.initState();
  }

  Widget buildSkeleton(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: CustomPaint(
          painter: HeaderWavesGradientPainter(),
          child: Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
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
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 10),
                child: const Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Gestión de OT",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontFamily: 'CronosSPro',
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 50,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                child: BlocBuilder<FormularioBloc, FormularioState>(
                    builder: (context, state) {
                  if (!state.isCurrentFormListo) {
                    return buildSkeleton(context);
                  }
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 1,
                              color: kSecondaryColor,
                              spreadRadius: 0.2,
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            state.currentForm[0].formName!,
                            style: const TextStyle(
                                color: kSecondaryColor,
                                fontSize: 22,
                                fontFamily: 'CronosSPro'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
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
                              BoxShadow(
                                  blurRadius: 1,
                                  color: Colors.grey,
                                  spreadRadius: 0)
                            ],
                          ),
                          child: ReactiveForm(
                            formGroup: state.currentFormgroup!,
                            child: ListView(children: [
                              ...(formBloc.contruirCampos(state.currentForm)),
                              ReactiveFormConsumer(
                                builder: (context, form, child) {
                                  return MaterialButton(
                                    child: const Text(
                                      'Enviar',
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 18,
                                        fontFamily: 'CronosLPro',
                                      ),
                                    ),
                                    color: kSecondaryColor,
                                    disabledColor: Colors.grey,
                                    onPressed: form.valid
                                        ? () async {
                                            formBloc.add(OnCurrentFormsSaving(
                                              currentForm: state.currentForm,
                                              formGroup: form,
                                              currentFormAud: const [],
                                              formGroupAud: null,
                                            ));

                                            await showDialog(
                                              context: context,
                                              builder: (ctx) =>
                                                  const ProcessingScreen(),
                                            ).then(
                                              (value) {
                                                formBloc.add(
                                                  const OnCurrentFormReadyEvent(
                                                    isCurrentFormReady: false,
                                                    currentForm: [],
                                                    formGroup: null,
                                                  ),
                                                );
                                                Navigator.pop(context);
                                              },
                                            );
                                          }
                                        : () {
                                            form.markAllAsTouched();
                                          },
                                  );
                                },
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
