import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/models/models.dart';
import 'package:mihome_app/screens/screens.dart';
import 'package:mihome_app/services/db_service.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_image_picker/image_file.dart';

import '../widgets/widgets.dart';

class ModificarGeoScreen extends StatefulWidget {
  final Georreferencia geo;

  const ModificarGeoScreen({super.key, required this.geo});

  @override
  State<ModificarGeoScreen> createState() => _ModificarGeoScreenState();
}

class _ModificarGeoScreenState extends State<ModificarGeoScreen> {
  late AuthBloc authBloc;
  late GeoSearchBloc _geoBloc;
  late FormularioBloc _frmBloc;
  final DBService _db = DBService();

  final actualizarForm = FormGroup({
    'actualizar': FormControl<String>(value: 'NO'),
    'foto': FormControl<ImageFile>(),
    'latitud': FormControl<double>(
      value: 0,
      disabled: true,
    ),
    'longitud': FormControl<double>(
      value: 0,
      disabled: true,
    ),
  });

  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<AuthBloc>(context);
    _geoBloc = BlocProvider.of<GeoSearchBloc>(context);
    _frmBloc = BlocProvider.of<FormularioBloc>(context);
    _frmBloc.getFormulariosModificacion();
    _frmBloc.getFormularioGeo(
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
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NeumorphicIcon(
                          Icons.edit_location,
                          style: const NeumorphicStyle(
                            color: kPrimaryColor,
                            depth: 12,
                          ),
                          size: 44,
                        ),
                        const VerticalDivider(),
                        Column(
                          children: [
                            NeumorphicText(
                              widget.geo.tipo.toString(),
                              style: const NeumorphicStyle(
                                  color: kFourColor, depth: 2),
                              textStyle: NeumorphicTextStyle(
                                fontFamily: 'CronosLPro',
                                fontSize: 16,
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
                                fontSize: 24,
                              ),
                            ),
                            NeumorphicText(
                              widget.geo.nombre.toString(),
                              style: const NeumorphicStyle(
                                  color: kFourColor, depth: 2),
                              textStyle: NeumorphicTextStyle(
                                fontFamily: 'CronosLPro',
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
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
                          ReactiveForm(
                            formGroup: actualizarForm,
                            child: Column(
                              children: [
                                Neumorphic(
                                  style: const NeumorphicStyle(
                                    depth: 8,
                                    shape: NeumorphicShape.flat,
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      ReactiveDropdownField(
                                        formControlName: 'actualizar',
                                        borderRadius: BorderRadius.circular(25),
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            borderSide: const BorderSide(
                                              color: kSecondaryColor,
                                            ),
                                          ),
                                          label: NeumorphicText(
                                            "¿Actualizar Coordenadas?",
                                            style: const NeumorphicStyle(
                                              color: kFourColor,
                                            ),
                                            textStyle: NeumorphicTextStyle(
                                              fontFamily: 'CronosSPro',
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        items: const [
                                          DropdownMenuItem(
                                            child: Text("SI"),
                                            value: "SI",
                                          ),
                                          DropdownMenuItem(
                                            child: Text("NO"),
                                            value: "NO",
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      ReactiveValueListenableBuilder(
                                        formControlName: 'actualizar',
                                        builder: (context, control, child) {
                                          if (control.value.toString() ==
                                              'SI') {
                                            actualizarForm.controls['foto']!
                                                .setValidators(
                                              [
                                                Validators.required,
                                              ],
                                              autoValidate: true,
                                            );
                                            actualizarForm.controls['latitud']!
                                                .setValidators(
                                              [
                                                Validators.required,
                                              ],
                                              autoValidate: true,
                                            );
                                            actualizarForm.controls['longitud']!
                                                .setValidators(
                                              [
                                                Validators.required,
                                              ],
                                              autoValidate: true,
                                            );

                                            return Column(
                                              children: [
                                                SOPhotoCustom(
                                                  campo: 'foto',
                                                  label: 'Tomar Fotografía',
                                                  formulario: actualizarForm,
                                                ),
                                                const SizedBox(
                                                  height: 16,
                                                ),
                                                const SONumberCustom(
                                                  campo: 'latitud',
                                                  label: 'Latitud',
                                                  readOnly: true,
                                                ),
                                                const SizedBox(
                                                  height: 16,
                                                ),
                                                const SONumberCustom(
                                                  campo: 'longitud',
                                                  label: 'Longitud',
                                                  readOnly: true,
                                                ),
                                              ],
                                            );
                                          }
                                          actualizarForm.controls['foto']!
                                              .clearValidators();
                                          actualizarForm.controls['latitud']!
                                              .clearValidators();
                                          actualizarForm.controls['longitud']!
                                              .clearValidators();
                                          actualizarForm.controls['foto']!
                                              .reset();
                                          actualizarForm.controls['latitud']!
                                              .reset();
                                          actualizarForm.controls['longitud']!
                                              .reset();
                                          return Container();
                                        },
                                      ),
                                      ReactiveFormConsumer(
                                        builder: (context, formGroup, child) {
                                          return BlocBuilder<GeoSearchBloc,
                                              GeoSearchState>(
                                            builder: (context, state) {
                                              return NeumorphicButton(
                                                child: NeumorphicText(
                                                  "Actualizar",
                                                  style: const NeumorphicStyle(
                                                    color: kPrimaryColor,
                                                  ),
                                                  textStyle:
                                                      NeumorphicTextStyle(
                                                    fontFamily: 'CronosLPro',
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                onPressed: !(actualizarForm
                                                                .valid &&
                                                            actualizarForm
                                                                    .control(
                                                                        'foto')
                                                                    .value !=
                                                                null) ||
                                                        state.actualizandoGeo
                                                    ? null
                                                    : () async {
                                                        _geoBloc.add(
                                                          const OnActualizandoGeo(
                                                            actualizandoGeo:
                                                                true,
                                                          ),
                                                        );

                                                        final imageFile = File(
                                                          (actualizarForm
                                                                      .control(
                                                                          'foto')
                                                                      .value
                                                                  as ImageFile)
                                                              .image!
                                                              .path,
                                                        );

                                                        Uint8List imagebytes =
                                                            await imageFile
                                                                .readAsBytes(); //convert to bytes
                                                        String imagen = base64
                                                            .encode(imagebytes);

                                                        final fecha =
                                                            DateTime.now();

                                                        final actualizacion =
                                                            widget.geo.copyWith(
                                                          latitud:
                                                              actualizarForm
                                                                  .control(
                                                                      'latitud')
                                                                  .value,
                                                          longitud:
                                                              actualizarForm
                                                                  .control(
                                                                      'longitud')
                                                                  .value,
                                                          foto: imagen,
                                                          fechaActualizacion:
                                                              fecha,
                                                        );

                                                        final detalleLog =
                                                            GeorreferenciaLog(
                                                          enviado: 0,
                                                          usuarioActualiza:
                                                              authBloc
                                                                  .state
                                                                  .usuario
                                                                  .usuario,
                                                          codigoPadre: widget
                                                              .geo.codigoPadre,
                                                          codigo:
                                                              widget.geo.codigo,
                                                          fechaActualizacion:
                                                              fecha,
                                                          foto: imagen,
                                                          latitud:
                                                              actualizarForm
                                                                  .control(
                                                                      'latitud')
                                                                  .value,
                                                          longitud:
                                                              actualizarForm
                                                                  .control(
                                                                      'longitud')
                                                                  .value,
                                                          nombre:
                                                              widget.geo.nombre,
                                                          tipo: widget.geo.tipo,
                                                        );

                                                        await showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              ProcessingGeo(
                                                            geo: actualizacion,
                                                            geoLog: detalleLog,
                                                          ),
                                                        ).then((value) {
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
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
                                                    state.currentForm[0]
                                                        .formName!,
                                                    style:
                                                        const NeumorphicStyle(
                                                      color: kSecondaryColor,
                                                      depth: 12,
                                                    ),
                                                    textStyle:
                                                        NeumorphicTextStyle(
                                                      fontSize: 18,
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
                                                  depth: 8,
                                                  shape: NeumorphicShape.flat,
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
                                                      builder: (context, form,
                                                          child) {
                                                        return NeumorphicButton(
                                                          style:
                                                              const NeumorphicStyle(
                                                            depth: 12,
                                                          ),
                                                          child: NeumorphicText(
                                                            'Actualizar',
                                                            style:
                                                                const NeumorphicStyle(
                                                              color:
                                                                  kPrimaryColor,
                                                            ),
                                                            textStyle:
                                                                NeumorphicTextStyle(
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'CronosLPro',
                                                            ),
                                                          ),
                                                          onPressed: form.valid
                                                              ? () async {
                                                                  print(
                                                                      "Guardando formulario");
                                                                  _frmBloc.add(
                                                                    OnCurrentFormsSaving(
                                                                      currentForm:
                                                                          state
                                                                              .currentForm,
                                                                      formGroup:
                                                                          form,
                                                                    ),
                                                                  );
                                                                  print(
                                                                      "Paso 2");

                                                                  print(form
                                                                      .controls
                                                                      .keys);

                                                                  print(form
                                                                          .controls
                                                                          .keys
                                                                          .contains(
                                                                              "Puertos")
                                                                      ? form
                                                                          .control(
                                                                              "Puertos")
                                                                          .value
                                                                      : null);

                                                                  final geo =
                                                                      widget
                                                                          .geo;

                                                                  await _frmBloc
                                                                      .updateDataGeo(
                                                                    geo: geo
                                                                        .copyWith(
                                                                      marca: form
                                                                              .controls
                                                                              .keys
                                                                              .contains(
                                                                                  "Marca")
                                                                          ? form
                                                                              .control("Marca")
                                                                              .value
                                                                              .toString()
                                                                          : null,
                                                                      modelo: form
                                                                              .controls
                                                                              .keys
                                                                              .contains(
                                                                                  "Modelo")
                                                                          ? form
                                                                              .control("Modelo")
                                                                              .value
                                                                              .toString()
                                                                          : null,
                                                                      puertos: form
                                                                              .controls
                                                                              .keys
                                                                              .contains(
                                                                                  "Puertos")
                                                                          ? int.parse(form.control("Puertos").value ??
                                                                              "0")
                                                                          : null,
                                                                    ),
                                                                  );

                                                                  print(
                                                                      "paso3");

                                                                  _geoBloc.add(
                                                                      OnNewPlacesFoundEvent(
                                                                    geo: [
                                                                      geo.copyWith(
                                                                        marca: form.controls.keys.contains("Marca")
                                                                            ? form.control("Marca").value.toString()
                                                                            : widget.geo.marca,
                                                                        modelo: form.controls.keys.contains("Modelo")
                                                                            ? form.control("Modelo").value
                                                                            : widget.geo.modelo.toString(),
                                                                        puertos: form.controls.keys.contains("Puertos")
                                                                            ? int.parse(form.control("Puertos").value)
                                                                            : widget.geo.puertos,
                                                                      ),
                                                                    ],
                                                                  ));

                                                                  print(
                                                                      "Paso 4");

                                                                  await showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (ctx) =>
                                                                            const ProcessingScreen(),
                                                                  ).then(
                                                                    (value) {
                                                                      _frmBloc.add(
                                                                          const OnCurrentFormReadyEvent(
                                                                        currentForm: [],
                                                                        isCurrentFormReady:
                                                                            false,
                                                                      ));
                                                                      Navigator
                                                                          .pop(
                                                                        context,
                                                                      );
                                                                    },
                                                                  );
                                                                }
                                                              : () {
                                                                  print(
                                                                      "invalido");
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
                    size: 18,
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
