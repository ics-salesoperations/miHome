import 'package:intl/intl.dart';
import 'package:mihome_app/models/model.dart';

class Agenda extends Model {
  static String table = 'agenda';

  Agenda({
    id,
    this.fecha,
    this.ot,
    this.usuario,
    this.idTecnico,
    this.nombreTecnico,
    this.cliente,
    this.nombreCliente,
    this.nodo,
    this.nodoNuevo,
    this.tap,
    this.tapNuevo,
    this.colilla,
    this.colillaNueva,
    this.horaEntrada,
    this.horaSalida,
    this.zona99,
    this.seriesBBI,
    this.seriesTV,
    this.seriesOtras,
    this.longitud,
    this.latitud,
    this.estadoNodo,
    this.servicios,
    this.visitado,
    this.fechaVisita,
    this.comentario,
    this.estado,
    this.producto,
    this.tipo,
    this.distrito,
    this.region,
    this.direccion,
    this.qr,
    this.qrNuevo,
  }) : super(id);

  DateTime? fecha;
  int? ot;
  String? usuario;
  int? idTecnico;
  String? nombreTecnico;
  int? cliente;
  String? nombreCliente;
  String? nodo;
  String? nodoNuevo;
  String? tap;
  String? tapNuevo;
  String? colilla;
  String? colillaNueva;
  String? horaEntrada;
  String? horaSalida;
  String? zona99;
  String? seriesBBI;
  String? seriesTV;
  String? seriesOtras;
  double? longitud;
  double? latitud;
  String? estadoNodo;
  String? servicios;
  String? visitado;
  DateTime? fechaVisita;
  String? comentario;
  String? estado;
  String? producto;
  String? tipo;
  String? distrito;
  String? region;
  String? direccion;
  String? qr;
  String? qrNuevo;

  Agenda copyWith({
    DateTime? fecha,
    int? ot,
    String? usuario,
    int? idTecnico,
    String? nombreTecnico,
    int? cliente,
    String? nombreCliente,
    String? nodo,
    String? nodoNuevo,
    String? tap,
    String? tapNuevo,
    String? colilla,
    String? colillaNueva,
    String? horaEntrada,
    String? horaSalida,
    String? zona99,
    String? seriesBBI,
    String? seriesTV,
    String? seriesOtras,
    double? latitud,
    double? longitud,
    String? estadoNodo,
    String? servicios,
    String? visitado,
    DateTime? fechaVisita,
    String? comentario,
    String? estado,
    String? producto,
    String? tipo,
    String? distrito,
    String? region,
    String? direccion,
    String? qr,
    String? qrNuevo,
  }) =>
      Agenda(
        id: id ?? id,
        fecha: fecha ?? this.fecha,
        ot: ot ?? this.ot,
        usuario: usuario ?? this.usuario,
        idTecnico: idTecnico ?? this.idTecnico,
        nombreTecnico: nombreTecnico ?? this.nombreTecnico,
        cliente: cliente ?? this.cliente,
        nombreCliente: nombreCliente ?? this.nombreCliente,
        nodo: nodo ?? this.nodo,
        nodoNuevo: nodoNuevo ?? this.nodoNuevo,
        tap: tap ?? this.tap,
        tapNuevo: tapNuevo ?? this.tapNuevo,
        colilla: colilla ?? this.colilla,
        colillaNueva: colillaNueva ?? this.colillaNueva,
        horaEntrada: horaEntrada ?? this.horaEntrada,
        horaSalida: horaSalida ?? this.horaSalida,
        zona99: zona99 ?? this.zona99,
        seriesBBI: seriesBBI ?? this.seriesBBI,
        seriesTV: seriesTV ?? this.seriesTV,
        seriesOtras: seriesOtras ?? this.seriesOtras,
        latitud: latitud ?? this.latitud,
        longitud: longitud ?? this.longitud,
        estadoNodo: estadoNodo ?? this.estadoNodo,
        servicios: servicios ?? this.servicios,
        visitado: visitado ?? this.visitado,
        fechaVisita: fechaVisita ?? this.fechaVisita,
        comentario: comentario ?? this.comentario,
        estado: estado ?? this.estado,
        producto: producto ?? this.producto,
        tipo: tipo ?? this.tipo,
        distrito: distrito ?? this.distrito,
        region: region ?? this.region,
        direccion: direccion ?? this.direccion,
        qr: qr ?? this.qr,
        qrNuevo: qrNuevo ?? this.qrNuevo,
      );

