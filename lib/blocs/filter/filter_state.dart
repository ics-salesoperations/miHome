part of 'filter_bloc.dart';

class FilterState extends Equatable {
  final List<NodoResumen> nodos;
  final List<Agenda> clientes;
  final List<OT> ots;
  final List<Agenda> selectedCliente;
  final List<Georreferencia> geos;
  final bool cargandoClientes;
  final bool isSelectedCliente;
  final bool cargandoGeo;
  final List<Georreferencia> nodosLst;
  final List<Georreferencia> tapsLst;
  final bool cargandoNodos;
  final bool cargandoTaps;
  final bool cargandoOts;
  final bool seleccionandoTap;

  const FilterState({
    this.selectedCliente = const <Agenda>[],
    this.clientes = const <Agenda>[],
    this.nodos = const <NodoResumen>[],
    this.geos = const <Georreferencia>[],
    this.cargandoNodos = false,
    this.cargandoClientes = false,
    this.isSelectedCliente = false,
    this.cargandoGeo = false,
    this.nodosLst = const [],
    this.tapsLst = const [],
    this.cargandoTaps = false,
    this.seleccionandoTap = false,
    this.cargandoOts = false,
    this.ots = const [],
  });

  FilterState copyWith({
    List<Agenda>? selectedCliente,
    List<Agenda>? clientes,
    List<NodoResumen>? nodos,
    List<Sucursal>? sucursales,
    List<Dealer>? dealers,
    List<Georreferencia>? geos,
    bool? cargandoDealers,
    bool? cargandoSucursales,
    bool? cargandoNodos,
    bool? cargandoClientes,
    bool? isSelectedCliente,
    bool? cargandoGeo,
    List<Georreferencia>? nodosLst,
    List<Georreferencia>? tapsLst,
    bool? cargandoTaps,
    bool? seleccionandoTap,
    List<OT>? ots,
    bool? cargandoOts,
  }) =>
      FilterState(
        selectedCliente: selectedCliente ?? this.selectedCliente,
        clientes: clientes ?? this.clientes,
        nodos: nodos ?? this.nodos,
        geos: geos ?? this.geos,
        cargandoNodos: cargandoNodos ?? this.cargandoNodos,
        cargandoClientes: cargandoClientes ?? this.cargandoClientes,
        isSelectedCliente: isSelectedCliente ?? this.isSelectedCliente,
        cargandoGeo: cargandoGeo ?? this.cargandoGeo,
        nodosLst: nodosLst ?? this.nodosLst,
        tapsLst: tapsLst ?? this.tapsLst,
        cargandoTaps: cargandoTaps ?? this.cargandoTaps,
        seleccionandoTap: seleccionandoTap ?? this.seleccionandoTap,
        ots: ots ?? this.ots,
        cargandoOts: cargandoOts ?? this.cargandoOts,
      );

  @override
  List<Object> get props => [
        clientes,
        geos,
        cargandoNodos,
        cargandoClientes,
        isSelectedCliente,
        selectedCliente,
        cargandoGeo,
        nodosLst,
        tapsLst,
        seleccionandoTap,
        ots,
        cargandoOts,
      ];
}
