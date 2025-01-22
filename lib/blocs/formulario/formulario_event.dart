part of 'formulario_bloc.dart';

abstract class FormularioEvent extends Equatable {
  const FormularioEvent();

  @override
  List<Object> get props => [];
}

class OnActualizarFormsEvent extends FormularioEvent {
  final List<FormularioResumen> formularios;
  final bool formsActualizados;

  const OnActualizarFormsEvent({
    required this.formularios,
    required this.formsActualizados,
  });
}

class OnCargarFormsEvent extends FormularioEvent {
  final List<FormularioResumen> formularios;
  final FormGroup? formgroupVisita;
  final List<Formulario> lstFormVisita;
  final bool isFrmVisitaListo;

  const OnCargarFormsEvent({
    required this.formularios,
    this.formgroupVisita,
    required this.lstFormVisita,
    required this.isFrmVisitaListo,
  });
}

class OnCurrentFormReadyEvent extends FormularioEvent {
  final List<Formulario> currentForm;
  final FormGroup? formGroup;
  final bool isCurrentFormReady;

  const OnCurrentFormReadyEvent({
    required this.currentForm,
    required this.isCurrentFormReady,
    this.formGroup,
  });
}

class OnCurrentFormsSaving extends FormularioEvent {
  final List<Formulario>? currentForm;
  final FormGroup? formGroup;
  final List<Formulario>? currentFormAud;
  final FormGroup? formGroupAud;

  const OnCurrentFormsSaving({
    this.currentForm,
    this.formGroup,
    this.currentFormAud,
    this.formGroupAud,
  });
}

class OnProcessingEvent extends FormularioEvent {
  final String mensaje;
  final bool enviadoVisita;
  final bool? procesando;

  const OnProcessingEvent({
    required this.mensaje,
    required this.enviadoVisita,
    this.procesando,
  });
}

class OnUpdateProcessing extends FormularioEvent {
  final bool guardado;
  final bool enviado;
  final bool? procesando;

  const OnUpdateProcessing({
    required this.guardado,
    required this.enviado,
    this.procesando,
  });
}

class OnChangeBetweenForms extends FormularioEvent {
  final int frmActualVisita;

  const OnChangeBetweenForms({
    required this.frmActualVisita,
  });
}

class OnUpdateFormsEvent extends FormularioEvent {
  final List<FormularioResumen> formularios;
  final List<FormularioResumen> formulariosAud;

  const OnUpdateFormsEvent({
    required this.formularios,
    required this.formulariosAud,
  });
}

class OnCargarFormsAudEvent extends FormularioEvent {
  final List<FormularioResumen> formulariosAud;
  final FormGroup? formGroupAud;
  final List<Formulario> lstFormAud;
  final bool isFrmAudListo;

  const OnCargarFormsAudEvent({
    required this.formulariosAud,
    this.formGroupAud,
    required this.lstFormAud,
    required this.isFrmAudListo,
  });
}
