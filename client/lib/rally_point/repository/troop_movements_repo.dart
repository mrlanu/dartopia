import 'dart:convert';

import 'package:models/models.dart';
import 'package:network/network.dart';

abstract class TroopMovementsRepository {
  Future<void> sendTroops(SendTroopsRequest request, String fromSettlementId);

  Future<TroopsSendContract> fetchSendTroopsContract(
      {required TroopsSendContract contract, required String fromSettlementId});

  /*Stream<List<Movement>?> getMovements();

  Future<void> fetchMovements(String settlementId);*/

  Future<TileDetails> fetchTileDetails(
    int x,
    int y,
  );
}

class TroopMovementsRepositoryImpl implements TroopMovementsRepository {
  TroopMovementsRepositoryImpl({NetworkClient? networkClient})
      : _networkClient = networkClient ?? NetworkClient.instance;

  final NetworkClient _networkClient;

  /*final _movementsStreamController = BehaviorSubject<List<Movement>>.seeded([]);

  @override
  Stream<List<Movement>> getMovements() =>
      _movementsStreamController.asBroadcastStream();*/

  @override
  Future<TroopsSendContract> fetchSendTroopsContract(
      {required TroopsSendContract contract,
      required String fromSettlementId}) async {
    try {
      final response = await _networkClient.post<Map<String, dynamic>>(
          Api.sendTroopsContract(fromSettlementId),
          data: json.encode(contract));
      final confirmedContract = TroopsSendContract.fromJson(response.data!);
      return confirmedContract;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<void> sendTroops(
      SendTroopsRequest request, String fromSettlementId) async {
    try {
      await _networkClient.post(Api.sendTroops(fromSettlementId),
          data: json.encode(request));
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  /*@override
  Future<void> fetchMovements(String settlementId) async {
    final url = Uri.http(Api.baseURL, Api.fetchMovements(settlementId));
    final response =
        await http.get(url, headers: Api.headerAuthorization(token: _token));
    final movementsList = json.decode(response.body) as List<dynamic>;
    final movements = movementsList
        .map((e) => Movement.fromJson(e as Map<String, dynamic>))
        .toList();
    _movementsStreamController.add(movements);
  }*/

  @override
  Future<TileDetails> fetchTileDetails(
    int x,
    int y,
  ) async {
    final queryParameters = {
      'x': x.toString(),
      'y': y.toString(),
    };
    try {
      final response = await _networkClient.get<Map<String, dynamic>>(
          'settlement',
          queryParameters: queryParameters);
      return TileDetails.fromJson(response.data!);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }
}
