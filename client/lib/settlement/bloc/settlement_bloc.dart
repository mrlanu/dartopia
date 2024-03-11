import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

import '../settlement.dart';

part 'settlement_event.dart';

part 'settlement_state.dart';

class SettlementBloc extends Bloc<SettlementEvent, SettlementState> {
  SettlementBloc({required SettlementRepository settlementRepository})
      : _villageRepository = settlementRepository,
        super(const SettlementState()) {
    on<ListOfSettlementsRequested>(_onListOfSettlementsRequested);
    on<SettlementSubscriptionRequested>(_onSubscriptionRequested);
    on<SettlementFetchRequested>(_onSettlementFetchRequested);
    on<BuildingIndexChanged>(_onVillageBuildingIndexChanged);
    on<BuildingUpgradeRequested>(_onBuildingUpgradeRequested);
  }


  final SettlementRepository _villageRepository;

  Future<void> _onListOfSettlementsRequested(
      ListOfSettlementsRequested event, Emitter<SettlementState> emit) async {
    final settlementList =
        await _villageRepository.fetchSettlementListByUserId();
    emit(state.copyWith(settlementList: settlementList));
    add(const SettlementSubscriptionRequested());
  }

  Future<void> _onSubscriptionRequested(
    SettlementSubscriptionRequested event,
    Emitter<SettlementState> emit,
  ) async {
    emit(state.copyWith(status: SettlementStatus.loading));

    await emit.forEach<Settlement?>(
      _villageRepository.getSettlement(),
      onData: (settlement) {
        if (settlement != null) {
          final movementsMap = _sortMovementsByLocation(settlement.movements);
          return state.copyWith(
              status: SettlementStatus.success,
              settlement: settlement,
              movementsByLocationMap: movementsMap);
        } else {
          _villageRepository
              .fetchSettlementById(state.settlementList[0].settlementId);
          return state.copyWith(status: SettlementStatus.loading);
        }
      },
      onError: (_, __) => state.copyWith(
        status: SettlementStatus.failure,
      ),
    );
  }

  Future<void> _onSettlementFetchRequested(
      SettlementFetchRequested event, Emitter<SettlementState> emi) async {
    await _villageRepository
        .fetchSettlementById(state.settlementList[0].settlementId);
  }

  Future<void> _onBuildingUpgradeRequested(
      BuildingUpgradeRequested event, Emitter<SettlementState> emit) async {
    await _villageRepository.upgradeBuilding(
        settlementId: state.settlementList[0].settlementId,
        request: event.request);
  }

  Future<void> _onVillageBuildingIndexChanged(
      BuildingIndexChanged event, Emitter<SettlementState> emit) async {
    emit(state.copyWith(buildingIndex: event.index));
  }

  Map<MovementLocation, List<Movement>> _sortMovementsByLocation(
      List<Movement> movements) {
    final result = <MovementLocation, List<Movement>>{
      MovementLocation.home: [],
      MovementLocation.incoming: [],
      MovementLocation.outgoing: [],
      MovementLocation.away: [],
    };
    if (movements.isNotEmpty) {
      final currentSettlementId =
          movements[movements.length - 1].from.villageId;
      for (var m in movements) {
        if (m.mission == Mission.home) {
          result[MovementLocation.home]!.add(m);
        } else if (m.from.villageId == currentSettlementId) {
          if (m.isMoving) {
            result[MovementLocation.outgoing]!.add(m);
          } else {
            result[MovementLocation.away]!.add(m);
          }
        } else if (m.to.villageId == currentSettlementId) {
          if (m.isMoving) {
            result[MovementLocation.incoming]!.add(m);
          } else {
            result[MovementLocation.home]!.add(m);
          }
        }
      }
    }
    return result;
  }
}
