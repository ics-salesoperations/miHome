import 'dart:async';
import 'dart:isolate';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:mihome_app/models/models.dart';
import 'package:mihome_app/services/db_service.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription<Position>? positionStream;
  final DBService _db = DBService();

  ReceivePort port = ReceivePort();

  LocationBloc() : super(LocationState()) {
    on<OnStartFollowingUser>(
      (event, emit) {
        emit(state.copyWith(
          followingUser: true,
        ));
      },
    );
    on<OnStopFollowingUser>((event, emit) {
      emit(state.copyWith(followingUser: false));
    });
    on<OnActualizarReporteTrackingEvent>((event, emit) {
      emit(
        state.copyWith(
          actualizandoTracking: event.actualizandoTracking,
          myLocationHistory: event.tracking,
        ),
      );
    });
    on<OnNewUserLocationEvent>((event, emit) {
      emit(
        state.copyWith(
          lastKnownLocation: event.newLocation,
        ),
      );
    });
  }

  Future<Position> getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition();
    return position;
  }

  Future actualizarReporteTracking({
    required DateTime start,
    required DateTime end,
  }) async {
    List<List<Tracking>> listTracking = [];

    add(
      const OnActualizarReporteTrackingEvent(
        actualizandoTracking: false,
        tracking: [],
      ),
    );

    final listTrackingResumen = await _db.leerTrackingResumen(
      start: start,
      end: end,
    );

    for (var id in listTrackingResumen) {
      final ruta =
          await _db.leerTracking(start: start, end: end, idTracking: id);

      listTracking.add(ruta);
    }

    add(
      OnActualizarReporteTrackingEvent(
        actualizandoTracking: false,
        tracking: listTracking,
      ),
    );
  }

  void startFollowingUser() async {
    add(OnStartFollowingUser());
    positionStream = Geolocator.getPositionStream().listen((event) {
      final position = event;
      add(
        OnNewUserLocationEvent(
          newLocation: LatLng(
            position.latitude,
            position.longitude,
          ),
        ),
      );
    });
  }

  void stopFollowingUser() {
    positionStream?.cancel();
    add(OnStopFollowingUser());
  }

  @override
  Future<void> close() {
    stopFollowingUser();
    return super.close();
  }
/*
  Future<void> _startLocator() async {
    Map<String, dynamic> data = {'countInit': 1};
    return await BackgroundLocator.registerLocationUpdate(
      LocationCallbackHandler.callback,
      initCallback: LocationCallbackHandler.initCallback,
      initDataCallback: data,
      disposeCallback: LocationCallbackHandler.disposeCallback,
      iosSettings: const IOSSettings(
        accuracy: ls.LocationAccuracy.NAVIGATION,
        distanceFilter: 0,
        stopWithTerminate: true,
      ),
      autoStop: false,
      androidSettings: const las.AndroidSettings(
        accuracy: ls.LocationAccuracy.NAVIGATION,
        interval: 15,
        distanceFilter: 0,
        client: las.LocationClient.google,
        androidNotificationSettings: las.AndroidNotificationSettings(
          notificationChannelName: 'Location tracking',
          notificationTitle: 'Start Location Tracking',
          notificationMsg: 'Track location in background',
          notificationBigMsg:
              'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
          notificationIconColor: Colors.grey,
          notificationTapCallback: LocationCallbackHandler.notificationCallback,
        ),
      ),
    );
  }*/

