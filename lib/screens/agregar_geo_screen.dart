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

class AgregarGeoScreen extends StatefulWidget {
  final Georreferencia geo;
  final int puerto;

  const AgregarGeoScreen({
    super.key,
    required this.geo,
    this.puerto = 0,
  });

  @override
  State<AgregarGeoScreen> createState() => _AgregarGeoScreenState();
}

class _AgregarGeoScreenState extends State<AgregarGeoScreen> {
  late AuthBloc authBloc;
  final DBService _db = DBService();
  late GeoSearchBloc _geoBloc;

  FormGroup crearForm = FormGroup({
    'codigo': FormControl<String>(
      value: '',
    ),
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
  });

  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<AuthBloc>(context);
    _geoBloc = BlocProvider.of<GeoSearchBloc>(context);
    crearForm.control('codigoPadre').value = widget.geo.codigo;
    crearForm.control('tipo').value = getTipo(widget.geo.tipo.toString());
    crearForm.control('puerto').value = widget.puerto;

    if (widget.puerto > 0) {
      crearForm.control('puerto').markAsDisabled();
    }

    if (widget.geo.tipo != 'TAP') {
      crearForm.control('codigo').markAsDisabled();
      final posicion = widget.geo.codigo.toString().indexOf('-');
      if (posicion == -1) {
        crearForm.control('codigo').value = widget.geo.codigo.toString() + '-';
      } else {
        crearForm.control('codigo').value =
            widget.geo.codigo.toString().substring(0, posicion) + '-';
      }
    } else {
      crearForm.control('foto').clearValidators();
      crearForm.control('foto').reset();
    }
  }

  String getTipo(String tipoPadre) {
    switch (tipoPadre) {
      case 'NODO':
        return 'AMPLIFICADOR';
      case 'AMPLIFICADOR':
        return 'TAP';
      case 'TAP':
        return 'COLILLA';
      default:
        return 'DESCONOCIDO';
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
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ReactiveForm(
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
                            widget.geo.tipo == "TAP"
                                ? SONumberCustom(
                                    campo: 'puerto',
                                    label: 'Puerto',
                                    readOnly: widget.puerto > 0 ? true : false,
                                  )
                                : Container(),
                            const SizedBox(
                              height: 12,
                            ),
                            widget.geo.tipo == "TAP"
                                ? Row(
                                    children: [
                                      const Expanded(
                                        child: SONumberCustom(
                                          campo: 'codigo',
                                          label: 'Colilla',
                                        ),
                                      ),
                                      NeumorphicButton(
                                        style: const NeumorphicStyle(
                                          boxShape: NeumorphicBoxShape.circle(),
                                          depth: 12,
                                        ),
                                        onPressed: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (context) =>
                                                SearchGeoElement(
                                              cliente: crearForm
                                                  .control('codigo')
                                                  .value
                                                  .toString(),
                                              frm: crearForm,
                                              retornar: true,
                                              colilla: true,
                                            ),
                                          );
                                        },
                                        child: SizedBox(
                                          height: 25,
                                          width: 25,
                                          child: NeumorphicIcon(
                                            Icons.search,
                                            size: 26,
                                            style: const NeumorphicStyle(
                                              color: kFourColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : ReactiveValueListenableBuilder<String>(
                                    formControlName: 'nombre',
                                    builder: (context, control, child) {
                                      final posicion = widget.geo.codigo
                                          .toString()
                                          .indexOf('-');
                                      if (posicion == -1) {
                                        crearForm.control('codigo').value =
                                            widget.geo.codigo.toString() +
                                                '-' +
                                                control.value.toString();
                                      } else {
                                        crearForm.control('codigo').value =
                                            widget.geo.codigo
                                                    .toString()
                                                    .substring(0, posicion) +
                                                '-' +
                                                control.value.toString();
                                      }

                                      return const SOTextFieldCustom(
                                        campo: 'codigo',
                                        label: 'Código',
                                      );
                                    }),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: widget.geo.tipo == "TAP"
                                        ? const SONumberCustom(
                                            campo: 'nombre',
                                            label: 'Número de Cliente',
                                          )
                                        : const SOTextFieldCustom(
                                            campo: 'nombre',
                                            label: 'Nombre',
                                            toUpper: true,
                                          ),
                                  ),
                                ),
                                widget.geo.tipo != "TAP"
                                    ? Container()
                                    : NeumorphicButton(
                                        style: const NeumorphicStyle(
                                          boxShape: NeumorphicBoxShape.circle(),
                                          depth: 12,
                                        ),
                                        onPressed: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (context) =>
                                                SearchGeoElement(
                                              cliente: crearForm
                                                  .control('nombre')
                                                  .value
                                                  .toString(),
                                              frm: crearForm,
                                              retornar: true,
                                            ),
                                          );
                                        },
                                        child: SizedBox(
                                          height: 25,
                                          width: 25,
                                          child: NeumorphicIcon(
                                            Icons.search,
                                            size: 26,
                                            style: const NeumorphicStyle(
                                              color: kFourColor,
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
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
                            widget.geo.tipo == "TAP"
                                ? Container()
                                : Column(
                                    children: [
                                      SOPhotoCustom(
                                        campo: 'foto',
                                        label: 'Tomar Fotografía',
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
                                return NeumorphicButton(
                                  style: const NeumorphicStyle(
                                    oppositeShadowLightSource: true,
                                    lightSource: LightSource.topLeft,
                                  ),
                                  child: NeumorphicText(
                                    "Crear",
                                    style: const NeumorphicStyle(
                                      color: kSecondaryColor,
                                      lightSource: LightSource.topRight,
                                    ),
                                    textStyle: NeumorphicTextStyle(
                                      fontFamily: 'CronosLPro',
                                      fontSize: 18,
                                    ),
                                  ),
                                  onPressed: !crearForm.valid
                                      ? () async {
                                          print(crearForm.errors);
                                          crearForm.markAllAsTouched();
                                          if (widget.geo.tipo == 'TAP' &&
                                              crearForm.errors.length == 1 &&
                                              crearForm.errors
                                                  .containsKey('foto')) {
                                            await crearDependencia();
                                          }
                                        }
                                      : crearDependencia,
                                );
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
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
                    'Crear nueva dependencia',
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

class SearchGeoElement extends StatefulWidget {
  final String cliente;
  final FormGroup? frm;
  final bool retornar;
  final bool colilla;
  const SearchGeoElement({
    super.key,
    required this.cliente,
    this.frm,
    this.retornar = false,
    this.colilla = false,
  });

  @override
  State<SearchGeoElement> createState() => _SearchGeoElementState();
}

class _SearchGeoElementState extends State<SearchGeoElement> {
  late FilterBloc _filterBloc;
  late GeoSearchBloc _geoBloc;

  Georreferencia selected = Georreferencia();
  late final Future<Map<String, dynamic>> detalleCliente;

  @override
  void initState() {
    super.initState();
    _filterBloc = BlocProvider.of<FilterBloc>(context);
    _geoBloc = BlocProvider.of<GeoSearchBloc>(context);
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
                        return Center(
                          child: NeumorphicText(
                              'No existen datos asociados al cliente ${widget.cliente}, valida que este bien escrito.'),
                        );
                      }

                      final List<dynamic> lst = snapshot.data!['data'];

                      final Map<String, dynamic> datos = lst.first;

                      if (datos.keys.contains("colilla") && widget.retornar) {
                        widget.frm!.controls['codigo']!.value =
                            datos['colilla']!.toString();
                      }

                      if (datos.keys.contains("cliente") && widget.retornar) {
                        widget.frm!.controls['nombre']!.value =
                            datos['cliente']!.toString();
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
                                    e.key.toString().toUpperCase() + ": ",
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
