import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mihome_app/global/environment.dart';
import 'package:mihome_app/models/models.dart';
import 'package:mihome_app/services/services.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_image_picker/image_file.dart';

part 'visita_event.dart';
part 'visita_state.dart';

class VisitaBloc extends Bloc<VisitaEvent, VisitaState> {
  final DBService _dbService = DBService();
  FormGroup? formGroup;

  VisitaBloc() : super(const VisitaState()) {
    on<OnIniciarVisitaEvent>((event, emit) {
      emit(
        state.copyWith(
          frmControlVisita: event.frmControlVisita,
          formGroupVisita: event.formGroupVisita,
          frmVisitaListo: event.frmVisitaListo,
          errores: event.errores,
        ),
      );
    });
    on<OnFinalizarVisitaEvent>((event, emit) {
      emit(
        state.copyWith(
          guardado: event.guardado,
          enviado: event.enviado,
        ),
      );
    });
    on<OnGuardandoFormularioEvent>((event, emit) {
      emit(
        state.copyWith(
          guardandoFormulario: true,
        ),
      );
    });
    on<OnActualizarInformacionEvent>((event, emit) {
      emit(
        state.copyWith(
          formId: event.formId,
          fechaCreacion: event.fechaCreacion,
          instanceId: event.instanceId,
          respondentId: event.respondentId,
        ),
      );
    });
    on<OnActualizarIdVisitaEvent>((event, emit) {
      emit(
        state.copyWith(
          idVisita: event.idVisita,
          cliente: event.cliente,
        ),
      );
    });
  }

  Future<void> iniciarVisita(
    OT ot,
    String idForm,
    String usuario,
  ) async {
    add(
      const OnIniciarVisitaEvent(
        visitaIniciada: false,
        frmControlVisita: [],
        frmVisitaListo: false,
        errores: [],
      ),
    );

    List<String> errores = [];
    final localizacionHabilitada = await _checkGpsStatus();
    final position = await Geolocator.getCurrentPosition();

    if (localizacionHabilitada == 'Deshabilitado') {
      errores.add("Tienes la localización deshabilitada.");
    }

    final tipoDatos = await _checkDataStatus();
    String esRuta = "SI";

    try {
      final formulario = await _dbService.leerFormulario(
        idForm: idForm,
      );

      print("LONGITUD");
      print(formulario.length);
      //creamos el formGroup
      final formGroup = await createCurrentFormGroup(
        formulario: formulario,
        ot: ot,
        usuario: usuario,
        position: position,
        esRuta: esRuta,
        localizacionHabilitada: localizacionHabilitada,
        tipoDatos: tipoDatos,
        aplicaRevision: errores.isEmpty ? "NO" : "SI",
      );

      print("Segunda etapa");

      //Agregamos el evento para el BLOC
      add(
        OnIniciarVisitaEvent(
          visitaIniciada: true,
          frmControlVisita: formulario,
          formGroupVisita: formGroup,
          frmVisitaListo: true,
          errores: errores,
        ),
      );
    } catch (e) {
      print("Ha ocurrido un error");
      print(e.toString());
      add(
        const OnIniciarVisitaEvent(
          visitaIniciada: false,
          frmControlVisita: [],
          frmVisitaListo: false,
          errores: [],
        ),
      );
    }
  }

