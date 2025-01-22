part of 'actualizar_bloc.dart';

class ActualizarState extends Equatable {
  final List<Tabla> tablas;
  final List<SymphonicaResponse> equipos;
  final bool actualizandoForms;
  final bool actualizandoAgenda;
  final bool actualizandoModelos;
  final bool actualizandoTangible;
  final bool consultandoEquipo;
  final bool actualizandoGeo;
  final bool actualizandoOts;
  final String mensaje;

  const ActualizarState({
    this.actualizandoForms = false,
    this.actualizandoAgenda = false,
    this.actualizandoModelos = false,
    this.actualizandoTangible = false,
    this.actualizandoGeo = false,
    this.actualizandoOts = false,
    this.consultandoEquipo = false,
    this.mensaje = "",
    this.tablas = const [],
    this.equipos = const [],
  });

  ActualizarState copyWith({
    bool? actualizandoForms,
    bool? actualizandoAgenda,
    bool? actualizandoModelos,
    bool? actualizandoTangible,
    bool? consultandoEquipo,
    bool? actualizandoGeo,
    bool? actualizandoOts,
    String? mensaje,
    List<Tabla>? tablas,
    List<SymphonicaResponse>? equipos,
  }) =>
      ActualizarState(
        actualizandoForms: actualizandoForms ?? this.actualizandoForms,
        actualizandoAgenda: actualizandoAgenda ?? this.actualizandoAgenda,
        actualizandoModelos: actualizandoModelos ?? this.actualizandoModelos,
        actualizandoTangible: actualizandoTangible ?? this.actualizandoTangible,
        actualizandoGeo: actualizandoGeo ?? this.actualizandoGeo,
        actualizandoOts: actualizandoOts ?? this.actualizandoOts,
        consultandoEquipo: consultandoEquipo ?? this.consultandoEquipo,
        mensaje: mensaje ?? this.mensaje,
        tablas: tablas ?? this.tablas,
        equipos: equipos ?? this.equipos,
      );

  @override
  List<Object> get props => [
        actualizandoForms,
        actualizandoAgenda,
        actualizandoModelos,
        actualizandoTangible,
        actualizandoGeo,
        actualizandoOts,
        consultandoEquipo,
        mensaje,
        tablas,
        equipos,
      ];
}
