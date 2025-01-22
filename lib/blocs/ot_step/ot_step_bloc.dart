import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:mihome_app/models/models.dart';
import 'package:mihome_app/services/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../global/environment.dart';

part 'ot_step_event.dart';
part 'ot_step_state.dart';

class OTStepBloc extends Bloc<OTStepEvent, OTStepState> {
  final DBService _dbService = DBService();
  final AuthService _authService = AuthService();
  final UsuarioService _userService = UsuarioService();

  OTStepBloc() : super(const OTStepState()) {
    on<OnCargarStepsEvent>((event, emit) {
      emit(
        state.copyWith(
          actualizandoSteps: event.actualizandoSteps,
          currentStep: 0, //event.steps.length - 1,
          steps: event.steps,
        ),
      );
    });

    on<OnChangeCurrentEvent>((event, emit) {
      emit(
        state.copyWith(
          currentStep: event.currentStep,
        ),
      );
    });
    on<OnUpdateProcesando>((event, emit) {
      emit(
        state.copyWith(
          procesando: event.procesando,
        ),
      );
    });

    on<OnCambiarOT>((event, emit) {
      emit(
        state.copyWith(
          ot: event.ot,
        ),
      );
    });
    on<OnCambiarColillaActualizada>((event, emit) {
      emit(
        state.copyWith(
          colillaActualizada: event.colillaActualizada,
        ),
      );
    });

    on<OnCambiarColillaValida>((event, emit) {
      emit(
        state.copyWith(
          colillaValida: event.colillaValida,
        ),
      );
    });
    on<OnChangeGuardado>((event, emit) {
      emit(
        state.copyWith(
          guardado: event.guardado,
          mensaje: event.mensaje,
        ),
      );
    });
    on<OnChangeEnviado>((event, emit) {
      emit(
        state.copyWith(
          enviado: event.enviado,
          mensaje: event.mensaje,
        ),
      );
    });
    on<OnCargarEquiposEvent>((event, emit) {
      emit(
        state.copyWith(
          equipos: event.equipos,
        ),
      );
    });
  }

  Future<void> init({
    required String ot,
  }) async {
    add(
      const OnCargarStepsEvent(
        steps: [],
        actualizandoSteps: true,
        currentStep: 0,
        mensaje: "",
      ),
    );
    //await actualizarSteps();
    //await getSteps();
  }

  Future<void> actualizarOTSteps({
    required String ot,
  }) async {
    add(
      const OnCargarStepsEvent(
          steps: [],
          actualizandoSteps: true,
          currentStep: 0,
          mensaje: "Estamos actualizando la información de la OT."),
    );

    try {
      final token = await _authService.getToken();
      final resp = await http.get(
          Uri.parse(
            '${Environment.apiURL}/apphome/gestion/tep/' + ot,

            //usuario.idDms.toString(),
          ),
          headers: {
            'Content-Type': 'application/json',
            'token': token,
          }).timeout(
        const Duration(minutes: 2),
      );
      if (resp.statusCode == 200) {
        final agendaResponse = otStepsResponseFromJson(
          utf8.decode(resp.bodyBytes),
        );

        //guardar en base de datos local
        await _dbService.crearOTSteps(
          agendaResponse.data, //planningResponse.detallePdvs,
        );

        final steps = await _dbService.leerOTSteps(
          ot: ot,
        );

        add(
          OnCargarStepsEvent(
            steps: steps,
            actualizandoSteps: false,
            currentStep: 0,
            mensaje: "OT Actualizada exitosamente.",
          ),
        );
      } else {
        final steps = await _dbService.leerOTSteps(
          ot: ot,
        );
        add(
          OnCargarStepsEvent(
            steps: steps,
            actualizandoSteps: false,
            currentStep: 0,
            mensaje: "Ocurrio un error al actualizar OTs.",
          ),
        );
      }
    } on TimeoutException catch (_) {
      final steps = await _dbService.leerOTSteps(
        ot: ot,
      );
      add(
        OnCargarStepsEvent(
            steps: steps,
            actualizandoSteps: false,
            currentStep: 0,
            mensaje: "Ocurrio un error al actualizar OTs."),
      );
      // handle timeout
    } catch (e) {
      final steps = await _dbService.leerOTSteps(
        ot: ot,
      );
      add(
        OnCargarStepsEvent(
            steps: steps,
            actualizandoSteps: false,
            currentStep: 0,
            mensaje: "Error al conectarse con el servidor."),
      );
    }
  }

