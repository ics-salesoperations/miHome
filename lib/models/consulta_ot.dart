import 'package:intl/intl.dart';

import 'models.dart';

class ConsultaOt extends Model {
  static String table = 'consultaOt';
  ConsultaOt({
    id,
    this.ot,
    this.cliente,
    this.estadoCliente,
    this.codigoNodo,
    this.estadoNodo,
    this.motivo,
    this.descripcionMotivo,
    this.fechaCreado,
    this.fechaHoraEstimada,
    this.estadoAmsys,
    this.descripconTipoOt,
    this.categoriaNodo,
    this.contrato,
    this.vendedor,
    this.supervisor,
    this.territorioVendedor,
    this.fechaHoraDigitacion,
    this.fechaEstadoAmsys,
    this.fechaUltimaBitacora,
    this.ultimaBitacora,
    this.estadoFieldService,
    this.jordanaAsignada,
    this.duracionHoras,
    this.tiempoCierre,
    this.esFinalizado,
    this.dataUpdate,
    this.estaSubscrito = 0,
  }) : super(id);

  final int? ot;
  int? cliente;
  String? estadoCliente;
  String? codigoNodo;
  String? estadoNodo;
  String? motivo;
  String? descripcionMotivo;
  String? fechaCreado;
  String? fechaHoraEstimada;
  String? estadoAmsys;
  String? descripconTipoOt;
  String? categoriaNodo;
  int? contrato;
  String? vendedor;
  String? supervisor;
  String? territorioVendedor;
  String? fechaHoraDigitacion;
  String? fechaEstadoAmsys;
  String? fechaUltimaBitacora;
  String? ultimaBitacora;
  String? estadoFieldService;
  String? jordanaAsignada;
  String? duracionHoras;
  String? tiempoCierre;
  int? esFinalizado;
  DateTime? dataUpdate;
  int? estaSubscrito;

  ConsultaOt copyWith({
    int? id,
    int? ot,
    int? cliente,
    String? estadoCliente,
    String? codigoNodo,
    String? estadoNodo,
    String? motivo,
    String? descripcionMotivo,
    String? fechaCreado,
    String? fechaHoraEstimada,
    String? estadoAmsys,
    String? descripconTipoOt,
    String? categoriaNodo,
    int? contrato,
    String? vendedor,
    String? supervisor,
    String? territorioVendedor,
    String? fechaHoraDigitacion,
    String? fechaEstadoAmsys,
    String? fechaUltimaBitacora,
    String? ultimaBitacora,
    String? estadoFieldService,
    String? jordanaAsignada,
    String? duracionHoras,
    String? tiempoCierre,
    int? esFinalizado,
    DateTime? dataUpdate,
    int? estaSubscrito,
  }) {
    return ConsultaOt(
      ot: ot ?? this.ot,
      cliente: cliente ?? this.cliente,
      estadoCliente: estadoCliente ?? this.estadoCliente,
      codigoNodo: codigoNodo ?? this.codigoNodo,
      estadoNodo: estadoNodo ?? this.estadoNodo,
      motivo: motivo ?? this.motivo,
      descripcionMotivo: descripcionMotivo ?? this.descripcionMotivo,
      fechaCreado: fechaCreado ?? this.fechaCreado,
      fechaHoraEstimada: fechaHoraEstimada ?? this.fechaHoraEstimada,
      estadoAmsys: estadoAmsys ?? this.estadoAmsys,
      descripconTipoOt: descripconTipoOt ?? this.descripconTipoOt,
      categoriaNodo: categoriaNodo ?? this.categoriaNodo,
      contrato: contrato ?? this.contrato,
      vendedor: vendedor ?? this.vendedor,
      supervisor: supervisor ?? this.supervisor,
      territorioVendedor: territorioVendedor ?? this.territorioVendedor,
      fechaHoraDigitacion: fechaHoraDigitacion ?? this.fechaHoraDigitacion,
      fechaEstadoAmsys: fechaEstadoAmsys ?? this.fechaEstadoAmsys,
      fechaUltimaBitacora: fechaUltimaBitacora ?? this.fechaUltimaBitacora,
      ultimaBitacora: ultimaBitacora ?? this.ultimaBitacora,
      estadoFieldService: estadoFieldService ?? this.estadoFieldService,
      jordanaAsignada: jordanaAsignada ?? this.jordanaAsignada,
      duracionHoras: duracionHoras ?? this.duracionHoras,
      tiempoCierre: tiempoCierre ?? this.tiempoCierre,
      esFinalizado: esFinalizado ?? this.esFinalizado,
      dataUpdate: dataUpdate ?? this.dataUpdate,
      estaSubscrito: estaSubscrito ?? this.estaSubscrito,
    );
  }

