import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/pages/detalle_ot_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../models/models.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({Key? key}) : super(key: key);

  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  DateTime _selectedDate = DateTime.now();
  DatePickerController controlador = DatePickerController();
  late AgendaBloc planningBloc;
  late OTStepBloc _stepsBloc;
  TextEditingController editingController = TextEditingController();
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  var items = <Agenda>[];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_Es', null);
    planningBloc = BlocProvider.of<AgendaBloc>(context);
    _stepsBloc = BlocProvider.of<OTStepBloc>(context);
    planningBloc.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeumorphicAppBar(
        centerTitle: true,
        title: NeumorphicText(
          "Mi Agenda",
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
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(
            height: 10,
          ),
          _showNodos(),
        ],
      ),
    );
  }

  _showNodos() {
    return Expanded(
      child: SmartRefresher(
        enablePullDown: true,
        controller: _refreshController,
        //physics: const BouncingScrollPhysics(),
        onRefresh: () async {
          await planningBloc.actualizarAgendaDiaria(
            fecha: _selectedDate,
          );

          _refreshController.refreshCompleted();
        },
        child: BlocBuilder<AgendaBloc, AgendaState>(
          builder: (context, state) {
            if (!state.otsActualizadas) {
              return const Center(child: CircularProgressIndicator());
            }
            items = state.ots
                .where((ot) =>
                    DateFormat('dd-MM-yyyy').format(ot.fecha!) ==
                    DateFormat('dd-MM-yyyy').format(_selectedDate))
                .toList();
            return ListView.builder(
                itemCount: items.length,
                shrinkWrap: true,
                padding: const EdgeInsets.all(12),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (_, index) {
                  final ots = items[index];

                  return NeumorphicButton(
                    style: NeumorphicStyle(
                      depth: (ots.estado
                                  .toString()
                                  .toUpperCase()
                                  .contains("CANCELADO") ||
                              ots.estado
                                  .toString()
                                  .toUpperCase()
                                  .contains("FALLID"))
                          ? 0
                          : 12,
                    ),
                    onPressed: () {
                      _stepsBloc.add(
                        OnCambiarOT(
                          ot: [
                            ots,
                          ],
                        ),
                      );
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DetalleOtPage(),
                          ));
                    },
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(7),
                    child: SizedBox(
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Neumorphic(
                                style: NeumorphicStyle(
                                  color: (ots.estado
                                              .toString()
                                              .toUpperCase()
                                              .contains("CANCELADO") ||
                                          ots.estado
                                              .toString()
                                              .toUpperCase()
                                              .contains("FALLID"))
                                      ? Colors.grey[300]
                                      : ots.estado
                                              .toString()
                                              .toUpperCase()
                                              .contains("FINALIZADO")
                                          ? kSecondaryColor.withOpacity(0.8)
                                          : kPrimaryColor,
                                  depth: (ots.estado
                                              .toString()
                                              .toUpperCase()
                                              .contains("CANCELADO") ||
                                          ots.estado
                                              .toString()
                                              .toUpperCase()
                                              .contains("FALLID"))
                                      ? -10
                                      : ots.estado
                                              .toString()
                                              .toUpperCase()
                                              .contains("FINALIZADO")
                                          ? 0
                                          : 12,
                                ),
                                child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      NeumorphicText(
                                        ots.ot.toString(),
                                        style: const NeumorphicStyle(
                                          color: Colors.white,
                                        ),
                                        textStyle: NeumorphicTextStyle(
                                          fontFamily: 'CronosSPro',
                                          fontSize: 18,
                                        ),
                                      ),
                                      NeumorphicText(
                                        "No. OT",
                                        style: const NeumorphicStyle(
                                          color: kFourColor,
                                        ),
                                        textStyle: NeumorphicTextStyle(
                                          fontFamily: 'CronosSPro',
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        NeumorphicText(
                                          "Hora Cita: ",
                                          style: NeumorphicStyle(
                                            color: kSecondaryColor
                                                .withOpacity(0.6),
                                          ),
                                          textStyle: NeumorphicTextStyle(
                                            fontFamily: 'CronossPro',
                                            fontSize: 16,
                                          ),
                                        ),
                                        NeumorphicText(
                                          DateFormat('hh:mm a')
                                              .format(ots.fecha!),
                                          style: const NeumorphicStyle(
                                            color: kFourColor,
                                          ),
                                          textStyle: NeumorphicTextStyle(
                                            fontFamily: 'CronosLPro',
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        NeumorphicText(
                                          "Cliente: ",
                                          style: NeumorphicStyle(
                                            color: kSecondaryColor
                                                .withOpacity(0.6),
                                          ),
                                          textStyle: NeumorphicTextStyle(
                                            fontFamily: 'CronossPro',
                                            fontSize: 16,
                                          ),
                                        ),
                                        NeumorphicText(
                                          ots.cliente.toString(),
                                          style: const NeumorphicStyle(
                                            color: kFourColor,
                                          ),
                                          textStyle: NeumorphicTextStyle(
                                            fontFamily: 'CronosLPro',
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        NeumorphicText(
                                          "Nombre: ",
                                          style: NeumorphicStyle(
                                            color: kSecondaryColor
                                                .withOpacity(0.6),
                                          ),
                                          textStyle: NeumorphicTextStyle(
                                            fontFamily: 'CronossPro',
                                            fontSize: 16,
                                          ),
                                        ),
                                        Flexible(
                                          child: NeumorphicText(
                                            ots.nombreCliente.toString() ==
                                                    'null'
                                                ? ""
                                                : ots.nombreCliente.toString(),
                                            style: const NeumorphicStyle(
                                              color: kFourColor,
                                            ),
                                            textStyle: NeumorphicTextStyle(
                                              fontFamily: 'CronosLPro',
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        NeumorphicText(
                                          "Nodo: ",
                                          style: NeumorphicStyle(
                                            color: kSecondaryColor
                                                .withOpacity(0.6),
                                          ),
                                          textStyle: NeumorphicTextStyle(
                                            fontFamily: 'CronossPro',
                                            fontSize: 16,
                                          ),
                                        ),
                                        NeumorphicText(
                                          ots.nodo.toString() == 'null'
                                              ? ""
                                              : ots.nodo.toString(),
                                          style: const NeumorphicStyle(
                                            color: kFourColor,
                                          ),
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
                            ],
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Text(
                              ots.estado.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'CronosLPro',
                                color: kPrimaryColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }

  _addDateBar() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controlador.animateToDate(
        _selectedDate,
        curve: Curves.easeInOut,
      );
    });

    return Container(
      margin: const EdgeInsets.only(
        top: 20,
        left: 15,
        right: 15,
      ),
      child: Neumorphic(
        style: const NeumorphicStyle(
          shape: NeumorphicShape.convex,
          depth: 15,
        ),
        child: DatePicker(
          DateTime(DateTime.now().year, DateTime.now().month),
          height: 100,
          width: 80,
          controller: controlador,
          initialSelectedDate: _selectedDate,
          locale: 'es_ES',
          daysCount: 40,
          selectionColor: kSecondaryColor,
          selectedTextColor: Colors.white,
          dateTextStyle: const TextStyle(
            fontSize: 24,
            fontFamily: 'CronosPro',
            fontWeight: FontWeight.w600,
            color: kFourColor,
          ),
          dayTextStyle: const TextStyle(
            fontSize: 16,
            fontFamily: 'CronosPro',
            fontWeight: FontWeight.w600,
            color: kFourColor,
          ),
          monthTextStyle: const TextStyle(
            fontSize: 14,
            fontFamily: 'CronosPro',
            fontWeight: FontWeight.w600,
            color: kFourColor,
          ),
          onDateChange: (date) {
            setState(() {
              _selectedDate = date;
            });
          },
        ),
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(
        right: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              NeumorphicText(
                DateFormat.yMMMd('es_Es').format(DateTime.now()),
                style: const NeumorphicStyle(
                  color: kFourColor,
                ),
                textStyle: NeumorphicTextStyle(
                  fontFamily: 'CronosLPro',
                  fontSize: 20,
                ),
              ),
              NeumorphicText(
                "Hoy",
                style: const NeumorphicStyle(
                  color: kPrimaryColor,
                ),
                textStyle: NeumorphicTextStyle(
                  fontFamily: 'CronosSPro',
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
