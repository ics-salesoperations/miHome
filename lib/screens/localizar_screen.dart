import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:mihome_app/app_styles.dart';

import '../models/models.dart';
import 'screens.dart';

class LocalizarScreen extends StatefulWidget {
  final Agenda ot;
  final List<OTSteps> steps;
  const LocalizarScreen({
    super.key,
    required this.ot,
    required this.steps,
  });

  @override
  State<LocalizarScreen> createState() => _LocalizarScreenState();
}

class _LocalizarScreenState extends State<LocalizarScreen> {
  @override
  Widget build(BuildContext context) {
    /*String estadoActual = widget.steps.isEmpty
        ? 'PENDIENTE'
        : widget.steps.last.estadoNuevo.toString();*/

    String estadoActual = 'PENDIENTE';

    String estadoPaso =
        widget.steps.isEmpty ? '' : widget.steps.last.estado.toString();

    bool finalizado =
        widget.ot.estado.toString().toUpperCase().contains("CANCELADO") ||
            widget.ot.estado.toString().toUpperCase().contains("FALLID") ||
            widget.ot.estado.toString().toUpperCase().contains("FINALIZADO");
    return Center(
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
                    'LOCALIZAR',
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
                      !finalizado
                  ? NeumorphicText(
                      "¿Estas seguro que deseas enviar a LOCALIZAR esta ot?",
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
                          !finalizado
                      ? NeumorphicButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => ProcessingStep(
                                ot: widget.ot,
                                step: 'LOCALIZAR',
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
    );
  }
}
