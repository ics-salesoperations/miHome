import 'package:intl/intl.dart';
import 'package:mihome_app/models/model.dart';

class Activar extends Model {
  static String table = 'activar';

  Activar({
    id,
    this.fecha,
    this.ot,
    this.cajaAndroidTV,
    this.cajaDVB,
    this.cableModem,
    this.telefonia,
    this.extensores,
    this.retiros,
    this.ipPublica,
    this.nodo,
    this.tap,
    this.colilla,
    this.correo,
    this.bandSteering,
    this.nombreRed,
    this.claveRed,
    this.enviado = 0,
    this.region,
    this.distrito,
  }) : super(id);

  DateTime? fecha;
  int? ot;
  String? cajaAndroidTV;
  String? cajaDVB;
  String? cableModem;
  String? telefonia;
  String? extensores;
  String? retiros;
  String? ipPublica;
  String? nodo;
  String? tap;
  String? colilla;
  String? correo;
  String? bandSteering;
  String? nombreRed;
  String? claveRed;
  String? region;
  String? distrito;
  int? enviado;

  Activar copyWith({
    DateTime? fecha,
    int? ot,
    String? cajaAndroidTV,
    String? cajaDVB,
    String? cableModem,
    String? telefonia,
    String? extensores,
    String? retiros,
    String? ipPublica,
    String? nodo,
    String? tap,
    String? colilla,
    String? correo,
    String? bandSteering,
    String? nombreRed,
    String? claveRed,
    String? region,
    String? distrito,
    int? enviado,
  }) =>
      Activar(
        id: id ?? id,
        fecha: fecha ?? this.fecha,
        ot: ot ?? this.ot,
        cajaAndroidTV: cajaAndroidTV ?? this.cajaAndroidTV,
        cajaDVB: cajaDVB ?? this.cajaDVB,
        cableModem: cableModem ?? this.cableModem,
        telefonia: telefonia ?? this.telefonia,
        extensores: extensores ?? this.extensores,
        retiros: retiros ?? this.retiros,
        ipPublica: ipPublica ?? this.ipPublica,
        nodo: nodo ?? this.nodo,
        tap: tap ?? this.tap,
        colilla: colilla ?? this.colilla,
        correo: correo ?? this.correo,
        bandSteering: bandSteering ?? this.bandSteering,
        nombreRed: nombreRed ?? this.nombreRed,
        claveRed: claveRed ?? this.claveRed,
        distrito: distrito ?? this.distrito,
        region: region ?? this.region,
        enviado: enviado ?? this.enviado,
      );

  factory Activar.fromJson(Map<String, dynamic> json) {
    return Activar(
      id: json["id"],
      fecha: DateFormat('yyyy-MM-dd HH:mm:ss').parse(json["fecha"]),
      ot: json["ot"] != null ? int.parse(json["ot"].toString()) : 0,
      cajaAndroidTV: json["cajaAndroidTV"].toString(),
      cajaDVB: json["cajaDVB"].toString(),
      cableModem: json["cableModem"].toString(),
      telefonia: json["telefonia"].toString(),
      extensores: json["extensores"].toString(),
      retiros: json["retiros"].toString(),
      ipPublica: json["ipPublica"].toString(),
      nodo: json["nodo"].toString(),
      tap: json["tap"].toString(),
      colilla: json["colilla"].toString(),
      correo: json["correo"].toString(),
      bandSteering: json["bandSteering"].toString(),
      nombreRed: json["nombreRed"].toString(),
      claveRed: json["claveRed"].toString(),
      distrito: json["distrito"].toString(),
      region: json["region"].toString(),
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
      "cajaAndroidTV": cajaAndroidTV,
      "cajaDVB": cajaDVB,
      "cableModem": cableModem,
      "telefonia": telefonia,
      "extensores": extensores,
      "retiros": retiros,
      "ipPublica": ipPublica,
      "nodo": nodo,
      "tap": tap,
      "colilla": colilla,
      "correo": correo,
      "bandSteering": bandSteering,
      "nombreRed": nombreRed,
      "claveRed": claveRed,
      "distrito": distrito,
      "region": region,
      "enviado": enviado,
    };
  }
}
