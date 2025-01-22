import 'package:intl/intl.dart';
import 'package:mihome_app/models/model.dart';

class NodoResumen extends Model {
  NodoResumen({
    id,
    this.fecha,
    this.nodo,
    this.cantidad,
    this.visitado = 0,
    this.tipoCliente,
  }) : super(id);

  DateTime? fecha;
  String? nodo;
  int? cantidad;
  int? visitado;
  String? tipoCliente;

  factory NodoResumen.fromJson(Map<String, dynamic> json) => NodoResumen(
        fecha: DateFormat('dd-MM-yyyy').parse(json["fecha"].toString()),
        nodo: json["nodo"],
        cantidad: json["cantidad"],
        visitado: json["visitado"] ?? 0,
        tipoCliente: json["tipoCliente"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "fecha": DateFormat('dd-MM-yyyy').format(fecha!),
        "nodo": nodo,
        "nombreNodo": nodo,
        "cantidad": cantidad,
        "visitado": visitado ?? 0,
        "tipoCliente": tipoCliente,
      };
}
