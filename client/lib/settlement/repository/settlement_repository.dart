import 'dart:convert';

import 'package:models/models.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../../consts/api.dart';

abstract class SettlementRepository {
  Stream<Settlement?> getSettlement();

  Future<void> fetchSettlement(String settlementId);

  Future<void> upgradeBuilding(
      {required String settlementId, required ConstructionRequest request});

  Future<List<ShortSettlementInfo>> fetchSettlementListByUserId(
      {required String userId});
}

class SettlementRepositoryImpl implements SettlementRepository {
  final _settlementStreamController = BehaviorSubject<Settlement?>.seeded(null);

  @override
  Stream<Settlement?> getSettlement() =>
      _settlementStreamController.asBroadcastStream();

  @override
  Future<List<ShortSettlementInfo>> fetchSettlementListByUserId(
      {required String userId}) async {
    final url = Uri.http(baseURL, '/users/$userId/settlements');
    final response = await http.get(url);
    final responseList = json.decode(response.body) as List<dynamic>;
    final result = responseList
        .map((e) => ShortSettlementInfo.fromJson(e as Map<String, dynamic>)).toList();
    return result;
  }

  @override
  Future<void> fetchSettlement(String settlementId) async {
    final url = Uri.http(baseURL, '/settlement/$settlementId');
    final response = await http.get(url);
    final map = json.decode(response.body) as Map<String, dynamic>;
    final settlement = Settlement.fromJson(map);
    _settlementStreamController.add(settlement);
  }

  @override
  Future<void> upgradeBuilding(
      {required String settlementId,
      required ConstructionRequest request}) async {
    final url = Uri.http(baseURL, '/settlement/$settlementId/construction');
    final response = await http.post(url, body: json.encode(request));
    final map = json.decode(response.body) as Map<String, dynamic>;
    final settlement = Settlement.fromJson(map);
    _settlementStreamController.add(settlement);
  }
}
