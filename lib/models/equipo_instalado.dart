import 'package:mihome_app/models/model.dart';

class EquipoInstalado extends Model {
  EquipoInstalado({
    id,
    required this.tipo,
    required this.serie,
    required this.retiro,
    required this.comentarios,
  }) : super(id);

  String tipo;
  String serie;
  String retiro;
  String comentarios;

  factory EquipoInstalado.fromJson(Map<String, dynamic> json) =>
      EquipoInstalado(
        tipo: json["tipo"].toString(),
        serie: json["serie"].toString(),
        retiro: json["retiro"].toString(),
        comentarios: json["comentarios"].toString(),
      );

  @override
  Map<String, dynamic> toJson() => {
        "tipo": tipo,
        "serie": serie,
        "retiro": retiro,
        "comentarios": comentarios,
      };
}
