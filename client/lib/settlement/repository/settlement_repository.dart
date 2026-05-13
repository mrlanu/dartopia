import 'dart:convert';

import 'package:models/models.dart';
import 'package:network/network.dart';
import 'package:rxdart/rxdart.dart';

abstract class SettlementRepository {
  Stream<Settlement?> getSettlement();

  Future<void> fetchSettlementById(String settlementId);

  Future<void> upgradeBuilding(
      {required String settlementId, required ConstructionRequest request});

  Future<List<ShortSettlementInfo>> fetchAllSettlementList();

  Future<void> orderUnits(
      {required String settlementId, required int unitId, required int amount});

  Future<void> reorderBuildings(
      {required String settlementId, required List<List<int>> newBuildings});
}

class SettlementRepositoryImpl implements SettlementRepository {
  SettlementRepositoryImpl({NetworkClient? networkClient})
      : _networkClient = networkClient ?? NetworkClient.instance;

  final NetworkClient _networkClient;

  final _settlementStreamController = BehaviorSubject<Settlement?>.seeded(null);

  /// Server runs single-flight automation on this endpoint before returning; the
  /// HTTP thread may wait behind other players — allow a long receive timeout.
  static const Duration _settlementReceiveTimeout = Duration(seconds: 90);

  /// Rare 400 (still blocked) or 5xx; fewer rounds than the old async race workaround.
  static const int _settlementFetchMaxAttempts = 5;
  static const Duration _settlementRetryDelay = Duration(milliseconds: 400);

  @override
  Stream<Settlement?> getSettlement() =>
      _settlementStreamController.asBroadcastStream();

  @override
  Future<List<ShortSettlementInfo>> fetchAllSettlementList() async {
    try {
      final response = await _networkClient
          .get<List<dynamic>>(Api.fetchAllSettlementsList());
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
    for (var attempt = 0; attempt < _settlementFetchMaxAttempts; attempt++) {
      try {
        final response = await _networkClient.get<Map<String, dynamic>>(
          Api.fetchSettlementById(settlementId),
          receiveTimeout: _settlementReceiveTimeout,
        );
        if (response.statusCode == 200 && response.data != null) {
          _settlementStreamController.add(
            Settlement.fromJson(response.data!),
          );
          return;
        }
      } on DioException catch (_) {
        // Includes 5xx if validateStatus rejects, timeouts while automation runs, etc.
      }
      await Future<void>.delayed(_settlementRetryDelay);
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

  @override
  Future<void> reorderBuildings(
      {required String settlementId,
      required List<List<int>> newBuildings}) async {
    try {
      await _networkClient.post(Api.reorderBuildings(settlementId),
          data: json.encode(newBuildings));
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }
}
