import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:mihome_app/global/environment.dart';
import 'package:mihome_app/models/agenda_response.dart';
import 'package:mihome_app/models/form_response.dart';
import 'package:mihome_app/models/georreferencia_response.dart';
import 'package:mihome_app/models/models.dart';
import 'package:mihome_app/services/services.dart';

part 'actualizar_event.dart';
part 'actualizar_state.dart';

class ActualizarBloc extends Bloc<ActualizarEvent, ActualizarState> {
  final DBService _dbService = DBService();
  final AuthService _authService = AuthService();

  ActualizarBloc() : super(const ActualizarState()) {
    on<OnActualizarFormulariosEvent>((event, emit) {
      emit(
        state.copyWith(
          mensaje: event.mensaje,
          actualizandoForms: event.actualizandoForms,
          tablas: event.tablas,
        ),
      );
    });
    on<OnGetTablasEvent>((event, emit) {
      emit(
        state.copyWith(
          tablas: event.tablas,
          mensaje: '',
        ),
      );
    });
    on<OnActualizarAgendaEvent>((event, emit) {
      emit(
        state.copyWith(
          mensaje: event.mensaje,
          actualizandoAgenda: event.actualizandoAgenda,
          tablas: event.tablas,
        ),
      );
    });
    on<OnConsultarEquipoEvent>((event, emit) {
      emit(
        state.copyWith(
          mensaje: event.mensaje,
          consultandoEquipo: event.consultandoEquipo,
          equipos: event.equipos,
        ),
      );
    });
    on<OnActualizarOtsEvent>((event, emit) {
      emit(
        state.copyWith(
          mensaje: event.mensaje,
          actualizandoOts: event.actualizandoOts,
          tablas: event.tablas,
        ),
      );
    });
    on<OnActualizarModelosEvent>((event, emit) {
      emit(
        state.copyWith(
          mensaje: event.mensaje,
          actualizandoModelos: event.actualizandoModelos,
          tablas: event.tablas,
        ),
      );
    });
    on<OnActualizarTangiblesEvent>((event, emit) {
      emit(
        state.copyWith(
          mensaje: event.mensaje,
          actualizandoTangible: event.actualizandoTangible,
          tablas: event.tablas,
        ),
      );
    });
    on<OnActualizarGeoEvent>((event, emit) {
      emit(
        state.copyWith(
          mensaje: event.mensaje,
          actualizandoGeo: event.actualizandoGeo,
          tablas: event.tablas,
        ),
      );
    });
    _init();
  }

  Future<void> actualizarTodo({required List<Tabla> currentTablas}) async {
    await actualizarFormularios(currentTablas: currentTablas);
    await actualizarAgenda(currentTablas: currentTablas);
  }

  Future<void> _init() async {
    final tablas = await getTablas();
    add(OnGetTablasEvent(
      tablas: tablas,
    ));
  }

  Future<List<Tabla>> getTablas() async {
    final tablas = await _dbService.leerListadoTablas();

    return tablas;
  }

  Future<void> actualizarAgenda({required List<Tabla> currentTablas}) async {
    add(
      OnActualizarAgendaEvent(
        actualizandoAgenda: true,
        mensaje: "Espere un momento, estamos actualizando tu agenda.",
        tablas: currentTablas,
      ),
    );

    UsuarioService _usuarioService = UsuarioService();

    try {
      final token = await _authService.getToken();
      final usuario = await _usuarioService.getInfoUsuario();

      final resp = await http.get(
          Uri.parse(
            '${Environment.apiURL}/apphome/agenda_tecnico/' +
                usuario.idDms.toString(),
          ),
          headers: {
            'Content-Type': 'application/json',
            'token': token,
          }).timeout(const Duration(minutes: 10));

      if (resp.statusCode == 200 && resp.body.contains("data")) {
        final agendaResponse = agendaResponseFromJson(
          utf8.decode(resp.bodyBytes),
        );

        //guardar en base de datos local
        await _dbService
            .crearAgenda(agendaResponse.data //planningResponse.detallePdvs,
                );

        await _dbService.actualizarAgendaGeo(DateTime.now());

        await _dbService.updateTabla(
          tbl: 'agenda',
        );
        final tablas = await _dbService.leerListadoTablas();
        add(OnActualizarAgendaEvent(
          actualizandoAgenda: false,
          mensaje: "Agenda actualizada exitosamente",
          tablas: tablas,
        ));
      } else if (resp.statusCode == 404) {
        add(
          OnActualizarAgendaEvent(
            actualizandoAgenda: false,
            mensaje: "No tienes agenda cargada.",
            tablas: currentTablas,
          ),
        );
      } else {
        add(
          OnActualizarAgendaEvent(
            actualizandoAgenda: false,
            mensaje: "Ocurrió un error al actualizar tu agenda.",
            tablas: currentTablas,
          ),
        );
      }
    } catch (e) {
      add(OnActualizarAgendaEvent(
        actualizandoAgenda: false,
        mensaje: "Ocurrió un error al actualizar tu agenda.",
        tablas: currentTablas,
      ));
    }
  }