  Future<FormGroup> createCurrentFormGroup({
    required List<Formulario> formulario,
    required OT ot,
    required String usuario,
    required Position position,
    required String localizacionHabilitada,
    required String esRuta,
    required String tipoDatos,
    required String aplicaRevision,
  }) async {
    final jsonForm = ot.toJson();

    Map<String, AbstractControl<dynamic>> elementos = {};
    Map<String, AbstractControl<dynamic>> elemento = {};

    final fecha = DateTime.now();

    final idVisita = usuario +
        ":" +
        DateFormat('ddMMyyyyHHmmss').format(fecha) +
        ":" +
        ot.cliente.toString();

    add(
      OnActualizarIdVisitaEvent(
        idVisita: idVisita,
        cliente: ot.cliente.toString() == 'null'
            ? 0
            : int.parse(ot.cliente.toString()),
      ),
    );

    for (var campo in formulario) {
      List<Map<String, dynamic>? Function(AbstractControl<dynamic>)>
          validaciones = campo.required == 'Y' ? [Validators.required] : [];


      switch (campo.shortText.toString().toUpperCase()) {
        case "IDVISITA":
          {
            elemento = <String, AbstractControl<dynamic>>{
              "${campo.questionText}": FormControl<String>(
                value: idVisita,
                validators: validaciones,
              )
            };
          }
          break;
        case "OT":
          {
            elemento = <String, AbstractControl<dynamic>>{
              "${campo.questionText}": FormControl<String>(
                value: jsonForm['${campo.shortText}'].toString(),
                validators: validaciones,
              )
            };
          }
          break;
        case "LOCALIZACION":
          {
            elemento = <String, AbstractControl<dynamic>>{
              "${campo.questionText}": FormControl<String>(
                  validators: validaciones,
                  value: '${position.latitude}, ${position.longitude}')
            };
          }
          break;
        case "LOCALIZACIONHABILITADA":
          {
            elemento = <String, AbstractControl<dynamic>>{
              "${campo.questionText}": FormControl<String>(
                value: localizacionHabilitada,
                validators: validaciones,
              )
            };
          }
          break;
        case "TIPODATOS":
          {
            elemento = <String, AbstractControl<dynamic>>{
              "${campo.questionText}": FormControl<String>(
                value: tipoDatos,
                disabled: true,
                validators: validaciones,
              )
            };
          }
          break;
        case "USUARIO":
          {
            elemento = <String, AbstractControl<dynamic>>{
              "${campo.questionText}": FormControl<String>(
                value: usuario,
                validators: validaciones,
              )
            };
          }
          break;
        case "ESRUTA":
          {
            elemento = <String, AbstractControl<dynamic>>{
              "${campo.questionText}": FormControl<String>(
                value: esRuta,
                validators: validaciones,
              )
            };
          }
          break;
        case "APLICAREVISION":
          {
            elemento = <String, AbstractControl<dynamic>>{
              "${campo.questionText}": FormControl<String>(
                value: aplicaRevision,
                validators: validaciones,
              )
            };
          }
          break;
        case "INICIO":
          {
            elemento = <String, AbstractControl<dynamic>>{
              "${campo.questionText}": FormControl<String>(
                value: DateFormat('yyyyMMdd:HHmmss').format(fecha),
                validators: validaciones,
              )
            };
          }
          break;
        case "FIN":
          {
            elemento = <String, AbstractControl<dynamic>>{
              "${campo.questionText}": FormControl<String>(
                //value: aplicaRevision,
                validators: validaciones,
              )
            };
          }
          break;
      }
      elementos.addEntries(elemento.entries);
    }

    print("::::step 1:::");

    formGroup = FormGroup(elementos);



    await guardarFormulario(formulario, formGroup!);


    Visita visit = Visita(
      enviado: "NO",
      fechaInicioVisita: fecha,
      cliente: ot.cliente,
      idVisita: idVisita,
      latitud: position.latitude,
      longitud: position.longitude,
      usuario: usuario,
    );


    await _dbService.guardarVisita(visit);


    return formGroup!;
  }

  Future<String> _checkGpsStatus() async {
    final isEnabled = await Geolocator.isLocationServiceEnabled();

    if (isEnabled) {
      return 'Habilitado';
    }

    if (!isEnabled) {
      return 'Deshabilitado';
    }

    return 'Error';
  }

