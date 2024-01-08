part of 'settlement_bloc.dart';

sealed class SettlementEvent extends Equatable {
  const SettlementEvent();
}

final class ListOfSettlementsRequested extends SettlementEvent {
  const ListOfSettlementsRequested();

  @override
  List<Object?> get props => [];
}

final class SettlementSubscriptionRequested extends SettlementEvent {
  const SettlementSubscriptionRequested();

  @override
  List<Object?> get props => [];
}

final class SettlementFetchRequested extends SettlementEvent {
  const SettlementFetchRequested();

  @override
  List<Object?> get props => [];
}

final class BuildingUpgradeRequested extends SettlementEvent {
  final ConstructionRequest request;

  const BuildingUpgradeRequested({required this.request});

  @override
  List<Object?> get props => [request];
}

final class BuildingIndexChanged extends SettlementEvent {
  final int index;

  const BuildingIndexChanged({required this.index});

  @override
  List<Object?> get props => [index];
}


