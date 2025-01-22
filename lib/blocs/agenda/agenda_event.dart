part of 'agenda_bloc.dart';

abstract class AgendaEvent extends Equatable {
  const AgendaEvent();

  @override
  List<Object> get props => [];
}

class OnCargarOtsAgendaEvent extends AgendaEvent {
  final List<Agenda> ots;
  final bool otsActualizadas;

  const OnCargarOtsAgendaEvent({
    required this.ots,
    required this.otsActualizadas,
  });
}
