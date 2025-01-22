import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mihome_app/global/environment.dart';
import 'package:mihome_app/models/form_response.dart';
import 'package:mihome_app/models/models.dart';
import 'package:mihome_app/services/services.dart';
import 'package:mihome_app/widgets/widgets.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_image_picker/image_file.dart';

part 'formulario_event.dart';
part 'formulario_state.dart';

class FormularioBloc extends Bloc<FormularioEvent, FormularioState> {
  final DBService _dbService = DBService();
  final AuthService _authService = AuthService();
  FormGroup? formGroup;

  FormularioBloc() : super(const FormularioState()) {
    on<OnActualizarFormsEvent>((event, emit) {
      emit(
        state.copyWith(
          formsActualizados: event.formsActualizados,
          formularios: event.formularios,
        ),
      );
    });
    on<OnCargarFormsEvent>((event, emit) {
      emit(
        state.copyWith(
          formularios: event.formularios,
          lstFormVisita: event.lstFormVisita,
          formgroupVisita: event.formgroupVisita,
          isFrmVisitaListo: event.isFrmVisitaListo,
        ),
      );
    });
    on<OnChangeBetweenForms>((event, emit) {
      emit(
        state.copyWith(
          frmActualVisita: event.frmActualVisita,
        ),
      );
    });
    on<OnUpdateProcessing>((event, emit) {
      emit(
        state.copyWith(
          guardado: event.guardado,
          enviado: event.enviado,
          procesando: event.procesando ?? state.procesando,
        ),
      );
    });
    on<OnCurrentFormReadyEvent>((event, emit) {
      emit(
        state.copyWith(
            currentForm: event.currentForm,
            isCurrentFormListo: event.isCurrentFormReady,
            currentFormgroup: event.formGroup),
      );
    });
    on<OnProcessingEvent>((event, emit) {
      emit(state.copyWith(
        mensaje: event.mensaje,
        enviadoVisita: event.enviadoVisita,
        procesando: event.procesando ?? state.procesando,
      ));
    });
    on<OnCurrentFormsSaving>(guardarFormularios);
    on<OnUpdateFormsEvent>((event, emit) {
      emit(
        state.copyWith(
          formularios: event.formularios,
          formulariosAud: event.formulariosAud,
        ),
      );
    });
    on<OnCargarFormsAudEvent>((event, emit) {
      emit(
        state.copyWith(
          formulariosAud: event.formulariosAud,
          lstFormAud: event.lstFormAud,
          formGroupAud: event.formGroupAud,
          isFrmAudListo: event.isFrmAudListo,
        ),
      );
    });
  }

  Future<void> init() async {
    final updateFormularios = await actualizarForms();
    final forms = await getFormulariosVisita();

    //Agregamos el evento para el BLOC
    add(
      OnActualizarFormsEvent(
        formsActualizados: updateFormularios,
        formularios: forms,
      ),
    );
  }

  Future<void> actualizarFormsModificaion(String? idForm) async {
    final forms = await getFormulariosModificacion(
      formId: idForm,
    );

    //Agregamos el evento para el BLOC
    add(
      OnActualizarFormsEvent(
        formsActualizados: true,
        formularios: forms,
      ),
    );
  }

  Future<void> cargarFormsVisita({required OT ot}) async {
    //Agregamos el evento para el BLOC
    add(
      const OnCargarFormsEvent(
        formularios: <FormularioResumen>[],
        lstFormVisita: [],
        isFrmVisitaListo: false,
      ),
    );
    final formsResumen = await getFormulariosVisita();
    final formsDetalle =
        await getDetalleFormulariosVisita(resumen: formsResumen);
    final frmsGroup = await getFormGroupsVisita(
      detalle: formsDetalle,
      ot: ot,
    );
    //Agregamos el evento para el BLOC
    add(
      OnCargarFormsEvent(
        formularios: formsResumen,
        formgroupVisita: frmsGroup,
        lstFormVisita: formsDetalle,
        isFrmVisitaListo: true,
      ),
    );
  }

  Future<void> getFormularioAuditoriaTap(Georreferencia geo) async {
    add(
      const OnCurrentFormReadyEvent(
        isCurrentFormReady: false,
        currentForm: [],
      ),
    );
    try {
      final formulario = await _dbService.leerFormularioAuditoria(
        tipo: 'AUDITORIA HOME',
      );
      //creamos el formGroup
      final formGroup = await createCurrentFormGroupGeo(
        formulario,
        geo,
      );

      //Agregamos el evento para el BLOC
      add(
        OnCurrentFormReadyEvent(
          isCurrentFormReady: true,
          currentForm: formulario,
          formGroup: formGroup,
        ),
      );
    } catch (e) {
      add(
        const OnCurrentFormReadyEvent(
          isCurrentFormReady: false,
          currentForm: [],
        ),
      );
    }
  }

  Future<void> cargarFormAuditoria({
    required OT ot,
  }) async {
    //Agregamos el evento para el BLOC
    add(
      const OnCargarFormsAudEvent(
        formulariosAud: <FormularioResumen>[],
        lstFormAud: [],
        isFrmAudListo: false,
      ),
    );
    final formsResumen = await getFormulariosAuditoria();

    final formsDetalle = await getDetalleFormulariosAuditoria(
      resumen: formsResumen,
    );

    final frmsGroup = await getFormGroupsAud(
      detalle: formsDetalle,
      ot: ot,
    );
    //Agregamos el evento para el BLOC
    add(
      OnCargarFormsAudEvent(
        formulariosAud: formsResumen,
        formGroupAud: frmsGroup,
        lstFormAud: formsDetalle,
        isFrmAudListo: true,
      ),
    );
  }

