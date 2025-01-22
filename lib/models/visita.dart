import 'package:intl/intl.dart';
import 'package:mihome_app/models/model.dart';

class Visita extends Model {
  static String table = 'visita';

  Visita({
    id,
    this.fechaInicioVisita,
    this.fechaFinVisita,
    this.cliente,
    this.usuario,
    this.latitud,
    this.longitud,
    this.enviado,
    this.idVisita,
  }) : super(id);

  DateTime? fechaInicioVisita;
  DateTime? fechaFinVisita;
  String? cliente;
  String? usuario;
  double? latitud;
  double? longitud;
  String? enviado;
  String? idVisita;

  Visita copyWith({
    DateTime? fechaInicioVisita,
    DateTime? fechaFinVisita,
    String? cliente,
    String? usuario,
    double? latitud,
    double? longitud,
    String? enviado,
    String? idVisita,
  }) =>
      Visita(
        fechaInicioVisita: fechaInicioVisita ?? this.fechaInicioVisita,
        fechaFinVisita: fechaFinVisita ?? this.fechaFinVisita,
        cliente: cliente ?? this.cliente,
        usuario: usuario ?? this.usuario,
        latitud: latitud ?? this.latitud,
        longitud: longitud ?? this.longitud,
        enviado: enviado ?? this.enviado,
        idVisita: idVisita ?? this.idVisita,
      );

  factory Visita.fromMap(Map<String, dynamic> json) => Visita(
        id: json["id"],
        fechaInicioVisita:
            DateFormat('yyyyMMdd:HHmmss').parse(json["fechaInicioVisita"]),
        fechaFinVisita: json["fechaFinVisita"] != null
            ? DateFormat('yyyyMMdd:HHmmss').parse(json["fechaFinVisita"])
            : null,
        cliente: json["cliente"],
        usuario: json["usuario"],
        latitud: json["latitud"],
        longitud: json["longitud"],
        enviado: json["enviado"],
        idVisita: json["idVisita"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "fechaInicioVisita": fechaInicioVisita != null
            ? DateFormat('yyyyMMdd:HHmmss').format(fechaInicioVisita!)
            : "",
        "fechaFinVisita": fechaFinVisita != null
            ? DateFormat('yyyyMMdd:HHmmss').format(fechaFinVisita!)
            : "",
        "cliente": cliente,
        "usuario": usuario,
        "latitud": latitud,
        "longitud": longitud,
        "enviado": enviado,
        "idVisita": idVisita,
      };
}
