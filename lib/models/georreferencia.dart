import 'package:mihome_app/models/model.dart';

class Georreferencia extends Model {
  static String table = 'georreferencia';

  String? codigo;
  String? nombre;
  String? estado;
  double? latitud;
  double? longitud;
  String? territorio;
  String? zona;
  String? departamento;
  String? municipio;
  String? tipo;
  String? codigoPadre;
  double? distancia;
  String? foto;
  String? modelo;
  String? marca;
  int? puertos;
  int? puerto;
  DateTime? fechaActualizacion;

  Georreferencia({
    id,
    this.codigo,
    this.nombre,
    this.estado,
    this.latitud,
    this.longitud,
    this.territorio,
    this.zona,
    this.departamento,
    this.municipio,
    this.tipo,
    this.codigoPadre,
    this.distancia = 0,
    this.foto,
    this.modelo,
    this.marca,
    this.puertos,
    this.puerto,
    this.fechaActualizacion,
  }) : super(id);

  Georreferencia copyWith({
    int? id,
    String? codigo,
    String? nombre,
    String? estado,
    double? latitud,
    double? longitud,
    String? territorio,
    String? zona,
    String? departamento,
    String? municipio,
    String? tipo,
    String? codigoPadre,
    double? distancia,
    String? foto,
    String? modelo,
    String? marca,
    int? puertos,
    int? puerto,
    DateTime? fechaActualizacion,
  }) =>
      Georreferencia(
        id: id ?? this.id,
        codigo: codigo ?? this.codigo,
        nombre: nombre ?? this.nombre,
        estado: estado ?? this.estado,
        latitud: latitud ?? this.latitud,
        longitud: longitud ?? this.longitud,
        territorio: territorio ?? this.territorio,
        zona: zona ?? this.zona,
        departamento: departamento ?? this.departamento,
        municipio: municipio ?? this.municipio,
        tipo: tipo ?? this.tipo,
        codigoPadre: codigoPadre ?? this.codigoPadre,
        distancia: distancia ?? this.distancia,
        foto: foto ?? this.foto,
        modelo: modelo ?? this.modelo,
        marca: marca ?? this.marca,
        puertos: puertos ?? this.puertos,
        puerto: puerto ?? this.puerto,
        fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
      );

  factory Georreferencia.fromJson(Map<String, dynamic> json) => Georreferencia(
        id: json["id"],
        codigo: json["codigo"].toString(),
        nombre: json["nombre"].toString(),
        estado: json["estado"].toString(),
        latitud: json["latitud"] == null ? 0 : json["latitud"].toDouble(),
        longitud: json["longitud"] == null ? 0 : json["longitud"].toDouble(),
        territorio: json["territorio"].toString(),
        zona: json["zona"].toString(),
        departamento: json["departamento"].toString(),
        municipio: json["municipio"].toString(),
        tipo: json["tipo"].toString(),
        codigoPadre: json["codigoPadre"].toString(),
        distancia: json["distancia"] == null ? 0 : json["distancia"].toDouble(),
        foto: json["foto"].toString(),
        modelo: json["modelo"].toString(),
        marca: json["marca"].toString(),
        puertos: json["puertos"],
        puerto: json["puerto"],
        fechaActualizacion: json["fechaActualizacion"] != null
            ? DateTime.parse(json["fechaActualizacion"])
            : null,
      );

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "codigo": codigo,
      "nombre": nombre,
      "estado": estado,
      "latitud": latitud,
      "longitud": longitud,
      "territorio": territorio,
      "zona": zona,
      "departamento": departamento,
      "municipio": municipio,
      "tipo": tipo,
      "codigoPadre": codigoPadre,
      "distancia": distancia,
      "foto": foto,
      "modelo": modelo,
      "marca": marca,
      "puertos": puertos,
      "puerto": puerto,
      "fechaActualizacion": fechaActualizacion != null
          ? fechaActualizacion!.toIso8601String()
          : null,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }
}
