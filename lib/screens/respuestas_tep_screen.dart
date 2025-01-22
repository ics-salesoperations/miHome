import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';

import '../app_styles.dart';
import '../models/models.dart';

class RespuestasTEPScreen extends StatelessWidget {
  final List<OTSteps> informacion;
  const RespuestasTEPScreen({
    super.key,
    required this.informacion,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...informacion.map((e) {
          return Neumorphic(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(5),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "FECHA: ",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'CronosSPro',
                        color: kSecondaryColor,
                      ),
                    ),
                    Text(
                      DateFormat('dd-MM-yyyy HH:mm:ss').format(e.fecha!),
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'CronosLPro',
                        color: kSecondaryColor,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    const Text(
                      "GESTION: ",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'CronosSPro',
                        color: kSecondaryColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        e.gestion.toString() == 'null'
                            ? ''
                            : e.gestion.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'CronosLPro',
                          color: kSecondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    const Text(
                      "COMENTARIO: ",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'CronosSPro',
                        color: kSecondaryColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        e.comentario.toString() == 'null'
                            ? ''
                            : e.comentario.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'CronosLPro',
                          color: kSecondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                e.subEstado.toString() == 'null'
                    ? Container()
                    : const Divider(),
                e.subEstado.toString() == 'null'
                    ? Container()
                    : Row(
                        children: [
                          const Text(
                            "SUB ESTADO: ",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'CronosSPro',
                              color: kSecondaryColor,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              e.subEstado.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'CronosLPro',
                                color: kSecondaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                const Divider(),
                Row(
                  children: [
                    const Text(
                      "ESTADO: ",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'CronosSPro',
                        color: kSecondaryColor,
                      ),
                    ),
                    Text(
                      e.estado.toString() == 'null' ? '' : e.estado.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'CronosLPro',
                        color: kSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
