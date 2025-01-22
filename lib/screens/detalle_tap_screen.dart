import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/models/models.dart';
import 'package:mihome_app/screens/screens.dart';
import 'package:mihome_app/services/db_service.dart';

import '../blocs/blocs.dart';

class DetalleTapScreen extends StatefulWidget {
  final Georreferencia geo;
  final Agenda? ot;

  const DetalleTapScreen({
    super.key,
    required this.geo,
    this.ot,
  });

  @override
  State<DetalleTapScreen> createState() => _DetalleTapScreenState();
}

class _DetalleTapScreenState extends State<DetalleTapScreen> {
  late AuthBloc authBloc;
  late GeoSearchBloc _geoBloc;
  Georreferencia geo = Georreferencia();

  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<AuthBloc>(context);
    _geoBloc = BlocProvider.of<GeoSearchBloc>(context);
    geo = _geoBloc.state.geo.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackground,
      appBar: NeumorphicAppBar(
        centerTitle: true,
        title: NeumorphicText(
          "TAP/NAP: " + geo.nombre.toString(),
          style: const NeumorphicStyle(
            color: kSecondaryColor,
            depth: 0,
          ),
          textStyle: NeumorphicTextStyle(
            fontFamily: 'CronosSPro',
            fontSize: 24,
          ),
        ),
        leading: NeumorphicButton(
          onPressed: () async {
            Navigator.pop(context);
          },
          padding: const EdgeInsets.all(12),
          style: const NeumorphicStyle(
            depth: 0,
            color: Colors.transparent,
          ),
          child: NeumorphicIcon(
            Icons.arrow_back,
            size: 26,
            style: const NeumorphicStyle(
              color: kPrimaryColor,
              depth: 0,
            ),
          ),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: GeoElementWidgetTap(
          geo: geo,
          ot: widget.ot!.copyWith(
            tap: widget.geo.nombre,
          ),
        ),
      ),
    );
  }
}

class PuertoWidget extends StatelessWidget {
  final bool ocupado;
  final bool selected;
  final VoidCallback onTap;
  final int puerto;
  final bool tieneSpliter;

