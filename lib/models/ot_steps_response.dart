// To parse this JSON data, do
//
//     final planningResponse = planningResponseFromJson(jsonString);

import 'dart:convert';

import 'package:mihome_app/models/models.dart';

OTStepsResponse otStepsResponseFromJson(String str) =>
    OTStepsResponse.fromJson(json.decode(str));

String otStepsResponseToJson(OTStepsResponse data) =>
    json.encode(data.toJson());

class OTStepsResponse {
  OTStepsResponse({
    this.status,
    this.data = const <OTSteps>[],
  });

  String? status;
  List<OTSteps> data;

  OTStepsResponse copyWith({
    String? status,
    List<OTSteps>? data,
  }) =>
      OTStepsResponse(
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory OTStepsResponse.fromJson(Map<String, dynamic> json) =>
      OTStepsResponse(
        status: json["status"],
        data: List<OTSteps>.from(
          json["data"].map(
            (x) {
              return OTSteps.fromJson(x);
            },
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
