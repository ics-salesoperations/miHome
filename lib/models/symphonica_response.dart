// To parse this JSON data, do
//
//     final symphonicaResponse = symphonicaResponseFromJson(jsonString);

import 'dart:convert';

SymphonicaResponse symphonicaResponseFromJson(String str) =>
    SymphonicaResponse.fromJson(json.decode(str));

String symphonicaResponseToJson(SymphonicaResponse data) =>
    json.encode(data.toJson());

class SymphonicaResponse {
  final String status;
  final int records;
  final List<Datum> data;

  SymphonicaResponse({
    required this.status,
    required this.records,
    required this.data,
  });

  SymphonicaResponse copyWith({
    String? status,
    int? records,
    List<Datum>? data,
  }) =>
      SymphonicaResponse(
        status: status ?? this.status,
        records: records ?? this.records,
        data: data ?? this.data,
      );

  factory SymphonicaResponse.fromJson(Map<String, dynamic> json) =>
      SymphonicaResponse(
        status: json["status"],
        records: json["records"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "records": records,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  final String id;
  final String organizationCode;
  final String publicIdentifier;
  final String name;
  final String description;
  final String category;
  final String region;
  final String type;
  final String baseType;
  final String lifecycleState;
  final String version;
  final ValidFor validFor;
  final List<dynamic> notes;
  final List<Nms> relatedParty;
  final List<ResourceCharacteristic> resourceCharacteristics;
  final Nms resourceSpecification;
  final bool isServiceComposite;
  final Nms nms;
  final dynamic ipAddress;
  final bool useIpV6;
  final dynamic hostname;
  final dynamic vendorModelVersion;
  final List<dynamic> fallbackResources;
  final dynamic connectionInterfaceCli;
  final dynamic connectionInterfaceHttp;
  final dynamic connectionInterfaceLdap;
  final dynamic connectionInterfaceSnmp;
  final dynamic connectionInterfaceSql;
  final List<dynamic> resourceRelationship;
  final List<dynamic> links;

  Datum({
    required this.id,
    required this.organizationCode,
    required this.publicIdentifier,
    required this.name,
    required this.description,
    required this.category,
    required this.region,
    required this.type,
    required this.baseType,
    required this.lifecycleState,
    required this.version,
    required this.validFor,
    required this.notes,
    required this.relatedParty,
    required this.resourceCharacteristics,
    required this.resourceSpecification,
    required this.isServiceComposite,
    required this.nms,
    required this.ipAddress,
    required this.useIpV6,
    required this.hostname,
    required this.vendorModelVersion,
    required this.fallbackResources,
    required this.connectionInterfaceCli,
    required this.connectionInterfaceHttp,
    required this.connectionInterfaceLdap,
    required this.connectionInterfaceSnmp,
    required this.connectionInterfaceSql,
    required this.resourceRelationship,
    required this.links,
  });

  Datum copyWith({
    String? id,
    String? organizationCode,
    String? publicIdentifier,
    String? name,
    String? description,
    String? category,
    String? region,
    String? type,
    String? baseType,
    String? lifecycleState,
    String? version,
    ValidFor? validFor,
    List<dynamic>? notes,
    List<Nms>? relatedParty,
    List<ResourceCharacteristic>? resourceCharacteristics,
    Nms? resourceSpecification,
    bool? isServiceComposite,
    Nms? nms,
    dynamic ipAddress,
    bool? useIpV6,
    dynamic hostname,
    dynamic vendorModelVersion,
    List<dynamic>? fallbackResources,
    dynamic connectionInterfaceCli,
    dynamic connectionInterfaceHttp,
    dynamic connectionInterfaceLdap,
    dynamic connectionInterfaceSnmp,
    dynamic connectionInterfaceSql,
    List<dynamic>? resourceRelationship,
    List<dynamic>? links,
  }) =>
      Datum(
        id: id ?? this.id,
        organizationCode: organizationCode ?? this.organizationCode,
        publicIdentifier: publicIdentifier ?? this.publicIdentifier,
        name: name ?? this.name,
        description: description ?? this.description,
        category: category ?? this.category,
        region: region ?? this.region,
        type: type ?? this.type,
        baseType: baseType ?? this.baseType,
        lifecycleState: lifecycleState ?? this.lifecycleState,
        version: version ?? this.version,
        validFor: validFor ?? this.validFor,
        notes: notes ?? this.notes,
        relatedParty: relatedParty ?? this.relatedParty,
        resourceCharacteristics:
            resourceCharacteristics ?? this.resourceCharacteristics,
        resourceSpecification:
            resourceSpecification ?? this.resourceSpecification,
        isServiceComposite: isServiceComposite ?? this.isServiceComposite,
        nms: nms ?? this.nms,
        ipAddress: ipAddress ?? this.ipAddress,
        useIpV6: useIpV6 ?? this.useIpV6,
        hostname: hostname ?? this.hostname,
        vendorModelVersion: vendorModelVersion ?? this.vendorModelVersion,
        fallbackResources: fallbackResources ?? this.fallbackResources,
        connectionInterfaceCli:
            connectionInterfaceCli ?? this.connectionInterfaceCli,
        connectionInterfaceHttp:
            connectionInterfaceHttp ?? this.connectionInterfaceHttp,
        connectionInterfaceLdap:
            connectionInterfaceLdap ?? this.connectionInterfaceLdap,
        connectionInterfaceSnmp:
            connectionInterfaceSnmp ?? this.connectionInterfaceSnmp,
        connectionInterfaceSql:
            connectionInterfaceSql ?? this.connectionInterfaceSql,
        resourceRelationship: resourceRelationship ?? this.resourceRelationship,
        links: links ?? this.links,
      );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        organizationCode: json["organizationCode"] ?? "",
        publicIdentifier: json["publicIdentifier"] ?? "",
        name: json["name"] ?? "",
        description: json["description"] ?? "",
        category: json["category"] ?? "",
        region: json["region"] ?? "",
        type: json["type"] ?? "",
        baseType: json["baseType"] ?? "",
        lifecycleState: json["lifecycleState"] ?? "",
        version: json["version"] ?? "",
        validFor: ValidFor.fromJson(json["validFor"]),
        notes: List<dynamic>.from(json["notes"].map((x) => x)),
        relatedParty:
            List<Nms>.from(json["relatedParty"].map((x) => Nms.fromJson(x))),
        resourceCharacteristics: List<ResourceCharacteristic>.from(
            json["resourceCharacteristics"]
                .map((x) => ResourceCharacteristic.fromJson(x))),
        resourceSpecification: Nms.fromJson(json["resourceSpecification"]),
        isServiceComposite: json["isServiceComposite"],
        nms: Nms.fromJson(json["nms"]),
        ipAddress: json["ipAddress"],
        useIpV6: json["useIpV6"],
        hostname: json["hostname"],
        vendorModelVersion: json["vendorModelVersion"],
        fallbackResources:
            List<dynamic>.from(json["fallbackResources"].map((x) => x)),
        connectionInterfaceCli: json["connectionInterfaceCli"],
        connectionInterfaceHttp: json["connectionInterfaceHttp"],
        connectionInterfaceLdap: json["connectionInterfaceLdap"],
        connectionInterfaceSnmp: json["connectionInterfaceSnmp"],
        connectionInterfaceSql: json["connectionInterfaceSql"],
        resourceRelationship:
            List<dynamic>.from(json["resourceRelationship"].map((x) => x)),
        links: List<dynamic>.from(json["links"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organizationCode": organizationCode,
        "publicIdentifier": publicIdentifier,
        "name": name,
        "description": description,
        "category": category,
        "region": region,
        "type": type,
        "baseType": baseType,
        "lifecycleState": lifecycleState,
        "version": version,
        "validFor": validFor.toJson(),
        "notes": List<dynamic>.from(notes.map((x) => x)),
        "relatedParty": List<dynamic>.from(relatedParty.map((x) => x.toJson())),
        "resourceCharacteristics":
            List<dynamic>.from(resourceCharacteristics.map((x) => x.toJson())),
        "resourceSpecification": resourceSpecification.toJson(),
        "isServiceComposite": isServiceComposite,
        "nms": nms.toJson(),
        "ipAddress": ipAddress,
        "useIpV6": useIpV6,
        "hostname": hostname,
        "vendorModelVersion": vendorModelVersion,
        "fallbackResources":
            List<dynamic>.from(fallbackResources.map((x) => x)),
        "connectionInterfaceCli": connectionInterfaceCli,
        "connectionInterfaceHttp": connectionInterfaceHttp,
        "connectionInterfaceLdap": connectionInterfaceLdap,
        "connectionInterfaceSnmp": connectionInterfaceSnmp,
        "connectionInterfaceSql": connectionInterfaceSql,
        "resourceRelationship":
            List<dynamic>.from(resourceRelationship.map((x) => x)),
        "links": List<dynamic>.from(links.map((x) => x)),
      };
}

class Nms {
  final String id;
  final String source;
  final String name;
  final String role;
  final String version;

  Nms({
    required this.id,
    required this.source,
    required this.name,
    required this.role,
    required this.version,
  });

  Nms copyWith({
    String? id,
    String? source,
    String? name,
    String? role,
    String? version,
  }) =>
      Nms(
        id: id ?? this.id,
        source: source ?? this.source,
        name: name ?? this.name,
        role: role ?? this.role,
        version: version ?? this.version,
      );

  factory Nms.fromJson(Map<String, dynamic> json) => Nms(
        id: json["id"],
        source: json["source"].toString(),
        name: json["name"].toString(),
        role: json["role"].toString(),
        version: json["version"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "source": source,
        "name": name,
        "role": role,
        "version": version,
      };
}

class ResourceCharacteristic {
  final String id;
  final String name;
  final String value;
  final List<ResourceCharacteristic> characteristicRelationships;

  ResourceCharacteristic({
    required this.id,
    required this.name,
    required this.value,
    required this.characteristicRelationships,
  });

  ResourceCharacteristic copyWith({
    String? id,
    String? name,
    String? value,
    List<ResourceCharacteristic>? characteristicRelationships,
  }) =>
      ResourceCharacteristic(
        id: id ?? this.id,
        name: name ?? this.name,
        value: value ?? this.value,
        characteristicRelationships:
            characteristicRelationships ?? this.characteristicRelationships,
      );

  factory ResourceCharacteristic.fromJson(Map<String, dynamic> json) =>
      ResourceCharacteristic(
        id: json["id"],
        name: json["name"],
        value: json["value"],
        characteristicRelationships: [] /*List<ResourceCharacteristic>.from(
          json["characteristicRelationships"].map(
            (x) => ResourceCharacteristic.fromJson(x),
          ),
        )*/
        ,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "value": value,
        "characteristicRelationships": List<dynamic>.from(
            characteristicRelationships.map((x) => x.toJson())),
      };
}

class ValidFor {
  final DateTime startDateTime;
  final dynamic endDateTime;

  ValidFor({
    required this.startDateTime,
    required this.endDateTime,
  });

  ValidFor copyWith({
    DateTime? startDateTime,
    dynamic endDateTime,
  }) =>
      ValidFor(
        startDateTime: startDateTime ?? this.startDateTime,
        endDateTime: endDateTime ?? this.endDateTime,
      );

  factory ValidFor.fromJson(Map<String, dynamic> json) => ValidFor(
        startDateTime: DateTime.parse(json["startDateTime"]),
        endDateTime: json["endDateTime"],
      );

  Map<String, dynamic> toJson() => {
        "startDateTime": startDateTime.toIso8601String(),
        "endDateTime": endDateTime,
      };
}