  Future<void> localizarOT({
    required Agenda ot,
  }) async {
    add(
      const OnChangeGuardado(
        guardado: false,
        mensaje: "Estamos guardando información localmente.",
      ),
    );
    add(
      const OnUpdateProcesando(
        procesando: true,
      ),
    );

    final usuario = await _userService.getInfoUsuario();

    final Localizar model = Localizar(
      ot: ot.ot,
      tecnico: usuario.usuario,
      nombreTecnico: ot.nombreTecnico,
      fecha: DateTime.now(),
      enviado: 0,
      nodo: ot.nodo,
      region: ot.region,
      distrito: ot.distrito,
      telefono: usuario.telefono,
    );

    final guardado = await guardarLocalizar(model);

    if (guardado) {
      add(
        const OnChangeGuardado(
          guardado: true,
          mensaje: "Guardado exitosamente",
        ),
      );

      final nuevoStep = OTSteps(
        ot: model.ot,
        fecha: model.fecha,
        step: 'LOCALIZAR',
        gestion: 'Localizacion de Cliente via OT',
        estado: 'PENDIENTE',
        subEstado: 'PENDIENTE',
        comentario: '',
        estadoNuevo: 'PENDIENTE',
      );

      add(
        OnCargarStepsEvent(
          steps: [
            ...state.steps,
            nuevoStep,
          ],
          actualizandoSteps: false,
          currentStep: 0,
          mensaje: "OT Actualizada exitosamente.",
        ),
      );

      add(
        const OnChangeEnviado(
          enviado: false,
          mensaje: "Enviando datos.",
        ),
      );
      final enviado = await enviarLocalizar(model);
      if (enviado) {
        add(
          const OnChangeEnviado(
            enviado: true,
            mensaje: "Datos enviados exitosamente",
          ),
        );
      } else {
        add(
          const OnChangeEnviado(
            enviado: false,
            mensaje: "Envio fallido",
          ),
        );
      }
    } else {
      add(
        const OnChangeGuardado(
          guardado: false,
          mensaje:
              "Ocurrió un error al guardar localmente. Favor intentar nuevamente",
        ),
      );
    }

    add(
      const OnUpdateProcesando(
        procesando: false,
      ),
    );
  }

  Future<void> retryLocalizarOT({
    required String ot,
  }) async {
    final enviado = await retryEnviarLocalizar(ot);
    if (enviado) {
      add(
        const OnChangeEnviado(
          enviado: true,
          mensaje: "Datos enviados exitosamente",
        ),
      );
    } else {
      add(
        const OnChangeEnviado(
          enviado: false,
          mensaje: "Envio fallido",
        ),
      );
    }
  }

  Future<bool> guardarLocalizar(Localizar model) async {
    bool respuesta = false;
    try {
      respuesta = await _dbService.guardarLocalizar(model);
    } catch (e) {
      respuesta = false;
    }
    return respuesta;
  }

  Future<bool> enviarLocalizar(Localizar model) async {
    bool respuesta = false;

    final json = {
      'telefono': model.telefono,
      'ot': model.ot,
      'nodo': model.nodo,
      'region': model.region,
      'distrito': model.distrito,
      'tecnico': model.tecnico,
      'nombreTecnico': model.nombreTecnico,
    };

    try {
      final token = await _authService.getToken();
      final resp = await http.post(
          Uri.parse(
            '${Environment.apiURL}/apphome/gestion/tep/localizar',
          ),
          body: jsonEncode(json),
          headers: {
            'Content-Type': 'application/json',
            'token': token,
          }).timeout(
        const Duration(
          minutes: 2,
        ),
      );

      if (resp.statusCode == 200) {
        //guardar en base de datos local
        await _dbService.updateStep(
          ot: model.ot.toString(),
          tabla: 'localizar',
        );

        respuesta = true;
      } else {
        respuesta = false;
      }
    } catch (e) {
      respuesta = false;
    }

    return respuesta;
  }

