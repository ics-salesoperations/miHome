import 'package:mihome_app/models/model.dart';

class FormularioResumen extends Model {
  FormularioResumen({
    id,
    this.formId,
    this.formName,
    this.formDescription,
    this.type,
    this.subType,
    this.guardado = false,
    this.enviado = false,
    this.cantGuardado = 0,
  }) : super(id);

  int? formId;
  String? formName;
  String? formDescription;
  String? type;
  String? subType;
  bool? guardado;
  bool? enviado;
  int? cantGuardado;

  FormularioResumen copyWith({
    int? formId,
    String? formName,
    String? formDescription,
    String? subType,
    String? type,
    bool? guardado,
    bool? enviado,
    int? cantGuardado,
  }) =>
      FormularioResumen(
        formId: formId ?? this.formId,
        formName: formName ?? this.formName,
        formDescription: formDescription ?? this.formDescription,
        type: type ?? this.type,
        subType: subType ?? this.subType,
        guardado: guardado ?? this.guardado,
        enviado: enviado ?? this.enviado,
        cantGuardado: cantGuardado ?? this.cantGuardado,
      );

  factory FormularioResumen.fromMap(Map<String, dynamic> json) =>
      FormularioResumen(
        id: json["id"],
        formId: json["formId"],
        formName: json["formName"],
        formDescription: json["formDescription"],
        type: json["type"],
        subType: json["subType"],
        cantGuardado: json["cantGuardado"],
        guardado: json["guardado"] ?? false,
        enviado: json["enviado"] ?? false,
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "formId": formId,
        "formName": formName,
        "formDescription": formDescription,
        "type": type,
        "subType": subType,
        "cantGuardado": cantGuardado,
        "guardado": guardado ?? false,
        "enviado": enviado ?? false,
      };
}
