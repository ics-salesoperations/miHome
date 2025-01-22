import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/models/models.dart';
import 'package:mihome_app/services/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'carrito_event.dart';
part 'carrito_state.dart';

class CarritoBloc extends Bloc<CarritoEvent, CarritoState> {
  final DBService _dbService = DBService();
  FormGroup formulario = FormGroup({
    'mensaje': FormControl<String>(value: 'Cargando datos'),
  });

  CarritoBloc()
      : super(
          CarritoState(
            frmProductos: FormGroup(
              {
                'mensaje': FormControl<String>(value: 'Cargando datos'),
              },
            ),
            actual: ModeloTangible(),
            serieActual: ProductoTangible(),
          ),
        ) {
    on<OnCargarModelosEvent>((event, emit) {
      emit(
        state.copyWith(
          mensaje: event.mensaje,
          cargandoModelos: event.cargandoModelos,
          modelos: event.modelos,
          actual: ModeloTangible(),
        ),
      );
    });
    on<OnCargarModelosAsignadosoEvent>((event, emit) {
      emit(
        state.copyWith(
          modelosAsignados: event.modelosAsignados,
        ),
      );
    });
    on<OnUpdateTotalEvent>((event, emit) {
      emit(
        state.copyWith(
          total: event.total,
        ),
      );
    });
    on<OnCambiarCategoriaEvent>((event, emit) {
      emit(
        state.copyWith(
          selectedCat: event.categoria,
        ),
      );
    });
    on<OnCambiarFiltroEvent>((event, emit) {
      emit(
        state.copyWith(
          filter: event.filtro,
        ),
      );
    });
    on<OnCargarFrmProductoEvent>((event, emit) {
      emit(
        state.copyWith(
          cargandoFrmProductos: event.cargandoFrmProducto,
          frmProductos: event.frmProducto,
        ),
      );
    });
    on<OnCargarLstTangibleModeloEvent>((event, emit) {
      emit(
        state.copyWith(
          cargandoLstTangibleModelo: event.cargandoLstTangibleModelo,
          lstTangibleModelo: event.lstTangibleModelo,
        ),
      );
    });
    on<OnEnviarTangiblesEvent>((event, emit) {
      emit(
        state.copyWith(
          mensaje: event.mensaje,
          enviando: event.enviando,
        ),
      );
    });
    on<OnChangeModeloActual>((event, emit) {
      emit(
        state.copyWith(
          actual: event.actual,
          modelos: state.modelos.map((elemento) {
            return elemento.modelo == event.actual.modelo
                ? event.actual
                : elemento;
          }).toList(),
        ),
      );
    });
    on<OnChangeSerieActual>((event, emit) {
      emit(
        state.copyWith(
          serieActual: event.actual,
          lstTangibleModelo: state.lstTangibleModelo.map((elemento) {
            return elemento.serie == event.actual.serie
                ? event.actual
                : elemento;
          }).toList(),
        ),
      );
    });

    //init();
  }

  Future<void> init() async {
    final m = await getModelos();
    await crearFrmProductos(m);
    await actualizaTotal();
  }

  Future<List<ModeloTangible>> getModelos() async {
    add(OnCargarModelosEvent(
      modelos: state.modelos,
      cargandoModelos: true,
      mensaje: "",
    ));

    List<ModeloTangible> modelos;

    try {
      modelos = await _dbService.leerListadoModelos();
    } catch (e) {
      modelos = const [];
      add(OnCargarModelosEvent(
          modelos: modelos,
          cargandoModelos: false,
          mensaje: "Ocurrió un error al actualizar modelos"));
    }

    add(OnCargarModelosEvent(
      modelos: modelos,
      cargandoModelos: false,
      mensaje: "",
    ));

    return modelos;
  }

  Future<void> procesarVisita({
    required int cliente,
    required String idVisita,
  }) async {
    SyncBloc _sincronizar = SyncBloc();

    add(const OnEnviarTangiblesEvent(
      enviando: true,
      mensaje: "Visita procesada correctamente.",
    ));

    await confirmarTangiblesAsignados(
      cliente: cliente,
    );

    add(const OnEnviarTangiblesEvent(
      enviando: true,
      mensaje: "Sincronizando datos.",
    ));

    await _sincronizar.sincronizarDatos();

    add(const OnEnviarTangiblesEvent(
      enviando: false,
      mensaje: "Visita procesada correctamente.",
    ));
  }

  Future<void> confirmarTangiblesAsignados({
    required int cliente,
  }) async {
    try {
      await _dbService.confirmarTangiblesAsignados(
        cliente: cliente,
      );
    } catch (e) {
      add(const OnEnviarTangiblesEvent(
        enviando: false,
        mensaje: "Ocurrió un error al procesar la venta.",
      ));
    }
  }

  Future<void> actualizaTotal() async {
    int total = 0;

    try {
      total = await _dbService.leerTotalModelos();
    } catch (e) {
      total = 0;
    }

    add(OnUpdateTotalEvent(
      total: total,
    ));
  }

  Future<void> getTangiblePorModelo({required ModeloTangible modelo}) async {
    add(const OnCargarLstTangibleModeloEvent(
      lstTangibleModelo: [],
      cargandoLstTangibleModelo: true,
    ));

    List<ProductoTangible> tangibles;

    try {
      tangibles = await _dbService.getTangibleModelo(modelo: modelo);
      add(OnCargarLstTangibleModeloEvent(
        lstTangibleModelo: tangibles,
        cargandoLstTangibleModelo: false,
      ));
    } catch (e) {
      add(const OnCargarLstTangibleModeloEvent(
        lstTangibleModelo: [],
        cargandoLstTangibleModelo: false,
      ));
    }
  }

  Future<void> crearFrmProductos(List<ModeloTangible> modelos) async {
    add(OnCargarFrmProductoEvent(
      cargandoFrmProducto: true,
      frmProducto: formulario,
    ));

    Map<String, AbstractControl<dynamic>> elementos = {};
    Map<String, AbstractControl<dynamic>> elemento = {};

    for (var modelo in modelos) {
      final validaciones = [
        Validators.min(0),
        Validators.max(modelo.disponible)
      ];

      elemento = <String, AbstractControl<dynamic>>{
        modelo.tangible.toString() + modelo.modelo.toString(): FormControl<int>(
          value: modelo.asignado,
          validators: validaciones,
          //disabled: true,
        )
      };
      elementos.addEntries(elemento.entries);
    }

    add(OnCargarFrmProductoEvent(
      cargandoFrmProducto: false,
      frmProducto: FormGroup(elementos),
    ));
  }
}
