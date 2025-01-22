part of 'geo_search_bloc.dart';

class GeoSearchState extends Equatable {
  final List<Georreferencia> geo;
  final List<Georreferencia> selected;
  final List<Georreferencia> currentDep;
  final List<Georreferencia> historyGeo;
  final List<Georreferencia> historyNav;
  final bool actualizandoGeo;
  final bool actualizandoDep;
  final bool guardandoGeo;
  final bool enviandogeo;

  const GeoSearchState({
    this.geo = const [],
    this.historyGeo = const [],
    this.selected = const [],
    this.currentDep = const [],
    this.historyNav = const [],
    this.actualizandoGeo = false,
    this.actualizandoDep = false,
    this.guardandoGeo = false,
    this.enviandogeo = false,
  });

  GeoSearchState copyWith({
    List<Georreferencia>? geo,
    List<Georreferencia>? selected,
    List<Georreferencia>? currentDep,
    List<Georreferencia>? historyGeo,
    List<Georreferencia>? historyNav,
    bool? actualizandoGeo,
    bool? actualizandoDep,
    bool? guardandoGeo,
    bool? enviandogeo,
  }) =>
      GeoSearchState(
        geo: geo ?? this.geo,
        historyGeo: historyGeo ?? this.historyGeo,
        selected: selected ?? this.selected,
        currentDep: currentDep ?? this.currentDep,
        historyNav: historyNav ?? this.historyNav,
        actualizandoGeo: actualizandoGeo ?? this.actualizandoGeo,
        actualizandoDep: actualizandoDep ?? this.actualizandoDep,
        guardandoGeo: guardandoGeo ?? this.guardandoGeo,
        enviandogeo: enviandogeo ?? this.enviandogeo,
      );

  @override
  List<Object> get props => [
        geo,
        historyGeo,
        historyNav,
        currentDep,
        selected,
        actualizandoGeo,
        actualizandoDep,
        guardandoGeo,
        enviandogeo,
      ];
}
