import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../models/models.dart';
import '../widgets/widgets.dart';
import 'screens.dart';

class LiquidarScreen extends StatefulWidget {
  final Agenda ot;
  final List<OTSteps> steps;
  final bool localizarFinalizado;
  final bool colillaActualizada;
  const LiquidarScreen({
    super.key,
    required this.ot,
    required this.steps,
    this.localizarFinalizado = false,
    this.colillaActualizada = false,
  });

  @override
  State<LiquidarScreen> createState() => _LiquidarScreenState();
}

class _LiquidarScreenState extends State<LiquidarScreen> {
  final formLiquidar = FormGroup({
    'ot': FormControl<String>(
      value: '0',
      disabled: true,
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
      value: '',
    ),
    'bitacora': FormControl<String>(
      validators: [Validators.required],
    ),
  });

  @override
  void initState() {
    formLiquidar.control('ot').value = widget.ot.ot.toString();
    formLiquidar.control('nodo').value = widget.ot.nodoNuevo.toString() == 'null' || widget.ot.nodoNuevo == ""
          ? widget.ot.nodo.toString()
          : widget.ot.nodoNuevo.toString();
    formLiquidar.control('tap').value = widget.ot.tapNuevo.toString() == 'null' || widget.ot.tapNuevo == ""
          ? widget.ot.tap.toString()
          : widget.ot.tapNuevo.toString();
    formLiquidar.control('colilla').value = widget.ot.colillaNueva.toString() == 'null' || widget.ot.colillaNueva == ""
          ? widget.ot.colilla.toString()
          : widget.ot.colillaNueva.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String estadoActual = widget.steps.isEmpty
        ? 'PENDIENTE'
        : widget.steps.last.estadoNuevo.toString();

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
                        'LIQUIDAR',
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
                    ? ReactiveForm(
                        formGroup: formLiquidar,
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
                              campo: 'correo',
                              label: 'Correo',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SOTextFieldMultilineCustom(
                              campo: 'bitacora',
                              label: 'Bitácora',
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
                        widget.localizarFinalizado
                    ? NeumorphicText(
                        "¿Estas seguro que deseas enviar a LIQUIDAR esta ot?",
                        textStyle: NeumorphicTextStyle(
                          fontSize: 16,
                          fontFamily: 'CronosLPro',
                        ),
                        style: const NeumorphicStyle(
                          color: kSecondaryColor,
                        ),
                      )
                    : Container(),
                !widget.localizarFinalizado
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
                        "¿Para poder LIQUIDAR es necesario ASOCIAR la colilla del cliente previamente.?",
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
                            onPressed: !formLiquidar.valid
                                ? null
                                : () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => ProcessingStep(
                                        ot: widget.ot,
                                        formulario: formLiquidar,
                                        step: 'LIQUIDAR',
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
