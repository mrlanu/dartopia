part of 'village_bloc.dart';

enum VillageStatus { loading, empty, success, failure }

class VillageState extends Equatable {
  final VillageModel? villageModel;
  final List<double> storage;
  final List<BuildingViewModel> buildingViewModelList;
  final VillageStatus status;

  const VillageState(
      {this.status = VillageStatus.loading,
      this.villageModel,
      this.storage = const [0, 0, 0, 0],
      this.buildingViewModelList = const []});

  VillageState copyWith(
      {VillageStatus? status,
      VillageModel? villageModel,
      List<BuildingViewModel>? buildingViewModelList,
      List<double>? storage}) {
    return VillageState(
        status: status ?? this.status,
        villageModel: villageModel ?? this.villageModel,
        buildingViewModelList: buildingViewModelList ?? this.buildingViewModelList,
        storage: storage ?? this.storage);
  }

  @override
  List<Object?> get props => [status, villageModel, storage];
}
