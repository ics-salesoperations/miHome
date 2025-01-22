part of 'geo_search_bloc.dart';

abstract class GeoSearchEvent extends Equatable {
  const GeoSearchEvent();

  @override
  List<Object> get props => [];
}

class OnActivateManualMarkerEvent extends GeoSearchEvent {}

class OnDeActivateManualMarkerEvent extends GeoSearchEvent {}

class OnNewPlacesFoundEvent extends GeoSearchEvent {
  final List<Georreferencia> geo;

  const OnNewPlacesFoundEvent({
    required this.geo,
  });
}

class AddToHistoryEvent extends GeoSearchEvent {
  final Georreferencia geo;

  const AddToHistoryEvent({
    required this.geo,
  });
}

class OnChangeNavHist extends GeoSearchEvent {
  final List<Georreferencia> geo;

  const OnChangeNavHist({
    required this.geo,
  });
}

class OnSelectColilla extends GeoSearchEvent {
  final List<Georreferencia> selected;

  const OnSelectColilla({
    required this.selected,
  });
}

class OnActualizandoGeo extends GeoSearchEvent {
  final bool actualizandoGeo;

  const OnActualizandoGeo({
    required this.actualizandoGeo,
  });
}

class OnActualizandoDep extends GeoSearchEvent {
  final bool actualizandoDep;
  final List<Georreferencia> dep;

  const OnActualizandoDep({
    required this.actualizandoDep,
    required this.dep,
  });
}

class OnEnviarDatos extends GeoSearchEvent {
  final bool guardandoGeo;
  final bool enviandoGeo;

  const OnEnviarDatos({
    required this.guardandoGeo,
    required this.enviandoGeo,
  });
}
