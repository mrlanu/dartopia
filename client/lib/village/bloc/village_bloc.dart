import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:models/models.dart';

import '../../buildings/models/building_view_model.dart';
import '../../buildings/models/buildings_consts.dart';
import '../../consts/api.dart';

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

    final url = Uri.http(baseURL, '/settlement/6541b8ce582211d8f224e539');
    final response = await http.get(url);
    final map = json.decode(response.body) as Map<String, dynamic>;
    final settlement = Settlement.fromResponse(map);

    final buildingViewModelList = settlement.buildings.map((buildingRecord) {
      final specification = buildingSpecefication[BuildingId.values[buildingRecord.id]]!;
      final widget = buildingWidgetsMap[specification.id]!;
      final buildingView = BuildingViewModel(
          id: specification.id,
          name: specification.name,
          level: buildingRecord.level,
          description: specification.description,
          imagePath: specification.imagePath,
          cost: specification.cost,
          widget: widget);
      return buildingView;
    }).toList();
    emit(state.copyWith(
        status: VillageStatus.success,
        settlement: settlement,
        storage: settlement.storage,
        buildingViewModelList: buildingViewModelList));
  }
}
