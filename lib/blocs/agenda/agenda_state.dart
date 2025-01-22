part of 'agenda_bloc.dart';

class AgendaState extends Equatable {
  final List<Agenda> ots;
  final bool otsActualizadas;

  const AgendaState({
    this.ots = const [],
    this.otsActualizadas = false,
  });

  AgendaState copyWith({
    List<Agenda>? ots,
    bool? otsActualizadas,
  }) =>
      AgendaState(
        ots: ots ?? this.ots,
        otsActualizadas: otsActualizadas ?? this.otsActualizadas,
      );

  @override
  List<Object> get props => [
        ots,
        otsActualizadas,
      ];
}
