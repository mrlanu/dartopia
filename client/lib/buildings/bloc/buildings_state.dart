part of 'buildings_bloc.dart';

enum VillageStatus { loading, empty, success, failure }

class BuildingsState extends Equatable {
  final Settlement? settlement;
  final VillageStatus status;
  final List<List<int>> buildingRecords;
  final int buildingIndex; // current index in buildings carousel

  const BuildingsState(
      {this.status = VillageStatus.loading,
      this.settlement,
      this.buildingRecords = const [],
      this.buildingIndex = 0});

  BuildingsState copyWith(
      {VillageStatus? status,
      Settlement? settlement,
      List<double>? storage,
      List<List<int>>? buildingRecords,
      int? buildingIndex}) {
    return BuildingsState(
        status: status ?? this.status,
        settlement: settlement ?? this.settlement,
        buildingRecords: buildingRecords ?? this.buildingRecords,
        buildingIndex: buildingIndex ?? this.buildingIndex);
  }

  @override
  List<Object?> get props => [status, settlement, buildingIndex];
}
