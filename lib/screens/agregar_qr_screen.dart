import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/screens/screens.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../blocs/blocs.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

class AgregarQrScreen extends StatefulWidget {
  final Agenda detalle;
  const AgregarQrScreen({
    super.key,
    required this.detalle,
  });

  @override
  State<AgregarQrScreen> createState() => _AgregarQrScreenState();
}

class _AgregarQrScreenState extends State<AgregarQrScreen> {
  late FormularioBloc formBloc;
  DBService db = DBService();
  late OTStepBloc _stepBloc;

  @override
  void initState() {
    formBloc = BlocProvider.of<FormularioBloc>(context);
    _stepBloc = BlocProvider.of<OTStepBloc>(context);
    formBloc.actualizarFormsModificaion("39");
    formBloc.getFormulario(
      idForm: "39",
      ot: widget.detalle,
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 20,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 10,
              right: 10,
              child: NeumorphicButton(
                style: const NeumorphicStyle(
                  boxShape: NeumorphicBoxShape.circle(),
                  color: kThirdColor,
                  depth: 10,
                ),
                padding: const EdgeInsets.all(7),
                child: NeumorphicIcon(
                  Icons.close,
                  style: const NeumorphicStyle(
                    color: Colors.white,
                    depth: 5,
                  ),
                  size: 26,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
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
                if (!state.isCurrentFormListo || state.currentForm.isEmpty) {
                  return buildSkeleton(context);
                }
                /*
                if (state.currentFormgroup!.controls.keys
                    .contains("Nuevo QR")) {
                  state.currentFormgroup!.control('Nuevo QR').value == 1;
                }*/
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
                              spreadRadius: 0.2)
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
                                          ));

                                          await showDialog(
                                            context: context,
                                            builder: (ctx) =>
                                                const ProcessingScreen(),
                                          ).then(
                                            (value) async {
                                              if (form.controls.keys
                                                  .contains("Nuevo QR")) {
                                                final otBase =
                                                    await db.leerAgendaOt(
                                                        ot: widget.detalle.ot ??
                                                            0);
                                                final actualizada =
                                                    otBase.first.copyWith(
                                                  qrNuevo: form
                                                      .control('Nuevo QR')
                                                      .value,
                                                );

                                                await db
                                                    .actualizarClienteAgenda(
                                                        actualizada);

                                                _stepBloc.add(
                                                  OnCambiarOT(
                                                    ot: [actualizada],
                                                  ),
                                                );
                                              }
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
    );
  }
}
