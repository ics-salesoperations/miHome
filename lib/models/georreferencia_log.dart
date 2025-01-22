import 'package:mihome_app/models/model.dart';

class GeorreferenciaLog extends Model {
  static String table = 'georreferenciaLog';

  String? codigo;
  String? nombre;
  double? latitud;
  double? longitud;
  String? tipo;
  String? codigoPadre;
  String? foto;
  String? usuarioActualiza;
  DateTime? fechaActualizacion;
  int? enviado;
  int? puerto;

  GeorreferenciaLog({
    id,
    this.codigo,
    this.nombre,
    this.latitud,
    this.longitud,
    this.tipo,
    this.codigoPadre,
    this.foto,
    this.usuarioActualiza,
    this.fechaActualizacion,
    this.enviado = 0,
    this.puerto = 0,
  }) : super(id);

  GeorreferenciaLog copyWith({
    int? id,
    String? codigo,
    String? nombre,
    double? latitud,
    double? longitud,
    String? tipo,
    String? codigoPadre,
    String? foto,
    String? usuarioActualiza,
    DateTime? fechaActualizacion,
    int? enviado,
    int? puerto,
  }) =>
      GeorreferenciaLog(
        id: id ?? this.id,
        codigo: codigo ?? this.codigo,
        nombre: nombre ?? this.nombre,
        latitud: latitud ?? this.latitud,
        longitud: longitud ?? this.longitud,
        tipo: tipo ?? this.tipo,
        codigoPadre: codigoPadre ?? this.codigoPadre,
        foto: foto ?? this.foto,
        fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
        usuarioActualiza: usuarioActualiza ?? this.usuarioActualiza,
        enviado: enviado ?? this.enviado,
        puerto: puerto ?? this.puerto,
      );

  factory GeorreferenciaLog.fromJson(Map<String, dynamic> json) =>
      GeorreferenciaLog(
          id: json["id"],
          codigo: json["codigo"].toString(),
          nombre: json["nombre"].toString(),
          latitud: json["latitud"] == null ? 0 : json["latitud"].toDouble(),
          longitud: json["longitud"] == null ? 0 : json["longitud"].toDouble(),
          tipo: json["tipo"].toString(),
          codigoPadre: json["codigoPadre"].toString(),
          foto: json["foto"].toString(),
          fechaActualizacion: json["fechaActualizacion"] != null
              ? DateTime.parse(json["fechaActualizacion"])
              : null,
          usuarioActualiza: json["usuarioActualiza"].toString(),
          enviado: json["enviado"],
          puerto: json["puerto"]);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "codigo": codigo,
      "nombre": nombre,
      "latitud": latitud,
      "longitud": longitud,
      "tipo": tipo,
      "codigoPadre": codigoPadre,
      "foto": foto,
      "fechaActualizacion": fechaActualizacion != null
          ? fechaActualizacion!.toIso8601String()
          : null,
      "usuarioActualiza": usuarioActualiza,
      "enviado": enviado,
      "puerto": puerto,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }
}
