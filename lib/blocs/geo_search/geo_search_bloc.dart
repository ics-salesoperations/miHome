import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:http/http.dart' as http;
import 'package:mihome_app/models/models.dart';
import 'package:mihome_app/services/services.dart';

import '../../global/environment.dart';

part 'geo_search_event.dart';
part 'geo_search_state.dart';

class GeoSearchBloc extends Bloc<GeoSearchEvent, GeoSearchState> {
  TrafficService? trafficService;
  DBService db = DBService();
  final AuthService _authService = AuthService();

  GeoSearchBloc() : super(const GeoSearchState()) {
    on<OnNewPlacesFoundEvent>((event, emit) {
      emit(
        state.copyWith(
          geo: event.geo,
        ),
      );
    });

    on<AddToHistoryEvent>((event, emit) {
      emit(
        state.copyWith(
          historyGeo: [
            event.geo,
            ...state.historyGeo,
          ],
        ),
      );
    });

    on<OnChangeNavHist>((event, emit) {
      emit(
        state.copyWith(
          historyNav: event.geo,
        ),
      );
    });

    on<OnSelectColilla>((event, emit) {
      emit(
        state.copyWith(
          selected: event.selected,
        ),
      );
    });

    on<OnActualizandoGeo>((event, emit) {
      emit(
        state.copyWith(
          actualizandoGeo: event.actualizandoGeo,
        ),
      );
    });

    on<OnActualizandoDep>((event, emit) {
      emit(
        state.copyWith(
          actualizandoDep: event.actualizandoDep,
          currentDep: event.dep,
        ),
      );
    });

    on<OnEnviarDatos>((event, emit) {
      emit(
        state.copyWith(
          guardandoGeo: event.guardandoGeo,
          enviandogeo: event.enviandoGeo,
        ),
      );
    });
  }

  Future<RouteDestination> getCoorsStartToEnd(LatLng start, LatLng end) async {
    final trafficResponce =
        await trafficService!.getCoorsStartToEnd(start, end);

    final endPlace = await trafficService!.getInformationByCoors(end);

    final geometry = trafficResponce.routes[0].geometry;
    final distance = trafficResponce.routes[0].distance;
    final duration = trafficResponce.routes[0].duration;

    //decodificar geometry
    final points = decodePolyline(geometry, accuracyExponent: 6);
    final latLngList = points
        .map((coor) => LatLng(coor[0].toDouble(), coor[1].toDouble()))
        .toList();

    return RouteDestination(
      points: latLngList,
      duration: duration,
      distance: distance,
      endPlace: endPlace,
    );
  }

  Future getGeosByQuery(String query) async {
    final nodos = await getGeos(query);
    add(
      OnNewPlacesFoundEvent(
        geo: nodos,
      ),
    );
  }

  Future<List<Georreferencia>> getGeos(String query) async {
    final geo = await db.filtrarGeo(filtro: query);
    return geo;
  }

  Future<void> getGeoDependencias({required Georreferencia geo}) async {
    add(
      const OnActualizandoDep(
        actualizandoDep: true,
        dep: [],
      ),
    );

    final dep = await db.filtrarGeoParent(filtro: geo.codigo.toString());
    add(
      OnActualizandoDep(
        actualizandoDep: false,
        dep: dep,
      ),
    );
  }

  Future<List<Georreferencia>> getNearestGeo({required String tipo}) async {
    final position = await Geolocator.getCurrentPosition();

    final geo = await db.filtrarGeoTipo(filtro: tipo);

    return geo
        .where(
          (geo) =>
              Geolocator.distanceBetween(
                position.latitude,
                position.longitude,
                geo.latitud ?? 0,
                geo.longitud ?? 0,
              ) <=
              3000,
        )
        .toList();
  }

  Future<void> procesarInfoGeo({
    required Georreferencia actualizacion,
    required GeorreferenciaLog detalleLog,
  }) async {
    add(
      const OnEnviarDatos(
        guardandoGeo: true,
        enviandoGeo: false,
      ),
    );
    await db.updateInformacionGeo(
      actualizacion,
    );

    await db.insertarLogGeo(
      detalleLog,
    );

    add(
      const OnEnviarDatos(
        guardandoGeo: false,
        enviandoGeo: true,
      ),
    );

    await enviarDatosGeo(detalleLog).timeout(
      const Duration(
        seconds: 35,
      ),
    );

    add(
      const OnEnviarDatos(
        guardandoGeo: false,
        enviandoGeo: false,
      ),
    );

/*
    add(
      OnNewPlacesFoundEvent(
        geo: [actualizacion],
      ),
    );*/

    add(
      const OnActualizandoGeo(
        actualizandoGeo: false,
      ),
    );
/*
    await getGeoDependencias(
      geo: actualizacion,
    );*/
  }

