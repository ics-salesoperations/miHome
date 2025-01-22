import 'package:intl/intl.dart';
import 'package:mihome_app/models/model.dart';

class Certificar extends Model {
  static String table = 'certificar';

  Certificar({
    id,
    this.fecha,
    this.ot,
    this.telefono,
    this.nodo,
    this.tap,
    this.colilla,
    this.correo,
    this.region,
    this.distrito,
    this.tecnico,
    this.nombreTecnico,
    this.bitacora,
    this.enviado = 0,
    this.bst = 'NO',
  }) : super(id);

  DateTime? fecha;
  int? ot;
  String? telefono;
  String? nodo;
  String? tap;
  String? colilla;
  String? correo;
  String? region;
  String? distrito;
  String? tecnico;
  String? nombreTecnico;
  String? bitacora;
  String? bst;
  int? enviado;

  Certificar copyWith({
    DateTime? fecha,
    int? ot,
    String? telefono,
    String? nodo,
    String? tap,
    String? colilla,
    String? correo,
    String? region,
    String? distrito,
    String? tecnico,
    String? nombreTecnico,
    String? bitacora,
    String? bst,
    int? enviado,
  }) =>
      Certificar(
        id: id ?? id,
        fecha: fecha ?? this.fecha,
        ot: ot ?? this.ot,
        telefono: telefono ?? this.telefono,
        nodo: nodo ?? this.nodo,
        tap: tap ?? this.tap,
        colilla: colilla ?? this.colilla,
        correo: correo ?? this.correo,
        region: region ?? this.region,
        distrito: distrito ?? this.distrito,
        tecnico: tecnico ?? this.tecnico,
        nombreTecnico: nombreTecnico ?? this.nombreTecnico,
        bitacora: bitacora ?? this.bitacora,
        enviado: enviado ?? this.enviado,
        bst: bst ?? this.bst,
      );

  factory Certificar.fromJson(Map<String, dynamic> json) {
    return Certificar(
      id: json["id"],
      fecha: DateFormat('yyyy-MM-dd HH:mm:ss').parse(json["fecha"]),
      ot: json["ot"] != null ? int.parse(json["ot"].toString()) : 0,
      telefono: json["telefono"].toString(),
      nodo: json["nodo"].toString(),
      tap: json["tap"].toString(),
      colilla: json["colilla"].toString(),
      correo: json["correo"].toString(),
      region: json["region"].toString(),
      distrito: json["distrito"].toString(),
      tecnico: json["tecnico"].toString(),
      nombreTecnico: json["nombreTecnico"].toString(),
      bitacora: json["bitacora"].toString(),
      enviado: json["enviado"] ?? 0,
      bst: json["bst"] ?? "NO",
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
      "tap": tap,
      "colilla": colilla,
      "correo": correo,
      "region": region,
      "distrito": distrito,
      "tecnico": tecnico,
      "nombreTecnico": nombreTecnico,
      "bitacora": bitacora,
      "enviado": enviado,
      "bst": bst,
    };
  }
}
