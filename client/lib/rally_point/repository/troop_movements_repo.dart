import 'dart:convert';

import 'package:models/models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import '../../../../../consts/api.dart';

abstract class TroopMovementsRepository {
  Future<void> sendTroops(SendTroopsRequest request, String fromSettlementId);
  Stream<List<Movement>?> getMovements();
  Future<void> fetchMovements(String settlementId);
  Future<TileDetails> fetchTileDetails(int x, int y,);
}

class TroopMovementsRepositoryImpl implements TroopMovementsRepository {
  final _movementsStreamController = BehaviorSubject<List<Movement>>.seeded([]);

  @override
  Stream<List<Movement>> getMovements() =>
      _movementsStreamController.asBroadcastStream();

  @override
  Future<void> sendTroops(SendTroopsRequest request, String fromSettlementId) async {
    final url = Uri.http(baseURL, 'settlement/$fromSettlementId/send_units');
    final response = await http.post(url, body: json.encode(request));
  }


  @override
  Future<void> fetchMovements(String settlementId) async {
    final url = Uri.http(baseURL, 'settlement/$settlementId/movements');
    final response = await http.get(url);
    final movementsList = json.decode(response.body) as List<dynamic>;
    final movements = movementsList
        .map((e) => Movement.fromJson(e as Map<String, dynamic>))
        .toList();
    _movementsStreamController.add(movements);
  }

  @override
  Future<TileDetails> fetchTileDetails(int x, int y,) async {
    final url = Uri.http(baseURL, 'settlement', {
      'x': x.toString(),
      'y': y.toString(),
    });
    final response = await http.get(url);
    final tileDetailMap = json.decode(response.body) as Map<String, dynamic>;
    return TileDetails.fromJson(tileDetailMap);
  }
}
