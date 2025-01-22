part of 'ot_step_bloc.dart';

class OTStepState extends Equatable {
  final List<Agenda> ot;
  final List<OTSteps> steps;
  final List<EquipoInstalado> equipos;
  final bool actualizandoSteps;
  final int currentStep;
  final String mensaje;
  final bool guardado;
  final bool enviado;
  final bool colillaActualizada;
  final bool colillaValida;
  final bool procesando;

  const OTStepState({
    this.steps = const <OTSteps>[],
    this.equipos = const <EquipoInstalado>[],
    this.ot = const [],
    this.actualizandoSteps = false,
    this.currentStep = 0,
    this.mensaje = "",
    this.guardado = false,
    this.enviado = false,
    this.colillaActualizada = false,
    this.colillaValida = false,
    this.procesando = false,
  });

  OTStepState copyWith({
    List<OTSteps>? steps,
    List<EquipoInstalado>? equipos,
    List<Agenda>? ot,
    bool? actualizandoSteps,
    int? currentStep,
    String? mensaje,
    bool? guardado,
    bool? enviado,
    bool? colillaActualizada,
    bool? colillaValida,
    bool? procesando,
  }) =>
      OTStepState(
        steps: steps ?? this.steps,
        equipos: equipos ?? this.equipos,
        actualizandoSteps: actualizandoSteps ?? this.actualizandoSteps,
        currentStep: currentStep ?? this.currentStep,
        mensaje: mensaje ?? this.mensaje,
        guardado: guardado ?? this.guardado,
        enviado: enviado ?? this.enviado,
        colillaActualizada: colillaActualizada ?? this.colillaActualizada,
        colillaValida: colillaValida ?? this.colillaValida,
        ot: ot ?? this.ot,
        procesando: procesando ?? this.procesando,
      );

  @override
  List<Object> get props => [
        steps,
        equipos,
        actualizandoSteps,
        currentStep,
        mensaje,
        guardado,
        enviado,
        colillaActualizada,
        ot,
        colillaValida,
        procesando,
      ];
}