  Future<String> _checkDataStatus() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());

      if (connectivityResult == ConnectivityResult.mobile) {
        return "Mobile";
      }

      if (connectivityResult == ConnectivityResult.wifi) {
        return "Wifi";
      }
    } catch (e) {
      return "No Identificado";
    }

    return "No Habilitado";
  }

  Future<void> guardarFormulario(
    List<Formulario> estructura,
    FormGroup frm,
  ) async {
    add(
      const OnFinalizarVisitaEvent(
        enviado: false,
        guardado: false,
      ),
    );

    UsuarioService _usuarioService = UsuarioService();

    List<FormularioAnswer> respuestas = [];



    final usuario = await _usuarioService.getInfoUsuario();
    final currentDate = DateTime.now();
    final formated = DateFormat('yyyyMMdd:HHmmss').format(currentDate);
    final dato2 = DateFormat('yyyyMMddHHmmss').format(currentDate);

    final instanceId = dato2 + usuario.usuario.toString();

    int formId = -1;
    String idVisita = "";

    for (var campo in estructura) {
      FormularioAnswer resp = FormularioAnswer(
        instanceId: instanceId + campo.formId.toString(),
        formId: campo.formId,
        respondentId: usuario.usuario,
        fechaCreacion: formated,
        questionId: campo.questionId,
        enviado: "NO",
      );



      formId = campo.formId!;
      if (campo.shortText.toString() == "idVisita") {
        idVisita = frm.controls["${campo.questionText}"]!.value.toString();
      }

      switch (campo.questionType) {
        case 'Abierta Texto':
        case 'Abierta Numerica':
        case 'Seleccion Unica':
        case 'Fecha':
        case 'Abierta Texto Multilinea':
        case 'Localizacion':
          resp = resp.copyWith(
            response: frm.controls["${campo.questionText}"]!.value.toString(),
          );
          break;
        case 'Seleccion Multiple':
          final respuesta =
              (frm.controls["${campo.questionText}"]!.value as List);
          final respuestaMap = (respuesta[0] as Map);

          final resultado = <String>[];

          for (var i = 0; i < respuestaMap.keys.length; i++) {
            if (respuestaMap[respuestaMap.keys.elementAt(i)] == true) {
              resultado.add(respuestaMap.keys.elementAt(i));
            }
          }

          resp = resp.copyWith(
            response: resultado.join(","),
          );
          break;
        case 'Fotografia':
          {
            if (frm.controls["${campo.questionText}"]!.value != null) {
              final imageFile = File(
                  (frm.controls["${campo.questionText}"]!.value as ImageFile)
                      .image!
                      .path);

              Uint8List imagebytes =
                  await imageFile.readAsBytes(); //convert to bytes
              final imagen = base64.encode(imagebytes);

              resp = resp.copyWith(
                response: imagen,
              );
            }
          }
          break;
        default:
          {}
      }
      if (resp.response != null &&
          resp.response != '' &&
          resp.response != 'null') {
        respuestas.add(resp);
      }
    }


    await _dbService.guardarRespuestaFormulario(respuestas);

    add(OnActualizarInformacionEvent(
      formId: formId,
      instanceId: instanceId + formId.toString(),
      fechaCreacion: formated,
      respondentId: usuario.usuario.toString(),
      idVisita: idVisita,
    ));

    add(
      const OnFinalizarVisitaEvent(
        enviado: false,
        guardado: true,
      ),
    );
  }

  Future<void> enviarDatos({
    required int formId,
    required String instanceId,
    required String fechaCreacion,
    required String respondentId,
    required OT ot,
  }) async {
    add(
      const OnFinalizarVisitaEvent(
        enviado: false,
        guardado: true,
      ),
    );

    final currentDate = DateTime.now();
    final formated = DateFormat('yyyyMMdd:HHmmss').format(currentDate);

    FormularioAnswer resp = FormularioAnswer(
      instanceId: instanceId,
      formId: formId,
      respondentId: respondentId,
      fechaCreacion: fechaCreacion,
      questionId: 844,
      enviado: "NO",
      response: formated,
    );

    await _dbService.guardarRespuestaFormulario([resp]);
    await _dbService.actualizarOTPlanning(
      ot.copyWith(gestionado: 1),
    );

    final respuestas = await _dbService.leerRespuestaFormulario(
      instanceId: instanceId,
    );

    int registro = 1;
    int total = respuestas.length;
    for (var info in respuestas) {
      try {
        final data = {
          'APP_ID': '500',
          'RESPONDENT_ID': info.respondentId,
          'FORM_ID': info.formId,
          'QUESTION_ID': info.questionId,
          'RESPONSE': info.response,
          'FECHA_CREACION': info.fechaCreacion,
        };

        final resp = await http
            .post(
              Uri.parse('${Environment.apiURL}/appdms/newform'),
              body: jsonEncode(data),
              headers: {'Content-Type': 'application/json'},
              encoding: Encoding.getByName('utf-8'),
            )
            .timeout(const Duration(seconds: 30));

        if (resp.statusCode == 200) {
          await _dbService.updateInformacionForm(
            info.copyWith(enviado: 'SI'),
          );

          if (registro == total) {
            add(
              const OnFinalizarVisitaEvent(
                enviado: true,
                guardado: true,
              ),
            );
          }

          registro += 1;
        } else {
          add(
            const OnFinalizarVisitaEvent(
              enviado: false,
              guardado: true,
            ),
          );
          return;
        }
      } on TimeoutException catch (_) {
        add(
          const OnFinalizarVisitaEvent(
            enviado: false,
            guardado: true,
          ),
        );
        return;
      } catch (e) {
        add(
          const OnFinalizarVisitaEvent(
            enviado: false,
            guardado: true,
          ),
        );
        return;
      }
    }
  }

  Future<void> enviarDatosAuditoria({
    required int formId,
    required String instanceId,
    required String fechaCreacion,
    required String respondentId,
    required OT ot,
  }) async {
    add(
      const OnFinalizarVisitaEvent(
        enviado: false,
        guardado: true,
      ),
    );

    final currentDate = DateTime.now();
    final formated = DateFormat('yyyyMMdd:HHmmss').format(currentDate);

    FormularioAnswer resp = FormularioAnswer(
      instanceId: instanceId,
      formId: formId,
      respondentId: respondentId,
      fechaCreacion: fechaCreacion,
      questionId: 279,
      enviado: "NO",
      response: formated,
    );

    await _dbService.guardarRespuestaFormulario([resp]);

    final respuestas = await _dbService.leerRespuestaFormulario(
      instanceId: instanceId,
    );

    int registro = 1;
    int total = respuestas.length;
    for (var info in respuestas) {
      try {
        final data = {
          'APP_ID': '500',
          'RESPONDENT_ID': info.respondentId,
          'FORM_ID': info.formId,
          'QUESTION_ID': info.questionId,
          'RESPONSE': info.response,
          'FECHA_CREACION': info.fechaCreacion,
        };

        final resp = await http
            .post(
              Uri.parse('${Environment.apiURL}/appdms/newform'),
              body: jsonEncode(data),
              headers: {'Content-Type': 'application/json'},
              encoding: Encoding.getByName('utf-8'),
            )
            .timeout(const Duration(seconds: 30));

        if (resp.statusCode == 200) {
          await _dbService.updateInformacionForm(
            info.copyWith(enviado: 'SI'),
          );

          if (registro == total) {
            add(
              const OnFinalizarVisitaEvent(
                enviado: true,
                guardado: true,
              ),
            );
          }

          registro += 1;
        } else {
          add(
            const OnFinalizarVisitaEvent(
              enviado: false,
              guardado: true,
            ),
          );
          return;
        }
      } on TimeoutException catch (_) {
        add(
          const OnFinalizarVisitaEvent(
            enviado: false,
            guardado: true,
          ),
        );
        return;
      } catch (e) {
        add(
          const OnFinalizarVisitaEvent(
            enviado: false,
            guardado: true,
          ),
        );
        return;
      }
    }
  }

  Future<void> finalizarVisita({
    required int formId,
    required String instanceId,
    required String fechaCreacion,
    required String respondentId,
    required OT ot,
  }) async {
    add(
      const OnFinalizarVisitaEvent(
        enviado: false,
        guardado: true,
      ),
    );

    final currentDate = DateTime.now();
    final formated = DateFormat('yyyyMMdd:HHmmss').format(currentDate);

    FormularioAnswer resp = FormularioAnswer(
      instanceId: instanceId,
      formId: formId,
      respondentId: respondentId,
      fechaCreacion: fechaCreacion,
      questionId: 844,
      enviado: "NO",
      response: formated,
    );

    await _dbService.guardarRespuestasFormulario([resp]);
    await _dbService.actualizarOTPlanning(
      ot.copyWith(
        gestionado: 1,
      ),
    );
  }
}
