// To parse this JSON data, do
//
//     final planningResponse = planningResponseFromJson(jsonString);

import 'dart:convert';

import 'package:mihome_app/models/models.dart';

OtResponse otResponseFromJson(String str) =>
    OtResponse.fromJson(json.decode(str));

String otResponseToJson(OtResponse data) => json.encode(data.toJson());

class OtResponse {
  OtResponse({
    this.status,
    this.data = const <OT>[],
  });

  String? status;
  List<OT> data;

  OtResponse copyWith({
    String? status,
    List<OT>? data,
  }) =>
      OtResponse(
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory OtResponse.fromJson(Map<String, dynamic> json) => OtResponse(
        status: json["status"],
        data: List<OT>.from(
          json["data"].map(
            (x) {
              return OT.fromJson(x);
            },
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
