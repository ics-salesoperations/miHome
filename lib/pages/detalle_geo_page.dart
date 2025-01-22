import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/models/models.dart';
import 'package:mihome_app/screens/screens.dart';
import 'package:mihome_app/services/db_service.dart';

import '../blocs/blocs.dart';

class DetalleGeoPage extends StatefulWidget {
  const DetalleGeoPage({
    super.key,
  });

  @override
  State<DetalleGeoPage> createState() => _DetalleGeoPageState();
}

class _DetalleGeoPageState extends State<DetalleGeoPage> {
  late GeoSearchBloc _geoBloc;
  late AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
    _geoBloc = BlocProvider.of<GeoSearchBloc>(context);
    authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackground,
      appBar: NeumorphicAppBar(
        centerTitle: true,
        title: NeumorphicText(
          "Detalle",
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
            if (_geoBloc.state.historyNav.length > 1) {
              List<Georreferencia> hist = _geoBloc.state.historyNav;
              hist.removeLast();

              _geoBloc.add(
                OnNewPlacesFoundEvent(
                  geo: [
                    _geoBloc.state.historyNav.last,
                  ],
                ),
              );

              await _geoBloc.getGeoDependencias(
                geo: _geoBloc.state.historyNav.last,
              );

              _geoBloc.add(OnChangeNavHist(
                geo: hist,
              ));
            }
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
        child: BlocBuilder<GeoSearchBloc, GeoSearchState>(
          builder: (context, state) {
            if (state.geo.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final geo = state.geo[0];
            return geo.tipo != 'TAP'
                ? GeoElementWidget(
                    geo: geo,
                  )
                : GeoElementWidgetTap(
                    geo: geo,
                  );
          },
        ),
      ),
      bottomNavigationBar: _geoBloc.state.geo[0].tipo == 'TAP'
          ? null
          : Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
              ),
              child: NeumorphicFloatingActionButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => AgregarGeoScreen(
                      geo: _geoBloc.state.geo[0],
                    ),
                  );
                },
                child: Center(
                  child: NeumorphicIcon(
                    Icons.add,
                  ),
                ),
                style: const NeumorphicStyle(
                  color: kPrimaryColor,
                  shape: NeumorphicShape.convex,
                  boxShape: NeumorphicBoxShape.circle(),
                ),
                tooltip: "Agregar nueva dependencia",
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

class GeoElementWidget extends StatefulWidget {
  final Georreferencia geo;
  const GeoElementWidget({
    super.key,
    required this.geo,
  });

  @override
  State<GeoElementWidget> createState() => _GeoElementWidgetState();
}

class _GeoElementWidgetState extends State<GeoElementWidget> {
  late GeoSearchBloc _geoBloc;
  late AuthBloc authBloc;
  final DBService _db = DBService();