  const PuertoWidget({
    super.key,
    this.ocupado = true,
    this.selected = false,
    this.tieneSpliter = false,
    required this.onTap,
    this.puerto = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Neumorphic(
                style: const NeumorphicStyle(
                  border: NeumorphicBorder(),
                  depth: -5,
                  boxShape: NeumorphicBoxShape.circle(),
                ),
                child: const SizedBox(
                  height: 60,
                  width: 60,
                ),
              ),
              Neumorphic(
                style: const NeumorphicStyle(
                  border: NeumorphicBorder(),
                  depth: 0,
                  boxShape: NeumorphicBoxShape.circle(),
                ),
                child: const SizedBox(
                  height: 45,
                  width: 45,
                ),
              ),
              NeumorphicButton(
                onPressed: onTap,
                style: NeumorphicStyle(
                  boxShape: const NeumorphicBoxShape.circle(),
                  depth: selected ? -2 : 12,
                ),
                child: SizedBox(
                  height: 12,
                  width: 12,
                  child: Align(
                    alignment: Alignment.center,
                    child: NeumorphicIcon(
                      size: selected ? 5 : 10,
                      Icons.circle,
                      style: NeumorphicStyle(
                        color: ocupado
                            ? (selected ? kThirdColor : kPrimaryColor)
                            : kFourColor,
                        depth: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 5,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NeumorphicText(
                puerto.toString().length == 1
                    ? ' ' + puerto.toString()
                    : puerto.toString(),
                style: const NeumorphicStyle(
                  color: kFourColor,
                ),
                textStyle: NeumorphicTextStyle(
                  fontFamily: 'CronosSPro',
                  fontSize: 22,
                ),
              ),
              tieneSpliter
                  ? Transform.rotate(
                      angle: 1.5708,
                      child: NeumorphicIcon(
                        Icons.call_split_sharp,
                        size: 18,
                        style: NeumorphicStyle(
                          color: kSecondaryColor.withOpacity(0.6),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}

class _RightScrew extends StatelessWidget {
  const _RightScrew();

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        border: const NeumorphicBorder(),
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(
            10,
          ),
        ),
        shape: NeumorphicShape.convex,
        depth: 5,
        lightSource: LightSource.topLeft,
      ),
      child: SizedBox(
        height: 40,
        width: 60,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: NeumorphicIcon(
              Icons.hexagon_rounded,
              style: NeumorphicStyle(
                color: Colors.grey.withOpacity(0.7),
                shape: NeumorphicShape.concave,
                boxShape: const NeumorphicBoxShape.circle(),
                depth: 5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GeoElementWidgetTap extends StatefulWidget {
  final Georreferencia geo;
  final Agenda? ot;
  const GeoElementWidgetTap({
    super.key,
    required this.geo,
    this.ot,
  });

  @override
  State<GeoElementWidgetTap> createState() => _GeoElementWidgetTapState();
}

class _GeoElementWidgetTapState extends State<GeoElementWidgetTap> {
  late GeoSearchBloc _geoBloc;
  late AuthBloc authBloc;
  late OTStepBloc _stepBloc;
  final DBService _db = DBService();
  CarouselController? listaClientesCtrl;
  int selectedIndex = 0;
  Georreferencia geoActual = Georreferencia();

  @override
  void initState() {
    _geoBloc = BlocProvider.of<GeoSearchBloc>(context);
    authBloc = BlocProvider.of<AuthBloc>(context);
    _stepBloc = BlocProvider.of<OTStepBloc>(context);
    geoActual = _geoBloc.state.geo.first;
    _geoBloc.getGeoDependencias(
      geo: geoActual,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.1,
      ),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -25,
            child: Neumorphic(
              style: NeumorphicStyle(
                border: const NeumorphicBorder(),
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.circular(
                    30,
                  ),
                ),
                shape: NeumorphicShape.convex,
                depth: 5,
                lightSource: LightSource.right,
              ),
              child: SizedBox(
                height: 100,
                width: 100,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: NeumorphicIcon(
                      Icons.hexagon_rounded,
                      style: NeumorphicStyle(
                        color: Colors.grey.withOpacity(0.7),
                        shape: NeumorphicShape.concave,
                        boxShape: const NeumorphicBoxShape.circle(),
                        depth: 5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: -30,
            top: size.height * 0.2,
            child: const _RightScrew(),
          ),
          Positioned(
            right: -30,
            top: size.height * 0.5,
            child: const _RightScrew(),
          ),
          Neumorphic(
            style: NeumorphicStyle(
              border: const NeumorphicBorder(),
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(
                  45,
                ),
              ),
              shape: NeumorphicShape.concave,
            ),
            child: SizedBox(
              height: size.height * 0.7,
              width: size.width * 0.8,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Neumorphic(
              style: NeumorphicStyle(
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.circular(
                    45,
                  ),
                ),
                shape: NeumorphicShape.convex,
                depth: -5,
              ),
              child: SizedBox(
                height: size.height * 0.7,
                width: size.width * 0.8,
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    clipBehavior: Clip.none,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BlocBuilder<GeoSearchBloc, GeoSearchState>(
                          builder: (context, state) {
                            if (state.actualizandoDep) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            List<Georreferencia> datos = state.currentDep;
                            final geo = state.geo.first;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                  geo.puertos == null
                                      ? 0
                                      : int.parse((geo.puertos! / 2)
                                          .toStringAsFixed(0)), (index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    PuertoWidget(
                                      puerto: index * 2 + 1,
                                      tieneSpliter: datos
                                              .where((element) =>
                                                  element.puerto ==
                                                  index * 2 + 1)
                                              .toList()
                                              .length >
                                          1,
                                      ocupado: datos
                                          .where((element) =>
                                              element.puerto == index * 2 + 1)
                                          .toList()
                                          .isNotEmpty,
                                      selected:
                                          _geoBloc.state.selected.isNotEmpty
                                              ? (_geoBloc.state.selected[0]
                                                          .puerto ==
                                                      (index * 2 + 1)
                                                  ? true
                                                  : false)
                                              : false,
                                      onTap: () async {
                                        final clientes = datos
                                            .where((element) =>
                                                element.puerto == index * 2 + 1)
                                            .toList();

                                        if (clientes.isNotEmpty) {
                                          _geoBloc.add(
                                            OnSelectColilla(
                                              selected: clientes,
                                            ),
                                          );
                                        } else {
                                          _stepBloc.add(
                                            const OnCambiarColillaValida(
                                              colillaValida: false,
                                            ),
                                          );

                                          await showDialog(
                                            context: context,
                                            builder: (context) =>
                                                AgregarColillaScreen(
                                              geo: geo,
                                              puerto: index * 2 + 1,
                                              ot: widget.ot,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    PuertoWidget(
                                      puerto: index * 2 + 2,
                                      tieneSpliter: datos
                                              .where((element) =>
                                                  element.puerto ==
                                                  index * 2 + 2)
                                              .toList()
                                              .length >
                                          1,
                                      ocupado: datos
                                          .where((element) =>
                                              element.puerto == index * 2 + 2)
                                          .toList()
                                          .isNotEmpty,
                                      selected:
                                          _geoBloc.state.selected.isNotEmpty
                                              ? (_geoBloc.state.selected[0]
                                                          .puerto ==
                                                      (index * 2 + 2)
                                                  ? true
                                                  : false)
                                              : false,
                                      onTap: () async {
                                        final clientes = datos
                                            .where((element) =>
                                                element.puerto == index * 2 + 2)
                                            .toList();
                                        if (clientes.isNotEmpty) {
                                          _geoBloc.add(
                                            OnSelectColilla(
                                              selected: clientes,
                                            ),
                                          );
                                        } else {
                                          _stepBloc.add(
                                            const OnCambiarColillaValida(
                                              colillaValida: false,
                                            ),
                                          );
                                          await showDialog(
                                            context: context,
                                            builder: (context) =>
                                                AgregarColillaScreen(
                                              geo: geo,
                                              puerto: index * 2 + 2,
                                              ot: widget.ot,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                );
                              }),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BlocBuilder<GeoSearchBloc, GeoSearchState>(
                          builder: (context, state) {
                            if (state.selected.isEmpty) {
                              return NeumorphicText(
                                "*Seleccione un puerto",
                                style: NeumorphicStyle(
                                  color: kThirdColor.withOpacity(0.7),
                                  depth: 0,
                                ),
                                textStyle: NeumorphicTextStyle(
                                  fontFamily: 'CronosLPro',
                                  fontSize: 16,
                                ),
                              );
                            }

                            return SizedBox(
                              height: 130,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //titulo y boton add
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      NeumorphicText(
                                        "Información del Cliente",
                                        style: const NeumorphicStyle(
                                            color: kFourColor, depth: 5),
                                        textStyle: NeumorphicTextStyle(
                                          fontFamily: 'CronosSPro',
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      NeumorphicButton(
                                        style: const NeumorphicStyle(
                                          depth: 8,
                                          boxShape: NeumorphicBoxShape.circle(),
                                        ),
                                        padding: const EdgeInsets.all(3),
                                        onPressed: () async {
                                          if (_geoBloc.state.selected.length ==
                                              1) {
                                            final resp = await showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  const DecisionScreen(
                                                mensaje:
                                                    "Este puerto ya tiene un cliente asignado, ¿Existe un Splitter en este puerto?",
                                              ),
                                            );
                                            if (resp == false) {
                                              return;
                                            }
                                          }
                                          await showModalBottomSheet(
                                            context: context,
                                            builder: (context) =>
                                                AgregarGeoScreen(
                                              geo: _geoBloc.state.geo[0],
                                              puerto: _geoBloc.state.selected[0]
                                                      .puerto ??
                                                  0,
                                            ),
                                          ).then((resp) async {
                                            await _geoBloc.getGeoDependencias(
                                                geo: _geoBloc.state.geo[0]);

                                            final clientes = state.currentDep
                                                .where(
                                                  (element) =>
                                                      element.puerto ==
                                                      _geoBloc.state.selected[0]
                                                          .puerto,
                                                )
                                                .toList();
                                            _geoBloc.add(
                                              OnSelectColilla(
                                                selected: clientes,
                                              ),
                                            );
                                          });
                                        },
                                        child: NeumorphicIcon(
                                          Icons.add,
                                          style: const NeumorphicStyle(
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CarouselSlider(
                                    carouselController: listaClientesCtrl,
                                    options: CarouselOptions(
                                      height: 70,
                                      scrollPhysics:
                                          const BouncingScrollPhysics(),
                                      clipBehavior: Clip.none,
                                      onPageChanged:
                                          (index, carouselPageChangedReason) {
                                        //print(index);
                                        setState(() {
                                          selectedIndex = index;
                                        });
                                      },
                                    ),
                                    items: List.generate(state.selected.length,
                                        (index) {
                                      final cliente = state.selected[index];

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 2,
                                        ),
                                        child: Stack(
                                          children: [
                                            NeumorphicButton(
                                              onPressed: () async {
                                                await showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (context) =>
                                                      ModificarGeoScreen(
                                                    geo:
                                                        cliente, //_geoBloc.state
                                                    //.selected[selectedIndex],
                                                  ),
                                                ).then((value) async {
                                                  await _geoBloc
                                                      .getGeoDependencias(
                                                    geo: geoActual,
                                                  );
                                                });
                                              },
                                              style: const NeumorphicStyle(
                                                depth: 12,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  NeumorphicText(
                                                    (index + 1).toString(),
                                                    style: NeumorphicStyle(
                                                      color: kFourColor
                                                          .withOpacity(0.7),
                                                    ),
                                                    textStyle:
                                                        NeumorphicTextStyle(
                                                      fontFamily: 'CronosSPro',
                                                      fontSize: 32,
                                                    ),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          NeumorphicText(
                                                            "Colilla:  ",
                                                            style: const NeumorphicStyle(
                                                                color:
                                                                    kSecondaryColor,
                                                                depth: 5),
                                                            textStyle:
                                                                NeumorphicTextStyle(
                                                              fontFamily:
                                                                  'CronosSPro',
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                          NeumorphicText(
                                                            cliente.codigo
                                                                .toString(),
                                                            style:
                                                                NeumorphicStyle(
                                                              color: kSecondaryColor
                                                                  .withOpacity(
                                                                      0.7),
                                                              depth: 5,
                                                            ),
                                                            textStyle:
                                                                NeumorphicTextStyle(
                                                              fontFamily:
                                                                  'CronosSPro',
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          NeumorphicText(
                                                            "Cliente:  ",
                                                            style: const NeumorphicStyle(
                                                                color:
                                                                    kSecondaryColor,
                                                                depth: 5),
                                                            textStyle:
                                                                NeumorphicTextStyle(
                                                              fontFamily:
                                                                  'CronosSPro',
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                          NeumorphicText(
                                                            cliente.nombre
                                                                .toString(),
                                                            style:
                                                                NeumorphicStyle(
                                                              color: kSecondaryColor
                                                                  .withOpacity(
                                                                      0.7),
                                                              depth: 5,
                                                            ),
                                                            textStyle:
                                                                NeumorphicTextStyle(
                                                              fontFamily:
                                                                  'CronosSPro',
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              top: 10,
                                              right: 5,
                                              bottom: 10,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  NeumorphicButton(
                                                    onPressed: () async {
                                                      await showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            BuscarClienteElement(
                                                          cliente: cliente
                                                              .nombre
                                                              .toString(),
                                                        ),
                                                      );
                                                    },
                                                    style:
                                                        const NeumorphicStyle(
                                                      boxShape:
                                                          NeumorphicBoxShape
                                                              .circle(),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(1),
                                                    child: NeumorphicIcon(
                                                      FontAwesomeIcons
                                                          .circleInfo,
                                                      size: 14,
                                                      style: NeumorphicStyle(
                                                        color: kThirdColor
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ),
                                                  NeumorphicButton(
                                                    onPressed: () async {
                                                      final respuesta =
                                                          await showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            const DecisionScreen(
                                                          mensaje:
                                                              '¿Estás seguro que deseas eliminar esta dependencia?',
                                                        ),
                                                      );

                                                      if (respuesta) {
                                                        await _db
                                                            .updateInformacionGeo(
                                                                cliente
                                                                    .copyWith(
                                                          codigoPadre: "",
                                                          puerto: 0,
                                                        ));

                                                        final detalleLog =
                                                            GeorreferenciaLog(
                                                          enviado: 0,
                                                          usuarioActualiza:
                                                              authBloc
                                                                  .state
                                                                  .usuario
                                                                  .usuario,
                                                          codigoPadre: "",
                                                          puerto: 0,
                                                          codigo:
                                                              cliente.codigo,
                                                          fechaActualizacion:
                                                              DateTime.now(),
                                                          foto: cliente.foto,
                                                          latitud:
                                                              cliente.latitud,
                                                          longitud:
                                                              cliente.longitud,
                                                          nombre:
                                                              cliente.nombre,
                                                          tipo: cliente.tipo,
                                                        );

                                                        final cant = await _db
                                                            .insertarLogGeo(
                                                          detalleLog,
                                                        );

                                                        await _geoBloc
                                                            .getGeoDependencias(
                                                          geo: geoActual,
                                                        );

                                                        await _geoBloc
                                                            .enviarDatosGeoDelete(
                                                          detalleLog,
                                                        );

                                                        _geoBloc.add(
                                                          const OnSelectColilla(
                                                            selected: [],
                                                          ),
                                                        );

                                                        Fluttertoast.showToast(
                                                          msg: cant >= 1
                                                              ? "Registro Eliminado exitosamente."
                                                              : "Ocurrió un error al eliminar datos.",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor: cant >=
                                                                  1
                                                              ? kSecondaryColor
                                                              : kThirdColor,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0,
                                                        );
                                                      }
                                                    },
                                                    style:
                                                        const NeumorphicStyle(
                                                      boxShape:
                                                          NeumorphicBoxShape
                                                              .circle(),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    child: NeumorphicIcon(
                                                      Icons.delete_rounded,
                                                      size: 14,
                                                      style: NeumorphicStyle(
                                                        color:
                                                            Colors.red.shade300,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        NeumorphicButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => ModificarGeoScreen(
                                geo: geoActual,
                              ),
                            ) /*.then((value) {
                              _geoBloc.add(
                                OnNewPlacesFoundEvent(
                                  geo: [geoActual],
                                ),
                              );
                            })*/
                                ;
                          },
                          style: const NeumorphicStyle(
                            color: kThirdColor,
                          ),
                          child: SizedBox(
                            height: 100,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                clipBehavior: Clip.none,
                                child:
                                    BlocBuilder<GeoSearchBloc, GeoSearchState>(
                                  builder: (context, state) {
                                    if (state.actualizandoDep) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    final geoActual = state.geo.first;
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            NeumorphicText(
                                              "Código:  ",
                                              style: const NeumorphicStyle(
                                                  color: kSecondaryColor,
                                                  depth: 5),
                                              textStyle: NeumorphicTextStyle(
                                                fontFamily: 'CronosSPro',
                                                fontSize: 18,
                                              ),
                                            ),
                                            NeumorphicText(
                                              geoActual.codigo.toString(),
                                              style: NeumorphicStyle(
                                                color: kSecondaryColor
                                                    .withOpacity(0.7),
                                                depth: 5,
                                              ),
                                              textStyle: NeumorphicTextStyle(
                                                fontFamily: 'CronosSPro',
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            NeumorphicText(
                                              "Nombre:  ",
                                              style: const NeumorphicStyle(
                                                  color: kSecondaryColor,
                                                  depth: 5),
                                              textStyle: NeumorphicTextStyle(
                                                fontFamily: 'CronosSPro',
                                                fontSize: 18,
                                              ),
                                            ),
                                            NeumorphicText(
                                              geoActual.nombre.toString(),
                                              style: NeumorphicStyle(
                                                color: kSecondaryColor
                                                    .withOpacity(0.7),
                                                depth: 5,
                                              ),
                                              textStyle: NeumorphicTextStyle(
                                                fontFamily: 'CronosSPro',
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            NeumorphicText(
                                              "Puertos:  ",
                                              style: const NeumorphicStyle(
                                                  color: kSecondaryColor,
                                                  depth: 5),
                                              textStyle: NeumorphicTextStyle(
                                                fontFamily: 'CronosSPro',
                                                fontSize: 18,
                                              ),
                                            ),
                                            NeumorphicText(
                                              geoActual.puertos == null
                                                  ? '0'
                                                  : geoActual.puertos
                                                      .toString(),
                                              style: NeumorphicStyle(
                                                color: kSecondaryColor
                                                    .withOpacity(0.7),
                                                depth: 5,
                                              ),
                                              textStyle: NeumorphicTextStyle(
                                                fontFamily: 'CronosSPro',
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            NeumorphicText(
                                              "Padre:  ",
                                              style: const NeumorphicStyle(
                                                  color: kSecondaryColor,
                                                  depth: 5),
                                              textStyle: NeumorphicTextStyle(
                                                fontFamily: 'CronosSPro',
                                                fontSize: 18,
                                              ),
                                            ),
                                            NeumorphicText(
                                              geoActual.codigoPadre.toString(),
                                              style: NeumorphicStyle(
                                                color: kSecondaryColor
                                                    .withOpacity(0.7),
                                                depth: 5,
                                              ),
                                              textStyle: NeumorphicTextStyle(
                                                fontFamily: 'CronosSPro',
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
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
          ),
          /*Positioned(
            bottom: -11,
            child: NeumorphicButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AuditoriaScreen(
                    geo: geo,
                  ),
                );
              },
              child: Row(
                children: [
                  NeumorphicIcon(
                    FontAwesomeIcons.clipboardCheck,
                    size: 16,
                    style: const NeumorphicStyle(
                      color: kPrimaryColor,
                      depth: 0,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  NeumorphicText(
                    'Auditoría',
                    style:
                        const NeumorphicStyle(color: kSecondaryColor, depth: 0),
                    textStyle: NeumorphicTextStyle(
                      fontFamily: 'CronosLPro',
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            ),
          ),
        */

          Positioned(
            bottom: 30,
            right: 30,
            child: NeumorphicButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TapSaturadoScreen(
                      ot: widget.ot!,
                      idForm: "56",
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  NeumorphicIcon(
                    style: const NeumorphicStyle(
                      color: kSecondaryColor,
                    ),
                    Icons.battery_full,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  NeumorphicText(
                    "¿Tap Saturado?",
                    style: const NeumorphicStyle(
                      color: kPrimaryColor,
                    ),
                    textStyle: NeumorphicTextStyle(
                      fontFamily: 'CronosLPro',
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
