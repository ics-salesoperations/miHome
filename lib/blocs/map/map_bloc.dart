import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mihome_app/app_styles.dart';
import 'package:mihome_app/blocs/blocs.dart';
import 'package:mihome_app/helpers/helpers.dart';
import 'package:mihome_app/models/models.dart';
import 'package:mihome_app/services/db_service.dart';
import 'package:mihome_app/themes/themes.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;
  final DBService _db = DBService();

  GoogleMapController? _mapController;
  BuildContext? _context;

  LatLng? mapCenter;

  StreamSubscription<LocationState>? locationStateSubscription;

  MapBloc({required this.locationBloc}) : super(const MapState()) {
    on<OnMapInitializedEvent>(_onInitMap);
    on<OnStartFollowingUserEvent>(_onStartFollowingUser);
    on<OnStopFollowingUserEvent>(
        (event, emit) => emit(state.copyWith(isFollowingUser: false)));
    on<OnUpdateOTsMap>((event, emit) {
      return emit(state.copyWith(
        ots: event.ots,
      ));
    });
    on<OnUpdateUserPolylinesEvent>(_onPolylineNewPoint);
    on<OnToggleUserRoute>(
        (event, emit) => emit(state.copyWith(showMyRoute: !state.showMyRoute)));
    on<OnToggleShowMarkers>((event, emit) {
      switch (event.tipo) {
        case 'NODO':
          emit(
            state.copyWith(
              showNodos: !state.showNodos,
            ),
          );
          break;
        case 'AMPLIFICADOR':
          emit(
            state.copyWith(
              showAmps: !state.showAmps,
            ),
          );
          break;
        case 'TAP':
          emit(
            state.copyWith(
              showTaps: !state.showTaps,
            ),
          );
          break;
        case 'CLIENTE':
          emit(
            state.copyWith(
              showClientes: !state.showClientes,
            ),
          );
          break;
        default:
          emit(
            state.copyWith(
              showMarkers: !state.showMarkers,
            ),
          );
      }
    });
    on<DisplayPolylinesEvent>((event, emit) {
      switch (event.tipo) {
        case 'NODO':
          emit(
            state.copyWith(
              polylines: event.polylines,
              markersNodos: event.markers,
              showNodos: true,
            ),
          );
          break;
        case 'AMPLIFICADOR':
          emit(
            state.copyWith(
              polylines: event.polylines,
              markersAmps: event.markers,
              showAmps: true,
            ),
          );
          break;
        case 'TAP':
          emit(
            state.copyWith(
              polylines: event.polylines,
              markersTaps: event.markers,
              showTaps: true,
            ),
          );
          break;
        case 'CLIENTE':
          emit(
            state.copyWith(
              polylines: event.polylines,
              markersClientes: event.markers,
              showClientes: true,
            ),
          );
          break;
        case 'SELECCION':
          emit(
            state.copyWith(
              polylines: event.polylines,
              markerSelect: event.markers,
            ),
          );
          break;
        default:
          emit(
            state.copyWith(
              polylines: event.polylines,
              markers: event.markers,
            ),
          );
      }
    });
  }

  void _onInitMap(OnMapInitializedEvent event, Emitter<MapState> emit) async {
    _mapController = event.controller;
    _context = event.context;
    _mapController!.setMapStyle(jsonEncode(uberMapTheme));
    await getPDVs();
    await drawMarkersOts(context: _context!);

    await drawGeoMarkers(context: _context!, tipo: 'NODO');
    emit(state.copyWith(isMapInitialized: true));
  }

  void _onStartFollowingUser(
      OnStartFollowingUserEvent event, Emitter<MapState> emit) {
    emit(state.copyWith(isFollowingUser: true));

    if (locationBloc.state.lastKnownLocation == null) return;

    moveCamera(locationBloc.state.lastKnownLocation!);
  }

  void _onPolylineNewPoint(
    OnUpdateUserPolylinesEvent event,
    Emitter<MapState> emit,
  ) async {
    int cantRow = 0;
    int orden = 0;
    final currentMarkers = <String, Marker>{};
    final currentPolylines = Map<String, Polyline>.from(state.polylines);

    for (var poly in locationBloc.state.myLocationHistory) {
      final puntos = poly.map((e) => LatLng(e.latitud!, e.longitud!)).toList();
      final myRoute = Polyline(
        polylineId: PolylineId(cantRow.toString()),
        color: markerColors[cantRow],
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        points: puntos,
      );

      currentPolylines[cantRow.toString()] = myRoute;

      //dibujando marcadores
      orden = 1;

      for (final detalle in poly) {
        final marker = await getTrackingMarker(orden);
        final newMarker = Marker(
          anchor: const Offset(0.1, 0.9),
          markerId:
              MarkerId(DateFormat('yyyyMMddHHmmss').format(detalle.fecha!)),
          position: LatLng(detalle.latitud!, detalle.longitud!),
          icon: marker,
          infoWindow: InfoWindow(
            title: DateFormat('dd/MM/yyyy HH:mm:ss').format(detalle.fecha!),
            anchor: const Offset(
              0.05,
              0.75,
            ),
          ),
        );
        currentMarkers[DateFormat('yyyyMMddHHmmss').format(
          detalle.fecha!,
        )] = newMarker;
        orden = orden + 1;
      }

      if (cantRow + 1 == 13) {
        cantRow = 0;
      } else {
        cantRow = cantRow + 1;
      }
    }

    emit(
      state.copyWith(
        polylines: currentPolylines,
        markers: currentMarkers,
      ),
    );
  }

  /*Dibujar Ruta */
  Future drawRoutePolyline(RouteDestination destination, Agenda detalle,
      BuildContext context) async {
    final myRoute = Polyline(
      polylineId: const PolylineId('route'),
      color: kPrimaryColor,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      points: destination.points,
    );

    double kms = destination.distance / 1000;
    kms = (kms * 100).floorToDouble(); //para redondear
    kms = kms / 100;

    int tripDuration = (destination.duration / 60).floorToDouble().toInt();

    //Custom markers
    //final _startMarker = await getAssetImageMarker();
    //final _endMarker = await getNetworkImageMarker();

    final _startMarker = await getStartCustomMarker(tripDuration, 'Inicio');
    final _endMarker =
        await getEndCustomMarker(kms.toInt(), detalle.nombreCliente!);

    final startMarker = Marker(
      anchor: const Offset(0.1, 0.9),
      markerId: const MarkerId('start'),
      position: destination.points.first,
      icon: _startMarker,
      /*infoWindow: InfoWindow(
        title: "Inicio",
        snippet: "Kms: $kms, duration: $tripDuration",
      ),*/
    );

    final endMarker = Marker(
      anchor: const Offset(0.1, 0.9),
      markerId: const MarkerId('end'),
      position: destination.points.last,
      icon: _endMarker,
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (builder) {
              return Container(
                height: 100,
                width: 100,
                color: Colors.blue,
              ) /*BottomMapModal(
                detalle: detalle,
                ctx: context,
              )*/
                  ;
            });
      },
    );

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['route'] = myRoute;

    final currentMarkers = Map<String, Marker>.from(state.markers);
    currentMarkers['start'] = startMarker;
    currentMarkers['end'] = endMarker;

    add(
      DisplayPolylinesEvent(
        polylines: currentPolylines,
        markers: currentMarkers,
        tipo: '',
      ),
    );

    //await Future.delayed(const Duration(milliseconds: 300));

    //_mapController?.showMarkerInfoWindow(const MarkerId('start'));
  }

  /*Fin Dibujar Ruta */

  /*Dibujar Marcadores */

  Future drawMarkersOts({required BuildContext context}) async {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    List<Agenda> ots = mapBloc.state.ots;

    final _startMarker = await getCustomColillaMarker(
      12,
      'Inicio',
      false,
    );

    final currentMarkers = <String, Marker>{};

    for (final detalle in ots) {
      final newMarker = Marker(
        anchor: const Offset(0.1, 0.9),
        markerId: MarkerId(detalle.ot.toString()),
        position: LatLng(detalle.latitud!, detalle.longitud!),
        icon: _startMarker,
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (builder) {
              return BottomMapModalCliente(
                detalle: detalle,
                ctx: context,
              );
            },
          );
        },
      );
      currentMarkers[detalle.ot.toString()] = newMarker;
    }

    final routeMarkers = Map<String, Marker>.from(state.markers);
    final startMarker = routeMarkers['start'];
    final endMarker = routeMarkers['end'];

    if (startMarker != null) {
      currentMarkers['start'] = startMarker;
      currentMarkers['end'] = endMarker!;
    }

    //final currentPolylines = Map<String, Polyline>.from(state.polylines);

    add(DisplayPolylinesEvent(
      polylines: const {},
      markers: currentMarkers,
      tipo: 'CLIENTE',
    ));

    //await Future.delayed(const Duration(milliseconds: 300));

    //_mapController?.showMarkerInfoWindow(const MarkerId('start'));
  }

  Future drawGeoMarkers({
    required BuildContext context,
    required String tipo,
  }) async {
    final geoSearchBloc = BlocProvider.of<GeoSearchBloc>(context);

    List<Georreferencia> _lista = await geoSearchBloc.getNearestGeo(
      tipo: tipo,
    );

    BitmapDescriptor _startMarker;

    switch (tipo) {
      case 'NODO':
        _startMarker = await getCustomNodoMarker(
          12,
          'Inicio',
          false,
        );
        break;
      case 'AMPLIFICADOR':
        _startMarker = await getCustomAmpMarker(
          12,
          'Inicio',
          false,
        );
        break;
      case 'TAP':
        _startMarker = await getCustomTapMarker(
          12,
          'Inicio',
          false,
        );
        break;
      case 'COLILLA':
        _startMarker = await getCustomColillaMarker(
          12,
          'Inicio',
          false,
        );
        break;
      default:
        _startMarker = await getCustomNodoMarker(
          12,
          'Inicio',
          false,
        );
    }

    final currentMarkers = <String, Marker>{};

    for (final detalle in _lista) {
      final newMarker = Marker(
        anchor: const Offset(0.1, 0.9),
        markerId: MarkerId(detalle.codigo.toString()),
        position: LatLng(detalle.latitud ?? 0, detalle.longitud ?? 0),
        icon: _startMarker,
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (builder) {
              return BottomMapModalGeo(
                detalle: detalle,
                ctx: context,
              );
            },
          );
        },
      );
      currentMarkers[detalle.codigo.toString()] = newMarker;
    }

    final routeMarkers = Map<String, Marker>.from(state.markers);
    final startMarker = routeMarkers['start'];
    final endMarker = routeMarkers['end'];

    if (startMarker != null) {
      currentMarkers['start'] = startMarker;
      currentMarkers['end'] = endMarker!;
    }

    //final currentPolylines = Map<String, Polyline>.from(state.polylines);

    add(DisplayPolylinesEvent(
      polylines: const {},
      markers: currentMarkers,
      tipo: tipo,
    ));

    //await Future.delayed(const Duration(milliseconds: 300));

    //_mapController?.showMarkerInfoWindow(const MarkerId('start'));
  }

  Future drawSelectedMarket({
    required BuildContext context,
    required Georreferencia datos,
  }) async {
    BitmapDescriptor _startMarker;

    switch (datos.tipo) {
      case 'NODO':
        _startMarker = await getCustomNodoMarker(12, 'Inicio', false);
        break;
      case 'TAP':
        _startMarker = await getCustomTapMarker(12, 'Inicio', false);
        break;
      default:
        _startMarker = await getCustomNodoMarker(12, 'Inicio', false);
    }

    final currentMarkers = <String, Marker>{};

    final newMarker = Marker(
      anchor: const Offset(0.1, 0.9),
      markerId: MarkerId(datos.codigo.toString()),
      position: LatLng(datos.latitud ?? 0, datos.longitud ?? 0),
      icon: _startMarker,
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (builder) {
            return BottomMapModalGeo(
              detalle: datos,
              ctx: context,
            );
          },
        );
      },
    );
    currentMarkers[datos.codigo.toString()] = newMarker;

    final currentPolylines = Map<String, Polyline>.from(state.polylines);

    add(DisplayPolylinesEvent(
      polylines: currentPolylines,
      markers: currentMarkers,
      tipo: 'SELECCION',
    ));

    //await Future.delayed(const Duration(milliseconds: 300));

    //_mapController?.showMarkerInfoWindow(const MarkerId('start'));
  }

  /*Fin Dibujar Marcadores*/

  /*Dibujar ARBOL */
  Future drawTreePolyline({
    required Georreferencia datos,
    required BuildContext context,
  }) async {
    final hijos = await DBService().filtrarGeoParent(
      filtro: datos.codigo.toString(),
    );

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    final currentMarkers = Map<String, Marker>.from(state.markers);

    currentPolylines.clear();

    //Dibujamos el Padre
    BitmapDescriptor _startMarker =
        await getMarcadorPorTipo(datos.tipo.toString());

    final newMarker = Marker(
      anchor: const Offset(0.1, 0.9),
      markerId: MarkerId(datos.codigo.toString()),
      position: LatLng(datos.latitud ?? 0, datos.longitud ?? 0),
      icon: _startMarker,
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (builder) {
            return BottomMapModalGeo(
              detalle: datos,
              ctx: context,
            );
          },
        );
      },
    );
    currentMarkers[datos.codigo.toString()] = newMarker;

    //Dibujamos hijos
    for (var h in hijos) {
      BitmapDescriptor _startMarker =
          await getMarcadorPorTipo(h.tipo.toString());

      final newMarker = Marker(
        anchor: const Offset(0.1, 0.9),
        markerId: MarkerId(h.codigo.toString()),
        position: LatLng(h.latitud ?? 0, h.longitud ?? 0),
        icon: _startMarker,
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (builder) {
              return BottomMapModalGeo(
                detalle: h,
                ctx: context,
              );
            },
          );
        },
      );
      currentMarkers[h.codigo.toString()] = newMarker;

      final myRoute = Polyline(
        polylineId: PolylineId(h.codigo.toString()),
        color: kPrimaryColor,
        width: 3,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        points: [
          LatLng(
            datos.latitud ?? 0,
            datos.longitud ?? 0,
          ),
          LatLng(
            h.latitud ?? 0,
            h.longitud ?? 0,
          ),
        ],
      );

      currentPolylines[h.codigo.toString()] = myRoute;

      //await Future.delayed(const Duration(milliseconds: 300));

      //_mapController?.showMarkerInfoWindow(const MarkerId('start'));
    }

    add(
      DisplayPolylinesEvent(
        polylines: currentPolylines,
        markers: currentMarkers,
        tipo: 'TAP',
      ),
    );
  }

  Future<BitmapDescriptor> getMarcadorPorTipo(String tipo) async {
    switch (tipo) {
      case 'NODO':
        return await getCustomNodoMarker(12, 'Inicio', false);
      case 'AMPLIFICADOR':
        return await getCustomAmpMarker(12, 'Inicio', false);
      case 'TAP':
        return await getCustomTapMarker(12, 'Inicio', false);
      case 'COLILLA':
        return await getCustomColillaMarker(12, 'Inicio', false);
      default:
        return await getCustomNodoMarker(12, 'Inicio', false);
    }
  }

  Future<void> getPDVs() async {
    final ots = await _db.leerAgendaOts(fecha: DateTime.now());

    add(OnUpdateOTsMap(ots));
  }

  /*Fin Dibujar ARBOL */

  void moveCamera(LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(
      cameraUpdate,
    );
  }

  @override
  Future<void> close() {
    locationStateSubscription?.cancel();
    _mapController?.dispose();
    return super.close();
  }
}
