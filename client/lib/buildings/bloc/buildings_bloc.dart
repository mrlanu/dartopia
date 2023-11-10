import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

import '../../village/repository/settlement_repository.dart';

part 'buildings_event.dart';

part 'buildings_state.dart';

class BuildingsBloc extends Bloc<BuildingsEvent, BuildingsState> {
  BuildingsBloc(
      {this.settlementId = '654eaeb5693f198560bc1e5a',
      required SettlementRepository settlementRepository})
      : _villageRepository = settlementRepository,
        super(const BuildingsState()) {
    on<SettlementSubscriptionRequested>(_onSubscriptionRequested);
    on<BuildingIndexChanged>(_onVillageBuildingIndexChanged);
    on<BuildingUpgradeRequested>(_onBuildingUpgradeRequested);
  }

  final SettlementRepository _villageRepository;
  final String settlementId;

  Future<void> _onSubscriptionRequested(
    SettlementSubscriptionRequested event,
    Emitter<BuildingsState> emit,
  ) async {
    emit(state.copyWith(status: VillageStatus.loading));

    await emit.forEach<Settlement?>(
      _villageRepository.getSettlement(),
      onData: (settlement) {
        if (settlement != null) {
          return _settlementUpdated(settlement)
              .copyWith(status: VillageStatus.success, settlement: settlement);
        } else {
          _villageRepository.fetchSettlement(settlementId);
          return state.copyWith(status: VillageStatus.loading);
        }
      },
      onError: (_, __) => state.copyWith(
        status: VillageStatus.failure,
      ),
    );
  }

  Future<void> _onBuildingUpgradeRequested(
      BuildingUpgradeRequested event, Emitter<BuildingsState> emit) async {
    emit(state.copyWith(status: VillageStatus.loading));
    await _villageRepository.upgradeBuilding(
        settlementId: settlementId, request: event.request);
    emit(state.copyWith(status: VillageStatus.success));
  }

  Future<void> _onVillageBuildingIndexChanged(
      BuildingIndexChanged event, Emitter<BuildingsState> emit) async {
    emit(state.copyWith(buildingIndex: event.index));
  }

  BuildingsState _settlementUpdated(Settlement settlement) {
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
