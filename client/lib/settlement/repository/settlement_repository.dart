import 'dart:convert';

import 'package:models/models.dart';
import 'package:network/network.dart';
import 'package:rxdart/rxdart.dart';

abstract class SettlementRepository {
  Stream<Settlement?> getSettlement();

  Future<void> fetchSettlementById(String settlementId);

  Future<void> upgradeBuilding(
      {required String settlementId, required ConstructionRequest request});

  Future<List<ShortSettlementInfo>> fetchSettlementListByUserId();

  Future<void> orderUnits(
      {required String settlementId, required int unitId, required int amount});
}

class SettlementRepositoryImpl implements SettlementRepository {
  SettlementRepositoryImpl({NetworkClient? networkClient})
      : _networkClient = networkClient ?? NetworkClient.instance;

  final NetworkClient _networkClient;

  final _settlementStreamController = BehaviorSubject<Settlement?>.seeded(null);

  @override
  Stream<Settlement?> getSettlement() =>
      _settlementStreamController.asBroadcastStream();

  @override
  Future<List<ShortSettlementInfo>> fetchSettlementListByUserId() async {
    try {
      final response = await _networkClient
          .get<List<dynamic>>(Api.fetchSettlementsInfoList());
      final result = response.data!
          .map((e) => ShortSettlementInfo.fromJson(e as Map<String, dynamic>))
          .toList();
      return result;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<void> fetchSettlementById(String settlementId) async {
    for (var i = 0; i <= 10; i++) {
      final response = await _networkClient
          .get<Map<String, dynamic>>(Api.fetchSettlementById(settlementId));
      if (response.statusCode != 200) {
        await Future<void>.delayed(const Duration(milliseconds: 200));
        continue;
      } else {
        final settlement = Settlement.fromJson(response.data!);
        _settlementStreamController.add(settlement);
        break;
      }
    }
  }

  @override
  Future<void> upgradeBuilding(
      {required String settlementId,
      required ConstructionRequest request}) async {
    try {
      final response = await _networkClient.post<Map<String, dynamic>>(
          Api.upgradeBuilding(settlementId),
          data: json.encode(request));
      final settlement = Settlement.fromJson(response.data!);
      _settlementStreamController.add(settlement);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<void> orderUnits(
      {required String settlementId,
      required int unitId,
      required int amount}) async {
    try {
      await _networkClient.post(Api.orderTroops(settlementId),
          data: OrderCombatUnitRequest(unitId: unitId, amount: amount).toMap());
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }
}
