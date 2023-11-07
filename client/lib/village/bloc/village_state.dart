part of 'village_bloc.dart';

enum VillageStatus { loading, empty, success, failure }

class VillageState extends Equatable {
  final Settlement? settlement;
  final VillageStatus status;
  final List<List<int>> buildingRecords;

  const VillageState(
      {this.status = VillageStatus.loading,
      this.settlement,
      this.buildingRecords = const []});

  VillageState copyWith(
      {VillageStatus? status,
      Settlement? settlement,
      List<double>? storage,
      List<List<int>>? buildingRecords}) {
    return VillageState(
        status: status ?? this.status,
        settlement: settlement ?? this.settlement,
        buildingRecords: buildingRecords ?? this.buildingRecords);
  }

  @override
  List<Object?> get props => [status, settlement];
}
