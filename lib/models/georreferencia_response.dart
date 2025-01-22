// To parse this JSON data, do
//
//     final georreferenciaResponse = georreferenciaResponseFromJson(jsonString);

import 'dart:convert';

import 'package:mihome_app/models/models.dart';

GeorreferenciaResponse georreferenciaResponseFromJson(String str) =>
    GeorreferenciaResponse.fromJson(json.decode(str));

String georreferenciaResponseToJson(GeorreferenciaResponse data) =>
    json.encode(data.toJson());

class GeorreferenciaResponse {
  String? status;
  int? count;
  List<Georreferencia>? data;

  GeorreferenciaResponse({
    this.status,
    this.count,
    this.data,
  });

  GeorreferenciaResponse copyWith({
    String? status,
    int? count,
    List<Georreferencia>? data,
  }) =>
      GeorreferenciaResponse(
        status: status ?? this.status,
        count: count ?? this.count,
        data: data ?? this.data,
      );

  factory GeorreferenciaResponse.fromJson(Map<String, dynamic> json) =>
      GeorreferenciaResponse(
        status: json["status"],
        count: json["count"],
        data: json["data"] == null
            ? []
            : List<Georreferencia>.from(
                json["data"]!.map((x) => Georreferencia.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
    "count": count,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}
