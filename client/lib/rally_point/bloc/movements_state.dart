part of 'movements_bloc.dart';

enum MovementsStatus { initial, loading, success, failure }

enum MovementLocation {
  home, incoming, outgoing, away,
}

class MovementsState extends Equatable {
  const MovementsState(
      {this.status = MovementsStatus.initial,
      this.movements = const <MovementLocation, List<Movement>>{
        MovementLocation.home: [],
        MovementLocation.incoming: [],
        MovementLocation.outgoing: [],
        MovementLocation.away: [],
      }});

  final MovementsStatus status;
  final Map<MovementLocation, List<Movement>> movements;

  MovementsState copyWith({
    MovementsStatus? status,
    Map<MovementLocation, List<Movement>>? movements,
  }) {
    return MovementsState(
      status: status ?? this.status,
      movements: movements ?? this.movements,
    );
  }

  @override
  List<Object?> get props => [status, movements];
}