  factory Agenda.fromJson(Map<String, dynamic> json) {
    return Agenda(
      id: json["id"],
      fecha: DateFormat('yyyy-MM-dd HH:mm:ss').parse(json["fecha"]),
      ot: json["ot"] != null ? int.parse(json["ot"].toString()) : 0,
      usuario: json["usuario"].toString(),
      idTecnico: json["idTecnico"] != null
          ? int.parse(json["idTecnico"].toString())
          : 0,
      nombreTecnico: json["nombreTecnico"].toString(),
      cliente: int.parse(json["cliente"] ?? '0'),
      nombreCliente: json["nombreCliente"].toString(),
      nodo: json["nodo"] ?? "",
      nodoNuevo: json["nodoNuevo"] ?? "",
      tap: json["tap"] ?? "",
      tapNuevo: json["tapNuevo"] ?? "",
      colilla: json["colilla"].toString() == 'null'
          ? ""
          : json["colilla"].toString(),
      colillaNueva: json["colillaNueva"] ?? "",
      horaEntrada: json["horaEntrada"].toString(),
      horaSalida: json["horaSalida"].toString(),
      zona99: json["zona99"].toString(),
      seriesBBI: json["seriesBBI"].toString(),
      seriesTV: json["seriesTV"].toString(),
      seriesOtras: json["seriesOtras"].toString(),
      latitud: json["latitud"] == null
          ? 0
          : double.parse(json["latitud"].toString()),
      longitud: json["longitud"] == null
          ? 0
          : double.parse(json["longitud"].toString()),
      estadoNodo: json["estadoNodo"].toString(),
      servicios: json["servicios"].toString(),
      comentario: json["comentario"].toString(),
      visitado: json["visitado"] ?? "NO",
      estado: json["estado"].toString(),
      producto: json["producto"].toString(),
      tipo: json["tipo"].toString(),
      distrito: json["distrito"].toString(),
      region: json["region"].toString(),
      direccion: json["direccion"].toString(),
      qr: json["qr"] ?? "",
      qrNuevo: json["qrNuevo"] ?? "",
      fechaVisita: json["fechaVisita"] == null ||
              json["fechaVisita"].isEmpty ||
              json["fechaVisita"] == 'null'
          ? null
          : DateTime.parse(json["fechaVisita"]),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "ot": ot,
      "usuario": usuario,
      "idTecnico": idTecnico,
      "nombreTecnico": nombreTecnico,
      "cliente": cliente,
      "nombreCliente": nombreCliente,
      "nodo": nodo,
      "nodoNuevo": nodoNuevo,
      "tap": tap,
      "tapNuevo": tapNuevo,
      "colilla": colilla,
      "colillaNueva": colillaNueva,
      "horaEntrada": horaEntrada,
      "horaSalida": horaSalida,
      "seriesBBI": seriesBBI,
      "seriesTV": seriesTV,
      "seriesOtras": seriesOtras,
      "estadoNodo": estadoNodo,
      "longitud": longitud,
      "latitud": latitud,
      "fecha": DateFormat('yyyy-MM-dd HH:mm:ss').format(fecha!),
      "comentario": comentario,
      "estado": estado,
      "producto": producto,
      "tipo": tipo,
      "distrito": distrito,
      "region": region,
      "fechaVisita": fechaVisita != null
          ? DateFormat('yyyy-MM-dd HH:mm:ss').format(fechaVisita!)
          : null,
      "visitado": visitado ?? "NO",
      "direccion": direccion ?? "",
      "qr": qr ?? "",
      "qrNuevo": qrNuevo ?? "",
    };
  }
}