  factory ConsultaOt.fromJson(Map<String, dynamic> json) {
    return ConsultaOt(
      ot: int.parse(json["ot"].toString()),
      cliente: int.parse(json["cliente"].toString()),
      estadoCliente: json["estadoCliente"],
      codigoNodo: json["codigoNodo"],
      estadoNodo: json["estadoNodo"],
      motivo: json["motivo"],
      descripcionMotivo: json["descripcionMotivo"],
      fechaCreado: json["fechaCreado"],
      fechaHoraEstimada: json["fechaHoraEstimada"],
      estadoAmsys: json["estadoAmsys"],
      descripconTipoOt: json["descripconTipoOt"],
      categoriaNodo: json["categoriaNodo"],
      contrato: int.parse(json["contrato"].toString()),
      vendedor: json["vendedor"],
      supervisor: json["supervisor"],
      territorioVendedor: json["territorioVendedor"],
      fechaHoraDigitacion: json["fechaHoraDigitacion"],
      fechaEstadoAmsys: json["fechaEstadoAmsys"],
      fechaUltimaBitacora: json["fechaUltimaBitacora"],
      ultimaBitacora: json["ultimaBitacora"],
      estadoFieldService: json["estadoFieldService"],
      jordanaAsignada: json["jordanaAsignada"],
      duracionHoras: json["duracionHoras"],
      tiempoCierre: json["tiempoCierre"],
      esFinalizado: json["esFinalizado"],
      estaSubscrito: json["estaSubscrito"],
      dataUpdate:
          DateFormat('yyyy-MM-dd HH:mm:ss').parse(json["dataUpdate"] ?? ""),
    );
  }

  @override
  Map<String, String?> toJson() => {
        "ot": ot.toString(),
        "cliente": cliente.toString(),
        "estadoCliente": estadoCliente,
        "codigoNodo": codigoNodo,
        "estadoNodo": estadoNodo,
        "motivo": motivo,
        "descripcionMotivo": descripcionMotivo,
        "fechaCreado": fechaCreado,
        "fechaHoraEstimada": fechaHoraEstimada,
        "estadoAmsys": estadoAmsys,
        "descripconTipoOt": descripconTipoOt,
        "categoriaNodo": categoriaNodo,
        "contrato": contrato.toString(),
        "vendedor": vendedor,
        "supervisor": supervisor,
        "territorioVendedor": territorioVendedor,
        "fechaHoraDigitacion": fechaHoraDigitacion,
        "fechaEstadoAmsys": fechaEstadoAmsys,
        "fechaUltimaBitacora": fechaUltimaBitacora,
        "ultimaBitacora": ultimaBitacora,
        "estadoFieldService": estadoFieldService,
        "jordanaAsignada": jordanaAsignada,
        "duracionHoras": duracionHoras,
        "tiempoCierre": tiempoCierre,
        "esFinalizado": esFinalizado.toString(),
        "estaSubscrito": estaSubscrito.toString(),
        "dataUpdate": DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(dataUpdate ?? DateTime.now()),
      };

  @override
  String toString() {
    return """Ot: $ot, 
              Cliente: $cliente, 
              Estado del Cliente: $estadoCliente, 
              Nodo: $codigoNodo, 
              Estado del Nodo: $estadoNodo, 
              Motivo: $motivo, 
              Descripción Motivo: $descripcionMotivo, 
              Fecha Creado: $fechaCreado, 
              Fecha y Hora Estimada: $fechaHoraEstimada, 
              Estado Amsys: $estadoAmsys, 
              Descripción Tipo OT: $descripconTipoOt, 
              Categoría Nodo: $categoriaNodo, 
              Contrato: $contrato, 
              Vendedor: $vendedor, 
              Supervisor: $supervisor, 
              Territorio Vendedor: $territorioVendedor, 
              Fecha y Hora Digitación: $fechaHoraDigitacion, 
              Fecha Estado Amsys: $fechaEstadoAmsys, 
              Fecha Última Bitacora: $fechaUltimaBitacora, 
              Última Bitácora: $ultimaBitacora, 
              Estado Field Service: $estadoFieldService, 
              Jornada Asignada: $jordanaAsignada, 
              Duración Horas: $duracionHoras, 
              Tiempo Cierre: $tiempoCierre,
              Fecha de Datos: $dataUpdate """;
  }
}
