import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/models/models.dart';
import 'package:mihome_app/services/db_service.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_image_picker/image_file.dart';

import '../widgets/widgets.dart';
import 'screens.dart';

class AgregarColillaScreen extends StatefulWidget {
  final Georreferencia geo;
  final int puerto;
  final Agenda? ot;

  const AgregarColillaScreen({
    super.key,
    required this.geo,
    this.puerto = 0,
    this.ot,
  });

  @override
  State<AgregarColillaScreen> createState() => _AgregarColillaScreenState();
}

class _AgregarColillaScreenState extends State<AgregarColillaScreen> {
  late AuthBloc authBloc;
  final DBService _db = DBService();
  late GeoSearchBloc _geoBloc;
  late OTStepBloc _stepBloc;
  String mensaje = "";
  bool valido = false;

  static final GlobalKey<FormState> _key = GlobalKey<FormState>();

  FormGroup crearForm = FormGroup({
    'codigo': FormControl<String>(value: '', validators: [
      Validators.minLength(10),
      Validators.maxLength(10),
      Validators.required,
    ]),
    'tipo': FormControl<String>(
      value: '',
      disabled: true,
    ),
    'nombre': FormControl<String>(
      value: '',
      validators: [
        Validators.required,
      ],
    ),
    'codigoPadre': FormControl<String>(
      value: '',
      disabled: true,
    ),
    'foto': FormControl<ImageFile>(
      validators: [
        Validators.required,
      ],
    ),
    'latitud': FormControl<double>(
      value: 0,
      disabled: true,
    ),
    'longitud': FormControl<double>(
      value: 0,
      disabled: true,
    ),
    'puerto': FormControl<int>(
      value: 0,
    ),
    'valida': FormControl<bool>(
      value: true,
    ),
    'mensaje': FormControl<String>(
      value: "",
    ),
  });

  FormGroup validarForm = FormGroup({
    'colilla': FormControl<String>(
      value: '',
    ),
    'cliente': FormControl<String>(),
    'valida': FormControl<String>(),
  });

  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<AuthBloc>(context);
    _geoBloc = BlocProvider.of<GeoSearchBloc>(context);
    _stepBloc = BlocProvider.of<OTStepBloc>(context);
    crearForm.control('codigoPadre').value = widget.geo.codigo;
    crearForm.control('tipo').value = 'COLILLA';
    crearForm.control('puerto').value = widget.puerto;
    if (widget.ot != null) {
      crearForm.control('nombre').value = widget.ot!.cliente.toString();
      crearForm.control('nombre').markAsDisabled();
    }

