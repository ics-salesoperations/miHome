import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:mihome_app/global/environment.dart';
import 'package:mihome_app/models/models.dart';
import 'package:mihome_app/services/services.dart';

part 'sophia_event.dart';
part 'sophia_state.dart';

class SophiaBloc extends Bloc<SophiaEvent, SophiaState> {
  final DBService _dbService = DBService();
  final AuthService _authService = AuthService();

  SophiaBloc() : super(const SophiaState()) {
    on<OnCargarOts>((event, emit) {
      emit(
        state.copyWith(
          actualizandoOt: event.actualizandoOt,
          listaOts: event.listaOts,
        ),
      );
    });

    on<OnExpandirOt>((event, emit) {
      emit(
        state.copyWith(
          expandirOt: event.expandirOt,
          otConsultada: event.otConsultada,
        ),
      );
    });

    on<OnConsultandoOt>((event, emit) {
      emit(
        state.copyWith(
          actualizandoOt: event.actualizandoOt,
          otConsultada: event.otConsultada,
        ),
      );
    });
    on<OnFiltrarCerradas>((event, emit) {
      emit(
        state.copyWith(
          filtrarCerradas: event.filtrarCerradas,
          listaFiltradas: event.listaFiltradas,
        ),
      );
    });
    on<OnFiltrarSubscripciones>((event, emit) {
      emit(
        state.copyWith(
          filtrarSubs: event.filtrarSubs,
          listaFiltradas: event.listaFiltradas,
        ),
      );
    });
    on<OnFiltrarPendientes>((event, emit) {
      emit(
        state.copyWith(
          filtrarPendientes: event.filtrarPendientes,
          listaFiltradas: event.listaFiltradas,
        ),
      );
    });
  }

  Future<void> consultarOt(ConsultaOt ot) async {
    add(
      OnConsultandoOt(
        actualizandoOt: true,
        otConsultada: [
          ot,
        ],
      ),
    );

    UsuarioService _usuarioService = UsuarioService();

    try {
      final token = await _authService.getToken();
      final usuario = await _usuarioService.getInfoUsuario();

      final resp = await http.get(
          Uri.parse(
            '${Environment.apiURL}/apphome/sophia/consultaot?ot=' +
                ot.ot.toString() +
                '&usuario=' +
                usuario.usuario.toString() +
                '&isSucriptor=${ot.estaSubscrito}',
          ),
          headers: {
            'Content-Type': 'application/json',
            'token': token,
          }).timeout(const Duration(minutes: 5));

      if (resp.statusCode == 200 && resp.body.contains("data")) {
        final consultaOtResponse =
            consultaOtResponseFromJson(utf8.decode(resp.bodyBytes));

        final nueva = consultaOtResponse.data!.copyWith(
          estaSubscrito: ot.estaSubscrito,
          dataUpdate: DateTime.now(),
        );

        //guardar en base de datos local
        await _dbService.crearConsultaOt(
          [nueva], //planningResponse.detallePdvs,
        );

        add(OnConsultandoOt(
          actualizandoOt: false,
          otConsultada: [nueva],
        ));
      } else {
        add(OnConsultandoOt(
          actualizandoOt: false,
          otConsultada: [
            ot,
          ],
        ));
      }
    } catch (e) {
      add(OnConsultandoOt(
        actualizandoOt: false,
        otConsultada: [
          ot,
        ],
      ));
    }
  }

  Future<void> subscribirOt(ConsultaOt ot) async {
    add(
      OnConsultandoOt(
        actualizandoOt: true,
        otConsultada: [
          ConsultaOt(
            ot: int.tryParse(ot.ot.toString()) ?? 0,
          ),
        ],
      ),
    );

    UsuarioService _usuarioService = UsuarioService();

    try {
      final token = await _authService.getToken();
      final usuario = await _usuarioService.getInfoUsuario();

      final resp = await http.get(
          Uri.parse(
            '${Environment.apiURL}/apphome/sophia/consultaot?ot=' +
                ot.ot.toString() +
                '&usuario=' +
                usuario.usuario.toString() +
                '&isSucriptor=${ot.estaSubscrito == 0 ? 1 : 0}',
          ),
          headers: {
            'Content-Type': 'application/json',
            'token': token,
          }).timeout(const Duration(minutes: 5));

      if (resp.statusCode == 200 && resp.body.contains("data")) {
        final consultaOtResponse =
            consultaOtResponseFromJson(utf8.decode(resp.bodyBytes));

        final nueva = consultaOtResponse.data!.copyWith(
          estaSubscrito: ot.estaSubscrito == 0 ? 1 : 0,
        );
        //guardar en base de datos local
        await _dbService.crearConsultaOt([nueva] //planningResponse.detallePdvs,
            );

        add(OnConsultandoOt(
          actualizandoOt: false,
          otConsultada: [nueva],
        ));
      } else {
        add(OnConsultandoOt(
          actualizandoOt: false,
          otConsultada: [
            ot,
          ],
        ));
      }
    } catch (e) {
      add(OnConsultandoOt(
        actualizandoOt: false,
        otConsultada: [
          ot,
        ],
      ));
    }
  }

  Future<void> cargarOts() async {
    add(
      const OnCargarOts(
        actualizandoOt: true,
        listaOts: [],
      ),
    );

    try {
      final consultas = await _dbService.leerConsultasOt();

      add(
        OnCargarOts(
          actualizandoOt: false,
          listaOts: consultas,
        ),
      );
    } catch (e) {
      add(
        OnCargarOts(
          actualizandoOt: false,
          listaOts: state.listaOts,
        ),
      );
    }
  }

  Future<void> eliminarOts() async {
    add(
      const OnCargarOts(
        actualizandoOt: true,
        listaOts: [],
      ),
    );

    try {
      await _dbService.eliminarOts();
      final consultas = await _dbService.leerConsultasOt();

      add(
        OnCargarOts(
          actualizandoOt: false,
          listaOts: consultas,
        ),
      );
    } catch (e) {
      add(
        OnCargarOts(
          actualizandoOt: false,
          listaOts: state.listaOts,
        ),
      );
    }
  }

  Future<void> filtrarCerradas() async {
    try {
      final nuevas = await _dbService.filtrarConsultasOt(
        cerradas: !state.filtrarCerradas,
        pendientes: state.filtrarPendientes,
        subs: state.filtrarSubs,
      );

      add(OnFiltrarCerradas(
        filtrarCerradas: !state.filtrarCerradas,
        listaFiltradas: nuevas,
      ));
    } catch (e) {
      null;
    }
  }

  Future<void> filtrarPendientes() async {
    try {
      final nuevas = await _dbService.filtrarConsultasOt(
        cerradas: state.filtrarCerradas,
        pendientes: !state.filtrarPendientes,
        subs: state.filtrarSubs,
      );

      add(OnFiltrarPendientes(
        filtrarPendientes: !state.filtrarPendientes,
        listaFiltradas: nuevas,
      ));
    } catch (e) {
      null;
    }
  }

  Future<void> filtrarSubs() async {
    try {
      final nuevas = await _dbService.filtrarConsultasOt(
        cerradas: state.filtrarCerradas,
        pendientes: state.filtrarPendientes,
        subs: !state.filtrarSubs,
      );

      add(OnFiltrarSubscripciones(
        filtrarSubs: !state.filtrarSubs,
        listaFiltradas: nuevas,
      ));
    } catch (e) {
      null;
    }
  }
}
