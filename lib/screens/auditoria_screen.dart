import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/models/models.dart';
import 'package:mihome_app/screens/processing_screen.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AuditoriaScreen extends StatefulWidget {
  final Georreferencia geo;

  const AuditoriaScreen({super.key, required this.geo});

  @override
  State<AuditoriaScreen> createState() => _AuditoriaScreenState();
}

class _AuditoriaScreenState extends State<AuditoriaScreen> {
  late AuthBloc authBloc;
  late GeoSearchBloc _geoBloc;
  late FormularioBloc _frmBloc;

  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<AuthBloc>(context);
    _geoBloc = BlocProvider.of<GeoSearchBloc>(context);
    _frmBloc = BlocProvider.of<FormularioBloc>(context);
    _frmBloc.getFormulariosModificacion();
    _frmBloc.getFormularioAuditoriaTap(
      widget.geo,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 20,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Neumorphic(
          style: NeumorphicStyle(
            shape: NeumorphicShape.flat,
            boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.circular(
                25,
              ),
            ),
            depth: 4,
            lightSource: LightSource.topLeft,
            intensity: 0.9,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 20,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Neumorphic(
                    child: SizedBox(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NeumorphicIcon(
                            FontAwesomeIcons.clipboardCheck,
                            style: const NeumorphicStyle(
                              color: kPrimaryColor,
                              depth: 12,
                            ),
                            size: 44,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              NeumorphicText(
                                widget.geo.tipo.toString(),
                                style: const NeumorphicStyle(
                                    color: kFourColor, depth: 2),
                                textStyle: NeumorphicTextStyle(
                                  fontFamily: 'CronosLPro',
                                  fontSize: 18,
                                ),
                              ),
                              NeumorphicText(
                                widget.geo.codigo.toString(),
                                style: const NeumorphicStyle(
                                  color: kPrimaryColor,
                                  depth: 12,
                                ),
                                textStyle: NeumorphicTextStyle(
                                  fontFamily: 'CronosSPro',
                                  fontSize: 22,
                                ),
                              ),
                              NeumorphicText(
                                widget.geo.nombre.toString(),
                                style: const NeumorphicStyle(
                                    color: kFourColor, depth: 2),
                                textStyle: NeumorphicTextStyle(
                                  fontFamily: 'CronosLPro',
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              BlocBuilder<FormularioBloc, FormularioState>(
                                builder: (context, state) {
                                  if (!state.isCurrentFormListo) {
                                    return const SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }
                                  return state.currentForm.isEmpty
                                      ? Container()
                                      : Column(
                                          children: [
                                            Neumorphic(
                                              style: const NeumorphicStyle(
                                                depth: 0,
                                                color: Colors.transparent,
                                              ),
                                              child: Center(
                                                child: NeumorphicText(
                                                  state
                                                      .currentForm[0].formName!,
                                                  style: const NeumorphicStyle(
                                                    color: kSecondaryColor,
                                                    depth: 12,
                                                  ),
                                                  textStyle:
                                                      NeumorphicTextStyle(
                                                    fontSize: 22,
                                                    fontFamily: 'CronosSPro',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Neumorphic(
                                              style: const NeumorphicStyle(
                                                depth: 12,
                                              ),
                                              padding: const EdgeInsets.only(
                                                top: 20,
                                                left: 20,
                                                right: 20,
                                                bottom: 20,
                                              ),
                                              child: ReactiveForm(
                                                formGroup:
                                                    state.currentFormgroup!,
                                                child: Column(children: [
                                                  ...(_frmBloc.contruirCampos(
                                                    state.currentForm,
                                                  )),
                                                  ReactiveFormConsumer(
                                                    builder:
                                                        (context, form, child) {
                                                      return NeumorphicButton(
                                                        style:
                                                            const NeumorphicStyle(
                                                          depth: 12,
                                                        ),
                                                        child: NeumorphicText(
                                                          'Finalizar',
                                                          style:
                                                              const NeumorphicStyle(
                                                            color:
                                                                kPrimaryColor,
                                                          ),
                                                          textStyle:
                                                              NeumorphicTextStyle(
                                                            fontSize: 18,
                                                            fontFamily:
                                                                'CronosLPro',
                                                          ),
                                                        ),
                                                        onPressed: form.valid
                                                            ? () async {
                                                                _frmBloc.add(
                                                                  OnCurrentFormsSaving(
                                                                    currentForm:
                                                                        state
                                                                            .currentForm,
                                                                    formGroup:
                                                                        form,
                                                                  ),
                                                                );

                                                                await showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (ctx) =>
                                                                      const ProcessingScreen(),
                                                                ).then(
                                                                  (value) {
                                                                    _frmBloc
                                                                        .add(
                                                                      const OnCurrentFormsSaving(
                                                                        currentForm: [],
                                                                        formGroup:
                                                                            null,
                                                                      ),
                                                                    );
                                                                    Navigator
                                                                        .pop(
                                                                      context,
                                                                    );
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
                                          ],
                                        );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
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
            ],
          ),
        ),
      ),
    );
  }
}
