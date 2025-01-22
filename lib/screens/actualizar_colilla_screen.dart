import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/models/models.dart';
import 'package:mihome_app/screens/screens.dart';
import 'package:mihome_app/widgets/boton_azul.dart';

import '../services/services.dart';
//import 'package:elegant_notification/elegant_notification.dart';

class ActualizarColillaScreen extends StatefulWidget {
  final Agenda ot;
  const ActualizarColillaScreen({
    Key? key,
    required this.ot,
  }) : super(key: key);
  @override
  _ActualizarColillaScreenState createState() =>
      _ActualizarColillaScreenState();
}

class _ActualizarColillaScreenState extends State<ActualizarColillaScreen> {
  late FilterBloc filterBloc;
  Georreferencia geo = Georreferencia();
  late GeoSearchBloc _geoBloc;
  late AgendaBloc _agendaBloc;
  late OTStepBloc _stepBloc;
  DBService db = DBService();

  @override
  void initState() {
    filterBloc = BlocProvider.of<FilterBloc>(context);
    _geoBloc = BlocProvider.of<GeoSearchBloc>(context);
    _agendaBloc = BlocProvider.of<AgendaBloc>(context);
    _stepBloc = BlocProvider.of<OTStepBloc>(context);
    filterBloc.getNodosFiltro();
    if (widget.ot.nodo.toString() != 'null') {
      filterBloc.getTapsFiltro(
        nodo: widget.ot.nodo.toString(),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NeumorphicAppBar(
          centerTitle: true,
          title: NeumorphicText(
            "Actualización de Colilla",
            style: const NeumorphicStyle(
              color: kSecondaryColor,
              depth: 0,
            ),
            textStyle: NeumorphicTextStyle(
              fontFamily: 'CronosSPro',
              fontSize: 26,
            ),
          ),
          leading: NeumorphicButton(
            onPressed: () {
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
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Neumorphic(
                style: const NeumorphicStyle(
                  depth: 15,
                  shape: NeumorphicShape.convex,
                ),
                padding: const EdgeInsets.all(20),
                child: BlocBuilder<FilterBloc, FilterState>(
                  builder: (context, state) {
                    if (state.cargandoNodos) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final nodoFilter = filterBloc.state.nodosLst
                            .where((element) =>
                                element.codigo == widget.ot.nodo.toString())
                            .isEmpty
                        ? null
                        : filterBloc.state.nodosLst
                            .where((element) =>
                                element.codigo == widget.ot.nodo.toString())
                            .first;

                    final tapFilter = filterBloc.state.tapsLst
                            .where((element) =>
                                element.codigo ==
                                widget.ot.nodo.toString() +
                                    '-' +
                                    widget.ot.tap.toString())
                            .isEmpty
                        ? null
                        : filterBloc.state.tapsLst
                            .where((element) =>
                                element.codigo ==
                                widget.ot.nodo.toString() +
                                    '-' +
                                    widget.ot.tap.toString())
                            .first;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NeumorphicText(
                          "Seleccione el NODO:",
                          style: const NeumorphicStyle(
                            color: kSecondaryColor,
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontFamily: 'CronosLPro',
                            fontSize: 18,
                          ),
                        ),
                        DropdownSearch<Georreferencia>(
                          popupProps: const PopupProps.menu(
                            /*textStyle: TextStyle(
                              color: kSecondaryColor,
                              fontFamily: 'CrosnoLPro',
                              fontSize: 30,
                            ),*/
                            showSearchBox: true,
                          ),
                          selectedItem: nodoFilter,
                          asyncItems: (String nodo) => filtrarNodo(nodo),
                          itemAsString: (Georreferencia nodo) =>
                              nodo.nombre.toString(),
                          onChanged: (
                            Georreferencia? nodo,
                          ) async {
                            print("Cambiando Nodo");
                            if (nodo != null) {
                              await filterBloc.getTapsFiltro(
                                nodo: nodo.codigo.toString(),
                              );
                              final actualizada = widget.ot.copyWith(
                                nodoNuevo: nodo.codigo.toString(),
                              );

                              await db.actualizarClienteAgenda(actualizada);

                              await _agendaBloc.init();

                              print("Antes de cambiar nodo");
                              _stepBloc.add(
                                OnCambiarOT(
                                  ot: [actualizada],
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        NeumorphicText(
                          "Seleccione el TAP:",
                          style: const NeumorphicStyle(
                            color: kSecondaryColor,
                          ),
                          textStyle: NeumorphicTextStyle(
                            fontFamily: 'CronosLPro',
                            fontSize: 18,
                          ),
                        ),
                        state.cargandoTaps
                            ? const CircularProgressIndicator()
                            : DropdownSearch<Georreferencia>(
                                popupProps: const PopupProps.menu(
                                  showSearchBox: true,
                                  /*textStyle: TextStyle(
                                    color: kSecondaryColor,
                                    fontFamily: 'CrosnoLPro',
                                    fontSize: 30,
                                  ),*/
                                ),
                                selectedItem: tapFilter,
                                asyncItems: (String tap) => filtrarTaps(tap),
                                itemAsString: (Georreferencia tap) =>
                                    tap.nombre.toString(),
                                onChanged: (Georreferencia? tap) async {
                                  if (tap != null) {
                                    _geoBloc.add(
                                      OnNewPlacesFoundEvent(geo: [tap]),
                                    );

                                    final otBase = await db.leerAgendaOt(
                                        ot: widget.ot.ot ?? 0);

                                    final actualizada = otBase.first.copyWith(
                                      tapNuevo: tap.nombre.toString(),
                                    );

                                    await db
                                        .actualizarClienteAgenda(actualizada);

                                    await _agendaBloc.init();
                                    _stepBloc.add(
                                      OnCambiarOT(
                                        ot: [actualizada],
                                      ),
                                    );

                                    setState(() {
                                      geo = tap;
                                    });
                                  }
                                },
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        BotonAzul(
                          text: "Asociar Colilla",
                          onPressed: geo.codigo.toString() == "null"
                              ? null
                              : () async {
                                  final otBase = await db.leerAgendaOt(
                                      ot: widget.ot.ot ?? 0);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetalleTapScreen(
                                        geo: geo,
                                        ot: otBase.first,
                                      ),
                                    ),
                                  ).then((value) {
                                    _geoBloc.add(
                                      const OnSelectColilla(
                                        selected: [],
                                      ),
                                    );
                                  });
                                },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Future<List<Georreferencia>> filtrarNodo(String filtro) async {
    final filterBloc = BlocProvider.of<FilterBloc>(context);
    return filterBloc.state.nodosLst;
  }

  Future<List<Georreferencia>> filtrarTaps(String filtro) async {
    final filterBloc = BlocProvider.of<FilterBloc>(context);
    return filterBloc.state.tapsLst;
  }

  Future<List<Agenda>> filtrarClienteS(String filtro) async {
    final filterBloc = BlocProvider.of<FilterBloc>(context);
    return filterBloc.state.clientes;
  }
}