  Future<bool> retryEnviarLocalizar(String ot) async {
    bool respuesta = false;

    List<Localizar> models = await _dbService.getStepLocalizar(ot: ot);

    if (models.isNotEmpty) {
      final model = models.first;
      final json = {
        'telefono': model.telefono,
        'ot': model.ot,
        'nodo': model.nodo,
        'region': model.region,
        'distrito': model.distrito,
        'tecnico': model.tecnico,
        'nombreTecnico': model.nombreTecnico,
      };

      try {
        final token = await _authService.getToken();
        final resp = await http.post(
            Uri.parse(
              '${Environment.apiURL}/apphome/gestion/tep/localizar',
            ),
            body: jsonEncode(json),
            headers: {
              'Content-Type': 'application/json',
              'token': token,
            }).timeout(
          const Duration(
            minutes: 2,
          ),
        );

        if (resp.statusCode == 200) {
          //guardar en base de datos local
          await _dbService.updateStep(
            ot: model.ot.toString(),
            tabla: 'localizar',
          );

          respuesta = true;
        } else {
          respuesta = false;
        }
      } catch (e) {
        respuesta = false;
      }
    } else {
      respuesta = true;
    }

    return respuesta;
  }

  Future<void> activarOT({
    required Agenda ot,
    required FormGroup formulario,
    required List<EquipoInstalado> equipos,
  }) async {
    add(
      const OnChangeGuardado(
        guardado: false,
        mensaje: "Estamos guardando información localmente.",
      ),
    );
    add(
      const OnUpdateProcesando(
        procesando: true,
      ),
    );

    final Activar model = Activar(
      ot: ot.ot,
      fecha: DateTime.now(),
      enviado: 0,
      nodo: ot.nodoNuevo,
      tap: ot.tapNuevo,
      colilla: ot.colillaNueva,
      bandSteering: formulario.control('bandSteering').value ?? '',
      cableModem: formulario.control('cableModem').value ?? '',
      cajaAndroidTV: formulario.control('cajaAndroidTV').value ?? '',
      cajaDVB: formulario.control('cajaDVB').value ?? '',
      claveRed: formulario.control('claveRed').value ?? '',
      correo: formulario.control('correo').value ?? '',
      extensores: formulario.control('extensores').value ?? '',
      ipPublica: formulario.control('ipPublica').value ?? '',
      nombreRed: formulario.control('nombreRed').value ?? '',
      telefonia: formulario.control('telefonia').value ?? '',
      retiros: formulario.control('retiros').value ?? '',
    );

    final guardado = await guardarActivar(model);

    if (guardado) {
      add(
        const OnChangeGuardado(
          guardado: true,
          mensaje: "Guardado exitosamente",
        ),
      );

      String gestion = """
      Retiro de lo siguientes equipos:
        - SERIES: ${model.retiros}
      Activación de los siguientes equipos:
        - CABLE MODEMS: ${model.cableModem},
        - CAJAS DVB: ${model.cajaDVB},
        - CAJAS ANDROID TV: ${model.cajaAndroidTV},
        - TELEFONIA: ${model.telefonia},
                        """;

      final nuevoStep = OTSteps(
        ot: model.ot,
        fecha: model.fecha,
        step: 'ACTIVAR',
        gestion: gestion,
        estado: 'PENDIENTE',
        subEstado: 'PENDIENTE',
        comentario: '',
        estadoNuevo: 'PENDIENTE',
      );

      add(
        OnCargarStepsEvent(
          steps: [
            ...state.steps,
            nuevoStep,
          ],
          actualizandoSteps: false,
          currentStep: 0,
          mensaje: "OT Actualizada exitosamente.",
        ),
      );

      add(
        const OnChangeEnviado(
          enviado: false,
          mensaje: "Enviando datos.",
        ),
      );
      final enviado = await enviarActivar(
        model,
        equipos,
      );
      if (enviado) {
        add(
          const OnChangeEnviado(
            enviado: true,
            mensaje: "Datos enviados exitosamente",
          ),
        );
      } else {
        add(
          const OnChangeEnviado(
            enviado: false,
            mensaje: "Envio fallido",
          ),
        );
      }
    } else {
      add(
        const OnChangeGuardado(
          guardado: false,
          mensaje:
              "Ocurrió un error al guardar localmente. Favor intentar nuevamente",
        ),
      );
    }

    add(
      const OnUpdateProcesando(
        procesando: false,
      ),
    );
  }

