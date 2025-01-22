import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../models/models.dart';
import '../widgets/widgets.dart';
import 'screens.dart';

class ActivarScreen extends StatefulWidget {
  final Agenda ot;
  final List<OTSteps> steps;
  final bool localizarFinalizado;
  final bool colillaActualizada;
  const ActivarScreen({
    super.key,
    required this.ot,
    required this.steps,
    this.localizarFinalizado = false,
    this.colillaActualizada = false,
  });

  @override
  State<ActivarScreen> createState() => _ActivarScreenState();
}

class _ActivarScreenState extends State<ActivarScreen> {
  List<EquipoInstalado> equipos = [];

  final formEquipo = FormGroup({
    'tipo': FormControl<String>(value: '', validators: [
      Validators.required,
    ]),
    'serie': FormControl<String>(value: '', validators: [
      Validators.required,
    ]),
    'retiro': FormControl<String>(value: 'NO', validators: [
      Validators.required,
    ]),
    'comentarios': FormControl<String>(value: ''),
  });

  final formActivar = FormGroup({
    'cajaAndroidTV': FormControl<String>(
      value: '0',
      disabled: true,
    ),
    'cajaDVB': FormControl<String>(
      value: '0',
      disabled: true,
    ),
    'cableModem': FormControl<String>(
      value: '0',
      disabled: true,
    ),
    'telefonia': FormControl<String>(
      value: '0',
      disabled: true,
    ),
    'extensores': FormControl<String>(
      value: '0',
      disabled: true,
    ),
    'retiros': FormControl<String>(
      value: '0',
      disabled: true,
    ),
    'ipPublica': FormControl<String>(
      value: '0',
    ),
    'nodo': FormControl<String>(
      value: '0',
      disabled: true,
    ),
    'tap': FormControl<String>(
      value: '0',
      disabled: true,
    ),
    'colilla': FormControl<String>(
      value: '0',
      disabled: true,
    ),
    'correo': FormControl<String>(
      value: '0',
    ),
    'bandSteering': FormControl<String>(
      value: '0',
    ),
    'nombreRed': FormControl<String>(
      value: '0',
    ),
    'claveRed': FormControl<String>(
      value: '0',
    ),
    'ot': FormControl<String>(
      value: '0',
      disabled: true,
    ),
    'comentarios': FormControl<String>(
      value: '',
    ),
  });

