import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/models/models.dart';
import 'package:mihome_app/widgets/widgets.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SophiaConsultaOtScreen extends StatefulWidget {
  const SophiaConsultaOtScreen({Key? key}) : super(key: key);

  @override
  _SophiaConsultaOtScreenState createState() => _SophiaConsultaOtScreenState();
}

class _SophiaConsultaOtScreenState extends State<SophiaConsultaOtScreen>
    with TickerProviderStateMixin {
  late SophiaBloc _sophiaBloc;

  final form = FormGroup({
    'ot': FormControl<String>(
      value: '',
      validators: [
        Validators.required,
      ],
    ),
  });

  @override
  void initState() {
    super.initState();

    _sophiaBloc = BlocProvider.of<SophiaBloc>(context);
    _sophiaBloc.cargarOts();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        body: SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(ctx).padding.top + 15,
          left: 15,
          right: 15,
        ),
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
                  color: kFourColor,
                ),
              ),
            ),
            Center(
              child: Text(
                "Consultar OT",
                style: TextStyle(
                  color: kSecondaryColor.withOpacity(0.6),
                  fontFamily: 'CronosSPro',
                  fontSize: 22,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: BlocBuilder<SophiaBloc, SophiaState>(
                  builder: (context, state) {
                    final cerradas = state.listaOts.fold<double>(0,
                        (previousValue, element) {
                      final valor = element.esFinalizado ?? 0;
                      return previousValue + valor;
                    });

                    final subscritas = state.listaOts.fold<double>(0,
                        (previousValue, element) {
                      final valor = element.estaSubscrito ?? 0;
                      return previousValue + valor;
                    });

                    List<ConsultaOt> listaConsultas = [];

                    if (state.filtrarCerradas ||
                        state.filtrarPendientes ||
                        state.filtrarSubs) {
                      listaConsultas = state.listaFiltradas;
                    } else {
                      listaConsultas = state.listaOts;
                    }

                    return Column(
                      children: [
                        Neumorphic(
                          style: const NeumorphicStyle(
                            color: Colors.transparent,
                            depth: 5,
                          ),
                          padding: const EdgeInsets.only(
                            top: 8,
                            left: 8,
                            right: 8,
                            bottom: 0,
                          ),
                          child: ReactiveForm(
                            formGroup: form,
                            child: Column(
                              children: [
                                const SONumberCustom(
                                  campo: 'ot',
                                  label: 'Ingrese el número de OT',
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                state.actualizandoOt
                                    ? const Center(
                                        child: SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: CircularProgressIndicator(
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                      )
                                    : ReactiveFormConsumer(
                                        key: const Key('consultar'),
                                        builder: (context, form, _) =>
                                            NeumorphicButton(
                                          padding: const EdgeInsets.all(8),
                                          style: const NeumorphicStyle(
                                            depth: 3,
                                            color: Colors.transparent,
                                          ),
                                          onPressed: !form.valid
                                              ? null
                                              : () async {
                                                  await _sophiaBloc.consultarOt(
                                                    ConsultaOt(
                                                        ot: int.parse(form
                                                                .control('ot')
                                                                .value ??
                                                            0)),
                                                  );
                                                  await _sophiaBloc.cargarOts();
                                                },
                                          child: Center(
                                            child: NeumorphicText(
                                              'Consultar',
                                              style: const NeumorphicStyle(
                                                color: kPrimaryColor,
                                              ),
                                              textStyle: NeumorphicTextStyle(
                                                fontFamily: 'CronosLPro',
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                const SizedBox(
                                  height: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Neumorphic(
                              style: const NeumorphicStyle(
                                color: Colors.transparent,
                                depth: 12,
                              ),
                              child: SizedBox(
                                width: 60,
                                height: 60,
                                child: Center(
                                  child: NeumorphicIcon(
                                    FontAwesomeIcons.solidFlag,
                                    style: NeumorphicStyle(
                                      color: kPrimaryColor.withOpacity(0.4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 18,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                NeumorphicText(
                                  'Resumen',
                                  style: const NeumorphicStyle(
                                    color: kFourColor,
                                  ),
                                  textStyle: NeumorphicTextStyle(
                                    fontFamily: 'CronosLPro',
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                  child: ListView(
                                    clipBehavior: Clip.none,
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      NeumorphicButton(
                                        style: NeumorphicStyle(
                                          depth: state.filtrarCerradas ? -1 : 1,
                                          color: Colors.transparent,
                                        ),
                                        padding: const EdgeInsets.all(5),
                                        onPressed: () async {
                                          await _sophiaBloc.filtrarCerradas();
                                        },
                                        child: NeumorphicText(
                                          '${cerradas.toStringAsFixed(0)} cerradas',
                                          style: const NeumorphicStyle(
                                            color: kSecondaryColor,
                                          ),
                                          textStyle: NeumorphicTextStyle(
                                            fontFamily: 'CronosLPro',
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      NeumorphicButton(
                                        style: NeumorphicStyle(
                                          depth:
                                              state.filtrarPendientes ? -1 : 1,
                                          color: Colors.transparent,
                                        ),
                                        padding: const EdgeInsets.all(5),
                                        onPressed: () async {
                                          await _sophiaBloc.filtrarPendientes();
                                        },
                                        child: NeumorphicText(
                                          '${(state.listaOts.length - cerradas).toStringAsFixed(0)} pendientes',
                                          style: const NeumorphicStyle(
                                            color: kPrimaryColor,
                                          ),
                                          textStyle: NeumorphicTextStyle(
                                            fontFamily: 'CronosLPro',
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      NeumorphicButton(
                                        style: NeumorphicStyle(
                                          depth: state.filtrarSubs ? -1 : 1,
                                          color: Colors.transparent,
                                        ),
                                        padding: const EdgeInsets.all(5),
                                        onPressed: () async {
                                          await _sophiaBloc.filtrarSubs();
                                        },
                                        child: NeumorphicText(
                                          '${subscritas.toStringAsFixed(0)}  subscritas',
                                          style: const NeumorphicStyle(
                                            color: kThirdColor,
                                          ),
                                          textStyle: NeumorphicTextStyle(
                                            fontFamily: 'CronosLPro',
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: NeumorphicText(
                            'Consultas recientes',
                            style: const NeumorphicStyle(
                              color: kFourColor,
                            ),
                            textStyle: NeumorphicTextStyle(
                              fontFamily: 'CronosLPro',
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Expanded(
                          child: Neumorphic(
                            style: const NeumorphicStyle(
                              color: Colors.transparent,
                              depth: 12,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Neumorphic(
                                          padding: const EdgeInsets.all(8),
                                          style: const NeumorphicStyle(
                                            depth: 0,
                                            color: Colors.transparent,
                                          ),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: NeumorphicText(
                                              state.listaOts.length.toString() +
                                                  " Consultas",
                                              style: const NeumorphicStyle(
                                                color: kFourColor,
                                              ),
                                              textStyle: NeumorphicTextStyle(
                                                fontFamily: 'CronosLPro',
                                                fontSize: 22,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                      ),
                                      NeumorphicButton(
                                        onPressed: () async {
                                          await _sophiaBloc.eliminarOts();
                                        },
                                        padding: const EdgeInsets.all(8),
                                        child: NeumorphicIcon(
                                          FontAwesomeIcons.trash,
                                          style: const NeumorphicStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Neumorphic(
                                    style: const NeumorphicStyle(
                                      color: Colors.transparent,
                                      depth: 22,
                                      boxShape: NeumorphicBoxShape.rect(),
                                    ),
                                    padding: const EdgeInsets.all(5),
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      clipBehavior: Clip.none,
                                      padding: const EdgeInsets.all(8),
                                      children: [
                                        ...listaConsultas
                                            .map(
                                                (e) => DetalleConsultaOt(ot: e))
                                            .toList(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class DetalleConsultaOt extends StatefulWidget {
  final ConsultaOt ot;
  const DetalleConsultaOt({
    super.key,
    required this.ot,
  });

  @override
  State<DetalleConsultaOt> createState() => _DetalleConsultaOtState();
}

class _DetalleConsultaOtState extends State<DetalleConsultaOt> {
  late SophiaBloc _sophiaBloc;

  @override
  void initState() {
    _sophiaBloc = BlocProvider.of<SophiaBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> valores = {};

    return Container(
      //height: 140,
      margin: const EdgeInsets.only(
        bottom: 15,
      ),
      /*decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(200, 200, 200, 0.3),
            width: 1,
          ),
        ),
      ),*/
      width: double.infinity,
      child: BlocBuilder<SophiaBloc, SophiaState>(
        builder: (context, state) {
          if (state.otConsultada.isNotEmpty) {
            valores = state.otConsultada.first.toJson();
          }

          return Neumorphic(
            style: NeumorphicStyle(
              color: state.otConsultada.isNotEmpty &&
                      state.otConsultada.first.ot == widget.ot.ot
                  ? kPrimaryColor.withOpacity(0.3)
                  : widget.ot.esFinalizado == 1
                      ? kFourColor.withOpacity(0.09)
                      : Colors.transparent,
              depth: 5,
            ),
            padding: const EdgeInsets.all(8),
            child: (state.actualizandoOt &&
                    state.otConsultada.isNotEmpty &&
                    state.otConsultada.first.ot == widget.ot.ot)
                ? const SizedBox(
                    height: 100,
                    child: Center(
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  )
                : Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.centerRight,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          NeumorphicText(
                            'OT',
                            style: NeumorphicStyle(
                              color: kFourColor.withOpacity(0.2),
                            ),
                            textStyle: NeumorphicTextStyle(
                              fontFamily: 'CronosPro',
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          NeumorphicText(
                            widget.ot.ot.toString(),
                            style: NeumorphicStyle(
                              color: kFourColor.withOpacity(0.2),
                            ),
                            textStyle: NeumorphicTextStyle(
                              fontFamily: 'CronosSPro',
                              fontSize: 44,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                      (state.expandirOt &&
                              state.otConsultada.isNotEmpty &&
                              state.otConsultada.first.ot == widget.ot.ot)
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ...(valores.entries).map(
                                    (e) => Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        NeumorphicText(
                                          insertSpaceBeforeCapitals(e.key)
                                                  .toUpperCase() +
                                              ":  ",
                                          style: const NeumorphicStyle(
                                            color: kFourColor,
                                          ),
                                          textStyle: NeumorphicTextStyle(
                                            fontFamily: 'CronosLPro',
                                            fontSize: 14,
                                          ),
                                        ),
                                        Flexible(
                                          child: NeumorphicText(
                                            e.value ?? "Sin Datos",
                                            style: const NeumorphicStyle(
                                              color: kSecondaryColor,
                                            ),
                                            textStyle: NeumorphicTextStyle(
                                              fontFamily: 'CronosSPro',
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OtItem(
                                    label: 'Cliente: ',
                                    value: widget.ot.cliente.toString(),
                                  ),
                                  OtItem(
                                    label: 'Tipo OT: ',
                                    value:
                                        widget.ot.descripconTipoOt.toString(),
                                  ),
                                  OtItem(
                                    label: 'Nodo: ',
                                    value: widget.ot.codigoNodo.toString(),
                                  ),
                                  OtItem(
                                    label: 'Estado SF: ',
                                    value:
                                        widget.ot.estadoFieldService.toString(),
                                    fontSize: 18,
                                    upper: true,
                                  ),
                                  OtItem(
                                    label: 'Actualizado al: ',
                                    value: DateFormat('dd/MM/yyyy HH:mm:ss')
                                        .format(widget.ot.dataUpdate!),
                                  ),
                                ],
                              ),
                            ),
                      Positioned(
                        right: 0,
                        top: -10,
                        child: Row(
                          children: [
                            NeumorphicButton(
                              style: const NeumorphicStyle(
                                color: kPrimaryColor,
                              ),
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(
                                    text: widget.ot.toString(),
                                  ),
                                ).then((value) {
                                  //only if ->
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: kSecondaryColor,
                                      duration: Duration(
                                        seconds: 1,
                                      ),
                                      content: Text(
                                        "Copiado al portapapeles",
                                        style: TextStyle(
                                          fontFamily: 'CronosLPro',
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                });
                              },
                              child: NeumorphicIcon(
                                FontAwesomeIcons.copy,
                                size: 12,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            NeumorphicButton(
                              style: NeumorphicStyle(
                                color: widget.ot.esFinalizado == 1
                                    ? kFourColor.withOpacity(0.5)
                                    : kPrimaryColor,
                                depth: 2,
                              ),
                              onPressed: widget.ot.esFinalizado == 1
                                  ? null
                                  : () async {
                                      await _sophiaBloc.consultarOt(widget.ot);
                                      await _sophiaBloc.cargarOts();
                                    },
                              child: Row(
                                children: [
                                  NeumorphicIcon(
                                    FontAwesomeIcons.rotateRight,
                                    size: 12,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            NeumorphicButton(
                              style: NeumorphicStyle(
                                color: widget.ot.esFinalizado == 1
                                    ? kFourColor.withOpacity(0.5)
                                    : widget.ot.estaSubscrito == 1
                                        ? kSecondaryColor
                                        : kPrimaryColor,
                              ),
                              onPressed: widget.ot.esFinalizado == 1
                                  ? null
                                  : () async {
                                      await _sophiaBloc.subscribirOt(
                                        widget.ot,
                                      );
                                      await _sophiaBloc.cargarOts();
                                    },
                              child: Row(
                                children: [
                                  NeumorphicIcon(
                                    FontAwesomeIcons.solidBell,
                                    size: 12,
                                    style: NeumorphicStyle(
                                      color: widget.ot.estaSubscrito == 1
                                          ? kThirdColor
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: NeumorphicButton(
                          style: const NeumorphicStyle(
                            color: kSecondaryColor,
                            depth: 2,
                          ),
                          padding: const EdgeInsets.all(10),
                          onPressed: () {
                            _sophiaBloc.add(
                              OnExpandirOt(
                                expandirOt: !state.expandirOt,
                                otConsultada: [
                                  widget.ot,
                                ],
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              NeumorphicIcon(
                                state.expandirOt
                                    ? FontAwesomeIcons.angleUp
                                    : FontAwesomeIcons.angleDown,
                                size: 12,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              NeumorphicText(
                                state.expandirOt ? "Ocultar" : "Detalle",
                                textStyle: NeumorphicTextStyle(
                                  fontFamily: 'CronosLPro',
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

String insertSpaceBeforeCapitals(String text) {
  StringBuffer result = StringBuffer();
  for (int i = 0; i < text.length; i++) {
    if (i > 0 && text[i].toUpperCase() == text[i]) {
      result.write(' ');
    }
    result.write(text[i]);
  }
  return result.toString();
}

class OtItem extends StatelessWidget {
  final String label;
  final String value;
  final bool upper;
  final double? fontSize;
  const OtItem({
    super.key,
    required this.label,
    required this.value,
    this.upper = false,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        NeumorphicText(
          label,
          style: const NeumorphicStyle(
            color: kFourColor,
          ),
          textStyle: NeumorphicTextStyle(
            fontFamily: 'CronosSPro',
            fontSize: 14,
          ),
        ),
        Flexible(
          child: NeumorphicText(
            value == 'null'
                ? 'Sin Datos'
                : upper
                    ? value.toUpperCase()
                    : value,
            style: const NeumorphicStyle(
              color: kSecondaryColor,
            ),
            textStyle: NeumorphicTextStyle(
              fontFamily: 'CronosSPro',
              fontSize: fontSize ?? 16,
            ),
          ),
        ),
      ],
    );
  }
}