  Future<void> actualizarGeo({
    required List<Tabla> currentTablas,
    required String departamento,
  }) async {
    add(
      OnActualizarGeoEvent(
        actualizandoGeo: true,
        mensaje:
            "Espere un momento, estamos actualizando los datos de Geolocalización.",
        tablas: currentTablas,
      ),
    );

    try {
      final token = await _authService.getToken();

      final resp = await http.get(
          Uri.parse(
            '${Environment.apiURL}/apphome/georeferencia/' + departamento,
          ),
          headers: {
            'Content-Type': 'application/json',
            'token': token,
          }).timeout(
        const Duration(
          minutes: 20,
        ),
      );

      if (resp.statusCode == 200) {
        final georreferenciaReferenciaResponse =
            georreferenciaResponseFromJson(utf8.decode(resp.bodyBytes));

        //guardar en base de datos local
        await _dbService.crearGeoDB(
          georreferenciaReferenciaResponse.data ?? [],
        );

        await _dbService.updateTabla(tbl: 'georreferencia');

        final tablas = await _dbService.leerListadoTablas();

        add(OnActualizarGeoEvent(
          actualizandoGeo: false,
          mensaje: "Datos de Gelocalización actualizados exitosamente.",
          tablas: tablas,
        ));
      } else {
        add(OnActualizarGeoEvent(
          actualizandoGeo: false,
          mensaje:
              "Ocurrió un error al actualizar los datos de Geolocalización.",
          tablas: currentTablas,
        ));
      }
    } catch (e) {
      add(OnActualizarGeoEvent(
        actualizandoGeo: false,
        mensaje: "Ocurrió un error al actualizar los datos de Geolocalización.",
        tablas: currentTablas,
      ));
    }
  }

  Future<void> consultarEquipo({
    required String serie,
  }) async {
    add(
      OnConsultarEquipoEvent(
        consultandoEquipo: true,
        equipos: const [],
        mensaje: "Consultando equipo: " + serie,
      ),
    );

    try {
      final token = await _authService.getToken();

      print(token);

      final resp = await http.get(
          Uri.parse(
            '${Environment.apiURL}/apphome/symphonicadevicestatus/' + serie,
          ),
          headers: {
            'Content-Type': 'application/json',
            'token': token,
          }).timeout(
        const Duration(
          minutes: 5,
        ),
      );

      if (resp.statusCode == 200) {
        final symphonicaResponse =
            symphonicaResponseFromJson(utf8.decode(resp.bodyBytes));

        add(OnConsultarEquipoEvent(
          consultandoEquipo: false,
          equipos: [symphonicaResponse],
          mensaje: "Consulta realizada exitosamente.",
        ));
      } else {
        print("Erorr por status code");
        add(const OnConsultarEquipoEvent(
          consultandoEquipo: false,
          equipos: [],
          mensaje: "Error al consultar el Equipo.",
        ));
      }
    } catch (e) {
      print(e.toString());
      add(const OnConsultarEquipoEvent(
        consultandoEquipo: false,
        equipos: [],
        mensaje: "Error al consultar el Equipo.",
      ));
    }
  }

  Future<void> actualizarFormularios({
    required List<Tabla> currentTablas,
  }) async {
    add(OnActualizarFormulariosEvent(
      actualizandoForms: true,
      mensaje: "Espere un momento, estamos actualizando los formularios.",
      tablas: currentTablas,
    ));

    try {
      final token = await _authService.getToken();
      final resp = await http.get(
          Uri.parse('${Environment.apiURL}/appdms/estructura_form/500'),
          headers: {
            'Content-Type': 'application/json',
            'token': token,
          }).timeout(
        const Duration(
          seconds: 30,
        ),
      );

      final formsResponse = formResponseFromMap(utf8.decode(resp.bodyBytes));

      //guardar en base de datos local
      await _dbService.crearFormularios(formsResponse.detalleFormulario);
      await _dbService.updateTabla(tbl: 'formulario');
      final tablas = await _dbService.leerListadoTablas();
      add(OnActualizarFormulariosEvent(
        actualizandoForms: false,
        mensaje: "Formularios actualizados exitosamente",
        tablas: tablas,
      ));
    } catch (e) {
      add(OnActualizarFormulariosEvent(
        actualizandoForms: false,
        mensaje: "Ocurrió un error al actualizar los formularios",
        tablas: currentTablas,
      ));
    }
  }

  Future<void> actualizarOts({
    required List<Tabla> currentTablas,
  }) async {
    add(
      OnActualizarOtsEvent(
        actualizandoOts: true,
        mensaje: "Espere un momento, estamos actualizando las OTs.",
        tablas: currentTablas,
      ),
    );
    UsuarioService _usuarioService = UsuarioService();

    try {
      final token = await _authService.getToken();
      final usuario = await _usuarioService.getInfoUsuario();

      final resp = await http.get(
          Uri.parse(
            '${Environment.apiURL}/apphome/gestion/ots_cerradas/' +
                usuario.idDms.toString(),
          ),
          headers: {
            'Content-Type': 'application/json',
            'token': token,
          }).timeout(
        const Duration(
          minutes: 5,
        ),
      );

      if (resp.statusCode == 200 && resp.body.contains("data")) {
        final otResponse = otResponseFromJson(
          utf8.decode(resp.bodyBytes),
        );

        //guardar en base de datos local
        await _dbService
            .crearOts(otResponse.data //planningResponse.detallePdvs,
                );

        await _dbService.updateTabla(
          tbl: 'ot',
        );

        final tablas = await _dbService.leerListadoTablas();
        add(OnActualizarOtsEvent(
          actualizandoOts: false,
          mensaje: "OTs actualizadas exitosamente",
          tablas: tablas,
        ));
      } else {
        add(
          OnActualizarOtsEvent(
            actualizandoOts: false,
            mensaje: "Ocurrió un error al actualizar las OTs.",
            tablas: currentTablas,
          ),
        );
      }
    } catch (e) {
      add(OnActualizarOtsEvent(
        actualizandoOts: false,
        mensaje: "Ocurrió un error al actualizar las OTs.",
        tablas: currentTablas,
      ));
    }
  }
}
