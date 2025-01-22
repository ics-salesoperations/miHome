part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool isMapInitialized;
  final bool isFollowingUser;
  final bool showMyRoute;
  final bool showMarkers;
  final bool showNodos;
  final bool showAmps;
  final bool showTaps;
  final bool showClientes;
  final List<Agenda> ots;

  //Polylines
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;
  final Map<String, Marker> markersNodos;
  final Map<String, Marker> markerSelect;
  final Map<String, Marker> markersAmps;
  final Map<String, Marker> markersTaps;
  final Map<String, Marker> markersClientes;

  const MapState({
    this.isMapInitialized = false,
    this.isFollowingUser = true,
    this.showMyRoute = true,
    this.showMarkers = false,
    this.showNodos = true,
    this.showAmps = false,
    this.showTaps = false,
    this.showClientes = false,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
    List<Agenda>? pdvs,
    Map<String, Marker>? markersNodos,
    Map<String, Marker>? markersAmps,
    Map<String, Marker>? markerSelect,
    Map<String, Marker>? markersTaps,
    Map<String, Marker>? markersClientes,
  })  : polylines = polylines ?? const {},
        ots = pdvs ?? const [],
        markers = markers ?? const {},
        markersNodos = markersNodos ?? const {},
        markersAmps = markersAmps ?? const {},
        markersTaps = markersTaps ?? const {},
        markerSelect = markerSelect ?? const {},
        markersClientes = markersClientes ?? const {};

  MapState copyWith({
    bool? isMapInitialized,
    bool? isFollowingUser,
    bool? showMyRoute,
    bool? showMarkers,
    bool? showNodos,
    bool? showAmps,
    bool? showTaps,
    bool? showClientes,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
    List<Agenda>? ots,
    Map<String, Marker>? markersNodos,
    Map<String, Marker>? markersAmps,
    Map<String, Marker>? markersTaps,
    Map<String, Marker>? markerSelect,
    Map<String, Marker>? markersClientes,
  }) =>
      MapState(
        isMapInitialized: isMapInitialized ?? this.isMapInitialized,
        isFollowingUser: isFollowingUser ?? this.isFollowingUser,
        showMyRoute: showMyRoute ?? this.showMyRoute,
        showMarkers: showMarkers ?? this.showMarkers,
        showNodos: showNodos ?? this.showNodos,
        showAmps: showAmps ?? this.showAmps,
        showTaps: showTaps ?? this.showTaps,
        showClientes: showClientes ?? this.showClientes,
        polylines: polylines ?? this.polylines,
        markers: markers ?? this.markers,
        pdvs: ots ?? this.ots,
        markersNodos: markersNodos ?? this.markersNodos,
        markerSelect: markerSelect ?? this.markerSelect,
        markersAmps: markersAmps ?? this.markersAmps,
        markersTaps: markersTaps ?? this.markersTaps,
        markersClientes: markersClientes ?? this.markersClientes,
      );

  @override
  List<Object> get props => [
        isMapInitialized,
        isFollowingUser,
        polylines,
        showMyRoute,
        showMarkers,
        showNodos,
        showAmps,
        showTaps,
        showClientes,
        markers,
        markersNodos,
        markersAmps,
        markersTaps,
        markerSelect,
        markersClientes,
        ots,
      ];
}