  Future<List<FormularioResumen>> getFormulariosAuditoria() async {
    try {
      final formsResumen = await _dbService.leerResumenFormsAud();
      return formsResumen;
    } catch (e) {
      return <FormularioResumen>[];
    }
  }

  Future<void> cargarFormsGeneral() async {
    //Agregamos el evento para el BLOC
    add(
      const OnCargarFormsEvent(
        formularios: <FormularioResumen>[],
        lstFormVisita: [],
        isFrmVisitaListo: false,
      ),
    );
    final formsResumen = await getFormulariosGeneral();
    final formsDetalle =
        await getDetalleFormulariosVisita(resumen: formsResumen);
    final frmsGroup = await getFormGroupsGeneral(
      detalle: formsDetalle,
    );
    //Agregamos el evento para el BLOC
    add(
      OnCargarFormsEvent(
        formularios: formsResumen,
        formgroupVisita: frmsGroup,
        lstFormVisita: formsDetalle,
        isFrmVisitaListo: true,
      ),
    );
  }

  Future<bool> actualizarForms() async {
    try {
      final token = await _authService.getToken();
      final resp = await http.get(
        Uri.parse('${Environment.apiURL}/appdms/estructura_form/500'),
        headers: {
          'Content-Type': 'application/json',
          'token': token,
        },
      );

      final formsResponse = formResponseFromMap(resp.body);

      //guardar en base de datos local
      await _dbService.crearFormularios(formsResponse.detalleFormulario);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Formulario>> getFormularios() async {
    try {
      final forms = await _dbService.leerListadoForms();
      return forms;
    } catch (e) {
      return <Formulario>[];
    }
  }

  Future<List<FormularioResumen>> getFormulariosModificacion({
    String? formId,
  }) async {
    try {
      final formsResumen = await _dbService.leerResumenForms(
        tipo: "MODIFICACION",
        formId: formId,
      );
      return formsResumen;
    } catch (e) {
      return <FormularioResumen>[];
    }
  }

  Future<List<FormularioResumen>> getFormulariosVisita() async {
    try {
      final formsResumen = await _dbService.leerResumenForms(
        tipo: "VISITA",
        subType: 'AUDITORIA MATERIALES',
      );
      return formsResumen;
    } catch (e) {
      return <FormularioResumen>[];
    }
  }

  Future<List<FormularioResumen>> getFormulariosGeneral() async {
    try {
      final formsResumen = await _dbService.leerResumenForms(tipo: "GENERAL");
      return formsResumen;
    } catch (e) {
      return <FormularioResumen>[];
    }
  }

  Future<List<Formulario>> getDetalleFormulariosVisita({
    required List<FormularioResumen> resumen,
  }) async {
    List<Formulario> respuesta = <Formulario>[];

    try {
      for (var frm in resumen) {
        final formulario = await _dbService.leerFormulario(
          idForm: frm.formId.toString(),
        );
        respuesta = [...respuesta, ...formulario];
      }

      return respuesta;
    } catch (e) {
      return respuesta;
    }
  }

  Future<List<Formulario>> getDetalleFormulariosAuditoria({
    required List<FormularioResumen> resumen,
  }) async {
    List<Formulario> respuesta = <Formulario>[];
    try {
      for (var frm in resumen) {
        final formulario = await _dbService.leerFormulario(
          idForm: frm.formId.toString(),
        );
        respuesta = [...respuesta, ...formulario];
      }

      return respuesta;
    } catch (e) {
      return respuesta;
    }
  }

  Future<FormGroup> getFormGroupsVisita({
    required List<Formulario> detalle,
    required OT ot,
  }) async {
    final respuesta = await createCurrentFormGroupAud(detalle, ot);
    return respuesta;
  }

  Future<FormGroup> getFormGroupsAud({
    required List<Formulario> detalle,
    required OT ot,
  }) async {
    return await createCurrentFormGroupAud(
      detalle,
      ot,
    );
  }

  Future<FormGroup> getFormGroupsGeneral({
    required List<Formulario> detalle,
  }) async {
    final formGroup = await createCurrentFormGroupGeneral(
      detalle,
    );

    return formGroup;
  }

  Future<void> obtenerFormulario(String idForm) async {
    try {
      final formsResumen = await _dbService.leerResumenForms(
        tipo: "MODIFICACION",
        formId: idForm,
      );
      add(
        OnActualizarFormsEvent(
          formsActualizados: true,
          formularios: formsResumen,
        ),
      );
    } catch (e) {
      add(
        const OnActualizarFormsEvent(
          formsActualizados: true,
          formularios: [],
        ),
      );
    }

    //Agregamos el evento para el BLOC
  }

  Future<void> getFormulario({
    required String idForm,
    required Agenda ot,
  }) async {
    add(
      const OnCurrentFormReadyEvent(
        isCurrentFormReady: false,
        currentForm: [],
      ),
    );
    try {
      final formulario = await _dbService.leerFormulario(
        idForm: idForm,
      );
      //creamos el formGroup
      final formGroup = await createCurrentFormGroup(formulario, ot);

      //Agregamos el evento para el BLOC
      add(
        OnCurrentFormReadyEvent(
          isCurrentFormReady: true,
          currentForm: formulario,
          formGroup: formGroup,
        ),
      );
    } catch (e) {
      add(
        const OnCurrentFormReadyEvent(
          isCurrentFormReady: false,
          currentForm: [],
        ),
      );
    }
  }

  Future<void> getFormularioOT({
    required String idForm,
    required OT ot,
  }) async {
    add(
      const OnCurrentFormReadyEvent(
        isCurrentFormReady: false,
        currentForm: [],
      ),
    );
    try {
      final formulario = await _dbService.leerFormulario(
        idForm: idForm,
      );

      //creamos el formGroup
      final formGroup = await createCurrentFormGroupAud(formulario, ot);

      //Agregamos el evento para el BLOC
      add(
        OnCurrentFormReadyEvent(
          isCurrentFormReady: true,
          currentForm: formulario,
          formGroup: formGroup,
        ),
      );
    } catch (e) {
      add(
        const OnCurrentFormReadyEvent(
          isCurrentFormReady: false,
          currentForm: [],
        ),
      );
    }
  }

  Future<void> getFormularioGeo(Georreferencia geo) async {
    add(
      const OnCurrentFormReadyEvent(
        isCurrentFormReady: false,
        currentForm: [],
      ),
    );
    try {
      final formulario = await _dbService.leerFormularioGeo(
        tipo: geo.tipo.toString(),
      );
      //creamos el formGroup
      final formGroup = await createCurrentFormGroupGeo(
        formulario,
        geo,
      );

      //Agregamos el evento para el BLOC
      add(
        OnCurrentFormReadyEvent(
          isCurrentFormReady: true,
          currentForm: formulario,
          formGroup: formGroup,
        ),
      );
    } catch (e) {
      add(
        const OnCurrentFormReadyEvent(
          isCurrentFormReady: false,
          currentForm: [],
        ),
      );
    }
  }

  Future<void> getFormularioAuditoriaMateriales(OT ot) async {
    add(
      const OnCurrentFormReadyEvent(
        isCurrentFormReady: false,
        currentForm: [],
      ),
    );
    try {
      final formulario = await _dbService.leerFormularioAuditoria(
        tipo: 'AUDITORIA MATERIALES',
      );
      //creamos el formGroup
      final formGroup = await createCurrentFormGroupAud(
        formulario,
        ot,
      );

      //Agregamos el evento para el BLOC
      add(
        OnCurrentFormReadyEvent(
          isCurrentFormReady: true,
          currentForm: formulario,
          formGroup: formGroup,
        ),
      );
    } catch (e) {
      add(
        const OnCurrentFormReadyEvent(
          isCurrentFormReady: false,
          currentForm: [],
        ),
      );
    }
  }

  Future<void> updateDataGeo({
    required Georreferencia geo,
  }) async {
    try {
      await _dbService.updateInformacionGeo(geo);
    } catch (e) {
      null;
    }
  }

  Future<void> getFormularioGeneral(String idForm) async {
    add(
      const OnCurrentFormReadyEvent(
        isCurrentFormReady: false,
        currentForm: [],
      ),
    );
    try {
      final formulario = await _dbService.leerFormulario(
        idForm: idForm,
      );
      //creamos el formGroup
      final formGroup = await createCurrentFormGroupGeneral(formulario);

      //Agregamos el evento para el BLOC
      add(
        OnCurrentFormReadyEvent(
          isCurrentFormReady: true,
          currentForm: formulario,
          formGroup: formGroup,
        ),
      );
    } catch (e) {
      add(
        const OnCurrentFormReadyEvent(
          isCurrentFormReady: false,
          currentForm: [],
        ),
      );
    }
  }

  Future<FormGroup> createCurrentFormGroupGeneral(
      List<Formulario> formulario) async {
    Map<String, AbstractControl<dynamic>> elementos = {};
    Map<String, AbstractControl<dynamic>> elemento = {};
    for (var campo in formulario) {
      List<Map<String, dynamic>? Function(AbstractControl<dynamic>)>
          validaciones = campo.required == 'Y' ? [Validators.required] : [];

      switch (campo.auto) {
        case 1:
          {
            elemento = <String, AbstractControl<dynamic>>{
              "${campo.questionText}": FormControl<String>(
                value: 'No Soportado',
                disabled: true,
                validators: validaciones,
              )
            };
          }
          break;
        case 0:
          {
            if (campo.questionType == 'Seleccion Multiple') {
              var elementos = campo.offeredAnswer.toString().split(",");

              final estructura = <String, AbstractControl<dynamic>>{};

              for (var elemento in elementos) {
                final valor = {elemento: FormControl<bool>(value: false)};
                estructura.addEntries(valor.entries);
              }

              elemento = <String, AbstractControl<dynamic>>{
                "${campo.questionText}": FormArray([
                  FormGroup(estructura),
                ]),
              };
            } else if (campo.questionType == 'Fotografia') {
              elemento = <String, AbstractControl<dynamic>>{
                "${campo.questionText}": FormControl<ImageFile>(
                  validators: validaciones,
                )
              };
            } else if (campo.questionType == 'Localizacion') {
              final position = await Geolocator.getCurrentPosition();

              elemento = <String, AbstractControl<dynamic>>{
                "${campo.questionText}": FormControl<String>(
                    validators: validaciones,
                    disabled: true,
                    value: '${position.latitude}, ${position.longitude}')
              };
            } else {
              elemento = <String, AbstractControl<dynamic>>{
                "${campo.questionText}": FormControl<String>(
                  validators: validaciones,
                )
              };
            }
          }
          break;
      }
      elementos.addEntries(elemento.entries);
    }

    formGroup = FormGroup(elementos);

    return formGroup!;
  }

  Future<FormGroup> createCurrentFormGroup(
    List<Formulario> formulario,
    Agenda pdv,
  ) async {
    final jsonForm = pdv.toJson();

    Map<String, AbstractControl<dynamic>> elementos = {};
    Map<String, AbstractControl<dynamic>> elemento = {};
    for (var campo in formulario) {
      List<Map<String, dynamic>? Function(AbstractControl<dynamic>)>
          validaciones = campo.required == 'Y' ? [Validators.required] : [];

      switch (campo.auto) {
        case 1:
          {
            elemento = <String, AbstractControl<dynamic>>{
              "${campo.questionText}": FormControl<String>(
                value: jsonForm['${campo.shortText}'].toString(),
                disabled: (campo.formId == 19 &&
                        (campo.questionId == 253 ||
                            campo.questionId == 257 ||
                            campo.questionId == 258))
                    ? false
                    : true,
                validators: validaciones,
              )
            };
          }
          break;
        case 0:
          {
            if (campo.questionType == 'Seleccion Multiple') {
              var elementos = campo.offeredAnswer.toString().split(",");

              final estructura = <String, AbstractControl<dynamic>>{};

              for (var elemento in elementos) {
                final valor = {elemento: FormControl<bool>(value: false)};
                estructura.addEntries(valor.entries);
              }

              elemento = <String, AbstractControl<dynamic>>{
                "${campo.questionText}": FormArray([
                  FormGroup(estructura),
                ]),
              };
            } else if (campo.questionType == 'Fotografia') {
              elemento = <String, AbstractControl<dynamic>>{
                "${campo.questionText}": FormControl<ImageFile>(
                  validators: validaciones,
                )
              };
            } else if (campo.questionType == 'Localizacion') {
              final position = await Geolocator.getCurrentPosition();

              elemento = <String, AbstractControl<dynamic>>{
                "${campo.questionText}": FormControl<String>(
                    validators: validaciones,
                    disabled: true,
                    value: '${position.latitude}, ${position.longitude}')
              };
            } else {
              elemento = <String, AbstractControl<dynamic>>{
                "${campo.questionText}": FormControl<String>(
                  validators: validaciones,
                )
              };
            }
          }
          break;
      }
      elementos.addEntries(elemento.entries);
    }

    formGroup = FormGroup(elementos);

    return formGroup!;
  }

  Future<FormGroup> createCurrentFormGroupAud(
    List<Formulario> formulario,
    OT pdv,
  ) async {
    final jsonForm = pdv.toJson();

    Map<String, AbstractControl<dynamic>> elementos = {};
    Map<String, AbstractControl<dynamic>> elemento = {};
    for (var campo in formulario) {
      List<Map<String, dynamic>? Function(AbstractControl<dynamic>)>
          validaciones = campo.required == 'Y' ? [Validators.required] : [];

      switch (campo.auto) {
        case 1:
          {
            elemento = <String, AbstractControl<dynamic>>{
              "${campo.questionText}": FormControl<String>(
                value: jsonForm['${campo.shortText}'].toString(),
                disabled: (campo.formId == 19 &&
                        (campo.questionId == 253 ||
                            campo.questionId == 257 ||
                            campo.questionId == 258))
                    ? false
                    : true,
                validators: validaciones,
              )
            };
          }
          break;
        case 0:
          {
            if (campo.questionType == 'Seleccion Multiple') {
              var elementos = campo.offeredAnswer.toString().split(",");

              final estructura = <String, AbstractControl<dynamic>>{};

              for (var elemento in elementos) {
                final valor = {elemento: FormControl<bool>(value: false)};
                estructura.addEntries(valor.entries);
              }

              elemento = <String, AbstractControl<dynamic>>{
                "${campo.questionText}": FormArray([
                  FormGroup(estructura),
                ]),
              };
            } else if (campo.questionType == 'Fotografia') {
              elemento = <String, AbstractControl<dynamic>>{
                "${campo.questionText}": FormControl<ImageFile>(
                  validators: validaciones,
                )
              };
            } else if (campo.questionType == 'Localizacion') {
              final position = await Geolocator.getCurrentPosition();

              elemento = <String, AbstractControl<dynamic>>{
                "${campo.questionText}": FormControl<String>(
                    validators: validaciones,
                    disabled: true,
                    value: '${position.latitude}, ${position.longitude}')
              };
            } else {
              elemento = <String, AbstractControl<dynamic>>{
                "${campo.questionText}": FormControl<String>(
                  validators: validaciones,
                )
              };
            }
          }
          break;
      }
      elementos.addEntries(elemento.entries);
    }

    formGroup = FormGroup(elementos);

    return formGroup!;
  }

  Future<FormGroup> createCurrentFormGroupGeo(
    List<Formulario> formulario,
    Georreferencia geo,
  ) async {
    final jsonForm = geo.toJson();

    Map<String, AbstractControl<dynamic>> elementos = {};
    Map<String, AbstractControl<dynamic>> elemento = {};
    for (var campo in formulario) {
      List<Map<String, dynamic>? Function(AbstractControl<dynamic>)>
          validaciones = campo.required == 'Y' ? [Validators.required] : [];

      switch (campo.auto) {
        case 1:
          {
            elemento = <String, AbstractControl<dynamic>>{
              "${campo.questionText}": FormControl<String>(
                value: jsonForm['${campo.shortText}'].toString(),
                disabled: (campo.questionId == 303 ||
                        campo.questionId == 320 ||
                        campo.questionId == 321)
                    ? true
                    : false,
                validators: validaciones,
              )
            };
          }
          break;
        case 0:
          {
            if (campo.questionType == 'Seleccion Multiple') {
              var elementos = campo.offeredAnswer.toString().split(",");

              final estructura = <String, AbstractControl<dynamic>>{};

              for (var elemento in elementos) {
                final valor = {elemento: FormControl<bool>(value: false)};
                estructura.addEntries(valor.entries);
              }

              elemento = <String, AbstractControl<dynamic>>{
                "${campo.questionText}": FormArray([
                  FormGroup(estructura),
                ]),
              };
            } else if (campo.questionType == 'Fotografia') {
              elemento = <String, AbstractControl<dynamic>>{
                "${campo.questionText}": FormControl<ImageFile>(
                  validators: validaciones,
                )
              };
            } else if (campo.questionType == 'Localizacion') {
              final position = await Geolocator.getCurrentPosition();

              elemento = <String, AbstractControl<dynamic>>{
                "${campo.questionText}": FormControl<String>(
                    validators: validaciones,
                    disabled: true,
                    value: '${position.latitude}, ${position.longitude}')
              };
            } else {
              elemento = <String, AbstractControl<dynamic>>{
                "${campo.questionText}": FormControl<String>(
                  validators: validaciones,
                )
              };
            }
          }
          break;
      }
      elementos.addEntries(elemento.entries);
    }

    formGroup = FormGroup(elementos);

    return formGroup!;
  }

  List<Widget> contruirCampos(List<Formulario> form) {
    List<Widget> campos = <Widget>[];

    print("::::CONSTRUYENDO FORMULARIO::::::");
    print(form.length);

    const espacio = SizedBox(
      height: 10,
    );

    for (var campo in form) {
      var preguntasPadre = campo.parentQuestion.toString().split("|");
      var respuestasPadre = campo.parentAnswer.toString().split("|");

      switch (campo.questionType) {
        case 'Abierta Texto':
          if (campo.conditional == 1) {
            final padre = form.map((elemento) {
              if (preguntasPadre[0].contains(
                elemento.questionId.toString(),
              )) {
                return elemento.questionText.toString();
              }
            }).toList();

            final filtrado = padre.where((e) => e != null).toList();

            campos.add(ReactiveValueListenableBuilder<String>(
              formControlName: filtrado[0],
              builder: (context, control, child) {
                if (respuestasPadre[0].contains(control.value.toString())) {
                  if (preguntasPadre.length >= 2) {
                    final padre2 = form.map((elemento) {
                      if (preguntasPadre[1]
                          .contains(elemento.questionId.toString())) {
                        return elemento.questionText.toString();
                      }
                    }).toList();

                    final filtrado2 = padre2.where((e) => e != null).toList();

                    return ReactiveValueListenableBuilder(
                      formControlName: filtrado2[0],
                      builder: (context, control, child) {
                        if (respuestasPadre[1]
                            .contains(control.value.toString())) {
                          return Column(
                            children: [
                              SOTextField(
                                campo: campo,
                              ),
                              espacio,
                            ],
                          );
                        }
                        return Container();
                      },
                    );
                  } else {
                    return Column(
                      children: [
                        SOTextField(
                          campo: campo,
                        ),
                        espacio,
                      ],
                    );
                  }

                  //campos.add(espacio);
                }
                return Container();
              },
            ));
          } else {
            campos.add(
              SOTextField(campo: campo),
            );
            campos.add(espacio);
          }
          break;
        case 'Abierta Numerica':
          if (campo.conditional == 1) {
            final padre = form.map((elemento) {
              if (preguntasPadre[0].contains(elemento.questionId.toString())) {
                return elemento.questionText.toString();
              }
            }).toList();

            final filtrado = padre.where((e) => e != null).toList();

            campos.add(ReactiveValueListenableBuilder<String>(
              formControlName: filtrado[0],
              builder: (context, control, child) {
                if (respuestasPadre[0].contains(control.value.toString())) {
                  if (preguntasPadre.length >= 2) {
                    final padre2 = form.map((elemento) {
                      if (preguntasPadre[1]
                          .contains(elemento.questionId.toString())) {
                        return elemento.questionText.toString();
                      }
                    }).toList();

                    final filtrado2 = padre2.where((e) => e != null).toList();

                    return ReactiveValueListenableBuilder(
                      formControlName: filtrado2[0],
                      builder: (context, control, child) {
                        if (respuestasPadre[1]
                            .contains(control.value.toString())) {
                          return Column(
                            children: [
                              SONumberField(
                                campo: campo,
                              ),
                              espacio,
                            ],
                          );
                        }
                        return Container();
                      },
                    );
                  } else {
                    return Column(
                      children: [
                        SONumberField(
                          campo: campo,
                        ),
                        espacio,
                      ],
                    );
                  }

                  //campos.add(espacio);
                }
                return Container();
              },
            ));
          } else {
            campos.add(
              SONumberField(campo: campo),
            );
            campos.add(espacio);
          }
          break;
        case 'Seleccion Unica':
          if (campo.conditional == 1) {
            final padre = form.map((elemento) {
              if (preguntasPadre[0].contains(elemento.questionId.toString())) {
                return elemento.questionText.toString();
              }
            }).toList();

            final filtrado = padre.where((e) => e != null).toList();

            campos.add(ReactiveValueListenableBuilder<String>(
              formControlName: filtrado[0],
              builder: (context, control, child) {
                if (respuestasPadre[0].contains(control.value.toString())) {
                  if (preguntasPadre.length >= 2) {
                    final padre2 = form.map((elemento) {
                      if (preguntasPadre[1]
                          .contains(elemento.questionId.toString())) {
                        return elemento.questionText.toString();
                      }
                    }).toList();

                    final filtrado2 = padre2.where((e) => e != null).toList();

                    return ReactiveValueListenableBuilder(
                      formControlName: filtrado2[0],
                      builder: (context, control, child) {
                        if (respuestasPadre[1]
                            .contains(control.value.toString())) {
                          return Column(
                            children: [
                              SOSeleccionUnicaField(
                                campo: campo,
                              ),
                              espacio
                            ],
                          );
                        }
                        return Container();
                      },
                    );
                  } else {
                    return Column(
                      children: [
                        SOSeleccionUnicaField(
                          campo: campo,
                        ),
                        espacio
                      ],
                    );
                  }

                  //campos.add(espacio);
                }
                return Container();
              },
            ));
          } else {
            campos.add(
              SOSeleccionUnicaField(campo: campo),
            );
            campos.add(espacio);
          }
          break;
        case 'Scanner':
          if (campo.conditional == 1) {
            final padre = form.map((elemento) {
              if (preguntasPadre[0].contains(elemento.questionId.toString())) {
                return elemento.questionText.toString();
              }
            }).toList();

            final filtrado = padre.where((e) => e != null).toList();

            campos.add(ReactiveValueListenableBuilder<String>(
              formControlName: filtrado[0],
              builder: (context, control, child) {
                if (respuestasPadre[0].contains(control.value.toString())) {
                  if (preguntasPadre.length >= 2) {
                    final padre2 = form.map((elemento) {
                      if (preguntasPadre[1]
                          .contains(elemento.questionId.toString())) {
                        return elemento.questionText.toString();
                      }
                    }).toList();

                    final filtrado2 = padre2.where((e) => e != null).toList();

                    return ReactiveValueListenableBuilder(
                      formControlName: filtrado2[0],
                      builder: (context, control, child) {
                        if (respuestasPadre[1]
                            .contains(control.value.toString())) {
                          return Column(
                            children: [
                              SOScannerField(
                                campo: campo,
                              ),
                              espacio
                            ],
                          );
                        }
                        return Container();
                      },
                    );
                  } else {
                    return Column(
                      children: [
                        SOScannerField(
                          campo: campo,
                        ),
                        espacio
                      ],
                    );
                  }

                  //campos.add(espacio);
                }
                return Container();
              },
            ));
          } else {
            campos.add(
              SOScannerField(campo: campo),
            );
            campos.add(espacio);
          }
          break;
        case 'Seleccion Multiple':
          if (campo.conditional == 1) {
            final padre = form.map((elemento) {
              if (preguntasPadre[0].contains(elemento.questionId.toString())) {
                return elemento.questionText.toString();
              }
            }).toList();

            final filtrado = padre.where((e) => e != null).toList();

            campos.add(ReactiveValueListenableBuilder<String>(
              formControlName: filtrado[0],
              builder: (context, control, child) {
                if (respuestasPadre[0].contains(control.value.toString())) {
                  if (preguntasPadre.length >= 2) {
                    final padre2 = form.map((elemento) {
                      if (preguntasPadre[1]
                          .contains(elemento.questionId.toString())) {
                        return elemento.questionText.toString();
                      }
                    }).toList();

                    final filtrado2 = padre2.where((e) => e != null).toList();

                    return ReactiveValueListenableBuilder(
                      formControlName: filtrado2[0],
                      builder: (context, control, child) {
                        if (respuestasPadre[1]
                            .contains(control.value.toString())) {
                          return Column(
                            children: [
                              SOSeleccionMultipleField(
                                campo: campo,
                                formGroup: formGroup!,
                              ),
                              espacio,
                            ],
                          );
                        }
                        return Container();
                      },
                    );
                  } else {
                    return Column(
                      children: [
                        SOSeleccionMultipleField(
                          campo: campo,
                          formGroup: formGroup!,
                        ),
                        espacio,
                      ],
                    );
                  }
                  //campos.add(espacio);
                }
                return Container();
              },
            ));
          } else {
            campos.add(
              SOSeleccionMultipleField(campo: campo, formGroup: formGroup!),
            );
            campos.add(espacio);
          }
          break;
        case 'Abierta Texto Multilinea':
          if (campo.conditional == 1) {
            final padre = form.map((elemento) {
              if (preguntasPadre[0].contains(elemento.questionId.toString())) {
                return elemento.questionText.toString();
              }
            }).toList();

            final filtrado = padre.where((e) => e != null).toList();

            campos.add(ReactiveValueListenableBuilder<String>(
              formControlName: filtrado[0],
              builder: (context, control, child) {
                if (respuestasPadre[0].contains(control.value.toString())) {
                  if (preguntasPadre.length >= 2) {
                    final padre2 = form.map((elemento) {
                      if (preguntasPadre[1]
                          .contains(elemento.questionId.toString())) {
                        return elemento.questionText.toString();
                      }
                    }).toList();

                    final filtrado2 = padre2.where((e) => e != null).toList();

                    return ReactiveValueListenableBuilder(
                      formControlName: filtrado2[0],
                      builder: (context, control, child) {
                        if (respuestasPadre[1]
                            .contains(control.value.toString())) {
                          return Column(
                            children: [
                              SOTextFieldMultilineField(
                                campo: campo,
                              ),
                              espacio,
                            ],
                          );
                        }
                        return Container();
                      },
                    );
                  } else {
                    return Column(
                      children: [
                        SOTextFieldMultilineField(
                          campo: campo,
                        ),
                        espacio,
                      ],
                    );
                  }

                  //campos.add(espacio);
                }
                return Container();
              },
            ));
          } else {
            campos.add(
              SOTextFieldMultilineField(campo: campo),
            );
            campos.add(espacio);
          }
          break;
        case 'Fotografia':
          if (campo.conditional == 1) {
            final padre = form.map((elemento) {
              if (preguntasPadre[0].contains(elemento.questionId.toString())) {
                return elemento.questionText.toString();
              }
            }).toList();

            final filtrado = padre.where((e) => e != null).toList();

            campos.add(ReactiveValueListenableBuilder<String>(
              formControlName: filtrado[0],
              builder: (context, control, child) {
                if (respuestasPadre[0].contains(control.value.toString())) {
                  if (preguntasPadre.length >= 2) {
                    final padre2 = form.map((elemento) {
                      if (preguntasPadre[1]
                          .contains(elemento.questionId.toString())) {
                        return elemento.questionText.toString();
                      }
                    }).toList();

                    final filtrado2 = padre2.where((e) => e != null).toList();

                    return ReactiveValueListenableBuilder(
                      formControlName: filtrado2[0],
                      builder: (context, control, child) {
                        if (respuestasPadre[1]
                            .contains(control.value.toString())) {
                          return Column(
                            children: [
                              SOPhotoField(
                                campo: campo,
                              ),
                              espacio,
                            ],
                          );
                        }
                        return Container();
                      },
                    );
                  } else {
                    return Column(
                      children: [
                        SOPhotoField(
                          campo: campo,
                        ),
                        espacio,
                      ],
                    );
                  }

                  //campos.add(espacio);
                }
                return Container();
              },
            ));
          } else {
            campos.add(
              SOPhotoField(campo: campo),
            );
            campos.add(espacio);
          }
          break;
        default:
          {
            if (campo.conditional == 1) {
              final padre = form.map((elemento) {
                if (preguntasPadre[0]
                    .contains(elemento.questionId.toString())) {
                  return elemento.questionText.toString();
                }
              }).toList();

              final filtrado = padre.where((e) => e != null).toList();

              campos.add(ReactiveValueListenableBuilder<String>(
                formControlName: filtrado[0],
                builder: (context, control, child) {
                  if (respuestasPadre[0].contains(control.value.toString())) {
                    if (preguntasPadre.length >= 2) {
                      final padre2 = form.map((elemento) {
                        if (preguntasPadre[1]
                            .contains(elemento.questionId.toString())) {
                          return elemento.questionText.toString();
                        }
                      }).toList();

                      final filtrado2 = padre2.where((e) => e != null).toList();

                      return ReactiveValueListenableBuilder(
                        formControlName: filtrado2[0],
                        builder: (context, control, child) {
                          if (respuestasPadre[1]
                              .contains(control.value.toString())) {
                            return Column(
                              children: [
                                SOTextField(
                                  campo: campo,
                                ),
                                espacio,
                              ],
                            );
                          }
                          return Container();
                        },
                      );
                    } else {
                      return Column(
                        children: [
                          SOTextField(
                            campo: campo,
                          ),
                          espacio,
                        ],
                      );
                    }

                    //campos.add(espacio);
                  }
                  return Container();
                },
              ));
            } else {
              campos.add(
                SOTextField(campo: campo),
              );
              campos.add(espacio);
            }
          }
      }
    }

    return campos;
  }

  Future<void> guardarFormularios(
    OnCurrentFormsSaving event,
    Emitter<FormularioState> emit,
  ) async {
    add(
      const OnProcessingEvent(
        mensaje: "Procesando Formulario...",
        enviadoVisita: false,
        procesando: true,
      ),
    );

    UsuarioService _usuarioService = UsuarioService();

    final usuario = await _usuarioService.getInfoUsuario();
    final currentDate = DateTime.now();
    final formated = DateFormat('yyyyMMdd:HHmmss').format(currentDate);
    final dato2 = DateFormat('yyyyMMddHHmmss').format(currentDate);

    final instanceId = dato2 + usuario.usuario.toString();

    List<FormularioAnswer> respuestasAud = [];
    List<FormularioAnswer> respuestasAdi = [];

    if (event.formGroupAud != null) {
      respuestasAdi = await getRespuestas(
        estructura: event.currentFormAud!,
        frm: event.formGroupAud!,
        fechaCreacion: formated,
        instanceId: instanceId,
        usuario: usuario.usuario.toString(),
      );
    }

    if (event.formGroup != null) {
      respuestasAud = await getRespuestas(
        estructura: event.currentForm!,
        frm: event.formGroup!,
        fechaCreacion: formated,
        instanceId: instanceId,
        usuario: usuario.usuario.toString(),
      );
    }

    final guardado = await _dbService.guardarRespuestasFormulario(
      [
        ...respuestasAud,
        ...respuestasAdi,
      ],
    );

    List<FormularioResumen> formulariosAud = state.formulariosAud;
    List<FormularioResumen> formulariosAdi = state.formularios;

    formulariosAud = formulariosAud
        .map((e) => e.copyWith(
              guardado: guardado,
            ))
        .toList();
    formulariosAdi = formulariosAdi
        .map((e) => e.copyWith(
              guardado: guardado,
            ))
        .toList();

    add(OnUpdateFormsEvent(
      formularios: formulariosAdi,
      formulariosAud: formulariosAud,
    ));

    add(const OnUpdateProcessing(
      guardado: true,
      enviado: false,
    ));

    final datos = await _dbService.leerRespuestaFormulario();

    final enviado = await enviarDatosMasivo(
      datos,
    );

    if (enviado) {
      formulariosAud = formulariosAud
          .map((e) => e.copyWith(
                enviado: enviado,
              ))
          .toList();
      formulariosAdi = formulariosAdi
          .map((e) => e.copyWith(
                enviado: enviado,
              ))
          .toList();

      add(OnUpdateFormsEvent(
        formularios: formulariosAdi,
        formulariosAud: formulariosAud,
      ));
    }

    add(const OnUpdateProcessing(
      guardado: true,
      enviado: true,
      procesando: false,
    ));
  }

  Future<bool> enviarDatosMasivo(
    List<FormularioAnswer> respuestas,
  ) async {
    bool respuesta = false;

    add(
      const OnProcessingEvent(
        mensaje: "Enviando formulario...",
        enviadoVisita: false,
      ),
    );

    DBService db = DBService();

    List<Map<String, dynamic>> datos = [];

    for (var info in respuestas) {
      final data = {
        'appId': '500',
        'respondentId': info.respondentId,
        'formId': info.formId,
        'questionId': info.questionId,
        'response': info.response,
        'fechaCreacion': info.fechaCreacion,
      };

      datos.add(data);
    }

    try {
      final body = {
        "data": datos,
      };

      final resp = await http
          .post(
            Uri.parse('${Environment.apiURL}/appdms/newform_json'),
            body: jsonEncode(body),
            headers: {'Content-Type': 'application/json'},
            encoding: Encoding.getByName('utf-8'),
          )
          .timeout(const Duration(minutes: 5));

      if (resp.statusCode == 200) {
        add(
          const OnProcessingEvent(
            mensaje: "Actualizando despues de enviado.",
            enviadoVisita: true,
          ),
        );
        await db.updateEnviados(
          respuestas,
        );

        add(
          const OnProcessingEvent(
            mensaje: "Enviado exitosamente.",
            enviadoVisita: true,
          ),
        );

        respuesta = true;
      } else {
        add(
          const OnProcessingEvent(
            mensaje:
                "Ocurrió un error al enviar respuesta. La puedes sincronizar luego desde el menú principal.",
            enviadoVisita: false,
          ),
        );
      }
    } on TimeoutException catch (_) {
      add(
        const OnProcessingEvent(
          mensaje:
              "Ocurrió un error al enviar respuesta. La puedes sincronizar luego desde el menú principal.",
          enviadoVisita: false,
        ),
      );
    } catch (e) {
      add(
        const OnProcessingEvent(
          mensaje:
              "Ocurrió un error al enviar respuesta. La puedes sincronizar desde el menú principal.",
          enviadoVisita: false,
        ),
      );
    }

    return respuesta;
  }

  Future<List<FormularioAnswer>> getRespuestas(
      {required List<Formulario> estructura,
      required FormGroup frm,
      required String fechaCreacion,
      required String usuario,
      required String instanceId}) async {
    List<FormularioAnswer> respuestas = [];

    for (var campo in estructura) {
      FormularioAnswer resp = FormularioAnswer(
        instanceId: instanceId + campo.formId.toString(),
        formId: campo.formId,
        respondentId: usuario,
        fechaCreacion: fechaCreacion,
        questionId: campo.questionId,
        enviado: "NO",
      );

      switch (campo.questionType) {
        case 'Abierta Texto':
        case 'Abierta Numerica':
        case 'Seleccion Unica':
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

    return respuestas;
  }

  Future<void> enviarDatos(List<FormularioAnswer> respuestas) async {
    add(
      const OnProcessingEvent(
        mensaje: "Enviando formulario.",
        enviadoVisita: false,
      ),
    );
    DBService db = DBService();
    List<Map<String, dynamic>> datos = [];

    for (var info in respuestas) {
      final data = {
        'appId': '500',
        'respondentId': info.respondentId,
        'formId': info.formId,
        'questionId': info.questionId,
        'response': info.response,
        'fechaCreacion': info.fechaCreacion,
      };

      datos.add(data);
    }

    try {
      final body = {
        "data": datos,
      };

      final resp = await http
          .post(
            Uri.parse('${Environment.apiURL}/appdms/newform_json'),
            body: jsonEncode(body),
            headers: {'Content-Type': 'application/json'},
            encoding: Encoding.getByName('utf-8'),
          )
          .timeout(const Duration(minutes: 5));

      if (resp.statusCode == 200) {
        add(
          const OnProcessingEvent(
            mensaje: "Actualizando despues de enviado.",
            enviadoVisita: true,
          ),
        );

        await db.updateEnviados(
          respuestas,
        );

        add(
          const OnProcessingEvent(
            mensaje: "Enviado exitosamente",
            enviadoVisita: true,
          ),
        );
      } else {
        add(
          const OnProcessingEvent(
            mensaje:
                "Ocurrió un error al procesar respuesta. La puedes sincronizar luego desde el menú principal.",
            enviadoVisita: false,
          ),
        );
      }
    } on TimeoutException catch (_) {
      add(
        const OnProcessingEvent(
          mensaje:
              "Ocurrió un error al procesar respuesta. La puedes sincronizar luego desde el menú principal.",
          enviadoVisita: false,
        ),
      );
      return;
    } catch (e) {
      add(
        const OnProcessingEvent(
          mensaje:
              "Ocurrió un error al procesar respuesta. La puedes sincronizar luego desde el menú principal.",
          enviadoVisita: false,
        ),
      );
    }
  }
}
