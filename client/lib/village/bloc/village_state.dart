part of 'village_bloc.dart';

enum VillageStatus { loading, empty, success, failure }

class VillageState extends Equatable {
  final Settlement? settlement;
  final List<BuildingViewModel> buildingViewModelList;
  final VillageStatus status;

  const VillageState(
      {this.status = VillageStatus.loading,
      this.settlement,
      this.buildingViewModelList = const []});

  VillageState copyWith(
      {VillageStatus? status,
      Settlement? settlement,
      List<BuildingViewModel>? buildingViewModelList,
      List<double>? storage}) {
    return VillageState(
        status: status ?? this.status,
        settlement: settlement ?? this.settlement,
        buildingViewModelList: buildingViewModelList ?? this.buildingViewModelList,);
  }

  @override
  List<Object?> get props => [status, settlement];
}
