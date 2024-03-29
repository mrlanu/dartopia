part of 'settlement_bloc.dart';

enum SettlementStatus { loading, empty, success, failure }

class SettlementState extends Equatable {
  final List<ShortSettlementInfo> settlementList;
  final Settlement? settlement;
  final Map<MovementLocation, List<Movement>> movementsByLocationMap;
  final SettlementStatus status;
  final int buildingIndex; // current index in buildings carousel

  const SettlementState(
      {this.status = SettlementStatus.loading,
      this.settlementList = const [],
      this.settlement,
        this.movementsByLocationMap = const <MovementLocation, List<Movement>>{
          MovementLocation.home: [],
          MovementLocation.incoming: [],
          MovementLocation.outgoing: [],
          MovementLocation.away: [],
        },
      this.buildingIndex = 7});

  SettlementState copyWith(
      {SettlementStatus? status,
      List<ShortSettlementInfo>? settlementList,
      Settlement? settlement,
        Map<MovementLocation, List<Movement>>? movementsByLocationMap,
      int? buildingIndex}) {
    return SettlementState(
        status: status ?? this.status,
        settlementList: settlementList ?? this.settlementList,
        settlement: settlement ?? this.settlement,
        movementsByLocationMap: movementsByLocationMap ?? this.movementsByLocationMap,
        buildingIndex: buildingIndex ?? this.buildingIndex);
  }

  @override
  List<Object?> get props =>
      [status, settlementList, settlement, movementsByLocationMap, buildingIndex];
}