  Future<void> retryActivarOT({
    required String ot,
    required List<EquipoInstalado> equipos,
  }) async {
    final enviado = await retryEnviarActivar(
      ot,
      equipos,
    );
    if (enviado) {
      add(
        const OnChangeEnviado(
          enviado: true,
          mensaje: "Datos enviados exitosamente",
        ),
      );
    } else {
      add(
        const OnChangeEnviado(
          enviado: false,
          mensaje: "Envio fallido",
        ),
      );
    }
  }

  Future<bool> guardarActivar(Activar model) async {
    bool respuesta = false;
    try {
      respuesta = await _dbService.guardarActivar(model);
    } catch (e) {
      respuesta = false;
    }
    return respuesta;
  }

  Future<bool> enviarActivar(
      Activar model, List<EquipoInstalado> equipos) async {
    bool respuesta = false;
    final Usuario usr = await _userService.getInfoUsuario();

    final json = {
      'telefono': '${usr.telefono}',
      'ot': model.ot,
      'equipos': [
        ...equipos.map((e) => e.toJson()),
      ],
      'nodo': '${model.nodo}',
      'tap': '${model.tap}',
      'colilla': '${model.colilla}',
      'correo': '${usr.correo}',
      'bandSteering': '${model.bandSteering}',
      'nombreRed': '${model.nombreRed}',
      'claveRed': '${model.claveRed}',
      'region': '${model.region}',
      'distrito': '${model.distrito}',
      'tecnico': '${usr.usuario}',
      'nombreTecnico': '${usr.nombre}',
    };

    try {
      final token = await _authService.getToken();
      final resp = await http.post(
          Uri.parse(
            '${Environment.apiURL}/apphome/gestion/tep/activar',
          ),
          body: jsonEncode(json),
          headers: {
            'Content-Type': 'application/json',
            'token': token,
          }).timeout(
        const Duration(
          minutes: 2,
        ),
      );

      if (resp.statusCode == 200) {
        //guardar en base de datos local
        await _dbService.updateStep(ot: model.ot.toString(), tabla: 'activar');

        respuesta = true;
      } else {
        respuesta = false;
      }
    } catch (e) {
      respuesta = false;
    }

    return respuesta;
  }

  Future<bool> retryEnviarActivar(
      String ot, List<EquipoInstalado> equipos) async {
    bool respuesta = false;

    List<Activar> models = await _dbService.getStepActivar(ot: ot);

    if (models.isNotEmpty) {
      final Usuario usr = await _userService.getInfoUsuario();

      final model = models.first;
      final json = {
        'telefono': '${usr.telefono}',
        'ot': model.ot,
        'equipos': [
          ...equipos.map((e) => e.toJson()),
        ],
        'nodo': '${model.nodo}',
        'tap': '${model.tap}',
        'colilla': '${model.colilla}',
        'correo': '${usr.correo}',
        'bandSteering': '${model.bandSteering}',
        'nombreRed': '${model.nombreRed}',
        'claveRed': '${model.claveRed}',
        'region': '${model.region}',
        'distrito': '${model.distrito}',
        'tecnico': '${usr.usuario}',
        'nombreTecnico': '${usr.nombre}',
      };

      try {
        final token = await _authService.getToken();
        final resp = await http.post(
            Uri.parse(
              '${Environment.apiURL}/apphome/gestion/tep/activar',
            ),
            body: jsonEncode(json),
            headers: {
              'Content-Type': 'application/json',
              'token': token,
            }).timeout(
          const Duration(
            minutes: 2,
          ),
        );

        if (resp.statusCode == 200) {
          //guardar en base de datos local
          await _dbService.updateStep(
              ot: model.ot.toString(), tabla: 'activar');

          respuesta = true;
        } else {
          respuesta = false;
        }
      } catch (e) {
        respuesta = false;
      }
    } else {
      respuesta = true;
    }

    return respuesta;
  }

