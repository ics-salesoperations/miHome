import 'package:intl/intl.dart';
import 'package:mihome_app/models/model.dart';

class OT extends Model {
  static String table = 'ot';

  OT({
    id,
    this.fechaCierre,
    this.ot,
    this.cliente,
    this.paquete,
    this.idTecnico,
    this.nombreTecnico,
    this.contratista,
    this.ciudad,
    this.nodo,
    this.nombreCliente,
    this.departamento,
    this.tap,
    this.colilla,
    this.tipoOt,
    this.gestionado,
  }) : super(id);

  DateTime? fechaCierre;
  int? ot;
  String? cliente;
  String? paquete;
  String? idTecnico;
  String? nombreTecnico;
  String? contratista;
  String? ciudad;
  String? nodo;
  String? nombreCliente;
  String? departamento;
  String? tap;
  String? colilla;
  String? tipoOt;
  int? gestionado;

  OT copyWith({
    DateTime? fechaCierre,
    int? ot,
    String? cliente,
    String? paquete,
    String? idTecnico,
    String? nombreTecnico,
    String? contratista,
    String? ciudad,
    String? nodo,
    String? nombreCliente,
    String? departamento,
    String? tap,
    String? colilla,
    String? tipoOt,
    int? gestionado,
  }) =>
      OT(
        id: id ?? id,
        fechaCierre: fechaCierre ?? this.fechaCierre,
        ot: ot ?? this.ot,
        cliente: cliente ?? this.cliente,
        paquete: paquete ?? this.paquete,
        idTecnico: idTecnico ?? this.idTecnico,
        nombreTecnico: nombreTecnico ?? this.nombreTecnico,
        contratista: contratista ?? this.contratista,
        ciudad: ciudad ?? this.ciudad,
        nodo: nodo ?? this.nodo,
        nombreCliente: nombreCliente ?? this.nombreCliente,
        departamento: departamento ?? this.departamento,
        tap: tap ?? this.tap,
        colilla: colilla ?? this.colilla,
        tipoOt: tipoOt ?? this.tipoOt,
        gestionado: gestionado ?? this.gestionado,
      );

  factory OT.fromJson(Map<String, dynamic> json) {
    return OT(
      id: json["id"],
      fechaCierre: DateFormat('yyyy-MM-dd HH:mm:ss').parse(json["fechaCierre"]),
      ot: json["ot"] != null ? int.parse(json["ot"].toString()) : 0,
      cliente: json["cliente"].toString(),
      paquete: json["paquete"].toString(),
      idTecnico: json["idTecnico"].toString(),
      nombreTecnico: json["nombreTecnico"].toString(),
      contratista: json["contratista"].toString(),
      ciudad: json["ciudad"].toString(),
      nodo: json["nodo"].toString(),
      nombreCliente: json["nombreCliente"].toString(),
      departamento: json["departamento"].toString(),
      tap: json["tap"].toString(),
      colilla: json["colilla"].toString(),
      tipoOt: json["tipoOt"].toString(),
      gestionado: json["gestionado"] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "ot": ot,
      'fechaCierre': fechaCierre != null
          ? DateFormat('yyyy-MM-dd HH:mm:ss').format(fechaCierre!)
          : null,
      "cliente": cliente,
      "paquete": paquete,
      "idTecnico": idTecnico,
      "nombreTecnico": nombreTecnico,
      "contratista": contratista,
      "ciudad": ciudad,
      "nodo": nodo,
      "nombreCliente": nombreCliente,
      "departamento": departamento,
      "tap": tap,
      "colilla": colilla,
      "tipoOt": tipoOt,
      "gestionado": gestionado,
    };
  }
}
