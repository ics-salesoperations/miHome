part of 'sophia_bloc.dart';

abstract class SophiaEvent extends Equatable {
  const SophiaEvent();

  @override
  List<Object> get props => [];
}

class OnConsultandoOt extends SophiaEvent {
  final bool actualizandoOt;
  final List<ConsultaOt> otConsultada;

  const OnConsultandoOt({
    required this.actualizandoOt,
    required this.otConsultada,
  });
}

class OnExpandirOt extends SophiaEvent {
  final bool expandirOt;
  final List<ConsultaOt> otConsultada;

  const OnExpandirOt({
    required this.expandirOt,
    required this.otConsultada,
  });
}

class OnCargarOts extends SophiaEvent {
  final bool actualizandoOt;
  final List<ConsultaOt> listaOts;

  const OnCargarOts({
    required this.actualizandoOt,
    required this.listaOts,
  });
}

class OnFiltrarCerradas extends SophiaEvent {
  final bool filtrarCerradas;
  final List<ConsultaOt> listaFiltradas;

  const OnFiltrarCerradas({
    required this.filtrarCerradas,
    required this.listaFiltradas,
  });
}

class OnFiltrarPendientes extends SophiaEvent {
  final bool filtrarPendientes;
  final List<ConsultaOt> listaFiltradas;

  const OnFiltrarPendientes({
    required this.filtrarPendientes,
    required this.listaFiltradas,
  });
}

class OnFiltrarSubscripciones extends SophiaEvent {
  final bool filtrarSubs;
  final List<ConsultaOt> listaFiltradas;

  const OnFiltrarSubscripciones({
    required this.filtrarSubs,
    required this.listaFiltradas,
  });
}
