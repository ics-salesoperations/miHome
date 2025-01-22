import 'dart:convert';

import 'package:mihome_app/models/models.dart';

ConsultaOtResponse consultaOtResponseFromJson(String str) =>
    ConsultaOtResponse.fromJson(json.decode(str));

String consultaOtResponseToJson(ConsultaOtResponse data) =>
    json.encode(data.toJson());

class ConsultaOtResponse {
  final String? status;
  final int? records;
  final String? usuario;
  final int? isSuscriptor;
  final ConsultaOt? data;

  ConsultaOtResponse({
    this.status,
    this.records,
    this.usuario,
    this.isSuscriptor,
    this.data,
  });

  ConsultaOtResponse copyWith({
    String? status,
    int? records,
    String? usuario,
    int? isSuscriptor,
    ConsultaOt? data,
  }) =>
      ConsultaOtResponse(
        status: status ?? this.status,
        records: records ?? this.records,
        usuario: usuario ?? this.usuario,
        isSuscriptor: isSuscriptor ?? this.isSuscriptor,
        data: data ?? this.data,
      );

  factory ConsultaOtResponse.fromJson(Map<String, dynamic> json) =>
      ConsultaOtResponse(
        status: json["status"],
        data: ConsultaOt.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data,
      };
}