  @override
  void initState() {
    formActivar.control('ot').value = widget.ot.ot.toString();
    formActivar.control('nodo').value = widget.ot.nodo.toString();
    formActivar.control('tap').value = widget.ot.tap.toString();
    formActivar.control('colilla').value = widget.ot.colilla.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String estadoActual = widget.steps.isEmpty
        ? 'PENDIENTE'
        : widget.steps.last.estadoNuevo.toString();

    estadoActual = 'PENDIENTE';

    String estadoPaso =
        widget.steps.isEmpty ? '' : widget.steps.last.estado.toString();

    bool finalizado =
        widget.ot.estado.toString().toUpperCase().contains("CANCELADO") ||
            widget.ot.estado.toString().toUpperCase().contains("FALLID") ||
            widget.ot.estado.toString().toUpperCase().contains("FINALIZAD");

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.all(12),
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Neumorphic(
                    style: const NeumorphicStyle(
                      shape: NeumorphicShape.concave,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    child: NeumorphicText(
                      'ACTIVAR',
                      textStyle: NeumorphicTextStyle(
                        fontSize: 18,
                        fontFamily: 'CronosSPro',
                      ),
                      style: const NeumorphicStyle(
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                RespuestasTEPScreen(
                  informacion: widget.steps,
                ),
                const SizedBox(
                  height: 15,
                ),
                estadoActual == 'PENDIENTE' &&
                        estadoPaso != 'PENDIENTE' &&
                        !finalizado &&
                        widget.localizarFinalizado &&
                        widget.colillaActualizada
                    ? Neumorphic(
                        padding: const EdgeInsets.all(
                          12,
                        ),
                        child: SizedBox(
                            width: double.infinity,
                            height: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                NeumorphicText(
                                  "Agregar equipos",
                                  style: const NeumorphicStyle(
                                    color: kSecondaryColor,
                                  ),
                                  textStyle: NeumorphicTextStyle(
                                    fontFamily: 'CronosSPro',
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Expanded(
                                  child: ListView(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.only(
                                      bottom: 10,
                                    ),
                                    children: [
                                      ...equipos.map((e) {
                                        return Neumorphic(
                                          style:
                                              const NeumorphicStyle(depth: -5),
                                          padding: const EdgeInsets.all(5),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    NeumorphicText(
                                                      e.serie,
                                                      style:
                                                          const NeumorphicStyle(
                                                        color: kSecondaryColor,
                                                      ),
                                                      textStyle:
                                                          NeumorphicTextStyle(
                                                        fontSize: 14,
                                                        fontFamily:
                                                            'CronosSPro',
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: NeumorphicText(
                                                        e.tipo,
                                                        style:
                                                            const NeumorphicStyle(
                                                          color: kFourColor,
                                                        ),
                                                        textStyle:
                                                            NeumorphicTextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                              'CronosLPro',
                                                        ),
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ),
                                                    NeumorphicText(
                                                      e.retiro == 'SI'
                                                          ? ' x'
                                                          : ' +',
                                                      style: NeumorphicStyle(
                                                        color: e.retiro == 'SI'
                                                            ? kFourColor
                                                            : Colors
                                                                .greenAccent,
                                                      ),
                                                      textStyle:
                                                          NeumorphicTextStyle(
                                                        fontSize: 14,
                                                        fontFamily:
                                                            'CronosSPro',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              NeumorphicButton(
                                                onPressed: () {
                                                  setState(() {
                                                    equipos.remove(e);
                                                    List<String> series = [];
                                                    if (e.retiro == 'SI') {
                                                      series = equipos
                                                          .map((e) =>
                                                              e.retiro == 'SI'
                                                                  ? e.serie
                                                                  : 'null')
                                                          .toList()
                                                          .where((element) =>
                                                              element != 'null')
                                                          .toList();
                                                      formActivar
                                                          .control('retiros')
                                                          .value = series
                                                              .isNotEmpty
                                                          ? series.join(',')
                                                          : '0';
                                                    } else if (e.tipo ==
                                                            'CABLE MODEM' &&
                                                        e.retiro == 'NO') {
                                                      series = equipos
                                                          .map((e) => e.tipo ==
                                                                      'CABLE MODEM' &&
                                                                  e.retiro ==
                                                                      'NO'
                                                              ? e.serie
                                                              : 'null')
                                                          .toList()
                                                          .where((element) =>
                                                              element != 'null')
                                                          .toList();
                                                      formActivar
                                                          .control('cableModem')
                                                          .value = series
                                                              .isNotEmpty
                                                          ? series.join(',')
                                                          : '0';
                                                    } else if (e.tipo ==
                                                            'CAJA DVB' &&
                                                        e.retiro == 'NO') {
                                                      series = equipos
                                                          .map((e) => e.tipo ==
                                                                      'CAJA DVB' &&
                                                                  e.retiro ==
                                                                      'NO'
                                                              ? e.serie
                                                              : 'null')
                                                          .toList()
                                                          .where((element) =>
                                                              element != 'null')
                                                          .toList();
                                                      formActivar
                                                          .control('cajaDVB')
                                                          .value = series
                                                              .isNotEmpty
                                                          ? series.join(',')
                                                          : '0';
                                                    } else if (e.tipo ==
                                                            'CAJA ANDROID TV' &&
                                                        e.retiro == 'NO') {
                                                      series = equipos
                                                          .map((e) => e.tipo ==
                                                                      'CAJA ANDROID TV' &&
                                                                  e.retiro ==
                                                                      'NO'
                                                              ? e.serie
                                                              : 'null')
                                                          .toList()
                                                          .where((element) =>
                                                              element != 'null')
                                                          .toList();
                                                      formActivar
                                                          .control(
                                                              'cajaAndroidTV')
                                                          .value = series
                                                              .isNotEmpty
                                                          ? series.join(',')
                                                          : '0';
                                                    } else if (e.tipo ==
                                                            'TELEFONIA' &&
                                                        e.retiro == 'NO') {
                                                      series = equipos
                                                          .map((e) => e.tipo ==
                                                                      'TELEFONIA' &&
                                                                  e.retiro ==
                                                                      'NO'
                                                              ? e.serie
                                                              : 'null')
                                                          .toList()
                                                          .where((element) =>
                                                              element != 'null')
                                                          .toList();
                                                      formActivar
                                                          .control('telefonia')
                                                          .value = series
                                                              .isNotEmpty
                                                          ? series.join(',')
                                                          : '0';
                                                    } else if (e.tipo ==
                                                            'EXTENSOR' &&
                                                        e.retiro == 'NO') {
                                                      series = equipos
                                                          .map((e) => e.tipo ==
                                                                      'EXTENSOR' &&
                                                                  e.retiro ==
                                                                      'NO'
                                                              ? e.serie
                                                              : 'null')
                                                          .toList()
                                                          .where((element) =>
                                                              element != 'null')
                                                          .toList();
                                                      formActivar
                                                          .control('extensores')
                                                          .value = series
                                                              .isNotEmpty
                                                          ? series.join(',')
                                                          : '0';
                                                    }
                                                  });
                                                },
                                                child: NeumorphicText(
                                                  'Eliminar',
                                                  style: const NeumorphicStyle(
                                                    color: kPrimaryColor,
                                                  ),
                                                  textStyle:
                                                      NeumorphicTextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'CronosLPro',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      NeumorphicButton(
                                        onPressed: () async {
                                          await showDialog(
                                            context: context,
                                            barrierDismissible:
                                                false, // false = user must tap button, true = tap outside dialog
                                            builder:
                                                (BuildContext dialogContext) {
                                              return AgregarEquipo(
                                                form: formEquipo,
                                              );
                                            },
                                          ).then((value) {
                                            if (value != null) {
                                              EquipoInstalado eq = value;
                                              formEquipo
                                                  .control('serie')
                                                  .value = '';

                                              setState(() {
                                                equipos.add(eq);

                                                List<String> series = [];

                                                if (eq.retiro == 'SI') {
                                                  series = equipos
                                                      .map((e) =>
                                                          e.retiro == 'SI'
                                                              ? e.serie
                                                              : 'null')
                                                      .toList()
                                                      .where((element) =>
                                                          element != 'null')
                                                      .toList();
                                                  formActivar
                                                      .control('retiros')
                                                      .value = series.join(',');
                                                } else if (eq.tipo ==
                                                        'CABLE MODEM' &&
                                                    eq.retiro == 'NO') {
                                                  series = equipos
                                                      .map((e) => e.tipo ==
                                                                  'CABLE MODEM' &&
                                                              eq.retiro == 'NO'
                                                          ? e.serie
                                                          : 'null')
                                                      .toList()
                                                      .where((element) =>
                                                          element != 'null')
                                                      .toList();
                                                  formActivar
                                                      .control('cableModem')
                                                      .value = series.join(',');
                                                } else if (eq.tipo ==
                                                        'CAJA DVB' &&
                                                    eq.retiro == 'NO') {
                                                  series = equipos
                                                      .map((e) => e.tipo ==
                                                                  'CAJA DVB' &&
                                                              eq.retiro == 'NO'
                                                          ? e.serie
                                                          : 'null')
                                                      .toList()
                                                      .where((element) =>
                                                          element != 'null')
                                                      .toList();
                                                  formActivar
                                                      .control('cajaDVB')
                                                      .value = series.join(',');
                                                } else if (eq.tipo ==
                                                        'CAJA ANDROID TV' &&
                                                    eq.retiro == 'NO') {
                                                  series = equipos
                                                      .map((e) => e.tipo ==
                                                                  'CAJA ANDROID TV' &&
                                                              eq.retiro == 'NO'
                                                          ? e.serie
                                                          : 'null')
                                                      .toList()
                                                      .where((element) =>
                                                          element != 'null')
                                                      .toList();
                                                  formActivar
                                                      .control('cajaAndroidTV')
                                                      .value = series.join(',');
                                                } else if (eq.tipo ==
                                                        'TELEFONIA' &&
                                                    eq.retiro == 'NO') {
                                                  series = equipos
                                                      .map((e) => e.tipo ==
                                                                  'TELEFONIA' &&
                                                              eq.retiro == 'NO'
                                                          ? e.serie
                                                          : 'null')
                                                      .toList()
                                                      .where((element) =>
                                                          element != 'null')
                                                      .toList();
                                                  formActivar
                                                      .control('telefonia')
                                                      .value = series.join(',');
                                                } else if (eq.tipo ==
                                                        'EXTENSOR' &&
                                                    eq.retiro == 'NO') {
                                                  series = equipos
                                                      .map((e) => e.tipo ==
                                                                  'EXTENSOR' &&
                                                              eq.retiro == 'NO'
                                                          ? e.serie
                                                          : 'null')
                                                      .toList()
                                                      .where((element) =>
                                                          element != 'null')
                                                      .toList();
                                                  formActivar
                                                      .control('extensores')
                                                      .value = series.join(',');
                                                }
                                              });
                                            }
                                          });
                                        },
                                        child: NeumorphicText(
                                          'Agregar',
                                          style: const NeumorphicStyle(
                                            color: kPrimaryColor,
                                          ),
                                          textStyle: NeumorphicTextStyle(
                                            fontSize: 14,
                                            fontFamily: 'CronosLPro',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      )
                    : Container(),
                const SizedBox(
                  height: 15,
                ),
                estadoActual == 'PENDIENTE' &&
                        estadoPaso != 'PENDIENTE' &&
                        !finalizado &&
                        widget.localizarFinalizado &&
                        widget.colillaActualizada
                    ? ReactiveForm(
                        formGroup: formActivar,
                        child: Column(
                          children: const [
                            SOTextFieldCustom(
                              campo: 'ot',
                              label: 'Número de OT',
                              readOnly: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SOTextFieldCustom(
                              campo: 'nodo',
                              label: 'Nodo',
                              readOnly: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SOTextFieldCustom(
                              campo: 'tap',
                              label: 'TAP',
                              readOnly: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SOTextFieldCustom(
                              campo: 'colilla',
                              label: 'Colilla',
                              readOnly: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SOTextFieldCustom(
                              campo: 'cableModem',
                              label: 'Series de Cable Modems',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SOTextFieldCustom(
                              campo: 'cajaDVB',
                              label: 'Series de Cajas DVB',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SOTextFieldCustom(
                              campo: 'cajaAndroidTV',
                              label: 'Series de Cajas Android TV',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SOTextFieldCustom(
                              campo: 'telefonia',
                              label: 'Ingrese series de Telefonía',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SOTextFieldCustom(
                              campo: 'extensores',
                              label: 'Extensores',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SOTextFieldCustom(
                              campo: 'retiros',
                              label: 'Equipos retirados',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SOTextFieldCustom(
                              campo: 'ipPublica',
                              label: 'IP Pública',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SOTextFieldCustom(
                              campo: 'correo',
                              label: 'Correo',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SOTextFieldCustom(
                              campo: 'bandSteering',
                              label: 'Band Steering',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SOTextFieldCustom(
                              campo: 'nombreRed',
                              label: 'Nombre de la Red',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SOTextFieldCustom(
                              campo: 'claveRed',
                              label: 'Clave de la Red',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SOTextFieldMultilineCustom(
                              campo: 'comentarios',
                              label: 'Comentarios',
                            ),
                          ],
                        ),
                      )
                    : Container(),
                const SizedBox(
                  height: 10,
                ),
                estadoActual == 'PENDIENTE' &&
                        estadoPaso != 'PENDIENTE' &&
                        !finalizado &&
                        widget.localizarFinalizado &&
                        widget.colillaActualizada
                    ? NeumorphicText(
                        "¿Estas seguro que deseas enviar a ACTIVAR esta ot?",
                        textStyle: NeumorphicTextStyle(
                          fontSize: 16,
                          fontFamily: 'CronosLPro',
                        ),
                        style: const NeumorphicStyle(
                          color: kSecondaryColor,
                        ),
                      )
                    : Container(),
                !widget.localizarFinalizado && !finalizado
                    ? NeumorphicText(
                        "¿Para poder ACTIVAR es necesario LOCALIZAR previamente.?",
                        textStyle: NeumorphicTextStyle(
                          fontSize: 16,
                          fontFamily: 'CronosLPro',
                        ),
                        style: const NeumorphicStyle(
                          color: kSecondaryColor,
                        ),
                      )
                    : Container(),
                !widget.colillaActualizada && estadoActual == 'PENDIENTE'
                    ? NeumorphicText(
                        "¿Para poder ACTIVAR es necesario ASOCIAR la colilla del cliente previamente.?",
                        textStyle: NeumorphicTextStyle(
                          fontSize: 16,
                          fontFamily: 'CronosLPro',
                        ),
                        style: const NeumorphicStyle(
                          color: kSecondaryColor,
                        ),
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    estadoActual == 'PENDIENTE' &&
                            estadoPaso != 'PENDIENTE' &&
                            !finalizado &&
                            widget.localizarFinalizado &&
                            widget.colillaActualizada
                        ? NeumorphicButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => ProcessingStep(
                                  ot: widget.ot,
                                  formulario: formActivar,
                                  step: 'ACTIVAR',
                                  equipos: equipos,
                                ),
                              ).then((value) {
                                Navigator.pop(context);
                              });
                            },
                            child: NeumorphicText(
                              "Confirmar",
                              textStyle: NeumorphicTextStyle(
                                fontSize: 16,
                                fontFamily: 'CronosLPro',
                              ),
                              style: const NeumorphicStyle(
                                color: kSecondaryColor,
                              ),
                            ),
                          )
                        : Container(),
                    estadoActual == 'PENDIENTE'
                        ? const SizedBox(
                            width: 20,
                          )
                        : Container(),
                    NeumorphicButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: NeumorphicText(
                        "Salir",
                        textStyle: NeumorphicTextStyle(
                          fontSize: 16,
                          fontFamily: 'CronosLPro',
                        ),
                        style: const NeumorphicStyle(
                          color: kSecondaryColor,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AgregarEquipo extends StatelessWidget {
  final FormGroup form;

  const AgregarEquipo({
    Key? key,
    required this.form,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    NeumorphicText(
                      'Agregar Equipo',
                      style: const NeumorphicStyle(
                        color: kSecondaryColor,
                      ),
                      textStyle: NeumorphicTextStyle(
                        fontSize: 18,
                        fontFamily: 'CronosSPro',
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ReactiveForm(
                      formGroup: form,
                      child: Column(
                        children: [
                          const SOSeleccionUnicaFieldCustom(
                            campo: 'tipo',
                            label: 'Tipo',
                            listaValores:
                                'CABLE MODEM,CAJA DVB,CAJA ANDROID TV,TELEFONIA,EXTENSOR',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SOScannerFieldCustom(
                            campo: 'serie',
                            label: 'Serie',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SOSeleccionUnicaFieldCustom(
                            campo: 'retiro',
                            label: '¿Es Retiro?',
                            listaValores: 'SI,NO',
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SOTextFieldMultilineCustom(
                            campo: 'comentarios',
                            label: 'Comentarios',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ReactiveFormConsumer(
                                builder: (context, form, child) {
                                  return NeumorphicButton(
                                    child: const Text(
                                      'Confirmar',
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontFamily: 'CronosSPro',
                                        fontSize: 16,
                                      ),
                                    ),
                                    onPressed: !form.valid
                                        ? null
                                        : () {
                                            final EquipoInstalado eq =
                                                EquipoInstalado(
                                              tipo: form
                                                  .control('tipo')
                                                  .value
                                                  .toString(),
                                              serie: form
                                                  .control('serie')
                                                  .value
                                                  .toString(),
                                              retiro: form
                                                  .control('retiro')
                                                  .value
                                                  .toString(),
                                              comentarios: form
                                                  .control('comentarios')
                                                  .value
                                                  .toString(),
                                            );
                                            Navigator.of(context).pop(
                                              eq,
                                            ); // Dismiss alert dialog
                                          },
                                  );
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              NeumorphicButton(
                                child: const Text(
                                  'Salir',
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontFamily: 'CronosSPro',
                                    fontSize: 16,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Dismiss alert dialog
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
