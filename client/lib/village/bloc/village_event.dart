part of 'village_bloc.dart';

sealed class VillageEvent extends Equatable {
  const VillageEvent();
}

final class VillageUpdated extends VillageEvent {
  final Settlement settlement;

  const VillageUpdated({required this.settlement});

  @override
  List<Object?> get props => [settlement];
}

final class VillageFetchRequested extends VillageEvent {
  final String villageId;

  const VillageFetchRequested({required this.villageId});

  @override
  List<Object?> get props => [villageId];
}

final class BuildingUpgradeRequested extends VillageEvent {
  final ConstructionRequest request;

  const BuildingUpgradeRequested({required this.request});

  @override
  List<Object?> get props => [request];
}

final class VillageBuildingIndexChanged extends VillageEvent {
  final int index;

  const VillageBuildingIndexChanged({required this.index});

  @override
  List<Object?> get props => [index];
}


