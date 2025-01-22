// To parse this JSON data, do
//
//     final planningResponse = planningResponseFromJson(jsonString);

import 'dart:convert';

import 'package:mihome_app/models/models.dart';

AgendaResponse agendaResponseFromJson(String str) =>
    AgendaResponse.fromJson(json.decode(str));

String agendaResponseToJson(AgendaResponse data) => json.encode(data.toJson());

class AgendaResponse {
  AgendaResponse({
    this.status,
    this.data = const <Agenda>[],
  });

  String? status;
  List<Agenda> data;

  AgendaResponse copyWith({
    String? status,
    List<Agenda>? data,
  }) =>
      AgendaResponse(
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory AgendaResponse.fromJson(Map<String, dynamic> json) => AgendaResponse(
        status: json["status"],
        data: List<Agenda>.from(
          json["data"].map(
            (x) {
              return Agenda.fromJson(x);
            },
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
