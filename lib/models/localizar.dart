import 'package:intl/intl.dart';
import 'package:mihome_app/models/model.dart';

class Localizar extends Model {
  static String table = 'localizar';

  Localizar({
    id,
    this.fecha,
    this.ot,
    this.telefono,
    this.nodo,
    this.region,
    this.distrito,
    this.tecnico,
    this.nombreTecnico,
    this.enviado = 0,
  }) : super(id);

  DateTime? fecha;
  int? ot;
  String? telefono;
  String? nodo;
  String? region;
  String? distrito;
  String? tecnico;
  String? nombreTecnico;
  int? enviado;

  Localizar copyWith({
    DateTime? fecha,
    int? ot,
    String? telefono,
    String? nodo,
    String? region,
    String? distrito,
    String? tecnico,
    String? nombreTecnico,
    int? enviado,
  }) =>
      Localizar(
        id: id ?? id,
        fecha: fecha ?? this.fecha,
        ot: ot ?? this.ot,
        telefono: telefono ?? this.telefono,
        nodo: nodo ?? this.nodo,
        region: region ?? this.region,
        distrito: distrito ?? this.distrito,
        tecnico: tecnico ?? this.tecnico,
        nombreTecnico: nombreTecnico ?? this.nombreTecnico,
        enviado: enviado ?? this.enviado,
      );

  factory Localizar.fromJson(Map<String, dynamic> json) {
    return Localizar(
      id: json["id"],
      fecha: DateFormat('yyyy-MM-dd HH:mm:ss').parse(json["fecha"]),
      ot: json["ot"] != null ? int.parse(json["ot"].toString()) : 0,
      telefono: json["telefono"].toString(),
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
      "ot": ot,
      'fecha': fecha != null
          ? DateFormat('yyyy-MM-dd HH:mm:ss').format(fecha!)
          : null,
      "telefono": telefono,
      "nodo": nodo,
      "region": region,
      "distrito": distrito,
      "tecnico": tecnico,
      "nombreTecnico": nombreTecnico,
      "enviado": enviado,
    };
  }
}
