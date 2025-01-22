import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mihome_app/models/models.dart';

import '../../global/environment.dart';
import '../../models/agenda_response.dart';
import '../../services/services.dart';

part 'agenda_event.dart';
part 'agenda_state.dart';

class AgendaBloc extends Bloc<AgendaEvent, AgendaState> {
  final DBService _dbService = DBService();
  final AuthService _authService = AuthService();

  AgendaBloc() : super(const AgendaState()) {
    on<OnCargarOtsAgendaEvent>((event, emit) {
      emit(
        state.copyWith(
          otsActualizadas: event.otsActualizadas,
          ots: event.ots,
        ),
      );
    });
  }

  Future<void> init() async {
    add(
      const OnCargarOtsAgendaEvent(
        otsActualizadas: false,
        ots: [],
      ),
    );
    final otsAgenda = await getAgendaOts();

    add(OnCargarOtsAgendaEvent(
      otsActualizadas: true,
      ots: otsAgenda,
    ));
  }

  Future<List<Agenda>> getAgendaOts() async {
    try {
      final ots = await _dbService.leerAgendaOts();
      return ots;
    } catch (e) {
      return <Agenda>[];
    }
  }

  Future<void> actualizarAgendaDiaria({
    required DateTime fecha,
  }) async {
    add(
      const OnCargarOtsAgendaEvent(
        otsActualizadas: false,
        ots: [],
      ),
    );

    UsuarioService _usuarioService = UsuarioService();

    try {
      final token = await _authService.getToken();
      final usuario = await _usuarioService.getInfoUsuario();

      final resp = await http.get(
          Uri.parse(
            '${Environment.apiURL}/apphome/agenda_tecnico/' +
                usuario.idDms.toString() +
                '?fecha=' +
                DateFormat('yyyy-MM-dd').format(fecha),
          ),
          headers: {
            'Content-Type': 'application/json',
            'token': token,
          }).timeout(const Duration(minutes: 5));

      if (resp.statusCode == 200 && resp.body.contains("data")) {
        final agendaResponse = agendaResponseFromJson(
          utf8.decode(resp.bodyBytes),
        );

        //guardar en base de datos local
        await _dbService.crearAgendaDiaria(
          agendaResponse.data,
          fecha,
        );

        await _dbService.actualizarAgendaGeo(DateTime.now());

        final ots = await _dbService.leerAgendaOts();

        add(
          OnCargarOtsAgendaEvent(
            otsActualizadas: true,
            ots: ots,
          ),
        );
      } else {
        add(
          OnCargarOtsAgendaEvent(
            otsActualizadas: true,
            ots: state.ots,
          ),
        );
      }
    } catch (e) {
      add(
        OnCargarOtsAgendaEvent(
          otsActualizadas: true,
          ots: state.ots,
        ),
      );
    }
  }
}
