import 'package:intl/intl.dart';
import 'package:mihome_app/models/model.dart';

class ResumenSincronizar extends Model {
  ResumenSincronizar({
    id,
    this.fecha,
    this.tipo,
    this.porcentajeSync,
    this.codigo,
    this.nombrePdv,
    this.idVisita,
    this.categoria,
  }) : super(id);

  DateTime? fecha;
  String? tipo;
  int? porcentajeSync;
  String? codigo;
  String? nombrePdv;
  String? idVisita;
  String? categoria;

  factory ResumenSincronizar.fromJson(Map<String, dynamic> json) {
    DateTime fecha;

    if (json["categoria"].toString() == "GEORREFERENCIACION" &&
        !json["tipo"].toString().contains("ACTUALIZACION")) {
      fecha = DateTime.parse(json["fecha"].toString());
    } else if (json["categoria"].toString() == "GESTION DESPACHO") {
      fecha = DateTime.now();
    } else {
      fecha = DateTime(
        int.parse(json["fecha"].toString().substring(0, 4)),
        int.parse(json["fecha"].toString().substring(4, 6)),
        int.parse(json["fecha"].toString().substring(6, 8)),
        int.parse(json["fecha"].toString().substring(9, 11)),
        int.parse(json["fecha"].toString().substring(11, 13)),
        int.parse(json["fecha"].toString().substring(13, 15)),
      );
    }

    return ResumenSincronizar(
      fecha: fecha,
      tipo: json["tipo"].toString(),
      idVisita: json["idVisita"].toString(),
      porcentajeSync: json["porcentajeSync"],
      nombrePdv: json["nombrePdv"].toString(),
      codigo: json["codigo"],
      categoria: json["categoria"],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "fecha": DateFormat('yyyyMMdd:HHmmss').format(fecha!),
        "tipo": tipo,
        "porcentajeSync": porcentajeSync,
        "codigo": codigo,
        "nombrePdv": nombrePdv,
        "idVisita": idVisita,
        "categoria": categoria,
      };
}
