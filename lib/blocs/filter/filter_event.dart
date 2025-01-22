part of 'filter_bloc.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object> get props => [];
}

class OnCargarNodosEvent extends FilterEvent {
  final List<NodoResumen> nodos;
  final bool cargandoNodos;

  const OnCargarNodosEvent({
    required this.nodos,
    required this.cargandoNodos,
  });
}

class OnCargarClientesEvent extends FilterEvent {
  final List<Agenda> clientes;
  final bool cargandoClientes;

  const OnCargarClientesEvent({
    required this.clientes,
    required this.cargandoClientes,
  });
}

class OnCargarOtsEvent extends FilterEvent {
  final List<OT> ots;
  final bool cargandoOts;

  const OnCargarOtsEvent({
    required this.ots,
    required this.cargandoOts,
  });
}

class OnCargarFiltrosEvent extends FilterEvent {
  final List<Georreferencia> nodosLst;
  final List<Georreferencia> tapsLst;
  final bool cargandoNodos;
  final bool cargandoTaps;
  final bool seleccionandoTap;

  const OnCargarFiltrosEvent({
    required this.nodosLst,
    required this.tapsLst,
    required this.cargandoNodos,
    required this.cargandoTaps,
    required this.seleccionandoTap,
  });
}

class OnCargarGeoEvent extends FilterEvent {
  final List<Georreferencia> geos;
  final bool cargandoGeos;

  const OnCargarGeoEvent({
    required this.geos,
    required this.cargandoGeos,
  });
}

class OnSelectClienteEvent extends FilterEvent {
  final List<Agenda> selectedCliente;
  final bool isSelectedCliente;

  const OnSelectClienteEvent({
    required this.selectedCliente,
    required this.isSelectedCliente,
  });
}
