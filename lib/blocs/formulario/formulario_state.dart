part of 'formulario_bloc.dart';

class FormularioState extends Equatable {
  final List<FormularioResumen> formularios;
  final bool formsActualizados;
  final List<Formulario> currentForm;
  final FormGroup? currentFormgroup;
  final FormGroup? formgroupVisita;
  final List<Formulario> lstFormVisita;
  final bool isCurrentFormListo;
  final bool isFrmVisitaListo;
  final int frmActualVisita;
  final String mensaje;
  final int procesado;
  final int sinProcesar;
  final bool guardado;
  final bool enviado;
  final List<FormularioResumen> formulariosAud;
  final FormGroup? formGroupAud;
  final List<Formulario> lstFormAud;
  final bool isFrmAudListo;
  final bool enviadoVisita;
  final bool procesando;

  const FormularioState({
    this.formularios = const [],
    this.formsActualizados = false,
    this.isCurrentFormListo = false,
    this.isFrmVisitaListo = false,
    this.currentForm = const [],
    this.formgroupVisita,
    this.lstFormVisita = const [],
    this.currentFormgroup,
    this.mensaje = "",
    this.procesado = 0,
    this.sinProcesar = 0,
    this.frmActualVisita = 0,
    this.guardado = false,
    this.enviado = false,
    this.formulariosAud = const [],
    this.formGroupAud,
    this.lstFormAud = const [],
    this.isFrmAudListo = false,
    this.enviadoVisita = false,
    this.procesando = false,
  });

  FormularioState copyWith({
    List<FormularioResumen>? formularios,
    bool? formsActualizados,
    List<Formulario>? currentForm,
    List<Formulario>? lstFormVisita,
    FormGroup? formgroupVisita,
    bool? isCurrentFormListo,
    bool? isFrmVisitaListo,
    int? frmActualVisita,
    FormGroup? currentFormgroup,
    String? mensaje,
    int? procesado,
    int? sinProcesar,
    bool? guardado,
    bool? enviado,
    List<FormularioResumen>? formulariosAud,
    FormGroup? formGroupAud,
    List<Formulario>? lstFormAud,
    bool? isFrmAudListo,
    bool? enviadoVisita,
    bool? procesando,
  }) =>
      FormularioState(
        formularios: formularios ?? this.formularios,
        formsActualizados: formsActualizados ?? this.formsActualizados,
        currentForm: currentForm ?? this.currentForm,
        isCurrentFormListo: isCurrentFormListo ?? this.isCurrentFormListo,
        isFrmVisitaListo: isFrmVisitaListo ?? this.isFrmVisitaListo,
        currentFormgroup: currentFormgroup ?? this.currentFormgroup,
        lstFormVisita: lstFormVisita ?? this.lstFormVisita,
        formgroupVisita: formgroupVisita ?? this.formgroupVisita,
        frmActualVisita: frmActualVisita ?? this.frmActualVisita,
        mensaje: mensaje ?? this.mensaje,
        procesado: procesado ?? this.procesado,
        sinProcesar: sinProcesar ?? this.sinProcesar,
        guardado: guardado ?? this.guardado,
        enviado: enviado ?? this.enviado,
        formulariosAud: formulariosAud ?? this.formulariosAud,
        formGroupAud: formGroupAud ?? this.formGroupAud,
        lstFormAud: lstFormAud ?? this.lstFormAud,
        isFrmAudListo: isFrmAudListo ?? this.isFrmAudListo,
        enviadoVisita: enviadoVisita ?? this.enviadoVisita,
        procesando: procesando ?? this.procesando,
      );

  @override
  List<Object> get props => [
        formularios,
        formsActualizados,
        isCurrentFormListo,
        isFrmVisitaListo,
        currentForm,
        lstFormVisita,
        mensaje,
        procesado,
        sinProcesar,
        guardado,
        enviado,
        frmActualVisita,
        formulariosAud,
        lstFormAud,
        isFrmAudListo,
        frmActualVisita,
        procesando,
      ];
}
