part of 'settlement_bloc.dart';

enum SettlementStatus { loading, empty, success, failure }

class SettlementState extends Equatable {
  final List<ShortSettlementInfo> settlementList;
  final Settlement? settlement;
  final SettlementStatus status;
  final List<List<int>> buildingRecords;
  final int buildingIndex; // current index in buildings carousel

  const SettlementState(
      {this.status = SettlementStatus.loading,
      this.settlementList = const [],
      this.settlement,
      this.buildingRecords = const [],
      this.buildingIndex = 7});

  SettlementState copyWith(
      {SettlementStatus? status,
      List<ShortSettlementInfo>? settlementList,
      Settlement? settlement,
      List<double>? storage,
      List<List<int>>? buildingRecords,
      int? buildingIndex}) {
    return SettlementState(
        status: status ?? this.status,
        settlementList: settlementList ?? this.settlementList,
        settlement: settlement ?? this.settlement,
        buildingRecords: buildingRecords ?? this.buildingRecords,
        buildingIndex: buildingIndex ?? this.buildingIndex);
  }

  @override
  List<Object?> get props =>
      [status, settlementList, settlement, buildingIndex, buildingRecords];
}
