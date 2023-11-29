import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

import '../rally_point.dart';

part 'movements_event.dart';

part 'movements_state.dart';

class MovementsBloc extends Bloc<MovementsEvent, MovementsState> {
  MovementsBloc({this.settlementId = '654eaeb5693f198560bc1e5a',
    required this.movementsRepository})
      : super(const MovementsState()) {
    on<MovementsSubscriptionRequested>(_onSubscriptionRequested);
    on<MovementsFetchRequested>(_onMovementsFetchRequested);
  }

  final TroopMovementsRepository movementsRepository;
  final String settlementId;

  Future<void> _onSubscriptionRequested(MovementsSubscriptionRequested event,
      Emitter<MovementsState> emit,) async {
    if (state.status == MovementsStatus.initial) {
      movementsRepository.fetchMovements(settlementId);
      emit(state.copyWith(status: MovementsStatus.loading));
    }
    await emit.forEach<List<Movement>?>(
      movementsRepository.getMovements(),
      onData: (movements) {
        final movementsMap = _sortMovementsByLocation(movements!);
        return state.copyWith(
            movements: movementsMap, status: MovementsStatus.success);
      },
      onError: (_, __) =>
          state.copyWith(
            status: MovementsStatus.failure,
          ),
    );
  }

  Future<void> _onMovementsFetchRequested(MovementsFetchRequested event,
      Emitter<MovementsState> emit) async {
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
    for (var m in movements) {
      if(m.mission == Mission.home){
        result[MovementLocation.home]!.add(m);
      }else if(m.from.villageId == settlementId){
        result[MovementLocation.outgoing]!.add(m);
      }else if(m.to.villageId == settlementId && m.isMoving){
        result[MovementLocation.incoming]!.add(m);
      }else if(m.to.villageId == settlementId && !m.isMoving){
        result[MovementLocation.home]!.add(m);
      }
    }
    return result;
  }
}

