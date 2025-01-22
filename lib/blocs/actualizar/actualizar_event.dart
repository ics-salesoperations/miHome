part of 'actualizar_bloc.dart';

abstract class ActualizarEvent extends Equatable {
  const ActualizarEvent();

  @override
  List<Object> get props => [];
}

class OnActualizarFormulariosEvent extends ActualizarEvent {
  final String mensaje;
  final bool actualizandoForms;
  final List<Tabla> tablas;

  const OnActualizarFormulariosEvent({
    required this.actualizandoForms,
    required this.mensaje,
    required this.tablas,
  });
}

class OnGetTablasEvent extends ActualizarEvent {
  final List<Tabla> tablas;

  const OnGetTablasEvent({
    required this.tablas,
  });
}

class OnActualizarAgendaEvent extends ActualizarEvent {
  final String mensaje;
  final bool actualizandoAgenda;
  final List<Tabla> tablas;

  const OnActualizarAgendaEvent({
    required this.actualizandoAgenda,
    required this.mensaje,
    required this.tablas,
  });
}

class OnActualizarModelosEvent extends ActualizarEvent {
  final String mensaje;
  final bool actualizandoModelos;
  final List<Tabla> tablas;

  const OnActualizarModelosEvent({
    required this.actualizandoModelos,
    required this.mensaje,
    required this.tablas,
  });
}

class OnActualizarTangiblesEvent extends ActualizarEvent {
  final String mensaje;
  final bool actualizandoTangible;
  final List<Tabla> tablas;

  const OnActualizarTangiblesEvent({
    required this.actualizandoTangible,
    required this.mensaje,
    required this.tablas,
  });
}

class OnActualizarGeoEvent extends ActualizarEvent {
  final String mensaje;
  final bool actualizandoGeo;
  final List<Tabla> tablas;

  const OnActualizarGeoEvent({
    required this.actualizandoGeo,
    required this.mensaje,
    required this.tablas,
  });
}

class OnConsultarEquipoEvent extends ActualizarEvent {
  final String mensaje;
  final bool consultandoEquipo;
  final List<SymphonicaResponse> equipos;

  const OnConsultarEquipoEvent({
    required this.consultandoEquipo,
    required this.mensaje,
    required this.equipos,
  });
}

class OnActualizarOtsEvent extends ActualizarEvent {
  final String mensaje;
  final bool actualizandoOts;
  final List<Tabla> tablas;

  const OnActualizarOtsEvent({
    required this.actualizandoOts,
    required this.mensaje,
    required this.tablas,
  });
}
