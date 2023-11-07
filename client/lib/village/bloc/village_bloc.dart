import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:models/models.dart';
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

    final url = Uri.http(baseURL, '/settlement/654a6251f8cab210a84af452');
    final response = await http.get(url);
    final map = json.decode(response.body) as Map<String, dynamic>;
    final settlement = Settlement.fromResponse(map);

    final buildingRecords = <List<int>>[[0, 0, 0],[1, 1, 0],[2, 2, 0],[3, 3, 0]];

    final buildingsExceptFields = settlement.buildings
        .where((bR) => bR[1] != 0 && bR[1] != 1 && bR[1] != 2 && bR[1] != 3)
        .toList();

    buildingRecords.addAll(buildingsExceptFields);

    emit(state.copyWith(
        status: VillageStatus.success,
        settlement: settlement,
        storage: settlement.storage,
        buildingRecords: buildingRecords));
  }
}
