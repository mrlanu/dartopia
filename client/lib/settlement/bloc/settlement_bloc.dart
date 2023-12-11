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
    final settlementList = await _villageRepository.fetchSettlementListByUserId(userId: event.userId);
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
          return _settlementUpdated(settlement).copyWith(
              status: SettlementStatus.success, settlement: settlement);
        } else {
          _villageRepository.fetchSettlement(state.settlementList[0].settlementId);
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
    await _villageRepository.fetchSettlement(state.settlementList[0].settlementId);
  }

  Future<void> _onBuildingUpgradeRequested(
      BuildingUpgradeRequested event, Emitter<SettlementState> emit) async {
    await _villageRepository.upgradeBuilding(
        settlementId: state.settlementList[0].settlementId, request: event.request);
  }

  Future<void> _onVillageBuildingIndexChanged(
      BuildingIndexChanged event, Emitter<SettlementState> emit) async {
    emit(state.copyWith(buildingIndex: event.index));
  }

  SettlementState _settlementUpdated(Settlement settlement) {
    final buildingRecords = <List<int>>[
      [0, 0, 0],
      [1, 1, 0],
      [2, 2, 0],
      [3, 3, 0]
    ];

    final buildingsExceptFields = settlement.buildings
        .where((bR) => bR[1] != 0 && bR[1] != 1 && bR[1] != 2 && bR[1] != 3)
        .toList();

    buildingRecords.addAll(buildingsExceptFields);

    return state.copyWith(
        storage: settlement.storage, buildingRecords: buildingRecords);
  }
}