  Future<bool> enviarDatosGeo(GeorreferenciaLog log) async {
    DBService db = DBService();
    final token = await _authService.getToken();

    try {
      final data = {
        'codigo': log.codigo,
        'nombre': log.nombre,
        'latitud': log.latitud,
        'longitud': log.longitud,
        'tipo': log.tipo,
        'codigoPadre': log.codigoPadre,
        'foto': log.foto,
        'ingresadoPor': log.usuarioActualiza,
        'fechaEvento': log.fechaActualizacion!.toIso8601String(),
        'puerto': log.puerto ?? 0
      };

      final resp = await http
          .post(
            Uri.parse('${Environment.apiURL}/apphome/georeferencia'),
            body: jsonEncode(data),
            headers: {
              'Content-Type': 'application/json',
              'token': token,
            },
            encoding: Encoding.getByName('utf-8'),
          )
          .timeout(const Duration(seconds: 60));

      if (resp.statusCode == 200) {
        await db.updateGeoLog(
          log.copyWith(
            enviado: 1,
          ),
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> sincronizarDatos() async {
    DBService db = DBService();
    final token = await _authService.getToken();

    try {
      final pendientes = await db.leerGeoPendienteSync();

      for (var log in pendientes) {
        final data = {
          'codigo': log.codigo,
          'nombre': log.nombre,
          'latitud': log.latitud,
          'longitud': log.longitud,
          'tipo': log.tipo,
          'codigoPadre': log.codigoPadre,
          'foto': log.foto,
          'ingresadoPor': log.usuarioActualiza,
          'fechaEvento': log.fechaActualizacion!.toIso8601String(),
          'puerto': log.puerto ?? 0
          //'fecha': log.fechaActualizacion!.toIso8601String(),
        };

        final resp = await http
            .post(
              Uri.parse('${Environment.apiURL}/apphome/georeferencia'),
              body: jsonEncode(data),
              headers: {
                'Content-Type': 'application/json',
                'token': token,
              },
              encoding: Encoding.getByName('utf-8'),
            )
            .timeout(const Duration(seconds: 60));

        if (resp.statusCode == 200) {
          await db.updateGeoLog(
            log.copyWith(
              enviado: 1,
            ),
          );
        }
      }
    } catch (e) {
      null;
    }
  }

  Future<void> enviarDatosGeoDelete(GeorreferenciaLog geo) async {
    DBService db = DBService();
    final token = await _authService.getToken();
    try {
      final resp = await http
          .delete(
            Uri.parse(
              '${Environment.apiURL}/apphome/georeferencia/' +
                  geo.codigo.toString() +
                  '/' +
                  geo.tipo.toString() +
                  '/' +
                  geo.usuarioActualiza.toString(),
            ),
            headers: {
              'Content-Type': 'application/json',
              'token': token,
            },
            encoding: Encoding.getByName('utf-8'),
          )
          .timeout(const Duration(seconds: 60));

      if (resp.statusCode == 200) {
        await db.updateGeoLog(
          geo.copyWith(
            enviado: 1,
          ),
        );
      }
    } catch (e) {
      null;
    }
  }

  Future<Map<String, dynamic>> buscarCliente({
    required String cliente,
    bool esColilla = false,
  }) async {
    if (esColilla) {
      try {
        final token = await _authService.getToken();

        final resp = await http.get(
            Uri.parse('${Environment.apiURL}/apphome/cliente/' +
                cliente +
                "/COLILLA"),
            headers: {
              'Content-Type': 'application/json',
              'token': token,
            });

        if (resp.statusCode == 200) {
          final Map<String, dynamic> datos = jsonDecode(resp.body);

          return datos;
        } else if (resp.statusCode == 404) {
          return {
            'data': [
              {'Error': 'Cliente no encontrado'}
            ],
          };
        } else {
          return {
            'data': [
              {'Error': 'Ocurrió un error al buscar el cliente'}
            ],
          };
        }
      } catch (e) {
        return {
          'data': [
            {'Error': 'Ocurrió un error al buscar el cliente'}
          ],
        };
      }
    } else {
      try {
        final token = await _authService.getToken();

        final resp = await http.get(
            Uri.parse(
                '${Environment.apiURL}/apphome/cliente/' + cliente + "/CODIGO"),
            headers: {
              'Content-Type': 'application/json',
              'token': token,
              "Connection": "keep-alive"
            });

        if (resp.statusCode == 200) {
          final Map<String, dynamic> datos = jsonDecode(resp.body);

          return datos;
        } else if (resp.statusCode == 404) {
          final resp2 = await http.get(
              Uri.parse(
                  '${Environment.apiURL}/apphome/cliente/' + cliente + "/ID"),
              headers: {
                'Content-Type': 'application/json',
                'token': token,
                "Connection": "keep-alive"
              });

          if (resp2.statusCode == 200) {
            final Map<String, dynamic> datos = jsonDecode(resp2.body);

            return datos;
          } else if (resp2.statusCode == 404) {
            return {
              'data': [
                {'Error': 'Cliente no encontrado'}
              ],
            };
          }

          return {
            'data': [
              {'Error': 'Cliente no encontrado'}
            ],
          };
        } else {
          return {
            'data': [
              {'Error': 'Ocurrió un error al buscar el cliente'}
            ],
          };
        }
      } catch (e) {
        return {
          'data': [
            {'Error': 'Ocurrió un error al buscar el cliente'}
          ],
        };
      }
    }
  }
}