  @override
  void initState() {
    _geoBloc = BlocProvider.of<GeoSearchBloc>(context);
    authBloc = BlocProvider.of<AuthBloc>(context);
    _geoBloc.getGeoDependencias(
      geo: widget.geo,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Neumorphic(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                height: 110,
                width: width * 0.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NeumorphicText(
                      widget.geo.tipo.toString().toUpperCase(),
                      textStyle: NeumorphicTextStyle(
                        fontFamily: 'CronosSPro',
                        fontSize: 18,
                      ),
                      style: const NeumorphicStyle(
                        color: kPrimaryColor,
                      ),
                    ),
                    widget.geo.foto.toString() == "null" ||
                            widget.geo.foto == null
                        ? Image.asset(
                            'assets/images/nodo.png',
                            height: 80,
                          )
                        : SizedBox(
                            height: 80,
                            child: InstaImageViewer(
                              child: Image(
                                image: Image.memory(
                                  base64.decode(
                                    widget.geo.foto!,
                                  ),
                                ).image,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            NeumorphicButton(
              padding: const EdgeInsets.all(12),
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => ModificarGeoScreen(
                    geo: widget.geo,
                  ),
                );
              },
              child: SizedBox(
                height: 120,
                width: width * 0.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NeumorphicText(
                      widget.geo.codigo.toString().toUpperCase(),
                      textStyle: NeumorphicTextStyle(
                        fontFamily: 'CronosLPro',
                        fontSize: 16,
                      ),
                      style: const NeumorphicStyle(
                        color: kPrimaryColor,
                      ),
                    ),
                    NeumorphicText(
                      widget.geo.nombre.toString().toUpperCase(),
                      textStyle: NeumorphicTextStyle(
                        fontFamily: 'CronosSPro',
                        fontSize: 18,
                      ),
                      style: const NeumorphicStyle(
                        color: kSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 35,
        ),
        SizedBox(
          height: 30,
          child: NeumorphicText(
            "Dependencias",
            textStyle: NeumorphicTextStyle(
              fontFamily: 'CronosSPro',
              fontSize: 18,
            ),
            style: const NeumorphicStyle(
              color: kFourColor,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(
          child: Container(
            height: 400,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: BlocBuilder<GeoSearchBloc, GeoSearchState>(
              builder: (context, state) {
                if (state.actualizandoDep) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<Georreferencia> datos = state.currentDep;
                datos = datos
                    .map(
                      (e) => e.copyWith(
                        distancia: (e.latitud == null ||
                                e.longitud == null ||
                                widget.geo.latitud == null ||
                                widget.geo.longitud == null)
                            ? 0
                            : Geolocator.distanceBetween(
                                  widget.geo.latitud ?? 0,
                                  widget.geo.longitud ?? 0,
                                  e.latitud ?? 0,
                                  e.longitud ?? 0,
                                ) /
                                1000,
                      ),
                    )
                    .toList();

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  clipBehavior: Clip.none,
                  padding: const EdgeInsets.only(
                    top: 12,
                    left: 12,
                    bottom: 12,
                    right: 2,
                  ),
                  itemCount: datos.length,
                  itemBuilder: (context, index) {
                    var e = datos[index];
                    return Row(
                      children: [
                        Expanded(
                          child: NeumorphicButton(
                            margin: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            onPressed: () {
                              _geoBloc.add(
                                OnNewPlacesFoundEvent(
                                  geo: [datos[index]],
                                ),
                              );

                              _geoBloc.add(
                                OnChangeNavHist(
                                  geo: [
                                    ..._geoBloc.state.historyNav,
                                    datos[index],
                                  ],
                                ),
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DetalleGeoPage(),
                                ),
                              );
                            },
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    NeumorphicText(
                                      (e.latitud == 0 && e.longitud == 0)
                                          ? "? KM"
                                          : e.distancia!.toStringAsFixed(1) +
                                              " KM",
                                      style: const NeumorphicStyle(
                                        color: kSecondaryColor,
                                        depth: 12,
                                      ),
                                      textStyle: NeumorphicTextStyle(
                                        fontFamily: 'CronosSPro',
                                        fontSize: 16,
                                      ),
                                    ),
                                    NeumorphicIcon(
                                      Icons.route,
                                      style: const NeumorphicStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    NeumorphicText(
                                      e.tipo.toString(),
                                      textAlign: TextAlign.left,
                                      style: const NeumorphicStyle(
                                        color: kFourColor,
                                        depth: 5,
                                      ),
                                      textStyle: NeumorphicTextStyle(
                                        fontFamily: 'CronosSPro',
                                        fontSize: 16,
                                      ),
                                    ),
                                    NeumorphicText(
                                      e.nombre.toString(),
                                      style: const NeumorphicStyle(
                                        color: kFourColor,
                                        depth: 5,
                                      ),
                                      textStyle: NeumorphicTextStyle(
                                        fontFamily: 'CronosLPro',
                                        fontSize: 16,
                                      ),
                                    ),
                                    NeumorphicText(
                                      e.codigo.toString(),
                                      style: const NeumorphicStyle(
                                        color: kFourColor,
                                        depth: 5,
                                      ),
                                      textStyle: NeumorphicTextStyle(
                                        fontFamily: 'CronosLPro',
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                NeumorphicIcon(
                                  e.latitud == 0
                                      ? Icons.location_off
                                      : Icons.location_on,
                                  style: NeumorphicStyle(
                                    color: e.latitud == 0
                                        ? kFourColor
                                        : kThirdColor,
                                    depth: 12,
                                    boxShape: const NeumorphicBoxShape.circle(),
                                    shape: NeumorphicShape.convex,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        NeumorphicButton(
                          padding: const EdgeInsets.all(8),
                          style: const NeumorphicStyle(
                            boxShape: NeumorphicBoxShape.circle(),
                            shape: NeumorphicShape.convex,
                          ),
                          onPressed: () async {
                            final respuesta = await showDialog(
                              context: context,
                              builder: (context) => const DecisionScreen(
                                mensaje:
                                    '¿Estás seguro que deseas eliminar esta dependencia?',
                              ),
                            );

                            if (respuesta) {
                              await _db.updateInformacionGeo(
                                  e.copyWith(codigoPadre: ""));

                              final detalleLog = GeorreferenciaLog(
                                enviado: 0,
                                usuarioActualiza:
                                    authBloc.state.usuario.usuario,
                                codigoPadre: "",
                                codigo: e.codigo,
                                fechaActualizacion: DateTime.now(),
                                foto: e.foto,
                                latitud: e.latitud,
                                longitud: e.longitud,
                                nombre: e.nombre,
                                tipo: e.tipo,
                              );

                              final cant = await _db.insertarLogGeo(detalleLog);

                              await _geoBloc.getGeoDependencias(
                                geo: widget.geo,
                              );

                              await _geoBloc.enviarDatosGeoDelete(detalleLog);

                              Fluttertoast.showToast(
                                msg: cant >= 1
                                    ? "Registro Eliminado exitosamente."
                                    : "Ocurrió un error al eliminar datos.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor:
                                    cant >= 1 ? kSecondaryColor : kThirdColor,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          },
                          child: NeumorphicIcon(
                            Icons.delete,
                            style: const NeumorphicStyle(
                              color: kSecondaryColor,
                            ),
                          ),
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ),
        )
      ],
    );
  }
}

class GeoElementWidgetTap extends StatefulWidget {
  final Georreferencia geo;
  const GeoElementWidgetTap({
    super.key,
    required this.geo,
  });

  @override
  State<GeoElementWidgetTap> createState() => _GeoElementWidgetTapState();
}

class _GeoElementWidgetTapState extends State<GeoElementWidgetTap> {
  late GeoSearchBloc _geoBloc;
  late AuthBloc authBloc;
  final DBService _db = DBService();
  CarouselController? listaClientesCtrl;
  int selectedIndex = 0;

  @override
  void initState() {
    _geoBloc = BlocProvider.of<GeoSearchBloc>(context);
    authBloc = BlocProvider.of<AuthBloc>(context);
    _geoBloc.getGeoDependencias(
      geo: widget.geo,
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
                shape: NeumorphicShape.concave),
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
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                  widget.geo.puertos == null
                                      ? 0
                                      : int.parse((widget.geo.puertos! / 2)
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
                                          await showDialog(
                                            context: context,
                                            builder: (context) =>
                                                AgregarGeoScreen(
                                              geo: _geoBloc.state.geo[0],
                                              puerto: index * 2 + 1,
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
                                          await showDialog(
                                            context: context,
                                            builder: (context) =>
                                                AgregarGeoScreen(
                                              geo: _geoBloc.state.geo[0],
                                              puerto: index * 2 + 2,
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
                                                );
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
                                                                detalleLog);

                                                        await _geoBloc
                                                            .getGeoDependencias(
                                                          geo: widget.geo,
                                                        );

                                                        await _geoBloc
                                                            .enviarDatosGeoDelete(
                                                                detalleLog);

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
                                geo: widget.geo,
                              ),
                            ) /*.then((value) {
                              _geoBloc.add(
                                OnNewPlacesFoundEvent(
                                  geo: [widget.geo],
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
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        NeumorphicText(
                                          "Código:  ",
                                          style: const NeumorphicStyle(
                                              color: kSecondaryColor, depth: 5),
                                          textStyle: NeumorphicTextStyle(
                                            fontFamily: 'CronosSPro',
                                            fontSize: 18,
                                          ),
                                        ),
                                        NeumorphicText(
                                          widget.geo.codigo.toString(),
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
                                              color: kSecondaryColor, depth: 5),
                                          textStyle: NeumorphicTextStyle(
                                            fontFamily: 'CronosSPro',
                                            fontSize: 18,
                                          ),
                                        ),
                                        NeumorphicText(
                                          widget.geo.nombre.toString(),
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
                                              color: kSecondaryColor, depth: 5),
                                          textStyle: NeumorphicTextStyle(
                                            fontFamily: 'CronosSPro',
                                            fontSize: 18,
                                          ),
                                        ),
                                        NeumorphicText(
                                          widget.geo.puertos == null
                                              ? '0'
                                              : widget.geo.puertos.toString(),
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
                                              color: kSecondaryColor, depth: 5),
                                          textStyle: NeumorphicTextStyle(
                                            fontFamily: 'CronosSPro',
                                            fontSize: 18,
                                          ),
                                        ),
                                        NeumorphicText(
                                          widget.geo.codigoPadre.toString(),
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
          Positioned(
            bottom: -11,
            child: NeumorphicButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AuditoriaScreen(
                    geo: widget.geo,
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
        ],
      ),
    );
  }
}