    if (widget.puerto > 0) {
      crearForm.control('puerto').markAsDisabled();
    }
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
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: BlocBuilder<OTStepBloc, OTStepState>(
                      builder: (context, state) {
                        return ListView(
                            physics: const BouncingScrollPhysics(),
                            children: [
                              ReactiveForm(
                                key: _key,
                                formGroup: validarForm,
                                child: ReactiveFormConsumer(
                                  builder: (context, formGroup, child) {
                                    String colillaValidada = formGroup
                                        .control('colilla')
                                        .value
                                        .toString();

                                    String clienteValidada = formGroup
                                        .control('cliente')
                                        .value
                                        .toString();
                                    String colillaIngresada = crearForm
                                        .control('codigo')
                                        .value
                                        .toString();

                                    if (colillaValidada != colillaIngresada &&
                                        colillaValidada != "null" &&
                                        colillaIngresada != "null") {
                                      crearForm.control('mensaje').value =
                                          "Antes de Continuar, valida la colilla ingresada.";
                                      crearForm.control('valida').value = false;
                                    } else if (clienteValidada !=
                                            widget.ot!.cliente.toString() &&
                                        clienteValidada != "null") {
                                      crearForm.control('mensaje').value =
                                          "Esta colilla pertenece a otro cliente, tienes que reemplazarla.";
                                      crearForm.control('valida').value = false;
                                    } else {
                                      crearForm.control('valida').value = true;
                                    }

                                    return Container();
                                  },
                                ),
                              ),
                              ReactiveForm(
                                formGroup: crearForm,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 34,
                                    ),
                                    const SOTextFieldCustom(
                                      campo: 'tipo',
                                      label: 'Tipo',
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    SONumberCustom(
                                      campo: 'puerto',
                                      label: 'Puerto',
                                      readOnly:
                                          widget.puerto > 0 ? true : false,
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    const SOTextFieldCustom(
                                      campo: 'codigoPadre',
                                      label: 'Codigo Padre',
                                      readOnly: true,
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    const SONumberCustom(
                                      campo: 'nombre',
                                      label: 'Número de Cliente',
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    const SONumberCustom(
                                      campo: 'codigo',
                                      label: 'Colilla',
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    widget.ot == null
                                        ? Container()
                                        : Column(
                                            children: [
                                              SOPhotoCustom(
                                                campo: 'foto',
                                                label: 'Foto de la colilla',
                                                formulario: crearForm,
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
                                          ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    ReactiveFormConsumer(
                                      builder: (context, formGroup, child) {
                                        String mensaje = formGroup
                                            .control('mensaje')
                                            .value
                                            .toString();

                                        return NeumorphicText(
                                          _stepBloc.state.colillaValida
                                              ? ""
                                              : mensaje,
                                          textStyle: NeumorphicTextStyle(
                                            fontFamily: 'CronosLPro',
                                            fontSize: 16,
                                          ),
                                          style: const NeumorphicStyle(
                                            color: kPrimaryColor,
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        state.colillaValida
                                            ? Container()
                                            : NeumorphicButton(
                                                style: const NeumorphicStyle(
                                                  oppositeShadowLightSource:
                                                      true,
                                                  lightSource:
                                                      LightSource.topLeft,
                                                ),
                                                child: NeumorphicText(
                                                  "Validar",
                                                  style: const NeumorphicStyle(
                                                    color: kSecondaryColor,
                                                    lightSource:
                                                        LightSource.topRight,
                                                  ),
                                                  textStyle:
                                                      NeumorphicTextStyle(
                                                    fontFamily: 'CronosLPro',
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  await showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        BuscarClienteElement(
                                                      cliente: crearForm
                                                          .control('codigo')
                                                          .value
                                                          .toString(),
                                                      frm: crearForm,
                                                      frmValidar: validarForm,
                                                      retornar: false,
                                                      colilla: true,
                                                      ot: widget.ot,
                                                    ),
                                                  );
                                                },
                                              ),
                                        state.colillaValida
                                            ? NeumorphicButton(
                                                style: const NeumorphicStyle(
                                                  oppositeShadowLightSource:
                                                      true,
                                                  lightSource:
                                                      LightSource.topLeft,
                                                ),
                                                child: NeumorphicText(
                                                  "Crear",
                                                  style: const NeumorphicStyle(
                                                    color: kSecondaryColor,
                                                    lightSource:
                                                        LightSource.topRight,
                                                  ),
                                                  textStyle:
                                                      NeumorphicTextStyle(
                                                    fontFamily: 'CronosLPro',
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                onPressed: crearDependencia,
                                              )
                                            : Container(),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                ),
                              ),
                            ]);
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                top: -10,
                child: Neumorphic(
                  padding: const EdgeInsets.all(8),
                  style: const NeumorphicStyle(
                    depth: 5,
                  ),
                  child: NeumorphicText(
                    'Actualizar colilla',
                    style: const NeumorphicStyle(
                      color: kFourColor,
                    ),
                    textStyle: NeumorphicTextStyle(
                      fontFamily: 'CronosSPro',
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -10,
                right: -10,
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

  Future<void> crearDependencia() async {
    String imagen = "";

    if (crearForm.control('foto').value != null) {
      final imageFile = File(
        (crearForm.control('foto').value as ImageFile).image!.path,
      );

      Uint8List imagebytes = await imageFile.readAsBytes(); //convert to bytes
      imagen = base64.encode(imagebytes);
    }

    final geo = Georreferencia(
      codigo: crearForm.control('codigo').value,
      nombre: crearForm.control('nombre').value,
      codigoPadre: widget.geo.codigo,
      foto: imagen,
      tipo: crearForm.control('tipo').value,
      latitud: crearForm.control('latitud').value,
      longitud: crearForm.control('longitud').value,
      puerto: crearForm.control('puerto').value,
      fechaActualizacion: DateTime.now(),
    );

    await _db.crearGeoDep(geo);

    final entidad = await _db.validarExiste(geo);

    if (entidad.isNotEmpty) {
      final detalleLog = GeorreferenciaLog(
        enviado: 0,
        usuarioActualiza: authBloc.state.usuario.usuario,
        codigoPadre: entidad[0].codigoPadre,
        codigo: entidad[0].codigo,
        fechaActualizacion: DateTime.now(),
        foto: imagen,
        latitud: entidad[0].latitud,
        longitud: entidad[0].longitud,
        nombre: entidad[0].nombre,
        tipo: entidad[0].tipo,
      );

      await showDialog(
        context: context,
        builder: (context) => ProcessingGeo(
          geo: entidad[0],
          geoLog: detalleLog,
        ),
      ).then((value) async {
        _geoBloc.add(
          OnNewPlacesFoundEvent(
            geo: [widget.geo],
          ),
        );
        await _geoBloc.getGeoDependencias(
          geo: widget.geo,
        );
        Navigator.pop(context);
      });
    }
  }
}

class BuscarClienteElement extends StatefulWidget {
  final String cliente;
  final FormGroup? frm;
  final FormGroup? frmValidar;
  final bool retornar;
  final bool colilla;
  final Agenda? ot;

  const BuscarClienteElement({
    super.key,
    required this.cliente,
    this.frm,
    this.frmValidar,
    this.retornar = false,
    this.colilla = false,
    this.ot,
  });

  @override
  State<BuscarClienteElement> createState() => _BuscarClienteElementState();
}

class _BuscarClienteElementState extends State<BuscarClienteElement> {
  late GeoSearchBloc _geoBloc;
  late OTStepBloc _stepBloc;
  late AgendaBloc _agendaBloc;
  DBService db = DBService();

  Georreferencia selected = Georreferencia();
  late final Future<Map<String, dynamic>> detalleCliente;

  @override
  void initState() {
    super.initState();
    _geoBloc = BlocProvider.of<GeoSearchBloc>(context);
    _stepBloc = BlocProvider.of<OTStepBloc>(context);
    _agendaBloc = BlocProvider.of<AgendaBloc>(context);
    detalleCliente = _geoBloc.buscarCliente(
      cliente: widget.cliente,
      esColilla: widget.colilla,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.center,
        child: Neumorphic(
          style: const NeumorphicStyle(
            depth: 5,
          ),
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            height: size.width,
            width: size.width * 0.8,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: NeumorphicText(
                      "Detalle de la búsqueda",
                      style: const NeumorphicStyle(
                        color: kPrimaryColor,
                      ),
                      textStyle: NeumorphicTextStyle(
                        fontSize: 22,
                        fontFamily: 'CronosSPro',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  FutureBuilder<Map<String, dynamic>>(
                    future: detalleCliente,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (!snapshot.data!.isNotEmpty) {
                        if (widget.ot != null) {
                          final actualizada = widget.ot!.copyWith(
                            colillaNueva:
                                widget.frm!.control('codigo').value.toString(),
                          );

                          db.actualizarClienteAgenda(actualizada);

                          _agendaBloc.init();

                          _stepBloc.add(
                            OnCambiarOT(
                              ot: [actualizada],
                            ),
                          );
                        }

                        _stepBloc.add(
                          const OnCambiarColillaValida(
                            colillaValida: true,
                          ),
                        );
                        return Center(
                          child: NeumorphicText(
                              'No existen datos asociados al cliente ${widget.cliente}, valida que este bien escrito.'),
                        );
                      }

                      final List<dynamic> lst = snapshot.data!['data'];

                      final Map<String, dynamic> datos = lst.first;

                      /*
                      if (datos.keys.contains("colilla") && widget.retornar) {
                        widget.frm!.controls['codigo']!.value =
                            datos['colilla']!.toString();
                      }

                      if (datos.keys.contains("cliente") && widget.retornar) {
                        widget.frm!.controls['nombre']!.value =
                            datos['cliente']!.toString();
                      }*/
                      if (datos.keys.contains("cliente")) {
                        print("ENCONTRE VALIDAR");
                        if (widget.frm!.controls['nombre']!.value ==
                            datos['cliente']!.toString()) {
                          if (widget.ot != null) {
                            final actualizada = widget.ot!.copyWith(
                              colillaNueva: widget.frm!
                                  .control('codigo')
                                  .value
                                  .toString(),
                            );

                            db.actualizarClienteAgenda(actualizada);

                            _agendaBloc.init();

                            _stepBloc.add(
                              OnCambiarOT(
                                ot: [actualizada],
                              ),
                            );
                          }

                          _stepBloc.add(
                            const OnCambiarColillaValida(
                              colillaValida: true,
                            ),
                          );
                        }
                      }

                      if (widget.frmValidar != null) {
                        if (datos.keys.contains("cliente")) {
                          if (widget.frmValidar!.controls['cliente']!.value ==
                              datos['cliente']!.toString()) {
                            if (widget.ot != null) {
                              final actualizada = widget.ot!.copyWith(
                                colillaNueva: widget.frm!
                                    .control('codigo')
                                    .value
                                    .toString(),
                              );

                              db.actualizarClienteAgenda(actualizada);

                              _agendaBloc.init();

                              _stepBloc.add(
                                OnCambiarOT(
                                  ot: [actualizada],
                                ),
                              );
                            }

                            _stepBloc.add(
                              const OnCambiarColillaValida(
                                colillaValida: true,
                              ),
                            );
                          }
                        }

                        if (datos.keys.contains("colilla")) {
                          widget.frmValidar!.controls['colilla']!.value =
                              datos['colilla']!.toString();
                        }
                        if (datos.keys.contains("valida")) {
                          widget.frmValidar!.controls['valida']!.value =
                              datos['valida']!.toString();
                          if (datos['valida']!.toString().toUpperCase() ==
                              'NO') {
                            _stepBloc.add(const OnCambiarColillaValida(
                              colillaValida: false,
                            ));
                          }
                        }

                        if (datos.keys.contains("Error")) {
                          if (widget.ot != null) {
                            final actualizada = widget.ot!.copyWith(
                              colillaNueva: widget.frm!
                                  .control('codigo')
                                  .value
                                  .toString(),
                            );

                            db.actualizarClienteAgenda(actualizada);

                            _agendaBloc.init();

                            _stepBloc.add(
                              OnCambiarOT(
                                ot: [actualizada],
                              ),
                            );
                          }
                          _stepBloc.add(const OnCambiarColillaValida(
                            colillaValida: true,
                          ));
                        }
                      }

                      return Neumorphic(
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        padding: const EdgeInsets.all(5),
                        style: const NeumorphicStyle(depth: 15),
                        child: Column(
                          children: datos.entries.map((e) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  NeumorphicText(
                                    e.key
                                            .toString()
                                            .toUpperCase()
                                            .contains("ERROR")
                                        ? "OBSERVACIÓN"
                                        : e.key.toString().toUpperCase() + ": ",
                                    style: const NeumorphicStyle(
                                      color: kSecondaryColor,
                                    ),
                                    textStyle: NeumorphicTextStyle(
                                      fontFamily: 'CronosSPro',
                                      fontSize: 16,
                                    ),
                                  ),
                                  Expanded(
                                    child: NeumorphicText(
                                      e.value.toString() == 'null'
                                          ? ""
                                          : e.value.toString().toUpperCase(),
                                      style: const NeumorphicStyle(
                                        color: kSecondaryColor,
                                      ),
                                      textStyle: NeumorphicTextStyle(
                                        fontFamily: 'CronosLPro',
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: NeumorphicButton(
                      style: const NeumorphicStyle(
                        shape: NeumorphicShape.concave,
                        lightSource: LightSource.topLeft,
                        oppositeShadowLightSource: true,
                        shadowLightColorEmboss: kSecondaryColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: NeumorphicText(
                        "Cerrar",
                        style: const NeumorphicStyle(
                          color: kSecondaryColor,
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontFamily: 'CronosLPro',
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
