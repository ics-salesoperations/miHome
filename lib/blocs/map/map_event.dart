part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class OnMapInitializedEvent extends MapEvent {
  final GoogleMapController controller;
  final BuildContext context;

  const OnMapInitializedEvent(this.controller, this.context);
}

class OnStartFollowingUserEvent extends MapEvent {}

class OnStopFollowingUserEvent extends MapEvent {}

class OnUpdateUserPolylinesEvent extends MapEvent {}

class OnToggleUserRoute extends MapEvent {}

class OnToggleShowMarkers extends MapEvent {
  final String tipo;
  const OnToggleShowMarkers({
    required this.tipo,
  });
}

class DisplayPolylinesEvent extends MapEvent {
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;
  final String tipo;

  const DisplayPolylinesEvent({
    required this.polylines,
    required this.markers,
    required this.tipo,
  });
}

class OnUpdateOTsMap extends MapEvent {
  final List<Agenda> ots;

  const OnUpdateOTsMap(this.ots);
}

class DisplayMarkersEvent extends MapEvent {
  final Map<String, Marker> markers;

  const DisplayMarkersEvent(this.markers);
}
