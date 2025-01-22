part of 'ot_step_bloc.dart';

abstract class OTStepEvent extends Equatable {
  const OTStepEvent();

  @override
  List<Object> get props => [];
}

class OnCargarStepsEvent extends OTStepEvent {
  final List<OTSteps> steps;
  final bool actualizandoSteps;
  final int currentStep;
  final String mensaje;

  const OnCargarStepsEvent({
    required this.steps,
    required this.actualizandoSteps,
    required this.currentStep,
    required this.mensaje,
  });
}

class OnChangeCurrentEvent extends OTStepEvent {
  final int currentStep;

  const OnChangeCurrentEvent({
    required this.currentStep,
  });
}

class OnChangeGuardado extends OTStepEvent {
  final bool guardado;
  final String mensaje;

  const OnChangeGuardado({
    required this.guardado,
    required this.mensaje,
  });
}

class OnChangeEnviado extends OTStepEvent {
  final bool enviado;
  final String mensaje;

  const OnChangeEnviado({
    required this.enviado,
    required this.mensaje,
  });
}

class OnCargarEquiposEvent extends OTStepEvent {
  final List<EquipoInstalado>? equipos;
  const OnCargarEquiposEvent({
    required this.equipos,
  });
}

class OnCambiarColillaActualizada extends OTStepEvent {
  final bool colillaActualizada;
  const OnCambiarColillaActualizada({
    required this.colillaActualizada,
  });
}

class OnCambiarColillaValida extends OTStepEvent {
  final bool colillaValida;
  const OnCambiarColillaValida({
    required this.colillaValida,
  });
}

class OnCambiarOT extends OTStepEvent {
  final List<Agenda> ot;
  const OnCambiarOT({
    required this.ot,
  });
}

class OnUpdateProcesando extends OTStepEvent {
  final bool procesando;
  const OnUpdateProcesando({
    required this.procesando,
  });
}
