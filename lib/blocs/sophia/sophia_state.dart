part of 'sophia_bloc.dart';

class SophiaState extends Equatable {
  final bool actualizandoOt;
  final List<ConsultaOt> otConsultada;
  final List<ConsultaOt> listaOts;
  final List<ConsultaOt> listaFiltradas;
  final bool filtrarCerradas;
  final bool filtrarPendientes;
  final bool filtrarSubs;
  final bool expandirOt;
  final String mensaje;

  const SophiaState({
    this.actualizandoOt = false,
    this.otConsultada = const [],
    this.listaOts = const [],
    this.listaFiltradas = const [],
    this.filtrarCerradas = false,
    this.filtrarPendientes = false,
    this.filtrarSubs = false,
    this.expandirOt = false,
    this.mensaje = "",
  });

  SophiaState copyWith({
    bool? actualizandoOt,
    List<ConsultaOt>? otConsultada,
    List<ConsultaOt>? listaOts,
    List<ConsultaOt>? listaFiltradas,
    bool? filtrarCerradas,
    bool? filtrarPendientes,
    bool? filtrarSubs,
    bool? expandirOt,
    String? mensaje,
  }) =>
      SophiaState(
        actualizandoOt: actualizandoOt ?? this.actualizandoOt,
        otConsultada: otConsultada ?? this.otConsultada,
        listaOts: listaOts ?? this.listaOts,
        listaFiltradas: listaFiltradas ?? this.listaFiltradas,
        filtrarCerradas: filtrarCerradas ?? this.filtrarCerradas,
        filtrarPendientes: filtrarPendientes ?? this.filtrarPendientes,
        filtrarSubs: filtrarSubs ?? this.filtrarSubs,
        expandirOt: expandirOt ?? this.expandirOt,
        mensaje: mensaje ?? this.mensaje,
      );

  @override
  List<Object> get props => [
        actualizandoOt,
        otConsultada,
        listaOts,
        listaFiltradas,
        filtrarCerradas,
        filtrarPendientes,
        filtrarSubs,
        expandirOt,
        mensaje,
      ];
}
