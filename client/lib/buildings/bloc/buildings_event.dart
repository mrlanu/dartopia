part of 'buildings_bloc.dart';

sealed class BuildingsEvent extends Equatable {
  const BuildingsEvent();
}

final class SettlementSubscriptionRequested extends BuildingsEvent {
  const SettlementSubscriptionRequested();

  @override
  List<Object?> get props => [];
}

final class BuildingUpgradeRequested extends BuildingsEvent {
  final ConstructionRequest request;

  const BuildingUpgradeRequested({required this.request});

  @override
  List<Object?> get props => [request];
}

final class BuildingIndexChanged extends BuildingsEvent {
  final int index;

  const BuildingIndexChanged({required this.index});

  @override
  List<Object?> get props => [index];
}