/*
  Future<void> initBackgroundTracking({
    required bool esBackground,
  }) async {
    final activado = await verificarTrackingActivado();

    if (IsolateNameServer.lookupPortByName(
            LocationServiceRepository.isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(
          LocationServiceRepository.isolateName);
    }

    IsolateNameServer.registerPortWithName(
      port.sendPort,
      LocationServiceRepository.isolateName,
    );

    port.listen(
      (dynamic data) async {
        print("::::ESCUCHANDO PUERTO:::::::");
        await updateUI(data);
      },
    );
    print("INICIALIZANDO");
    await BackgroundLocator.initialize();
    print("INICIALIZACION FINALIZADA");

    final _isRunning = await BackgroundLocator.isServiceRunning();

    print(":::::¿ESTA CORRIENDO INICIALMENTE?:::::::::::");
    print(_isRunning);

    final position = await getCurrentPosition();

    if (activado) {
      await actualizarDatosTracking(
        esBackground: esBackground,
        position: LatLng(position.latitude, position.longitude),
      );

      await enviarDatosTracking();
      final current = await _db.getCurrentTrackingHed();

      add(
        onStartFollowingUser(trackingStart: current.fechaInicio!),
      );
    }
  }

  Future<void> updateUI(LocationDto? data) async {
    await _updateNotificationText(data);
  }

  Future<void> _updateNotificationText(LocationDto? data) async {
    print("Actualizando notificacion");
    LatLng position;
    print(data.toString());
    if (data == null) {
      return;
    } else {
      position = LatLng(
        data.latitude,
        data.longitude,
      );
    }

    await actualizarDatosTracking(esBackground: true, position: position);

    await BackgroundLocator.updateNotificationText(
        title: "Localizacion: ",
        msg: "${DateTime.now()}",
        bigMsg: "Latitud: ${data.latitude}, Longitud: ${data.longitude}");
  }

  Future<TrackingDet> actualizarDatosTracking({
    required bool esBackground,
    required LatLng position,
  }) async {
    final fechaActual = DateTime.now();
    final current = await _db.getCurrentTrackingHed();

    TrackingDet tdet = TrackingDet(
      fecha: fechaActual,
      idTracking: current.idTracking,
      latitude: position.latitude,
      longitude: position.longitude,
    );

    await _db.addTrackingDet(tdet);

    add(
      onNewUserLocationEvent(
        newLocation: LatLng(position.latitude, position.longitude),
      ),
    );

    return tdet;
  }

  Future<bool> verificarTrackingActivado() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? actual = prefs.getBool('trackingActivado');
    if (actual == null) {
      return false;
    } else {
      return actual;
    }
  }

  Future<void> toggleTrackingActivado() async {
    final prefs = await SharedPreferences.getInstance();

    final bool? actual = prefs.getBool('trackingActivado');
    if (actual == null) {
      await prefs.setBool('trackingActivado', true);
    } else {
      await prefs.setBool('trackingActivado', !actual);
    }
  }

  Future<void> enviarDatosTracking() async {
    /*DBService db = DBService();

    final infoList = await db.getInformacion();

    final now = DateTime.now();
    for (var info in infoList) {
      if (info.fecha!.isBefore(now.subtract(const Duration(days: 3))) &&
          info.enviado!.toUpperCase() == 'SI') {
        db.deleteInformacion(info);
      } else if (info.enviado!.toUpperCase() == 'NO') {
        try {
          final data = {
            'brand': info.marca.toString(),
            'model': info.modelo.toString(),
            'capture_id': info.id_lectura.toString(),
            'phone_number': int.parse(info.telefono.toString()),
            'mobile_data': info.datos.toString(),
            'location': info.localizacion.toString(),
            'latitude': double.parse(info.latitud.toString()),
            'longitude': double.parse(info.longitud.toString()),
            'network_status': info.estadoRed.toString(),
            'network_type': info.tipoRed.toString(),
            'smarthpone_type': info.tipoTelefono.toString(),
            'is_roaming': info.esRoaming.toString(),
            'signal_level': info.nivelSignal.toString(),
            'db': int.parse(info.dB == 'null' ? '0' : info.dB!),
            'date': info.fecha!.toIso8601String(),
            'rsrp': int.parse(info.rsrp == 'null' ? '0' : info.rsrp!),
            'rsrq': int.parse(info.rsrq == 'null' ? '0' : info.rsrq!),
            'rssi': int.parse(info.rssi == 'null' ? '0' : info.rssi!),
            'rssi_asu':
                int.parse(info.rssi_asu == 'null' ? '0' : info.rssi_asu!),
            'rsrp_asu':
                int.parse(info.rsrp_asu == 'null' ? '0' : info.rsrp_asu!),
            'cqi': info.cqi ?? '0',
            'snr': int.parse(info.snr == 'null' ? '0' : info.snr!),
            'cid': info.cid ?? 'Unknown',
            'eci': info.eci ?? 'Unknown',
            'enb': info.enb ?? 'Unknown',
            'network_iso': info.network_iso ?? 'Unknown',
            'network_mcc': info.network_mcc ?? 'Unknown',
            'network_mnc': info.network_mnc ?? 'Unknown',
            'pci': info.pci == 'null' ? 'Unknown' : info.pci!,
            'cgi': info.cgi == 'null' ? 'Unknown' : info.cgi!,
            'ci': info.ci == 'null' ? 'Unknown' : info.ci,
            'lac': info.lac == 'null' ? 'Unknown' : info.lac,
            'psc': info.psc == 'null' ? 'Unknown' : info.psc,
            'rnc': info.rnc == 'null' ? 'Unknown' : info.rnc,
            'operator_name': info.operator_name ?? 'Unknown',
            'is_background': info.background,
          };

          final resp = await http
              .post(
                Uri.parse('${Environment.apiURL}/guardar'),
                body: jsonEncode(data),
                headers: {'Content-Type': 'application/json'},
                encoding: Encoding.getByName('utf-8'),
              )
              .timeout(const Duration(seconds: 15));

          if (resp.statusCode == 200) {
            await db.updateInformacion(info.copyWith(enviado: 'SI'));
          }
        } on TimeoutException catch (_) {
          return;
        } catch (e) {
          return;
        }
      }
    }*/
  }*/
}
