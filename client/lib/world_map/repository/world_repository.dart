import 'dart:convert';

import 'package:models/models.dart';
import 'package:http/http.dart' as http;

abstract class WorldRepository {
  Future<List<MapTile>> fetchPartOfWorld(
      int fromX, int toX, int fromY, int toY);

  Future<TileDetails> fetchTileDetails(int x, int y);
}

class WorldRepositoryImpl implements WorldRepository {
  WorldRepositoryImpl({required String token}) : _token = token;

  final String _token;

  @override
  Future<List<MapTile>> fetchPartOfWorld(
      int fromX, int toX, int fromY, int toY) async {
    final url = Uri.http(Api.baseURL, Api.fetchPartOfWorld(), {
      'fromX': fromX.toString(),
      'toX': toX.toString(),
      'fromY': fromY.toString(),
      'toY': toY.toString()
    });
    final response =
        await http.get(url, headers: Api.headerAuthorization(token: _token));
    final tilesList = json.decode(response.body) as List<dynamic>;
    final tiles = tilesList
        .map((e) => MapTile.fromJson(e as Map<String, dynamic>))
        .toList();
    return tiles;
  }

  @override
  Future<TileDetails> fetchTileDetails(
    int x,
    int y,
  ) async {
    final url = Uri.http(Api.baseURL, Api.fetchTileDetails(), {
      'x': x.toString(),
      'y': y.toString(),
    });
    final response =
        await http.get(url, headers: Api.headerAuthorization(token: _token));
    final tileDetailMap = json.decode(response.body) as Map<String, dynamic>;
    return TileDetails.fromJson(tileDetailMap);
  }
}
