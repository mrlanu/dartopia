import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

import '../rally_point.dart';

part 'movements_event.dart';

part 'movements_state.dart';

class MovementsBloc extends Bloc<MovementsEvent, MovementsState> {
  MovementsBloc({required this.movementsRepository})
      : super(const MovementsState()) {
    on<MovementsSubscriptionRequested>(_onSubscriptionRequested);
    on<MovementsFetchRequested>(_onMovementsFetchRequested);
  }

  final TroopMovementsRepository movementsRepository;

  Future<void> _onSubscriptionRequested(
    MovementsSubscriptionRequested event,
    Emitter<MovementsState> emit,
  ) async {
    await emit.forEach<List<Movement>?>(
      movementsRepository.getMovements(),
      onData: (movements) {
        final movementsMap = _sortMovementsByLocation(movements!);
        return state.copyWith(
            movements: movementsMap, status: MovementsStatus.success);
      },
      onError: (_, __) => state.copyWith(
        status: MovementsStatus.failure,
      ),
    );
  }

  Future<void> _onMovementsFetchRequested(
      MovementsFetchRequested event, Emitter<MovementsState> emit) async {
    await movementsRepository.fetchMovements(event.settlementId);
  }

  Map<MovementLocation, List<Movement>> _sortMovementsByLocation(
      List<Movement> movements) {
    final result = <MovementLocation, List<Movement>>{
      MovementLocation.home: [],
      MovementLocation.incoming: [],
      MovementLocation.outgoing: [],
      MovementLocation.away: [],
    };
    if(movements.isNotEmpty){
      final currentSettlementId = movements[movements.length - 1].from.villageId;
      for (var m in movements) {
        if (m.mission == Mission.home) {
          result[MovementLocation.home]!.add(m);
        } else if (m.from.villageId == currentSettlementId) {
          if(m.isMoving){
            result[MovementLocation.outgoing]!.add(m);
          }else{
            result[MovementLocation.away]!.add(m);
          }
        } else if (m.to.villageId == currentSettlementId) {
          if(m.isMoving){
            result[MovementLocation.incoming]!.add(m);
          }else{
            result[MovementLocation.home]!.add(m);
          }
        }
      }
    }
    return result;
  }
}
