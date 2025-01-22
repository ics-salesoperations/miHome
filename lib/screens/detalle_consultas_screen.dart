import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/models/models.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
//import 'package:elegant_notification/elegant_notification.dart';

class DetalleConsultasScreen extends StatefulWidget {
  final Agenda ot;
  const DetalleConsultasScreen({
    Key? key,
    required this.ot,
  }) : super(key: key);
  @override
  _DetalleConsultasScreenState createState() => _DetalleConsultasScreenState();
}

class _DetalleConsultasScreenState extends State<DetalleConsultasScreen> {
  late FilterBloc filterBloc;
  Georreferencia geo = Georreferencia();
  late OTStepBloc _stepBloc;
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void initState() {
    filterBloc = BlocProvider.of<FilterBloc>(context);
    _stepBloc = BlocProvider.of<OTStepBloc>(context);
    filterBloc.getNodosFiltro();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    return Scaffold(
      appBar: NeumorphicAppBar(
        centerTitle: true,
        title: NeumorphicText(
          "Consultas",
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
      body: Stack(
        children: [
          SmartRefresher(
            enablePullDown: true,
            controller: _refreshController,
            onRefresh: () async {
              if (_stepBloc.state.ot.isNotEmpty) {
                await _stepBloc.actualizarOTSteps(
                  ot: widget.ot.ot.toString(),
                );
                await _stepBloc.colillaActualizada(
                  widget.ot.cliente.toString(),
                );
              }

              _refreshController.refreshCompleted();
            },
            physics: const BouncingScrollPhysics(),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: BlocBuilder<OTStepBloc, OTStepState>(
                builder: (context, state) {
                  if (state.actualizandoSteps) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final datos = state.steps
                      .where((element) => element.step == 'CONSULTAS_DESPACHO');
                  return Column(children: [
                    datos.isEmpty
                        ? const Center(
                            child: Text(
                              "No has realizado ninguna consulta.",
                              style: TextStyle(
                                fontFamily: 'CronosLPro',
                                fontSize: 16,
                                color: kFourColor,
                              ),
                            ),
                          )
                        : Container(),
                    ...datos
                        .map(
                          (e) => Column(
                            children: [
                              DateChip(
                                date: e.fecha ?? DateTime.now(),
                              ),
                              BubbleNormal(
                                text: e.gestion.toString(),
                                tail: true,
                                isSender: true,
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  color: kSecondaryColor,
                                  fontFamily: 'CronosLPro',
                                ),
                                delivered: true,
                                color: kPrimaryColor,
                              ),
                              Text(
                                DateFormat('HH:mm')
                                    .format(e.fechaFin ?? DateTime.now()),
                                style: const TextStyle(
                                  color: kFourColor,
                                  fontFamily: 'CronosLPro',
                                  fontSize: 12,
                                ),
                              ),
                              e.comentario.toString() == 'null' ||
                                      e.comentario.toString() == ''
                                  ? Container()
                                  : BubbleNormal(
                                      text: e.comentario.toString(),
                                      tail: true,
                                      isSender: false,
                                      textStyle: const TextStyle(
                                        fontSize: 18,
                                        color: kSecondaryColor,
                                        fontFamily: 'CronosLPro',
                                      ),
                                    ),
                              e.comentario.toString() == 'null' ||
                                      e.comentario.toString() == ''
                                  ? Container()
                                  : Text(
                                      DateFormat('HH:mm')
                                          .format(e.fechaFin ?? DateTime.now()),
                                      style: const TextStyle(
                                        color: kFourColor,
                                        fontFamily: 'CronosLPro',
                                        fontSize: 12,
                                      ),
                                    ),
                            ],
                          ),
                        )
                        .toList(),
                  ]);
                },
              ),
            ),
          ),
          MessageBar(
            onSend: (text) async {
              print(text);
              await _stepBloc.consultarOT(
                consulta: text,
                ot: widget.ot,
              );
            },
          ),
        ],
      ),
    );
  }
}
