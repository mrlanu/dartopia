part of 'buildings_bloc.dart';

sealed class BuildingsEvent extends Equatable {
  const BuildingsEvent();
}

final class VillageUpdated extends BuildingsEvent {
  final Settlement settlement;

  const VillageUpdated({required this.settlement});

  @override
  List<Object?> get props => [settlement];
}

final class VillageFetchRequested extends BuildingsEvent {
  final String villageId;

  const VillageFetchRequested({required this.villageId});

  @override
  List<Object?> get props => [villageId];
}

final class BuildingUpgradeRequested extends BuildingsEvent {
  final ConstructionRequest request;

  const BuildingUpgradeRequested({required this.request});

  @override
  List<Object?> get props => [request];
}

final class VillageBuildingIndexChanged extends BuildingsEvent {
  final int index;

  const VillageBuildingIndexChanged({required this.index});

  @override
  List<Object?> get props => [index];
}


