import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mihome_app/models/models.dart';
import 'package:mihome_app/services/db_service.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final DBService _dbService = DBService();

  FilterBloc() : super(const FilterState()) {
    on<OnCargarNodosEvent>((event, emit) {
      emit(
        state.copyWith(
          cargandoNodos: event.cargandoNodos,
          nodos: event.nodos,
        ),
      );
    });
    on<OnCargarClientesEvent>((event, emit) {
      emit(
        state.copyWith(
          clientes: event.clientes,
          cargandoClientes: event.cargandoClientes,
        ),
      );
    });
    on<OnCargarOtsEvent>((event, emit) {
      emit(
        state.copyWith(
          ots: event.ots,
          cargandoOts: event.cargandoOts,
        ),
      );
    });
    on<OnCargarGeoEvent>((event, emit) {
      emit(
        state.copyWith(
          geos: event.geos,
          cargandoGeo: event.cargandoGeos,
        ),
      );
    });
    on<OnCargarFiltrosEvent>((event, emit) {
      emit(
        state.copyWith(
          nodosLst: event.nodosLst,
          tapsLst: event.tapsLst,
          cargandoNodos: event.cargandoNodos,
          cargandoTaps: event.cargandoTaps,
          seleccionandoTap: event.seleccionandoTap,
        ),
      );
    });
    on<OnSelectClienteEvent>((event, emit) {
      emit(
        state.copyWith(
          selectedCliente: event.selectedCliente,
          isSelectedCliente: event.isSelectedCliente,
        ),
      );
    });

    init();
  }

  Future<void> init() async {
    await getNodos();
    await getClientes();
    await getOtsAuditoria();
  }

  Future<void> getNodos({String? idSucursal}) async {
    add(const OnCargarNodosEvent(
      cargandoNodos: true,
      nodos: [],
    ));
    List<NodoResumen> circuito;
    try {
      circuito = await _dbService.leerNodos();
    } catch (e) {
      circuito = <NodoResumen>[];
    }
    add(OnCargarNodosEvent(
      cargandoNodos: false,
      nodos: circuito,
    ));
  }

  Future<void> getNodosFiltro() async {
    add(const OnCargarFiltrosEvent(
      cargandoNodos: true,
      nodosLst: [],
      cargandoTaps: false,
      seleccionandoTap: true,
      tapsLst: [],
    ));
    List<Georreferencia> nodos;
    try {
      nodos = await _dbService.leerNodosFiltro();
    } catch (e) {
      nodos = <Georreferencia>[];
    }
    add(OnCargarFiltrosEvent(
      cargandoNodos: false,
      nodosLst: nodos,
      cargandoTaps: false,
      seleccionandoTap: true,
      tapsLst: const [],
    ));
  }

  Future<void> getTapsFiltro({required String nodo}) async {
    add(OnCargarFiltrosEvent(
      cargandoNodos: false,
      nodosLst: state.nodosLst,
      cargandoTaps: true,
      seleccionandoTap: true,
      tapsLst: const [],
    ));
    List<Georreferencia> taps;
    try {
      taps = await _dbService.leerTapsFiltro(
        nodo: nodo,
      );
    } catch (e) {
      taps = <Georreferencia>[];
    }
    add(OnCargarFiltrosEvent(
      cargandoNodos: false,
      nodosLst: state.nodosLst,
      cargandoTaps: false,
      seleccionandoTap: true,
      tapsLst: taps,
    ));
  }

  Future<void> getClientes({
    String? idSucursal,
    String? codigoNodo,
    DateTime? fecha,
  }) async {
    add(const OnCargarClientesEvent(
      cargandoClientes: true,
      clientes: [],
    ));
    List<Agenda> clientes;
    try {
      clientes = await _dbService.leerListadoPdv(
        codigoNodo: codigoNodo,
        fecha: fecha,
      );
    } catch (e) {
      clientes = <Agenda>[];
    }

    add(OnCargarClientesEvent(
      cargandoClientes: false,
      clientes: clientes,
    ));
  }

  Future<void> getOtsAuditoria() async {
    add(const OnCargarOtsEvent(
      cargandoOts: true,
      ots: [],
    ));
    List<OT> ots;
    try {
      ots = await _dbService.leerOtsAuditoria();
    } catch (e) {
      ots = <OT>[];
    }

    add(OnCargarOtsEvent(
      cargandoOts: false,
      ots: ots,
    ));
  }

  Future<void> getGeoFiltrado({
    String? codigo,
  }) async {
    add(const OnCargarGeoEvent(
      cargandoGeos: true,
      geos: [],
    ));
    List<Georreferencia> geos;
    try {
      geos =
          await _dbService.filtrarGeoTipoParent(codigoPadre: codigo.toString());
    } catch (e) {
      geos = <Georreferencia>[];
    }

    add(OnCargarGeoEvent(
      cargandoGeos: false,
      geos: geos,
    ));
  }
}
