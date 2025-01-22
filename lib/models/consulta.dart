import 'package:intl/intl.dart';
import 'package:mihome_app/models/model.dart';

class Consulta extends Model {
  static String table = 'consulta';

  Consulta({
    id,
    this.fecha,
    this.fechaFin,
    this.ot,
    this.telefono,
    this.consulta,
    this.nodo,
    this.region,
    this.distrito,
    this.tecnico,
    this.nombreTecnico,
    this.enviado = 0,
  }) : super(id);

  DateTime? fecha;
  DateTime? fechaFin;
  int? ot;
  String? telefono;
  String? consulta;
  String? nodo;
  String? region;
  String? distrito;
  String? tecnico;
  String? nombreTecnico;
  int? enviado;

  Consulta copyWith({
    DateTime? fecha,
    DateTime? fechaFin,
    int? ot,
    String? telefono,
    String? consulta,
    String? nodo,
    String? region,
    String? distrito,
    String? tecnico,
    String? nombreTecnico,
    int? enviado,
  }) =>
      Consulta(
        id: id ?? id,
        fecha: fecha ?? this.fecha,
        fechaFin: fechaFin ?? this.fechaFin,
        ot: ot ?? this.ot,
        telefono: telefono ?? this.telefono,
        consulta: consulta ?? this.consulta,
        nodo: nodo ?? this.nodo,
        region: region ?? this.region,
        distrito: distrito ?? this.distrito,
        tecnico: tecnico ?? this.tecnico,
        nombreTecnico: nombreTecnico ?? this.nombreTecnico,
        enviado: enviado ?? this.enviado,
      );

  factory Consulta.fromJson(Map<String, dynamic> json) {
    return Consulta(
      id: json["id"],
      fecha: DateFormat('yyyy-MM-dd HH:mm:ss').parse(json["fecha"]),
      fechaFin: DateFormat('yyyy-MM-dd HH:mm:ss').parse(json["fechaFin"] ?? ''),
      ot: json["ot"] != null ? int.parse(json["ot"].toString()) : 0,
      telefono: json["telefono"].toString(),
      consulta: json["consulta"].toString(),
      nodo: json["nodo"].toString(),
      region: json["region"].toString(),
      distrito: json["distrito"].toString(),
      tecnico: json["tecnico"].toString(),
      nombreTecnico: json["nombreTecnico"].toString(),
      enviado: json["enviado"] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'fecha': fecha != null
          ? DateFormat('yyyy-MM-dd HH:mm:ss').format(fecha!)
          : null,
      'fechaFin': fechaFin != null
          ? DateFormat('yyyy-MM-dd HH:mm:ss').format(fechaFin!)
          : null,
      "ot": ot,
      "telefono": telefono,
      "consulta": consulta,
      "nodo": nodo,
      "region": region,
      "distrito": distrito,
      "tecnico": tecnico,
      "nombreTecnico": nombreTecnico,
      "enviado": enviado,
    };
  }
}
