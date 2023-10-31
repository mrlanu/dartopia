import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';

import '../../buildings/models/building_model.dart';
import '../../buildings/models/buildings_consts.dart';
import '../../buildings/repository/buildings_repository.dart';
import '../models/village_model.dart';

part 'village_event.dart';

part 'village_state.dart';

class VillageBloc extends Bloc<VillageEvent, VillageState> {
  VillageBloc() : super(const VillageState()) {
    on<VillageEvent>(_onEvent, transformer: sequential());
  }

  Future<void> _onEvent(VillageEvent event, Emitter<VillageState> emit) async {
    return switch (event) {
      final VillageFetchRequested e => _onVillageFetchRequested(e, emit),
    };
  }

  Future<void> _onVillageFetchRequested(
      VillageFetchRequested event, Emitter<VillageState> emit) async {
    emit(state.copyWith(status: VillageStatus.loading));
    await Future<void>.delayed(const Duration(seconds: 1));
    List<BuildingModelRepo> buildings = [
      BuildingModelRepo(id: BuildingId.MAIN, level: 3),
      BuildingModelRepo(id: BuildingId.BARRACKS, level: 1),
      BuildingModelRepo(id: BuildingId.EMPTY, level: 1),
      BuildingModelRepo(id: BuildingId.GRAIN_MILL, level: 1),
      BuildingModelRepo(id: BuildingId.GRANARY, level: 1),
    ];
    final village = VillageModel(
        id: event.villageId,
        name: 'My Village',
        buildings: buildings,
        storage: const [100, 100, 100, 100]);
    final buildingModelList = village.buildings
        .map((b) => buildingsMap[b.id]!.copyWith(level: b.level))
        .toList();
    emit(state.copyWith(
        status: VillageStatus.success,
        villageModel: village,
        storage: village.storage,
        buildingList: buildingModelList));
  }
}
