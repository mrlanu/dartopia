part of 'village_bloc.dart';

enum VillageStatus { loading, empty, success, failure }

class VillageState extends Equatable {
  final VillageModel? villageModel;
  final List<double> storage;
  final List<BuildingModel> buildingList;
  final VillageStatus status;

  const VillageState(
      {this.status = VillageStatus.loading,
      this.villageModel,
      this.storage = const [0, 0, 0, 0],
      this.buildingList = const []});

  VillageState copyWith(
      {VillageStatus? status,
      VillageModel? villageModel,
      List<BuildingModel>? buildingList,
      List<double>? storage}) {
    return VillageState(
        status: status ?? this.status,
        villageModel: villageModel ?? this.villageModel,
        buildingList: buildingList ?? this.buildingList,
        storage: storage ?? this.storage);
  }

  @override
  List<Object?> get props => [status, villageModel, storage];
}