  Future<void> consultarOT({
    required Agenda ot,
    required String consulta,
  }) async {
    add(
      const OnChangeGuardado(
        guardado: false,
        mensaje: "Estamos guardando información localmente.",
      ),
    );

    final Usuario usr = await _userService.getInfoUsuario();

    final Consulta model = Consulta(
      ot: ot.ot,
      fecha: DateTime.now(),
      enviado: 0,
      nodo: ot.nodo,
      consulta: consulta,
      distrito: ot.distrito,
      nombreTecnico: ot.nombreTecnico,
      region: ot.region,
      tecnico: usr.usuario.toString(),
      telefono: usr.telefono,
    );

    final nuevoStep = OTSteps(
      fecha: model.fecha,
      gestion: model.consulta,
      comentario: '',
      estado: 'PENDIENTE',
      estadoNuevo: 'PENDIENTE',
      step: 'CONSULTAS_DESPACHO',
      ot: ot.ot,
      subEstado: 'PENDIENTE',
    );

    final guardado = await guardarConsulta(model);

    if (guardado) {
      add(
        const OnChangeGuardado(
          guardado: true,
          mensaje: "Guardado exitosamente",
        ),
      );

      add(
        OnCargarStepsEvent(
          steps: [
            ...state.steps,
            nuevoStep,
          ],
          actualizandoSteps: false,
          currentStep: 0,
          mensaje: "OT Actualizada exitosamente.",
        ),
      );

      add(
        const OnChangeEnviado(
          enviado: false,
          mensaje: "Enviando datos.",
        ),
      );
      final enviado = await enviarConsulta(
        model,
      );
      if (enviado) {
        add(
          const OnChangeEnviado(
            enviado: true,
            mensaje: "Datos enviados exitosamente",
          ),
        );
      } else {
        add(
          const OnChangeEnviado(
            enviado: false,
            mensaje: "Envio fallido",
          ),
        );
      }
    } else {
      add(
        const OnChangeGuardado(
          guardado: false,
          mensaje:
              "Ocurrió un error al guardar localmente. Favor intentar nuevamente",
        ),
      );
    }
  }

  Future<bool> guardarConsulta(Consulta model) async {
    bool respuesta = false;
    try {
      respuesta = await _dbService.guardarConsulta(model);
    } catch (e) {
      respuesta = false;
    }
    return respuesta;
  }

  Future<bool> enviarConsulta(
    Consulta model,
  ) async {
    bool respuesta = false;

    final json = {
      'telefono': '${model.telefono}',
      'ot': model.ot,
      'consulta': '${model.consulta}',
      'nodo': '${model.nodo}',
      'region': '${model.region}',
      'distrito': '${model.distrito}',
      'tecnico': '${model.tecnico}',
      'nombreTecnico': '${model.nombreTecnico}',
    };

    try {
      final token = await _authService.getToken();
      final resp = await http.post(
          Uri.parse(
            '${Environment.apiURL}/apphome/gestion/tep/consulta',
          ),
          body: jsonEncode(json),
          headers: {
            'Content-Type': 'application/json',
            'token': token,
          }).timeout(
        const Duration(
          minutes: 2,
        ),
      );

      if (resp.statusCode == 200) {
        //guardar en base de datos local
        await _dbService.updateStep(
          ot: model.ot.toString(),
          tabla: 'consulta',
        );

        respuesta = true;
      } else {
        respuesta = false;
      }
    } catch (e) {
      respuesta = false;
    }

    return respuesta;
  }

  Future<String> colillaActualizada(String cliente) async {
    String colilla = "";
    add(
      const OnCambiarColillaActualizada(
        colillaActualizada: false,
      ),
    );
    final geo = await _dbService.getGeoLogByNombre(
      nombre: cliente,
    );
    {
      if (geo.isNotEmpty) {
        colilla = geo.first.codigo.toString();
        add(
          const OnCambiarColillaActualizada(
            colillaActualizada: true,
          ),
        );
      }
    }

    return colilla;
  }

