import 'dart:convert';

import 'package:models/models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

abstract class TroopMovementsRepository {
  Future<void> sendTroops(SendTroopsRequest request, String fromSettlementId);

  Future<TroopsSendContract> fetchSendTroopsContract(
      {required TroopsSendContract contract, required String fromSettlementId});

  Stream<List<Movement>?> getMovements();

  Future<void> fetchMovements(String settlementId);

  Future<TileDetails> fetchTileDetails(
    int x,
    int y,
  );
}

class TroopMovementsRepositoryImpl implements TroopMovementsRepository {
  TroopMovementsRepositoryImpl({required String token}) : _token = token;

  final String _token;

  final _movementsStreamController = BehaviorSubject<List<Movement>>.seeded([]);

  @override
  Stream<List<Movement>> getMovements() =>
      _movementsStreamController.asBroadcastStream();

  @override
  Future<TroopsSendContract> fetchSendTroopsContract(
      {required TroopsSendContract contract,
      required String fromSettlementId}) async {
    final url = Uri.http(Api.baseURL, Api.sendTroopsContract(fromSettlementId));
    final response = await http.post(url,
        body: json.encode(contract),
        headers: Api.headerAuthorization(token: _token));

    final map = json.decode(response.body) as Map<String, dynamic>;
    final confirmedContract = TroopsSendContract.fromJson(map);
    return confirmedContract;
  }

  @override
  Future<void> sendTroops(
      SendTroopsRequest request, String fromSettlementId) async {
    final url = Uri.http(Api.baseURL, Api.sendTroops(fromSettlementId));
    await http.post(url,
        body: json.encode(request),
        headers: Api.headerAuthorization(token: _token));
  }

  @override
  Future<void> fetchMovements(String settlementId) async {
    final url = Uri.http(Api.baseURL, Api.fetchMovements(settlementId));
    final response =
        await http.get(url, headers: Api.headerAuthorization(token: _token));
    final movementsList = json.decode(response.body) as List<dynamic>;
    final movements = movementsList
        .map((e) => Movement.fromJson(e as Map<String, dynamic>))
        .toList();
    _movementsStreamController.add(movements);
  }

  @override
  Future<TileDetails> fetchTileDetails(
    int x,
    int y,
  ) async {
    final url = Uri.http(Api.baseURL, 'settlement', {
      'x': x.toString(),
      'y': y.toString(),
    });
    final response =
        await http.get(url, headers: Api.headerAuthorization(token: _token));
    final tileDetailMap = json.decode(response.body) as Map<String, dynamic>;
    return TileDetails.fromJson(tileDetailMap);
  }
}
