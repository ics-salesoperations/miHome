import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/widgets/widgets.dart';

import '../models/models.dart';
import '../screens/screens.dart';
import '../widgets/boton_azul.dart';
//import 'package:elegant_notification/elegant_notification.dart';

class BusquedaPage extends StatefulWidget {
  const BusquedaPage({Key? key}) : super(key: key);
  @override
  _BusquedaPageState createState() => _BusquedaPageState();
}

class _BusquedaPageState extends State<BusquedaPage> {
  late FilterBloc filterBloc;
  late MapBloc mapBloc;
  OT otSeleccionada = OT();

  @override
  void initState() {
    super.initState();
    filterBloc = BlocProvider.of<FilterBloc>(context);
    mapBloc = BlocProvider.of<MapBloc>(context);
    filterBloc.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: CustomPaint(
        painter: HeaderPicoPainter(),
        child: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 15,
              left: 15,
              right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_outlined,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Búsqueda",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontFamily: 'CronosSPro',
                      fontSize: 28,
                    ),
                  ),
                  Lottie.asset(
                    'assets/lottie/buscar.json',
                    width: 50,
                    height: 50,
                    animate: true,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<FilterBloc, FilterState>(
                        builder: (context, state) {
                          if (state.cargandoClientes) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          return SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Selecciona una OT",
                                  style: TextStyle(
                                    fontFamily: 'CronosLPro',
                                    fontSize: 18,
                                    color: kSecondaryColor,
                                  ),
                                ),
                                DropdownSearch<OT>(
                                  popupProps: const PopupProps.menu(
                                    showSearchBox: true,
                                    /*textStyle: TextStyle(
                                      color: kSecondaryColor,
                                      fontFamily: 'CrosnoLPro',
                                      fontSize: 30,
                                    ),*/
                                    searchFieldProps: TextFieldProps(
                                      style: TextStyle(
                                        color: kSecondaryColor,
                                        fontFamily: 'CrosnoLPro',
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  selectedItem: state.ots.isNotEmpty
                                      ? state.ots[0]
                                      : null,
                                  items:
                                      !state.cargandoOts ? state.ots : const [],
                                  itemAsString: (OT ot) =>
                                      "${ot.ot} - ${ot.cliente} - ${ot.tipoOt}",
                                  onChanged: (OT? ot) {
                                    setState(() {
                                      otSeleccionada = ot!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      Neumorphic(
                        padding: const EdgeInsets.all(8),
                        style: const NeumorphicStyle(
                          depth: 0,
                        ),
                        child: NeumorphicText(
                          'Detalle de OT',
                          style: const NeumorphicStyle(
                            color: kPrimaryColor,
                          ),
                          textAlign: TextAlign.center,
                          textStyle: NeumorphicTextStyle(
                            fontSize: 16,
                            fontFamily: 'CronosSPro',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: otSeleccionada.ot == null
                            ? const Text(
                                'Seleccione una OT.',
                                style: TextStyle(
                                  fontFamily: 'CronosLPro',
                                  fontSize: 16,
                                  color: kPrimaryColor,
                                ),
                              )
                            : Neumorphic(
                                style: const NeumorphicStyle(),
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Número de OT: ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'CronosLPro',
                                            color: kFourColor,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            otSeleccionada.ot.toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'CronosLPro',
                                              color: kSecondaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Cliente: ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'CronosLPro',
                                            color: kFourColor,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            otSeleccionada.cliente.toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'CronosLPro',
                                              color: kSecondaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Nombre Cliente: ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'CronosLPro',
                                            color: kFourColor,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            otSeleccionada.nombreCliente
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'CronosLPro',
                                              color: kSecondaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Tipo OT: ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'CronosLPro',
                                            color: kFourColor,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            otSeleccionada.tipoOt.toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'CronosLPro',
                                              color: kSecondaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Paquete: ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'CronosLPro',
                                            color: kFourColor,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            otSeleccionada.paquete.toString() ==
                                                    'null'
                                                ? "No Identificado"
                                                : otSeleccionada.paquete
                                                    .toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'CronosLPro',
                                              color: kSecondaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Fecha Cierre: ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'CronosLPro',
                                            color: kFourColor,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            DateFormat('dd/MM/yyyy HH:mm:ss')
                                                .format(otSeleccionada
                                                    .fechaCierre!),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'CronosLPro',
                                              color: kSecondaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Tecnico: ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'CronosLPro',
                                            color: kFourColor,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            otSeleccionada.nombreTecnico
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'CronosLPro',
                                              color: kSecondaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Contratista: ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'CronosLPro',
                                            color: kFourColor,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            otSeleccionada.contratista
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'CronosLPro',
                                              color: kSecondaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Departamento: ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'CronosLPro',
                                            color: kFourColor,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            otSeleccionada.departamento
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'CronosLPro',
                                              color: kSecondaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Ciudad: ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'CronosLPro',
                                            color: kFourColor,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            otSeleccionada.ciudad.toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'CronosLPro',
                                              color: kSecondaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Nodo: ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'CronosLPro',
                                            color: kFourColor,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            otSeleccionada.nodo.toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'CronosLPro',
                                              color: kSecondaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Gestionada: ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'CronosLPro',
                                            color: kFourColor,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            otSeleccionada.gestionado
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'CronosLPro',
                                              color: kSecondaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BotonAzul(
                    onPressed: otSeleccionada.ot == null ||
                            otSeleccionada.tipoOt == 'DESCONEXION'
                        ? null
                        : () async {
                            await showDialog(
                              context: context,
                              builder: (ctx) => ValidacionVisitaScreen(
                                ot: otSeleccionada,
                              ),
                            ).then(
                              (value) {
                                if (value == true) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RealizarVisitaScreen(
                                        ot: otSeleccionada,
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                            );
                          },
                    text: 'Auditoría de Materiales',
                  ),
                  BotonAzul(
                    onPressed: otSeleccionada.ot == null ||
                            otSeleccionada.tipoOt != 'DESCONEXION'
                        ? null
                        : () async {
                            await showDialog(
                              context: context,
                              builder: (ctx) => ValidacionVisitaScreen(
                                ot: otSeleccionada,
                              ),
                            ).then(
                              (value) {
                                if (value == true) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OTFormScreen(
                                        ot: otSeleccionada,
                                        idForm: '61',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                            );
                          },
                    text: 'Retiro de Acometida',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

/*
  Future<List<Dealer>> filtrarDealer(String filtro) async {
    final filterBloc = BlocProvider.of<FilterBloc>(context);
    return filterBloc.state.;
  }

  Future<List<Sucursal>> filtrarSucursal(String filtro) async {
    final filterBloc = BlocProvider.of<FilterBloc>(context);
    return filterBloc.state.sucursales;
  }

  Future<List<Circuito>> filtrarCircuito(String filtro) async {
    final filterBloc = BlocProvider.of<FilterBloc>(context);
    return filterBloc.state.circuitos;
  }

  Future<List<Planning>> filtrarPDVS(String filtro) async {
    final filterBloc = BlocProvider.of<FilterBloc>(context);
    return filterBloc.state.pdvs;
  }*/
}