  Future<void> actualizarInfoOt(Agenda ot) async {
    final otBase = await _dbService.leerAgendaOt(ot: ot.ot ?? 0);

    if (otBase.isNotEmpty) {
      add(
        OnCambiarOT(
          ot: [otBase.first],
        ),
      );
    }
  }

  Future<void> certificarOT({
    required Agenda ot,
    required FormGroup formulario,
  }) async {
    add(
      const OnChangeGuardado(
        guardado: false,
        mensaje: "Estamos guardando información localmente.",
      ),
    );
    add(
      const OnUpdateProcesando(
        procesando: true,
      ),
    );

    final Usuario usr = await _userService.getInfoUsuario();

    final Certificar model = Certificar(
      ot: ot.ot,
      fecha: DateTime.now(),
      enviado: 0,
      nodo: ot.nodoNuevo.toString() == 'null' || ot.nodoNuevo == ""
          ? ot.nodo.toString()
          : ot.nodoNuevo.toString(),
      tap: ot.tapNuevo.toString() == 'null' || ot.tapNuevo == ""
          ? ot.tap.toString()
          : ot.tapNuevo.toString(),
      colilla: ot.colillaNueva,
      bitacora: formulario.control('bitacora').value ?? '',
      distrito: ot.distrito,
      nombreTecnico: ot.nombreTecnico,
      region: ot.region,
      tecnico: usr.usuario.toString(),
      correo: formulario.control('correo').value ?? '',
      telefono: usr.telefono,
      bst: formulario.control('bst').value ?? '',
    );

    final nuevoStep = OTSteps(
      fecha: model.fecha,
      gestion: model.bitacora,
      comentario: '',
      estado: 'PENDIENTE',
      estadoNuevo: 'PENDIENTE',
      step: 'CERTIFICAR',
      ot: ot.ot,
      subEstado: 'PENDIENTE',
    );

    final guardado = await guardarCertificar(model);

    if (guardado) {
      add(
        const OnChangeGuardado(
          guardado: true,
          mensaje: "Guardado exitosamente",
        ),
      );

      add(
        OnCargarStepsEvent(
          steps: [...state.steps, nuevoStep],
          actualizandoSteps: false,
          currentStep: 0,
          mensaje: "OT Actualizada exitosamente.",
        ),
      );

      add(
        const OnChangeEnviado(
          enviado: false,
          mensaje: "Enviando datos.",
        ),
      );
      final enviado = await enviarCertificar(model);
      if (enviado) {
        add(
          const OnChangeEnviado(
            enviado: true,
            mensaje: "Datos enviados exitosamente",
          ),
        );
      } else {
        add(
          const OnChangeEnviado(
            enviado: false,
            mensaje: "Envio fallido",
          ),
        );
      }
    } else {
      add(
        const OnChangeEnviado(
          enviado: false,
          mensaje: "Envio fallido",
        ),
      );
    }
    add(
      const OnUpdateProcesando(
        procesando: false,
      ),
    );
  }

  Future<void> retryCertificarOT({
    required String ot,
  }) async {
    final enviado = await retryEnviarCertificar(ot);
    if (enviado) {
      add(
        const OnChangeEnviado(
          enviado: true,
          mensaje: "Datos enviados exitosamente",
        ),
      );
    } else {
      add(
        const OnChangeEnviado(
          enviado: false,
          mensaje: "Envio fallido",
        ),
      );
    }
  }

  Future<bool> guardarCertificar(Certificar model) async {
    bool respuesta = false;
    try {
      respuesta = await _dbService.guardarCertificar(model);
    } catch (e) {
      respuesta = false;
    }
    return respuesta;
  }

