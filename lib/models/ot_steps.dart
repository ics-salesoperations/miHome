import 'package:intl/intl.dart';
import 'package:mihome_app/models/model.dart';

class OTSteps extends Model {
  static String table = 'ot_steps';

  OTSteps({
    id,
    this.ot,
    this.step,
    this.subEstado,
    this.estado,
    this.comentario,
    this.gestion,
    this.fecha,
    this.estadoNuevo,
  }) : super(id);

  int? ot;
  String? step;
  String? subEstado;
  String? estado;
  String? comentario;
  String? gestion;
  DateTime? fecha;
  DateTime? fechaFin;
  String? estadoNuevo;

  OTSteps copyWith({
    int? ot,
    String? step,
    String? subEstado,
    String? estado,
    String? comentario,
    String? gestion,
    DateTime? fecha,
    String? estadoNuevo,
  }) =>
      OTSteps(
        id: id ?? id,
        ot: ot ?? this.ot,
        step: step ?? this.step,
        subEstado: subEstado ?? this.subEstado,
        estado: estado ?? this.estado,
        comentario: comentario ?? this.comentario,
        gestion: gestion ?? this.gestion,
        fecha: fecha ?? this.fecha,
        estadoNuevo: estadoNuevo ?? this.estadoNuevo,
      );

  factory OTSteps.fromJson(Map<String, dynamic> json) {
    OTSteps step = OTSteps(
      id: json["id"],
      ot: json["ot"] != null ? int.parse(json["ot"].toString()) : 0,
      step: json["step"] ?? "Localizar",
      subEstado: json["subEstado"].toString(),
      estado: json["estado"].toString(),
      comentario: json["comentario"].toString(),
      gestion: json["gestion"].toString(),
      fecha: DateFormat('yyyy-MM-dd HH:mm:ss').parse(json["fecha"]),
      estadoNuevo: json["estadoNuevo"].toString(),
    );

    return step;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "ot": ot,
      "step": step,
      "subEstado": subEstado,
      "estado": estado,
      "comentario": comentario,
      "gestion": gestion,
      "fecha": DateFormat('yyyy-MM-dd HH:mm:ss').format(fecha!),
      "estadoNuevo": estadoNuevo,
    };
  }

  bool validarEstaFinalizado({
    required String step,
    required OTSteps? estadoOT,
  }) {
    if (estadoOT == null) {
      return false;
    }
    bool finalizado = false;
    switch (step.toUpperCase()) {
      case 'LOCALIZAR':
        if (estadoOT.estado == 'FINALIZADA') {
          if (estadoOT.subEstado == 'LOCALIZADO NO DESEA VISITA' ||
              estadoOT.subEstado == 'LOCALIZADO EN CONFERENCIA' ||
              estadoOT.subEstado ==
                  'LOCALIZADO CLIENTE SERVICIO RESTABLECIDO' ||
              estadoOT.subEstado == 'SALTO DE RUTA') {
            finalizado = true;
          } else {
            /*_stepBloc.add(
              const OnChangeCurrentEvent(
                currentStep: 0,
              ),
            );*/
          }
        }

        break;
      case 'ACTIVAR':
        if (estadoOT.estado == 'FINALIZADA') {
          finalizado = true;
        } else {
          /*_stepBloc.add(
            const OnChangeCurrentEvent(
              currentStep: 1,
            ),
          );*/
        }
        break;
      case 'CERTIFICAR':
        if (estadoOT.estado != 'INVALIDA' && estadoOT.estado != 'RECHAZADA') {
          finalizado = true;
        } else {
          /*_stepBloc.add(
            const OnChangeCurrentEvent(
              currentStep: 2,
            ),
          );*/
        }

        break;
      case 'LIQUIDAR':
        if (estadoOT.estado == 'FINALIZADA') {
          finalizado = true;
        } else {
          /*_stepBloc.add(
            const OnChangeCurrentEvent(
              currentStep: 3,
            ),
          );*/
        }

        break;
      default:
    }
    return finalizado;
  }
}
