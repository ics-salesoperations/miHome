import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/models/models.dart';
import 'package:mihome_app/models/resumen_answer.dart';
import 'package:mihome_app/services/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'sync_event.dart';
part 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final DBService _dbService = DBService();
  final FormularioBloc _formularioBloc = FormularioBloc();
  final OTStepBloc _stepBloc = OTStepBloc();

  FormGroup? formGroup;

  SyncBloc() : super(const SyncState()) {
    on<OnCargarResumenEvent>((event, emit) {
      emit(
        state.copyWith(
          resSincronizar: event.resSincronizar,
          actualizandoResumen: event.actualizandoResumen,
          mensaje: "",
        ),
      );
    });
    on<OnCargarDetalleEvent>((event, emit) {
      emit(
        state.copyWith(
          respDetalleList: event.respDetalleList,
          actualizandoDetalle: event.actualizandoDetalle,
          detalleVisita: const [],
        ),
      );
    });
    on<OnBorrarSincronizadosEvent>((event, emit) {
      emit(
        state.copyWith(
          borrando: event.borrando,
          mensaje: event.mensaje,
        ),
      );
    });
    on<OnSincronizandoEvent>((event, emit) {
      emit(
        state.copyWith(
          sincronizando: event.sincronizando,
          mensaje: event.mensaje,
        ),
      );
    });
    on<OnCargarDetalleVisitaEvent>((event, emit) {
      emit(
        state.copyWith(
          detalleVisita: event.detalleVisita,
          respDetalleList: const [],
        ),
      );
    });
    //init();
  }

  Future<void> init() async {
    await getRespResumen(DateTime.now(), DateTime.now());
  }

  Future<void> getRespResumen(DateTime start, DateTime end) async {
    add(
      const OnCargarResumenEvent(
        resSincronizar: [],
        actualizandoResumen: true,
        mensaje: "Actualizando datos.",
      ),
    );

    try {
      final respuestasResumen =
          await _dbService.getSincronizarResumen(start, end);

      //Agregamos el evento para el BLOC
      add(
        OnCargarResumenEvent(
          resSincronizar: respuestasResumen,
          actualizandoResumen: false,
          mensaje: "Datos de formularios actualizados exitosamente.",
        ),
      );
    } catch (e) {
      add(
        const OnCargarResumenEvent(
          resSincronizar: [],
          actualizandoResumen: false,
          mensaje: "Ocurrió un error al cargar datos de formularios.",
        ),
      );
      return;
    }
  }

  Future<void> getRespDetalle({required String instanceId}) async {
    //Agregamos el evento para el BLOC
    add(
      const OnCargarDetalleEvent(
          respDetalleList: [], actualizandoDetalle: true, mensaje: ""),
    );

    try {
      final respuestasDetalle =
          await _dbService.leerRespuestasDetalle(instanceId: instanceId);

      //Agregamos el evento para el BLOC
      add(
        OnCargarDetalleEvent(
            respDetalleList: respuestasDetalle,
            actualizandoDetalle: false,
            mensaje: ""),
      );
    } catch (e) {
      add(
        const OnCargarDetalleEvent(
          respDetalleList: [],
          actualizandoDetalle: false,
          mensaje: "",
        ),
      );
      return;
    }
  }

  Future<void> eliminarDatosLocalesSincronizados() async {
    //Agregamos el evento para el BLOC
    add(
      const OnBorrarSincronizadosEvent(
        borrando: true,
        mensaje: "Eliminando datos borrados.",
      ),
    );

    try {
      await _dbService.deleteRespuestasSincronizadas();
      await _dbService.deleteGeoSincronizadas();

      //Agregamos el evento para el BLOC
      add(
        const OnBorrarSincronizadosEvent(
          borrando: false,
          mensaje: "Datos borrados exitosamente.",
        ),
      );
    } catch (e) {
      add(
        const OnBorrarSincronizadosEvent(
          borrando: false,
          mensaje: "Ocurrió un error al borrar los datos.",
        ),
      );
      return;
    }
  }

  Future<void> sincronizarDatos() async {
    //Agregamos el evento para el BLOC
    add(
      const OnSincronizandoEvent(
        sincronizando: true,
        mensaje: "Enviando datos no sincronizados.",
      ),
    );

    try {
      final listaRespFormularios = await _dbService.leerListadoRespuestas();
      final listaRespLocalizar = await _dbService.leerListadoLocalizar();
      //final listaRespActivar = await _dbService.leerListadoActivar();
      final listaRespCertificar = await _dbService.leerListadoCertificar();
      final listaRespLiquidar = await _dbService.leerListadoLiquidar();
      final listaRespConsulta = await _dbService.leerListadoConsulta();

      await _formularioBloc.enviarDatos(listaRespFormularios);

      for (var resp in listaRespLocalizar) {
        await _stepBloc.enviarLocalizar(resp);
      }
      for (var resp in listaRespCertificar) {
        await _stepBloc.enviarCertificar(resp);
      }
      for (var resp in listaRespLiquidar) {
        await _stepBloc.enviarLiquidar(resp);
      }
      for (var resp in listaRespConsulta) {
        await _stepBloc.enviarConsulta(resp);
      }

      //Agregamos el evento para el BLOC
      add(
        const OnSincronizandoEvent(
          sincronizando: false,
          mensaje: "Datos enviados exitosamente.",
        ),
      );
    } catch (e) {
      add(
        const OnSincronizandoEvent(
          sincronizando: false,
          mensaje: "Ocurrió un error al enviar los datos.",
        ),
      );
      return;
    }
  }
}