  Future<bool> enviarCertificar(Certificar model) async {
    bool respuesta = false;

    final json = {
      'telefono': model.telefono,
      'ot': model.ot,
      'nodo': model.nodo,
      'region': model.region,
      'distrito': model.distrito,
      'tecnico': model.tecnico,
      'nombreTecnico': model.nombreTecnico,
      'bitacora': model.bitacora,
      'tap': model.tap,
      'colilla': model.colilla,
      'correo': model.correo,
      'bandSteering': model.bst,
    };

    try {
      final token = await _authService.getToken();
      final resp = await http.post(
          Uri.parse(
            '${Environment.apiURL}/apphome/gestion/tep/certificar',
          ),
          body: jsonEncode(json),
          headers: {
            'Content-Type': 'application/json',
            'token': token,
          }).timeout(
        const Duration(
          minutes: 2,
        ),
      );

      if (resp.statusCode == 200) {
        //guardar en base de datos local
        await _dbService.updateStep(
          ot: model.ot.toString(),
          tabla: 'certificar',
        );

        respuesta = true;
      } else {
        respuesta = false;
      }
    } catch (e) {
      respuesta = false;
    }

    return respuesta;
  }

  Future<bool> retryEnviarCertificar(String ot) async {
    bool respuesta = false;

    List<Certificar> models = await _dbService.getStepCertificar(ot: ot);

    if (models.isNotEmpty) {
      final model = models.first;
      final json = {
        'telefono': model.telefono,
        'ot': model.ot,
        'nodo': model.nodo,
        'region': model.region,
        'distrito': model.distrito,
        'tecnico': model.tecnico,
        'nombreTecnico': model.nombreTecnico,
        'bitacora': model.bitacora,
        'tap': model.tap,
        'colilla': model.colilla,
        'correo': model.correo,
        'bandSteering': model.bst,
      };

      try {
        final token = await _authService.getToken();
        final resp = await http.post(
            Uri.parse(
              '${Environment.apiURL}/apphome/gestion/tep/certificar',
            ),
            body: jsonEncode(json),
            headers: {
              'Content-Type': 'application/json',
              'token': token,
            }).timeout(
          const Duration(
            minutes: 2,
          ),
        );

        if (resp.statusCode == 200) {
          //guardar en base de datos local
          await _dbService.updateStep(
            ot: model.ot.toString(),
            tabla: 'certificar',
          );

          respuesta = true;
        } else {
          respuesta = false;
        }
      } catch (e) {
        respuesta = false;
      }
    } else {
      respuesta = true;
    }

    return respuesta;
  }

  Future<void> liquidarOT({
    required Agenda ot,
    required FormGroup formulario,
  }) async {
    add(
      const OnChangeGuardado(
        guardado: false,
        mensaje: "Estamos guardando información localmente.",
      ),
    );
    add(
      const OnUpdateProcesando(
        procesando: true,
      ),
    );

    final Usuario usr = await _userService.getInfoUsuario();

    final Liquidar model = Liquidar(
      ot: ot.ot,
      fecha: DateTime.now(),
      enviado: 0,
      nodo: ot.nodoNuevo.toString() == 'null' || ot.nodoNuevo == ""
          ? ot.nodo.toString()
          : ot.nodoNuevo.toString(),
      tap: ot.tapNuevo.toString() == 'null' || ot.tapNuevo == ""
          ? ot.tap.toString()
          : ot.tapNuevo.toString(),
      colilla: ot.colillaNueva,
      bitacora: formulario.control('bitacora').value ?? '',
      distrito: ot.distrito,
      nombreTecnico: ot.nombreTecnico,
      region: ot.region,
      tecnico: usr.usuario.toString(),
      correo: formulario.control('correo').value ?? '',
      telefono: usr.telefono,
    );

    final nuevoStep = OTSteps(
      fecha: model.fecha,
      gestion: model.bitacora,
      comentario: '',
      estado: 'PENDIENTE',
      estadoNuevo: 'PENDIENTE',
      step: 'LIQUIDAR',
      ot: ot.ot,
      subEstado: 'PENDIENTE',
    );

    final guardado = await guardarLiquidar(model);

    if (guardado) {
      add(
        const OnChangeGuardado(
          guardado: true,
          mensaje: "Guardado exitosamente",
        ),
      );

      add(
        OnCargarStepsEvent(
          steps: [
            ...state.steps,
            nuevoStep,
          ],
          actualizandoSteps: false,
          currentStep: 0,
          mensaje: "OT Actualizada exitosamente.",
        ),
      );

      add(
        const OnChangeEnviado(
          enviado: false,
          mensaje: "Enviando datos.",
        ),
      );
      final enviado = await enviarLiquidar(model);
      if (enviado) {
        add(
          const OnChangeEnviado(
            enviado: true,
            mensaje: "Datos enviados exitosamente",
          ),
        );
      } else {
        add(
          const OnChangeEnviado(
            enviado: false,
            mensaje: "Envio fallido",
          ),
        );
      }
    } else {
      add(
        const OnChangeGuardado(
          guardado: false,
          mensaje:
              "Ocurrió un error al guardar localmente. Favor intentar nuevamente",
        ),
      );
    }
    add(
      const OnUpdateProcesando(
        procesando: false,
      ),
    );
  }

  Future<void> retryLiquidarOT({
    required String ot,
  }) async {
    final enviado = await retryEnviarLiquidar(ot);
    if (enviado) {
      add(
        const OnChangeEnviado(
          enviado: true,
          mensaje: "Datos enviados exitosamente",
        ),
      );
    } else {
      add(
        const OnChangeEnviado(
          enviado: false,
          mensaje: "Envio fallido",
        ),
      );
    }
  }

  Future<bool> guardarLiquidar(Liquidar model) async {
    bool respuesta = false;
    try {
      respuesta = await _dbService.guardarLiquidar(model);
    } catch (e) {
      respuesta = false;
    }
    return respuesta;
  }

  Future<bool> enviarLiquidar(Liquidar model) async {
    bool respuesta = false;

    final json = {
      'telefono': model.telefono,
      'ot': model.ot,
      'nodo': model.nodo,
      'region': model.region,
      'distrito': model.distrito,
      'tecnico': model.tecnico,
      'nombreTecnico': model.nombreTecnico,
      'bitacora': model.bitacora,
      'tap': model.tap,
      'colilla': model.colilla,
      'correo': model.correo,
    };

    try {
      final token = await _authService.getToken();
      final resp = await http.post(
          Uri.parse(
            '${Environment.apiURL}/apphome/gestion/tep/liquidar',
          ),
          body: jsonEncode(json),
          headers: {
            'Content-Type': 'application/json',
            'token': token,
          }).timeout(
        const Duration(
          minutes: 2,
        ),
      );

      if (resp.statusCode == 200) {
        //guardar en base de datos local
        await _dbService.updateStep(
          ot: model.ot.toString(),
          tabla: 'liquidar',
        );

        respuesta = true;
      } else {
        respuesta = false;
      }
    } catch (e) {
      respuesta = false;
    }

    return respuesta;
  }

  Future<bool> retryEnviarLiquidar(String ot) async {
    bool respuesta = false;

    List<Liquidar> models = await _dbService.getStepLiquidar(ot: ot);

    if (models.isNotEmpty) {
      final model = models.first;
      final json = {
        'telefono': model.telefono,
        'ot': model.ot,
        'nodo': model.nodo,
        'region': model.region,
        'distrito': model.distrito,
        'tecnico': model.tecnico,
        'nombreTecnico': model.nombreTecnico,
        'bitacora': model.bitacora,
        'tap': model.tap,
        'colilla': model.colilla,
        'correo': model.correo,
      };

      try {
        final token = await _authService.getToken();
        final resp = await http.post(
            Uri.parse(
              '${Environment.apiURL}/apphome/gestion/tep/liquidar',
            ),
            body: jsonEncode(json),
            headers: {
              'Content-Type': 'application/json',
              'token': token,
            }).timeout(
          const Duration(
            minutes: 2,
          ),
        );

        if (resp.statusCode == 200) {
          //guardar en base de datos local
          await _dbService.updateStep(
            ot: model.ot.toString(),
            tabla: 'liquidar',
          );

          respuesta = true;
        } else {
          respuesta = false;
        }
      } catch (e) {
        respuesta = false;
      }
    } else {
      respuesta = true;
    }

    return respuesta;
  }
}
